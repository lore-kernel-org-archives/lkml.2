Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab0HZJSH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 05:18:07 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:33893 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab0HZJSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 05:18:03 -0400
From: Alexander Shishkin <virtuoso@slind.org>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, Alexander Shishkin <virtuoso@slind.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, Paul Walmsley <paul@pwsan.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] omap3: move EMU peripheral addresses to a platform header
Date: Thu, 26 Aug 2010 12:14:24 +0300
Message-Id: <1282814066-23537-2-git-send-email-virtuoso@slind.org>
X-Mailer: git-send-email 1.7.2.1.45.gb66c2
In-Reply-To: <13B9B4C6EF24D648824FF11BE896716203BADA0745@dlee02.ent.ti.com>
References: <13B9B4C6EF24D648824FF11BE896716203BADA0745@dlee02.ent.ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These addresses are also needed for the OFF code to save/restore the
contexts of the EMU peripherals correctly.

Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
Cc: linux-omap@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-omap2/emu.c            |   14 ++++----------
 arch/arm/plat-omap/include/plat/io.h |   20 ++++++++++++++++++++
 2 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-omap2/emu.c b/arch/arm/mach-omap2/emu.c
index 9c442e2..6b41745 100644
--- a/arch/arm/mach-omap2/emu.c
+++ b/arch/arm/mach-omap2/emu.c
@@ -24,19 +24,13 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Alexander Shishkin");
 
-/* Cortex CoreSight components within omap3xxx EMU */
-#define ETM_BASE	(L4_EMU_34XX_PHYS + 0x10000)
-#define DBG_BASE	(L4_EMU_34XX_PHYS + 0x11000)
-#define ETB_BASE	(L4_EMU_34XX_PHYS + 0x1b000)
-#define DAPCTL		(L4_EMU_34XX_PHYS + 0x1d000)
-
 static struct amba_device omap3_etb_device = {
 	.dev		= {
 		.init_name = "etb",
 	},
 	.res		= {
-		.start	= ETB_BASE,
-		.end	= ETB_BASE + SZ_4K - 1,
+		.start	= OMAP34XX_ETB_PHYS,
+		.end	= OMAP34XX_ETB_PHYS + OMAP34XX_ETB_SIZE - 1,
 		.flags	= IORESOURCE_MEM,
 	},
 	.periphid	= 0x000bb907,
@@ -47,8 +41,8 @@ static struct amba_device omap3_etm_device = {
 		.init_name = "etm",
 	},
 	.res		= {
-		.start	= ETM_BASE,
-		.end	= ETM_BASE + SZ_4K - 1,
+		.start	= OMAP34XX_ETM_PHYS,
+		.end	= OMAP34XX_ETM_PHYS + OMAP34XX_ETM_SIZE - 1,
 		.flags	= IORESOURCE_MEM,
 	},
 	.periphid	= 0x102bb921,
diff --git a/arch/arm/plat-omap/include/plat/io.h b/arch/arm/plat-omap/include/plat/io.h
index 128b549..81f736a 100644
--- a/arch/arm/plat-omap/include/plat/io.h
+++ b/arch/arm/plat-omap/include/plat/io.h
@@ -185,6 +185,26 @@
 
 /* 3430 IVA - currently unmapped */
 
+#define OMAP34XX_DBG_OFFSET	(0x00011000)
+#define OMAP34XX_DBG_VIRT	(L4_EMU_34XX_VIRT + OMAP34XX_DBG_OFFSET)
+#define OMAP34XX_DBG_PHYS	(L4_EMU_34XX_PHYS + OMAP34XX_DBG_OFFSET)
+#define OMAP34XX_DBG_SIZE	SZ_4K
+
+#define OMAP34XX_ETM_OFFSET	(0x00010000)
+#define OMAP34XX_ETM_VIRT	(L4_EMU_34XX_VIRT + OMAP34XX_ETM_OFFSET)
+#define OMAP34XX_ETM_PHYS	(L4_EMU_34XX_PHYS + OMAP34XX_ETM_OFFSET)
+#define OMAP34XX_ETM_SIZE	SZ_4K
+
+#define OMAP34XX_ETB_OFFSET	(0x0001b000)
+#define OMAP34XX_ETB_VIRT	(L4_EMU_34XX_VIRT + OMAP34XX_ETB_OFFSET)
+#define OMAP34XX_ETB_PHYS	(L4_EMU_34XX_PHYS + OMAP34XX_ETB_OFFSET)
+#define OMAP34XX_ETB_SIZE	SZ_4K
+
+#define OMAP34XX_DAP_OFFSET	(0x0001d000)
+#define OMAP34XX_DAP_VIRT	(L4_EMU_34XX_VIRT + OMAP34XX_DAP_OFFSET)
+#define OMAP34XX_DAP_PHYS	(L4_EMU_34XX_PHYS + OMAP34XX_DAP_OFFSET)
+#define OMAP34XX_DAP_SIZE	SZ_4K
+
 /*
  * ----------------------------------------------------------------------------
  * Omap4 specific IO mapping
-- 
1.7.2.1.45.gb66c2

