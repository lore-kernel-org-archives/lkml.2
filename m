Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab1AFKIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 05:08:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44361 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469Ab1AFKID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 05:08:03 -0500
Date: Thu, 6 Jan 2011 11:07:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/platform changes for v2.6.38
Message-ID: <20110106100748.GA19207@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-platform-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-platform-for-linus


out-of-topic modifications in x86-platform-for-linus:
-----------------------------------------------------
drivers/platform/x86/intel_scu_ipc.c# 1da4b1c: x86/mrst: Add SFI platform device
drivers/rtc/Kconfig                # 0146f26: rtc: Add drivers/rtc/rtc-mrst.c
drivers/rtc/Makefile               # 0146f26: rtc: Add drivers/rtc/rtc-mrst.c
drivers/rtc/rtc-mrst.c             # d3e1884: x86, mrst: Add explanation for us
                                   # 0146f26: rtc: Add drivers/rtc/rtc-mrst.c
include/linux/sfi.h                # 1da4b1c: x86/mrst: Add SFI platform device

 Thanks,

	Ingo

------------------>
Alan Cox (1):
      x86, mrst: The shutdown for MRST requires the SCU IPC mechanism

Alek Du (1):
      x86: mrst: Add Moorestown specific reboot/shutdown support

Dirk Brandewie (3):
      ce4100: Add PCI register emulation for CE4100
      x86: Ce4100: Add reboot_fixup() for CE4100
      ce4100: Add errata fixes for UART on CE4100

Feng Tang (7):
      x86/mrst: Add SFI platform device parsing code
      x86: mrst: Add vrtc driver which serves as a wall clock device
      rtc: Add drivers/rtc/rtc-mrst.c
      x86: mrst: Set vRTC's IRQ to level trigger type
      x86, mrst: Add explanation for using 1960 as the year offset for vrtc
      x86, apbt: Setup affinity for apb timers acting as per-cpu timer
      x86, earlyprintk: Move mrst early console to platform/ and fix a typo

Jacob Pan (1):
      x86: mrst: Parse SFI timer table for all timer configs

Randy Dunlap (1):
      x86, mrst: Fix dependencies of "select INTEL_SCU_IPC"

Shérab (1):
      x86/platform: Add Eurobraille/Iris power off support

Thomas Gleixner (2):
      x86: Add CE4100 platform support
      x86: platform: Move iris to x86/platform where it belongs

Vasiliy Kulikov (1):
      x86, mrst: Check platform_device_register() return code

Vinod Koul (1):
      x86: mrst: Add audio driver bindings


 Documentation/x86/boot.txt                         |    1 +
 arch/x86/Kconfig                                   |   29 +
 arch/x86/include/asm/bootparam.h                   |    1 +
 arch/x86/include/asm/fixmap.h                      |    4 +
 arch/x86/include/asm/mrst-vrtc.h                   |    9 +
 arch/x86/include/asm/mrst.h                        |   14 +-
 arch/x86/include/asm/setup.h                       |    6 +
 arch/x86/kernel/Makefile                           |    1 -
 arch/x86/kernel/apb_timer.c                        |    1 +
 arch/x86/kernel/early_printk.c                     |    3 +-
 arch/x86/kernel/head32.c                           |    3 +
 arch/x86/kernel/reboot_fixups_32.c                 |   16 +
 arch/x86/pci/Makefile                              |    1 +
 arch/x86/pci/ce4100.c                              |  315 +++++++++++
 arch/x86/platform/Makefile                         |    2 +
 arch/x86/platform/ce4100/Makefile                  |    1 +
 arch/x86/platform/ce4100/ce4100.c                  |  132 +++++
 arch/x86/platform/iris/Makefile                    |    1 +
 arch/x86/platform/iris/iris.c                      |   91 +++
 arch/x86/platform/mrst/Makefile                    |    2 +
 .../{kernel => platform/mrst}/early_printk_mrst.c  |    0
 arch/x86/platform/mrst/mrst.c                      |  546 ++++++++++++++++++-
 arch/x86/platform/mrst/vrtc.c                      |  165 ++++++
 drivers/platform/x86/intel_scu_ipc.c               |    5 +
 drivers/rtc/Kconfig                                |   12 +
 drivers/rtc/Makefile                               |    1 +
 drivers/rtc/rtc-mrst.c                             |  582 ++++++++++++++++++++
 include/linux/sfi.h                                |    8 +-
 28 files changed, 1934 insertions(+), 18 deletions(-)
 create mode 100644 arch/x86/include/asm/mrst-vrtc.h
 create mode 100644 arch/x86/pci/ce4100.c
 create mode 100644 arch/x86/platform/ce4100/Makefile
 create mode 100644 arch/x86/platform/ce4100/ce4100.c
 create mode 100644 arch/x86/platform/iris/Makefile
 create mode 100644 arch/x86/platform/iris/iris.c
 rename arch/x86/{kernel => platform/mrst}/early_printk_mrst.c (100%)
 create mode 100644 arch/x86/platform/mrst/vrtc.c
 create mode 100644 drivers/rtc/rtc-mrst.c

diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
index 30b43e1..bdeb81c 100644
--- a/Documentation/x86/boot.txt
+++ b/Documentation/x86/boot.txt
@@ -600,6 +600,7 @@ Protocol:	2.07+
   0x00000001	lguest
   0x00000002	Xen
   0x00000003	Moorestown MID
+  0x00000004	CE4100 TV Platform
 
 Field name:	hardware_subarch_data
 Type:		write (subarch-dependent)
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e832768..6ab6310 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -377,6 +377,18 @@ config X86_ELAN
 
 	  If unsure, choose "PC-compatible" instead.
 
+config X86_INTEL_CE
+	bool "CE4100 TV platform"
+	depends on PCI
+	depends on PCI_GODIRECT
+	depends on X86_32
+	depends on X86_EXTENDED_PLATFORM
+	select X86_REBOOTFIXUPS
+	---help---
+	  Select for the Intel CE media processor (CE4100) SOC.
+	  This option compiles in support for the CE4100 SOC for settop
+	  boxes and media devices.
+
 config X86_MRST
        bool "Moorestown MID platform"
 	depends on PCI
@@ -385,6 +397,10 @@ config X86_MRST
 	depends on X86_EXTENDED_PLATFORM
 	depends on X86_IO_APIC
 	select APB_TIMER
+	select I2C
+	select SPI
+	select INTEL_SCU_IPC
+	select X86_PLATFORM_DEVICES
 	---help---
 	  Moorestown is Intel's Low Power Intel Architecture (LPIA) based Moblin
 	  Internet Device(MID) platform. Moorestown consists of two chips:
@@ -466,6 +482,19 @@ config X86_ES7000
 	  Support for Unisys ES7000 systems.  Say 'Y' here if this kernel is
 	  supposed to run on an IA32-based Unisys ES7000 system.
 
+config X86_32_IRIS
+	tristate "Eurobraille/Iris poweroff module"
+	depends on X86_32
+	---help---
+	  The Iris machines from EuroBraille do not have APM or ACPI support
+	  to shut themselves down properly.  A special I/O sequence is
+	  needed to do so, which is what this module does at
+	  kernel shutdown.
+
+	  This is only for Iris machines from EuroBraille.
+
+	  If unused, say N.
+
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y
 	prompt "Single-depth WCHAN output"
diff --git a/arch/x86/include/asm/bootparam.h b/arch/x86/include/asm/bootparam.h
index 8e62185..c8bfe63 100644
--- a/arch/x86/include/asm/bootparam.h
+++ b/arch/x86/include/asm/bootparam.h
@@ -124,6 +124,7 @@ enum {
 	X86_SUBARCH_LGUEST,
 	X86_SUBARCH_XEN,
 	X86_SUBARCH_MRST,
+	X86_SUBARCH_CE4100,
 	X86_NR_SUBARCHS,
 };
 
diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index 4d293dc..139591a 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -117,6 +117,10 @@ enum fixed_addresses {
 	FIX_TEXT_POKE1,	/* reserve 2 pages for text_poke() */
 	FIX_TEXT_POKE0, /* first page is last, because allocation is backward */
 	__end_of_permanent_fixed_addresses,
+
+#ifdef	CONFIG_X86_MRST
+	FIX_LNW_VRTC,
+#endif
 	/*
 	 * 256 temporary boot-time mappings, used by early_ioremap(),
 	 * before ioremap() is functional.
diff --git a/arch/x86/include/asm/mrst-vrtc.h b/arch/x86/include/asm/mrst-vrtc.h
new file mode 100644
index 0000000..73668ab
--- /dev/null
+++ b/arch/x86/include/asm/mrst-vrtc.h
@@ -0,0 +1,9 @@
+#ifndef _MRST_VRTC_H
+#define _MRST_VRTC_H
+
+extern unsigned char vrtc_cmos_read(unsigned char reg);
+extern void vrtc_cmos_write(unsigned char val, unsigned char reg);
+extern unsigned long vrtc_get_time(void);
+extern int vrtc_set_mmss(unsigned long nowtime);
+
+#endif
diff --git a/arch/x86/include/asm/mrst.h b/arch/x86/include/asm/mrst.h
index 4a711a6..719f00b 100644
--- a/arch/x86/include/asm/mrst.h
+++ b/arch/x86/include/asm/mrst.h
@@ -14,7 +14,9 @@
 #include <linux/sfi.h>
 
 extern int pci_mrst_init(void);
-int __init sfi_parse_mrtc(struct sfi_table_header *table);
+extern int __init sfi_parse_mrtc(struct sfi_table_header *table);
+extern int sfi_mrtc_num;
+extern struct sfi_rtc_table_entry sfi_mrtc_array[];
 
 /*
  * Medfield is the follow-up of Moorestown, it combines two chip solution into
@@ -50,4 +52,14 @@ extern void mrst_early_console_init(void);
 
 extern struct console early_hsu_console;
 extern void hsu_early_console_init(void);
+
+extern void intel_scu_devices_create(void);
+extern void intel_scu_devices_destroy(void);
+
+/* VRTC timer */
+#define MRST_VRTC_MAP_SZ	(1024)
+/*#define MRST_VRTC_PGOFFSET	(0xc00) */
+
+extern void mrst_rtc_init(void);
+
 #endif /* _ASM_X86_MRST_H */
diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index d6763b1..db8aa19 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -53,6 +53,12 @@ extern void x86_mrst_early_setup(void);
 static inline void x86_mrst_early_setup(void) { }
 #endif
 
+#ifdef CONFIG_X86_INTEL_CE
+extern void x86_ce4100_early_setup(void);
+#else
+static inline void x86_ce4100_early_setup(void) { }
+#endif
+
 #ifndef _SETUP
 
 /*
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 9e13763..f60153d 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -84,7 +84,6 @@ obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault_32.o
 obj-$(CONFIG_KGDB)		+= kgdb.o
 obj-$(CONFIG_VM86)		+= vm86_32.o
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
-obj-$(CONFIG_EARLY_PRINTK_MRST)	+= early_printk_mrst.o
 
 obj-$(CONFIG_HPET_TIMER) 	+= hpet.o
 obj-$(CONFIG_APB_TIMER)		+= apb_timer.o
diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index 92543c7..7c9ab59 100644
--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -315,6 +315,7 @@ static void apbt_setup_irq(struct apbt_dev *adev)
 
 	if (system_state == SYSTEM_BOOTING) {
 		irq_modify_status(adev->irq, 0, IRQ_MOVE_PCNTXT);
+		irq_set_affinity(adev->irq, cpumask_of(adev->cpu));
 		/* APB timer irqs are set up as mp_irqs, timer is edge type */
 		__set_irq_handler(adev->irq, handle_edge_irq, 0, "edge");
 		if (request_irq(adev->irq, apbt_interrupt_handler,
diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index 4572f25..cd28a35 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -240,7 +240,7 @@ static int __init setup_early_printk(char *buf)
 		if (!strncmp(buf, "xen", 3))
 			early_console_register(&xenboot_console, keep);
 #endif
-#ifdef CONFIG_X86_MRST_EARLY_PRINTK
+#ifdef CONFIG_EARLY_PRINTK_MRST
 		if (!strncmp(buf, "mrst", 4)) {
 			mrst_early_console_init();
 			early_console_register(&early_mrst_console, keep);
@@ -250,7 +250,6 @@ static int __init setup_early_printk(char *buf)
 			hsu_early_console_init();
 			early_console_register(&early_hsu_console, keep);
 		}
-
 #endif
 		buf++;
 	}
diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index 7633101..7f138b3 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -61,6 +61,9 @@ void __init i386_start_kernel(void)
 	case X86_SUBARCH_MRST:
 		x86_mrst_early_setup();
 		break;
+	case X86_SUBARCH_CE4100:
+		x86_ce4100_early_setup();
+		break;
 	default:
 		i386_default_early_setup();
 		break;
diff --git a/arch/x86/kernel/reboot_fixups_32.c b/arch/x86/kernel/reboot_fixups_32.c
index fda313e..c8e41e9 100644
--- a/arch/x86/kernel/reboot_fixups_32.c
+++ b/arch/x86/kernel/reboot_fixups_32.c
@@ -43,17 +43,33 @@ static void rdc321x_reset(struct pci_dev *dev)
 	outb(1, 0x92);
 }
 
+static void ce4100_reset(struct pci_dev *dev)
+{
+	int i;
+
+	for (i = 0; i < 10; i++) {
+		outb(0x2, 0xcf9);
+		udelay(50);
+	}
+}
+
 struct device_fixup {
 	unsigned int vendor;
 	unsigned int device;
 	void (*reboot_fixup)(struct pci_dev *);
 };
 
+/*
+ * PCI ids solely used for fixups_table go here
+ */
+#define PCI_DEVICE_ID_INTEL_CE4100	0x0708
+
 static const struct device_fixup fixups_table[] = {
 { PCI_VENDOR_ID_CYRIX, PCI_DEVICE_ID_CYRIX_5530_LEGACY, cs5530a_warm_reset },
 { PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA, cs5536_warm_reset },
 { PCI_VENDOR_ID_NS, PCI_DEVICE_ID_NS_SC1100_BRIDGE, cs5530a_warm_reset },
 { PCI_VENDOR_ID_RDC, PCI_DEVICE_ID_RDC_R6030, rdc321x_reset },
+{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_CE4100, ce4100_reset },
 };
 
 /*
diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
index effd96e..6b8759f 100644
--- a/arch/x86/pci/Makefile
+++ b/arch/x86/pci/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_PCI_OLPC)		+= olpc.o
 obj-$(CONFIG_PCI_XEN)		+= xen.o
 
 obj-y				+= fixup.o
+obj-$(CONFIG_X86_INTEL_CE)      += ce4100.o
 obj-$(CONFIG_ACPI)		+= acpi.o
 obj-y				+= legacy.o irq.o
 
diff --git a/arch/x86/pci/ce4100.c b/arch/x86/pci/ce4100.c
new file mode 100644
index 0000000..85b68ef
--- /dev/null
+++ b/arch/x86/pci/ce4100.c
@@ -0,0 +1,315 @@
+/*
+ *  GPL LICENSE SUMMARY
+ *
+ *  Copyright(c) 2010 Intel Corporation. All rights reserved.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of version 2 of the GNU General Public License as
+ *  published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *  The full GNU General Public License is included in this distribution
+ *  in the file called LICENSE.GPL.
+ *
+ *  Contact Information:
+ *    Intel Corporation
+ *    2200 Mission College Blvd.
+ *    Santa Clara, CA  97052
+ *
+ * This provides access methods for PCI registers that mis-behave on
+ * the CE4100. Each register can be assigned a private init, read and
+ * write routine. The exception to this is the bridge device.  The
+ * bridge device is the only device on bus zero (0) that requires any
+ * fixup so it is a special case ATM
+ */
+
+#include <linux/kernel.h>
+#include <linux/pci.h>
+#include <linux/init.h>
+
+#include <asm/pci_x86.h>
+
+struct sim_reg {
+	u32 value;
+	u32 mask;
+};
+
+struct sim_dev_reg {
+	int dev_func;
+	int reg;
+	void (*init)(struct sim_dev_reg *reg);
+	void (*read)(struct sim_dev_reg *reg, u32 *value);
+	void (*write)(struct sim_dev_reg *reg, u32 value);
+	struct sim_reg sim_reg;
+};
+
+struct sim_reg_op {
+	void (*init)(struct sim_dev_reg *reg);
+	void (*read)(struct sim_dev_reg *reg, u32 value);
+	void (*write)(struct sim_dev_reg *reg, u32 value);
+};
+
+#define MB (1024 * 1024)
+#define KB (1024)
+#define SIZE_TO_MASK(size) (~(size - 1))
+
+#define DEFINE_REG(device, func, offset, size, init_op, read_op, write_op)\
+{ PCI_DEVFN(device, func), offset, init_op, read_op, write_op,\
+	{0, SIZE_TO_MASK(size)} },
+
+static void reg_init(struct sim_dev_reg *reg)
+{
+	pci_direct_conf1.read(0, 1, reg->dev_func, reg->reg, 4,
+			      &reg->sim_reg.value);
+}
+
+static void reg_read(struct sim_dev_reg *reg, u32 *value)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&pci_config_lock, flags);
+	*value = reg->sim_reg.value;
+	raw_spin_unlock_irqrestore(&pci_config_lock, flags);
+}
+
+static void reg_write(struct sim_dev_reg *reg, u32 value)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&pci_config_lock, flags);
+	reg->sim_reg.value = (value & reg->sim_reg.mask) |
+		(reg->sim_reg.value & ~reg->sim_reg.mask);
+	raw_spin_unlock_irqrestore(&pci_config_lock, flags);
+}
+
+static void sata_reg_init(struct sim_dev_reg *reg)
+{
+	pci_direct_conf1.read(0, 1, PCI_DEVFN(14, 0), 0x10, 4,
+			      &reg->sim_reg.value);
+	reg->sim_reg.value += 0x400;
+}
+
+static void ehci_reg_read(struct sim_dev_reg *reg, u32 *value)
+{
+	reg_read(reg, value);
+	if (*value != reg->sim_reg.mask)
+		*value |= 0x100;
+}
+
+void sata_revid_init(struct sim_dev_reg *reg)
+{
+	reg->sim_reg.value = 0x01060100;
+	reg->sim_reg.mask = 0;
+}
+
+static void sata_revid_read(struct sim_dev_reg *reg, u32 *value)
+{
+	reg_read(reg, value);
+}
+
+static struct sim_dev_reg bus1_fixups[] = {
+	DEFINE_REG(2, 0, 0x10, (16*MB), reg_init, reg_read, reg_write)
+	DEFINE_REG(2, 0, 0x14, (256), reg_init, reg_read, reg_write)
+	DEFINE_REG(2, 1, 0x10, (64*KB), reg_init, reg_read, reg_write)
+	DEFINE_REG(3, 0, 0x10, (64*KB), reg_init, reg_read, reg_write)
+	DEFINE_REG(4, 0, 0x10, (128*KB), reg_init, reg_read, reg_write)
+	DEFINE_REG(4, 1, 0x10, (128*KB), reg_init, reg_read, reg_write)
+	DEFINE_REG(6, 0, 0x10, (512*KB), reg_init, reg_read, reg_write)
+	DEFINE_REG(6, 1, 0x10, (512*KB), reg_init, reg_read, reg_write)
+	DEFINE_REG(6, 2, 0x10, (64*KB), reg_init, reg_read, reg_write)
+	DEFINE_REG(8, 0, 0x10, (1*MB), reg_init, reg_read, reg_write)
+	DEFINE_REG(8, 1, 0x10, (64*KB), reg_init, reg_read, reg_write)
+	DEFINE_REG(8, 2, 0x10, (64*KB), reg_init, reg_read, reg_write)
+	DEFINE_REG(9, 0, 0x10 , (1*MB), reg_init, reg_read, reg_write)
+	DEFINE_REG(9, 0, 0x14, (64*KB), reg_init, reg_read, reg_write)
+	DEFINE_REG(10, 0, 0x10, (256), reg_init, reg_read, reg_write)
+	DEFINE_REG(10, 0, 0x14, (256*MB), reg_init, reg_read, reg_write)
+	DEFINE_REG(11, 0, 0x10, (256), reg_init, reg_read, reg_write)
+	DEFINE_REG(11, 0, 0x14, (256), reg_init, reg_read, reg_write)
+	DEFINE_REG(11, 1, 0x10, (256), reg_init, reg_read, reg_write)
+	DEFINE_REG(11, 2, 0x10, (256), reg_init, reg_read, reg_write)
+	DEFINE_REG(11, 2, 0x14, (256), reg_init, reg_read, reg_write)
+	DEFINE_REG(11, 2, 0x18, (256), reg_init, reg_read, reg_write)
+	DEFINE_REG(11, 3, 0x10, (256), reg_init, reg_read, reg_write)
+	DEFINE_REG(11, 3, 0x14, (256), reg_init, reg_read, reg_write)
+	DEFINE_REG(11, 4, 0x10, (256), reg_init, reg_read, reg_write)
+	DEFINE_REG(11, 5, 0x10, (64*KB), reg_init, reg_read, reg_write)
+	DEFINE_REG(11, 6, 0x10, (256), reg_init, reg_read, reg_write)
+	DEFINE_REG(11, 7, 0x10, (64*KB), reg_init, reg_read, reg_write)
+	DEFINE_REG(12, 0, 0x10, (128*KB), reg_init, reg_read, reg_write)
+	DEFINE_REG(12, 0, 0x14, (256), reg_init, reg_read, reg_write)
+	DEFINE_REG(12, 1, 0x10, (1024), reg_init, reg_read, reg_write)
+	DEFINE_REG(13, 0, 0x10, (32*KB), reg_init, ehci_reg_read, reg_write)
+	DEFINE_REG(13, 1, 0x10, (32*KB), reg_init, ehci_reg_read, reg_write)
+	DEFINE_REG(14, 0, 0x8,  0, sata_revid_init, sata_revid_read, 0)
+	DEFINE_REG(14, 0, 0x10, 0, reg_init, reg_read, reg_write)
+	DEFINE_REG(14, 0, 0x14, 0, reg_init, reg_read, reg_write)
+	DEFINE_REG(14, 0, 0x18, 0, reg_init, reg_read, reg_write)
+	DEFINE_REG(14, 0, 0x1C, 0, reg_init, reg_read, reg_write)
+	DEFINE_REG(14, 0, 0x20, 0, reg_init, reg_read, reg_write)
+	DEFINE_REG(14, 0, 0x24, (0x200), sata_reg_init, reg_read, reg_write)
+	DEFINE_REG(15, 0, 0x10, (64*KB), reg_init, reg_read, reg_write)
+	DEFINE_REG(15, 0, 0x14, (64*KB), reg_init, reg_read, reg_write)
+	DEFINE_REG(16, 0, 0x10, (64*KB), reg_init, reg_read, reg_write)
+	DEFINE_REG(16, 0, 0x14, (64*MB), reg_init, reg_read, reg_write)
+	DEFINE_REG(16, 0, 0x18, (64*MB), reg_init, reg_read, reg_write)
+	DEFINE_REG(17, 0, 0x10, (128*KB), reg_init, reg_read, reg_write)
+	DEFINE_REG(18, 0, 0x10, (1*KB), reg_init, reg_read, reg_write)
+};
+
+static void __init init_sim_regs(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(bus1_fixups); i++) {
+		if (bus1_fixups[i].init)
+			bus1_fixups[i].init(&bus1_fixups[i]);
+	}
+}
+
+static inline void extract_bytes(u32 *value, int reg, int len)
+{
+	uint32_t mask;
+
+	*value >>= ((reg & 3) * 8);
+	mask = 0xFFFFFFFF >> ((4 - len) * 8);
+	*value &= mask;
+}
+
+int bridge_read(unsigned int devfn, int reg, int len, u32 *value)
+{
+	u32 av_bridge_base, av_bridge_limit;
+	int retval = 0;
+
+	switch (reg) {
+	/* Make BARs appear to not request any memory. */
+	case PCI_BASE_ADDRESS_0:
+	case PCI_BASE_ADDRESS_0 + 1:
+	case PCI_BASE_ADDRESS_0 + 2:
+	case PCI_BASE_ADDRESS_0 + 3:
+		*value = 0;
+		break;
+
+		/* Since subordinate bus number register is hardwired
+		 * to zero and read only, so do the simulation.
+		 */
+	case PCI_PRIMARY_BUS:
+		if (len == 4)
+			*value = 0x00010100;
+		break;
+
+	case PCI_SUBORDINATE_BUS:
+		*value = 1;
+		break;
+
+	case PCI_MEMORY_BASE:
+	case PCI_MEMORY_LIMIT:
+		/* Get the A/V bridge base address. */
+		pci_direct_conf1.read(0, 0, devfn,
+				PCI_BASE_ADDRESS_0, 4, &av_bridge_base);
+
+		av_bridge_limit = av_bridge_base + (512*MB - 1);
+		av_bridge_limit >>= 16;
+		av_bridge_limit &= 0xFFF0;
+
+		av_bridge_base >>= 16;
+		av_bridge_base &= 0xFFF0;
+
+		if (reg == PCI_MEMORY_LIMIT)
+			*value = av_bridge_limit;
+		else if (len == 2)
+			*value = av_bridge_base;
+		else
+			*value = (av_bridge_limit << 16) | av_bridge_base;
+		break;
+		/* Make prefetchable memory limit smaller than prefetchable
+		 * memory base, so not claim prefetchable memory space.
+		 */
+	case PCI_PREF_MEMORY_BASE:
+		*value = 0xFFF0;
+		break;
+	case PCI_PREF_MEMORY_LIMIT:
+		*value = 0x0;
+		break;
+		/* Make IO limit smaller than IO base, so not claim IO space. */
+	case PCI_IO_BASE:
+		*value = 0xF0;
+		break;
+	case PCI_IO_LIMIT:
+		*value = 0;
+		break;
+	default:
+		retval = 1;
+	}
+	return retval;
+}
+
+static int ce4100_conf_read(unsigned int seg, unsigned int bus,
+			    unsigned int devfn, int reg, int len, u32 *value)
+{
+	int i, retval = 1;
+
+	if (bus == 1) {
+		for (i = 0; i < ARRAY_SIZE(bus1_fixups); i++) {
+			if (bus1_fixups[i].dev_func == devfn &&
+			    bus1_fixups[i].reg == (reg & ~3) &&
+			    bus1_fixups[i].read) {
+				bus1_fixups[i].read(&(bus1_fixups[i]),
+						    value);
+				extract_bytes(value, reg, len);
+				return 0;
+			}
+		}
+	}
+
+	if (bus == 0 && (PCI_DEVFN(1, 0) == devfn) &&
+	    !bridge_read(devfn, reg, len, value))
+		return 0;
+
+	return pci_direct_conf1.read(seg, bus, devfn, reg, len, value);
+}
+
+static int ce4100_conf_write(unsigned int seg, unsigned int bus,
+			     unsigned int devfn, int reg, int len, u32 value)
+{
+	int i;
+
+	if (bus == 1) {
+		for (i = 0; i < ARRAY_SIZE(bus1_fixups); i++) {
+			if (bus1_fixups[i].dev_func == devfn &&
+			    bus1_fixups[i].reg == (reg & ~3) &&
+			    bus1_fixups[i].write) {
+				bus1_fixups[i].write(&(bus1_fixups[i]),
+						     value);
+				return 0;
+			}
+		}
+	}
+
+	/* Discard writes to A/V bridge BAR. */
+	if (bus == 0 && PCI_DEVFN(1, 0) == devfn &&
+	    ((reg & ~3) == PCI_BASE_ADDRESS_0))
+		return 0;
+
+	return pci_direct_conf1.write(seg, bus, devfn, reg, len, value);
+}
+
+struct pci_raw_ops ce4100_pci_conf = {
+	.read =	ce4100_conf_read,
+	.write = ce4100_conf_write,
+};
+
+static int __init ce4100_pci_init(void)
+{
+	init_sim_regs();
+	raw_pci_ops = &ce4100_pci_conf;
+	return 0;
+}
+subsys_initcall(ce4100_pci_init);
diff --git a/arch/x86/platform/Makefile b/arch/x86/platform/Makefile
index 7bf70b8..021eee9 100644
--- a/arch/x86/platform/Makefile
+++ b/arch/x86/platform/Makefile
@@ -1,5 +1,7 @@
 # Platform specific code goes here
