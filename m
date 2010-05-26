Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935042Ab0EZXmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 19:42:45 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56342 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934933Ab0EZXlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 19:41:04 -0400
From: Mike Sheldon <mike@mikeasoft.com>
To: greg@kroah.com, pavel@ucw.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mike Sheldon <mike@mikeasoft.com>
Subject: [PATCH 08/15] Staging: winbond: Replace printk usage with pr_info/pr_err
Date: Thu, 27 May 2010 00:39:45 +0100
Message-Id: <1274917192-16962-8-git-send-email-mike@mikeasoft.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1274917192-16962-1-git-send-email-mike@mikeasoft.com>
References: <1274917192-16962-1-git-send-email-mike@mikeasoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patches wb35rx.c to replace printk usage (missing KERN_ levels) with appropriate pr_info and pr_err calls.

Signed-off-by: Mike Sheldon <mike@mikeasoft.com>
---
 drivers/staging/winbond/wb35rx.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/winbond/wb35rx.c b/drivers/staging/winbond/wb35rx.c
index efe82b1..38ad5bd 100644
--- a/drivers/staging/winbond/wb35rx.c
+++ b/drivers/staging/winbond/wb35rx.c
@@ -28,7 +28,7 @@ static void packet_came(struct ieee80211_hw *hw, char *pRxBufferAddress, int Pac
 
 	skb = dev_alloc_skb(PacketSize);
 	if (!skb) {
-		printk("Not enough memory for packet, FIXME\n");
+		pr_err("Not enough memory for packet, FIXME\n");
 		return;
 	}
 
@@ -110,7 +110,7 @@ static u16 Wb35Rx_indicate(struct ieee80211_hw *hw)
 			/* Basic check for Rx length. Is length valid? */
 			if (PacketSize > MAX_PACKET_SIZE) {
 #ifdef _PE_RX_DUMP_
-				printk("Serious ERROR : Rx data size too long, size =%d\n", PacketSize);
+				pr_err("Serious ERROR : Rx data size too long, size =%d\n", PacketSize);
 #endif
 
 				pWb35Rx->EP3vm_state = VM_STOP;
@@ -187,7 +187,7 @@ static void Wb35Rx_Complete(struct urb *urb)
 	/* The URB is completed, check the result */
 	if (pWb35Rx->EP3VM_status != 0) {
 #ifdef _PE_USB_STATE_DUMP_
-		printk("EP3 IoCompleteRoutine return error\n");
+		pr_err("EP3 IoCompleteRoutine return error\n");
 #endif
 		pWb35Rx->EP3vm_state = VM_STOP;
 		goto error;
@@ -250,7 +250,7 @@ static void Wb35Rx(struct ieee80211_hw *hw)
 	if (!pWb35Rx->RxOwner[RxBufferId]) {
 		/* It's impossible to run here. */
 #ifdef _PE_RX_DUMP_
-		printk("Rx driver fifo unavailable\n");
+		pr_err("Rx driver fifo unavailable\n");
 #endif
 		goto error;
 	}
@@ -263,7 +263,7 @@ static void Wb35Rx(struct ieee80211_hw *hw)
 
 	pWb35Rx->pDRx = kzalloc(MAX_USB_RX_BUFFER, GFP_ATOMIC);
 	if (!pWb35Rx->pDRx) {
-		printk("w35und: Rx memory alloc failed\n");
+		pr_err("w35und: Rx memory alloc failed\n");
 		goto error;
 	}
 	pRxBufferAddress = pWb35Rx->pDRx;
@@ -278,7 +278,7 @@ static void Wb35Rx(struct ieee80211_hw *hw)
 	retv = usb_submit_urb(urb, GFP_ATOMIC);
 
 	if (retv != 0) {
-		printk("Rx URB sending error\n");
+		pr_err("Rx URB sending error\n");
 		goto error;
 	}
 	return;
@@ -338,7 +338,7 @@ void Wb35Rx_stop(struct hw_data *pHwData)
 	if (pWb35Rx->EP3vm_state == VM_RUNNING) {
 		usb_unlink_urb(pWb35Rx->RxUrb); /* Only use unlink, let Wb35Rx_destroy to free them */
 #ifdef _PE_RX_DUMP_
-		printk("EP3 Rx stop\n");
+		pr_info("EP3 Rx stop\n");
 #endif
 	}
 }
@@ -356,7 +356,7 @@ void Wb35Rx_destroy(struct hw_data *pHwData)
 	if (pWb35Rx->RxUrb)
 		usb_free_urb(pWb35Rx->RxUrb);
 #ifdef _PE_RX_DUMP_
-	printk("Wb35Rx_destroy OK\n");
+	pr_info("Wb35Rx_destroy OK\n");
 #endif
 }
 
-- 
1.7.0.4

