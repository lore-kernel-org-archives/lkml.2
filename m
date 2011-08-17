Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab1HQTQB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 15:16:01 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37123 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab1HQTP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 15:15:58 -0400
From: Akshay Joshi <me@akshayjoshi.com>
To: Pavel Machek <pavel@ucw.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
        Akshay Joshi <me@akshayjoshi.com>, Pekka Enberg <penberg@kernel.org>,
        Karthigan Srinivasan <karthigan.srinivasan2@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Dan Carpenter <error27@gmail.com>,
        Gabor Stefanik <netrolller.3d@gmail.com>
Subject: [PATCH 4/9] Staging: Winbond: Convert C99 style comments in Winbond.
Date: Wed, 17 Aug 2011 15:15:12 -0400
Message-Id: <1313608515-14033-1-git-send-email-me@akshayjoshi.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <4E4B54A4.4040203@kernel.org>
References: <4E4B54A4.4040203@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Converted all of the C99 style comments in the Winbond driver to the
kernel-accepted multiline stlye.

Signed-off-by: Akshay Joshi <me@akshayjoshi.com>
---
 drivers/staging/winbond/wb35rx_f.h |    6 +-
 drivers/staging/winbond/wb35rx_s.h |   51 ++++++++++----------
 drivers/staging/winbond/wb35tx.c   |   92 ++++++++++++++++++-----------------
 drivers/staging/winbond/wb35tx_s.h |   45 ++++++++---------
 4 files changed, 96 insertions(+), 98 deletions(-)

diff --git a/drivers/staging/winbond/wb35rx_f.h b/drivers/staging/winbond/wb35rx_f.h
index 1fdf65e..bb408e9 100644
--- a/drivers/staging/winbond/wb35rx_f.h
+++ b/drivers/staging/winbond/wb35rx_f.h
@@ -4,9 +4,9 @@
 #include <net/mac80211.h>
 #include "wbhal.h"
 
-//====================================
-// Interface function declare
-//====================================
+/*
+ * Interface function declare
+ */
 unsigned char		Wb35Rx_initial(  struct hw_data * pHwData );
 void		Wb35Rx_destroy(  struct hw_data * pHwData );
 void		Wb35Rx_stop(  struct hw_data * pHwData );
