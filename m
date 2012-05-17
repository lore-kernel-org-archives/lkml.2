Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933503Ab2EQQnB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 12:43:01 -0400
Received: from mail.windriver.com ([147.11.1.11]:40320 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933449Ab2EQQmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 12:42:45 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: JBottomley@parallels.com, Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <JBottomley@parallels.com>, x86@kernel.org
Subject: [PATCH 5/5] MCA: delete all remaining traces of microchannel bus support.
Date: Thu, 17 May 2012 12:40:41 -0400
Message-Id: <1337272841-25931-6-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1337272841-25931-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337272841-25931-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hardware with MCA bus is limited to 386 and 486 class machines
that are now 20+ years old and typically with less than 32MB
of memory.  A quick search on the internet, and you see that
even the MCA hobbyist/enthusiast community has lost interest
in the early 2000 era and never really even moved ahead from
the 2.4 kernels to the 2.6 series.

This deletes anything remaining related to CONFIG_MCA from core
kernel code and from the x86 architecture.  There is no point in
carrying this any further into the future.

One complication to watch for is inadvertently scooping up
stuff relating to machine check, since there is overlap in
the TLA name space (e.g. arch/x86/boot/mca.c).

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: x86@kernel.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 Documentation/00-INDEX                |    2 -
 Documentation/DocBook/Makefile        |    2 +-
 Documentation/DocBook/kernel-api.tmpl |   13 -
 Documentation/DocBook/mcabook.tmpl    |  107 --------
 Documentation/devices.txt             |    8 +-
 Documentation/eisa.txt                |    2 +-
 Documentation/kernel-parameters.txt   |    1 -
 Documentation/mca.txt                 |  313 ----------------------
 MAINTAINERS                           |   13 -
 arch/frv/include/asm/processor.h      |    1 -
 arch/x86/Kconfig                      |   10 -
 arch/x86/include/asm/mca.h            |   43 ---
 arch/x86/include/asm/mca_dma.h        |  201 --------------
 arch/x86/include/asm/mpspec.h         |    2 +-
 arch/x86/include/asm/mpspec_def.h     |    3 +-
 arch/x86/kernel/Makefile              |    1 -
 arch/x86/kernel/acpi/boot.c           |    2 +-
 arch/x86/kernel/apic/io_apic.c        |   17 +-
 arch/x86/kernel/mca_32.c              |  476 ---------------------------------
 arch/x86/kernel/mpparse.c             |   11 +-
 arch/x86/kernel/nmi.c                 |   12 -
 arch/x86/kernel/setup.c               |    8 -
 arch/x86/kernel/time.c                |    6 -
 arch/x86/kernel/traps.c               |    4 -
 drivers/Makefile                      |    1 -
 drivers/mca/Kconfig                   |   14 -
 drivers/mca/Makefile                  |    7 -
 drivers/mca/mca-bus.c                 |  169 ------------
 drivers/mca/mca-device.c              |  218 ---------------
 drivers/mca/mca-driver.c              |   63 -----
 drivers/mca/mca-legacy.c              |  329 -----------------------
 drivers/mca/mca-proc.c                |  249 -----------------
 drivers/message/i2o/i2o_proc.c        |   13 -
 include/linux/i2o-dev.h               |    2 +-
 include/linux/mca-legacy.h            |   66 -----
 include/linux/mca.h                   |  148 ----------
 scripts/kconfig/mconf.c               |    2 +-
 scripts/kconfig/nconf.c               |    2 +-
 38 files changed, 15 insertions(+), 2526 deletions(-)
 delete mode 100644 Documentation/DocBook/mcabook.tmpl
 delete mode 100644 Documentation/mca.txt
 delete mode 100644 arch/x86/include/asm/mca.h
 delete mode 100644 arch/x86/include/asm/mca_dma.h
 delete mode 100644 arch/x86/kernel/mca_32.c
 delete mode 100644 drivers/mca/Kconfig
 delete mode 100644 drivers/mca/Makefile
 delete mode 100644 drivers/mca/mca-bus.c
 delete mode 100644 drivers/mca/mca-device.c
 delete mode 100644 drivers/mca/mca-driver.c
 delete mode 100644 drivers/mca/mca-legacy.c
 delete mode 100644 drivers/mca/mca-proc.c
 delete mode 100644 include/linux/mca-legacy.h
 delete mode 100644 include/linux/mca.h

diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
index 2214f12..49c0513 100644
--- a/Documentation/00-INDEX
+++ b/Documentation/00-INDEX
@@ -218,8 +218,6 @@ m68k/
 	- directory with info about Linux on Motorola 68k architecture.
 magic-number.txt
 	- list of magic numbers used to mark/protect kernel data structures.
-mca.txt
-	- info on supporting Micro Channel Architecture (e.g. PS/2) systems.
 md.txt
 	- info on boot arguments for the multiple devices driver.
 memory-barriers.txt
diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
index 66725a3..bc3d9f8 100644
--- a/Documentation/DocBook/Makefile
+++ b/Documentation/DocBook/Makefile
@@ -6,7 +6,7 @@
 # To add a new book the only step required is to add the book to the
 # list of DOCBOOKS.
 
-DOCBOOKS := z8530book.xml mcabook.xml device-drivers.xml \
+DOCBOOKS := z8530book.xml device-drivers.xml \
 	    kernel-hacking.xml kernel-locking.xml deviceiobook.xml \
 	    writing_usb_driver.xml networking.xml \
 	    kernel-api.xml filesystems.xml lsm.xml usb.xml kgdb.xml \
diff --git a/Documentation/DocBook/kernel-api.tmpl b/Documentation/DocBook/kernel-api.tmpl
index 7160652..00687ee 100644
--- a/Documentation/DocBook/kernel-api.tmpl
+++ b/Documentation/DocBook/kernel-api.tmpl
@@ -212,19 +212,6 @@ X!Edrivers/pci/hotplug.c
      <sect1><title>PCI Hotplug Support Library</title>
 !Edrivers/pci/hotplug/pci_hotplug_core.c
      </sect1>
-     <sect1><title>MCA Architecture</title>
-	<sect2><title>MCA Device Functions</title>
-           <para>
-              Refer to the file arch/x86/kernel/mca_32.c for more information.
-           </para>
-<!-- FIXME: Removed for now since no structured comments in source
-X!Earch/x86/kernel/mca_32.c
--->
-	</sect2>
-	<sect2><title>MCA Bus DMA</title>
-!Iarch/x86/include/asm/mca_dma.h
-	</sect2>
-     </sect1>
   </chapter>
 
   <chapter id="firmware">
diff --git a/Documentation/DocBook/mcabook.tmpl b/Documentation/DocBook/mcabook.tmpl
deleted file mode 100644
index 467ccac..0000000
diff --git a/Documentation/devices.txt b/Documentation/devices.txt
index 0038318..c162be1 100644
--- a/Documentation/devices.txt
+++ b/Documentation/devices.txt
@@ -846,13 +846,7 @@ Your cooperation is appreciated.
 		    ...
 		 31 = /dev/tap15	16th Ethertap device
 
- 36 block	MCA ESDI hard disk
-		  0 = /dev/eda		First ESDI disk whole disk
-		 64 = /dev/edb		Second ESDI disk whole disk
-		    ...
-
-		Partitions are handled in the same way as IDE disks
-		(see major number 3).
+ 36 block	OBSOLETE (was MCA ESDI hard disk)
 
  37 char	IDE tape
 		  0 = /dev/ht0		First IDE tape
diff --git a/Documentation/eisa.txt b/Documentation/eisa.txt
index 38cf0c7..a55e491 100644
--- a/Documentation/eisa.txt
+++ b/Documentation/eisa.txt
@@ -179,7 +179,7 @@ CONFIG_ALPHA_JENSEN or CONFIG_EISA_VLB_PRIMING are set.
 
 Converting an EISA driver to the new API mostly involves *deleting*
 code (since probing is now in the core EISA code). Unfortunately, most
-drivers share their probing routine between ISA, MCA and EISA. Special
+drivers share their probing routine between ISA, and EISA. Special
 care must be taken when ripping out the EISA code, so other busses
 won't suffer from these surgical strikes...
 
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index c1601e5..38cad53 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -70,7 +70,6 @@ parameter is applicable:
 	M68k	M68k architecture is enabled.
 			These options have more detailed description inside of
 			Documentation/m68k/kernel-options.txt.
-	MCA	MCA bus support is enabled.
 	MDA	MDA console support is enabled.
 	MIPS	MIPS architecture is enabled.
 	MOUSE	Appropriate mouse support is enabled.
diff --git a/Documentation/mca.txt b/Documentation/mca.txt
deleted file mode 100644
index dfd130c..0000000
diff --git a/MAINTAINERS b/MAINTAINERS
index 887c965..469fc46 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3317,12 +3317,6 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git
 S:	Maintained
 F:	arch/ia64/
 
-IBM MCA SCSI SUBSYSTEM DRIVER
-M:	Michael Lang <langa2@kph.uni-mainz.de>
-W:	http://www.uni-mainz.de/~langm000/linux.html
-S:	Maintained
-F:	drivers/scsi/ibmmca.c
-
 IBM Power Linux RAID adapter
 M:	Brian King <brking@us.ibm.com>
 S:	Supported
@@ -4418,13 +4412,6 @@ T:	git git://git.monstr.eu/linux-2.6-microblaze.git
 S:	Supported
 F:	arch/microblaze/
 
-MICROCHANNEL ARCHITECTURE (MCA)
-M:	James Bottomley <James.Bottomley@HansenPartnership.com>
-S:	Maintained
-F:	Documentation/mca.txt
-F:	drivers/mca/
-F:	include/linux/mca*
-
 MICROTEK X6 SCANNER
 M:	Oliver Neukum <oliver@neukum.name>
 S:	Maintained
diff --git a/arch/frv/include/asm/processor.h b/arch/frv/include/asm/processor.h
index 81c2e27..4a53811 100644
--- a/arch/frv/include/asm/processor.h
+++ b/arch/frv/include/asm/processor.h
@@ -54,7 +54,6 @@ extern struct cpuinfo_frv __nongprelbss boot_cpu_data;
  * Bus types
  */
 #define EISA_bus 0
-#define MCA_bus 0
 
 struct thread_struct {
 	struct pt_regs		*frame;		/* [GR28] exception frame ptr for this thread */
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1d14cc6..3c65147 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2023,16 +2023,6 @@ config EISA
 
 source "drivers/eisa/Kconfig"
 
-config MCA
-	bool "MCA support"
-	---help---
-	  MicroChannel Architecture is found in some IBM PS/2 machines and
-	  laptops.  It is a bus system similar to PCI or ISA. See
-	  <file:Documentation/mca.txt> (and especially the web page given
-	  there) before attempting to build an MCA bus kernel.
-
-source "drivers/mca/Kconfig"
-
 config SCx200
 	tristate "NatSemi SCx200 support"
 	---help---
diff --git a/arch/x86/include/asm/mca.h b/arch/x86/include/asm/mca.h
deleted file mode 100644
index eedbb6c..0000000
diff --git a/arch/x86/include/asm/mca_dma.h b/arch/x86/include/asm/mca_dma.h
deleted file mode 100644
index 45271ae..0000000
diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index 9c7d95f..3e2f42a 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -40,7 +40,7 @@ extern int quad_local_to_mp_bus_id [NR_CPUS/4][4];
 
 #endif /* CONFIG_X86_64 */
 
-#if defined(CONFIG_MCA) || defined(CONFIG_EISA)
+#ifdef CONFIG_EISA
 extern int mp_bus_id_to_type[MAX_MP_BUSSES];
 #endif
 
diff --git a/arch/x86/include/asm/mpspec_def.h b/arch/x86/include/asm/mpspec_def.h
index c0a955a..b31f8c0 100644
--- a/arch/x86/include/asm/mpspec_def.h
+++ b/arch/x86/include/asm/mpspec_def.h
@@ -84,7 +84,7 @@ struct mpc_bus {
 #define BUSTYPE_EISA	"EISA"
 #define BUSTYPE_ISA	"ISA"
 #define BUSTYPE_INTERN	"INTERN"	/* Internal BUS */
-#define BUSTYPE_MCA	"MCA"
+#define BUSTYPE_MCA	"MCA"		/* Obsolete */
 #define BUSTYPE_VL	"VL"		/* Local bus */
 #define BUSTYPE_PCI	"PCI"
 #define BUSTYPE_PCMCIA	"PCMCIA"
@@ -169,6 +169,5 @@ enum mp_bustype {
 	MP_BUS_ISA = 1,
 	MP_BUS_EISA,
 	MP_BUS_PCI,
-	MP_BUS_MCA,
 };
 #endif /* _ASM_X86_MPSPEC_DEF_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 532d2e0..7d15699 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -49,7 +49,6 @@ obj-y				+= cpu/
 obj-y				+= acpi/
 obj-y				+= reboot.o
 obj-$(CONFIG_X86_32)		+= reboot_32.o
-obj-$(CONFIG_MCA)		+= mca_32.o
 obj-$(CONFIG_X86_MSR)		+= msr.o
 obj-$(CONFIG_X86_CPUID)		+= cpuid.o
 obj-$(CONFIG_PCI)		+= early-quirks.o
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index a415b1f..f564b18 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -990,7 +990,7 @@ void __init mp_config_acpi_legacy_irqs(void)
 	int i;
 	struct mpc_intsrc mp_irq;
 
-#if defined (CONFIG_MCA) || defined (CONFIG_EISA)
+#ifdef CONFIG_EISA
 	/*
 	 * Fabricate the legacy ISA bus (bus #31).
 	 */
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index e88300d..675e904 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -142,7 +142,7 @@ int mp_irq_entries;
 /* GSI interrupts */
 static int nr_irqs_gsi = NR_IRQS_LEGACY;
 
-#if defined (CONFIG_MCA) || defined (CONFIG_EISA)
+#ifdef CONFIG_EISA
 int mp_bus_id_to_type[MAX_MP_BUSSES];
 #endif
 
@@ -875,7 +875,7 @@ static int __init find_isa_irq_apic(int irq, int type)
 	return -1;
 }
 
-#if defined(CONFIG_EISA) || defined(CONFIG_MCA)
+#ifdef CONFIG_EISA
 /*
  * EISA Edge/Level control register, ELCR
  */
@@ -912,12 +912,6 @@ static int EISA_ELCR(unsigned int irq)
 #define default_PCI_trigger(idx)	(1)
 #define default_PCI_polarity(idx)	(1)
 
-/* MCA interrupts are always polarity zero level triggered,
- * when listed as conforming in the MP table. */
-
-#define default_MCA_trigger(idx)	(1)
-#define default_MCA_polarity(idx)	default_ISA_polarity(idx)
-
 static int irq_polarity(int idx)
 {
 	int bus = mp_irqs[idx].srcbus;
@@ -975,7 +969,7 @@ static int irq_trigger(int idx)
 				trigger = default_ISA_trigger(idx);
 			else
 				trigger = default_PCI_trigger(idx);
-#if defined(CONFIG_EISA) || defined(CONFIG_MCA)
+#ifdef CONFIG_EISA
 			switch (mp_bus_id_to_type[bus]) {
 				case MP_BUS_ISA: /* ISA pin */
 				{
@@ -992,11 +986,6 @@ static int irq_trigger(int idx)
 					/* set before the switch */
 					break;
 				}
-				case MP_BUS_MCA: /* MCA pin */
-				{
-					trigger = default_MCA_trigger(idx);
-					break;
-				}
 				default:
 				{
 					printk(KERN_WARNING "broken BIOS!!\n");
diff --git a/arch/x86/kernel/mca_32.c b/arch/x86/kernel/mca_32.c
deleted file mode 100644
index 7eb1e2b..0000000
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index ca470e4..b02d4dd 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -97,7 +97,7 @@ static void __init MP_bus_info(struct mpc_bus *m)
 
 	set_bit(m->busid, mp_bus_not_pci);
 	if (strncmp(str, BUSTYPE_ISA, sizeof(BUSTYPE_ISA) - 1) == 0) {
-#if defined(CONFIG_EISA) || defined(CONFIG_MCA)
+#ifdef CONFIG_EISA
 		mp_bus_id_to_type[m->busid] = MP_BUS_ISA;
 #endif
 	} else if (strncmp(str, BUSTYPE_PCI, sizeof(BUSTYPE_PCI) - 1) == 0) {
@@ -105,12 +105,10 @@ static void __init MP_bus_info(struct mpc_bus *m)
 			x86_init.mpparse.mpc_oem_pci_bus(m);
 
 		clear_bit(m->busid, mp_bus_not_pci);
-#if defined(CONFIG_EISA) || defined(CONFIG_MCA)
+#ifdef CONFIG_EISA
 		mp_bus_id_to_type[m->busid] = MP_BUS_PCI;
 	} else if (strncmp(str, BUSTYPE_EISA, sizeof(BUSTYPE_EISA) - 1) == 0) {
 		mp_bus_id_to_type[m->busid] = MP_BUS_EISA;
-	} else if (strncmp(str, BUSTYPE_MCA, sizeof(BUSTYPE_MCA) - 1) == 0) {
-		mp_bus_id_to_type[m->busid] = MP_BUS_MCA;
 #endif
 	} else
 		printk(KERN_WARNING "Unknown bustype %s - ignoring\n", str);
@@ -368,9 +366,6 @@ static void __init construct_ioapic_table(int mpc_default_type)
 	case 3:
 		memcpy(bus.bustype, "EISA  ", 6);
 		break;
-	case 4:
-	case 7:
-		memcpy(bus.bustype, "MCA   ", 6);
 	}
 	MP_bus_info(&bus);
 	if (mpc_default_type > 4) {
@@ -623,7 +618,7 @@ void __init default_find_smp_config(void)
 		return;
 	/*
 	 * If it is an SMP machine we should know now, unless the
-	 * configuration is in an EISA/MCA bus machine with an
+	 * configuration is in an EISA bus machine with an
 	 * extended bios data area.
 	 *
 	 * there is a real-mode segmented pointer pointing to the
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 47acaf3..7b3fdfd 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -19,8 +19,6 @@
 #include <linux/slab.h>
 #include <linux/export.h>
 
-#include <linux/mca.h>
-
 #if defined(CONFIG_EDAC)
 #include <linux/edac.h>
 #endif
@@ -282,16 +280,6 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 
 	__this_cpu_add(nmi_stats.unknown, 1);
 
-#ifdef CONFIG_MCA
-	/*
-	 * Might actually be able to figure out what the guilty party
-	 * is:
-	 */
-	if (MCA_bus) {
-		mca_handle_nmi();
-		return;
-	}
-#endif
 	pr_emerg("Uhhuh. NMI received for unknown reason %02x on CPU %d.\n",
 		 reason, smp_processor_id());
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 1a29015..8791664 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -34,7 +34,6 @@
 #include <linux/memblock.h>
 #include <linux/seq_file.h>
 #include <linux/console.h>
-#include <linux/mca.h>
 #include <linux/root_dev.h>
 #include <linux/highmem.h>
 #include <linux/module.h>
@@ -179,12 +178,6 @@ struct cpuinfo_x86 new_cpu_data __cpuinitdata = {0, 0, 0, 0, -1, 1, 0, 0, -1};
 /* common cpu data for all cpus */
 struct cpuinfo_x86 boot_cpu_data __read_mostly = {0, 0, 0, 0, -1, 1, 0, 0, -1};
 EXPORT_SYMBOL(boot_cpu_data);
-static void set_mca_bus(int x)
-{
-#ifdef CONFIG_MCA
-	MCA_bus = x;
-#endif
-}
 
 unsigned int def_to_bigsmp;
 
@@ -717,7 +710,6 @@ void __init setup_arch(char **cmdline_p)
 	apm_info.bios = boot_params.apm_bios_info;
 	ist_info = boot_params.ist_info;
 	if (boot_params.sys_desc_table.length != 0) {
-		set_mca_bus(boot_params.sys_desc_table.table[3] & 0x2);
 		machine_id = boot_params.sys_desc_table.table[0];
 		machine_submodel_id = boot_params.sys_desc_table.table[1];
 		BIOS_revision = boot_params.sys_desc_table.table[2];
diff --git a/arch/x86/kernel/time.c b/arch/x86/kernel/time.c
index c6eba2b..24d3c91 100644
--- a/arch/x86/kernel/time.c
+++ b/arch/x86/kernel/time.c
@@ -14,7 +14,6 @@
 #include <linux/i8253.h>
 #include <linux/time.h>
 #include <linux/export.h>
-#include <linux/mca.h>
 
 #include <asm/vsyscall.h>
 #include <asm/x86_init.h>
@@ -58,11 +57,6 @@ EXPORT_SYMBOL(profile_pc);
 static irqreturn_t timer_interrupt(int irq, void *dev_id)
 {
 	global_clock_event->event_handler(global_clock_event);
-
-	/* MCA bus quirk: Acknowledge irq0 by setting bit 7 in port 0x61 */
-	if (MCA_bus)
-		outb_p(inb_p(0x61)| 0x80, 0x61);
-
 	return IRQ_HANDLED;
 }
 
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index ff9281f1..4754f51 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -37,10 +37,6 @@
 #include <linux/eisa.h>
 #endif
 
-#ifdef CONFIG_MCA
-#include <linux/mca.h>
-#endif
-
 #if defined(CONFIG_EDAC)
 #include <linux/edac.h>
 #endif
diff --git a/drivers/Makefile b/drivers/Makefile
index 95952c8..f9b82f2 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -92,7 +92,6 @@ obj-$(CONFIG_BT)		+= bluetooth/
 obj-$(CONFIG_ACCESSIBILITY)	+= accessibility/
 obj-$(CONFIG_ISDN)		+= isdn/
 obj-$(CONFIG_EDAC)		+= edac/
-obj-$(CONFIG_MCA)		+= mca/
 obj-$(CONFIG_EISA)		+= eisa/
 obj-y				+= lguest/
 obj-$(CONFIG_CPU_FREQ)		+= cpufreq/
diff --git a/drivers/mca/Kconfig b/drivers/mca/Kconfig
deleted file mode 100644
index a7a0220..0000000
diff --git a/drivers/mca/Makefile b/drivers/mca/Makefile
deleted file mode 100644
index 0794b12..0000000
diff --git a/drivers/mca/mca-bus.c b/drivers/mca/mca-bus.c
deleted file mode 100644
index ada5ebb..0000000
diff --git a/drivers/mca/mca-device.c b/drivers/mca/mca-device.c
deleted file mode 100644
index e7adf89..0000000
diff --git a/drivers/mca/mca-driver.c b/drivers/mca/mca-driver.c
deleted file mode 100644
index 32cd39b..0000000
diff --git a/drivers/mca/mca-legacy.c b/drivers/mca/mca-legacy.c
deleted file mode 100644
index 494f0c2..0000000
diff --git a/drivers/mca/mca-proc.c b/drivers/mca/mca-proc.c
deleted file mode 100644
index 81ea0d3..0000000
diff --git a/drivers/message/i2o/i2o_proc.c b/drivers/message/i2o/i2o_proc.c
index 6d115c7..506c36f 100644
--- a/drivers/message/i2o/i2o_proc.c
+++ b/drivers/message/i2o/i2o_proc.c
@@ -283,7 +283,6 @@ static char *bus_strings[] = {
 	"Local Bus",
 	"ISA",
 	"EISA",
-	"MCA",
 	"PCI",
 	"PCMCIA",
 	"NUBUS",
@@ -351,18 +350,6 @@ static int i2o_seq_show_hrt(struct seq_file *seq, void *v)
 					   EisaSlotNumber);
 				break;
 
-			case I2O_BUS_MCA:
-				seq_printf(seq, "     IOBase: %0#6x,",
-					   hrt->hrt_entry[i].bus.mca_bus.
-					   McaBaseIOPort);
-				seq_printf(seq, " MemoryBase: %0#10x,",
-					   hrt->hrt_entry[i].bus.mca_bus.
-					   McaBaseMemoryAddress);
-				seq_printf(seq, " Slot: %0#4x,",
-					   hrt->hrt_entry[i].bus.mca_bus.
-					   McaSlotNumber);
-				break;
-
 			case I2O_BUS_PCI:
 				seq_printf(seq, "     Bus: %0#4x",
 					   hrt->hrt_entry[i].bus.pci_bus.
diff --git a/include/linux/i2o-dev.h b/include/linux/i2o-dev.h
index a0b23dd..a8093bf 100644
--- a/include/linux/i2o-dev.h
+++ b/include/linux/i2o-dev.h
@@ -124,7 +124,7 @@ typedef struct i2o_sg_io_hdr {
 #define I2O_BUS_LOCAL	0
 #define I2O_BUS_ISA	1
 #define I2O_BUS_EISA	2
-#define I2O_BUS_MCA	3
+/* was  I2O_BUS_MCA	3 */
 #define I2O_BUS_PCI	4
 #define I2O_BUS_PCMCIA	5
 #define I2O_BUS_NUBUS	6
diff --git a/include/linux/mca-legacy.h b/include/linux/mca-legacy.h
deleted file mode 100644
index 7a3aea8..0000000
diff --git a/include/linux/mca.h b/include/linux/mca.h
deleted file mode 100644
index 3797270..0000000
diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index 2c6286c..f606738 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -240,7 +240,7 @@ search_help[] = N_(
 	"Defined at drivers/pci/Kconfig:47\n"
 	"Depends on: X86_LOCAL_APIC && X86_IO_APIC || IA64\n"
 	"Location:\n"
-	"  -> Bus options (PCI, PCMCIA, EISA, MCA, ISA)\n"
+	"  -> Bus options (PCI, PCMCIA, EISA, ISA)\n"
 	"    -> PCI support (PCI [=y])\n"
 	"      -> PCI access mode (<choice> [=y])\n"
 	"Selects: LIBCRC32\n"
diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
index 73070cb..8c0eb65 100644
--- a/scripts/kconfig/nconf.c
+++ b/scripts/kconfig/nconf.c
@@ -223,7 +223,7 @@ search_help[] = N_(
 "Defined at drivers/pci/Kconfig:47\n"
 "Depends on: X86_LOCAL_APIC && X86_IO_APIC || IA64\n"
 "Location:\n"
-"  -> Bus options (PCI, PCMCIA, EISA, MCA, ISA)\n"
+"  -> Bus options (PCI, PCMCIA, EISA, ISA)\n"
 "    -> PCI support (PCI [ = y])\n"
 "      -> PCI access mode (<choice> [ = y])\n"
 "Selects: LIBCRC32\n"
-- 
1.7.9.1

