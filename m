Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935007Ab0EZXl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 19:41:28 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56342 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934972Ab0EZXlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 19:41:13 -0400
From: Mike Sheldon <mike@mikeasoft.com>
To: greg@kroah.com, pavel@ucw.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mike Sheldon <mike@mikeasoft.com>
Subject: [PATCH 12/15] Staging: winbond: Replace C99 comments with C88
Date: Thu, 27 May 2010 00:39:49 +0100
Message-Id: <1274917192-16962-12-git-send-email-mike@mikeasoft.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1274917192-16962-1-git-send-email-mike@mikeasoft.com>
References: <1274917192-16962-1-git-send-email-mike@mikeasoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patches wb35rx_s.h to replace all the C99 style comments (//) with C89 style (/* ... */), as reported by checkpatch.pl.

Signed-off-by: Mike Sheldon <mike@mikeasoft.com>
---
 drivers/staging/winbond/wb35rx_s.h |   42 ++++++++++++++++++------------------
 1 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/winbond/wb35rx_s.h b/drivers/staging/winbond/wb35rx_s.h
index 7230a44..5cb48a0 100644
--- a/drivers/staging/winbond/wb35rx_s.h
+++ b/drivers/staging/winbond/wb35rx_s.h
@@ -1,43 +1,43 @@
-//============================================================================
-// wb35rx.h --
-//============================================================================
+/*============================================================================
+ * wb35rx.h --
+ *============================================================================*/
 
-// Definition for this module used
-#define MAX_USB_RX_BUFFER	4096	// This parameter must be 4096 931130.4.f
+/* Definition for this module used */
+#define MAX_USB_RX_BUFFER	4096	/* This parameter must be 4096 931130.4.f */
 
-#define MAX_USB_RX_BUFFER_NUMBER	ETHERNET_RX_DESCRIPTORS		// Maximum 254, 255 is RESERVED ID
-#define RX_INTERFACE				0	// Interface 1
-#define RX_PIPE						2	// Pipe 3
-#define MAX_PACKET_SIZE				1600 //1568	// 8 + 1532 + 4 + 24(IV EIV MIC ICV CRC) for check DMA data 931130.4.g
-#define RX_END_TAG					0x0badbeef
+#define MAX_USB_RX_BUFFER_NUMBER	ETHERNET_RX_DESCRIPTORS		/* Maximum 254, 255 is RESERVED ID */
+#define RX_INTERFACE				0	/* Interface 1 */
+#define RX_PIPE					2	/* Pipe 3 */
+#define MAX_PACKET_SIZE				1600 /* 1568 */	/* 8 + 1532 + 4 + 24(IV EIV MIC ICV CRC) for check DMA data 931130.4.g */
+#define RX_END_TAG				0x0badbeef
 
 
-//====================================
-// Internal variable for module
-//====================================
+/*====================================
+ * Internal variable for module
+ *====================================*/
 struct wb35_rx {
-	u32			ByteReceived;// For calculating throughput of BulkIn
-	atomic_t		RxFireCounter;// Does Wb35Rx module fire?
+	u32			ByteReceived; /* For calculating throughput of BulkIn */
+	atomic_t		RxFireCounter; /* Does Wb35Rx module fire? */
 
 	u8	RxBuffer[MAX_USB_RX_BUFFER_NUMBER][((MAX_USB_RX_BUFFER+3) & ~0x03)];
 	u16	RxBufferSize[((MAX_USB_RX_BUFFER_NUMBER+1) & ~0x01)];
-	u8	RxOwner[((MAX_USB_RX_BUFFER_NUMBER+3) & ~0x03)];//Ownership of buffer  0: SW 1:HW
+	u8	RxOwner[((MAX_USB_RX_BUFFER_NUMBER+3) & ~0x03)]; /* Ownership of buffer  0: SW 1:HW */
 
-	u32	RxProcessIndex;//The next index to process
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
 	struct urb	*RxUrb;
-	u32		Ep3ErrorCount2; // 20060625.1 Usbd for Rx DMA error count
+	u32		Ep3ErrorCount2; /* 20060625.1 Usbd for Rx DMA error count */
 
 	int		EP3VM_status;
 	u8	*pDRx;
-- 
1.7.0.4

