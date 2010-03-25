Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab0CYFSE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 01:18:04 -0400
Received: from mail.perches.com ([173.55.12.10]:1108 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544Ab0CYFRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 01:17:35 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Subject: [PATCH 12/13] drivers/staging/vt6656: Hoist assign from if
Date: Wed, 24 Mar 2010 22:17:06 -0700
Message-Id: <240e36e730594a738eaeb0144c80051f585cda7a.1269493047.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.14.g7e948
In-Reply-To: <cover.1269493047.git.joe@perches.com>
References: <cover.1269493047.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/vt6656/main_usb.c |   12 ++++++++----
 drivers/staging/vt6656/usbpipe.c  |   21 ++++++++++++++-------
 2 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index a8e1adb..f15e7b4 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1434,7 +1434,8 @@ static int Config_FileGetParameter(UCHAR *string, UCHAR *dest,UCHAR *source)
     source+=strlen(buf1);
 
 //find target string start point
-    if((start_p = kstrstr(source,buf1))==NULL)
+    start_p = kstrstr(source,buf1);
+    if (start_p == NULL)
 	return FALSE;
 
 //check if current config line is marked by "#" ??
@@ -1446,7 +1447,8 @@ for(ii=1;;ii++) {
 }
 
 //find target string end point
-     if((end_p = kstrstr(start_p,"\n"))==NULL) {       //cann't find "\n",but don't care
+     end_p = kstrstr(start_p,"\n");
+     if (end_p == NULL) {       //can't find "\n",but don't care
           end_p=start_p+strlen(start_p);   //no include "\n"
        }
 
@@ -1455,7 +1457,8 @@ for(ii=1;;ii++) {
    buf2[end_p-start_p]='\0';
 
    //find value
-   if((start_p = kstrstr(buf2,"="))==NULL)
+   start_p = kstrstr(buf2,"=");
+   if (start_p == NULL)
       return FALSE;
    memset(buf1,0,100);
    strcpy(buf1,start_p+1);
@@ -1548,7 +1551,8 @@ static int Read_config_file(PSDevice pDevice) {
  pDevice->config_file.eAuthenMode = -1;
  pDevice->config_file.eEncryptionStatus = -1;
 
-  if((buffer=Config_FileOperation(pDevice)) ==NULL) {
+  buffer = Config_FileOperation(pDevice);
+  if (buffer == NULL) {
      result =-1;
      return result;
   }
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 65e91a3..df874ff 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -193,7 +193,8 @@ PIPEnsControlOut(
 			 usb_sndctrlpipe(pDevice->usb , 0), (char *) &pDevice->sUsbCtlRequest,
 			 pbyBuffer, wLength, s_nsControlInUsbIoCompleteWrite, pDevice);
 
-	if ((ntStatus = usb_submit_urb(pDevice->pControlURB, GFP_ATOMIC)) != 0) {
+	ntStatus = usb_submit_urb(pDevice->pControlURB, GFP_ATOMIC);
+	if (ntStatus != 0) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"control send request submission failed: %d\n", ntStatus);
 		return STATUS_FAILURE;
 	}
@@ -251,7 +252,8 @@ PIPEnsControlIn(
 			 usb_rcvctrlpipe(pDevice->usb , 0), (char *) &pDevice->sUsbCtlRequest,
 			 pbyBuffer, wLength, s_nsControlInUsbIoCompleteRead, pDevice);
 
-	if ((ntStatus = usb_submit_urb(pDevice->pControlURB, GFP_ATOMIC)) != 0) {
+	ntStatus = usb_submit_urb(pDevice->pControlURB, GFP_ATOMIC);
+	if (ntStatus != 0) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"control request submission failed: %d\n", ntStatus);
 	}else {
 		MP_SET_FLAG(pDevice, fMP_CONTROL_READS);
@@ -414,7 +416,8 @@ usb_fill_bulk_urb(pDevice->pInterruptURB,
 #endif
 #endif
 
-	if ((ntStatus = usb_submit_urb(pDevice->pInterruptURB, GFP_ATOMIC)) != 0) {
+	ntStatus = usb_submit_urb(pDevice->pInterruptURB, GFP_ATOMIC);
+	if (ntStatus != 0) {
 	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Submit int URB failed %d\n", ntStatus);
     }
 
@@ -494,7 +497,8 @@ s_nsInterruptUsbIoCompleteRead(
 
     if (pDevice->fKillEventPollingThread != TRUE) {
    #if 0               //reserve int URB submit
-	if ((ntStatus = usb_submit_urb(urb, GFP_ATOMIC)) != 0) {
+	ntStatus = usb_submit_urb(urb, GFP_ATOMIC);
+	if (ntStatus != 0) {
 	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Re-Submit int URB failed %d\n", ntStatus);
     }
    #else                                                                                     //replace int URB submit by bulk transfer
@@ -507,7 +511,8 @@ s_nsInterruptUsbIoCompleteRead(
 		     s_nsInterruptUsbIoCompleteRead,
 		     pDevice);
 
-	if ((ntStatus = usb_submit_urb(pDevice->pInterruptURB, GFP_ATOMIC)) != 0) {
+	ntStatus = usb_submit_urb(pDevice->pInterruptURB, GFP_ATOMIC);
+	if (ntStatus != 0) {
 	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Submit int URB failed %d\n", ntStatus);
            }
 
@@ -572,7 +577,8 @@ PIPEnsBulkInUsbRead(
 		s_nsBulkInUsbIoCompleteRead,
 		pRCB);
 
-	if((ntStatus = usb_submit_urb(pUrb, GFP_ATOMIC)) != 0){
+	ntStatus = usb_submit_urb(pUrb, GFP_ATOMIC);
+	if (ntStatus != 0) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Submit Rx URB failed %d\n", ntStatus);
 		return STATUS_FAILURE ;
 	}
@@ -718,7 +724,8 @@ PIPEnsSendBulkOut(
         		s_nsBulkOutIoCompleteWrite,
         		pContext);
 
-    	if((status = usb_submit_urb(pUrb, GFP_ATOMIC))!=0)
+    	status = usb_submit_urb(pUrb, GFP_ATOMIC);
+    	if (status!=0)
     	{
     		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Submit Tx URB failed %d\n", status);
     		return STATUS_FAILURE;
-- 
1.7.0.14.g7e948

