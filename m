Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759922Ab2JLQik (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 12:38:40 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63725 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759909Ab2JLQih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 12:38:37 -0400
From: Adil Mujeeb <mujeeb.adil@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Adil Mujeeb <mujeeb.adil@gmail.com>
Subject: [PATCH 7/9] Staging: winbond: wb35rx_s: Fixed coding style issue
Date: Fri, 12 Oct 2012 22:07:13 +0530
Message-Id: <1350059835-5408-8-git-send-email-mujeeb.adil@gmail.com>
X-Mailer: git-send-email 1.7.6.msysgit.0
In-Reply-To: <1350059835-5408-1-git-send-email-mujeeb.adil@gmail.com>
References: <1350059835-5408-1-git-send-email-mujeeb.adil@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed checpatch.pl reported ERRORs (excluding WARNING of line over 80 characters)

Signed-off-by: Adil Mujeeb <mujeeb.adil@gmail.com>
---
 linux-3.6-rc7/drivers/staging/winbond/wb35rx_s.h |   62 +++++++++++-----------
 1 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/linux-3.6-rc7/drivers/staging/winbond/wb35rx_s.h b/linux-3.6-rc7/drivers/staging/winbond/wb35rx_s.h
index 4b03274..545bc95 100644
--- a/linux-3.6-rc7/drivers/staging/winbond/wb35rx_s.h
+++ b/linux-3.6-rc7/drivers/staging/winbond/wb35rx_s.h
@@ -1,44 +1,44 @@
-//============================================================================
-// wb35rx.h --
-//============================================================================
+#ifndef __WINBOND_35RX_S_H
+#define __WINBOND_35RX_S_H
 
-// Definition for this module used
-#define MAX_USB_RX_BUFFER	4096	// This parameter must be 4096 931130.4.f
+/* Definition for this module used */
+#define MAX_USB_RX_BUFFER		4096	/* This parameter must be 4096 931130.4.f */
+#define MAX_USB_RX_BUFFER_NUMBER	ETHERNET_RX_DESCRIPTORS	/* Maximum 254, 255 is RESERVED ID */
+#define RX_INTERFACE			0	/* Interface 1 */
+#define RX_PIPE				2	/* Pipe 3 */
+#define MAX_PACKET_SIZE			1600	/* 1568	= 8 + 1532 + 4 + 24(IV EIV MIC ICV CRC) for check DMA data 931130.4.g */
+#define RX_END_TAG			0x0badbeef
 
-#define MAX_USB_RX_BUFFER_NUMBER	ETHERNET_RX_DESCRIPTORS		// Maximum 254, 255 is RESERVED ID
-#define RX_INTERFACE				0	// Interface 1
-#define RX_PIPE						2	// Pipe 3
-#define MAX_PACKET_SIZE				1600 //1568	// 8 + 1532 + 4 + 24(IV EIV MIC ICV CRC) for check DMA data 931130.4.g
-#define RX_END_TAG					0x0badbeef
 
-
-//====================================
-// Internal variable for module
-//====================================
+/*
+ * Internal variable for module
+ */
 struct wb35_rx {
-	u32			ByteReceived;// For calculating throughput of BulkIn
-	atomic_t		RxFireCounter;// Does Wb35Rx module fire?
+	u32		ByteReceived; /* For calculating throughput of BulkIn */
+	atomic_t	RxFireCounter;/* Does Wb35Rx module fire? */
 
-	u8	RxBuffer[ MAX_USB_RX_BUFFER_NUMBER ][ ((MAX_USB_RX_BUFFER+3) & ~0x03 ) ];
-	u16	RxBufferSize[ ((MAX_USB_RX_BUFFER_NUMBER+1) & ~0x01) ];
-	u8	RxOwner[ ((MAX_USB_RX_BUFFER_NUMBER+3) & ~0x03 ) ];//Ownership of buffer  0: SW 1:HW
+	u8		RxBuffer[MAX_USB_RX_BUFFER_NUMBER][((MAX_USB_RX_BUFFER+3) & ~0x03)];
+	u16		RxBufferSize[((MAX_USB_RX_BUFFER_NUMBER+1) & ~0x01)];
+	u8		RxOwner[((MAX_USB_RX_BUFFER_NUMBER+3) & ~0x03)]; /* Ownership of buffer  0:SW 1:HW */
 
-	u32	RxProcessIndex;//The next index to process
-	u32	RxBufferId;
-	u32	EP3vm_state;
+	u32		RxProcessIndex; /* The next index to process */
+	u32		RxBufferId;
+	u32		EP3vm_state;
 
-	u32	rx_halt; // For VM stopping
+	u32		rx_halt; /* For VM stopping */
 
-	u16	MoreDataSize;
-	u16	PacketSize;
+	u16		MoreDataSize;
+	u16		PacketSize;
 
-	u32	CurrentRxBufferId; // For complete routine usage
-	u32	Rx3UrbCancel;
+	u32		CurrentRxBufferId; /* For complete routine usage */
+	u32		Rx3UrbCancel;
 
-	u32	LastR1; // For RSSI reporting
-	struct urb *				RxUrb;
-	u32		Ep3ErrorCount2; // 20060625.1 Usbd for Rx DMA error count
+	u32		LastR1; /* For RSSI reporting */
+	struct urb	*RxUrb;
+	u32		Ep3ErrorCount2; /* 20060625.1 Usbd for Rx DMA error count */
 
 	int		EP3VM_status;
-	u8 *	pDRx;
+	u8		*pDRx;
 };
+
+#endif /* __WINBOND_35RX_S_H */
-- 
1.7.7.3

