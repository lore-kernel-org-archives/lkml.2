Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab0IGNPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 09:15:20 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:35580 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756792Ab0IGNPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 09:15:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=WY5PVl2A0BsHzOk0/j4G2S9DZ0wdOIt1awkvum2Vm2fGsOTTVetXqakTKzAEf1NsCE
         Xbepk47z71CEo2xKZPmFkxqeA2RNhmUuaLa4DkqJ5iB0IwbCxRbaeVY6p7sbQnump3+6
         aHuEVskB7KMQyOEGtxkqgMm6WQBEjePrgK1W4=
From: "Prashant P. Shah" <pshah.mumbai@gmail.com>
To: gregkh@suse.de
Cc: pshah.mumbai@gmail.com, julia@diku.dk, daniele.boncompagni@gmail.com,
        a.beregalov@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] Staging: otus: added valid KERN_ loglevels to printk in wwrap.c
Date: Tue,  7 Sep 2010 18:44:49 +0530
Message-Id: <7e1ccc28be954d553b6daddf54dbc149f27c709f.1283865137.git.pshah.mumbai@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <3f9402c47b6c1e56310bc43ea624bae01dce826f.1283865137.git.pshah.mumbai@gmail.com>
References: <3f9402c47b6c1e56310bc43ea624bae01dce826f.1283865137.git.pshah.mumbai@gmail.com>
In-Reply-To: <3f9402c47b6c1e56310bc43ea624bae01dce826f.1283865137.git.pshah.mumbai@gmail.com>
References: <3f9402c47b6c1e56310bc43ea624bae01dce826f.1283865137.git.pshah.mumbai@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the wwrap.c file that adds valid KERN_ loglevels
to printk() statements

Signed-off-by: Prashant P. Shah <pshah.mumbai@gmail.com>
---
 drivers/staging/otus/wwrap.c |   33 ++++++++++++++++-----------------
 1 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/otus/wwrap.c b/drivers/staging/otus/wwrap.c
index bca71c8..eee2f56 100644
--- a/drivers/staging/otus/wwrap.c
+++ b/drivers/staging/otus/wwrap.c
@@ -89,9 +89,8 @@ void zfLnxPutTxUrb(zdev_t *dev)
 		macp->TxUrbHead = idx;
 		macp->TxUrbCnt++;
 	} else {
-		printk(
-				"UsbTxUrbQ inconsistent: TxUrbHead: %d, TxUrbTail: %d\n",
-				macp->TxUrbHead, macp->TxUrbTail);
+		printk(KERN_ERR "UsbTxUrbQ inconsistent: TxUrbHead: %d, TxUrbTail: %d\n",
+			macp->TxUrbHead, macp->TxUrbTail);
 	}
 
 	spin_unlock_irqrestore(&macp->cs_lock, irqFlag);
