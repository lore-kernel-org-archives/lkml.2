Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab1LAC05 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 21:26:57 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34154 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab1LAC04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 21:26:56 -0500
From: Marcos Paulo de Souza <marcos.mage@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.mage@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Forest Bond <forest@alittletooquiet.net>, devel@driverdev.osuosl.org
Subject: [PATCH 2/4] staging: vt6656: control.c: Remove dead code
Date: Thu,  1 Dec 2011 00:26:34 +0000
Message-Id: <1322699194-19470-1-git-send-email-marcos.mage@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes some commented code, and a unnused variables. Remove too
a return statement at end of void function.

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Forest Bond <forest@alittletooquiet.net>
Cc: devel@driverdev.osuosl.org
---
 drivers/staging/vt6656/control.c |   26 ++++--------------
 drivers/staging/vt6656/usbpipe.c |   53 --------------------------------------
 2 files changed, 6 insertions(+), 73 deletions(-)

diff --git a/drivers/staging/vt6656/control.c b/drivers/staging/vt6656/control.c
index 5d8c571..74e9e7a 100644
--- a/drivers/staging/vt6656/control.c
+++ b/drivers/staging/vt6656/control.c
@@ -43,19 +43,6 @@
 #include "control.h"
 #include "rndis.h"
 
-/*---------------------  Static Definitions -------------------------*/
-/* static int          msglevel                =MSG_LEVEL_INFO;  */
-/* static int          msglevel                =MSG_LEVEL_DEBUG; */
-/*---------------------  Static Classes  ----------------------------*/
-
-/*---------------------  Static Variables  --------------------------*/
-
-/*---------------------  Static Functions  --------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Functions  --------------------------*/
-
 void ControlvWriteByte(PSDevice pDevice, BYTE byRegType, BYTE byRegOfs,
 			BYTE byData)
 {
@@ -72,14 +59,13 @@ void ControlvWriteByte(PSDevice pDevice, BYTE byRegType, BYTE byRegOfs,
 void ControlvReadByte(PSDevice pDevice, BYTE byRegType, BYTE byRegOfs,
 			PBYTE pbyData)
 {
-	int ntStatus;
 	BYTE	byData1;
-	ntStatus = CONTROLnsRequestIn(pDevice,
-					MESSAGE_TYPE_READ,
-					byRegOfs,
-					byRegType,
-					1,
-					&byData1);
+	CONTROLnsRequestIn(pDevice,
+			MESSAGE_TYPE_READ,
+			byRegOfs,
+			byRegType,
+			1,
+			&byData1);
 	*pbyData = byData1;
 }
 
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index c612ab5..2ff4b76 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -45,31 +45,14 @@
 #include "desc.h"
 #include "device.h"
 
-/*---------------------  Static Definitions -------------------------*/
-//endpoint def
-//endpoint 0: control
-//endpoint 1: interrupt
-//endpoint 2: read bulk
-//endpoint 3: write bulk
-
-//RequestType:
-//#define REQUEST_OUT       (USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE) // 0x40
-//#define REQUEST_IN        (USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE )  //0xc0
-//static int          msglevel                =MSG_LEVEL_DEBUG;
 static int          msglevel                =MSG_LEVEL_INFO;
 
-
 #define USB_CTL_WAIT   500 //ms
 
 #ifndef URB_ASYNC_UNLINK
 #define URB_ASYNC_UNLINK    0
 #endif
 
-/*---------------------  Static Classes  ----------------------------*/
-
-/*---------------------  Static Variables  --------------------------*/
-
-/*---------------------  Static Functions  --------------------------*/
 static
 void
 s_nsInterruptUsbIoCompleteRead(
@@ -103,10 +86,6 @@ s_nsControlInUsbIoCompleteWrite(
      struct urb *urb
     );
 
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Functions  --------------------------*/
-
 int PIPEnsControlOutAsyn(
      PSDevice     pDevice,
      BYTE         byRequest,
@@ -358,7 +337,6 @@ int PIPEnsInterruptRead(PSDevice pDevice)
         return (STATUS_FAILURE);
     }
     pDevice->intBuf.bInUse = TRUE;
-//    pDevice->bEventAvailable = FALSE;
     pDevice->ulIntInPosted++;
 
     //
@@ -433,14 +411,7 @@ s_nsInterruptUsbIoCompleteRead(
         pDevice->ulBulkInError++;
         pDevice->intBuf.bInUse = FALSE;
 
-//        if (ntStatus == USBD_STATUS_CRC) {
-//            pDevice->ulIntInContCRCError++;
-//        }
-
-//        if (ntStatus == STATUS_NOT_CONNECTED )
-//        {
             pDevice->fKillEventPollingThread = TRUE;
-//        }
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"IntUSBIoCompleteControl STATUS = %d\n", ntStatus );
     } else {
 	    pDevice->ulIntInBytesRead += (unsigned long) urb->actual_length;
@@ -569,14 +540,6 @@ s_nsBulkInUsbIoCompleteRead(
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"BULK In failed %d\n", status);
 
            pDevice->scStatistic.RxFcsErrCnt ++;
-//todo...xxxxxx
-//        if (status == USBD_STATUS_CRC) {
-//            pDevice->ulBulkInContCRCError++;
-//        }
-//        if (status == STATUS_DEVICE_NOT_CONNECTED )
-//        {
-//            MP_SET_FLAG(pDevice, fMP_DISCONNECTED);
-//        }
     } else {
         bIndicateReceive = TRUE;
         pDevice->ulBulkInContCRCError = 0;
@@ -633,23 +596,12 @@ PIPEnsSendBulkOut(
 
     pDevice->bPWBitOn = FALSE;
 
-/*
-    if (pDevice->pPendingBulkOutContext != NULL) {
-        pDevice->NumContextsQueued++;
-        EnqueueContext(pDevice->FirstTxContextQueue, pDevice->LastTxContextQueue, pContext);
-        status = STATUS_PENDING;
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Send pending!\n");
-        return status;
-    }
-*/
-
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"s_nsSendBulkOut\n");
 
     if (MP_IS_READY(pDevice) && (pDevice->Flags & fMP_POST_WRITES)) {
 
         pUrb = pContext->pUrb;
         pDevice->ulBulkOutPosted++;
-//        pDevice->pPendingBulkOutContext = pContext;
         usb_fill_bulk_urb(
         	    pUrb,
         		pDevice->usb,
@@ -746,9 +698,6 @@ s_nsBulkOutIoCompleteWrite(
         pDevice->ulBulkOutError++;
     }
 
-//    pDevice->ulCheckForHangCount = 0;
-//    pDevice->pPendingBulkOutContext = NULL;
-
     if ( CONTEXT_DATA_PACKET == ContextType ) {
         // Indicate to the protocol the status of the sent packet and return
         // ownership of the packet.
@@ -775,6 +724,4 @@ s_nsBulkOutIoCompleteWrite(
             netif_wake_queue(pDevice->dev);
     }
     pContext->bBoolInUse = FALSE;
-
-    return;
 }
-- 
1.7.4.4

