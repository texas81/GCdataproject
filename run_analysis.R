#library 
library(data.table)

# Getting and Cleaning data assigment
# Tamas Kenesei/texas81/tamas.kenesei@gmail.com
# Good morning Dave!!
#0. initialization - load what you can 
features <- read.table("./data/features.txt")
activity <- read.table("./data/activity_labels.txt")

# 1. step: load the train and test data sources and merge them
X_train <- read.table("./data/train/X_train.txt")
y_train <- read.table("./data/train/y_train.txt")
subject_train <- read.table("./data/train/subject_train.txt")
X_test <- read.table("./data/test/X_test.txt")
y_test <- read.table("./data/test/y_test.txt")
subject_test <- read.table("./data/test/subject_test.txt")
X <- rbind(X_train,X_test)
y <- rbind(y_train,y_test)
subject <- rbind(subject_train,subject_test)


#2. step extract the measurements mean and std
whereIsStdMean <- grep("mean\\(\\)|std\\(\\)", features[, 2])
dataSetE <- X[,whereIsStdMean]
# 4. Appropriately labels the data set with descriptive activity names
names(dataSetE) <- (features[whereIsStdMean,2])
dataSetEb <- cbind(subject,y,dataSetE)
colnames(dataSetEb)[2] <- "activity"
colnames(dataSetEb)[1] <- "subject"
names(dataSetEb) <-  gsub("\\(\\)", "",colnames(dataSetEb))

#3.  Uses descriptive activity names to name the activities in the data set
dataSetEb$activity <- activity[dataSetEb$activity,2]
#write out full_data.txt
write.table(dataSetEb, "full_data.txt")
#just a small counter check
fd <- read.table("full_data.txt")
View(fd)
#5. From the data set in step 4, creates a second, independent tidy data set with the average 
#of each variable for each activity and each subject.
performMean <- data.table(dataSetEb)
meanDataSet<-performMean[,lapply(.SD,mean),by="subject,activity"]
write.table(meanDataSet,"mean_data.txt",row.names = FALSE)
#counter check here as well
md <- read.table("mean_data.txt")
View(md)
