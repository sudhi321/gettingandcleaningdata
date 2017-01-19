library(reshape2)
library(dplyr)

## working folder -file  setting
##setwd(paste(getwd(),"gcd_week4_peer_run1",sep= "/"))
zipfilename <- "projectfile.zip"
floc<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if (!file.exists(zipfilename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(floc, zipfilename)
}

##Unzip
if (!file.exists("UCI HAR Dataset")) { 
  unzip(zipfilename) 
}

## start importing
features<- read.table("UCI HAR Dataset/features.txt", header = FALSE)
Y_train<- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
X_train<- read.table("UCI HAR Dataset/train/x_train.txt", header = FALSE)
y_test<- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
X_test<- read.table("UCI HAR Dataset/test/x_test.txt", header = FALSE)
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
x_trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
x_testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")

## Take only mean and standard deviation data and clean () and format
featuresWanted <- grep(".*mean.*|.*std.*", features[,2])
featuresWanted.names <- features[featuresWanted,2]
featuresWanted.names = gsub('-mean', 'Mean', featuresWanted.names)
featuresWanted.names = gsub('-std', 'Std', featuresWanted.names)
featuresWanted.names <- gsub('[-()]', '', featuresWanted.names)

##selecting the required data
X_train_wanted<- select(X_train,featuresWanted)
X_test_wanted<- select(X_test,featuresWanted)

## combining data
test_processed <- cbind(x_testSubjects,y_test, X_test)
train_processed <- cbind(x_trainSubjects,Y_train, X_train)
X_All<- rbind(train_processed,test_processed)

#Giving columns names to the table
colnames(X_All)<- c("Subject","activity",featuresWanted.names)

##Converting Activity and subject code to valyes
X_All$activity<- factor(X_All$activity, levels = activityLabels[,1], labels = activityLabels[,2])
X_All$subject <- as.factor(X_All$Subject)
X_all.melted<- melt(X_All,id=c("Subject","activity"))


