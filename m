Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab1JSXCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 19:02:47 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63334 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246Ab1JSXCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 19:02:43 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: =?UTF-8?q?staging=3A=20et131x=3A=20move=20et131x=5Fdefs=2Eh=20contents=20into=20et131x=2Ec?=
Date: Thu, 20 Oct 2011 00:00:56 +0100
Message-Id: <1319065268-2863-6-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1319065268-2863-1-git-send-email-mark.einon@gmail.com>
References: <1319065268-2863-1-git-send-email-mark.einon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
--- a/drivers/staging/et131x/et131x_defs.h
+++ /dev/null
@@ -1,128 +0,0 @@
-/*
- * Agere Systems Inc.
- * 10/100/1000 Base-T Ethernet Driver for the ET1301 and ET131x series MACs
- *
- * Copyright © 2005 Agere Systems Inc.
- * All rights reserved.
- *   http://www.agere.com
- *
- * Copyright (c) 2011 Mark Einon <mark.einon@gmail.com>
- *
- *------------------------------------------------------------------------------
- *
- * et131x_defs.h - Defines, structs, enums, prototypes, etc. to assist with OS
- *                 compatibility
- *
- *------------------------------------------------------------------------------
- *
- * SOFTWARE LICENSE
- *
- * This software is provided subject to the following terms and conditions,
- * which you should read carefully before using the software.  Using this
- * software indicates your acceptance of these terms and conditions.  If you do
- * not agree with these terms and conditions, do not use the software.
- *
- * Copyright © 2005 Agere Systems Inc.
- * All rights reserved.
- *
- * Redistribution and use in source or binary forms, with or without
- * modifications, are permitted provided that the following conditions are met:
- *
- * . Redistributions of source code must retain the above copyright notice, this
- *    list of conditions and the following Disclaimer as comments in the code as
- *    well as in the documentation and/or other materials provided with the
- *    distribution.
- *
- * . Redistributions in binary form must reproduce the above copyright notice,
- *    this list of conditions and the following Disclaimer in the documentation
- *    and/or other materials provided with the distribution.
- *
- * . Neither the name of Agere Systems Inc. nor the names of the contributors
- *    may be used to endorse or promote products derived from this software
- *    without specific prior written permission.
- *
- * Disclaimer
- *
- * THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
- * INCLUDING, BUT NOT LIMITED TO, INFRINGEMENT AND THE IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  ANY
- * USE, MODIFICATION OR DISTRIBUTION OF THIS SOFTWARE IS SOLELY AT THE USERS OWN
- * RISK. IN NO EVENT SHALL AGERE SYSTEMS INC. OR CONTRIBUTORS BE LIABLE FOR ANY
- * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
- * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
- * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
- * ON ANY THEORY OF LIABILITY, INCLUDING, BUT NOT LIMITED TO, CONTRACT, STRICT
- * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
- * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
- * DAMAGE.
- *
- */
-
-#ifndef __ET131X_DEFS_H__
-#define __ET131X_DEFS_H__
-
-/* Packet and header sizes */
-#define NIC_MIN_PACKET_SIZE	60
-
-/* Multicast list size */
-#define NIC_MAX_MCAST_LIST	128
-
-/* Supported Filters */
-#define ET131X_PACKET_TYPE_DIRECTED		0x0001
-#define ET131X_PACKET_TYPE_MULTICAST		0x0002
-#define ET131X_PACKET_TYPE_BROADCAST		0x0004
-#define ET131X_PACKET_TYPE_PROMISCUOUS		0x0008
-#define ET131X_PACKET_TYPE_ALL_MULTICAST	0x0010
-
-/* Tx Timeout */
-#define ET131X_TX_TIMEOUT	(1 * HZ)
-#define NIC_SEND_HANG_THRESHOLD	0
-
-/* MP_TCB flags */
-#define fMP_DEST_MULTI			0x00000001
-#define fMP_DEST_BROAD			0x00000002
-
-/* MP_ADAPTER flags */
-#define fMP_ADAPTER_RECV_LOOKASIDE	0x00000004
-#define fMP_ADAPTER_INTERRUPT_IN_USE	0x00000008
-#define fMP_ADAPTER_SECONDARY		0x00000010
-
-/* MP_SHARED flags */
-#define fMP_ADAPTER_SHUTDOWN		0x00100000
-#define fMP_ADAPTER_LOWER_POWER		0x00200000
-
-#define fMP_ADAPTER_NON_RECOVER_ERROR	0x00800000
-#define fMP_ADAPTER_RESET_IN_PROGRESS	0x01000000
-#define fMP_ADAPTER_NO_CABLE		0x02000000
-#define fMP_ADAPTER_HARDWARE_ERROR	0x04000000
-#define fMP_ADAPTER_REMOVE_IN_PROGRESS	0x08000000
-#define fMP_ADAPTER_HALT_IN_PROGRESS	0x10000000
-
-#define fMP_ADAPTER_FAIL_SEND_MASK	0x3ff00000
-#define fMP_ADAPTER_NOT_READY_MASK	0x3ff00000
-
-/* Some offsets in PCI config space that are actually used. */
-#define ET1310_PCI_MAX_PYLD		0x4C
-#define ET1310_PCI_MAC_ADDRESS		0xA4
-#define ET1310_PCI_EEPROM_STATUS	0xB2
-#define ET1310_PCI_ACK_NACK		0xC0
-#define ET1310_PCI_REPLAY		0xC2
-#define ET1310_PCI_L0L1LATENCY		0xCF
-
-/* PCI Vendor/Product IDs */
-#define ET131X_PCI_VENDOR_ID		0x11C1	/* Agere Systems */
-#define ET131X_PCI_DEVICE_ID_GIG	0xED00	/* ET1310 1000 Base-T 8 */
-#define ET131X_PCI_DEVICE_ID_FAST	0xED01	/* ET1310 100  Base-T */
-
-/* Define order of magnitude converter */
-#define NANO_IN_A_MICRO	1000
-
-#define PARM_RX_NUM_BUFS_DEF    4
-#define PARM_RX_TIME_INT_DEF    10
-#define PARM_RX_MEM_END_DEF     0x2bc
-#define PARM_TX_TIME_INT_DEF    40
-#define PARM_TX_NUM_BUFS_DEF    4
-#define PARM_DMA_CACHE_DEF      0
-
-
-#endif /* __ET131X_DEFS_H__ */
-- 
1.7.6.4