+obj-y	+= ce4100/
 obj-y	+= efi/
+obj-y	+= iris/
 obj-y	+= mrst/
 obj-y	+= olpc/
 obj-y	+= scx200/
diff --git a/arch/x86/platform/ce4100/Makefile b/arch/x86/platform/ce4100/Makefile
new file mode 100644
index 0000000..91fc929
--- /dev/null
+++ b/arch/x86/platform/ce4100/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_X86_INTEL_CE)	+= ce4100.o
diff --git a/arch/x86/platform/ce4100/ce4100.c b/arch/x86/platform/ce4100/ce4100.c
new file mode 100644
index 0000000..d2c0d51
--- /dev/null
+++ b/arch/x86/platform/ce4100/ce4100.c
@@ -0,0 +1,132 @@
+/*
+ * Intel CE4100  platform specific setup code
+ *
+ * (C) Copyright 2010 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/irq.h>
+#include <linux/module.h>
+#include <linux/serial_reg.h>
+#include <linux/serial_8250.h>
+
+#include <asm/setup.h>
+#include <asm/io.h>
+
+static int ce4100_i8042_detect(void)
+{
+	return 0;
+}
+
+static void __init sdv_find_smp_config(void)
+{
+}
+
+#ifdef CONFIG_SERIAL_8250
+
+
+static unsigned int mem_serial_in(struct uart_port *p, int offset)
+{
+	offset = offset << p->regshift;
+	return readl(p->membase + offset);
+}
+
+/*
+ * The UART Tx interrupts are not set under some conditions and therefore serial
+ * transmission hangs. This is a silicon issue and has not been root caused. The
+ * workaround for this silicon issue checks UART_LSR_THRE bit and UART_LSR_TEMT
+ * bit of LSR register in interrupt handler to see whether at least one of these
+ * two bits is set, if so then process the transmit request. If this workaround
+ * is not applied, then the serial transmission may hang. This workaround is for
+ * errata number 9 in Errata - B step.
+*/
+
+static unsigned int ce4100_mem_serial_in(struct uart_port *p, int offset)
+{
+	unsigned int ret, ier, lsr;
+
+	if (offset == UART_IIR) {
+		offset = offset << p->regshift;
+		ret = readl(p->membase + offset);
+		if (ret & UART_IIR_NO_INT) {
+			/* see if the TX interrupt should have really set */
+			ier = mem_serial_in(p, UART_IER);
+			/* see if the UART's XMIT interrupt is enabled */
+			if (ier & UART_IER_THRI) {
+				lsr = mem_serial_in(p, UART_LSR);
+				/* now check to see if the UART should be
+				   generating an interrupt (but isn't) */
+				if (lsr & (UART_LSR_THRE | UART_LSR_TEMT))
+					ret &= ~UART_IIR_NO_INT;
+			}
+		}
+	} else
+		ret =  mem_serial_in(p, offset);
+	return ret;
+}
+
+static void ce4100_mem_serial_out(struct uart_port *p, int offset, int value)
+{
+	offset = offset << p->regshift;
+	writel(value, p->membase + offset);
+}
+
+static void ce4100_serial_fixup(int port, struct uart_port *up,
+	unsigned short *capabilites)
+{
+#ifdef CONFIG_EARLY_PRINTK
+	/*
+	 * Over ride the legacy port configuration that comes from
+	 * asm/serial.h. Using the ioport driver then switching to the
+	 * PCI memmaped driver hangs the IOAPIC
+	 */
+	if (up->iotype !=  UPIO_MEM32) {
+		up->uartclk  = 14745600;
+		up->mapbase = 0xdffe0200;
+		set_fixmap_nocache(FIX_EARLYCON_MEM_BASE,
+				up->mapbase & PAGE_MASK);
+		up->membase =
+			(void __iomem *)__fix_to_virt(FIX_EARLYCON_MEM_BASE);
+		up->membase += up->mapbase & ~PAGE_MASK;
+		up->iotype   = UPIO_MEM32;
+		up->regshift = 2;
+	}
+#endif
+	up->iobase = 0;
+	up->serial_in = ce4100_mem_serial_in;
+	up->serial_out = ce4100_mem_serial_out;
+
+	*capabilites |= (1 << 12);
+}
+
+static __init void sdv_serial_fixup(void)
+{
+	serial8250_set_isa_configurator(ce4100_serial_fixup);
+}
+
+#else
+static inline void sdv_serial_fixup(void);
+#endif
+
+static void __init sdv_arch_setup(void)
+{
+	sdv_serial_fixup();
+}
+
+/*
+ * CE4100 specific x86_init function overrides and early setup
+ * calls.
+ */
+void __init x86_ce4100_early_setup(void)
+{
+	x86_init.oem.arch_setup = sdv_arch_setup;
+	x86_platform.i8042_detect = ce4100_i8042_detect;
+	x86_init.resources.probe_roms = x86_init_noop;
+	x86_init.mpparse.get_smp_config = x86_init_uint_noop;
+	x86_init.mpparse.find_smp_config = sdv_find_smp_config;
+}
diff --git a/arch/x86/platform/iris/Makefile b/arch/x86/platform/iris/Makefile
new file mode 100644
index 0000000..db92198
--- /dev/null
+++ b/arch/x86/platform/iris/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_X86_32_IRIS)		+= iris.o
diff --git a/arch/x86/platform/iris/iris.c b/arch/x86/platform/iris/iris.c
new file mode 100644
index 0000000..1ba7f5e
--- /dev/null
+++ b/arch/x86/platform/iris/iris.c
@@ -0,0 +1,91 @@
+/*
+ * Eurobraille/Iris power off support.
+ *
+ * Eurobraille's Iris machine is a PC with no APM or ACPI support.
+ * It is shutdown by a special I/O sequence which this module provides.
+ *
+ *  Copyright (C) Shérab <Sebastien.Hinderer@ens-lyon.org>
+ *
+ * This program is free software ; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation ; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY ; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with the program ; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/moduleparam.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/pm.h>
+#include <asm/io.h>
+
+#define IRIS_GIO_BASE		0x340
+#define IRIS_GIO_INPUT		IRIS_GIO_BASE
+#define IRIS_GIO_OUTPUT		(IRIS_GIO_BASE + 1)
+#define IRIS_GIO_PULSE		0x80 /* First byte to send */
+#define IRIS_GIO_REST		0x00 /* Second byte to send */
+#define IRIS_GIO_NODEV		0xff /* Likely not an Iris */
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Sébastien Hinderer <Sebastien.Hinderer@ens-lyon.org>");
+MODULE_DESCRIPTION("A power_off handler for Iris devices from EuroBraille");
+MODULE_SUPPORTED_DEVICE("Eurobraille/Iris");
+
+static int force;
+
+module_param(force, bool, 0);
+MODULE_PARM_DESC(force, "Set to one to force poweroff handler installation.");
+
+static void (*old_pm_power_off)(void);
+
+static void iris_power_off(void)
+{
+	outb(IRIS_GIO_PULSE, IRIS_GIO_OUTPUT);
+	msleep(850);
+	outb(IRIS_GIO_REST, IRIS_GIO_OUTPUT);
+}
+
+/*
+ * Before installing the power_off handler, try to make sure the OS is
+ * running on an Iris.  Since Iris does not support DMI, this is done
+ * by reading its input port and seeing whether the read value is
+ * meaningful.
+ */
+static int iris_init(void)
+{
+	unsigned char status;
+	if (force != 1) {
+		printk(KERN_ERR "The force parameter has not been set to 1 so the Iris poweroff handler will not be installed.\n");
+		return -ENODEV;
+	}
+	status = inb(IRIS_GIO_INPUT);
+	if (status == IRIS_GIO_NODEV) {
+		printk(KERN_ERR "This machine does not seem to be an Iris. Power_off handler not installed.\n");
+		return -ENODEV;
+	}
+	old_pm_power_off = pm_power_off;
+	pm_power_off = &iris_power_off;
+	printk(KERN_INFO "Iris power_off handler installed.\n");
+
+	return 0;
+}
+
+static void iris_exit(void)
+{
+	pm_power_off = old_pm_power_off;
+	printk(KERN_INFO "Iris power_off handler uninstalled.\n");
+}
+
+module_init(iris_init);
+module_exit(iris_exit);
diff --git a/arch/x86/platform/mrst/Makefile b/arch/x86/platform/mrst/Makefile
index efbbc55..f61ccdd 100644
--- a/arch/x86/platform/mrst/Makefile
+++ b/arch/x86/platform/mrst/Makefile
@@ -1 +1,3 @@
 obj-$(CONFIG_X86_MRST)		+= mrst.o
