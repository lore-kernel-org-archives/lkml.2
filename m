Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933247Ab1JRQJw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 12:09:52 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43058 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932870Ab1JRQJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 12:09:41 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: [RESEND][PATCH 03/26] staging: et131x: Move non-register defines from et131x.h to et131x.c
Date: Tue, 18 Oct 2011 17:07:36 +0100
Message-Id: <1318954079-16666-4-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1318954079-16666-1-git-send-email-mark.einon@gmail.com>
References: <1318954079-16666-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Header file should only have register defines, moved non-register
defines to et131x.c

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c |   31 +++++++++++++++++++++++++++++++
 drivers/staging/et131x/et131x.h |   33 +--------------------------------
 2 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index a038a37..cad271b 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -96,6 +96,37 @@ MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DESCRIPTION("10/100/1000 Base-T Ethernet Driver "
 		   "for the ET1310 by Agere Systems");
 
+/* EEPROM defines */
+#define MAX_NUM_REGISTER_POLLS          1000
+#define MAX_NUM_WRITE_RETRIES           2
+
+/* MAC defines */
+#define COUNTER_WRAP_16_BIT 0x10000
+#define COUNTER_WRAP_12_BIT 0x1000
+
+/* PCI defines */
+#define INTERNAL_MEM_SIZE       0x400	/* 1024 of internal memory */
+#define INTERNAL_MEM_RX_OFFSET  0x1FF	/* 50%   Tx, 50%   Rx */
+
+/* ISR defines */
+/*
+ * For interrupts, normal running is:
+ *       rxdma_xfr_done, phy_interrupt, mac_stat_interrupt,
+ *       watchdog_interrupt & txdma_xfer_done
+ *
+ * In both cases, when flow control is enabled for either Tx or bi-direction,
+ * we additional enable rx_fbr0_low and rx_fbr1_low, so we know when the
+ * buffer rings are running low.
+ */
+#define INT_MASK_DISABLE            0xffffffff
+
+/* NOTE: Masking out MAC_STAT Interrupt for now...
+ * #define INT_MASK_ENABLE             0xfff6bf17
+ * #define INT_MASK_ENABLE_NO_FLOW     0xfff6bfd7
+ */
+#define INT_MASK_ENABLE             0xfffebf17
+#define INT_MASK_ENABLE_NO_FLOW     0xfffebfd7
+
 void et131x_error_timer_handler(unsigned long data);
 void et131x_enable_interrupts(struct et131x_adapter *adapter);
 void et131x_disable_interrupts(struct et131x_adapter *adapter);
diff --git a/drivers/staging/et131x/et131x.h b/drivers/staging/et131x/et131x.h
index 71fd7fe..115d307 100644
--- a/drivers/staging/et131x/et131x.h
+++ b/drivers/staging/et131x/et131x.h
@@ -49,7 +49,7 @@
 #define DRIVER_NAME "et131x"
 #define DRIVER_VERSION "v2.0"
 
-/* EEPROM defines */
+/* EEPROM registers */
 
 /* LBCIF Register Groups (addressed via 32-bit offsets) */
 #define LBCIF_DWORD0_GROUP       0xAC
@@ -77,34 +77,3 @@
 #define LBCIF_STATUS_CHECKSUM_ERROR     0x40
 #define LBCIF_STATUS_EEPROM_PRESENT     0x80
 
-/* Miscellaneous Constraints */
-#define MAX_NUM_REGISTER_POLLS          1000
-#define MAX_NUM_WRITE_RETRIES           2
-
-/* MAC defines */
-#define COUNTER_WRAP_16_BIT 0x10000
-#define COUNTER_WRAP_12_BIT 0x1000
-
-/* PCI defines */
-#define INTERNAL_MEM_SIZE       0x400	/* 1024 of internal memory */
-#define INTERNAL_MEM_RX_OFFSET  0x1FF	/* 50%   Tx, 50%   Rx */
-
-/* ISR defines */
-/*
- * For interrupts, normal running is:
- *       rxdma_xfr_done, phy_interrupt, mac_stat_interrupt,
- *       watchdog_interrupt & txdma_xfer_done
- *
- * In both cases, when flow control is enabled for either Tx or bi-direction,
- * we additional enable rx_fbr0_low and rx_fbr1_low, so we know when the
- * buffer rings are running low.
- */
-#define INT_MASK_DISABLE            0xffffffff
-
-/* NOTE: Masking out MAC_STAT Interrupt for now...
- * #define INT_MASK_ENABLE             0xfff6bf17
- * #define INT_MASK_ENABLE_NO_FLOW     0xfff6bfd7
- */
-#define INT_MASK_ENABLE             0xfffebf17
-#define INT_MASK_ENABLE_NO_FLOW     0xfffebfd7
-
-- 
1.7.6.4

