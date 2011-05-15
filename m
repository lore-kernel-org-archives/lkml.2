Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab1EOXha (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 19:37:30 -0400
Received: from mail.df.lth.se ([194.47.250.12]:22981 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753190Ab1EOXh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 19:37:27 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 01/13] mach-ux500: update the DB8500 register file
Date: Mon, 16 May 2011 01:37:23 +0200
Message-Id: <1305502643-32455-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/include/mach/db8500-regs.h |   37 +++++++++++++++++++----
 1 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-ux500/include/mach/db8500-regs.h b/arch/arm/mach-ux500/include/mach/db8500-regs.h
index 16647b2..0499971 100644
--- a/arch/arm/mach-ux500/include/mach/db8500-regs.h
+++ b/arch/arm/mach-ux500/include/mach/db8500-regs.h
@@ -15,8 +15,13 @@
 #define U8500_ESRAM_BANK2	(U8500_ESRAM_BANK1 + U8500_ESRAM_BANK_SIZE)
 #define U8500_ESRAM_BANK3	(U8500_ESRAM_BANK2 + U8500_ESRAM_BANK_SIZE)
 #define U8500_ESRAM_BANK4	(U8500_ESRAM_BANK3 + U8500_ESRAM_BANK_SIZE)
-/* Use bank 4 for DMA LCPA */
-#define U8500_DMA_LCPA_BASE	U8500_ESRAM_BANK4
+/*
+ * on V1 DMA uses 4KB for logical parameters position is right after the 64KB
+ * reserved for security
+ */
+#define U8500_ESRAM_DMA_LCPA_OFFSET     0x10000
+
+#define U8500_DMA_LCPA_BASE    (U8500_ESRAM_BANK0 + U8500_ESRAM_DMA_LCPA_OFFSET)
 #define U8500_DMA_LCPA_BASE_ED	(U8500_ESRAM_BANK4 + 0x4000)
 
 #define U8500_PER3_BASE		0x80000000
@@ -27,9 +32,12 @@
 #define U8500_B2R2_BASE		0x80130000
 #define U8500_HSEM_BASE		0x80140000
 #define U8500_PER4_BASE		0x80150000
+#define U8500_TPIU_BASE		0x80190000
 #define U8500_ICN_BASE		0x81000000
 
 #define U8500_BOOT_ROM_BASE	0x90000000
+/* ASIC ID is at 0xbf4 offset within this region */
+#define U8500_ASIC_ID_BASE	0x9001D000
 
 #define U8500_PER6_BASE		0xa03c0000
 #define U8500_PER5_BASE		0xa03e0000
@@ -70,13 +78,15 @@
 
 /* per6 base addresses */
 #define U8500_RNG_BASE		(U8500_PER6_BASE + 0x0000)
-#define U8500_PKA_BASE		(U8500_PER6_BASE + 0x1000)
-#define U8500_PKAM_BASE		(U8500_PER6_BASE + 0x2000)
+#define U8500_HASH0_BASE        (U8500_PER6_BASE + 0x1000)
+#define U8500_HASH1_BASE        (U8500_PER6_BASE + 0x2000)
+#define U8500_PKA_BASE		(U8500_PER6_BASE + 0x4000)
+#define U8500_PKAM_BASE		(U8500_PER6_BASE + 0x5100)
 #define U8500_MTU0_BASE		(U8500_PER6_BASE + 0x6000) /* v1 */
 #define U8500_MTU1_BASE		(U8500_PER6_BASE + 0x7000) /* v1 */
 #define U8500_CR_BASE		(U8500_PER6_BASE + 0x8000) /* v1 */
-#define U8500_CRYPTO0_BASE	(U8500_PER6_BASE + 0xa000)
-#define U8500_CRYPTO1_BASE	(U8500_PER6_BASE + 0xb000)
+#define U8500_CRYP0_BASE	(U8500_PER6_BASE + 0xa000)
+#define U8500_CRYP1_BASE	(U8500_PER6_BASE + 0xb000)
 #define U8500_CLKRST6_BASE	(U8500_PER6_BASE + 0xf000)
 
 /* per5 base addresses */
@@ -93,7 +103,8 @@
 #define U8500_DMC_BASE		(U8500_PER4_BASE + 0x06000)
 #define U8500_PRCMU_BASE	(U8500_PER4_BASE + 0x07000)
 #define U8500_PRCMU_TCDM_BASE_V1 (U8500_PER4_BASE + 0x0f000)
-#define U8500_PRCMU_TCDM_BASE   (U8500_PER4_BASE + 0x68000)
+#define U8500_PRCMU_TCDM_BASE	(U8500_PER4_BASE + 0x68000)
+#define U8500_PRCMU_TCPM_BASE   (U8500_PER4_BASE + 0x60000)
 
 /* per3 base addresses */
 #define U8500_FSMC_BASE		(U8500_PER3_BASE + 0x0000)
@@ -124,6 +135,7 @@
 #define U8500_I2C1_BASE		(U8500_PER1_BASE + 0x2000)
 #define U8500_MSP0_BASE		(U8500_PER1_BASE + 0x3000)
 #define U8500_MSP1_BASE		(U8500_PER1_BASE + 0x4000)
+#define U8500_MSP3_BASE		(U8500_PER1_BASE + 0x5000)
 #define U8500_SDI0_BASE		(U8500_PER1_BASE + 0x6000)
 #define U8500_I2C2_BASE		(U8500_PER1_BASE + 0x8000)
 #define U8500_SPI3_BASE		(U8500_PER1_BASE + 0x9000)
@@ -143,4 +155,15 @@
 #define U8500_GPIOBANK7_BASE	(U8500_GPIO2_BASE + 0x80)
 #define U8500_GPIOBANK8_BASE	U8500_GPIO3_BASE
 
+#define U8500_MCDE_SIZE		0x1000
+#define U8500_DSI_LINK_SIZE	0x1000
+#define U8500_DSI_LINK1_BASE	(U8500_MCDE_BASE + U8500_MCDE_SIZE)
+#define U8500_DSI_LINK2_BASE	(U8500_DSI_LINK1_BASE + U8500_DSI_LINK_SIZE)
+#define U8500_DSI_LINK3_BASE	(U8500_DSI_LINK2_BASE + U8500_DSI_LINK_SIZE)
+#define U8500_DSI_LINK_COUNT	0x3
+
+/* Modem and APE physical addresses */
+#define U8500_MODEM_BASE	0xe000000
+#define U8500_APE_BASE		0x6000000
+
 #endif
-- 
1.7.4.4