+obj-$(CONFIG_X86_MRST)		+= vrtc.o
+obj-$(CONFIG_EARLY_PRINTK_MRST)	+= early_printk_mrst.o
diff --git a/arch/x86/kernel/early_printk_mrst.c b/arch/x86/platform/mrst/early_printk_mrst.c
similarity index 100%
rename from arch/x86/kernel/early_printk_mrst.c
rename to arch/x86/platform/mrst/early_printk_mrst.c
diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index 79ae681..fee0b49 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -9,9 +9,19 @@
  * as published by the Free Software Foundation; version 2
  * of the License.
  */
+
+#define pr_fmt(fmt) "mrst: " fmt
+
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/sfi.h>
+#include <linux/intel_pmic_gpio.h>
+#include <linux/spi/spi.h>
+#include <linux/i2c.h>
+#include <linux/i2c/pca953x.h>
+#include <linux/gpio_keys.h>
+#include <linux/input.h>
+#include <linux/platform_device.h>
 #include <linux/irq.h>
 #include <linux/module.h>
 
@@ -23,7 +33,9 @@
 #include <asm/mrst.h>
 #include <asm/io.h>
 #include <asm/i8259.h>
+#include <asm/intel_scu_ipc.h>
 #include <asm/apb_timer.h>
+#include <asm/reboot.h>
 
 /*
  * the clockevent devices on Moorestown/Medfield can be APBT or LAPIC clock,
@@ -102,10 +114,10 @@ static int __init sfi_parse_mtmr(struct sfi_table_header *table)
 		memcpy(sfi_mtimer_array, pentry, totallen);
 	}
 
-	printk(KERN_INFO "SFI: MTIMER info (num = %d):\n", sfi_mtimer_num);
+	pr_debug("SFI MTIMER info (num = %d):\n", sfi_mtimer_num);
 	pentry = sfi_mtimer_array;
 	for (totallen = 0; totallen < sfi_mtimer_num; totallen++, pentry++) {
-		printk(KERN_INFO "timer[%d]: paddr = 0x%08x, freq = %dHz,"
+		pr_debug("timer[%d]: paddr = 0x%08x, freq = %dHz,"
 			" irq = %d\n", totallen, (u32)pentry->phys_addr,
 			pentry->freq_hz, pentry->irq);
 			if (!pentry->irq)
@@ -176,14 +188,14 @@ int __init sfi_parse_mrtc(struct sfi_table_header *table)
 		memcpy(sfi_mrtc_array, pentry, totallen);
 	}
 
-	printk(KERN_INFO "SFI: RTC info (num = %d):\n", sfi_mrtc_num);
+	pr_debug("SFI RTC info (num = %d):\n", sfi_mrtc_num);
 	pentry = sfi_mrtc_array;
 	for (totallen = 0; totallen < sfi_mrtc_num; totallen++, pentry++) {
-		printk(KERN_INFO "RTC[%d]: paddr = 0x%08x, irq = %d\n",
+		pr_debug("RTC[%d]: paddr = 0x%08x, irq = %d\n",
 			totallen, (u32)pentry->phys_addr, pentry->irq);
 		mp_irq.type = MP_IOAPIC;
 		mp_irq.irqtype = mp_INT;
-		mp_irq.irqflag = 0;
+		mp_irq.irqflag = 0xf;	/* level trigger and active low */
 		mp_irq.srcbus = 0;
 		mp_irq.srcbusirq = pentry->irq;	/* IRQ */
 		mp_irq.dstapic = MP_APIC_ALL;
@@ -209,6 +221,7 @@ static unsigned long __init mrst_calibrate_tsc(void)
 
 void __init mrst_time_init(void)
 {
+	sfi_table_parse(SFI_SIG_MTMR, NULL, NULL, sfi_parse_mtmr);
 	switch (mrst_timer_options) {
 	case MRST_TIMER_APBT_ONLY:
 		break;
@@ -224,16 +237,10 @@ void __init mrst_time_init(void)
 		return;
 	}
 	/* we need at least one APB timer */
-	sfi_table_parse(SFI_SIG_MTMR, NULL, NULL, sfi_parse_mtmr);
 	pre_init_apic_IRQ0();
 	apbt_time_init();
 }
 
-void __init mrst_rtc_init(void)
-{
-	sfi_table_parse(SFI_SIG_MRTC, NULL, NULL, sfi_parse_mrtc);
-}
-
 void __cpuinit mrst_arch_setup(void)
 {
 	if (boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model == 0x27)
@@ -256,6 +263,17 @@ static int mrst_i8042_detect(void)
 	return 0;
 }
 
+/* Reboot and power off are handled by the SCU on a MID device */
+static void mrst_power_off(void)
+{
+	intel_scu_ipc_simple_command(0xf1, 1);
+}
+
+static void mrst_reboot(void)
+{
+	intel_scu_ipc_simple_command(0xf1, 0);
+}
+
 /*
  * Moorestown specific x86_init function overrides and early setup
  * calls.
@@ -281,6 +299,10 @@ void __init x86_mrst_early_setup(void)
 
 	legacy_pic = &null_legacy_pic;
 
+	/* Moorestown specific power_off/restart method */
+	pm_power_off = mrst_power_off;
+	machine_ops.emergency_restart  = mrst_reboot;
+
 	/* Avoid searching for BIOS MP tables */
 	x86_init.mpparse.find_smp_config = x86_init_noop;
 	x86_init.mpparse.get_smp_config = x86_init_uint_noop;
@@ -309,3 +331,505 @@ static inline int __init setup_x86_mrst_timer(char *arg)
 	return 0;
 }
 __setup("x86_mrst_timer=", setup_x86_mrst_timer);