diff --git a/drivers/staging/winbond/wb35rx_s.h b/drivers/staging/winbond/wb35rx_s.h
index 4b03274..2681ffa 100644
--- a/drivers/staging/winbond/wb35rx_s.h
+++ b/drivers/staging/winbond/wb35rx_s.h
@@ -1,43 +1,42 @@
-//============================================================================
-// wb35rx.h --
-//============================================================================
-
-// Definition for this module used
-#define MAX_USB_RX_BUFFER	4096	// This parameter must be 4096 931130.4.f
-
-#define MAX_USB_RX_BUFFER_NUMBER	ETHERNET_RX_DESCRIPTORS		// Maximum 254, 255 is RESERVED ID
-#define RX_INTERFACE				0	// Interface 1
-#define RX_PIPE						2	// Pipe 3
-#define MAX_PACKET_SIZE				1600 //1568	// 8 + 1532 + 4 + 24(IV EIV MIC ICV CRC) for check DMA data 931130.4.g
-#define RX_END_TAG					0x0badbeef
-
-
-//====================================
-// Internal variable for module
-//====================================
+/*============================================================================
+ * wb35rx.h --
+ * ==========================================================================*/
+
+/* Definition for this module used */
+#define MAX_USB_RX_BUFFER 4096	/* This parameter must be 4096 931130.4.f */
+
+#define MAX_USB_RX_BUFFER_NUMBER ETHERNET_RX_DESCRIPTORS  /* Maximum 254, 255 is RESERVED ID */
+#define RX_INTERFACE 0	/* Interface 1 */
+#define RX_PIPE	2 /* Pipe 3 */
+#define MAX_PACKET_SIZE	1600 /*1568: 8 + 1532 + 4 + 24(IV EIV MIC ICV CRC) for check DMA data 931130.4.g */
+#define RX_END_TAG 0x0badbeef
+
+/*
+ * Internal variable for module
+ */
 struct wb35_rx {
-	u32			ByteReceived;// For calculating throughput of BulkIn
-	atomic_t		RxFireCounter;// Does Wb35Rx module fire?
+	u32			ByteReceived;/* For calculating throughput of BulkIn */
+	atomic_t		RxFireCounter;/* Does Wb35Rx module fire? */
 
 	u8	RxBuffer[ MAX_USB_RX_BUFFER_NUMBER ][ ((MAX_USB_RX_BUFFER+3) & ~0x03 ) ];
+	/* Ownership of buffer  0: SW 1:HW */
 	u16	RxBufferSize[ ((MAX_USB_RX_BUFFER_NUMBER+1) & ~0x01) ];
-	u8	RxOwner[ ((MAX_USB_RX_BUFFER_NUMBER+3) & ~0x03 ) ];//Ownership of buffer  0: SW 1:HW
-
-	u32	RxProcessIndex;//The next index to process
+	u8	RxOwner[ ((MAX_USB_RX_BUFFER_NUMBER+3) & ~0x03 ) ];
+	u32	RxProcessIndex; /* The next index to process */
 	u32	RxBufferId;
 	u32	EP3vm_state;
 
-	u32	rx_halt; // For VM stopping
+	u32	rx_halt; /* For VM stopping */
 
 	u16	MoreDataSize;
 	u16	PacketSize;
 
-	u32	CurrentRxBufferId; // For complete routine usage
+	u32	CurrentRxBufferId; /* For complete routine usage */
 	u32	Rx3UrbCancel;
 
-	u32	LastR1; // For RSSI reporting
+	u32	LastR1; /* For RSSI reporting */
 	struct urb *				RxUrb;
-	u32		Ep3ErrorCount2; // 20060625.1 Usbd for Rx DMA error count
+	u32		Ep3ErrorCount2; /* 20060625.1 Usbd for Rx DMA error count */
 
 	int		EP3VM_status;
 	u8 *	pDRx;
diff --git a/drivers/staging/winbond/wb35tx.c b/drivers/staging/winbond/wb35tx.c
index 49a43c1..a8dd4c9 100644
--- a/drivers/staging/winbond/wb35tx.c
+++ b/drivers/staging/winbond/wb35tx.c
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
+/*============================================================================
+ *  Copyright (c) 1996-2002 Winbond Electronic Corporation
+ *
+ *  Module Name:
+ *    Wb35Tx.c
+ *
+ *  Abstract:
+ *    Processing the Tx message and put into down layer
+ *
+*/
 #include <linux/usb.h>
 #include <linux/gfp.h>
 
@@ -33,20 +33,22 @@ static void Wb35Tx_complete(struct urb *pUrb)
 	struct wb35_mds *pMds = &adapter->Mds;
 
 	printk("wb35: tx complete\n");
-	// Variable setting
+	/* Variable setting */
 	pWb35Tx->EP4vm_state = VM_COMPLETED;
-	pWb35Tx->EP4VM_status = pUrb->status; //Store the last result of Irp
-	pMds->TxOwner[pWb35Tx->TxSendIndex] = 0;// Set the owner. Free the owner bit always.
+	pWb35Tx->EP4VM_status = pUrb->status; /* Store the last result of Irp */
+	/* Set the owner. Free the owner bit always. */
+	pMds->TxOwner[pWb35Tx->TxSendIndex] = 0;
 	pWb35Tx->TxSendIndex++;
 	pWb35Tx->TxSendIndex %= MAX_USB_TX_BUFFER_NUMBER;
 
-	if (pHwData->SurpriseRemove) // Let WbWlanHalt to handle surprise remove
+	/* Let WbWlanHalt to handle surprise remove */
+	if (pHwData->SurpriseRemove)
 		goto error;
 
 	if (pWb35Tx->tx_halt)
 		goto error;
 
-	// The URB is completed, check the result
+	/* The URB is completed, check the result */
 	if (pWb35Tx->EP4VM_status != 0) {
 		printk("URB submission failed\n");
 		pWb35Tx->EP4vm_state = VM_STOP;
@@ -79,15 +81,16 @@ static void Wb35Tx(struct wbsoft_priv *adapter)
 	if (pWb35Tx->tx_halt)
 		goto cleanup;
 
-	// Ownership checking
+	/* Ownership checking */
 	SendIndex = pWb35Tx->TxSendIndex;
-	if (!pMds->TxOwner[SendIndex]) //No more data need to be sent, return immediately
+	if (!pMds->TxOwner[SendIndex])
+		/* No more data need to be sent, return immediately. */
 		goto cleanup;
 
 	pTxBufferAddress = pWb35Tx->TxBuffer[SendIndex];
-	//
-	// Issuing URB
-	//
+
+	/* Issuing URB */
+
 	usb_fill_bulk_urb(pUrb, pHwData->udev,
 			  usb_sndbulkpipe(pHwData->udev, 4),
 			  pTxBufferAddress, pMds->TxBufferSize[SendIndex],
@@ -100,7 +103,7 @@ static void Wb35Tx(struct wbsoft_priv *adapter)
 		goto cleanup;
 	}
 
-	// Check if driver needs issue Irp for EP2
+	/* Check if driver needs issue Irp for EP2 */
 	pWb35Tx->TxFillCount += pMds->TxCountInBuffer[SendIndex];
 	if (pWb35Tx->TxFillCount > 12)
 		Wb35Tx_EP2VM_start(adapter);
@@ -118,7 +121,7 @@ void Wb35Tx_start(struct wbsoft_priv *adapter)
 	struct hw_data *pHwData = &adapter->sHwData;
 	struct wb35_tx *pWb35Tx = &pHwData->Wb35Tx;
 
-	// Allow only one thread to run into function
+	/* Allow only one thread to run into function */
 	if (atomic_inc_return(&pWb35Tx->TxFireCounter) == 1) {
 		pWb35Tx->EP4vm_state = VM_RUNNING;
 		Wb35Tx(adapter);
@@ -144,32 +147,32 @@ unsigned char Wb35Tx_initial(struct hw_data *pHwData)
 	return true;
 }
 
-//======================================================
 void Wb35Tx_stop(struct hw_data *pHwData)
 {
 	struct wb35_tx *pWb35Tx = &pHwData->Wb35Tx;
 
-	// Trying to canceling the Trp of EP2
+	/* Trying to canceling the Trp of EP2 */
 	if (pWb35Tx->EP2vm_state == VM_RUNNING)
-		usb_unlink_urb(pWb35Tx->Tx2Urb); // Only use unlink, let Wb35Tx_destrot to free them
+		/* Only use unlink, let Wb35Tx_destroy to free them. */
+		usb_unlink_urb(pWb35Tx->Tx2Urb);
 	pr_debug("EP2 Tx stop\n");
 
-	// Trying to canceling the Irp of EP4
+	/* Trying to canceling the Irp of EP4 */
 	if (pWb35Tx->EP4vm_state == VM_RUNNING)
-		usb_unlink_urb(pWb35Tx->Tx4Urb); // Only use unlink, let Wb35Tx_destrot to free them
+		/* Only use unlink, let Wb35Tx_destroy to free them. */
+		usb_unlink_urb(pWb35Tx->Tx4Urb);
 	pr_debug("EP4 Tx stop\n");
 }
 
-//======================================================
 void Wb35Tx_destroy(struct hw_data *pHwData)
 {
 	struct wb35_tx *pWb35Tx = &pHwData->Wb35Tx;
 
-	// Wait for VM stop
+	/* Wait for VM stop */
 	do {
-		msleep(10);  // Delay for waiting function enter 940623.1.a
+		msleep(10);  /* Delay for waiting function enter 940623.1.a */
 	} while ((pWb35Tx->EP2vm_state != VM_STOP) && (pWb35Tx->EP4vm_state != VM_STOP));
-	msleep(10);  // Delay for waiting function enter 940623.1.b
+	msleep(10);  /* Delay for waiting function enter 940623.1.b */
 
 	if (pWb35Tx->Tx4Urb)
 		usb_free_urb(pWb35Tx->Tx4Urb);
@@ -210,34 +213,35 @@ static void Wb35Tx_EP2VM_complete(struct urb *pUrb)
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
 		printk("EP2 IoCompleteRoutine return error\n");
 		pWb35Tx->EP2vm_state = VM_STOP;
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
+	/* 20051221.1.c Modify the follow for more stable */
+	InterruptInLength -= 1;
+	InterruptInLength >>= 2; /* InterruptInLength/4 */
 	for (i = 1; i <= InterruptInLength; i++) {
 		T02.value |= ((cpu_to_le32(pltmp[i]) & 0xff) << 24);
 
-		TSTATUS.value = T02.value;  //20061009 anson's endian
+		TSTATUS.value = T02.value; /* 20061009 anson's endian */
 		Mds_SendComplete(adapter, &TSTATUS);
 		T02.value = cpu_to_le32(pltmp[i]) >> 8;
 	}
@@ -262,9 +266,7 @@ static void Wb35Tx_EP2VM(struct wbsoft_priv *adapter)
 	if (pWb35Tx->tx_halt)
 		goto error;
 
-	//
-	// Issuing URB
-	//
+	/* Issuing URB */
 	usb_fill_int_urb(pUrb, pHwData->udev, usb_rcvintpipe(pHwData->udev, 2),
 			pltmp, MAX_INTERRUPT_LENGTH, Wb35Tx_EP2VM_complete, adapter, 32);
 
@@ -287,7 +289,7 @@ void Wb35Tx_EP2VM_start(struct wbsoft_priv *adapter)
 	struct hw_data *pHwData = &adapter->sHwData;
 	struct wb35_tx *pWb35Tx = &pHwData->Wb35Tx;
 
-	// Allow only one thread to run into function
+	/* Allow only one thread to run into function */
 	if (atomic_inc_return(&pWb35Tx->TxResultCount) == 1) {
 		pWb35Tx->EP2vm_state = VM_RUNNING;
 		Wb35Tx_EP2VM(adapter);
diff --git a/drivers/staging/winbond/wb35tx_s.h b/drivers/staging/winbond/wb35tx_s.h
index f70f433..1befbcb 100644
--- a/drivers/staging/winbond/wb35tx_s.h
+++ b/drivers/staging/winbond/wb35tx_s.h
@@ -3,36 +3,33 @@
 
 #include "mds_s.h"
 
-//====================================
-// IS89C35 Tx related definition
-//====================================
-#define TX_INTERFACE			0	// Interface 1
-#define TX_PIPE					3	// endpoint 4
-#define TX_INTERRUPT			1	// endpoint 2
-#define MAX_INTERRUPT_LENGTH	64	// It must be 64 for EP2 hardware
-
-
-
-//====================================
-// Internal variable for module
-//====================================
-
+/*
+ * IS89C35 Tx related definition
+ */
+#define TX_INTERFACE			0	/* Interface 1 */
+#define TX_PIPE					3	/* endpoint 4 */
+#define TX_INTERRUPT			1	/* endpoint 2 */
+#define MAX_INTERRUPT_LENGTH	64	/* It must be 64 for EP2 hardware */
+
+/*
+ * Internal variable for module
+ */
 
 struct wb35_tx {
-	// For Tx buffer
+	/* For Tx buffer */
 	u8	TxBuffer[ MAX_USB_TX_BUFFER_NUMBER ][ MAX_USB_TX_BUFFER ];
 
-	// For Interrupt pipe
+	/* For Interrupt pipe */
 	u8	EP2_buf[MAX_INTERRUPT_LENGTH];
 
-	atomic_t	TxResultCount;// For thread control of EP2 931130.4.m
-	atomic_t	TxFireCounter;// For thread control of EP4 931130.4.n
+	atomic_t	TxResultCount;/* For thread control of EP2 931130.4.m */
+	atomic_t	TxFireCounter;/* For thread control of EP4 931130.4.n */
 	u32			ByteTransfer;
 
-	u32	    TxSendIndex;// The next index of Mds array to be sent
-	u32	    EP2vm_state; // for EP2vm state
-	u32	    EP4vm_state; // for EP4vm state
-	u32	    tx_halt; // Stopping VM
+	u32	    TxSendIndex;/* The next index of Mds array to be sent */
+	u32	    EP2vm_state; /* for EP2vm state */
+	u32	    EP4vm_state; /* for EP4vm state */
+	u32	    tx_halt; /* Stopping VM */
 
 	struct urb *				Tx4Urb;
 	struct urb *				Tx2Urb;
@@ -40,8 +37,8 @@ struct wb35_tx {
 	int		EP2VM_status;
 	int		EP4VM_status;
 
-	u32	TxFillCount; // 20060928
-	u32	TxTimer; // 20060928 Add if sending packet not great than 13
+	u32	TxFillCount; /* 20060928 */
+	u32	TxTimer; /* 20060928 Add if sending packet not great than 13 */
 };
 
 #endif
-- 
1.7.5.4

