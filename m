Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463Ab1F2Qsj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 12:48:39 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39893 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757242Ab1F2Qrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 12:47:52 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, nico@fluxnic.net,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 4/6] ARM: pci: make pcibios_assign_all_busses use pci_has_flag
Date: Wed, 29 Jun 2011 11:46:57 -0500
Message-Id: <1309366019-24379-5-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309366019-24379-1-git-send-email-robherring2@gmail.com>
References: <1309366019-24379-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Convert pcibios_assign_all_busses from a define to inline so platforms can
control this setting.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>
---
 arch/arm/include/asm/pci.h                       |    6 ++++++
 arch/arm/mach-bcmring/include/mach/hardware.h    |    2 --
 arch/arm/mach-cns3xxx/include/mach/hardware.h    |    1 -
 arch/arm/mach-dove/include/mach/hardware.h       |    2 --
 arch/arm/mach-ep93xx/include/mach/hardware.h     |    2 --
 arch/arm/mach-footbridge/include/mach/hardware.h |    2 --
 arch/arm/mach-integrator/include/mach/hardware.h |    2 --
 arch/arm/mach-iop13xx/include/mach/hardware.h    |    2 --
 arch/arm/mach-iop32x/include/mach/hardware.h     |    1 -
 arch/arm/mach-iop33x/include/mach/hardware.h     |    1 -
 arch/arm/mach-ixp2000/include/mach/hardware.h    |    2 --
 arch/arm/mach-ixp2000/pci.c                      |    2 ++
 arch/arm/mach-ixp23xx/include/mach/hardware.h    |    2 --
 arch/arm/mach-ixp23xx/pci.c                      |    2 ++
 arch/arm/mach-ixp4xx/include/mach/hardware.h     |    2 --
 arch/arm/mach-kirkwood/include/mach/hardware.h   |    3 ---
 arch/arm/mach-ks8695/include/mach/hardware.h     |    2 --
 arch/arm/mach-mv78xx0/include/mach/hardware.h    |    2 --
 arch/arm/mach-orion5x/include/mach/hardware.h    |    2 --
 arch/arm/mach-pxa/include/mach/hardware.h        |    1 -
 arch/arm/mach-sa1100/include/mach/hardware.h     |    1 -
 arch/arm/mach-shark/include/mach/hardware.h      |    2 --
 arch/arm/mach-tegra/include/mach/hardware.h      |    1 -
 arch/arm/mach-versatile/include/mach/hardware.h  |    2 --
 arch/arm/mm/iomap.c                              |    4 ++++
 25 files changed, 14 insertions(+), 37 deletions(-)

diff --git a/arch/arm/include/asm/pci.h b/arch/arm/include/asm/pci.h
index 92e2a83..cb77e66 100644
--- a/arch/arm/include/asm/pci.h
+++ b/arch/arm/include/asm/pci.h
@@ -3,10 +3,16 @@
 
 #ifdef __KERNEL__
 #include <asm-generic/pci-dma-compat.h>
+#include <asm-generic/pci-bridge.h>
 
 #include <asm/mach/pci.h> /* for pci_sys_data */
 #include <mach/hardware.h> /* for PCIBIOS_MIN_* */
 
