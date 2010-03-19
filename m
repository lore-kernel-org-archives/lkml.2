Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab0CSSXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 14:23:33 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:51636 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab0CSSXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 14:23:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=IdtZk39IUzIjecR0qm/6vTBUdfmO4/zZFjZ+IWuXBGR6WAe1ysV29xPZAQvzamcm81
         iySmXz21mW4BmZvGbotKce9pVGRtu6CB9IUSjvi1SkAN899VLuvITa58Vyf+qGeahL3F
         /WpdYc4AlT9bQ/3LAAa7b0XZT+0O1sAKnqtAA=
From: Gorskin Ilya <revent82@gmail.com>
To: gregkh@suse.de, bzolnier@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Gorskin Ilya <revent82@gmail.com>
Subject: [PATCH 6/6] Staging:rt2860: fix coding style issue in rt_usb.c This is a patch to the rt_usb.c file that fixes up errors found by the checkpatch.pl tool
Date: Fri, 19 Mar 2010 23:22:41 +0500
Message-Id: <1269022961-26103-1-git-send-email-revent82@gmail.com>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gorskin Ilya <revent82@gmail.com>
---
 drivers/staging/rt2860/rt_usb.c |   20 +++++++-------------
 1 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/rt2860/rt_usb.c b/drivers/staging/rt2860/rt_usb.c
index 01a7eb4..bcfc0f5 100644
--- a/drivers/staging/rt2860/rt_usb.c
+++ b/drivers/staging/rt2860/rt_usb.c
@@ -233,8 +233,7 @@ static void rtusb_dataout_complete(unsigned long data)
 		FREE_HTTX_RING(pAd, BulkOutPipeId, pHTTXContext);
 		/*RTMP_IRQ_UNLOCK(&pAd->TxContextQueueLock[BulkOutPipeId], IrqFlags); */
 
-	} else			/* STATUS_OTHER */
-	{
+	} else {		/* STATUS_OTHER */
 		u8 *pBuf;
 
 		pAd->BulkOutCompleteOther++;
@@ -316,8 +315,7 @@ static void rtusb_null_frame_done_tasklet(unsigned long data)
 		RTMP_IRQ_UNLOCK(&pAd->BulkOutLock[0], irqFlag);
 
 		RTMPDeQueuePacket(pAd, FALSE, NUM_OF_TX_RING, MAX_TX_PROCESS);
-	} else			/* STATUS_OTHER */
-	{
+	} else {		/* STATUS_OTHER */
 		if ((!RTMP_TEST_FLAG(pAd, fRTMP_ADAPTER_RESET_IN_PROGRESS)) &&
 		    (!RTMP_TEST_FLAG(pAd, fRTMP_ADAPTER_HALT_IN_PROGRESS)) &&
 		    (!RTMP_TEST_FLAG(pAd, fRTMP_ADAPTER_NIC_NOT_EXIST)) &&
@@ -362,8 +360,7 @@ static void rtusb_rts_frame_done_tasklet(unsigned long data)
 	if (Status == USB_ST_NOERROR) {
 		RTMP_IRQ_UNLOCK(&pAd->BulkOutLock[0], irqFlag);
 		RTMPDeQueuePacket(pAd, FALSE, NUM_OF_TX_RING, MAX_TX_PROCESS);
-	} else			/* STATUS_OTHER */
-	{
+	} else {		/* STATUS_OTHER */
 		if ((!RTMP_TEST_FLAG(pAd, fRTMP_ADAPTER_RESET_IN_PROGRESS)) &&
 		    (!RTMP_TEST_FLAG(pAd, fRTMP_ADAPTER_HALT_IN_PROGRESS)) &&
 		    (!RTMP_TEST_FLAG(pAd, fRTMP_ADAPTER_NIC_NOT_EXIST)) &&
@@ -410,8 +407,7 @@ static void rtusb_pspoll_frame_done_tasklet(unsigned long data)
 
 	if (Status == USB_ST_NOERROR) {
 		RTMPDeQueuePacket(pAd, FALSE, NUM_OF_TX_RING, MAX_TX_PROCESS);
-	} else			/* STATUS_OTHER */
-	{
+	} else {		/* STATUS_OTHER */
 		if ((!RTMP_TEST_FLAG(pAd, fRTMP_ADAPTER_RESET_IN_PROGRESS)) &&
 		    (!RTMP_TEST_FLAG(pAd, fRTMP_ADAPTER_HALT_IN_PROGRESS)) &&
 		    (!RTMP_TEST_FLAG(pAd, fRTMP_ADAPTER_NIC_NOT_EXIST)) &&
@@ -473,14 +469,12 @@ static void rx_done_tasklet(unsigned long data)
 	if (Status == USB_ST_NOERROR) {
 		pAd->BulkInComplete++;
 		pAd->NextRxBulkInPosition = 0;
-		if (pRxContext->BulkInOffset)	/* As jan's comment, it may bulk-in success but size is zero. */
-		{
+		if (pRxContext->BulkInOffset) { /* As jan's comment, it may bulk-in success but size is zero. */
 			pRxContext->Readable = TRUE;
 			INC_RING_INDEX(pAd->NextRxBulkInIndex, RX_RING_SIZE);
 		}
 		RTMP_IRQ_UNLOCK(&pAd->BulkInLock, IrqFlags);
-	} else			/* STATUS_OTHER */
-	{
+	} else {			/* STATUS_OTHER */
 		pAd->BulkInCompleteFail++;
 		/* Still read this packet although it may comtain wrong bytes. */
 		pRxContext->Readable = FALSE;
@@ -584,7 +578,7 @@ static void rtusb_mgmt_dma_done_tasklet(unsigned long data)
 			/* The protectioon of rest bulk should be in BulkOut routine */
 			if (pAd->MgmtRing.TxSwFreeIdx <
 			    MGMT_RING_SIZE
-			    /* pMLMEContext->bWaitingBulkOut == TRUE */ ) {
+			    /* pMLMEContext->bWaitingBulkOut == TRUE */) {
 				RTUSB_SET_BULK_FLAG(pAd, fRTUSB_BULK_OUT_MLME);
 			}
 			RTUSBKickBulkOut(pAd);
-- 
1.7.0.2

