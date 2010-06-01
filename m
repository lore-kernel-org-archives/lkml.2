Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486Ab0FAMWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 08:22:25 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:55038 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756191Ab0FAMWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 08:22:21 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Jonas Aaberg <jonas.aberg@stericsson.com>,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 13/18] DMAENGINE: ste_dma40: arch updates for LCLA and LCPA
Date: Tue, 1 Jun 2010 14:22:09 +0200
Message-ID: <1275394929-26678-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

This follows on the patch to allocate LCLA dynamically: the
on-chip memory is needed for other things so now that that
we're using it dynamically we can remove the LCLA resource
altogether and free up some ESRAM memory.

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 arch/arm/mach-ux500/devices-db8500.c           |   19 +++++++------------
 arch/arm/mach-ux500/include/mach/db8500-regs.h |    5 ++---
 2 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/arch/arm/mach-ux500/devices-db8500.c b/arch/arm/mach-ux500/devices-db8500.c
index 8229034..638964e 100644
--- a/arch/arm/mach-ux500/devices-db8500.c
+++ b/arch/arm/mach-ux500/devices-db8500.c
@@ -113,26 +113,21 @@ struct platform_device u8500_i2c4_device = {
 static struct resource dma40_resources[] = {
 	[0] = {
 		.start = U8500_DMA_BASE,
-		.end = U8500_DMA_BASE + SZ_4K - 1,
+		.end   = U8500_DMA_BASE + SZ_4K - 1,
 		.flags = IORESOURCE_MEM,
-		.name = "base",
+		.name  = "base",
 	},
 	[1] = {
 		.start = U8500_DMA_LCPA_BASE,
-		.end = U8500_DMA_LCPA_BASE + SZ_4K - 1,
+		.end   = U8500_DMA_LCPA_BASE + 2 * SZ_1K - 1,
 		.flags = IORESOURCE_MEM,
-		.name = "lcpa",
+		.name  = "lcpa",
 	},
 	[2] = {
-		.start = U8500_DMA_LCLA_BASE,
-		.end = U8500_DMA_LCLA_BASE + 16 * 1024 - 1,
-		.flags = IORESOURCE_MEM,
-		.name = "lcla",
-	},
-	[3] = {
 		.start = IRQ_DMA,
-		.end = IRQ_DMA,
-		.flags = IORESOURCE_IRQ}
+		.end   = IRQ_DMA,
+		.flags = IORESOURCE_IRQ,
+	}
 };
 
 /* Default configuration for physcial memcpy */
diff --git a/arch/arm/mach-ux500/include/mach/db8500-regs.h b/arch/arm/mach-ux500/include/mach/db8500-regs.h
index 85fc6a8..897fa35 100644
--- a/arch/arm/mach-ux500/include/mach/db8500-regs.h
+++ b/arch/arm/mach-ux500/include/mach/db8500-regs.h
@@ -15,9 +15,8 @@
 #define U8500_ESRAM_BANK2	(U8500_ESRAM_BANK1 + U8500_ESRAM_BANK_SIZE)
 #define U8500_ESRAM_BANK3	(U8500_ESRAM_BANK2 + U8500_ESRAM_BANK_SIZE)
 #define U8500_ESRAM_BANK4	(U8500_ESRAM_BANK3 + U8500_ESRAM_BANK_SIZE)
-/* Use bank 4 for DMA LCLA and LCPA */
-#define U8500_DMA_LCLA_BASE	U8500_ESRAM_BANK4
-#define U8500_DMA_LCPA_BASE	(U8500_ESRAM_BANK4 + 0x4000)
+/* Use bank 4 for DMA LCPA */
+#define U8500_DMA_LCPA_BASE	U8500_ESRAM_BANK4
 
 #define U8500_PER3_BASE		0x80000000
 #define U8500_STM_BASE		0x80100000
-- 
1.6.3.3

