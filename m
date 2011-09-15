Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934879Ab1IOUOl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 16:14:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:46846 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934691Ab1IOUKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 16:10:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="48873427"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, ralf@linux-mips.org
Subject: [PATCH 06/27] Initconst section fixes for MIPS
Date: Thu, 15 Sep 2011 13:09:33 -0700
Message-Id: <1316117394-21666-7-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
References: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Cc: ralf@linux-mips.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/mips/bcm63xx/boards/board_bcm963xx.c |    2 +-
 arch/mips/bcm63xx/dev-pcmcia.c            |    2 +-
 arch/mips/mti-malta/malta-setup.c         |    2 +-
 arch/mips/pci/fixup-mpc30x.c              |    4 ++--
 arch/mips/pci/pci-octeon.c                |    2 +-
 arch/mips/powertv/asic/asic-calliope.c    |    2 +-
 arch/mips/powertv/asic/asic-cronus.c      |    2 +-
 arch/mips/powertv/asic/asic-gaia.c        |    2 +-
 arch/mips/powertv/asic/asic-zeus.c        |    2 +-
 9 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/mips/bcm63xx/boards/board_bcm963xx.c b/arch/mips/bcm63xx/boards/board_bcm963xx.c
index 40b223b..0d2b640 100644
--- a/arch/mips/bcm63xx/boards/board_bcm963xx.c
+++ b/arch/mips/bcm63xx/boards/board_bcm963xx.c
@@ -591,7 +591,7 @@ static struct board_info __initdata board_DWVS0 = {
 /*
  * all boards
  */
-static const struct board_info __initdata *bcm963xx_boards[] = {
+static const struct board_info __initconst *bcm963xx_boards[] = {
 #ifdef CONFIG_BCM63XX_CPU_6338
 	&board_96338gw,
 	&board_96338w,
diff --git a/arch/mips/bcm63xx/dev-pcmcia.c b/arch/mips/bcm63xx/dev-pcmcia.c
index de4d917..9b93880 100644
--- a/arch/mips/bcm63xx/dev-pcmcia.c
+++ b/arch/mips/bcm63xx/dev-pcmcia.c
@@ -79,7 +79,7 @@ static int __init config_pcmcia_cs(unsigned int cs,
 	return ret;
 }
 
-static const __initdata struct {
+static const __initconst struct {
 	unsigned int	cs;
 	unsigned int	base;
 	unsigned int	size;
diff --git a/arch/mips/mti-malta/malta-setup.c b/arch/mips/mti-malta/malta-setup.c
index b7f37d4..2e28f65 100644
--- a/arch/mips/mti-malta/malta-setup.c
+++ b/arch/mips/mti-malta/malta-setup.c
@@ -111,7 +111,7 @@ static void __init pci_clock_check(void)
 	unsigned int __iomem *jmpr_p =
 		(unsigned int *) ioremap(MALTA_JMPRS_REG, sizeof(unsigned int));
 	int jmpr = (__raw_readl(jmpr_p) >> 2) & 0x07;
-	static const int pciclocks[] __initdata = {
+	static const int pciclocks[] __initconst = {
 		33, 20, 25, 30, 12, 16, 37, 10
 	};
 	int pciclock = pciclocks[jmpr];
diff --git a/arch/mips/pci/fixup-mpc30x.c b/arch/mips/pci/fixup-mpc30x.c
index e08f49c..8e4f828 100644
--- a/arch/mips/pci/fixup-mpc30x.c
+++ b/arch/mips/pci/fixup-mpc30x.c
@@ -22,13 +22,13 @@
 
 #include <asm/vr41xx/mpc30x.h>
 
-static const int internal_func_irqs[] __initdata = {
+static const int internal_func_irqs[] __initconst = {
 	VRC4173_CASCADE_IRQ,
 	VRC4173_AC97_IRQ,
 	VRC4173_USB_IRQ,
 };
 
-static const int irq_tab_mpc30x[] __initdata = {
+static const int irq_tab_mpc30x[] __initconst = {
  [12] = VRC4173_PCMCIA1_IRQ,
  [13] = VRC4173_PCMCIA2_IRQ,
  [29] = MQ200_IRQ,
diff --git a/arch/mips/pci/pci-octeon.c b/arch/mips/pci/pci-octeon.c
index ed1c542..0c71291 100644
--- a/arch/mips/pci/pci-octeon.c
+++ b/arch/mips/pci/pci-octeon.c
@@ -58,7 +58,7 @@ union octeon_pci_address {
 	} s;
 };
 
-int __initdata (*octeon_pcibios_map_irq)(const struct pci_dev *dev,
+int __initconst (*octeon_pcibios_map_irq)(const struct pci_dev *dev,
 					 u8 slot, u8 pin);
 enum octeon_dma_bar_type octeon_dma_bar_type = OCTEON_DMA_BAR_TYPE_INVALID;
 
diff --git a/arch/mips/powertv/asic/asic-calliope.c b/arch/mips/powertv/asic/asic-calliope.c
index 0a170e0..7773f3d 100644
--- a/arch/mips/powertv/asic/asic-calliope.c
+++ b/arch/mips/powertv/asic/asic-calliope.c
@@ -28,7 +28,7 @@
 
 #define CALLIOPE_ADDR(x)	(CALLIOPE_IO_BASE + (x))
 
-const struct register_map calliope_register_map __initdata = {
+const struct register_map calliope_register_map __initconst = {
 	.eic_slow0_strt_add = {.phys = CALLIOPE_ADDR(0x800000)},
 	.eic_cfg_bits = {.phys = CALLIOPE_ADDR(0x800038)},
 	.eic_ready_status = {.phys = CALLIOPE_ADDR(0x80004c)},
diff --git a/arch/mips/powertv/asic/asic-cronus.c b/arch/mips/powertv/asic/asic-cronus.c
index bbc0c12..da076db 100644
--- a/arch/mips/powertv/asic/asic-cronus.c
+++ b/arch/mips/powertv/asic/asic-cronus.c
@@ -28,7 +28,7 @@
 
 #define CRONUS_ADDR(x)	(CRONUS_IO_BASE + (x))
 
-const struct register_map cronus_register_map __initdata = {
+const struct register_map cronus_register_map __initconst = {
 	.eic_slow0_strt_add = {.phys = CRONUS_ADDR(0x000000)},
 	.eic_cfg_bits = {.phys = CRONUS_ADDR(0x000038)},
 	.eic_ready_status = {.phys = CRONUS_ADDR(0x00004C)},
diff --git a/arch/mips/powertv/asic/asic-gaia.c b/arch/mips/powertv/asic/asic-gaia.c
index 91dda68..47683b3 100644
--- a/arch/mips/powertv/asic/asic-gaia.c
+++ b/arch/mips/powertv/asic/asic-gaia.c
@@ -23,7 +23,7 @@
 #include <linux/init.h>
 #include <asm/mach-powertv/asic.h>
 
-const struct register_map gaia_register_map __initdata = {
+const struct register_map gaia_register_map __initconst = {
 	.eic_slow0_strt_add = {.phys = GAIA_IO_BASE + 0x000000},
 	.eic_cfg_bits = {.phys = GAIA_IO_BASE + 0x000038},
 	.eic_ready_status = {.phys = GAIA_IO_BASE + 0x00004C},
diff --git a/arch/mips/powertv/asic/asic-zeus.c b/arch/mips/powertv/asic/asic-zeus.c
index 4a05bb0..6ff4b10 100644
--- a/arch/mips/powertv/asic/asic-zeus.c
+++ b/arch/mips/powertv/asic/asic-zeus.c
@@ -28,7 +28,7 @@
 
 #define ZEUS_ADDR(x)	(ZEUS_IO_BASE + (x))
 
-const struct register_map zeus_register_map __initdata = {
+const struct register_map zeus_register_map __initconst = {
 	.eic_slow0_strt_add = {.phys = ZEUS_ADDR(0x000000)},
 	.eic_cfg_bits = {.phys = ZEUS_ADDR(0x000038)},
 	.eic_ready_status = {.phys = ZEUS_ADDR(0x00004c)},
-- 
1.7.4.4

