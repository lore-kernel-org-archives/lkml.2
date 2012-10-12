Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759931Ab2JLQit (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 12:38:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50829 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758062Ab2JLQiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 12:38:46 -0400
From: Adil Mujeeb <mujeeb.adil@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Adil Mujeeb <mujeeb.adil@gmail.com>
Subject: [PATCH 8/9] taging: winbond: wb35tx: Fixed coding style issues
Date: Fri, 12 Oct 2012 22:07:14 +0530
Message-Id: <1350059835-5408-9-git-send-email-mujeeb.adil@gmail.com>
X-Mailer: git-send-email 1.7.6.msysgit.0
In-Reply-To: <1350059835-5408-1-git-send-email-mujeeb.adil@gmail.com>
References: <1350059835-5408-1-git-send-email-mujeeb.adil@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed most of the checkpatch.pl reported ERRORs and WARNINGs (still few are there).

Signed-off-by: Adil Mujeeb <mujeeb.adil@gmail.com>
---
 linux-3.6-rc7/drivers/staging/winbond/wb35tx.c |  160 +++++++++++-------------
 1 files changed, 71 insertions(+), 89 deletions(-)

diff --git a/linux-3.6-rc7/drivers/staging/winbond/wb35tx.c b/linux-3.6-rc7/drivers/staging/winbond/wb35tx.c
index 5df39d4..8beeb4d 100644
--- a/linux-3.6-rc7/drivers/staging/winbond/wb35tx.c
+++ b/linux-3.6-rc7/drivers/staging/winbond/wb35tx.c
@@ -1,13 +1,13 @@
-//============================================================================
-//  Copyright (c) 1996-2002 Winbond Electronic Corporation
-//
-//  Module Name:
-//    Wb35Tx.c
-//
-//  Abstract:
-//    Processing the Tx message and put into down layer
-//
-//============================================================================
+/*
+ *  Copyright (c) 1996-2002 Winbond Electronic Corporation
+ *
+ *  Module Name:
+ *    Wb35Tx.c
+ *
+ *  Abstract:
+ *    Processing the Tx message and put into down layer
+ */
+
 #include <linux/usb.h>
 #include <linux/gfp.h>
 
@@ -15,7 +15,7 @@
 #include "mds_f.h"
 
 unsigned char
-Wb35Tx_get_tx_buffer(struct hw_data * pHwData, u8 **pBuffer)
+Wb35Tx_get_tx_buffer(struct hw_data *pHwData, u8 **pBuffer)
 {
 	struct wb35_tx *pWb35Tx = &pHwData->Wb35Tx;
 
@@ -25,30 +25,28 @@ Wb35Tx_get_tx_buffer(struct hw_data * pHwData, u8 **pBuffer)
 
 static void Wb35Tx(struct wbsoft_priv *adapter);
 
-static void Wb35Tx_complete(struct urb * pUrb)
+static void Wb35Tx_complete(struct urb *pUrb)
 {
 	struct wbsoft_priv *adapter = pUrb->context;
-	struct hw_data *	pHwData = &adapter->sHwData;
+	struct hw_data *pHwData = &adapter->sHwData;
 	struct wb35_tx *pWb35Tx = &pHwData->Wb35Tx;
 	struct wb35_mds *pMds = &adapter->Mds;
 
-	printk("wb35: tx complete\n");
-	// Variable setting
+	/* Variable setting */
 	pWb35Tx->EP4vm_state = VM_COMPLETED;
-	pWb35Tx->EP4VM_status = pUrb->status; //Store the last result of Irp
-	pMds->TxOwner[ pWb35Tx->TxSendIndex ] = 0;// Set the owner. Free the owner bit always.
+	pWb35Tx->EP4VM_status = pUrb->status; /* Store the last result of Irp */
+	pMds->TxOwner[pWb35Tx->TxSendIndex] = 0; /* Set the owner. Free the owner bit always. */
 	pWb35Tx->TxSendIndex++;
 	pWb35Tx->TxSendIndex %= MAX_USB_TX_BUFFER_NUMBER;
 
-	if (pHwData->SurpriseRemove) // Let WbWlanHalt to handle surprise remove
+	if (pHwData->SurpriseRemove) /* Let WbWlanHalt to handle surprise remove */
 		goto error;
 
 	if (pWb35Tx->tx_halt)
 		goto error;
 
-	// The URB is completed, check the result
+	/* The URB is completed, check the result */
 	if (pWb35Tx->EP4VM_status != 0) {
-		printk("URB submission failed\n");
 		pWb35Tx->EP4vm_state = VM_STOP;
 		goto error;
 	}
@@ -64,12 +62,12 @@ error:
 
 static void Wb35Tx(struct wbsoft_priv *adapter)
 {
-	struct hw_data *	pHwData = &adapter->sHwData;
-	struct wb35_tx *pWb35Tx = &pHwData->Wb35Tx;
+	struct hw_data	*pHwData = &adapter->sHwData;
+	struct wb35_tx	*pWb35Tx = &pHwData->Wb35Tx;
 	u8		*pTxBufferAddress;
 	struct wb35_mds *pMds = &adapter->Mds;
-	struct urb *	pUrb = (struct urb *)pWb35Tx->Tx4Urb;
-	int         	retv;
+	struct urb	*pUrb = (struct urb *)pWb35Tx->Tx4Urb;
+	int		retv;
 	u32		SendIndex;
 
 
@@ -79,28 +77,25 @@ static void Wb35Tx(struct wbsoft_priv *adapter)
 	if (pWb35Tx->tx_halt)
 		goto cleanup;
 
-	// Ownership checking
+	/* Ownership checking */
 	SendIndex = pWb35Tx->TxSendIndex;
-	if (!pMds->TxOwner[SendIndex]) //No more data need to be sent, return immediately
+	if (!pMds->TxOwner[SendIndex]) /* No more data need to be sent, return immediately */
 		goto cleanup;
 
 	pTxBufferAddress = pWb35Tx->TxBuffer[SendIndex];
-	//
-	// Issuing URB
-	//
+
+	/* Issuing URB */
 	usb_fill_bulk_urb(pUrb, pHwData->udev,
 			  usb_sndbulkpipe(pHwData->udev, 4),
-			  pTxBufferAddress, pMds->TxBufferSize[ SendIndex ],
+			  pTxBufferAddress, pMds->TxBufferSize[SendIndex],
 			  Wb35Tx_complete, adapter);
 
 	pWb35Tx->EP4vm_state = VM_RUNNING;
 	retv = usb_submit_urb(pUrb, GFP_ATOMIC);
-	if (retv<0) {
-		printk("EP4 Tx Irp sending error\n");
+	if (retv < 0)
 		goto cleanup;
-	}
 
-	// Check if driver needs issue Irp for EP2
+	/* Check if driver needs issue Irp for EP2 */
 	pWb35Tx->TxFillCount += pMds->TxCountInBuffer[SendIndex];
 	if (pWb35Tx->TxFillCount > 12)
 		Wb35Tx_EP2VM_start(adapter);
@@ -115,10 +110,10 @@ static void Wb35Tx(struct wbsoft_priv *adapter)
 
 void Wb35Tx_start(struct wbsoft_priv *adapter)
 {
-	struct hw_data * pHwData = &adapter->sHwData;
+	struct hw_data *pHwData = &adapter->sHwData;
 	struct wb35_tx *pWb35Tx = &pHwData->Wb35Tx;
 
-	// Allow only one thread to run into function
+	/* Allow only one thread to run into function */
 	if (atomic_inc_return(&pWb35Tx->TxFireCounter) == 1) {
 		pWb35Tx->EP4vm_state = VM_RUNNING;
 		Wb35Tx(adapter);
@@ -126,7 +121,7 @@ void Wb35Tx_start(struct wbsoft_priv *adapter)
 		atomic_dec(&pWb35Tx->TxFireCounter);
 }
 
-unsigned char Wb35Tx_initial(struct hw_data * pHwData)
+unsigned char Wb35Tx_initial(struct hw_data *pHwData)
 {
 	struct wb35_tx *pWb35Tx = &pHwData->Wb35Tx;
 
@@ -135,54 +130,47 @@ unsigned char Wb35Tx_initial(struct hw_data * pHwData)
 		return false;
 
 	pWb35Tx->Tx2Urb = usb_alloc_urb(0, GFP_ATOMIC);
-	if (!pWb35Tx->Tx2Urb)
-	{
-		usb_free_urb( pWb35Tx->Tx4Urb );
+	if (!pWb35Tx->Tx2Urb) {
+		usb_free_urb(pWb35Tx->Tx4Urb);
 		return false;
 	}
 
 	return true;
 }
 
-//======================================================
-void Wb35Tx_stop(struct hw_data * pHwData)
+void Wb35Tx_stop(struct hw_data *pHwData)
 {
 	struct wb35_tx *pWb35Tx = &pHwData->Wb35Tx;
 
-	// Trying to canceling the Trp of EP2
+	/* Trying to canceling the Trp of EP2 */
 	if (pWb35Tx->EP2vm_state == VM_RUNNING)
-		usb_unlink_urb( pWb35Tx->Tx2Urb ); // Only use unlink, let Wb35Tx_destrot to free them
-	pr_debug("EP2 Tx stop\n");
+		usb_unlink_urb(pWb35Tx->Tx2Urb); /* Only use unlink, let Wb35Tx_destrot to free them */
 
-	// Trying to canceling the Irp of EP4
+	/* Trying to canceling the Irp of EP4 */
 	if (pWb35Tx->EP4vm_state == VM_RUNNING)
-		usb_unlink_urb( pWb35Tx->Tx4Urb ); // Only use unlink, let Wb35Tx_destrot to free them
-	pr_debug("EP4 Tx stop\n");
+		usb_unlink_urb(pWb35Tx->Tx4Urb); /* Only use unlink, let Wb35Tx_destrot to free them */
 }
 
-//======================================================
-void Wb35Tx_destroy(struct hw_data * pHwData)
+void Wb35Tx_destroy(struct hw_data *pHwData)
 {
 	struct wb35_tx *pWb35Tx = &pHwData->Wb35Tx;
 
-	// Wait for VM stop
+	/* Wait for VM stop */
 	do {
-		msleep(10);  // Delay for waiting function enter 940623.1.a
-	} while( (pWb35Tx->EP2vm_state != VM_STOP) && (pWb35Tx->EP4vm_state != VM_STOP) );
-	msleep(10);  // Delay for waiting function enter 940623.1.b
+		msleep(10);  /* Delay for waiting function enter 940623.1.a */
+	} while ((pWb35Tx->EP2vm_state != VM_STOP) && (pWb35Tx->EP4vm_state != VM_STOP));
+	msleep(10);  /* Delay for waiting function enter 940623.1.b */
 
 	if (pWb35Tx->Tx4Urb)
-		usb_free_urb( pWb35Tx->Tx4Urb );
+		usb_free_urb(pWb35Tx->Tx4Urb);
 
 	if (pWb35Tx->Tx2Urb)
-		usb_free_urb( pWb35Tx->Tx2Urb );
-
-	pr_debug("Wb35Tx_destroy OK\n");
+		usb_free_urb(pWb35Tx->Tx2Urb);
 }
 
 void Wb35Tx_CurrentTime(struct wbsoft_priv *adapter, u32 TimeCount)
 {
-	struct hw_data * pHwData = &adapter->sHwData;
+	struct hw_data *pHwData = &adapter->sHwData;
 	struct wb35_tx *pWb35Tx = &pHwData->Wb35Tx;
 	unsigned char Trigger = false;
 
@@ -199,46 +187,44 @@ void Wb35Tx_CurrentTime(struct wbsoft_priv *adapter, u32 TimeCount)
 
 static void Wb35Tx_EP2VM(struct wbsoft_priv *adapter);
 
-static void Wb35Tx_EP2VM_complete(struct urb * pUrb)
+static void Wb35Tx_EP2VM_complete(struct urb *pUrb)
 {
 	struct wbsoft_priv *adapter = pUrb->context;
-	struct hw_data *	pHwData = &adapter->sHwData;
+	struct hw_data	*pHwData = &adapter->sHwData;
 	struct T02_descriptor	T02, TSTATUS;
 	struct wb35_tx *pWb35Tx = &pHwData->Wb35Tx;
-	u32 *		pltmp = (u32 *)pWb35Tx->EP2_buf;
+	u32		*pltmp = (u32 *)pWb35Tx->EP2_buf;
 	u32		i;
 	u16		InterruptInLength;
 
 
-	// Variable setting
+	/* Variable setting */
 	pWb35Tx->EP2vm_state = VM_COMPLETED;
 	pWb35Tx->EP2VM_status = pUrb->status;
 
-	// For Linux 2.4. Interrupt will always trigger
-	if (pHwData->SurpriseRemove) // Let WbWlanHalt to handle surprise remove
+	/* For Linux 2.4. Interrupt will always trigger */
+	if (pHwData->SurpriseRemove) /* Let WbWlanHalt to handle surprise remove */
 		goto error;
 
 	if (pWb35Tx->tx_halt)
 		goto error;
 
-	//The Urb is completed, check the result
+	/* The Urb is completed, check the result */
 	if (pWb35Tx->EP2VM_status != 0) {
-		printk("EP2 IoCompleteRoutine return error\n");
-		pWb35Tx->EP2vm_state= VM_STOP;
+		pWb35Tx->EP2vm_state = VM_STOP;
 		goto error;
 	}
 
-	// Update the Tx result
+	/* Update the Tx result */
 	InterruptInLength = pUrb->actual_length;
-	// Modify for minimum memory access and DWORD alignment.
-	T02.value = cpu_to_le32(pltmp[0]) >> 8; // [31:8] -> [24:0]
-	InterruptInLength -= 1;// 20051221.1.c Modify the follow for more stable
-	InterruptInLength >>= 2; // InterruptInLength/4
+	/* Modify for minimum memory access and DWORD alignment. */
+	T02.value = cpu_to_le32(pltmp[0]) >> 8; /* [31:8] -> [24:0] */
+	InterruptInLength -= 1; /* 20051221.1.c Modify the follow for more stable */
+	InterruptInLength >>= 2; /* InterruptInLength/4 */
 	for (i = 1; i <= InterruptInLength; i++) {
 		T02.value |= ((cpu_to_le32(pltmp[i]) & 0xff) << 24);
-
-		TSTATUS.value = T02.value;  //20061009 anson's endian
-		Mds_SendComplete( adapter, &TSTATUS );
+		TSTATUS.value = T02.value;  /* 20061009 anson's endian */
+		Mds_SendComplete(adapter, &TSTATUS);
 		T02.value = cpu_to_le32(pltmp[i]) >> 8;
 	}
 
@@ -250,10 +236,10 @@ error:
 
 static void Wb35Tx_EP2VM(struct wbsoft_priv *adapter)
 {
-	struct hw_data *	pHwData = &adapter->sHwData;
-	struct wb35_tx *pWb35Tx = &pHwData->Wb35Tx;
-	struct urb *	pUrb = (struct urb *)pWb35Tx->Tx2Urb;
-	u32 *	pltmp = (u32 *)pWb35Tx->EP2_buf;
+	struct hw_data	*pHwData = &adapter->sHwData;
+	struct wb35_tx	*pWb35Tx = &pHwData->Wb35Tx;
+	struct urb	*pUrb = (struct urb *)pWb35Tx->Tx2Urb;
+	u32		*pltmp = (u32 *)pWb35Tx->EP2_buf;
 	int		retv;
 
 	if (pHwData->SurpriseRemove)
@@ -262,19 +248,15 @@ static void Wb35Tx_EP2VM(struct wbsoft_priv *adapter)
 	if (pWb35Tx->tx_halt)
 		goto error;
 
-	//
-	// Issuing URB
-	//
-	usb_fill_int_urb( pUrb, pHwData->udev, usb_rcvintpipe(pHwData->udev,2),
+	/* Issuing URB */
+	usb_fill_int_urb(pUrb, pHwData->udev, usb_rcvintpipe(pHwData->udev, 2),
 			  pltmp, MAX_INTERRUPT_LENGTH, Wb35Tx_EP2VM_complete, adapter, 32);
 
 	pWb35Tx->EP2vm_state = VM_RUNNING;
 	retv = usb_submit_urb(pUrb, GFP_ATOMIC);
 
-	if (retv < 0) {
-		pr_debug("EP2 Tx Irp sending error\n");
+	if (retv < 0)
 		goto error;
-	}
 
 	return;
 error:
@@ -284,10 +266,10 @@ error:
 
 void Wb35Tx_EP2VM_start(struct wbsoft_priv *adapter)
 {
-	struct hw_data * pHwData = &adapter->sHwData;
+	struct hw_data *pHwData = &adapter->sHwData;
 	struct wb35_tx *pWb35Tx = &pHwData->Wb35Tx;
 
-	// Allow only one thread to run into function
+	/* Allow only one thread to run into function */
 	if (atomic_inc_return(&pWb35Tx->TxResultCount) == 1) {
 		pWb35Tx->EP2vm_state = VM_RUNNING;
 		Wb35Tx_EP2VM(adapter);
-- 
1.7.7.3

