Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934994Ab0EZXlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 19:41:22 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:33626 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934983Ab0EZXlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 19:41:15 -0400
From: Mike Sheldon <mike@mikeasoft.com>
To: greg@kroah.com, pavel@ucw.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mike Sheldon <mike@mikeasoft.com>
Subject: [PATCH 13/15] Staging: winbond: Replace printk usage with pr_info/pr_err
Date: Thu, 27 May 2010 00:39:50 +0100
Message-Id: <1274917192-16962-13-git-send-email-mike@mikeasoft.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1274917192-16962-1-git-send-email-mike@mikeasoft.com>
References: <1274917192-16962-1-git-send-email-mike@mikeasoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patches wb35tx.c to replace printk usage (missing KERN_ levels) with appropriate pr_info and pr_err calls.

Signed-off-by: Mike Sheldon <mike@mikeasoft.com>
---
 drivers/staging/winbond/wb35tx.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/winbond/wb35tx.c b/drivers/staging/winbond/wb35tx.c
index bda7a91..5ae792c 100644
--- a/drivers/staging/winbond/wb35tx.c
+++ b/drivers/staging/winbond/wb35tx.c
@@ -33,7 +33,7 @@ static void Wb35Tx_complete(struct urb * pUrb)
 	struct wb35_tx *pWb35Tx = &pHwData->Wb35Tx;
 	struct wb35_mds *pMds = &adapter->Mds;
 
-	printk("wb35: tx complete\n");
+	pr_info("wb35: tx complete\n");
 	// Variable setting
 	pWb35Tx->EP4vm_state = VM_COMPLETED;
 	pWb35Tx->EP4VM_status = pUrb->status; //Store the last result of Irp
@@ -49,7 +49,7 @@ static void Wb35Tx_complete(struct urb * pUrb)
 
 	// The URB is completed, check the result
 	if (pWb35Tx->EP4VM_status != 0) {
-		printk("URB submission failed\n");
+		pr_err("URB submission failed\n");
 		pWb35Tx->EP4vm_state = VM_STOP;
 		goto error;
 	}
@@ -97,7 +97,7 @@ static void Wb35Tx(struct wbsoft_priv *adapter)
 	pWb35Tx->EP4vm_state = VM_RUNNING;
 	retv = usb_submit_urb(pUrb, GFP_ATOMIC);
 	if (retv<0) {
-		printk("EP4 Tx Irp sending error\n");
+		pr_err("EP4 Tx Irp sending error\n");
 		goto cleanup;
 	}
 
@@ -154,14 +154,14 @@ void Wb35Tx_stop(struct hw_data * pHwData)
 	if (pWb35Tx->EP2vm_state == VM_RUNNING)
 		usb_unlink_urb( pWb35Tx->Tx2Urb ); // Only use unlink, let Wb35Tx_destrot to free them
 	#ifdef _PE_TX_DUMP_
-	printk("EP2 Tx stop\n");
+	pr_info("EP2 Tx stop\n");
 	#endif
 
 	// Trying to canceling the Irp of EP4
 	if (pWb35Tx->EP4vm_state == VM_RUNNING)
 		usb_unlink_urb( pWb35Tx->Tx4Urb ); // Only use unlink, let Wb35Tx_destrot to free them
 	#ifdef _PE_TX_DUMP_
-	printk("EP4 Tx stop\n");
+	pr_info("EP4 Tx stop\n");
 	#endif
 }
 
@@ -183,7 +183,7 @@ void Wb35Tx_destroy(struct hw_data * pHwData)
 		usb_free_urb( pWb35Tx->Tx2Urb );
 
 	#ifdef _PE_TX_DUMP_
-	printk("Wb35Tx_destroy OK\n");
+	pr_info("Wb35Tx_destroy OK\n");
 	#endif
 }
 
@@ -230,7 +230,7 @@ static void Wb35Tx_EP2VM_complete(struct urb * pUrb)
 
 	//The Urb is completed, check the result
 	if (pWb35Tx->EP2VM_status != 0) {
-		printk("EP2 IoCompleteRoutine return error\n");
+		pr_err("EP2 IoCompleteRoutine return error\n");
 		pWb35Tx->EP2vm_state= VM_STOP;
 		goto error;
 	}
@@ -280,7 +280,7 @@ static void Wb35Tx_EP2VM(struct wbsoft_priv *adapter)
 
 	if (retv < 0) {
 		#ifdef _PE_TX_DUMP_
-		printk("EP2 Tx Irp sending error\n");
+		pr_err("EP2 Tx Irp sending error\n");
 		#endif
 		goto error;
 	}
-- 
1.7.0.4

