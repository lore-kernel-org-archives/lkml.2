Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab1JLVkN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 17:40:13 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50359 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340Ab1JLVjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 17:39:06 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 07/10] staging: et131x: move et131x_defs.h contents into et131x.c
Date: Wed, 12 Oct 2011 22:36:39 +0100
Message-Id: <1318455402-10596-8-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1318455402-10596-1-git-send-email-mark.einon@gmail.com>
References: <1318455402-10596-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move et131x_defs.h contents into et131x.c and delete et131x_defs.h

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c      |   66 +++++++++++++++++-
 drivers/staging/et131x/et131x_defs.h |  128 ----------------------------------
 2 files changed, 64 insertions(+), 130 deletions(-)
 delete mode 100644 drivers/staging/et131x/et131x_defs.h

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index e88c277..402ab7f 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -53,8 +53,6 @@
  *
  */
 
-#include "et131x_defs.h"
-
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/module.h>
@@ -124,6 +122,70 @@ MODULE_DESCRIPTION("10/100/1000 Base-T Ethernet Driver "
 #define INT_MASK_ENABLE             0xfffebf17
 #define INT_MASK_ENABLE_NO_FLOW     0xfffebfd7
 
+/* General defines */
+/* Packet and header sizes */
+#define NIC_MIN_PACKET_SIZE	60
+
+/* Multicast list size */
+#define NIC_MAX_MCAST_LIST	128
+
+/* Supported Filters */
+#define ET131X_PACKET_TYPE_DIRECTED		0x0001
+#define ET131X_PACKET_TYPE_MULTICAST		0x0002
+#define ET131X_PACKET_TYPE_BROADCAST		0x0004
+#define ET131X_PACKET_TYPE_PROMISCUOUS		0x0008
+#define ET131X_PACKET_TYPE_ALL_MULTICAST	0x0010
+
+/* Tx Timeout */
+#define ET131X_TX_TIMEOUT	(1 * HZ)
+#define NIC_SEND_HANG_THRESHOLD	0
+
+/* MP_TCB flags */
+#define fMP_DEST_MULTI			0x00000001
+#define fMP_DEST_BROAD			0x00000002
+
+/* MP_ADAPTER flags */
+#define fMP_ADAPTER_RECV_LOOKASIDE	0x00000004
+#define fMP_ADAPTER_INTERRUPT_IN_USE	0x00000008
+#define fMP_ADAPTER_SECONDARY		0x00000010
+
+/* MP_SHARED flags */
+#define fMP_ADAPTER_SHUTDOWN		0x00100000
+#define fMP_ADAPTER_LOWER_POWER		0x00200000
+
+#define fMP_ADAPTER_NON_RECOVER_ERROR	0x00800000
+#define fMP_ADAPTER_RESET_IN_PROGRESS	0x01000000
+#define fMP_ADAPTER_NO_CABLE		0x02000000
+#define fMP_ADAPTER_HARDWARE_ERROR	0x04000000
+#define fMP_ADAPTER_REMOVE_IN_PROGRESS	0x08000000
+#define fMP_ADAPTER_HALT_IN_PROGRESS	0x10000000
+
+#define fMP_ADAPTER_FAIL_SEND_MASK	0x3ff00000
+#define fMP_ADAPTER_NOT_READY_MASK	0x3ff00000
+
+/* Some offsets in PCI config space that are actually used. */
+#define ET1310_PCI_MAX_PYLD		0x4C
+#define ET1310_PCI_MAC_ADDRESS		0xA4
+#define ET1310_PCI_EEPROM_STATUS	0xB2
+#define ET1310_PCI_ACK_NACK		0xC0
+#define ET1310_PCI_REPLAY		0xC2
+#define ET1310_PCI_L0L1LATENCY		0xCF
+
+/* PCI Vendor/Product IDs */
+#define ET131X_PCI_VENDOR_ID		0x11C1	/* Agere Systems */
+#define ET131X_PCI_DEVICE_ID_GIG	0xED00	/* ET1310 1000 Base-T 8 */
+#define ET131X_PCI_DEVICE_ID_FAST	0xED01	/* ET1310 100  Base-T */
+
+/* Define order of magnitude converter */
+#define NANO_IN_A_MICRO	1000
+
+#define PARM_RX_NUM_BUFS_DEF    4
+#define PARM_RX_TIME_INT_DEF    10
+#define PARM_RX_MEM_END_DEF     0x2bc
+#define PARM_TX_TIME_INT_DEF    40
+#define PARM_TX_NUM_BUFS_DEF    4
+#define PARM_DMA_CACHE_DEF      0
+
 /* ADAPTER defines */
 /*
  * Do not change these values: if changed, then change also in respective
diff --git a/drivers/staging/et131x/et131x_defs.h b/drivers/staging/et131x/et131x_defs.h
deleted file mode 100644
index 872a5af..0000000
-- 
1.7.6.4

