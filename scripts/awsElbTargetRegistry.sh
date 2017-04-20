#!/bin/sh
#
#
#

DIST_targetGroupRegion=us-east-1
DIST_awsAccount=280770932422
DIST_targetGroupName="testtg01/f3b683d6638d8c2c"
DIST_targetPort=8080

targetGroupArn=arn:aws:elasticloadbalancing:${DIST_targetGroupRegion}:${DIST_awsAccount}:targetgroup/${DIST_targetGroupName}
target=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
port=$DIST_targetPort
cmdOptions="--target-group-arn ${targetGroupArn} --targets Id=${target},Port=${port}"


function registerTarget(){
	aws elbv2 register-targets ${cmdOptions}
}

function deregisterTarget(){
	aws elbv2 deregister-targets ${cmdOptions}
}

function getTargetStage(){
	targetState=$(aws elbv2 describe-target-health ${cmdOptions}|jq '.TargetHealthDescriptions[0].TargetHealth.State')
}


getTargetStage
echo $targetState
