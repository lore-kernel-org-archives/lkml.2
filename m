Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855Ab2IXTOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 15:14:20 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:39830 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757768Ab2IXTOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 15:14:19 -0400
Message-ID: <201209241914.q8OJEHZS030540@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 24 Sep 2012 14:57:58 -0400
Subject: [PATCH] tile: gxio iorpc numbering change for TRIO interface
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An ABI numbering change was made in the hypervisor for Tilera's 4.1
MDE release (just shipped).  It's incompatible with the previous 4.0
release ABI numbering, so we track the new numbering going forward.
We plan to avoid modifying ABI numbering for these interfaces again.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/gxio/iorpc_trio.h |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/arch/tile/include/gxio/iorpc_trio.h b/arch/tile/include/gxio/iorpc_trio.h
index 15fb779..58105c3 100644
--- a/arch/tile/include/gxio/iorpc_trio.h
+++ b/arch/tile/include/gxio/iorpc_trio.h
@@ -25,21 +25,23 @@
 #include <linux/module.h>
 #include <asm/pgtable.h>
 
-#define GXIO_TRIO_OP_ALLOC_ASIDS       IORPC_OPCODE(IORPC_FORMAT_NONE, 0x1400)
+#define GXIO_TRIO_OP_DEALLOC_ASID      IORPC_OPCODE(IORPC_FORMAT_NONE, 0x1400)
+#define GXIO_TRIO_OP_ALLOC_ASIDS       IORPC_OPCODE(IORPC_FORMAT_NONE, 0x1401)
 
-#define GXIO_TRIO_OP_ALLOC_MEMORY_MAPS IORPC_OPCODE(IORPC_FORMAT_NONE, 0x1402)
+#define GXIO_TRIO_OP_ALLOC_MEMORY_MAPS IORPC_OPCODE(IORPC_FORMAT_NONE, 0x1404)
 
-#define GXIO_TRIO_OP_ALLOC_PIO_REGIONS IORPC_OPCODE(IORPC_FORMAT_NONE, 0x140e)
-#define GXIO_TRIO_OP_INIT_PIO_REGION_AUX IORPC_OPCODE(IORPC_FORMAT_NONE, 0x140f)
+#define GXIO_TRIO_OP_ALLOC_PIO_REGIONS IORPC_OPCODE(IORPC_FORMAT_NONE, 0x1412)
 
-#define GXIO_TRIO_OP_INIT_MEMORY_MAP_MMU_AUX IORPC_OPCODE(IORPC_FORMAT_NONE_NOUSER, 0x1417)
-#define GXIO_TRIO_OP_GET_PORT_PROPERTY IORPC_OPCODE(IORPC_FORMAT_NONE_NOUSER, 0x1418)
-#define GXIO_TRIO_OP_CONFIG_LEGACY_INTR IORPC_OPCODE(IORPC_FORMAT_KERNEL_INTERRUPT, 0x1419)
-#define GXIO_TRIO_OP_CONFIG_MSI_INTR   IORPC_OPCODE(IORPC_FORMAT_KERNEL_INTERRUPT, 0x141a)
+#define GXIO_TRIO_OP_INIT_PIO_REGION_AUX IORPC_OPCODE(IORPC_FORMAT_NONE, 0x1414)
 
-#define GXIO_TRIO_OP_SET_MPS_MRS       IORPC_OPCODE(IORPC_FORMAT_NONE_NOUSER, 0x141c)
-#define GXIO_TRIO_OP_FORCE_RC_LINK_UP  IORPC_OPCODE(IORPC_FORMAT_NONE_NOUSER, 0x141d)
-#define GXIO_TRIO_OP_FORCE_EP_LINK_UP  IORPC_OPCODE(IORPC_FORMAT_NONE_NOUSER, 0x141e)
+#define GXIO_TRIO_OP_INIT_MEMORY_MAP_MMU_AUX IORPC_OPCODE(IORPC_FORMAT_NONE_NOUSER, 0x141e)
+#define GXIO_TRIO_OP_GET_PORT_PROPERTY IORPC_OPCODE(IORPC_FORMAT_NONE_NOUSER, 0x141f)
+#define GXIO_TRIO_OP_CONFIG_LEGACY_INTR IORPC_OPCODE(IORPC_FORMAT_KERNEL_INTERRUPT, 0x1420)
+#define GXIO_TRIO_OP_CONFIG_MSI_INTR   IORPC_OPCODE(IORPC_FORMAT_KERNEL_INTERRUPT, 0x1421)
+
+#define GXIO_TRIO_OP_SET_MPS_MRS       IORPC_OPCODE(IORPC_FORMAT_NONE_NOUSER, 0x1423)
+#define GXIO_TRIO_OP_FORCE_RC_LINK_UP  IORPC_OPCODE(IORPC_FORMAT_NONE_NOUSER, 0x1424)
+#define GXIO_TRIO_OP_FORCE_EP_LINK_UP  IORPC_OPCODE(IORPC_FORMAT_NONE_NOUSER, 0x1425)
 #define GXIO_TRIO_OP_GET_MMIO_BASE     IORPC_OPCODE(IORPC_FORMAT_NONE_NOUSER, 0x8000)
 #define GXIO_TRIO_OP_CHECK_MMIO_OFFSET IORPC_OPCODE(IORPC_FORMAT_NONE_NOUSER, 0x8001)
 
-- 
1.7.10.3

