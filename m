Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab0C1Hi5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 03:38:57 -0400
Received: from smtprelay-h12.telenor.se ([62.127.194.5]:56867 "EHLO
	smtprelay-h12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721Ab0C1Hi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 03:38:56 -0400
X-SENDER-IP: [83.226.249.196]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkszAK6krktT4vnEPGdsb2JhbACHZ5NADAEBAQE1La8MjQ2FAQQ
X-IronPort-AV: E=Sophos;i="4.51,321,1267398000"; 
   d="scan'208";a="56560168"
From: Lars Lindley <lindley@coyote.org>
To: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi, pavel@ucw.cz,
       linville@tuxdriver.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Lars Lindley <lindley@coyote.org>
Subject: [PATCH] staging: winbond: wb35rx.c Coding style fixes v2.
Date: Sun, 28 Mar 2010 08:38:57 +0200
Message-Id: <1269758337-4120-1-git-send-email-lindley@coyote.org>
X-Mailer: git-send-email 1.7.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New patch that fixes an unclear comment too.

I fixed checkpatch issues except for long lines and printk:s.
I also removed version comments and the () in a return statement.
Generated .o is identical to master and i checked the code with
Dan Carpenters strip_whitespace.pl and diff.

Signed-off-by: Lars Lindley <lindley@coyote.org>
Acked-by: Dan Carpenter <error27@gmail.com>
---
 drivers/staging/winbond/wb35rx.c |  258 ++++++++++++++++++--------------------
 1 files changed, 123 insertions(+), 135 deletions(-)

diff --git a/drivers/staging/winbond/wb35rx.c b/drivers/staging/winbond/wb35rx.c
index 4d41f6c..83b042f 100644
--- a/drivers/staging/winbond/wb35rx.c
+++ b/drivers/staging/winbond/wb35rx.c
@@ -1,13 +1,15 @@
-//============================================================================
-//  Copyright (c) 1996-2002 Winbond Electronic Corporation
-//
-//  Module Name:
-//    Wb35Rx.c
-//
-//  Abstract:
-//    Processing the Rx message from down layer
-//
-//============================================================================
+/*
+ * ============================================================================
+ *  Copyright (c) 1996-2002 Winbond Electronic Corporation
+ *
+ *  Module Name:
+ *    Wb35Rx.c
+ *
+ *  Abstract:
+ *    Processing the Rx message from down layer
+ *
+ * ============================================================================
+ */
 #include <linux/usb.h>
 
 #include "core.h"
@@ -29,16 +31,7 @@ static void packet_came(struct ieee80211_hw *hw, char *pRxBufferAddress, int Pac
 		return;
 	}
 
-	memcpy(skb_put(skb, PacketSize),
-	       pRxBufferAddress,
-	       PacketSize);
-
-/*
-	rx_status.rate = 10;
-	rx_status.channel = 1;
-	rx_status.freq = 12345;
-	rx_status.phymode = MODE_IEEE80211B;
-*/
+	memcpy(skb_put(skb, PacketSize), pRxBufferAddress, PacketSize);
 
 	memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
 	ieee80211_rx_irqsafe(hw, skb);
@@ -46,7 +39,7 @@ static void packet_came(struct ieee80211_hw *hw, char *pRxBufferAddress, int Pac
 
 static void Wb35Rx_adjust(struct wb35_descriptor *pRxDes)
 {
-	u32 *	pRxBufferAddress;
+	u32	*pRxBufferAddress;
 	u32	DecryptionMethod;
 	u32	i;
 	u16	BufferSize;
@@ -55,81 +48,80 @@ static void Wb35Rx_adjust(struct wb35_descriptor *pRxDes)
 	pRxBufferAddress = pRxDes->buffer_address[0];
 	BufferSize = pRxDes->buffer_size[0];
 
-	// Adjust the last part of data. Only data left
-	BufferSize -= 4; // For CRC-32
+	/* Adjust the last part of data. Only data left */
+	BufferSize -= 4; /* For CRC-32 */
 	if (DecryptionMethod)
 		BufferSize -= 4;
-	if (DecryptionMethod == 3) // For CCMP
+	if (DecryptionMethod == 3) /* For CCMP */
 		BufferSize -= 4;
 
-	// Adjust the IV field which after 802.11 header and ICV field.
-	if (DecryptionMethod == 1) // For WEP
-	{
-		for( i=6; i>0; i-- )
-			pRxBufferAddress[i] = pRxBufferAddress[i-1];
+	/* Adjust the IV field which after 802.11 header and ICV field. */
+	if (DecryptionMethod == 1) { /* For WEP */
+		for (i = 6; i > 0; i--)
+			pRxBufferAddress[i] = pRxBufferAddress[i - 1];
 		pRxDes->buffer_address[0] = pRxBufferAddress + 1;
-		BufferSize -= 4; // 4 byte for IV
-	}
-	else if( DecryptionMethod ) // For TKIP and CCMP
-	{
-		for (i=7; i>1; i--)
-			pRxBufferAddress[i] = pRxBufferAddress[i-2];
-		pRxDes->buffer_address[0] = pRxBufferAddress + 2;//Update the descriptor, shift 8 byte
-		BufferSize -= 8; // 8 byte for IV + ICV
+		BufferSize -= 4; /* 4 byte for IV */
+	} else if (DecryptionMethod) { /* For TKIP and CCMP */
+		for (i = 7; i > 1; i--)
+			pRxBufferAddress[i] = pRxBufferAddress[i - 2];
+		pRxDes->buffer_address[0] = pRxBufferAddress + 2; /* Update the descriptor, shift 8 byte */
+		BufferSize -= 8; /* 8 byte for IV + ICV */
 	}
 	pRxDes->buffer_size[0] = BufferSize;
 }
 
 static u16 Wb35Rx_indicate(struct ieee80211_hw *hw)
 {
-	struct wbsoft_priv *priv = hw->priv;
-	struct hw_data * pHwData = &priv->sHwData;
+	struct wbsoft_priv	*priv = hw->priv;
+	struct hw_data		*pHwData = &priv->sHwData;
 	struct wb35_descriptor	RxDes;
-	struct wb35_rx *pWb35Rx = &pHwData->Wb35Rx;
-	u8 *		pRxBufferAddress;
-	u16		PacketSize;
-	u16		stmp, BufferSize, stmp2 = 0;
-	u32		RxBufferId;
+	struct wb35_rx		*pWb35Rx = &pHwData->Wb35Rx;
+	u8			*pRxBufferAddress;
+	u16			PacketSize;
+	u16			stmp, BufferSize, stmp2 = 0;
+	u32			RxBufferId;
 
-	// Only one thread be allowed to run into the following
+	/* Only one thread be allowed to run into the following */
 	do {
 		RxBufferId = pWb35Rx->RxProcessIndex;
-		if (pWb35Rx->RxOwner[ RxBufferId ]) //Owner by VM
+		if (pWb35Rx->RxOwner[RxBufferId]) /* Owner by VM */
 			break;
 
 		pWb35Rx->RxProcessIndex++;
 		pWb35Rx->RxProcessIndex %= MAX_USB_RX_BUFFER_NUMBER;
 
 		pRxBufferAddress = pWb35Rx->pDRx;
-		BufferSize = pWb35Rx->RxBufferSize[ RxBufferId ];
+		BufferSize = pWb35Rx->RxBufferSize[RxBufferId];
 
-		// Parse the bulkin buffer
+		/* Parse the bulkin buffer */
 		while (BufferSize >= 4) {
-			if ((cpu_to_le32(*(u32 *)pRxBufferAddress) & 0x0fffffff) == RX_END_TAG) //Is ending? 921002.9.a
+			if ((cpu_to_le32(*(u32 *)pRxBufferAddress) & 0x0fffffff) == RX_END_TAG) /* Is ending? */
 				break;
 
-			// Get the R00 R01 first
+			/* Get the R00 R01 first */
 			RxDes.R00.value = le32_to_cpu(*(u32 *)pRxBufferAddress);
 			PacketSize = (u16)RxDes.R00.R00_receive_byte_count;
-			RxDes.R01.value = le32_to_cpu(*((u32 *)(pRxBufferAddress+4)));
-			// For new DMA 4k
+			RxDes.R01.value = le32_to_cpu(*((u32 *)(pRxBufferAddress + 4)));
+			/* For new DMA 4k */
 			if ((PacketSize & 0x03) > 0)
 				PacketSize -= 4;
 
-			// Basic check for Rx length. Is length valid?
+			/* Basic check for Rx length. Is length valid? */
 			if (PacketSize > MAX_PACKET_SIZE) {
-				#ifdef _PE_RX_DUMP_
+#ifdef _PE_RX_DUMP_
 				printk("Serious ERROR : Rx data size too long, size =%d\n", PacketSize);
-				#endif
+#endif
 
 				pWb35Rx->EP3vm_state = VM_STOP;
 				pWb35Rx->Ep3ErrorCount2++;
 				break;
 			}
 
-			// Start to process Rx buffer
-//			RxDes.Descriptor_ID = RxBufferId; // Due to synchronous indicate, the field doesn't necessary to use.
-			BufferSize -= 8; //subtract 8 byte for 35's USB header length
+			/*
+			 * Wb35Rx_indicate() is called synchronously so it isn't
+			 * necessary to set "RxDes.Desctriptor_ID = RxBufferID;"
+			 */
+			BufferSize -= 8; /* subtract 8 byte for 35's USB header length */
 			pRxBufferAddress += 8;
 
 			RxDes.buffer_address[0] = pRxBufferAddress;
@@ -141,18 +133,17 @@ static u16 Wb35Rx_indicate(struct ieee80211_hw *hw)
 
 			packet_came(hw, pRxBufferAddress, PacketSize);
 
-			// Move RxBuffer point to the next
+			/* Move RxBuffer point to the next */
 			stmp = PacketSize + 3;
-			stmp &= ~0x03; // 4n alignment
+			stmp &= ~0x03; /* 4n alignment */
 			pRxBufferAddress += stmp;
 			BufferSize -= stmp;
 			stmp2 += stmp;
 		}
 
-		// Reclaim resource
-		pWb35Rx->RxOwner[ RxBufferId ] = 1;
+		/* Reclaim resource */
+		pWb35Rx->RxOwner[RxBufferId] = 1;
 	} while (true);
-
 	return stmp2;
 }
 
@@ -160,112 +151,110 @@ static void Wb35Rx(struct ieee80211_hw *hw);
 
 static void Wb35Rx_Complete(struct urb *urb)
 {
-	struct ieee80211_hw *hw = urb->context;
-	struct wbsoft_priv *priv = hw->priv;
-	struct hw_data * pHwData = &priv->sHwData;
-	struct wb35_rx *pWb35Rx = &pHwData->Wb35Rx;
-	u8 *		pRxBufferAddress;
-	u32		SizeCheck;
-	u16		BulkLength;
-	u32		RxBufferId;
-	R00_DESCRIPTOR 	R00;
-
-	// Variable setting
+	struct ieee80211_hw	*hw = urb->context;
+	struct wbsoft_priv	*priv = hw->priv;
+	struct hw_data		*pHwData = &priv->sHwData;
+	struct wb35_rx		*pWb35Rx = &pHwData->Wb35Rx;
+	u8			*pRxBufferAddress;
+	u32			SizeCheck;
+	u16			BulkLength;
+	u32			RxBufferId;
+	R00_DESCRIPTOR		R00;
+
+	/* Variable setting */
 	pWb35Rx->EP3vm_state = VM_COMPLETED;
-	pWb35Rx->EP3VM_status = urb->status;//Store the last result of Irp
+	pWb35Rx->EP3VM_status = urb->status; /* Store the last result of Irp */
 
 	RxBufferId = pWb35Rx->CurrentRxBufferId;
 
 	pRxBufferAddress = pWb35Rx->pDRx;
 	BulkLength = (u16)urb->actual_length;
 
-	// The IRP is completed
+	/* The IRP is completed */
 	pWb35Rx->EP3vm_state = VM_COMPLETED;
 
-	if (pHwData->SurpriseRemove || pHwData->HwStop) // Must be here, or RxBufferId is invalid
+	if (pHwData->SurpriseRemove || pHwData->HwStop) /* Must be here, or RxBufferId is invalid */
 		goto error;
 
 	if (pWb35Rx->rx_halt)
 		goto error;
 
-	// Start to process the data only in successful condition
-	pWb35Rx->RxOwner[ RxBufferId ] = 0; // Set the owner to driver
+	/* Start to process the data only in successful condition */
+	pWb35Rx->RxOwner[RxBufferId] = 0; /* Set the owner to driver */
 	R00.value = le32_to_cpu(*(u32 *)pRxBufferAddress);
 
-	// The URB is completed, check the result
+	/* The URB is completed, check the result */
 	if (pWb35Rx->EP3VM_status != 0) {
-		#ifdef _PE_USB_STATE_DUMP_
+#ifdef _PE_USB_STATE_DUMP_
 		printk("EP3 IoCompleteRoutine return error\n");
-		#endif
+#endif
 		pWb35Rx->EP3vm_state = VM_STOP;
 		goto error;
 	}
 
-	// 20060220 For recovering. check if operating in single USB mode
+	/* For recovering. check if operating in single USB mode */
 	if (!HAL_USB_MODE_BURST(pHwData)) {
-		SizeCheck = R00.R00_receive_byte_count;  //20060926 anson's endian
+		SizeCheck = R00.R00_receive_byte_count;
 		if ((SizeCheck & 0x03) > 0)
 			SizeCheck -= 4;
 		SizeCheck = (SizeCheck + 3) & ~0x03;
-		SizeCheck += 12; // 8 + 4 badbeef
+		SizeCheck += 12; /* 8 + 4 badbeef */
 		if ((BulkLength > 1600) ||
 			(SizeCheck > 1600) ||
 			(BulkLength != SizeCheck) ||
-			(BulkLength == 0)) { // Add for fail Urb
+			(BulkLength == 0)) { /* Add for fail Urb */
 			pWb35Rx->EP3vm_state = VM_STOP;
 			pWb35Rx->Ep3ErrorCount2++;
 		}
 	}
 
-	// Indicating the receiving data
+	/* Indicating the receiving data */
 	pWb35Rx->ByteReceived += BulkLength;
-	pWb35Rx->RxBufferSize[ RxBufferId ] = BulkLength;
+	pWb35Rx->RxBufferSize[RxBufferId] = BulkLength;
 
-	if (!pWb35Rx->RxOwner[ RxBufferId ])
+	if (!pWb35Rx->RxOwner[RxBufferId])
 		Wb35Rx_indicate(hw);
 
 	kfree(pWb35Rx->pDRx);
-	// Do the next receive
+	/* Do the next receive */
 	Wb35Rx(hw);
 	return;
 
 error:
-	pWb35Rx->RxOwner[ RxBufferId ] = 1; // Set the owner to hardware
+	pWb35Rx->RxOwner[RxBufferId] = 1; /* Set the owner to hardware */
 	atomic_dec(&pWb35Rx->RxFireCounter);
 	pWb35Rx->EP3vm_state = VM_STOP;
 }
 
-// This function cannot reentrain
+/* This function cannot reentrain */
 static void Wb35Rx(struct ieee80211_hw *hw)
 {
-	struct wbsoft_priv *priv = hw->priv;
-	struct hw_data * pHwData = &priv->sHwData;
-	struct wb35_rx *pWb35Rx = &pHwData->Wb35Rx;
-	u8 *	pRxBufferAddress;
-	struct urb *urb = pWb35Rx->RxUrb;
-	int	retv;
-	u32	RxBufferId;
-
-	//
-	// Issuing URB
-	//
+	struct wbsoft_priv	*priv = hw->priv;
+	struct hw_data		*pHwData = &priv->sHwData;
+	struct wb35_rx		*pWb35Rx = &pHwData->Wb35Rx;
+	u8			*pRxBufferAddress;
+	struct urb		*urb = pWb35Rx->RxUrb;
+	int			retv;
+	u32			RxBufferId;
+
+	/* Issuing URB */
 	if (pHwData->SurpriseRemove || pHwData->HwStop)
 		goto error;
 
 	if (pWb35Rx->rx_halt)
 		goto error;
 
-	// Get RxBuffer's ID
+	/* Get RxBuffer's ID */
 	RxBufferId = pWb35Rx->RxBufferId;
 	if (!pWb35Rx->RxOwner[RxBufferId]) {
-		// It's impossible to run here.
-		#ifdef _PE_RX_DUMP_
+		/* It's impossible to run here. */
+#ifdef _PE_RX_DUMP_
 		printk("Rx driver fifo unavailable\n");
-		#endif
+#endif
 		goto error;
 	}
 
-	// Update buffer point, then start to bulkin the data from USB
+	/* Update buffer point, then start to bulkin the data from USB */
 	pWb35Rx->RxBufferId++;
 	pWb35Rx->RxBufferId %= MAX_USB_RX_BUFFER_NUMBER;
 
@@ -294,18 +283,18 @@ static void Wb35Rx(struct ieee80211_hw *hw)
 	return;
 
 error:
-	// VM stop
+	/* VM stop */
 	pWb35Rx->EP3vm_state = VM_STOP;
 	atomic_dec(&pWb35Rx->RxFireCounter);
 }
 
 void Wb35Rx_start(struct ieee80211_hw *hw)
 {
-	struct wbsoft_priv *priv = hw->priv;
-	struct hw_data * pHwData = &priv->sHwData;
-	struct wb35_rx *pWb35Rx = &pHwData->Wb35Rx;
+	struct wbsoft_priv	*priv = hw->priv;
+	struct hw_data		*pHwData = &priv->sHwData;
+	struct wb35_rx		*pWb35Rx = &pHwData->Wb35Rx;
 
-	// Allow only one thread to run into the Wb35Rx() function
+	/* Allow only one thread to run into the Wb35Rx() function */
 	if (atomic_inc_return(&pWb35Rx->RxFireCounter) == 1) {
 		pWb35Rx->EP3vm_state = VM_RUNNING;
 		Wb35Rx(hw);
@@ -313,11 +302,10 @@ void Wb35Rx_start(struct ieee80211_hw *hw)
 		atomic_dec(&pWb35Rx->RxFireCounter);
 }
 
-//=====================================================================================
-static void Wb35Rx_reset_descriptor(  struct hw_data * pHwData )
+static void Wb35Rx_reset_descriptor(struct hw_data *pHwData)
 {
-	struct wb35_rx *pWb35Rx = &pHwData->Wb35Rx;
-	u32	i;
+	struct wb35_rx	*pWb35Rx = &pHwData->Wb35Rx;
+	u32		i;
 
 	pWb35Rx->ByteReceived = 0;
 	pWb35Rx->RxProcessIndex = 0;
@@ -325,49 +313,49 @@ static void Wb35Rx_reset_descriptor(  struct hw_data * pHwData )
 	pWb35Rx->EP3vm_state = VM_STOP;
 	pWb35Rx->rx_halt = 0;
 
-	// Initial the Queue. The last buffer is reserved for used if the Rx resource is unavailable.
-	for( i=0; i<MAX_USB_RX_BUFFER_NUMBER; i++ )
+	/* Initial the Queue. The last buffer is reserved for used if the Rx resource is unavailable. */
+	for (i = 0; i < MAX_USB_RX_BUFFER_NUMBER; i++)
 		pWb35Rx->RxOwner[i] = 1;
 }
 
-unsigned char Wb35Rx_initial(struct hw_data * pHwData)
+unsigned char Wb35Rx_initial(struct hw_data *pHwData)
 {
 	struct wb35_rx *pWb35Rx = &pHwData->Wb35Rx;
 
-	// Initial the Buffer Queue
-	Wb35Rx_reset_descriptor( pHwData );
+	/* Initial the Buffer Queue */
+	Wb35Rx_reset_descriptor(pHwData);
 
 	pWb35Rx->RxUrb = usb_alloc_urb(0, GFP_ATOMIC);
-	return (!!pWb35Rx->RxUrb);
+	return !!pWb35Rx->RxUrb;
 }
 
-void Wb35Rx_stop(struct hw_data * pHwData)
+void Wb35Rx_stop(struct hw_data *pHwData)
 {
 	struct wb35_rx *pWb35Rx = &pHwData->Wb35Rx;
 
-	// Canceling the Irp if already sends it out.
+	/* Canceling the Irp if already sends it out. */
 	if (pWb35Rx->EP3vm_state == VM_RUNNING) {
-		usb_unlink_urb( pWb35Rx->RxUrb ); // Only use unlink, let Wb35Rx_destroy to free them
-		#ifdef _PE_RX_DUMP_
+		usb_unlink_urb(pWb35Rx->RxUrb); /* Only use unlink, let Wb35Rx_destroy to free them */
+#ifdef _PE_RX_DUMP_
 		printk("EP3 Rx stop\n");
-		#endif
+#endif
 	}
 }
 
-// Needs process context
-void Wb35Rx_destroy(struct hw_data * pHwData)
+/* Needs process context */
+void Wb35Rx_destroy(struct hw_data *pHwData)
 {
 	struct wb35_rx *pWb35Rx = &pHwData->Wb35Rx;
 
 	do {
-		msleep(10); // Delay for waiting function enter 940623.1.a
+		msleep(10); /* Delay for waiting function enter */
 	} while (pWb35Rx->EP3vm_state != VM_STOP);
-	msleep(10); // Delay for waiting function exit 940623.1.b
+	msleep(10); /* Delay for waiting function exit */
 
 	if (pWb35Rx->RxUrb)
-		usb_free_urb( pWb35Rx->RxUrb );
-	#ifdef _PE_RX_DUMP_
+		usb_free_urb(pWb35Rx->RxUrb);
+#ifdef _PE_RX_DUMP_
 	printk("Wb35Rx_destroy OK\n");
-	#endif
+#endif
 }
 
-- 
1.7.0.3

