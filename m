Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab0C1IZd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 04:25:33 -0400
Received: from smtprelay-h11.telenor.se ([62.127.194.4]:44523 "EHLO
	smtprelay-h11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874Ab0C1IZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 04:25:30 -0400
X-SENDER-IP: [83.226.249.196]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkszADyvrktT4vnEPGdsb2JhbACHZ5NADAEBAQE1La8DjQeFAQQ
X-IronPort-AV: E=Sophos;i="4.51,321,1267398000"; 
   d="scan'208";a="56566837"
From: Lars Lindley <lindley@coyote.org>
To: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi, pavel@ucw.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Lars Lindley <lindley@coyote.org>
Subject: [PATCH] staging: winbond: wb35tx.c Coding style fixes.
Date: Sun, 28 Mar 2010 10:25:25 +0200
Message-Id: <1269764725-10190-1-git-send-email-lindley@coyote.org>
X-Mailer: git-send-email 1.7.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fixed the problems reported by checkpatch.pl except some long
lines and printk:s.
I also removed versioning comments.
Builds fine, .o identical to before and checked it with
Dan Carpenters strip_whitespace.pl and diff.

Signed-off-by: Lars Lindley <lindley@coyote.org>
---
 drivers/staging/winbond/wb35tx.c |  194 ++++++++++++++++++-------------------
 1 files changed, 94 insertions(+), 100 deletions(-)

diff --git a/drivers/staging/winbond/wb35tx.c b/drivers/staging/winbond/wb35tx.c
index 5869ef4..489a5e7 100644
--- a/drivers/staging/winbond/wb35tx.c
+++ b/drivers/staging/winbond/wb35tx.c
@@ -1,21 +1,21 @@
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
+/* ========================================================
+ *  Copyright (c) 1996-2002 Winbond Electronic Corporation
+ *
+ *  Module Name:
+ *    Wb35Tx.c
+ *
+ *  Abstract:
+ *   Processing the Tx message and put into down layer
+ *
+ * ========================================================
+ */
 #include <linux/usb.h>
 
 #include "wb35tx_f.h"
 #include "mds_f.h"
 #include "sysdef.h"
 
-unsigned char
-Wb35Tx_get_tx_buffer(struct hw_data * pHwData, u8 **pBuffer)
+unsigned char Wb35Tx_get_tx_buffer(struct hw_data *pHwData, u8 **pBuffer)
 {
 	struct wb35_tx *pWb35Tx = &pHwData->Wb35Tx;
 
@@ -25,28 +25,28 @@ Wb35Tx_get_tx_buffer(struct hw_data * pHwData, u8 **pBuffer)
 
 static void Wb35Tx(struct wbsoft_priv *adapter);
 
-static void Wb35Tx_complete(struct urb * pUrb)
+static void Wb35Tx_complete(struct urb *pUrb)
 {
-	struct wbsoft_priv *adapter = pUrb->context;
-	struct hw_data *	pHwData = &adapter->sHwData;
-	struct wb35_tx *pWb35Tx = &pHwData->Wb35Tx;
-	struct wb35_mds *pMds = &adapter->Mds;
+	struct wbsoft_priv	*adapter = pUrb->context;
+	struct hw_data		*pHwData = &adapter->sHwData;
+	struct wb35_tx		*pWb35Tx = &pHwData->Wb35Tx;
+	struct wb35_mds		*pMds = &adapter->Mds;
 
 	printk("wb35: tx complete\n");
-	// Variable setting
+	/* Variable setting */
 	pWb35Tx->EP4vm_state = VM_COMPLETED;
-	pWb35Tx->EP4VM_status = pUrb->status; //Store the last result of Irp
-	pMds->TxOwner[ pWb35Tx->TxSendIndex ] = 0;// Set the owner. Free the owner bit always.
+	pWb35Tx->EP4VM_status = pUrb->status; /* Store the last result of Irp */
+	pMds->TxOwner[pWb35Tx->TxSendIndex] = 0; /* Set the owner. Free the owner bit always. */
 	pWb35Tx->TxSendIndex++;
 	pWb35Tx->TxSendIndex %= MAX_USB_TX_BUFFER_NUMBER;
 
-	if (pHwData->SurpriseRemove || pHwData->HwStop) // Let WbWlanHalt to handle surprise remove
+	if (pHwData->SurpriseRemove || pHwData->HwStop) /* Let WbWlanHalt to handle surprise remove */
 		goto error;
 
 	if (pWb35Tx->tx_halt)
 		goto error;
 
-	// The URB is completed, check the result
+	/* The URB is completed, check the result */
 	if (pWb35Tx->EP4VM_status != 0) {
 		printk("URB submission failed\n");
 		pWb35Tx->EP4vm_state = VM_STOP;
@@ -64,43 +64,41 @@ error:
 
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
 
-
 	if (pHwData->SurpriseRemove || pHwData->HwStop)
 		goto cleanup;
 
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
 	usb_fill_bulk_urb(pUrb, pHwData->WbUsb.udev,
 			  usb_sndbulkpipe(pHwData->WbUsb.udev, 4),
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
 
-	// Check if driver needs issue Irp for EP2
+	/* Check if driver needs issue Irp for EP2 */
 	pWb35Tx->TxFillCount += pMds->TxCountInBuffer[SendIndex];
 	if (pWb35Tx->TxFillCount > 12)
 		Wb35Tx_EP2VM_start(adapter);
@@ -115,10 +113,10 @@ static void Wb35Tx(struct wbsoft_priv *adapter)
 
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
@@ -126,7 +124,7 @@ void Wb35Tx_start(struct wbsoft_priv *adapter)
 		atomic_dec(&pWb35Tx->TxFireCounter);
 }
 
-unsigned char Wb35Tx_initial(struct hw_data * pHwData)
+unsigned char Wb35Tx_initial(struct hw_data *pHwData)
 {
 	struct wb35_tx *pWb35Tx = &pHwData->Wb35Tx;
 
@@ -135,66 +133,63 @@ unsigned char Wb35Tx_initial(struct hw_data * pHwData)
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
-	#ifdef _PE_TX_DUMP_
+		usb_unlink_urb(pWb35Tx->Tx2Urb); /* Only use unlink, let Wb35Tx_destrot to free them */
+#ifdef _PE_TX_DUMP_
 	printk("EP2 Tx stop\n");
-	#endif
+#endif
 
-	// Trying to canceling the Irp of EP4
+	/* Trying to canceling the Irp of EP4 */
 	if (pWb35Tx->EP4vm_state == VM_RUNNING)
-		usb_unlink_urb( pWb35Tx->Tx4Urb ); // Only use unlink, let Wb35Tx_destrot to free them
-	#ifdef _PE_TX_DUMP_
+		usb_unlink_urb(pWb35Tx->Tx4Urb); /* Only use unlink, let Wb35Tx_destrot to free them */
+#ifdef _PE_TX_DUMP_
 	printk("EP4 Tx stop\n");
-	#endif
+#endif
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
+		msleep(10);  /* Delay for waiting function enter */
+	} while ((pWb35Tx->EP2vm_state != VM_STOP) && (pWb35Tx->EP4vm_state != VM_STOP));
+	msleep(10);  /* Delay for waiting function enter */
 
 	if (pWb35Tx->Tx4Urb)
-		usb_free_urb( pWb35Tx->Tx4Urb );
+		usb_free_urb(pWb35Tx->Tx4Urb);
 
 	if (pWb35Tx->Tx2Urb)
-		usb_free_urb( pWb35Tx->Tx2Urb );
+		usb_free_urb(pWb35Tx->Tx2Urb);
 
-	#ifdef _PE_TX_DUMP_
+#ifdef _PE_TX_DUMP_
 	printk("Wb35Tx_destroy OK\n");
-	#endif
+#endif
 }
 
 void Wb35Tx_CurrentTime(struct wbsoft_priv *adapter, u32 TimeCount)
 {
-	struct hw_data * pHwData = &adapter->sHwData;
+	struct hw_data *pHwData = &adapter->sHwData;
 	struct wb35_tx *pWb35Tx = &pHwData->Wb35Tx;
 	unsigned char Trigger = false;
 
 	if (pWb35Tx->TxTimer > TimeCount)
 		Trigger = true;
-	else if (TimeCount > (pWb35Tx->TxTimer+500))
+	else if (TimeCount > (pWb35Tx->TxTimer + 500))
 		Trigger = true;
 
 	if (Trigger) {
@@ -205,50 +200,50 @@ void Wb35Tx_CurrentTime(struct wbsoft_priv *adapter, u32 TimeCount)
 
 static void Wb35Tx_EP2VM(struct wbsoft_priv *adapter);
 
-static void Wb35Tx_EP2VM_complete(struct urb * pUrb)
+static void Wb35Tx_EP2VM_complete(struct urb *pUrb)
 {
-	struct wbsoft_priv *adapter = pUrb->context;
-	struct hw_data *	pHwData = &adapter->sHwData;
-	T02_DESCRIPTOR	T02, TSTATUS;
-	struct wb35_tx *pWb35Tx = &pHwData->Wb35Tx;
-	u32 *		pltmp = (u32 *)pWb35Tx->EP2_buf;
-	u32		i;
-	u16		InterruptInLength;
+	struct wbsoft_priv	*adapter = pUrb->context;
+	struct hw_data		*pHwData = &adapter->sHwData;
+	T02_DESCRIPTOR		T02, TSTATUS;
+	struct wb35_tx		*pWb35Tx = &pHwData->Wb35Tx;
+	u32			*pltmp = (u32 *)pWb35Tx->EP2_buf;
+	u32			i;
+	u16			InterruptInLength;
 
 
-	// Variable setting
+	/* Variable setting */
 	pWb35Tx->EP2vm_state = VM_COMPLETED;
 	pWb35Tx->EP2VM_status = pUrb->status;
 
-	// For Linux 2.4. Interrupt will always trigger
-	if (pHwData->SurpriseRemove || pHwData->HwStop) // Let WbWlanHalt to handle surprise remove
+	/* For Linux 2.4. Interrupt will always trigger */
+	if (pHwData->SurpriseRemove || pHwData->HwStop) /* Let WbWlanHalt to handle surprise remove */
 		goto error;
 
 	if (pWb35Tx->tx_halt)
 		goto error;
 
-	//The Urb is completed, check the result
+	/* The Urb is completed, check the result */
 	if (pWb35Tx->EP2VM_status != 0) {
 		printk("EP2 IoCompleteRoutine return error\n");
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
+	InterruptInLength -= 1;
+	InterruptInLength >>= 2; /* InterruptInLength / 4 */
 	for (i = 1; i <= InterruptInLength; i++) {
 		T02.value |= ((cpu_to_le32(pltmp[i]) & 0xff) << 24);
 
-		TSTATUS.value = T02.value;  //20061009 anson's endian
-		Mds_SendComplete( adapter, &TSTATUS );
+		TSTATUS.value = T02.value;
+		Mds_SendComplete(adapter, &TSTATUS);
 		T02.value = cpu_to_le32(pltmp[i]) >> 8;
 	}
-
 	return;
+
 error:
 	atomic_dec(&pWb35Tx->TxResultCount);
 	pWb35Tx->EP2vm_state = VM_STOP;
@@ -256,10 +251,10 @@ error:
 
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
 
 	if (pHwData->SurpriseRemove || pHwData->HwStop)
@@ -268,23 +263,23 @@ static void Wb35Tx_EP2VM(struct wbsoft_priv *adapter)
 	if (pWb35Tx->tx_halt)
 		goto error;
 
-	//
-	// Issuing URB
-	//
-	usb_fill_int_urb( pUrb, pHwData->WbUsb.udev, usb_rcvintpipe(pHwData->WbUsb.udev,2),
-			  pltmp, MAX_INTERRUPT_LENGTH, Wb35Tx_EP2VM_complete, adapter, 32);
+	/* Issuing URB */
+	usb_fill_int_urb(pUrb, pHwData->WbUsb.udev,
+			 usb_rcvintpipe(pHwData->WbUsb.udev, 2),
+			 pltmp, MAX_INTERRUPT_LENGTH,
+			 Wb35Tx_EP2VM_complete, adapter, 32);
 
 	pWb35Tx->EP2vm_state = VM_RUNNING;
 	retv = usb_submit_urb(pUrb, GFP_ATOMIC);
 
 	if (retv < 0) {
-		#ifdef _PE_TX_DUMP_
+#ifdef _PE_TX_DUMP_
 		printk("EP2 Tx Irp sending error\n");
-		#endif
+#endif
 		goto error;
 	}
-
 	return;
+
 error:
 	pWb35Tx->EP2vm_state = VM_STOP;
 	atomic_dec(&pWb35Tx->TxResultCount);
@@ -292,14 +287,13 @@ error:
 
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
-	}
-	else
+	} else
 		atomic_dec(&pWb35Tx->TxResultCount);
 }
-- 
1.7.0.3

