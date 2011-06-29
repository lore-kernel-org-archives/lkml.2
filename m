Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474Ab1F2QsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 12:48:00 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42307 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757436Ab1F2Qry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 12:47:54 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, nico@fluxnic.net,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 5/6] ARM: convert PCI defines to variables
Date: Wed, 29 Jun 2011 11:46:58 -0500
Message-Id: <1309366019-24379-6-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309366019-24379-1-git-send-email-robherring2@gmail.com>
References: <1309366019-24379-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Convert PCIBIOS_MIN_IO and PCIBIOS_MIN_MEM to variables to allow
multi-platform builds. This also removes the requirement for a platform to
have a mach/hardware.h.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>
---
 arch/arm/include/asm/pci.h                       |    6 ++++-
 arch/arm/mach-cns3xxx/include/mach/hardware.h    |   21 -----------------
 arch/arm/mach-dove/include/mach/hardware.h       |    2 -
 arch/arm/mach-dove/pcie.c                        |    2 +
 arch/arm/mach-footbridge/dc21285.c               |    3 ++
 arch/arm/mach-footbridge/include/mach/hardware.h |    3 --
 arch/arm/mach-integrator/include/mach/hardware.h |    3 --
 arch/arm/mach-integrator/pci_v3.c                |    3 ++
 arch/arm/mach-iop13xx/include/mach/hardware.h    |    5 ----
 arch/arm/mach-iop13xx/pci.c                      |    4 +--
 arch/arm/mach-iop32x/include/mach/hardware.h     |    2 -
 arch/arm/mach-iop33x/include/mach/hardware.h     |    2 -
 arch/arm/mach-ixp2000/include/mach/hardware.h    |    6 -----
 arch/arm/mach-ixp23xx/include/mach/hardware.h    |    2 -
 arch/arm/mach-ixp23xx/pci.c                      |    2 +
 arch/arm/mach-ixp4xx/common-pci.c                |    6 +++++
 arch/arm/mach-ixp4xx/include/mach/hardware.h     |    3 --
 arch/arm/mach-kirkwood/include/mach/hardware.h   |    1 -
 arch/arm/mach-kirkwood/pcie.c                    |    3 ++
 arch/arm/mach-ks8695/include/mach/hardware.h     |    7 -----
 arch/arm/mach-mv78xx0/include/mach/hardware.h    |    2 -
 arch/arm/mach-mv78xx0/pcie.c                     |    3 ++
 arch/arm/mach-orion5x/include/mach/hardware.h    |    2 -
 arch/arm/mach-orion5x/pci.c                      |    3 ++
 arch/arm/mach-pxa/include/mach/hardware.h        |    5 ----
 arch/arm/mach-sa1100/include/mach/hardware.h     |    7 -----
 arch/arm/mach-shark/include/mach/hardware.h      |    2 -
 arch/arm/mach-shark/pci.c                        |   10 ++++++-
 arch/arm/mach-tegra/include/mach/hardware.h      |   27 ----------------------
 arch/arm/mach-tegra/pcie.c                       |    2 +
 arch/arm/mach-versatile/include/mach/hardware.h  |    4 ---
 arch/arm/mach-versatile/pci.c                    |    3 ++
 arch/arm/mm/iomap.c                              |    7 +++++-
 33 files changed, 50 insertions(+), 113 deletions(-)
 delete mode 100644 arch/arm/mach-cns3xxx/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-tegra/include/mach/hardware.h

diff --git a/arch/arm/include/asm/pci.h b/arch/arm/include/asm/pci.h
index cb77e66..2b1f245 100644
--- a/arch/arm/include/asm/pci.h
+++ b/arch/arm/include/asm/pci.h
@@ -6,7 +6,11 @@
 #include <asm-generic/pci-bridge.h>
 
 #include <asm/mach/pci.h> /* for pci_sys_data */