+
+/*
+ * Parsing GPIO table first, since the DEVS table will need this table
+ * to map the pin name to the actual pin.
+ */
+static struct sfi_gpio_table_entry *gpio_table;
+static int gpio_num_entry;
+
+static int __init sfi_parse_gpio(struct sfi_table_header *table)
+{
+	struct sfi_table_simple *sb;
+	struct sfi_gpio_table_entry *pentry;
+	int num, i;
+
+	if (gpio_table)
+		return 0;
+	sb = (struct sfi_table_simple *)table;
+	num = SFI_GET_NUM_ENTRIES(sb, struct sfi_gpio_table_entry);
+	pentry = (struct sfi_gpio_table_entry *)sb->pentry;
+
+	gpio_table = (struct sfi_gpio_table_entry *)
+				kmalloc(num * sizeof(*pentry), GFP_KERNEL);
+	if (!gpio_table)
+		return -1;
+	memcpy(gpio_table, pentry, num * sizeof(*pentry));
+	gpio_num_entry = num;
+
+	pr_debug("GPIO pin info:\n");
+	for (i = 0; i < num; i++, pentry++)
+		pr_debug("info[%2d]: controller = %16.16s, pin_name = %16.16s,"
+		" pin = %d\n", i,
+			pentry->controller_name,
+			pentry->pin_name,
+			pentry->pin_no);
+	return 0;
+}
+
+static int get_gpio_by_name(const char *name)
+{
+	struct sfi_gpio_table_entry *pentry = gpio_table;
+	int i;
+
+	if (!pentry)
+		return -1;
+	for (i = 0; i < gpio_num_entry; i++, pentry++) {
+		if (!strncmp(name, pentry->pin_name, SFI_NAME_LEN))
+			return pentry->pin_no;
+	}
+	return -1;
+}
+
+/*
+ * Here defines the array of devices platform data that IAFW would export
+ * through SFI "DEVS" table, we use name and type to match the device and
+ * its platform data.
+ */
+struct devs_id {
+	char name[SFI_NAME_LEN + 1];
+	u8 type;
+	u8 delay;
+	void *(*get_platform_data)(void *info);
+};
+
+/* the offset for the mapping of global gpio pin to irq */
+#define MRST_IRQ_OFFSET 0x100
+
+static void __init *pmic_gpio_platform_data(void *info)
+{
+	static struct intel_pmic_gpio_platform_data pmic_gpio_pdata;
+	int gpio_base = get_gpio_by_name("pmic_gpio_base");
+
+	if (gpio_base == -1)
+		gpio_base = 64;
+	pmic_gpio_pdata.gpio_base = gpio_base;
+	pmic_gpio_pdata.irq_base = gpio_base + MRST_IRQ_OFFSET;
+	pmic_gpio_pdata.gpiointr = 0xffffeff8;
+
+	return &pmic_gpio_pdata;
+}
+
+static void __init *max3111_platform_data(void *info)
+{
+	struct spi_board_info *spi_info = info;
+	int intr = get_gpio_by_name("max3111_int");
+
+	if (intr == -1)
+		return NULL;
+	spi_info->irq = intr + MRST_IRQ_OFFSET;
+	return NULL;
+}
+
+/* we have multiple max7315 on the board ... */
+#define MAX7315_NUM 2
+static void __init *max7315_platform_data(void *info)
+{
+	static struct pca953x_platform_data max7315_pdata[MAX7315_NUM];
+	static int nr;
+	struct pca953x_platform_data *max7315 = &max7315_pdata[nr];
+	struct i2c_board_info *i2c_info = info;
+	int gpio_base, intr;
+	char base_pin_name[SFI_NAME_LEN + 1];
+	char intr_pin_name[SFI_NAME_LEN + 1];
+
+	if (nr == MAX7315_NUM) {
+		pr_err("too many max7315s, we only support %d\n",
+				MAX7315_NUM);
+		return NULL;
+	}
+	/* we have several max7315 on the board, we only need load several
+	 * instances of the same pca953x driver to cover them
+	 */
+	strcpy(i2c_info->type, "max7315");
+	if (nr++) {
+		sprintf(base_pin_name, "max7315_%d_base", nr);
+		sprintf(intr_pin_name, "max7315_%d_int", nr);
+	} else {
+		strcpy(base_pin_name, "max7315_base");
+		strcpy(intr_pin_name, "max7315_int");
+	}
+
+	gpio_base = get_gpio_by_name(base_pin_name);
+	intr = get_gpio_by_name(intr_pin_name);
+
+	if (gpio_base == -1)
+		return NULL;
+	max7315->gpio_base = gpio_base;
+	if (intr != -1) {
+		i2c_info->irq = intr + MRST_IRQ_OFFSET;
+		max7315->irq_base = gpio_base + MRST_IRQ_OFFSET;
+	} else {
+		i2c_info->irq = -1;
+		max7315->irq_base = -1;
+	}
+	return max7315;
+}
+
+static void __init *emc1403_platform_data(void *info)
+{
+	static short intr2nd_pdata;
+	struct i2c_board_info *i2c_info = info;
+	int intr = get_gpio_by_name("thermal_int");
+	int intr2nd = get_gpio_by_name("thermal_alert");
+
+	if (intr == -1 || intr2nd == -1)
+		return NULL;
+
+	i2c_info->irq = intr + MRST_IRQ_OFFSET;
+	intr2nd_pdata = intr2nd + MRST_IRQ_OFFSET;
+
+	return &intr2nd_pdata;
+}
+
+static void __init *lis331dl_platform_data(void *info)
+{
+	static short intr2nd_pdata;
+	struct i2c_board_info *i2c_info = info;
+	int intr = get_gpio_by_name("accel_int");
+	int intr2nd = get_gpio_by_name("accel_2");
+
+	if (intr == -1 || intr2nd == -1)
+		return NULL;
+
+	i2c_info->irq = intr + MRST_IRQ_OFFSET;
+	intr2nd_pdata = intr2nd + MRST_IRQ_OFFSET;
+
+	return &intr2nd_pdata;
+}
+
+static void __init *no_platform_data(void *info)
+{
+	return NULL;
+}
+
+static const struct devs_id __initconst device_ids[] = {
+	{"pmic_gpio", SFI_DEV_TYPE_SPI, 1, &pmic_gpio_platform_data},
+	{"spi_max3111", SFI_DEV_TYPE_SPI, 0, &max3111_platform_data},
+	{"i2c_max7315", SFI_DEV_TYPE_I2C, 1, &max7315_platform_data},
+	{"i2c_max7315_2", SFI_DEV_TYPE_I2C, 1, &max7315_platform_data},
+	{"emc1403", SFI_DEV_TYPE_I2C, 1, &emc1403_platform_data},
+	{"i2c_accel", SFI_DEV_TYPE_I2C, 0, &lis331dl_platform_data},
+	{"pmic_audio", SFI_DEV_TYPE_IPC, 1, &no_platform_data},
+	{"msic_audio", SFI_DEV_TYPE_IPC, 1, &no_platform_data},
+	{},
+};
+
+#define MAX_IPCDEVS	24
+static struct platform_device *ipc_devs[MAX_IPCDEVS];
+static int ipc_next_dev;
+
+#define MAX_SCU_SPI	24
+static struct spi_board_info *spi_devs[MAX_SCU_SPI];
+static int spi_next_dev;
+
+#define MAX_SCU_I2C	24
+static struct i2c_board_info *i2c_devs[MAX_SCU_I2C];
+static int i2c_bus[MAX_SCU_I2C];
+static int i2c_next_dev;
+
+static void __init intel_scu_device_register(struct platform_device *pdev)
+{
+	if(ipc_next_dev == MAX_IPCDEVS)
+		pr_err("too many SCU IPC devices");
+	else
+		ipc_devs[ipc_next_dev++] = pdev;
+}
+
+static void __init intel_scu_spi_device_register(struct spi_board_info *sdev)
+{
+	struct spi_board_info *new_dev;
+
+	if (spi_next_dev == MAX_SCU_SPI) {
+		pr_err("too many SCU SPI devices");
+		return;
+	}
+
+	new_dev = kzalloc(sizeof(*sdev), GFP_KERNEL);
+	if (!new_dev) {
+		pr_err("failed to alloc mem for delayed spi dev %s\n",
+			sdev->modalias);
+		return;
+	}
+	memcpy(new_dev, sdev, sizeof(*sdev));
+
+	spi_devs[spi_next_dev++] = new_dev;
+}
+
+static void __init intel_scu_i2c_device_register(int bus,
+						struct i2c_board_info *idev)
+{
+	struct i2c_board_info *new_dev;
+
+	if (i2c_next_dev == MAX_SCU_I2C) {
+		pr_err("too many SCU I2C devices");
+		return;
+	}
+
+	new_dev = kzalloc(sizeof(*idev), GFP_KERNEL);
+	if (!new_dev) {
+		pr_err("failed to alloc mem for delayed i2c dev %s\n",
+			idev->type);
+		return;
+	}
+	memcpy(new_dev, idev, sizeof(*idev));
+
+	i2c_bus[i2c_next_dev] = bus;
+	i2c_devs[i2c_next_dev++] = new_dev;
+}
+
+/* Called by IPC driver */
+void intel_scu_devices_create(void)
+{
+	int i;
+
+	for (i = 0; i < ipc_next_dev; i++)
+		platform_device_add(ipc_devs[i]);
+
+	for (i = 0; i < spi_next_dev; i++)
+		spi_register_board_info(spi_devs[i], 1);
+
+	for (i = 0; i < i2c_next_dev; i++) {
+		struct i2c_adapter *adapter;
+		struct i2c_client *client;
+
+		adapter = i2c_get_adapter(i2c_bus[i]);
+		if (adapter) {
+			client = i2c_new_device(adapter, i2c_devs[i]);
+			if (!client)
+				pr_err("can't create i2c device %s\n",
+					i2c_devs[i]->type);
+		} else
+			i2c_register_board_info(i2c_bus[i], i2c_devs[i], 1);
+	}
+}
+EXPORT_SYMBOL_GPL(intel_scu_devices_create);
+
+/* Called by IPC driver */
+void intel_scu_devices_destroy(void)
+{
+	int i;
+
+	for (i = 0; i < ipc_next_dev; i++)
+		platform_device_del(ipc_devs[i]);
+}
+EXPORT_SYMBOL_GPL(intel_scu_devices_destroy);
+
+static void __init install_irq_resource(struct platform_device *pdev, int irq)
+{
+	/* Single threaded */
+	static struct resource __initdata res = {
+		.name = "IRQ",
+		.flags = IORESOURCE_IRQ,
+	};
+	res.start = irq;
+	platform_device_add_resources(pdev, &res, 1);
+}
+
+static void __init sfi_handle_ipc_dev(struct platform_device *pdev)
+{
+	const struct devs_id *dev = device_ids;
+	void *pdata = NULL;
+
+	while (dev->name[0]) {
+		if (dev->type == SFI_DEV_TYPE_IPC &&
+			!strncmp(dev->name, pdev->name, SFI_NAME_LEN)) {
+			pdata = dev->get_platform_data(pdev);
+			break;
+		}
+		dev++;
+	}
+	pdev->dev.platform_data = pdata;
+	intel_scu_device_register(pdev);
+}
+
+static void __init sfi_handle_spi_dev(struct spi_board_info *spi_info)
+{
+	const struct devs_id *dev = device_ids;
+	void *pdata = NULL;
+
+	while (dev->name[0]) {
+		if (dev->type == SFI_DEV_TYPE_SPI &&
+				!strncmp(dev->name, spi_info->modalias, SFI_NAME_LEN)) {
+			pdata = dev->get_platform_data(spi_info);
+			break;
+		}
+		dev++;
+	}
+	spi_info->platform_data = pdata;
+	if (dev->delay)
+		intel_scu_spi_device_register(spi_info);
+	else
+		spi_register_board_info(spi_info, 1);
+}
+
+static void __init sfi_handle_i2c_dev(int bus, struct i2c_board_info *i2c_info)
+{
+	const struct devs_id *dev = device_ids;
+	void *pdata = NULL;
+
+	while (dev->name[0]) {
+		if (dev->type == SFI_DEV_TYPE_I2C &&
+			!strncmp(dev->name, i2c_info->type, SFI_NAME_LEN)) {
+			pdata = dev->get_platform_data(i2c_info);
+			break;
+		}
+		dev++;
+	}
+	i2c_info->platform_data = pdata;
+
+	if (dev->delay)
+		intel_scu_i2c_device_register(bus, i2c_info);
+	else
+		i2c_register_board_info(bus, i2c_info, 1);
+ }
+
+
+static int __init sfi_parse_devs(struct sfi_table_header *table)
+{
+	struct sfi_table_simple *sb;
+	struct sfi_device_table_entry *pentry;
+	struct spi_board_info spi_info;
+	struct i2c_board_info i2c_info;
+	struct platform_device *pdev;
+	int num, i, bus;
+	int ioapic;
+	struct io_apic_irq_attr irq_attr;
+
+	sb = (struct sfi_table_simple *)table;
+	num = SFI_GET_NUM_ENTRIES(sb, struct sfi_device_table_entry);
+	pentry = (struct sfi_device_table_entry *)sb->pentry;
+
+	for (i = 0; i < num; i++, pentry++) {
+		if (pentry->irq != (u8)0xff) { /* native RTE case */
+			/* these SPI2 devices are not exposed to system as PCI
+			 * devices, but they have separate RTE entry in IOAPIC
+			 * so we have to enable them one by one here
+			 */
+			ioapic = mp_find_ioapic(pentry->irq);
+			irq_attr.ioapic = ioapic;
+			irq_attr.ioapic_pin = pentry->irq;
+			irq_attr.trigger = 1;
+			irq_attr.polarity = 1;
+			io_apic_set_pci_routing(NULL, pentry->irq, &irq_attr);
+		}
+		switch (pentry->type) {
+		case SFI_DEV_TYPE_IPC:
+			/* ID as IRQ is a hack that will go away */
+			pdev = platform_device_alloc(pentry->name, pentry->irq);
+			if (pdev == NULL) {
+				pr_err("out of memory for SFI platform device '%s'.\n",
+							pentry->name);
+				continue;
+			}
+			install_irq_resource(pdev, pentry->irq);
+			pr_debug("info[%2d]: IPC bus, name = %16.16s, "
+				"irq = 0x%2x\n", i, pentry->name, pentry->irq);
+			sfi_handle_ipc_dev(pdev);
+			break;
+		case SFI_DEV_TYPE_SPI:
+			memset(&spi_info, 0, sizeof(spi_info));
+			strncpy(spi_info.modalias, pentry->name, SFI_NAME_LEN);
+			spi_info.irq = pentry->irq;
+			spi_info.bus_num = pentry->host_num;
+			spi_info.chip_select = pentry->addr;
+			spi_info.max_speed_hz = pentry->max_freq;
+			pr_debug("info[%2d]: SPI bus = %d, name = %16.16s, "
+				"irq = 0x%2x, max_freq = %d, cs = %d\n", i,
+				spi_info.bus_num,
+				spi_info.modalias,
+				spi_info.irq,
+				spi_info.max_speed_hz,
+				spi_info.chip_select);
+			sfi_handle_spi_dev(&spi_info);
+			break;
+		case SFI_DEV_TYPE_I2C:
+			memset(&i2c_info, 0, sizeof(i2c_info));
+			bus = pentry->host_num;
+			strncpy(i2c_info.type, pentry->name, SFI_NAME_LEN);
+			i2c_info.irq = pentry->irq;
+			i2c_info.addr = pentry->addr;
+			pr_debug("info[%2d]: I2C bus = %d, name = %16.16s, "
+				"irq = 0x%2x, addr = 0x%x\n", i, bus,
+				i2c_info.type,
+				i2c_info.irq,
+				i2c_info.addr);
+			sfi_handle_i2c_dev(bus, &i2c_info);
+			break;
+		case SFI_DEV_TYPE_UART:
+		case SFI_DEV_TYPE_HSI:
+		default:
+			;
+		}
+	}
+	return 0;
+}
+
+static int __init mrst_platform_init(void)
+{
+	sfi_table_parse(SFI_SIG_GPIO, NULL, NULL, sfi_parse_gpio);
+	sfi_table_parse(SFI_SIG_DEVS, NULL, NULL, sfi_parse_devs);
+	return 0;
+}
+arch_initcall(mrst_platform_init);
+
+/*
+ * we will search these buttons in SFI GPIO table (by name)
+ * and register them dynamically. Please add all possible
+ * buttons here, we will shrink them if no GPIO found.
+ */
+static struct gpio_keys_button gpio_button[] = {
+	{KEY_POWER,		-1, 1, "power_btn",	EV_KEY, 0, 3000},
+	{KEY_PROG1,		-1, 1, "prog_btn1",	EV_KEY, 0, 20},
+	{KEY_PROG2,		-1, 1, "prog_btn2",	EV_KEY, 0, 20},
+	{SW_LID,		-1, 1, "lid_switch",	EV_SW,  0, 20},
+	{KEY_VOLUMEUP,		-1, 1, "vol_up",	EV_KEY, 0, 20},
+	{KEY_VOLUMEDOWN,	-1, 1, "vol_down",	EV_KEY, 0, 20},
+	{KEY_CAMERA,		-1, 1, "camera_full",	EV_KEY, 0, 20},
+	{KEY_CAMERA_FOCUS,	-1, 1, "camera_half",	EV_KEY, 0, 20},
+	{SW_KEYPAD_SLIDE,	-1, 1, "MagSw1",	EV_SW,  0, 20},
+	{SW_KEYPAD_SLIDE,	-1, 1, "MagSw2",	EV_SW,  0, 20},
+};
+
+static struct gpio_keys_platform_data mrst_gpio_keys = {
+	.buttons	= gpio_button,
+	.rep		= 1,
+	.nbuttons	= -1, /* will fill it after search */
+};
+
+static struct platform_device pb_device = {
+	.name		= "gpio-keys",
+	.id		= -1,
+	.dev		= {
+		.platform_data	= &mrst_gpio_keys,
+	},
+};
+
+/*
+ * Shrink the non-existent buttons, register the gpio button
+ * device if there is some
+ */
+static int __init pb_keys_init(void)
+{
+	struct gpio_keys_button *gb = gpio_button;
+	int i, num, good = 0;
+
+	num = sizeof(gpio_button) / sizeof(struct gpio_keys_button);
+	for (i = 0; i < num; i++) {
+		gb[i].gpio = get_gpio_by_name(gb[i].desc);
+		if (gb[i].gpio == -1)
+			continue;
+
+		if (i != good)
+			gb[good] = gb[i];
+		good++;
+	}
+
+	if (good) {
+		mrst_gpio_keys.nbuttons = good;
+		return platform_device_register(&pb_device);
+	}
+	return 0;
+}
+late_initcall(pb_keys_init);
diff --git a/arch/x86/platform/mrst/vrtc.c b/arch/x86/platform/mrst/vrtc.c
new file mode 100644
index 0000000..32cd7ed
--- /dev/null
+++ b/arch/x86/platform/mrst/vrtc.c
@@ -0,0 +1,165 @@
+/*
+ * vrtc.c: Driver for virtual RTC device on Intel MID platform
+ *
+ * (C) Copyright 2009 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ *
+ * Note:
+ * VRTC is emulated by system controller firmware, the real HW
+ * RTC is located in the PMIC device. SCU FW shadows PMIC RTC
+ * in a memory mapped IO space that is visible to the host IA
+ * processor.
+ *
+ * This driver is based on RTC CMOS driver.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/sfi.h>
+#include <linux/platform_device.h>
+
+#include <asm/mrst.h>
+#include <asm/mrst-vrtc.h>
+#include <asm/time.h>
+#include <asm/fixmap.h>
+
+static unsigned char __iomem *vrtc_virt_base;
+
+unsigned char vrtc_cmos_read(unsigned char reg)
+{
+	unsigned char retval;
+
+	/* vRTC's registers range from 0x0 to 0xD */
+	if (reg > 0xd || !vrtc_virt_base)
+		return 0xff;
+
+	lock_cmos_prefix(reg);
+	retval = __raw_readb(vrtc_virt_base + (reg << 2));
+	lock_cmos_suffix(reg);
+	return retval;
+}
+EXPORT_SYMBOL_GPL(vrtc_cmos_read);
+
+void vrtc_cmos_write(unsigned char val, unsigned char reg)
+{
+	if (reg > 0xd || !vrtc_virt_base)
+		return;
+
+	lock_cmos_prefix(reg);
+	__raw_writeb(val, vrtc_virt_base + (reg << 2));
+	lock_cmos_suffix(reg);
+}
+EXPORT_SYMBOL_GPL(vrtc_cmos_write);
+
+unsigned long vrtc_get_time(void)
+{
+	u8 sec, min, hour, mday, mon;
+	u32 year;
+
+	while ((vrtc_cmos_read(RTC_FREQ_SELECT) & RTC_UIP))
+		cpu_relax();
+
+	sec = vrtc_cmos_read(RTC_SECONDS);
+	min = vrtc_cmos_read(RTC_MINUTES);
+	hour = vrtc_cmos_read(RTC_HOURS);
+	mday = vrtc_cmos_read(RTC_DAY_OF_MONTH);
+	mon = vrtc_cmos_read(RTC_MONTH);
+	year = vrtc_cmos_read(RTC_YEAR);
+
+	/* vRTC YEAR reg contains the offset to 1960 */
+	year += 1960;
+
+	printk(KERN_INFO "vRTC: sec: %d min: %d hour: %d day: %d "
+		"mon: %d year: %d\n", sec, min, hour, mday, mon, year);
+
+	return mktime(year, mon, mday, hour, min, sec);
+}
+
+/* Only care about the minutes and seconds */
+int vrtc_set_mmss(unsigned long nowtime)
+{
+	int real_sec, real_min;
+	int vrtc_min;
+
+	vrtc_min = vrtc_cmos_read(RTC_MINUTES);
+
+	real_sec = nowtime % 60;
+	real_min = nowtime / 60;
+	if (((abs(real_min - vrtc_min) + 15)/30) & 1)
+		real_min += 30;
+	real_min %= 60;
+
+	vrtc_cmos_write(real_sec, RTC_SECONDS);
+	vrtc_cmos_write(real_min, RTC_MINUTES);
+	return 0;
+}
+
+void __init mrst_rtc_init(void)
+{
+	unsigned long rtc_paddr;
+	void __iomem *virt_base;
+
+	sfi_table_parse(SFI_SIG_MRTC, NULL, NULL, sfi_parse_mrtc);
+	if (!sfi_mrtc_num)
+		return;
+
+	rtc_paddr = sfi_mrtc_array[0].phys_addr;
+
+	/* vRTC's register address may not be page aligned */
+	set_fixmap_nocache(FIX_LNW_VRTC, rtc_paddr);
+
+	virt_base = (void __iomem *)__fix_to_virt(FIX_LNW_VRTC);
+	virt_base += rtc_paddr & ~PAGE_MASK;
+	vrtc_virt_base = virt_base;
+
+	x86_platform.get_wallclock = vrtc_get_time;
+	x86_platform.set_wallclock = vrtc_set_mmss;
+}
+
+/*
+ * The Moorestown platform has a memory mapped virtual RTC device that emulates
+ * the programming interface of the RTC.
+ */
+
+static struct resource vrtc_resources[] = {
+	[0] = {
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.flags	= IORESOURCE_IRQ,
+	}
+};
+
+static struct platform_device vrtc_device = {
+	.name		= "rtc_mrst",
+	.id		= -1,
+	.resource	= vrtc_resources,
+	.num_resources	= ARRAY_SIZE(vrtc_resources),
+};
+
+/* Register the RTC device if appropriate */
+static int __init mrst_device_create(void)
+{
+	/* No Moorestown, no device */
+	if (!mrst_identify_cpu())
+		return -ENODEV;
+	/* No timer, no device */
+	if (!sfi_mrtc_num)
+		return -ENODEV;
+
+	/* iomem resource */
+	vrtc_resources[0].start = sfi_mrtc_array[0].phys_addr;
+	vrtc_resources[0].end = sfi_mrtc_array[0].phys_addr +
+				MRST_VRTC_MAP_SZ;
+	/* irq resource */
+	vrtc_resources[1].start = sfi_mrtc_array[0].irq;
+	vrtc_resources[1].end = sfi_mrtc_array[0].irq;
+
+	return platform_device_register(&vrtc_device);
+}
+
+module_init(mrst_device_create);
diff --git a/drivers/platform/x86/intel_scu_ipc.c b/drivers/platform/x86/intel_scu_ipc.c
index 41a9e34..ca35b0c 100644
--- a/drivers/platform/x86/intel_scu_ipc.c
+++ b/drivers/platform/x86/intel_scu_ipc.c
@@ -26,6 +26,7 @@
 #include <linux/sfi.h>
 #include <asm/mrst.h>
 #include <asm/intel_scu_ipc.h>