+static inline int pcibios_assign_all_busses(void)
+{
+	return pci_has_flag(PCI_REASSIGN_ALL_RSRC);
+}
+
 #ifdef CONFIG_PCI_DOMAINS
 static inline int pci_domain_nr(struct pci_bus *bus)
 {
diff --git a/arch/arm/mach-bcmring/include/mach/hardware.h b/arch/arm/mach-bcmring/include/mach/hardware.h
index 8bf3564..ed78aab 100644
--- a/arch/arm/mach-bcmring/include/mach/hardware.h
+++ b/arch/arm/mach-bcmring/include/mach/hardware.h
@@ -36,8 +36,6 @@
 #define RAM_SIZE                (CFG_GLOBAL_RAM_SIZE-CFG_GLOBAL_RAM_SIZE_RESERVED)
 #define RAM_BASE                PAGE_OFFSET
 
-#define pcibios_assign_all_busses()	1
-
 /* Macros to make managing spinlocks a bit more controlled in terms of naming. */
 /* See reg_gpio.h, reg_irq.h, arch.c, gpio.c for example usage. */
 #if defined(__KERNEL__)
diff --git a/arch/arm/mach-cns3xxx/include/mach/hardware.h b/arch/arm/mach-cns3xxx/include/mach/hardware.h
index 57e0983..82a0d4e 100644
--- a/arch/arm/mach-cns3xxx/include/mach/hardware.h
+++ b/arch/arm/mach-cns3xxx/include/mach/hardware.h
@@ -17,6 +17,5 @@
 /* macro to get at IO space when running virtually */
 #define PCIBIOS_MIN_IO		0x00000000
 #define PCIBIOS_MIN_MEM		0x00000000
-#define pcibios_assign_all_busses()	1
 
 #endif
diff --git a/arch/arm/mach-dove/include/mach/hardware.h b/arch/arm/mach-dove/include/mach/hardware.h
index 32b0826..f619fb9 100644
--- a/arch/arm/mach-dove/include/mach/hardware.h
+++ b/arch/arm/mach-dove/include/mach/hardware.h
@@ -11,8 +11,6 @@
 
 #include "dove.h"
 
-#define pcibios_assign_all_busses()	1
-
 #define PCIBIOS_MIN_IO			0x1000
 #define PCIBIOS_MIN_MEM			0x01000000
 #define PCIMEM_BASE			DOVE_PCIE0_MEM_PHYS_BASE
diff --git a/arch/arm/mach-ep93xx/include/mach/hardware.h b/arch/arm/mach-ep93xx/include/mach/hardware.h
index 5a3ce02..4df8428 100644
--- a/arch/arm/mach-ep93xx/include/mach/hardware.h
+++ b/arch/arm/mach-ep93xx/include/mach/hardware.h
@@ -8,8 +8,6 @@
 #include <mach/ep93xx-regs.h>
 #include <mach/platform.h>
 
-#define pcibios_assign_all_busses()	0
-
 /*
  * The EP93xx has two external crystal oscillators.  To generate the
  * required high-frequency clocks, the processor uses two phase-locked-
diff --git a/arch/arm/mach-footbridge/include/mach/hardware.h b/arch/arm/mach-footbridge/include/mach/hardware.h
index b6fdf23..082e6ce 100644
--- a/arch/arm/mach-footbridge/include/mach/hardware.h
+++ b/arch/arm/mach-footbridge/include/mach/hardware.h
@@ -100,8 +100,6 @@ extern unsigned int nw_gpio_read(void);
 extern void nw_cpld_modify(unsigned int mask, unsigned int set);
 #endif
 
-#define pcibios_assign_all_busses()	1
-
 #define PCIBIOS_MIN_IO		0x1000
 #define PCIBIOS_MIN_MEM 	0x81000000
 
diff --git a/arch/arm/mach-integrator/include/mach/hardware.h b/arch/arm/mach-integrator/include/mach/hardware.h
index 57f51ba..37323ea 100644
--- a/arch/arm/mach-integrator/include/mach/hardware.h
+++ b/arch/arm/mach-integrator/include/mach/hardware.h
@@ -34,8 +34,6 @@
 
 #define PCIMEM_BASE		PCI_MEMORY_VADDR
 
-#define pcibios_assign_all_busses()	1
-
 #define PCIBIOS_MIN_IO		0x6000
 #define PCIBIOS_MIN_MEM 	0x00100000
 
diff --git a/arch/arm/mach-iop13xx/include/mach/hardware.h b/arch/arm/mach-iop13xx/include/mach/hardware.h
index 8e1d562..ba81e50 100644
--- a/arch/arm/mach-iop13xx/include/mach/hardware.h
+++ b/arch/arm/mach-iop13xx/include/mach/hardware.h
@@ -2,8 +2,6 @@
 #define __ASM_ARCH_HARDWARE_H
 #include <asm/types.h>
 
-#define pcibios_assign_all_busses() 1
-
 #ifndef __ASSEMBLY__
 extern unsigned long iop13xx_pcibios_min_io;
 extern unsigned long iop13xx_pcibios_min_mem;
diff --git a/arch/arm/mach-iop32x/include/mach/hardware.h b/arch/arm/mach-iop32x/include/mach/hardware.h
index d559c4e..e68bf97 100644
--- a/arch/arm/mach-iop32x/include/mach/hardware.h
+++ b/arch/arm/mach-iop32x/include/mach/hardware.h
@@ -18,7 +18,6 @@
  * but when we read them, we convert them to virtual addresses. See
  * arch/arm/plat-iop/pci.c.
  */
-#define pcibios_assign_all_busses() 1
 #define PCIBIOS_MIN_IO		0x00000000
 #define PCIBIOS_MIN_MEM		0x00000000
 
diff --git a/arch/arm/mach-iop33x/include/mach/hardware.h b/arch/arm/mach-iop33x/include/mach/hardware.h
index 8c10e43..215065b 100644
--- a/arch/arm/mach-iop33x/include/mach/hardware.h
+++ b/arch/arm/mach-iop33x/include/mach/hardware.h
@@ -18,7 +18,6 @@
  * but when we read them, we convert them to virtual addresses.  See
  * arch/arm/mach-iop3xx/iop3xx-pci.c
  */
-#define pcibios_assign_all_busses()	1
 #define PCIBIOS_MIN_IO		0x00000000
 #define PCIBIOS_MIN_MEM		0x00000000
 
diff --git a/arch/arm/mach-ixp2000/include/mach/hardware.h b/arch/arm/mach-ixp2000/include/mach/hardware.h
index f033de4..6c92008 100644
--- a/arch/arm/mach-ixp2000/include/mach/hardware.h
+++ b/arch/arm/mach-ixp2000/include/mach/hardware.h
@@ -27,8 +27,6 @@
 
 #include "ixp2000-regs.h"	/* Chipset Registers */
 
-#define pcibios_assign_all_busses() 0
-
 /*
  * Platform helper functions
  */
diff --git a/arch/arm/mach-ixp2000/pci.c b/arch/arm/mach-ixp2000/pci.c
index f797c5f..8888ed9 100644
--- a/arch/arm/mach-ixp2000/pci.c
+++ b/arch/arm/mach-ixp2000/pci.c
@@ -196,6 +196,8 @@ clear_master_aborts(void)
 void __init
 ixp2000_pci_preinit(void)
 {
+	pci_set_flags(0);
+
 #ifndef CONFIG_IXP2000_SUPPORT_BROKEN_PCI_IO
 	/*
 	 * Configure the PCI unit to properly byteswap I/O transactions,
diff --git a/arch/arm/mach-ixp23xx/include/mach/hardware.h b/arch/arm/mach-ixp23xx/include/mach/hardware.h
index 57b508b..b8bb781 100644
--- a/arch/arm/mach-ixp23xx/include/mach/hardware.h
+++ b/arch/arm/mach-ixp23xx/include/mach/hardware.h
@@ -20,8 +20,6 @@
 
 #include "ixp23xx.h"
 
-#define pcibios_assign_all_busses()	0
-
 /*
  * Platform helper functions
  */
diff --git a/arch/arm/mach-ixp23xx/pci.c b/arch/arm/mach-ixp23xx/pci.c
index 563819a..72d145a 100644
--- a/arch/arm/mach-ixp23xx/pci.c
+++ b/arch/arm/mach-ixp23xx/pci.c
@@ -227,6 +227,8 @@ static void __init ixp23xx_pci_common_init(void)
 
 void __init ixp23xx_pci_preinit(void)
 {
+	pci_set_flags(0);
+
 	ixp23xx_pci_common_init();
 
 	hook_fault_code(16+6, ixp23xx_pci_abort_handler, SIGBUS, 0,
diff --git a/arch/arm/mach-ixp4xx/include/mach/hardware.h b/arch/arm/mach-ixp4xx/include/mach/hardware.h
index f91ca6d..a0921c6 100644
--- a/arch/arm/mach-ixp4xx/include/mach/hardware.h
+++ b/arch/arm/mach-ixp4xx/include/mach/hardware.h
@@ -26,8 +26,6 @@
 #define PCIBIOS_MAX_MEM		0x4BFFFFFF
 #endif
 
-#define pcibios_assign_all_busses()	1
-
 /* Register locations and bits */
 #include "ixp4xx-regs.h"
 
diff --git a/arch/arm/mach-kirkwood/include/mach/hardware.h b/arch/arm/mach-kirkwood/include/mach/hardware.h
index cde8528..31b81fe 100644
--- a/arch/arm/mach-kirkwood/include/mach/hardware.h
+++ b/arch/arm/mach-kirkwood/include/mach/hardware.h
@@ -11,9 +11,6 @@
 
 #include "kirkwood.h"
 
-#define pcibios_assign_all_busses()	1
-
-#define PCIBIOS_MIN_IO			0x00001000
 #define PCIBIOS_MIN_MEM			0x01000000
 #define PCIMEM_BASE			KIRKWOOD_PCIE_MEM_PHYS_BASE /* mem base for VGA */
 
diff --git a/arch/arm/mach-ks8695/include/mach/hardware.h b/arch/arm/mach-ks8695/include/mach/hardware.h
index e0f911d..a46be88 100644
--- a/arch/arm/mach-ks8695/include/mach/hardware.h
+++ b/arch/arm/mach-ks8695/include/mach/hardware.h
@@ -46,8 +46,6 @@
 /*
  * PCI support
  */
-#define pcibios_assign_all_busses()	1
-
 #define PCIBIOS_MIN_IO		0
 #define PCIBIOS_MIN_MEM		0
 
diff --git a/arch/arm/mach-mv78xx0/include/mach/hardware.h b/arch/arm/mach-mv78xx0/include/mach/hardware.h
index 5d88755..c76b93f 100644
--- a/arch/arm/mach-mv78xx0/include/mach/hardware.h
+++ b/arch/arm/mach-mv78xx0/include/mach/hardware.h
@@ -11,8 +11,6 @@
 
 #include "mv78xx0.h"
 
-#define pcibios_assign_all_busses()	1
-
 #define PCIBIOS_MIN_IO			0x00001000
 #define PCIBIOS_MIN_MEM			0x01000000
 #define PCIMEM_BASE			MV78XX0_PCIE_MEM_PHYS_BASE /* mem base for VGA */
diff --git a/arch/arm/mach-orion5x/include/mach/hardware.h b/arch/arm/mach-orion5x/include/mach/hardware.h
index e51aaf4..a42b743 100644
--- a/arch/arm/mach-orion5x/include/mach/hardware.h
+++ b/arch/arm/mach-orion5x/include/mach/hardware.h
@@ -11,8 +11,6 @@
 
 #include "orion5x.h"
 
-#define pcibios_assign_all_busses()	1
-
 #define PCIBIOS_MIN_IO		0x00001000
 #define PCIBIOS_MIN_MEM		0x01000000
 #define PCIMEM_BASE		ORION5X_PCIE_MEM_PHYS_BASE
diff --git a/arch/arm/mach-pxa/include/mach/hardware.h b/arch/arm/mach-pxa/include/mach/hardware.h
index 313051c..bd6e928 100644
--- a/arch/arm/mach-pxa/include/mach/hardware.h
+++ b/arch/arm/mach-pxa/include/mach/hardware.h
@@ -339,7 +339,6 @@ extern unsigned long get_clock_tick_rate(void);
 #if defined(CONFIG_MACH_ARMCORE) && defined(CONFIG_PCI)
 #define PCIBIOS_MIN_IO		0
 #define PCIBIOS_MIN_MEM		0
-#define pcibios_assign_all_busses()	1
 #endif
 
 #endif  /* _ASM_ARCH_HARDWARE_H */
diff --git a/arch/arm/mach-sa1100/include/mach/hardware.h b/arch/arm/mach-sa1100/include/mach/hardware.h
index 967ae76..5946af2 100644
--- a/arch/arm/mach-sa1100/include/mach/hardware.h
+++ b/arch/arm/mach-sa1100/include/mach/hardware.h
@@ -79,7 +79,6 @@ static inline unsigned long get_clock_tick_rate(void)
 #if defined(CONFIG_ARCH_SA1100) && defined(CONFIG_PCI)
 #define PCIBIOS_MIN_IO		0
 #define PCIBIOS_MIN_MEM		0
-#define pcibios_assign_all_busses()	1
 #define HAVE_ARCH_PCI_SET_DMA_MASK	1
 #endif
 
diff --git a/arch/arm/mach-shark/include/mach/hardware.h b/arch/arm/mach-shark/include/mach/hardware.h
index 94d84b2..24639ce 100644
--- a/arch/arm/mach-shark/include/mach/hardware.h
+++ b/arch/arm/mach-shark/include/mach/hardware.h
@@ -12,8 +12,6 @@
 
 #define UNCACHEABLE_ADDR        0xdf010000
 
-#define pcibios_assign_all_busses()     1
-
 #define PCIBIOS_MIN_IO          0x6000
 #define PCIBIOS_MIN_MEM         0x50000000
 #define PCIMEM_BASE		0xe8000000
diff --git a/arch/arm/mach-tegra/include/mach/hardware.h b/arch/arm/mach-tegra/include/mach/hardware.h
index 56e43b3..84c2658 100644
--- a/arch/arm/mach-tegra/include/mach/hardware.h
+++ b/arch/arm/mach-tegra/include/mach/hardware.h
@@ -23,6 +23,5 @@
 
 #define PCIBIOS_MIN_IO			0x1000
 #define PCIBIOS_MIN_MEM			0
-#define pcibios_assign_all_busses()	1
 
 #endif
diff --git a/arch/arm/mach-versatile/include/mach/hardware.h b/arch/arm/mach-versatile/include/mach/hardware.h
index 6911e1f..8f60e94 100644
--- a/arch/arm/mach-versatile/include/mach/hardware.h
+++ b/arch/arm/mach-versatile/include/mach/hardware.h
@@ -34,8 +34,6 @@
 #define PCIBIOS_MIN_IO			0x44000000
 #define PCIBIOS_MIN_MEM			0x50000000
 
-#define pcibios_assign_all_busses()     1
-
 /* macro to get at IO space when running virtually */
 #define IO_ADDRESS(x)		(((x) & 0x0fffffff) + (((x) >> 4) & 0x0f000000) + 0xf0000000)
 
diff --git a/arch/arm/mm/iomap.c b/arch/arm/mm/iomap.c
index ffad039..ad41414 100644
--- a/arch/arm/mm/iomap.c
+++ b/arch/arm/mm/iomap.c
@@ -8,6 +8,7 @@
 #include <linux/pci.h>
 #include <linux/ioport.h>
 #include <linux/io.h>
+#include <asm/pci.h>
 
 #ifdef __io
 void __iomem *ioport_map(unsigned long port, unsigned int nr)
@@ -23,6 +24,9 @@ EXPORT_SYMBOL(ioport_unmap);
 #endif
 
 #ifdef CONFIG_PCI
+unsigned int pci_flags = PCI_REASSIGN_ALL_RSRC;
+EXPORT_SYMBOL(pci_flags);
+
 void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 {
 	resource_size_t start = pci_resource_start(dev, bar);
-- 
1.7.4.1