-#include <mach/hardware.h> /* for PCIBIOS_MIN_* */
+
+extern unsigned long pcibios_min_io;
+#define PCIBIOS_MIN_IO pcibios_min_io
+extern unsigned long pcibios_min_mem;
+#define PCIBIOS_MIN_MEM pcibios_min_mem
 
 static inline int pcibios_assign_all_busses(void)
 {
diff --git a/arch/arm/mach-cns3xxx/include/mach/hardware.h b/arch/arm/mach-cns3xxx/include/mach/hardware.h
deleted file mode 100644
index 82a0d4e..0000000
--- a/arch/arm/mach-cns3xxx/include/mach/hardware.h
+++ /dev/null
@@ -1,21 +0,0 @@
-/*
- * This file contains the hardware definitions of the Cavium Networks boards.
- *
- * Copyright 2003 ARM Limited.
- * Copyright 2008 Cavium Networks
- *
- * This file is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License, Version 2, as
- * published by the Free Software Foundation.
- */
-
-#ifndef __MACH_HARDWARE_H
-#define __MACH_HARDWARE_H
-
-#include <asm/sizes.h>
-
-/* macro to get at IO space when running virtually */
-#define PCIBIOS_MIN_IO		0x00000000
-#define PCIBIOS_MIN_MEM		0x00000000
-
-#endif
diff --git a/arch/arm/mach-dove/include/mach/hardware.h b/arch/arm/mach-dove/include/mach/hardware.h
index f619fb9..94c5a2c 100644
--- a/arch/arm/mach-dove/include/mach/hardware.h
+++ b/arch/arm/mach-dove/include/mach/hardware.h
@@ -11,8 +11,6 @@
 
 #include "dove.h"
 
-#define PCIBIOS_MIN_IO			0x1000
-#define PCIBIOS_MIN_MEM			0x01000000
 #define PCIMEM_BASE			DOVE_PCIE0_MEM_PHYS_BASE
 
 
diff --git a/arch/arm/mach-dove/pcie.c b/arch/arm/mach-dove/pcie.c
index 502d1ca..4810426 100644
--- a/arch/arm/mach-dove/pcie.c
+++ b/arch/arm/mach-dove/pcie.c
@@ -228,6 +228,8 @@ static void __init add_pcie_port(int index, unsigned long base)
 
 void __init dove_pcie_init(int init_port0, int init_port1)
 {
+	pcibios_min_io = 0x1000;
+	pcibios_min_mem = 0x01000000;
 	if (init_port0)
 		add_pcie_port(0, DOVE_PCIE0_VIRT_BASE);
 
diff --git a/arch/arm/mach-footbridge/dc21285.c b/arch/arm/mach-footbridge/dc21285.c
index 3ffa548..e7ce279 100644
--- a/arch/arm/mach-footbridge/dc21285.c
+++ b/arch/arm/mach-footbridge/dc21285.c
@@ -295,6 +295,9 @@ void __init dc21285_preinit(void)
 	unsigned int mem_size, mem_mask;
 	int cfn_mode;
 
+	pcibios_min_io = 0x1000;
+	pcibios_min_mem = 0x81000000;
+
 	mem_size = (unsigned int)high_memory - PAGE_OFFSET;
 	for (mem_mask = 0x00100000; mem_mask < 0x10000000; mem_mask <<= 1)
 		if (mem_mask >= mem_size)
diff --git a/arch/arm/mach-footbridge/include/mach/hardware.h b/arch/arm/mach-footbridge/include/mach/hardware.h
index 082e6ce..15d5498 100644
--- a/arch/arm/mach-footbridge/include/mach/hardware.h
+++ b/arch/arm/mach-footbridge/include/mach/hardware.h
@@ -100,7 +100,4 @@ extern unsigned int nw_gpio_read(void);
 extern void nw_cpld_modify(unsigned int mask, unsigned int set);
 #endif
 
-#define PCIBIOS_MIN_IO		0x1000
-#define PCIBIOS_MIN_MEM 	0x81000000
-
 #endif
diff --git a/arch/arm/mach-integrator/include/mach/hardware.h b/arch/arm/mach-integrator/include/mach/hardware.h
index 37323ea..0ce5212 100644
--- a/arch/arm/mach-integrator/include/mach/hardware.h
+++ b/arch/arm/mach-integrator/include/mach/hardware.h
@@ -34,9 +34,6 @@
 
 #define PCIMEM_BASE		PCI_MEMORY_VADDR
 
-#define PCIBIOS_MIN_IO		0x6000
-#define PCIBIOS_MIN_MEM 	0x00100000
-
 /* macro to get at IO space when running virtually */
 #ifdef CONFIG_MMU
 #define IO_ADDRESS(x)	(((x) & 0x000fffff) | (((x) >> 4) & 0x0ff00000) | IO_BASE)
diff --git a/arch/arm/mach-integrator/pci_v3.c b/arch/arm/mach-integrator/pci_v3.c
index 6467d99..11b86e5 100644
--- a/arch/arm/mach-integrator/pci_v3.c
+++ b/arch/arm/mach-integrator/pci_v3.c
@@ -502,6 +502,9 @@ void __init pci_v3_preinit(void)
 	unsigned int temp;
 	int ret;
 
+	pcibios_min_io = 0x6000;
+	pcibios_min_mem = 0x00100000;
+
 	/*
 	 * Hook in our fault handler for PCI errors
 	 */
diff --git a/arch/arm/mach-iop13xx/include/mach/hardware.h b/arch/arm/mach-iop13xx/include/mach/hardware.h
index ba81e50..786fa26 100644
--- a/arch/arm/mach-iop13xx/include/mach/hardware.h
+++ b/arch/arm/mach-iop13xx/include/mach/hardware.h
@@ -3,15 +3,10 @@
 #include <asm/types.h>
 
 #ifndef __ASSEMBLY__
-extern unsigned long iop13xx_pcibios_min_io;
-extern unsigned long iop13xx_pcibios_min_mem;
 extern u16 iop13xx_dev_id(void);
 extern void iop13xx_set_atu_mmr_bases(void);
 #endif
 
-#define PCIBIOS_MIN_IO      (iop13xx_pcibios_min_io)
-#define PCIBIOS_MIN_MEM     (iop13xx_pcibios_min_mem)
-
 /*
  * Generic chipset bits
  *
diff --git a/arch/arm/mach-iop13xx/pci.c b/arch/arm/mach-iop13xx/pci.c
index ba3dae3..6027210 100644
--- a/arch/arm/mach-iop13xx/pci.c
+++ b/arch/arm/mach-iop13xx/pci.c
@@ -39,8 +39,6 @@ u32 iop13xx_atue_mem_base;
 u32 iop13xx_atux_mem_base;
 size_t iop13xx_atue_mem_size;
 size_t iop13xx_atux_mem_size;
-unsigned long iop13xx_pcibios_min_io = 0;
-unsigned long iop13xx_pcibios_min_mem = 0;
 
 EXPORT_SYMBOL(iop13xx_atue_mem_base);
 EXPORT_SYMBOL(iop13xx_atux_mem_base);
@@ -971,7 +969,7 @@ void __init iop13xx_pci_init(void)
 	__raw_writel(__raw_readl(IOP13XX_XBG_BECSR) & 3, IOP13XX_XBG_BECSR);
 
 	/* Setup the Min Address for PCI memory... */
-	iop13xx_pcibios_min_mem = IOP13XX_PCIX_LOWER_MEM_BA;
+	pcibios_min_mem = IOP13XX_PCIX_LOWER_MEM_BA;
 
 	/* if Linux is given control of an ATU
 	 * clear out its prior configuration,
diff --git a/arch/arm/mach-iop32x/include/mach/hardware.h b/arch/arm/mach-iop32x/include/mach/hardware.h
index e68bf97..48cb1b2 100644
--- a/arch/arm/mach-iop32x/include/mach/hardware.h
+++ b/arch/arm/mach-iop32x/include/mach/hardware.h
@@ -18,8 +18,6 @@
  * but when we read them, we convert them to virtual addresses. See
  * arch/arm/plat-iop/pci.c.
  */
-#define PCIBIOS_MIN_IO		0x00000000
-#define PCIBIOS_MIN_MEM		0x00000000
 
 #ifndef __ASSEMBLY__
 void iop32x_init_irq(void);
diff --git a/arch/arm/mach-iop33x/include/mach/hardware.h b/arch/arm/mach-iop33x/include/mach/hardware.h
index 215065b..8392853 100644
--- a/arch/arm/mach-iop33x/include/mach/hardware.h
+++ b/arch/arm/mach-iop33x/include/mach/hardware.h
@@ -18,8 +18,6 @@
  * but when we read them, we convert them to virtual addresses.  See
  * arch/arm/mach-iop3xx/iop3xx-pci.c
  */
-#define PCIBIOS_MIN_IO		0x00000000
-#define PCIBIOS_MIN_MEM		0x00000000
 
 #ifndef __ASSEMBLY__
 void iop33x_init_irq(void);
diff --git a/arch/arm/mach-ixp2000/include/mach/hardware.h b/arch/arm/mach-ixp2000/include/mach/hardware.h
index 6c92008..cdaf1db 100644
--- a/arch/arm/mach-ixp2000/include/mach/hardware.h
+++ b/arch/arm/mach-ixp2000/include/mach/hardware.h
@@ -19,12 +19,6 @@
 #ifndef __ASM_ARCH_HARDWARE_H__
 #define __ASM_ARCH_HARDWARE_H__
 
-/*
- * This needs to be platform-specific?
- */
-#define PCIBIOS_MIN_IO          0x00000000
-#define PCIBIOS_MIN_MEM         0x00000000
-
 #include "ixp2000-regs.h"	/* Chipset Registers */
 
 /*
diff --git a/arch/arm/mach-ixp23xx/include/mach/hardware.h b/arch/arm/mach-ixp23xx/include/mach/hardware.h
index b8bb781..60e55fa 100644
--- a/arch/arm/mach-ixp23xx/include/mach/hardware.h
+++ b/arch/arm/mach-ixp23xx/include/mach/hardware.h
@@ -15,8 +15,6 @@
 #define __ASM_ARCH_HARDWARE_H
 
 /* PCI IO info */
-#define PCIBIOS_MIN_IO		0x00000000
-#define PCIBIOS_MIN_MEM		0xe0000000
 
 #include "ixp23xx.h"
 
diff --git a/arch/arm/mach-ixp23xx/pci.c b/arch/arm/mach-ixp23xx/pci.c
index 72d145a..4913991 100644
--- a/arch/arm/mach-ixp23xx/pci.c
+++ b/arch/arm/mach-ixp23xx/pci.c
@@ -227,6 +227,8 @@ static void __init ixp23xx_pci_common_init(void)
 
 void __init ixp23xx_pci_preinit(void)
 {
+	pcibios_min_mem = 0xe0000000;
+
 	pci_set_flags(0);
 
 	ixp23xx_pci_common_init();
diff --git a/arch/arm/mach-ixp4xx/common-pci.c b/arch/arm/mach-ixp4xx/common-pci.c
index e9a5893..33e3bd8 100644
--- a/arch/arm/mach-ixp4xx/common-pci.c
+++ b/arch/arm/mach-ixp4xx/common-pci.c
@@ -346,6 +346,12 @@ void __init ixp4xx_pci_preinit(void)
 {
 	unsigned long cpuid = read_cpuid_id();
 
+	pcibios_min_io = 0x00001000;
+#ifdef CONFIG_IXP4XX_INDIRECT_PCI
+	pcibios_min_mem = 0x10000000; /* 1 GB of indirect PCI MMIO space */
+#else
+	pcibios_min_mem = 0x48000000; /* 64 MB of PCI MMIO space */
+#endif
 	/*
 	 * Determine which PCI read method to use.
 	 * Rev 0 IXP425 requires workaround.
diff --git a/arch/arm/mach-ixp4xx/include/mach/hardware.h b/arch/arm/mach-ixp4xx/include/mach/hardware.h
index a0921c6..034bb2a 100644
--- a/arch/arm/mach-ixp4xx/include/mach/hardware.h
+++ b/arch/arm/mach-ixp4xx/include/mach/hardware.h
@@ -17,12 +17,9 @@
 #ifndef __ASM_ARCH_HARDWARE_H__
 #define __ASM_ARCH_HARDWARE_H__
 
-#define PCIBIOS_MIN_IO		0x00001000
 #ifdef CONFIG_IXP4XX_INDIRECT_PCI
-#define PCIBIOS_MIN_MEM		0x10000000 /* 1 GB of indirect PCI MMIO space */
 #define PCIBIOS_MAX_MEM		0x4FFFFFFF
 #else
-#define PCIBIOS_MIN_MEM		0x48000000 /* 64 MB of PCI MMIO space */
 #define PCIBIOS_MAX_MEM		0x4BFFFFFF
 #endif
 
diff --git a/arch/arm/mach-kirkwood/include/mach/hardware.h b/arch/arm/mach-kirkwood/include/mach/hardware.h
index 31b81fe..470899b 100644
--- a/arch/arm/mach-kirkwood/include/mach/hardware.h
+++ b/arch/arm/mach-kirkwood/include/mach/hardware.h
@@ -11,7 +11,6 @@
 
 #include "kirkwood.h"
 
-#define PCIBIOS_MIN_MEM			0x01000000
 #define PCIMEM_BASE			KIRKWOOD_PCIE_MEM_PHYS_BASE /* mem base for VGA */
 
 
diff --git a/arch/arm/mach-kirkwood/pcie.c b/arch/arm/mach-kirkwood/pcie.c
index ca294ff..6e32b8a 100644
--- a/arch/arm/mach-kirkwood/pcie.c
+++ b/arch/arm/mach-kirkwood/pcie.c
@@ -271,6 +271,9 @@ static void __init add_pcie_port(int index, unsigned long base)
 
 void __init kirkwood_pcie_init(unsigned int portmask)
 {
+	pcibios_min_io = 0x00001000;
+	pcibios_min_mem = 0x01000000;
+
 	if (portmask & KW_PCIE0)
 		add_pcie_port(0, PCIE_VIRT_BASE);
 
diff --git a/arch/arm/mach-ks8695/include/mach/hardware.h b/arch/arm/mach-ks8695/include/mach/hardware.h
index a46be88..5e0c388 100644
--- a/arch/arm/mach-ks8695/include/mach/hardware.h
+++ b/arch/arm/mach-ks8695/include/mach/hardware.h
@@ -42,11 +42,4 @@
 #define KS8695_PCIIO_PA		0x80000000
 #define KS8695_PCIIO_SIZE	SZ_64K
 
-
-/*
- * PCI support
- */
-#define PCIBIOS_MIN_IO		0
-#define PCIBIOS_MIN_MEM		0
-
 #endif
diff --git a/arch/arm/mach-mv78xx0/include/mach/hardware.h b/arch/arm/mach-mv78xx0/include/mach/hardware.h
index c76b93f..29e37ed 100644
--- a/arch/arm/mach-mv78xx0/include/mach/hardware.h
+++ b/arch/arm/mach-mv78xx0/include/mach/hardware.h
@@ -11,8 +11,6 @@
 
 #include "mv78xx0.h"
 
-#define PCIBIOS_MIN_IO			0x00001000
-#define PCIBIOS_MIN_MEM			0x01000000
 #define PCIMEM_BASE			MV78XX0_PCIE_MEM_PHYS_BASE /* mem base for VGA */
 
 
diff --git a/arch/arm/mach-mv78xx0/pcie.c b/arch/arm/mach-mv78xx0/pcie.c
index a560439..cc9d1b9 100644
--- a/arch/arm/mach-mv78xx0/pcie.c
+++ b/arch/arm/mach-mv78xx0/pcie.c
@@ -297,6 +297,9 @@ static void __init add_pcie_port(int maj, int min, unsigned long base)
 
 void __init mv78xx0_pcie_init(int init_port0, int init_port1)
 {
+	pcibios_min_io = 0x00001000;
+	pcibios_min_mem = 0x01000000;
+
 	if (init_port0) {
 		add_pcie_port(0, 0, PCIE00_VIRT_BASE);
 		if (!orion_pcie_x4_mode((void __iomem *)PCIE00_VIRT_BASE)) {
diff --git a/arch/arm/mach-orion5x/include/mach/hardware.h b/arch/arm/mach-orion5x/include/mach/hardware.h
index a42b743..b6d55bc 100644
--- a/arch/arm/mach-orion5x/include/mach/hardware.h
+++ b/arch/arm/mach-orion5x/include/mach/hardware.h
@@ -11,8 +11,6 @@
 
 #include "orion5x.h"
 
-#define PCIBIOS_MIN_IO		0x00001000
-#define PCIBIOS_MIN_MEM		0x01000000
 #define PCIMEM_BASE		ORION5X_PCIE_MEM_PHYS_BASE
 
 
diff --git a/arch/arm/mach-orion5x/pci.c b/arch/arm/mach-orion5x/pci.c
index e8706f1..d80aeef 100644
--- a/arch/arm/mach-orion5x/pci.c
+++ b/arch/arm/mach-orion5x/pci.c
@@ -560,6 +560,9 @@ int __init orion5x_pci_sys_setup(int nr, struct pci_sys_data *sys)
 {
 	int ret = 0;
 
+	pcibios_min_io = 0x00001000;
+	pcibios_min_mem = 0x01000000;
+
 	if (nr == 0) {
 		orion_pcie_set_local_bus_nr(PCIE_BASE, sys->busnr);
 		ret = pcie_setup(sys);
diff --git a/arch/arm/mach-pxa/include/mach/hardware.h b/arch/arm/mach-pxa/include/mach/hardware.h
index bd6e928..e39e460 100644
--- a/arch/arm/mach-pxa/include/mach/hardware.h
+++ b/arch/arm/mach-pxa/include/mach/hardware.h
@@ -336,9 +336,4 @@ extern unsigned int get_memclk_frequency_10khz(void);
 extern unsigned long get_clock_tick_rate(void);
 #endif
 
-#if defined(CONFIG_MACH_ARMCORE) && defined(CONFIG_PCI)
-#define PCIBIOS_MIN_IO		0
-#define PCIBIOS_MIN_MEM		0
-#endif
-
 #endif  /* _ASM_ARCH_HARDWARE_H */
diff --git a/arch/arm/mach-sa1100/include/mach/hardware.h b/arch/arm/mach-sa1100/include/mach/hardware.h
index 5946af2..99f5856 100644
--- a/arch/arm/mach-sa1100/include/mach/hardware.h
+++ b/arch/arm/mach-sa1100/include/mach/hardware.h
@@ -76,11 +76,4 @@ static inline unsigned long get_clock_tick_rate(void)
 #include "SA-1101.h"
 #endif
 
-#if defined(CONFIG_ARCH_SA1100) && defined(CONFIG_PCI)
-#define PCIBIOS_MIN_IO		0
-#define PCIBIOS_MIN_MEM		0
-#define HAVE_ARCH_PCI_SET_DMA_MASK	1
-#endif
-
-
 #endif  /* _ASM_ARCH_HARDWARE_H */
diff --git a/arch/arm/mach-shark/include/mach/hardware.h b/arch/arm/mach-shark/include/mach/hardware.h
index 24639ce..4342931 100644
--- a/arch/arm/mach-shark/include/mach/hardware.h
+++ b/arch/arm/mach-shark/include/mach/hardware.h
@@ -12,8 +12,6 @@
 
 #define UNCACHEABLE_ADDR        0xdf010000
 
-#define PCIBIOS_MIN_IO          0x6000
-#define PCIBIOS_MIN_MEM         0x50000000
 #define PCIMEM_BASE		0xe8000000
 
 #endif
diff --git a/arch/arm/mach-shark/pci.c b/arch/arm/mach-shark/pci.c
index 89d175c..4aea637 100644
--- a/arch/arm/mach-shark/pci.c
+++ b/arch/arm/mach-shark/pci.c
@@ -37,8 +37,14 @@ static struct hw_pci shark_pci __initdata = {
 
 static int __init shark_pci_init(void)
 {
-	if (machine_is_shark())
-		pci_common_init(&shark_pci);
+	if (!machine_is_shark())
+		return;
+
+	pcibios_min_io = 0x6000;
+	pcibios_min_mem = 0x50000000;
+
+	pci_common_init(&shark_pci);
+
 	return 0;
 }
 
diff --git a/arch/arm/mach-tegra/include/mach/hardware.h b/arch/arm/mach-tegra/include/mach/hardware.h
deleted file mode 100644
index 84c2658..0000000
--- a/arch/arm/mach-tegra/include/mach/hardware.h
+++ /dev/null
@@ -1,27 +0,0 @@
-/*
- * arch/arm/mach-tegra/include/mach/hardware.h
- *
- * Copyright (C) 2010 Google, Inc.
- *
- * Author:
- *	Colin Cross <ccross@google.com>
- *	Erik Gilling <konkers@google.com>
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#ifndef __MACH_TEGRA_HARDWARE_H
-#define __MACH_TEGRA_HARDWARE_H
-
-#define PCIBIOS_MIN_IO			0x1000
-#define PCIBIOS_MIN_MEM			0
-
-#endif
diff --git a/arch/arm/mach-tegra/pcie.c b/arch/arm/mach-tegra/pcie.c
index 2941212..c4eba2c 100644
--- a/arch/arm/mach-tegra/pcie.c
+++ b/arch/arm/mach-tegra/pcie.c
@@ -912,6 +912,8 @@ int __init tegra_pcie_init(bool init_port0, bool init_port1)
 	if (!(init_port0 || init_port1))
 		return -ENODEV;
 
+	pcibios_min_io = 0x1000;
+
 	err = tegra_pcie_get_resources();
 	if (err)
 		return err;
diff --git a/arch/arm/mach-versatile/include/mach/hardware.h b/arch/arm/mach-versatile/include/mach/hardware.h
index 8f60e94..4d4973d 100644
--- a/arch/arm/mach-versatile/include/mach/hardware.h
+++ b/arch/arm/mach-versatile/include/mach/hardware.h
@@ -30,10 +30,6 @@
 #define VERSATILE_PCI_VIRT_BASE		(void __iomem *)0xe8000000ul
 #define VERSATILE_PCI_CFG_VIRT_BASE	(void __iomem *)0xe9000000ul
 
-/* CIK guesswork */
-#define PCIBIOS_MIN_IO			0x44000000
-#define PCIBIOS_MIN_MEM			0x50000000
-
 /* macro to get at IO space when running virtually */
 #define IO_ADDRESS(x)		(((x) & 0x0fffffff) + (((x) >> 4) & 0x0f000000) + 0xf0000000)
 
diff --git a/arch/arm/mach-versatile/pci.c b/arch/arm/mach-versatile/pci.c
index 13c7e5f..7848a17 100644
--- a/arch/arm/mach-versatile/pci.c
+++ b/arch/arm/mach-versatile/pci.c
@@ -311,6 +311,9 @@ struct pci_bus * __init pci_versatile_scan_bus(int nr, struct pci_sys_data *sys)
 
 void __init pci_versatile_preinit(void)
 {
+	pcibios_min_io = 0x44000000;
+	pcibios_min_mem = 0x50000000;
+
 	__raw_writel(VERSATILE_PCI_MEM_BASE0 >> 28, PCI_IMAP0);
 	__raw_writel(VERSATILE_PCI_MEM_BASE1 >> 28, PCI_IMAP1);
 	__raw_writel(VERSATILE_PCI_MEM_BASE2 >> 28, PCI_IMAP2);
diff --git a/arch/arm/mm/iomap.c b/arch/arm/mm/iomap.c
index ad41414..8946326 100644
--- a/arch/arm/mm/iomap.c
+++ b/arch/arm/mm/iomap.c
@@ -8,7 +8,6 @@
 #include <linux/pci.h>
 #include <linux/ioport.h>
 #include <linux/io.h>
-#include <asm/pci.h>
 
 #ifdef __io
 void __iomem *ioport_map(unsigned long port, unsigned int nr)
@@ -24,6 +23,12 @@ EXPORT_SYMBOL(ioport_unmap);
 #endif
 
 #ifdef CONFIG_PCI
+unsigned long pcibios_min_io;
+EXPORT_SYMBOL(pcibios_min_io);
+
+unsigned long pcibios_min_mem;
+EXPORT_SYMBOL(pcibios_min_mem);
+
 unsigned int pci_flags = PCI_REASSIGN_ALL_RSRC;
 EXPORT_SYMBOL(pci_flags);
 
-- 
1.7.4.1

