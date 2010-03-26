Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab0CZPDr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 11:03:47 -0400
Received: from smtprelay-h11.telenor.se ([62.127.194.4]:41011 "EHLO
	smtprelay-h11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab0CZPDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 11:03:46 -0400
X-SENDER-IP: [83.226.250.253]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkBDAMhprEtT4vr9PGdsb2JhbACHcJM6DAEBAQE3LbIxjgOEfgQ
X-IronPort-AV: E=Sophos;i="4.51,315,1267398000"; 
   d="scan'208";a="56031767"
From: Lars Lindley <lindley@coyote.org>
To: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi, pavel@ucw.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Lars Lindley <lindley@coyote.org>
Subject: [PATCH] staging: winbond: wb35tx_s.h Coding style fixes.
Date: Fri, 26 Mar 2010 16:03:37 +0100
Message-Id: <1269615817-3565-1-git-send-email-lindley@coyote.org>
X-Mailer: git-send-email 1.7.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fixed all reported checkpatch issues.
I also removed versioning comments.
I checked for oopses with Dan Carpenters strip_whitespace.pl
and diff.

Signed-off-by: <lindley@coyote.org>
---
 drivers/staging/winbond/wb35tx_s.h |   62 ++++++++++++++++++-----------------
 1 files changed, 32 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/winbond/wb35tx_s.h b/drivers/staging/winbond/wb35tx_s.h
index f70f433..6799048 100644
--- a/drivers/staging/winbond/wb35tx_s.h
+++ b/drivers/staging/winbond/wb35tx_s.h
@@ -3,45 +3,47 @@
 
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
-
+/*
+ * ====================================
+ * IS89C35 Tx related definition
+ * ====================================
+ */
+#define TX_INTERFACE		0	/* Interface 1 */
+#define TX_PIPE			3	/* endpoint 4 */
+#define TX_INTERRUPT		1	/* endpoint 2 */
+#define MAX_INTERRUPT_LENGTH	64	/* It must be 64 for EP2 hardware */
+
+
+
+/*
+ * ====================================
+ * Internal variable for module
+ * ====================================
+ */
 struct wb35_tx {
-	// For Tx buffer
-	u8	TxBuffer[ MAX_USB_TX_BUFFER_NUMBER ][ MAX_USB_TX_BUFFER ];
+	/* For Tx buffer */
+	u8		TxBuffer[MAX_USB_TX_BUFFER_NUMBER][MAX_USB_TX_BUFFER];
 
-	// For Interrupt pipe
-	u8	EP2_buf[MAX_INTERRUPT_LENGTH];
+	/* For Interrupt pipe */
+	u8		EP2_buf[MAX_INTERRUPT_LENGTH];
 
-	atomic_t	TxResultCount;// For thread control of EP2 931130.4.m
-	atomic_t	TxFireCounter;// For thread control of EP4 931130.4.n
-	u32			ByteTransfer;
+	atomic_t	TxResultCount; /* For thread control of EP2 */
+	atomic_t	TxFireCounter; /* For thread control of EP4 */
+	u32		ByteTransfer;
 
-	u32	    TxSendIndex;// The next index of Mds array to be sent
-	u32	    EP2vm_state; // for EP2vm state
-	u32	    EP4vm_state; // for EP4vm state
-	u32	    tx_halt; // Stopping VM
+	u32		TxSendIndex;/* The next index of Mds array to be sent */
+	u32		EP2vm_state; /* for EP2vm state */
+	u32		EP4vm_state; /* for EP4vm state */
+	u32		tx_halt; /* Stopping VM */
 
-	struct urb *				Tx4Urb;
-	struct urb *				Tx2Urb;
+	struct urb	*Tx4Urb;
+	struct urb	*Tx2Urb;
 
 	int		EP2VM_status;
 	int		EP4VM_status;
 
-	u32	TxFillCount; // 20060928
-	u32	TxTimer; // 20060928 Add if sending packet not great than 13
+	u32		TxFillCount;
+	u32		TxTimer; /* Add if sending packet not great than 13 */
 };
 
 #endif
-- 
1.7.0.3