+#include <asm/mrst.h>
 
 /* IPC defines the following message types */
 #define IPCMSG_WATCHDOG_TIMER 0xF8 /* Set Kernel Watchdog Threshold */
@@ -699,6 +700,9 @@ static int ipc_probe(struct pci_dev *dev, const struct pci_device_id *id)
 		iounmap(ipcdev.ipc_base);
 		return -ENOMEM;
 	}
+
+	intel_scu_devices_create();
+
 	return 0;
 }
 
@@ -720,6 +724,7 @@ static void ipc_remove(struct pci_dev *pdev)
 	iounmap(ipcdev.ipc_base);
 	iounmap(ipcdev.i2c_base);
 	ipcdev.pdev = NULL;
+	intel_scu_devices_destroy();
 }
 
 static const struct pci_device_id pci_ids[] = {
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 2883428..4941cad 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -463,6 +463,18 @@ config RTC_DRV_CMOS
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-cmos.
 
+config RTC_DRV_VRTC
+	tristate "Virtual RTC for Moorestown platforms"
+	depends on X86_MRST
+	default y if X86_MRST
+
+	help
+	Say "yes" here to get direct support for the real time clock
+	found on Moorestown platforms. The VRTC is a emulated RTC that
+	derives its clock source from a real RTC in the PMIC. The MC146818
+	style programming interface is mostly conserved, but any
+	updates are done via IPC calls to the system controller FW.
+
 config RTC_DRV_DS1216
 	tristate "Dallas DS1216"
 	depends on SNI_RM
diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
index 4c2832d..2afdaf3 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -30,6 +30,7 @@ obj-$(CONFIG_RTC_DRV_CMOS)	+= rtc-cmos.o
 obj-$(CONFIG_RTC_DRV_COH901331)	+= rtc-coh901331.o
 obj-$(CONFIG_RTC_DRV_DAVINCI)	+= rtc-davinci.o
 obj-$(CONFIG_RTC_DRV_DM355EVM)	+= rtc-dm355evm.o
+obj-$(CONFIG_RTC_DRV_VRTC)	+= rtc-mrst.o
 obj-$(CONFIG_RTC_DRV_DS1216)	+= rtc-ds1216.o
 obj-$(CONFIG_RTC_DRV_DS1286)	+= rtc-ds1286.o
 obj-$(CONFIG_RTC_DRV_DS1302)	+= rtc-ds1302.o
diff --git a/drivers/rtc/rtc-mrst.c b/drivers/rtc/rtc-mrst.c
new file mode 100644
index 0000000..bcd0cf6
--- /dev/null
+++ b/drivers/rtc/rtc-mrst.c
@@ -0,0 +1,582 @@
+/*
+ * rtc-mrst.c: Driver for Moorestown virtual RTC
+ *
+ * (C) Copyright 2009 Intel Corporation
+ * Author: Jacob Pan (jacob.jun.pan@intel.com)
+ *	   Feng Tang (feng.tang@intel.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ *
+ * Note:
+ * VRTC is emulated by system controller firmware, the real HW
+ * RTC is located in the PMIC device. SCU FW shadows PMIC RTC
+ * in a memory mapped IO space that is visible to the host IA
+ * processor.
+ *
+ * This driver is based upon drivers/rtc/rtc-cmos.c
+ */
+
+/*
+ * Note:
+ *  * vRTC only supports binary mode and 24H mode
+ *  * vRTC only support PIE and AIE, no UIE, and its PIE only happens
+ *    at 23:59:59pm everyday, no support for adjustable frequency
+ *  * Alarm function is also limited to hr/min/sec.
+ */
+
+#include <linux/mod_devicetable.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/sfi.h>
+
+#include <asm-generic/rtc.h>
+#include <asm/intel_scu_ipc.h>
+#include <asm/mrst.h>
+#include <asm/mrst-vrtc.h>
+
+struct mrst_rtc {
+	struct rtc_device	*rtc;
+	struct device		*dev;
+	int			irq;
+	struct resource		*iomem;
+
+	u8			enabled_wake;
+	u8			suspend_ctrl;
+};
+
+static const char driver_name[] = "rtc_mrst";
+
+#define	RTC_IRQMASK	(RTC_PF | RTC_AF)
+
+static inline int is_intr(u8 rtc_intr)
+{
+	if (!(rtc_intr & RTC_IRQF))
+		return 0;
+	return rtc_intr & RTC_IRQMASK;
+}
+
+/*
+ * rtc_time's year contains the increment over 1900, but vRTC's YEAR
+ * register can't be programmed to value larger than 0x64, so vRTC
+ * driver chose to use 1960 (1970 is UNIX time start point) as the base,
+ * and does the translation at read/write time.
+ *
+ * Why not just use 1970 as the offset? it's because using 1960 will
+ * make it consistent in leap year setting for both vrtc and low-level
+ * physical rtc devices.
+ */
+static int mrst_read_time(struct device *dev, struct rtc_time *time)
+{
+	unsigned long flags;
+
+	if (rtc_is_updating())
+		mdelay(20);
+
+	spin_lock_irqsave(&rtc_lock, flags);
+	time->tm_sec = vrtc_cmos_read(RTC_SECONDS);
+	time->tm_min = vrtc_cmos_read(RTC_MINUTES);
+	time->tm_hour = vrtc_cmos_read(RTC_HOURS);
+	time->tm_mday = vrtc_cmos_read(RTC_DAY_OF_MONTH);
+	time->tm_mon = vrtc_cmos_read(RTC_MONTH);
+	time->tm_year = vrtc_cmos_read(RTC_YEAR);
+	spin_unlock_irqrestore(&rtc_lock, flags);
+
+	/* Adjust for the 1960/1900 */
+	time->tm_year += 60;
+	time->tm_mon--;
+	return RTC_24H;
+}
+
+static int mrst_set_time(struct device *dev, struct rtc_time *time)
+{
+	int ret;
+	unsigned long flags;
+	unsigned char mon, day, hrs, min, sec;
+	unsigned int yrs;
+
+	yrs = time->tm_year;
+	mon = time->tm_mon + 1;   /* tm_mon starts at zero */
+	day = time->tm_mday;
+	hrs = time->tm_hour;
+	min = time->tm_min;
+	sec = time->tm_sec;
+
+	if (yrs < 70 || yrs > 138)
+		return -EINVAL;
+	yrs -= 60;
+
+	spin_lock_irqsave(&rtc_lock, flags);
+
+	vrtc_cmos_write(yrs, RTC_YEAR);
+	vrtc_cmos_write(mon, RTC_MONTH);
+	vrtc_cmos_write(day, RTC_DAY_OF_MONTH);
+	vrtc_cmos_write(hrs, RTC_HOURS);
+	vrtc_cmos_write(min, RTC_MINUTES);
+	vrtc_cmos_write(sec, RTC_SECONDS);
+
+	spin_unlock_irqrestore(&rtc_lock, flags);
+
+	ret = intel_scu_ipc_simple_command(IPCMSG_VRTC, IPC_CMD_VRTC_SETTIME);
+	return ret;
+}
+
+static int mrst_read_alarm(struct device *dev, struct rtc_wkalrm *t)
+{
+	struct mrst_rtc	*mrst = dev_get_drvdata(dev);
+	unsigned char rtc_control;
+
+	if (mrst->irq <= 0)
+		return -EIO;
+
+	/* Basic alarms only support hour, minute, and seconds fields.
+	 * Some also support day and month, for alarms up to a year in
+	 * the future.
+	 */
+	t->time.tm_mday = -1;
+	t->time.tm_mon = -1;
+	t->time.tm_year = -1;
+
+	/* vRTC only supports binary mode */
+	spin_lock_irq(&rtc_lock);
+	t->time.tm_sec = vrtc_cmos_read(RTC_SECONDS_ALARM);
+	t->time.tm_min = vrtc_cmos_read(RTC_MINUTES_ALARM);
+	t->time.tm_hour = vrtc_cmos_read(RTC_HOURS_ALARM);
+
+	rtc_control = vrtc_cmos_read(RTC_CONTROL);
+	spin_unlock_irq(&rtc_lock);
+
+	t->enabled = !!(rtc_control & RTC_AIE);
+	t->pending = 0;
+
+	return 0;
+}
+
+static void mrst_checkintr(struct mrst_rtc *mrst, unsigned char rtc_control)
+{
+	unsigned char	rtc_intr;
+
+	/*
+	 * NOTE after changing RTC_xIE bits we always read INTR_FLAGS;
+	 * allegedly some older rtcs need that to handle irqs properly
+	 */
+	rtc_intr = vrtc_cmos_read(RTC_INTR_FLAGS);
+	rtc_intr &= (rtc_control & RTC_IRQMASK) | RTC_IRQF;
+	if (is_intr(rtc_intr))
+		rtc_update_irq(mrst->rtc, 1, rtc_intr);
+}
+
+static void mrst_irq_enable(struct mrst_rtc *mrst, unsigned char mask)
+{
+	unsigned char	rtc_control;
+
+	/*
+	 * Flush any pending IRQ status, notably for update irqs,
+	 * before we enable new IRQs
+	 */
+	rtc_control = vrtc_cmos_read(RTC_CONTROL);
+	mrst_checkintr(mrst, rtc_control);
+
+	rtc_control |= mask;
+	vrtc_cmos_write(rtc_control, RTC_CONTROL);
+
+	mrst_checkintr(mrst, rtc_control);
+}
+
+static void mrst_irq_disable(struct mrst_rtc *mrst, unsigned char mask)
+{
+	unsigned char	rtc_control;
+
+	rtc_control = vrtc_cmos_read(RTC_CONTROL);
+	rtc_control &= ~mask;
+	vrtc_cmos_write(rtc_control, RTC_CONTROL);
+	mrst_checkintr(mrst, rtc_control);
+}
+
+static int mrst_set_alarm(struct device *dev, struct rtc_wkalrm *t)
+{
+	struct mrst_rtc	*mrst = dev_get_drvdata(dev);
+	unsigned char hrs, min, sec;
+	int ret = 0;
+
+	if (!mrst->irq)
+		return -EIO;
+
+	hrs = t->time.tm_hour;
+	min = t->time.tm_min;
+	sec = t->time.tm_sec;
+
+	spin_lock_irq(&rtc_lock);
+	/* Next rtc irq must not be from previous alarm setting */
+	mrst_irq_disable(mrst, RTC_AIE);
+
+	/* Update alarm */
+	vrtc_cmos_write(hrs, RTC_HOURS_ALARM);
+	vrtc_cmos_write(min, RTC_MINUTES_ALARM);
+	vrtc_cmos_write(sec, RTC_SECONDS_ALARM);
+
+	spin_unlock_irq(&rtc_lock);
+
+	ret = intel_scu_ipc_simple_command(IPCMSG_VRTC, IPC_CMD_VRTC_SETALARM);
+	if (ret)
+		return ret;
+
+	spin_lock_irq(&rtc_lock);
+	if (t->enabled)
+		mrst_irq_enable(mrst, RTC_AIE);
+
+	spin_unlock_irq(&rtc_lock);
+
+	return 0;
+}
+
+static int mrst_irq_set_state(struct device *dev, int enabled)
+{
+	struct mrst_rtc	*mrst = dev_get_drvdata(dev);
+	unsigned long	flags;
+
+	if (!mrst->irq)
+		return -ENXIO;
+
+	spin_lock_irqsave(&rtc_lock, flags);
+
+	if (enabled)
+		mrst_irq_enable(mrst, RTC_PIE);
+	else
+		mrst_irq_disable(mrst, RTC_PIE);
+
+	spin_unlock_irqrestore(&rtc_lock, flags);
+	return 0;
+}
+
+#if defined(CONFIG_RTC_INTF_DEV) || defined(CONFIG_RTC_INTF_DEV_MODULE)
+
+/* Currently, the vRTC doesn't support UIE ON/OFF */
+static int
+mrst_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
+{
+	struct mrst_rtc	*mrst = dev_get_drvdata(dev);
+	unsigned long	flags;
+
+	switch (cmd) {
+	case RTC_AIE_OFF:
+	case RTC_AIE_ON:
+		if (!mrst->irq)
+			return -EINVAL;
+		break;
+	default:
+		/* PIE ON/OFF is handled by mrst_irq_set_state() */
+		return -ENOIOCTLCMD;
+	}
+
+	spin_lock_irqsave(&rtc_lock, flags);
+	switch (cmd) {
+	case RTC_AIE_OFF:	/* alarm off */
+		mrst_irq_disable(mrst, RTC_AIE);
+		break;
+	case RTC_AIE_ON:	/* alarm on */
+		mrst_irq_enable(mrst, RTC_AIE);
+		break;
+	}
+	spin_unlock_irqrestore(&rtc_lock, flags);
+	return 0;
+}
+
+#else
+#define	mrst_rtc_ioctl	NULL
+#endif
+
+#if defined(CONFIG_RTC_INTF_PROC) || defined(CONFIG_RTC_INTF_PROC_MODULE)
+
+static int mrst_procfs(struct device *dev, struct seq_file *seq)
+{
+	unsigned char	rtc_control, valid;
+
+	spin_lock_irq(&rtc_lock);
+	rtc_control = vrtc_cmos_read(RTC_CONTROL);
+	valid = vrtc_cmos_read(RTC_VALID);
+	spin_unlock_irq(&rtc_lock);
+
+	return seq_printf(seq,
+			"periodic_IRQ\t: %s\n"
+			"alarm\t\t: %s\n"
+			"BCD\t\t: no\n"
+			"periodic_freq\t: daily (not adjustable)\n",
+			(rtc_control & RTC_PIE) ? "on" : "off",
+			(rtc_control & RTC_AIE) ? "on" : "off");
+}
+
+#else
+#define	mrst_procfs	NULL
+#endif
+
+static const struct rtc_class_ops mrst_rtc_ops = {
+	.ioctl		= mrst_rtc_ioctl,
+	.read_time	= mrst_read_time,
+	.set_time	= mrst_set_time,
+	.read_alarm	= mrst_read_alarm,
+	.set_alarm	= mrst_set_alarm,
+	.proc		= mrst_procfs,
+	.irq_set_state	= mrst_irq_set_state,
+};
+
+static struct mrst_rtc	mrst_rtc;
+
+/*
+ * When vRTC IRQ is captured by SCU FW, FW will clear the AIE bit in
+ * Reg B, so no need for this driver to clear it
+ */
+static irqreturn_t mrst_rtc_irq(int irq, void *p)
+{
+	u8 irqstat;
+
+	spin_lock(&rtc_lock);
+	/* This read will clear all IRQ flags inside Reg C */
+	irqstat = vrtc_cmos_read(RTC_INTR_FLAGS);
+	spin_unlock(&rtc_lock);
+
+	irqstat &= RTC_IRQMASK | RTC_IRQF;
+	if (is_intr(irqstat)) {
+		rtc_update_irq(p, 1, irqstat);
+		return IRQ_HANDLED;
+	}
+	return IRQ_NONE;
+}
+
+static int __init
+vrtc_mrst_do_probe(struct device *dev, struct resource *iomem, int rtc_irq)
+{
+	int retval = 0;
+	unsigned char rtc_control;
+
+	/* There can be only one ... */
+	if (mrst_rtc.dev)
+		return -EBUSY;
+
+	if (!iomem)
+		return -ENODEV;
+
+	iomem = request_mem_region(iomem->start,
+			iomem->end + 1 - iomem->start,
+			driver_name);
+	if (!iomem) {
+		dev_dbg(dev, "i/o mem already in use.\n");
+		return -EBUSY;
+	}
+
+	mrst_rtc.irq = rtc_irq;
+	mrst_rtc.iomem = iomem;
+
+	mrst_rtc.rtc = rtc_device_register(driver_name, dev,
+				&mrst_rtc_ops, THIS_MODULE);
+	if (IS_ERR(mrst_rtc.rtc)) {
+		retval = PTR_ERR(mrst_rtc.rtc);
+		goto cleanup0;
+	}
+
+	mrst_rtc.dev = dev;
+	dev_set_drvdata(dev, &mrst_rtc);
+	rename_region(iomem, dev_name(&mrst_rtc.rtc->dev));
+
+	spin_lock_irq(&rtc_lock);
+	mrst_irq_disable(&mrst_rtc, RTC_PIE | RTC_AIE);
+	rtc_control = vrtc_cmos_read(RTC_CONTROL);
+	spin_unlock_irq(&rtc_lock);
+
+	if (!(rtc_control & RTC_24H) || (rtc_control & (RTC_DM_BINARY)))
+		dev_dbg(dev, "TODO: support more than 24-hr BCD mode\n");
+
+	if (rtc_irq) {
+		retval = request_irq(rtc_irq, mrst_rtc_irq,
+				IRQF_DISABLED, dev_name(&mrst_rtc.rtc->dev),
+				mrst_rtc.rtc);
+		if (retval < 0) {
+			dev_dbg(dev, "IRQ %d is already in use, err %d\n",
+				rtc_irq, retval);
+			goto cleanup1;
+		}
+	}
+	dev_dbg(dev, "initialised\n");
+	return 0;
+
+cleanup1:
+	mrst_rtc.dev = NULL;
+	rtc_device_unregister(mrst_rtc.rtc);
+cleanup0:
+	release_region(iomem->start, iomem->end + 1 - iomem->start);
+	dev_err(dev, "rtc-mrst: unable to initialise\n");
+	return retval;
+}
+
+static void rtc_mrst_do_shutdown(void)
+{
+	spin_lock_irq(&rtc_lock);
+	mrst_irq_disable(&mrst_rtc, RTC_IRQMASK);
+	spin_unlock_irq(&rtc_lock);
+}
+
+static void __exit rtc_mrst_do_remove(struct device *dev)
+{
+	struct mrst_rtc	*mrst = dev_get_drvdata(dev);
+	struct resource *iomem;
+
+	rtc_mrst_do_shutdown();
+
+	if (mrst->irq)
+		free_irq(mrst->irq, mrst->rtc);
+
+	rtc_device_unregister(mrst->rtc);
+	mrst->rtc = NULL;
+
+	iomem = mrst->iomem;
+	release_region(iomem->start, iomem->end + 1 - iomem->start);
+	mrst->iomem = NULL;
+
+	mrst->dev = NULL;
+	dev_set_drvdata(dev, NULL);
+}
+
+#ifdef	CONFIG_PM
+static int mrst_suspend(struct device *dev, pm_message_t mesg)
+{
+	struct mrst_rtc	*mrst = dev_get_drvdata(dev);
+	unsigned char	tmp;
+
+	/* Only the alarm might be a wakeup event source */
+	spin_lock_irq(&rtc_lock);
+	mrst->suspend_ctrl = tmp = vrtc_cmos_read(RTC_CONTROL);
+	if (tmp & (RTC_PIE | RTC_AIE)) {
+		unsigned char	mask;
+
+		if (device_may_wakeup(dev))
+			mask = RTC_IRQMASK & ~RTC_AIE;
+		else
+			mask = RTC_IRQMASK;
+		tmp &= ~mask;
+		vrtc_cmos_write(tmp, RTC_CONTROL);
+
+		mrst_checkintr(mrst, tmp);
+	}
+	spin_unlock_irq(&rtc_lock);
+
+	if (tmp & RTC_AIE) {
+		mrst->enabled_wake = 1;
+		enable_irq_wake(mrst->irq);
+	}
+
+	dev_dbg(&mrst_rtc.rtc->dev, "suspend%s, ctrl %02x\n",
+			(tmp & RTC_AIE) ? ", alarm may wake" : "",
+			tmp);
+
+	return 0;
+}
+
+/*
+ * We want RTC alarms to wake us from the deep power saving state
+ */
+static inline int mrst_poweroff(struct device *dev)
+{
+	return mrst_suspend(dev, PMSG_HIBERNATE);
+}
+
+static int mrst_resume(struct device *dev)
+{
+	struct mrst_rtc	*mrst = dev_get_drvdata(dev);
+	unsigned char tmp = mrst->suspend_ctrl;
+
+	/* Re-enable any irqs previously active */
+	if (tmp & RTC_IRQMASK) {
+		unsigned char	mask;
+
+		if (mrst->enabled_wake) {
+			disable_irq_wake(mrst->irq);
+			mrst->enabled_wake = 0;
+		}
+
+		spin_lock_irq(&rtc_lock);
+		do {
+			vrtc_cmos_write(tmp, RTC_CONTROL);
+
+			mask = vrtc_cmos_read(RTC_INTR_FLAGS);
+			mask &= (tmp & RTC_IRQMASK) | RTC_IRQF;
+			if (!is_intr(mask))
+				break;
+
+			rtc_update_irq(mrst->rtc, 1, mask);
+			tmp &= ~RTC_AIE;
+		} while (mask & RTC_AIE);
+		spin_unlock_irq(&rtc_lock);
+	}
+
+	dev_dbg(&mrst_rtc.rtc->dev, "resume, ctrl %02x\n", tmp);
+
+	return 0;
+}
+
+#else
+#define	mrst_suspend	NULL
+#define	mrst_resume	NULL
+
+static inline int mrst_poweroff(struct device *dev)
+{
+	return -ENOSYS;
+}
+
+#endif
+
+static int __init vrtc_mrst_platform_probe(struct platform_device *pdev)
+{
+	return vrtc_mrst_do_probe(&pdev->dev,
+			platform_get_resource(pdev, IORESOURCE_MEM, 0),
+			platform_get_irq(pdev, 0));
+}
+
+static int __exit vrtc_mrst_platform_remove(struct platform_device *pdev)
+{
+	rtc_mrst_do_remove(&pdev->dev);
+	return 0;
+}
+
+static void vrtc_mrst_platform_shutdown(struct platform_device *pdev)
+{
+	if (system_state == SYSTEM_POWER_OFF && !mrst_poweroff(&pdev->dev))
+		return;
+
+	rtc_mrst_do_shutdown();
+}
+
+MODULE_ALIAS("platform:vrtc_mrst");
+
+static struct platform_driver vrtc_mrst_platform_driver = {
+	.probe		= vrtc_mrst_platform_probe,
+	.remove		= __exit_p(vrtc_mrst_platform_remove),
+	.shutdown	= vrtc_mrst_platform_shutdown,
+	.driver = {
+		.name		= (char *) driver_name,
+		.suspend	= mrst_suspend,
+		.resume		= mrst_resume,
+	}
+};
+
+static int __init vrtc_mrst_init(void)
+{
+	return platform_driver_register(&vrtc_mrst_platform_driver);
+}
+
+static void __exit vrtc_mrst_exit(void)
+{
+	platform_driver_unregister(&vrtc_mrst_platform_driver);
+}
+
+module_init(vrtc_mrst_init);
+module_exit(vrtc_mrst_exit);
+
+MODULE_AUTHOR("Jacob Pan; Feng Tang");
+MODULE_DESCRIPTION("Driver for Moorestown virtual RTC");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/sfi.h b/include/linux/sfi.h
index 7f770c6..fe81791 100644
--- a/include/linux/sfi.h
+++ b/include/linux/sfi.h
@@ -77,6 +77,8 @@
 #define SFI_OEM_ID_SIZE		6
 #define SFI_OEM_TABLE_ID_SIZE	8
 
+#define SFI_NAME_LEN		16
+
 #define SFI_SYST_SEARCH_BEGIN		0x000E0000
 #define SFI_SYST_SEARCH_END		0x000FFFFF
 
@@ -156,13 +158,13 @@ struct sfi_device_table_entry {
 	u16	addr;
 	u8	irq;
 	u32	max_freq;
-	char	name[16];
+	char	name[SFI_NAME_LEN];
 } __packed;
 
 struct sfi_gpio_table_entry {
-	char	controller_name[16];
+	char	controller_name[SFI_NAME_LEN];
 	u16	pin_no;
-	char	pin_name[16];
+	char	pin_name[SFI_NAME_LEN];
 } __packed;
 
 typedef int (*sfi_table_handler) (struct sfi_table_header *table);