@@ -204,7 +203,7 @@ zbuf_t *zfLnxGetUsbRxBuffer(zdev_t *dev)
 				- 1));
 		macp->RxBufCnt--;
 	} else {
-		printk("RxBufQ inconsistent: RxBufHead: %d, RxBufTail: %d\n",
+		printk(KERN_ERR "RxBufQ inconsistent: RxBufHead: %d, RxBufTail: %d\n",
 				macp->RxBufHead, macp->RxBufTail);
 		spin_unlock_irqrestore(&macp->cs_lock, irqFlag);
 		return NULL;
@@ -230,7 +229,7 @@ u32_t zfLnxPutUsbRxBuffer(zdev_t *dev, zbuf_t *buf)
 		macp->RxBufTail = idx;
 		macp->RxBufCnt++;
 	} else {
-		printk("RxBufQ inconsistent: RxBufHead: %d, RxBufTail: %d\n",
+		printk(KERN_ERR "RxBufQ inconsistent: RxBufHead: %d, RxBufTail: %d\n",
 				macp->RxBufHead, macp->RxBufTail);
 		spin_unlock_irqrestore(&macp->cs_lock, irqFlag);
 		return 0xffff;
@@ -282,7 +281,7 @@ void zfLnxUsbDataIn_callback(urb_t *urb)
 
 	/* Check status for URB */
 	if (urb->status != 0) {
-		printk("zfLnxUsbDataIn_callback() : status=0x%x\n", urb->status);
+		printk(KERN_INFO "zfLnxUsbDataIn_callback() : status=0x%x\n", urb->status);
 		if ((urb->status != -ENOENT) && (urb->status != -ECONNRESET)
 				&& (urb->status != -ESHUTDOWN)) {
 			if (urb->status == -EPIPE) {
@@ -358,13 +357,13 @@ void zfLnxUsbDataIn_callback(urb_t *urb)
 #if 0
 			/* Dump data */
 			for (ii = index; ii < pkt_len+4;) {
-				printk("%02x ", (buf->data[ii] & 0xff));
+				printk(KERN_INFO "%02x ", (buf->data[ii] & 0xff));
 
 				if ((++ii % 16) == 0)
-					printk("\n");
+					printk(KERN_INFO "\n");
 			}
 
-			printk("\n");
+			printk(KERN_INFO "\n");
 #endif
 
 			pad_len = 4 - (pkt_len & 0x3);
@@ -487,7 +486,7 @@ void zfLnxUsbRegIn_callback(urb_t *urb)
 
 	/* Check status for URB */
 	if (urb->status != 0) {
-		printk("zfLnxUsbRegIn_callback() : status=0x%x\n", urb->status);
+		printk(KERN_INFO "zfLnxUsbRegIn_callback() : status=0x%x\n", urb->status);
 		if ((urb->status != -ENOENT) && (urb->status != -ECONNRESET)
 				&& (urb->status != -ESHUTDOWN)) {
 			if (urb->status == -EPIPE) {
@@ -636,11 +635,11 @@ u32_t zfLnxUsbSubmitTxData(zdev_t *dev)
 	if (TxData->hdrlen != 0) {
 		puTxBuf = macp->txUsbBuf[freeTxUrb];
 		for (i = 0; i < len; i++) {
-			printk("%02x ", puTxBuf[i]);
+			printk(KERN_INFO "%02x ", puTxBuf[i]);
 			if (i % 16 == 15)
-				printk("\n");
+				printk(KERN_INFO "\n");
 		}
-		printk("\n");
+		printk(KERN_INFO "\n");
 	}
 #endif
 #if 0
@@ -884,7 +883,7 @@ int zfLnxCencSendMsg(struct sock *netlink_sk, u_int8_t *msg, int len)
 	skb = alloc_skb(size, GFP_ATOMIC);
 
 	if (skb == NULL) {
-		printk("dev_alloc_skb failure\n");
+		printk(KERN_ERR "dev_alloc_skb failure\n");
 		goto out;
 	}
 	old_tail = skb->tail;
@@ -958,7 +957,7 @@ void kevent(struct work_struct *work)
 	if (test_and_clear_bit(KEVENT_WATCHDOG, &macp->kevent_flags)) {
 		extern u16_t zfHpStartRecv(zdev_t *dev);
 		/* zfiHwWatchDogReinit(dev); */
-		printk("\n************ Hw watchDog occur!! **************\n");
+		printk(KERN_INFO "\n************ Hw watchDog occur!! **************\n");
 		zfiWlanSuspend(dev);
 		zfiWlanResume(dev, 0);
 		zfHpStartRecv(dev);
@@ -1015,12 +1014,12 @@ void zfLnxSignalThread(zdev_t *dev, int flag)
 	struct usbdrv_private *macp = dev->ml_priv;
 
 	if (macp == NULL) {
-		printk("macp is NULL\n");
+		printk(KERN_WARNING "macp is NULL\n");
 		return;
 	}
 
 	if (0 && macp->kevent_ready != 1) {
-		printk("Kevent not ready\n");
+		printk(KERN_WARNING "Kevent not ready\n");
 		return;
 	}
 
-- 
1.6.0.4

