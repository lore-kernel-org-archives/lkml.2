Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab1HPAZi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 20:25:38 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:34115 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab1HPAZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 20:25:36 -0400
From: Akshay Joshi <me@akshayjoshi.com>
To: Pavel Machek <pavel@ucw.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
        Pekka Enberg <penberg@kernel.org>, Akshay Joshi <me@akshayjoshi.com>,
        Karthigan Srinivasan <karthigan.srinivasan2@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/9] Staging: Winbond: Fix space issues in wb35tx.c.
Date: Mon, 15 Aug 2011 20:24:29 -0400
Message-Id: <1313454275-5604-3-git-send-email-me@akshayjoshi.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1313454275-5604-1-git-send-email-me@akshayjoshi.com>
References: <1313454275-5604-1-git-send-email-me@akshayjoshi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Issues with spaces (such as not having spaces inside of square brackets,
etc.) were fixed in the wb35tx.c file.

Signed-off-by: Akshay Joshi <me@akshayjoshi.com>
---
 drivers/staging/winbond/wb35tx.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/winbond/wb35tx.c b/drivers/staging/winbond/wb35tx.c
index 21edbc9..49a43c1 100644
--- a/drivers/staging/winbond/wb35tx.c
+++ b/drivers/staging/winbond/wb35tx.c
@@ -36,7 +36,7 @@ static void Wb35Tx_complete(struct urb *pUrb)
 	// Variable setting
 	pWb35Tx->EP4vm_state = VM_COMPLETED;
 	pWb35Tx->EP4VM_status = pUrb->status; //Store the last result of Irp
-	pMds->TxOwner[ pWb35Tx->TxSendIndex ] = 0;// Set the owner. Free the owner bit always.
+	pMds->TxOwner[pWb35Tx->TxSendIndex] = 0;// Set the owner. Free the owner bit always.
 	pWb35Tx->TxSendIndex++;
 	pWb35Tx->TxSendIndex %= MAX_USB_TX_BUFFER_NUMBER;
 
@@ -90,12 +90,12 @@ static void Wb35Tx(struct wbsoft_priv *adapter)
 	//
 	usb_fill_bulk_urb(pUrb, pHwData->udev,
 			  usb_sndbulkpipe(pHwData->udev, 4),
-			  pTxBufferAddress, pMds->TxBufferSize[ SendIndex ],
+			  pTxBufferAddress, pMds->TxBufferSize[SendIndex],
 			  Wb35Tx_complete, adapter);
 
 	pWb35Tx->EP4vm_state = VM_RUNNING;
 	retv = usb_submit_urb(pUrb, GFP_ATOMIC);
-	if (retv<0) {
+	if (retv < 0) {
 		printk("EP4 Tx Irp sending error\n");
 		goto cleanup;
 	}
@@ -137,7 +137,7 @@ unsigned char Wb35Tx_initial(struct hw_data *pHwData)
 	pWb35Tx->Tx2Urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (!pWb35Tx->Tx2Urb)
 	{
-		usb_free_urb( pWb35Tx->Tx4Urb );
+		usb_free_urb(pWb35Tx->Tx4Urb);
 		return false;
 	}
 
@@ -151,12 +151,12 @@ void Wb35Tx_stop(struct hw_data *pHwData)
 
 	// Trying to canceling the Trp of EP2
 	if (pWb35Tx->EP2vm_state == VM_RUNNING)
-		usb_unlink_urb( pWb35Tx->Tx2Urb ); // Only use unlink, let Wb35Tx_destrot to free them
+		usb_unlink_urb(pWb35Tx->Tx2Urb); // Only use unlink, let Wb35Tx_destrot to free them
 	pr_debug("EP2 Tx stop\n");
 
 	// Trying to canceling the Irp of EP4
 	if (pWb35Tx->EP4vm_state == VM_RUNNING)
-		usb_unlink_urb( pWb35Tx->Tx4Urb ); // Only use unlink, let Wb35Tx_destrot to free them
+		usb_unlink_urb(pWb35Tx->Tx4Urb); // Only use unlink, let Wb35Tx_destrot to free them
 	pr_debug("EP4 Tx stop\n");
 }
 
@@ -168,14 +168,14 @@ void Wb35Tx_destroy(struct hw_data *pHwData)
 	// Wait for VM stop
 	do {
 		msleep(10);  // Delay for waiting function enter 940623.1.a
-	} while( (pWb35Tx->EP2vm_state != VM_STOP) && (pWb35Tx->EP4vm_state != VM_STOP) );
+	} while ((pWb35Tx->EP2vm_state != VM_STOP) && (pWb35Tx->EP4vm_state != VM_STOP));
 	msleep(10);  // Delay for waiting function enter 940623.1.b
 
 	if (pWb35Tx->Tx4Urb)
-		usb_free_urb( pWb35Tx->Tx4Urb );
+		usb_free_urb(pWb35Tx->Tx4Urb);
 
 	if (pWb35Tx->Tx2Urb)
-		usb_free_urb( pWb35Tx->Tx2Urb );
+		usb_free_urb(pWb35Tx->Tx2Urb);
 
 	pr_debug("Wb35Tx_destroy OK\n");
 }
@@ -224,7 +224,7 @@ static void Wb35Tx_EP2VM_complete(struct urb *pUrb)
 	//The Urb is completed, check the result
 	if (pWb35Tx->EP2VM_status != 0) {
 		printk("EP2 IoCompleteRoutine return error\n");
-		pWb35Tx->EP2vm_state= VM_STOP;
+		pWb35Tx->EP2vm_state = VM_STOP;
 		goto error;
 	}
 
@@ -238,7 +238,7 @@ static void Wb35Tx_EP2VM_complete(struct urb *pUrb)
 		T02.value |= ((cpu_to_le32(pltmp[i]) & 0xff) << 24);
 
 		TSTATUS.value = T02.value;  //20061009 anson's endian
-		Mds_SendComplete( adapter, &TSTATUS );
+		Mds_SendComplete(adapter, &TSTATUS);
 		T02.value = cpu_to_le32(pltmp[i]) >> 8;
 	}
 
@@ -265,8 +265,8 @@ static void Wb35Tx_EP2VM(struct wbsoft_priv *adapter)
 	//
 	// Issuing URB
 	//
-	usb_fill_int_urb( pUrb, pHwData->udev, usb_rcvintpipe(pHwData->udev,2),
-			  pltmp, MAX_INTERRUPT_LENGTH, Wb35Tx_EP2VM_complete, adapter, 32);
+	usb_fill_int_urb(pUrb, pHwData->udev, usb_rcvintpipe(pHwData->udev, 2),
+			pltmp, MAX_INTERRUPT_LENGTH, Wb35Tx_EP2VM_complete, adapter, 32);
 
 	pWb35Tx->EP2vm_state = VM_RUNNING;
 	retv = usb_submit_urb(pUrb, GFP_ATOMIC);
-- 
1.7.5.4

