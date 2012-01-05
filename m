Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573Ab2AEOVJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 09:21:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55346 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756740Ab2AEOVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 09:21:06 -0500
Date: Thu, 5 Jan 2012 15:18:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/apic changes for v3.3
Message-ID: <20120105141855.GA1679@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-apic-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-apic-for-linus


out-of-topic modifications in x86-apic-for-linus:
-------------------------------------------------
drivers/edac/sb_edac.c             # 141168c: x86: Simplify code by removing a 
drivers/hwmon/coretemp.c           # 141168c: x86: Simplify code by removing a 
drivers/pci/Kconfig                # b95a7bd: pci, x86/io-apic: Allow PCI_IOAPI
drivers/pci/ioapic.c               # b95a7bd: pci, x86/io-apic: Allow PCI_IOAPI

 Thanks,

	Ingo

------------------>
Daniel J Blueman (2):
      x86: Make flat_init_apic_ldr() available
      x86: Add x86_init platform override to fix up NUMA core numbering

Fernando Luis Vazquez Cao (1):
      x86: Convert per-cpu counter icr_read_retry_count into a member of irq_stat

Fernando Luis Vázquez Cao (1):
      x86: Add per-cpu stat counter for APIC ICR read tries

Jan Beulich (1):
      pci, x86/io-apic: Allow PCI_IOAPIC to be user configurable on x86

Kevin Winchester (1):
      x86: Simplify code by removing a !SMP #ifdefs from 'struct cpuinfo_x86'

Steffen Persvold (2):
      x86: Add NumaChip support
      x86: Fix the !CONFIG_NUMA build of the new CPU ID fixup code support

Suresh Siddha (1):
      x86: Skip cpus with apic-ids >= 255 in !x2apic_mode

Yinghai Lu (4):
      x86, apic: Add probe() for apic_flat
      x86, acpi: Skip acpi x2apic entries if the x2apic feature is not present
      x86, x2apic: Fallback to xapic when BIOS doesn't setup interrupt-remapping
      x86, x2apic: Allow "nox2apic" to disable x2apic mode setup by BIOS


 arch/x86/Kconfig                             |   13 ++
 arch/x86/include/asm/apic.h                  |    6 +
 arch/x86/include/asm/apic_flat_64.h          |    7 +
 arch/x86/include/asm/apicdef.h               |    1 +
 arch/x86/include/asm/hardirq.h               |    1 +
 arch/x86/include/asm/numachip/numachip_csr.h |  167 +++++++++++++++
 arch/x86/include/asm/processor.h             |    2 -
 arch/x86/include/asm/x86_init.h              |    3 +
 arch/x86/kernel/acpi/boot.c                  |   10 +-
 arch/x86/kernel/amd_nb.c                     |    8 +-
 arch/x86/kernel/apic/Makefile                |    1 +
 arch/x86/kernel/apic/apic.c                  |  107 +++++++---
 arch/x86/kernel/apic/apic_flat_64.c          |    9 +-
 arch/x86/kernel/apic/apic_numachip.c         |  294 ++++++++++++++++++++++++++
 arch/x86/kernel/apic/io_apic.c               |    4 +
 arch/x86/kernel/cpu/amd.c                    |    9 +-
 arch/x86/kernel/cpu/common.c                 |   14 +-
 arch/x86/kernel/cpu/intel.c                  |    2 -
 arch/x86/kernel/cpu/mcheck/mce.c             |    2 -
 arch/x86/kernel/cpu/mcheck/mce_amd.c         |    7 +-
 arch/x86/kernel/cpu/proc.c                   |    4 +-
 arch/x86/kernel/irq.c                        |    5 +
 arch/x86/kernel/smpboot.c                    |    3 +-
 arch/x86/kernel/x86_init.c                   |    1 +
 arch/x86/mm/srat.c                           |    7 +-
 drivers/edac/sb_edac.c                       |    2 -
 drivers/hwmon/coretemp.c                     |    7 +-
 drivers/pci/Kconfig                          |    4 +-
 drivers/pci/ioapic.c                         |   15 +-
 29 files changed, 639 insertions(+), 76 deletions(-)
 create mode 100644 arch/x86/include/asm/apic_flat_64.h
 create mode 100644 arch/x86/include/asm/numachip/numachip_csr.h
 create mode 100644 arch/x86/kernel/apic/apic_numachip.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cb9a104..7b9eaa1 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -343,6 +343,7 @@ config X86_EXTENDED_PLATFORM
 
 	  If you enable this option then you'll be able to select support
 	  for the following (non-PC) 64 bit x86 platforms:
+		Numascale NumaChip
 		ScaleMP vSMP
 		SGI Ultraviolet
 
@@ -351,6 +352,18 @@ config X86_EXTENDED_PLATFORM
 endif
 # This is an alphabetically sorted list of 64 bit extended platforms
 # Please maintain the alphabetic order if and when there are additions
+config X86_NUMACHIP
+	bool "Numascale NumaChip"
+	depends on X86_64
+	depends on X86_EXTENDED_PLATFORM
+	depends on NUMA
+	depends on SMP
+	depends on X86_X2APIC
+	depends on !EDAC_AMD64
+	---help---
+	  Adds support for Numascale NumaChip large-SMP systems. Needed to
+	  enable more than ~168 cores.
+	  If you don't have one of these, you should say N here.
 
 config X86_VSMP
 	bool "ScaleMP vSMP"
diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 1a6c09a..3ab9bdd 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -176,6 +176,7 @@ static inline u64 native_x2apic_icr_read(void)
 }
 
 extern int x2apic_phys;
+extern int x2apic_preenabled;
 extern void check_x2apic(void);
 extern void enable_x2apic(void);
 extern void x2apic_icr_write(u32 low, u32 id);
@@ -198,6 +199,9 @@ static inline void x2apic_force_phys(void)
 	x2apic_phys = 1;
 }
 #else
+static inline void disable_x2apic(void)
+{
+}
 static inline void check_x2apic(void)
 {
 }
@@ -212,6 +216,7 @@ static inline void x2apic_force_phys(void)
 {
 }
 
+#define	nox2apic	0
 #define	x2apic_preenabled 0
 #define	x2apic_supported()	0
 #endif
@@ -410,6 +415,7 @@ extern int wakeup_secondary_cpu_via_nmi(int apicid, unsigned long start_eip);
 #endif
 
 #ifdef CONFIG_X86_LOCAL_APIC
+
 static inline u32 apic_read(u32 reg)
 {
 	return apic->read(reg);
diff --git a/arch/x86/include/asm/apic_flat_64.h b/arch/x86/include/asm/apic_flat_64.h
new file mode 100644
index 0000000..a2d3127
--- /dev/null
+++ b/arch/x86/include/asm/apic_flat_64.h
@@ -0,0 +1,7 @@
+#ifndef _ASM_X86_APIC_FLAT_64_H
+#define _ASM_X86_APIC_FLAT_64_H
+
+extern void flat_init_apic_ldr(void);
+
+#endif
+
diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
index 3925d80..134bba0 100644
--- a/arch/x86/include/asm/apicdef.h
+++ b/arch/x86/include/asm/apicdef.h
@@ -144,6 +144,7 @@
 
 #define APIC_BASE (fix_to_virt(FIX_APIC_BASE))
 #define APIC_BASE_MSR	0x800
+#define XAPIC_ENABLE	(1UL << 11)
 #define X2APIC_ENABLE	(1UL << 10)
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index 55e4de6..da0b3ca 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -11,6 +11,7 @@ typedef struct {
 #ifdef CONFIG_X86_LOCAL_APIC
 	unsigned int apic_timer_irqs;	/* arch dependent */
 	unsigned int irq_spurious_count;
+	unsigned int icr_read_retry_count;
 #endif
 	unsigned int x86_platform_ipis;	/* arch dependent */
 	unsigned int apic_perf_irqs;
diff --git a/arch/x86/include/asm/numachip/numachip_csr.h b/arch/x86/include/asm/numachip/numachip_csr.h
new file mode 100644
index 0000000..660f843
--- /dev/null
+++ b/arch/x86/include/asm/numachip/numachip_csr.h
@@ -0,0 +1,167 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Numascale NumaConnect-Specific Header file
+ *
+ * Copyright (C) 2011 Numascale AS. All rights reserved.
+ *
+ * Send feedback to <support@numascale.com>
+ *
+ */
+
+#ifndef _ASM_X86_NUMACHIP_NUMACHIP_CSR_H
+#define _ASM_X86_NUMACHIP_NUMACHIP_CSR_H
+
+#include <linux/numa.h>
+#include <linux/percpu.h>
+#include <linux/io.h>
+#include <linux/swab.h>
+#include <asm/types.h>
+#include <asm/processor.h>
+
+#define CSR_NODE_SHIFT		16
+#define CSR_NODE_BITS(p)	(((unsigned long)(p)) << CSR_NODE_SHIFT)
+#define CSR_NODE_MASK		0x0fff		/* 4K nodes */
+
+/* 32K CSR space, b15 indicates geo/non-geo */
+#define CSR_OFFSET_MASK	0x7fffUL
+
+/* Global CSR space covers all 4K possible nodes with 64K CSR space per node */
+#define NUMACHIP_GCSR_BASE	0x3fff00000000ULL
+#define NUMACHIP_GCSR_LIM	0x3fff0fffffffULL
+#define NUMACHIP_GCSR_SIZE	(NUMACHIP_GCSR_LIM - NUMACHIP_GCSR_BASE + 1)
+
+/*
+ * Local CSR space starts in global CSR space with "nodeid" = 0xfff0, however
+ * when using the direct mapping on x86_64, both start and size needs to be
+ * aligned with PMD_SIZE which is 2M
+ */
+#define NUMACHIP_LCSR_BASE	0x3ffffe000000ULL
+#define NUMACHIP_LCSR_LIM	0x3fffffffffffULL
+#define NUMACHIP_LCSR_SIZE	(NUMACHIP_LCSR_LIM - NUMACHIP_LCSR_BASE + 1)
+
+static inline void *gcsr_address(int node, unsigned long offset)
+{
+	return __va(NUMACHIP_GCSR_BASE | (1UL << 15) |
+		CSR_NODE_BITS(node & CSR_NODE_MASK) | (offset & CSR_OFFSET_MASK));
+}
+
+static inline void *lcsr_address(unsigned long offset)
+{
+	return __va(NUMACHIP_LCSR_BASE | (1UL << 15) |
+		CSR_NODE_BITS(0xfff0) | (offset & CSR_OFFSET_MASK));
+}
+
+static inline unsigned int read_gcsr(int node, unsigned long offset)
+{
+	return swab32(readl(gcsr_address(node, offset)));
+}
+
+static inline void write_gcsr(int node, unsigned long offset, unsigned int val)
+{
+	writel(swab32(val), gcsr_address(node, offset));
+}
+
+static inline unsigned int read_lcsr(unsigned long offset)
+{
+	return swab32(readl(lcsr_address(offset)));
+}
+
+static inline void write_lcsr(unsigned long offset, unsigned int val)
+{
+	writel(swab32(val), lcsr_address(offset));
+}
+
+/* ========================================================================= */
+/*                   CSR_G0_STATE_CLEAR                                      */
+/* ========================================================================= */
+
+#define CSR_G0_STATE_CLEAR (0x000 + (0 << 12))
+union numachip_csr_g0_state_clear {
+	unsigned int v;
+	struct numachip_csr_g0_state_clear_s {
+		unsigned int _state:2;
+		unsigned int _rsvd_2_6:5;
+		unsigned int _lost:1;
+		unsigned int _rsvd_8_31:24;
+	} s;
+};
+
+/* ========================================================================= */
+/*                   CSR_G0_NODE_IDS                                         */
+/* ========================================================================= */
+
+#define CSR_G0_NODE_IDS (0x008 + (0 << 12))
+union numachip_csr_g0_node_ids {
+	unsigned int v;
+	struct numachip_csr_g0_node_ids_s {
+		unsigned int _initialid:16;
+		unsigned int _nodeid:12;
+		unsigned int _rsvd_28_31:4;
+	} s;
+};
+
+/* ========================================================================= */
+/*                   CSR_G3_EXT_IRQ_GEN                                      */
+/* ========================================================================= */
+
+#define CSR_G3_EXT_IRQ_GEN (0x030 + (3 << 12))
+union numachip_csr_g3_ext_irq_gen {
+	unsigned int v;
+	struct numachip_csr_g3_ext_irq_gen_s {
+		unsigned int _vector:8;
+		unsigned int _msgtype:3;
+		unsigned int _index:5;
+		unsigned int _destination_apic_id:16;
+	} s;
+};
+
+/* ========================================================================= */
+/*                   CSR_G3_EXT_IRQ_STATUS                                   */
+/* ========================================================================= */
+
+#define CSR_G3_EXT_IRQ_STATUS (0x034 + (3 << 12))
+union numachip_csr_g3_ext_irq_status {
+	unsigned int v;
+	struct numachip_csr_g3_ext_irq_status_s {
+		unsigned int _result:32;
+	} s;
+};
+
+/* ========================================================================= */
+/*                   CSR_G3_EXT_IRQ_DEST                                     */
+/* ========================================================================= */
+
+#define CSR_G3_EXT_IRQ_DEST (0x038 + (3 << 12))
+union numachip_csr_g3_ext_irq_dest {
+	unsigned int v;
+	struct numachip_csr_g3_ext_irq_dest_s {
+		unsigned int _irq:8;
+		unsigned int _rsvd_8_31:24;
+	} s;
+};
+
+/* ========================================================================= */
+/*                   CSR_G3_NC_ATT_MAP_SELECT                                */
+/* ========================================================================= */
+
+#define CSR_G3_NC_ATT_MAP_SELECT (0x7fc + (3 << 12))
+union numachip_csr_g3_nc_att_map_select {
+	unsigned int v;
+	struct numachip_csr_g3_nc_att_map_select_s {
+		unsigned int _upper_address_bits:4;
+		unsigned int _select_ram:4;
+		unsigned int _rsvd_8_31:24;
+	} s;
+};
+
+/* ========================================================================= */
+/*                   CSR_G3_NC_ATT_MAP_SELECT_0-255                          */
+/* ========================================================================= */
+
+#define CSR_G3_NC_ATT_MAP_SELECT_0 (0x800 + (3 << 12))
+
+#endif /* _ASM_X86_NUMACHIP_NUMACHIP_CSR_H */
+
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index b650435..aa9088c 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -99,7 +99,6 @@ struct cpuinfo_x86 {
 	u16			apicid;
 	u16			initial_apicid;
 	u16			x86_clflush_size;
-#ifdef CONFIG_SMP
 	/* number of cores as seen by the OS: */
 	u16			booted_cores;
 	/* Physical processor id: */
@@ -110,7 +109,6 @@ struct cpuinfo_x86 {
 	u8			compute_unit_id;
 	/* Index into per_cpu list: */
 	u16			cpu_index;
-#endif
 	u32			microcode;
 } __attribute__((__aligned__(SMP_CACHE_BYTES)));
 
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 1971e65..1ac860a 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -7,6 +7,7 @@
 struct mpc_bus;
 struct mpc_cpu;
 struct mpc_table;
+struct cpuinfo_x86;
 
 /**
  * struct x86_init_mpparse - platform specific mpparse ops
@@ -147,6 +148,7 @@ struct x86_init_ops {
  */
 struct x86_cpuinit_ops {
 	void (*setup_percpu_clockev)(void);
+	void (*fixup_cpu_id)(struct cpuinfo_x86 *c, int node);
 };
 
 /**
@@ -186,5 +188,6 @@ extern struct x86_msi_ops x86_msi;
 
 extern void x86_init_noop(void);
 extern void x86_init_uint_noop(unsigned int unused);
+extern void x86_default_fixup_cpu_id(struct cpuinfo_x86 *c, int node);
 
 #endif
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 4558f0d..ce664f3 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -219,6 +219,8 @@ static int __init
 acpi_parse_x2apic(struct acpi_subtable_header *header, const unsigned long end)
 {
 	struct acpi_madt_local_x2apic *processor = NULL;
+	int apic_id;
+	u8 enabled;
 
 	processor = (struct acpi_madt_local_x2apic *)header;
 
@@ -227,6 +229,8 @@ acpi_parse_x2apic(struct acpi_subtable_header *header, const unsigned long end)
 
 	acpi_table_print_madt_entry(header);
 
+	apic_id = processor->local_apic_id;
+	enabled = processor->lapic_flags & ACPI_MADT_ENABLED;
 #ifdef CONFIG_X86_X2APIC
 	/*
 	 * We need to register disabled CPU as well to permit
@@ -235,8 +239,10 @@ acpi_parse_x2apic(struct acpi_subtable_header *header, const unsigned long end)
 	 * to not preallocating memory for all NR_CPUS
 	 * when we use CPU hotplug.
 	 */
-	acpi_register_lapic(processor->local_apic_id,	/* APIC ID */
-			    processor->lapic_flags & ACPI_MADT_ENABLED);
+	if (!cpu_has_x2apic && (apic_id >= 0xff) && enabled)
+		printk(KERN_WARNING PREFIX "x2apic entry ignored\n");
+	else
+		acpi_register_lapic(apic_id, enabled);
 #else
 	printk(KERN_WARNING PREFIX "x2apic entry ignored\n");
 #endif
diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index 4c39baa..013c181 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -123,16 +123,14 @@ int amd_get_subcaches(int cpu)
 {
 	struct pci_dev *link = node_to_amd_nb(amd_get_nb_id(cpu))->link;
 	unsigned int mask;
-	int cuid = 0;
+	int cuid;
 
 	if (!amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
 		return 0;
 
 	pci_read_config_dword(link, 0x1d4, &mask);
 
-#ifdef CONFIG_SMP
 	cuid = cpu_data(cpu).compute_unit_id;
-#endif
 	return (mask >> (4 * cuid)) & 0xf;
 }
 
@@ -141,7 +139,7 @@ int amd_set_subcaches(int cpu, int mask)
 	static unsigned int reset, ban;
 	struct amd_northbridge *nb = node_to_amd_nb(amd_get_nb_id(cpu));
 	unsigned int reg;
-	int cuid = 0;
+	int cuid;
 
 	if (!amd_nb_has_feature(AMD_NB_L3_PARTITIONING) || mask > 0xf)
 		return -EINVAL;
@@ -159,9 +157,7 @@ int amd_set_subcaches(int cpu, int mask)
 		pci_write_config_dword(nb->misc, 0x1b8, reg & ~0x180000);
 	}
 
-#ifdef CONFIG_SMP
 	cuid = cpu_data(cpu).compute_unit_id;
-#endif
 	mask <<= 4 * cuid;
 	mask |= (0xf ^ (1 << cuid)) << 26;
 
diff --git a/arch/x86/kernel/apic/Makefile b/arch/x86/kernel/apic/Makefile
index 767fd04..0ae0323 100644
--- a/arch/x86/kernel/apic/Makefile
+++ b/arch/x86/kernel/apic/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_SMP)		+= ipi.o
 
 ifeq ($(CONFIG_X86_64),y)
 # APIC probe will depend on the listing order here
+obj-$(CONFIG_X86_NUMACHIP)	+= apic_numachip.o
 obj-$(CONFIG_X86_UV)		+= x2apic_uv_x.o
 obj-$(CONFIG_X86_X2APIC)	+= x2apic_phys.o
 obj-$(CONFIG_X86_X2APIC)	+= x2apic_cluster.o
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index f98d84c..ff69d5d 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -146,16 +146,26 @@ __setup("apicpmtimer", setup_apicpmtimer);
 int x2apic_mode;
 #ifdef CONFIG_X86_X2APIC
 /* x2apic enabled before OS handover */
-static int x2apic_preenabled;
+int x2apic_preenabled;
+static int x2apic_disabled;
+static int nox2apic;
 static __init int setup_nox2apic(char *str)
 {
 	if (x2apic_enabled()) {
-		pr_warning("Bios already enabled x2apic, "
-			   "can't enforce nox2apic");
-		return 0;
-	}
+		int apicid = native_apic_msr_read(APIC_ID);
+
+		if (apicid >= 255) {
+			pr_warning("Apicid: %08x, cannot enforce nox2apic\n",
+				   apicid);
+			return 0;
+		}
+
+		pr_warning("x2apic already enabled. will disable it\n");
+	} else
+		setup_clear_cpu_cap(X86_FEATURE_X2APIC);
+
+	nox2apic = 1;
 
-	setup_clear_cpu_cap(X86_FEATURE_X2APIC);
 	return 0;
 }
 early_param("nox2apic", setup_nox2apic);
@@ -250,6 +260,7 @@ u32 native_safe_apic_wait_icr_idle(void)
 		send_status = apic_read(APIC_ICR) & APIC_ICR_BUSY;
 		if (!send_status)
 			break;
+		inc_irq_stat(icr_read_retry_count);
 		udelay(100);
 	} while (timeout++ < 1000);
 
@@ -1431,6 +1442,45 @@ void __init bsp_end_local_APIC_setup(void)
 }
 
 #ifdef CONFIG_X86_X2APIC
+/*
+ * Need to disable xapic and x2apic at the same time and then enable xapic mode
+ */
+static inline void __disable_x2apic(u64 msr)
+{
+	wrmsrl(MSR_IA32_APICBASE,
+	       msr & ~(X2APIC_ENABLE | XAPIC_ENABLE));
+	wrmsrl(MSR_IA32_APICBASE, msr & ~X2APIC_ENABLE);
+}
+
+static __init void disable_x2apic(void)
+{
+	u64 msr;
+
+	if (!cpu_has_x2apic)
+		return;
+
+	rdmsrl(MSR_IA32_APICBASE, msr);
+	if (msr & X2APIC_ENABLE) {
+		u32 x2apic_id = read_apic_id();
+
+		if (x2apic_id >= 255)
+			panic("Cannot disable x2apic, id: %08x\n", x2apic_id);
+
+		pr_info("Disabling x2apic\n");
+		__disable_x2apic(msr);
+
+		if (nox2apic) {
+			clear_cpu_cap(&cpu_data(0), X86_FEATURE_X2APIC);
+			setup_clear_cpu_cap(X86_FEATURE_X2APIC);
+		}
+
+		x2apic_disabled = 1;
+		x2apic_mode = 0;
+
+		register_lapic_address(mp_lapic_addr);
+	}
+}
+
 void check_x2apic(void)
 {
 	if (x2apic_enabled()) {
@@ -1441,15 +1491,20 @@ void check_x2apic(void)
 
 void enable_x2apic(void)
 {
-	int msr, msr2;
+	u64 msr;
+
+	rdmsrl(MSR_IA32_APICBASE, msr);
+	if (x2apic_disabled) {
+		__disable_x2apic(msr);
+		return;
+	}
 
 	if (!x2apic_mode)
 		return;
 
-	rdmsr(MSR_IA32_APICBASE, msr, msr2);
 	if (!(msr & X2APIC_ENABLE)) {
 		printk_once(KERN_INFO "Enabling x2apic\n");
-		wrmsr(MSR_IA32_APICBASE, msr | X2APIC_ENABLE, msr2);
+		wrmsrl(MSR_IA32_APICBASE, msr | X2APIC_ENABLE);
 	}
 }
 #endif /* CONFIG_X86_X2APIC */
@@ -1486,25 +1541,34 @@ void __init enable_IR_x2apic(void)
 	ret = save_ioapic_entries();
 	if (ret) {
 		pr_info("Saving IO-APIC state failed: %d\n", ret);
-		goto out;
+		return;
 	}
 
 	local_irq_save(flags);
 	legacy_pic->mask_all();
 	mask_ioapic_entries();
 
+	if (x2apic_preenabled && nox2apic)
+		disable_x2apic();
+
 	if (dmar_table_init_ret)
 		ret = -1;
 	else
 		ret = enable_IR();
 
+	if (!x2apic_supported())
+		goto skip_x2apic;
+
 	if (ret < 0) {
 		/* IR is required if there is APIC ID > 255 even when running
 		 * under KVM
 		 */
 		if (max_physical_apicid > 255 ||
-		    !hypervisor_x2apic_available())
-			goto nox2apic;
+		    !hypervisor_x2apic_available()) {
+			if (x2apic_preenabled)
+				disable_x2apic();
+			goto skip_x2apic;
+		}
 		/*
 		 * without IR all CPUs can be addressed by IOAPIC/MSI
 		 * only in physical mode
@@ -1512,8 +1576,10 @@ void __init enable_IR_x2apic(void)
 		x2apic_force_phys();
 	}
 
-	if (ret == IRQ_REMAP_XAPIC_MODE)
-		goto nox2apic;
+	if (ret == IRQ_REMAP_XAPIC_MODE) {
+		pr_info("x2apic not enabled, IRQ remapping is in xapic mode\n");
+		goto skip_x2apic;
+	}
 
 	x2apic_enabled = 1;
 
@@ -1523,22 +1589,11 @@ void __init enable_IR_x2apic(void)
 		pr_info("Enabled x2apic\n");
 	}
 
-nox2apic:
+skip_x2apic:
 	if (ret < 0) /* IR enabling failed */
 		restore_ioapic_entries();
 	legacy_pic->restore_mask();
 	local_irq_restore(flags);
-
-out:
-	if (x2apic_enabled || !x2apic_supported())
-		return;
-
-	if (x2apic_preenabled)
-		panic("x2apic: enabled by BIOS but kernel init failed.");
-	else if (ret == IRQ_REMAP_XAPIC_MODE)
-		pr_info("x2apic not enabled, IRQ remapping is in xapic mode\n");
-	else if (ret < 0)
-		pr_info("x2apic not enabled, IRQ remapping init failed\n");
 }
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index f7a41e4..8c3cdde 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -62,7 +62,7 @@ static void flat_vector_allocation_domain(int cpu, struct cpumask *retmask)
  * an APIC.  See e.g. "AP-388 82489DX User's Manual" (Intel
  * document number 292116).  So here it goes...
  */
-static void flat_init_apic_ldr(void)
+void flat_init_apic_ldr(void)
 {
 	unsigned long val;
 	unsigned long num, id;
@@ -171,9 +171,14 @@ static int flat_phys_pkg_id(int initial_apic_id, int index_msb)
 	return initial_apic_id >> index_msb;
 }
 
+static int flat_probe(void)
+{
+	return 1;
+}
+
 static struct apic apic_flat =  {
 	.name				= "flat",
-	.probe				= NULL,
+	.probe				= flat_probe,
 	.acpi_madt_oem_check		= flat_acpi_madt_oem_check,
 	.apic_id_registered		= flat_apic_id_registered,
 
diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
new file mode 100644
index 0000000..09d3d8c
--- /dev/null
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -0,0 +1,294 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Numascale NumaConnect-Specific APIC Code
+ *
+ * Copyright (C) 2011 Numascale AS. All rights reserved.
+ *
+ * Send feedback to <support@numascale.com>
+ *
+ */
+
+#include <linux/errno.h>
+#include <linux/threads.h>
+#include <linux/cpumask.h>
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/ctype.h>
+#include <linux/init.h>
+#include <linux/hardirq.h>
+#include <linux/delay.h>
+
+#include <asm/numachip/numachip_csr.h>
+#include <asm/smp.h>
+#include <asm/apic.h>
+#include <asm/ipi.h>
+#include <asm/apic_flat_64.h>
+
+static int numachip_system __read_mostly;
+
+static struct apic apic_numachip __read_mostly;
+
+static unsigned int get_apic_id(unsigned long x)
+{
+	unsigned long value;
+	unsigned int id;
+
+	rdmsrl(MSR_FAM10H_NODE_ID, value);
+	id = ((x >> 24) & 0xffU) | ((value << 2) & 0x3f00U);
+
+	return id;
+}
+
+static unsigned long set_apic_id(unsigned int id)
+{
+	unsigned long x;
+
+	x = ((id & 0xffU) << 24);
+	return x;
+}
+
+static unsigned int read_xapic_id(void)
+{
+	return get_apic_id(apic_read(APIC_ID));
+}
+
+static int numachip_apic_id_registered(void)
+{
+	return physid_isset(read_xapic_id(), phys_cpu_present_map);
+}
+
+static int numachip_phys_pkg_id(int initial_apic_id, int index_msb)
+{
+	return initial_apic_id >> index_msb;
+}
+
+static const struct cpumask *numachip_target_cpus(void)
+{
+	return cpu_online_mask;
+}
+
+static void numachip_vector_allocation_domain(int cpu, struct cpumask *retmask)
+{
+	cpumask_clear(retmask);
+	cpumask_set_cpu(cpu, retmask);
+}
+
+static int __cpuinit numachip_wakeup_secondary(int phys_apicid, unsigned long start_rip)
+{
+	union numachip_csr_g3_ext_irq_gen int_gen;
+
+	int_gen.s._destination_apic_id = phys_apicid;
+	int_gen.s._vector = 0;
+	int_gen.s._msgtype = APIC_DM_INIT >> 8;
+	int_gen.s._index = 0;
+
+	write_lcsr(CSR_G3_EXT_IRQ_GEN, int_gen.v);
+
+	int_gen.s._msgtype = APIC_DM_STARTUP >> 8;
+	int_gen.s._vector = start_rip >> 12;
+
+	write_lcsr(CSR_G3_EXT_IRQ_GEN, int_gen.v);
+
+	atomic_set(&init_deasserted, 1);
+	return 0;
+}
+
+static void numachip_send_IPI_one(int cpu, int vector)
+{
+	union numachip_csr_g3_ext_irq_gen int_gen;
+	int apicid = per_cpu(x86_cpu_to_apicid, cpu);
+
+	int_gen.s._destination_apic_id = apicid;
+	int_gen.s._vector = vector;
+	int_gen.s._msgtype = (vector == NMI_VECTOR ? APIC_DM_NMI : APIC_DM_FIXED) >> 8;
+	int_gen.s._index = 0;
+
+	write_lcsr(CSR_G3_EXT_IRQ_GEN, int_gen.v);
+}
+
+static void numachip_send_IPI_mask(const struct cpumask *mask, int vector)
+{
+	unsigned int cpu;
+
+	for_each_cpu(cpu, mask)
+		numachip_send_IPI_one(cpu, vector);
+}
+
+static void numachip_send_IPI_mask_allbutself(const struct cpumask *mask,
+						int vector)
+{
+	unsigned int this_cpu = smp_processor_id();
+	unsigned int cpu;
+
+	for_each_cpu(cpu, mask) {
+		if (cpu != this_cpu)
+			numachip_send_IPI_one(cpu, vector);
+	}
+}
+
+static void numachip_send_IPI_allbutself(int vector)
+{
+	unsigned int this_cpu = smp_processor_id();
+	unsigned int cpu;
+
+	for_each_online_cpu(cpu) {
+		if (cpu != this_cpu)
+			numachip_send_IPI_one(cpu, vector);
+	}
+}
+
+static void numachip_send_IPI_all(int vector)
+{
+	numachip_send_IPI_mask(cpu_online_mask, vector);
+}
+
+static void numachip_send_IPI_self(int vector)
+{
+	__default_send_IPI_shortcut(APIC_DEST_SELF, vector, APIC_DEST_PHYSICAL);
+}
+
+static unsigned int numachip_cpu_mask_to_apicid(const struct cpumask *cpumask)
+{
+	int cpu;
+
+	/*
+	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
+	 * May as well be the first.
+	 */
+	cpu = cpumask_first(cpumask);
+	if (likely((unsigned)cpu < nr_cpu_ids))
+		return per_cpu(x86_cpu_to_apicid, cpu);
+
+	return BAD_APICID;
+}
+
+static unsigned int
+numachip_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
+				const struct cpumask *andmask)
+{
+	int cpu;
+
+	/*
+	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
+	 * May as well be the first.
+	 */
+	for_each_cpu_and(cpu, cpumask, andmask) {
+		if (cpumask_test_cpu(cpu, cpu_online_mask))
+			break;
+	}
+	return per_cpu(x86_cpu_to_apicid, cpu);
+}
+
+static int __init numachip_probe(void)
+{
+	return apic == &apic_numachip;
+}
+
+static void __init map_csrs(void)
+{
+	printk(KERN_INFO "NumaChip: Mapping local CSR space (%016llx - %016llx)\n",
+		NUMACHIP_LCSR_BASE, NUMACHIP_LCSR_BASE + NUMACHIP_LCSR_SIZE - 1);
+	init_extra_mapping_uc(NUMACHIP_LCSR_BASE, NUMACHIP_LCSR_SIZE);
+
+	printk(KERN_INFO "NumaChip: Mapping global CSR space (%016llx - %016llx)\n",
+		NUMACHIP_GCSR_BASE, NUMACHIP_GCSR_BASE + NUMACHIP_GCSR_SIZE - 1);
+	init_extra_mapping_uc(NUMACHIP_GCSR_BASE, NUMACHIP_GCSR_SIZE);
+}
+
+static void fixup_cpu_id(struct cpuinfo_x86 *c, int node)
+{
+	c->phys_proc_id = node;
+	per_cpu(cpu_llc_id, smp_processor_id()) = node;
+}
+
+static int __init numachip_system_init(void)
+{
+	unsigned int val;
+
+	if (!numachip_system)
+		return 0;
+
+	x86_cpuinit.fixup_cpu_id = fixup_cpu_id;
+
+	map_csrs();
+
+	val = read_lcsr(CSR_G0_NODE_IDS);
+	printk(KERN_INFO "NumaChip: Local NodeID = %08x\n", val);
+
+	return 0;
+}
+early_initcall(numachip_system_init);
+
+static int numachip_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+{
+	if (!strncmp(oem_id, "NUMASC", 6)) {
+		numachip_system = 1;
+		return 1;
+	}
+
+	return 0;
+}
+
+static struct apic apic_numachip __refconst = {
+
+	.name				= "NumaConnect system",
+	.probe				= numachip_probe,
+	.acpi_madt_oem_check		= numachip_acpi_madt_oem_check,
+	.apic_id_registered		= numachip_apic_id_registered,
+
+	.irq_delivery_mode		= dest_Fixed,
+	.irq_dest_mode			= 0, /* physical */
+
+	.target_cpus			= numachip_target_cpus,
+	.disable_esr			= 0,
+	.dest_logical			= 0,
+	.check_apicid_used		= NULL,
+	.check_apicid_present		= NULL,
+
+	.vector_allocation_domain	= numachip_vector_allocation_domain,
+	.init_apic_ldr			= flat_init_apic_ldr,
+
+	.ioapic_phys_id_map		= NULL,
+	.setup_apic_routing		= NULL,
+	.multi_timer_check		= NULL,
+	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
+	.apicid_to_cpu_present		= NULL,
+	.setup_portio_remap		= NULL,
+	.check_phys_apicid_present	= default_check_phys_apicid_present,
+	.enable_apic_mode		= NULL,
+	.phys_pkg_id			= numachip_phys_pkg_id,
+	.mps_oem_check			= NULL,
+
+	.get_apic_id			= get_apic_id,
+	.set_apic_id			= set_apic_id,
+	.apic_id_mask			= 0xffU << 24,
+
+	.cpu_mask_to_apicid		= numachip_cpu_mask_to_apicid,
+	.cpu_mask_to_apicid_and		= numachip_cpu_mask_to_apicid_and,
+
+	.send_IPI_mask			= numachip_send_IPI_mask,
+	.send_IPI_mask_allbutself	= numachip_send_IPI_mask_allbutself,
+	.send_IPI_allbutself		= numachip_send_IPI_allbutself,
+	.send_IPI_all			= numachip_send_IPI_all,
+	.send_IPI_self			= numachip_send_IPI_self,
+
+	.wakeup_secondary_cpu		= numachip_wakeup_secondary,
+	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
+	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
+	.wait_for_init_deassert		= NULL,
+	.smp_callin_clear_local_apic	= NULL,
+	.inquire_remote_apic		= NULL, /* REMRD not supported */
+
+	.read				= native_apic_mem_read,
+	.write				= native_apic_mem_write,
+	.icr_read			= native_apic_icr_read,
+	.icr_write			= native_apic_icr_write,
+	.wait_icr_idle			= native_apic_wait_icr_idle,
+	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
+};
+apic_driver(apic_numachip);
+
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 6d939d7..45b461f 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2948,6 +2948,10 @@ static inline void __init check_timer(void)
 	}
 	local_irq_disable();
 	apic_printk(APIC_QUIET, KERN_INFO "..... failed :(.\n");
+	if (x2apic_preenabled)
+		apic_printk(APIC_QUIET, KERN_INFO
+			    "Perhaps problem with the pre-enabled x2apic mode\n"
+			    "Try booting with x2apic and interrupt-remapping disabled in the bios.\n");
 	panic("IO-APIC + timer doesn't work!  Boot with apic=debug and send a "
 		"report.  Then try booting with the 'noapic' option.\n");
 out:
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 0bab2b1..f4773f4 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -148,7 +148,6 @@ static void __cpuinit init_amd_k6(struct cpuinfo_x86 *c)
 
 static void __cpuinit amd_k7_smp_check(struct cpuinfo_x86 *c)
 {
-#ifdef CONFIG_SMP
 	/* calling is from identify_secondary_cpu() ? */
 	if (!c->cpu_index)
 		return;
@@ -192,7 +191,6 @@ static void __cpuinit amd_k7_smp_check(struct cpuinfo_x86 *c)
 
 valid_k7:
 	;
-#endif
 }
 
 static void __cpuinit init_amd_k7(struct cpuinfo_x86 *c)
@@ -353,6 +351,13 @@ static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
 	if (node == NUMA_NO_NODE)
 		node = per_cpu(cpu_llc_id, cpu);
 
+	/*
+	 * If core numbers are inconsistent, it's likely a multi-fabric platform,
+	 * so invoke platform-specific handler
+	 */
+	if (c->phys_proc_id != node)
+		x86_cpuinit.fixup_cpu_id(c, node);
+
 	if (!node_online(node)) {
 		/*
 		 * Two possibilities here:
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index aa003b1..850f296 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -676,9 +676,7 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 	if (this_cpu->c_early_init)
 		this_cpu->c_early_init(c);
 
-#ifdef CONFIG_SMP
 	c->cpu_index = 0;
-#endif
 	filter_cpuid_features(c, false);
 
 	setup_smep(c);
@@ -764,10 +762,7 @@ static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
 		c->apicid = c->initial_apicid;
 # endif
 #endif
-
-#ifdef CONFIG_X86_HT
 		c->phys_proc_id = c->initial_apicid;
-#endif
 	}
 
 	setup_smep(c);
@@ -1141,6 +1136,15 @@ static void dbg_restore_debug_regs(void)
 #endif /* ! CONFIG_KGDB */
 
 /*
+ * Prints an error where the NUMA and configured core-number mismatch and the
+ * platform didn't override this to fix it up
+ */
+void __cpuinit x86_default_fixup_cpu_id(struct cpuinfo_x86 *c, int node)
+{
+	pr_err("NUMA core number %d differs from configured core number %d\n", node, c->phys_proc_id);
+}
+
+/*
  * cpu_init() initializes state that is per-CPU. Some data is already
  * initialized (naturally) in the bootstrap process, such as the GDT
  * and IDT. We reload them nevertheless, this function acts as a
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 5231312..3e6ff6c 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -181,7 +181,6 @@ static void __cpuinit trap_init_f00f_bug(void)
 
 static void __cpuinit intel_smp_check(struct cpuinfo_x86 *c)
 {
-#ifdef CONFIG_SMP
 	/* calling is from identify_secondary_cpu() ? */
 	if (!c->cpu_index)
 		return;
@@ -198,7 +197,6 @@ static void __cpuinit intel_smp_check(struct cpuinfo_x86 *c)
 		WARN_ONCE(1, "WARNING: SMP operation may be unreliable"
 				    "with B stepping processors.\n");
 	}
-#endif
 }
 
 static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 2af127d..e9c9d0a 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -119,9 +119,7 @@ void mce_setup(struct mce *m)
 	m->time = get_seconds();
 	m->cpuvendor = boot_cpu_data.x86_vendor;
 	m->cpuid = cpuid_eax(1);
-#ifdef CONFIG_SMP
 	m->socketid = cpu_data(m->extcpu).phys_proc_id;
-#endif
 	m->apicid = cpu_data(m->extcpu).initial_apicid;
 	rdmsrl(MSR_IA32_MCG_CAP, m->mcgcap);
 }
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index f547421..1d76872 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -64,11 +64,9 @@ struct threshold_bank {
 };
 static DEFINE_PER_CPU(struct threshold_bank * [NR_BANKS], threshold_banks);
 
-#ifdef CONFIG_SMP
 static unsigned char shared_bank[NR_BANKS] = {
 	0, 0, 0, 0, 1
 };
-#endif
 
 static DEFINE_PER_CPU(unsigned char, bank_map);	/* see which banks are on */
 
@@ -202,10 +200,9 @@ void mce_amd_feature_init(struct cpuinfo_x86 *c)
 
 			if (!block)
 				per_cpu(bank_map, cpu) |= (1 << bank);
-#ifdef CONFIG_SMP
 			if (shared_bank[bank] && c->cpu_core_id)
 				break;
-#endif
+
 			offset = setup_APIC_mce(offset,
 						(high & MASK_LVTOFF_HI) >> 20);
 
@@ -531,7 +528,6 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 
 	sprintf(name, "threshold_bank%i", bank);
 
-#ifdef CONFIG_SMP
 	if (cpu_data(cpu).cpu_core_id && shared_bank[bank]) {	/* symlink */
 		i = cpumask_first(cpu_llc_shared_mask(cpu));
 
@@ -558,7 +554,6 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 
 		goto out;
 	}
-#endif
 
 	b = kzalloc(sizeof(struct threshold_bank), GFP_KERNEL);
 	if (!b) {
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index 14b2314..8022c66 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -64,12 +64,10 @@ static void show_cpuinfo_misc(struct seq_file *m, struct cpuinfo_x86 *c)
 static int show_cpuinfo(struct seq_file *m, void *v)
 {
 	struct cpuinfo_x86 *c = v;
-	unsigned int cpu = 0;
+	unsigned int cpu;
 	int i;
 
-#ifdef CONFIG_SMP
 	cpu = c->cpu_index;
-#endif
 	seq_printf(m, "processor\t: %u\n"
 		   "vendor_id\t: %s\n"
 		   "cpu family\t: %d\n"
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 429e0c9..ef54ed4 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -74,6 +74,10 @@ int arch_show_interrupts(struct seq_file *p, int prec)
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->apic_irq_work_irqs);
 	seq_printf(p, "  IRQ work interrupts\n");
+	seq_printf(p, "%*s: ", prec, "RTR");
+	for_each_online_cpu(j)
+		seq_printf(p, "%10u ", irq_stats(j)->icr_read_retry_count);
+	seq_printf(p, "  APIC ICR read retries\n");
 #endif
 	if (x86_platform_ipi_callback) {
 		seq_printf(p, "%*s: ", prec, "PLT");
@@ -136,6 +140,7 @@ u64 arch_irq_stat_cpu(unsigned int cpu)
 	sum += irq_stats(cpu)->irq_spurious_count;
 	sum += irq_stats(cpu)->apic_perf_irqs;
 	sum += irq_stats(cpu)->apic_irq_work_irqs;
+	sum += irq_stats(cpu)->icr_read_retry_count;
 #endif
 	if (x86_platform_ipi_callback)
 		sum += irq_stats(cpu)->x86_platform_ipis;
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 9f548cb..e38e217 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -840,7 +840,8 @@ int __cpuinit native_cpu_up(unsigned int cpu)
 	pr_debug("++++++++++++++++++++=_---CPU UP  %u\n", cpu);
 
 	if (apicid == BAD_APICID || apicid == boot_cpu_physical_apicid ||
-	    !physid_isset(apicid, phys_cpu_present_map)) {
+	    !physid_isset(apicid, phys_cpu_present_map) ||
+	    (!x2apic_mode && apicid >= 255)) {
 		printk(KERN_ERR "%s: bad cpu %d\n", __func__, cpu);
 		return -EINVAL;
 	}
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index c1d6cd5..91f83e2 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -92,6 +92,7 @@ struct x86_init_ops x86_init __initdata = {
 
 struct x86_cpuinit_ops x86_cpuinit __cpuinitdata = {
 	.setup_percpu_clockev		= setup_secondary_APIC_clock,
+	.fixup_cpu_id			= x86_default_fixup_cpu_id,
 };
 
 static void default_nmi_init(void) { };
diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
index 81dbfde..fd61b3f 100644
--- a/arch/x86/mm/srat.c
+++ b/arch/x86/mm/srat.c
@@ -69,6 +69,12 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
 	if ((pa->flags & ACPI_SRAT_CPU_ENABLED) == 0)
 		return;
 	pxm = pa->proximity_domain;
+	apic_id = pa->apic_id;
+	if (!cpu_has_x2apic && (apic_id >= 0xff)) {
+		printk(KERN_INFO "SRAT: PXM %u -> X2APIC 0x%04x ignored\n",
+			 pxm, apic_id);
+		return;
+	}
 	node = setup_node(pxm);
 	if (node < 0) {
 		printk(KERN_ERR "SRAT: Too many proximity domains %x\n", pxm);
@@ -76,7 +82,6 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
 		return;
 	}
 
-	apic_id = pa->apic_id;
 	if (apic_id >= MAX_LOCAL_APIC) {
 		printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%04x -> Node %u skipped apicid that is too big\n", pxm, apic_id, node);
 		return;
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 7a402bf..88df489 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -1609,11 +1609,9 @@ static int sbridge_mce_check_error(struct notifier_block *nb, unsigned long val,
 		mce->cpuvendor, mce->cpuid, mce->time,
 		mce->socketid, mce->apicid);
 
-#ifdef CONFIG_SMP
 	/* Only handle if it is the right mc controller */
 	if (cpu_data(mce->cpu).phys_proc_id != pvt->sbridge_dev->mc)
 		return NOTIFY_DONE;
-#endif
 
 	smp_rmb();
 	if ((pvt->mce_out + 1) % MCE_LOG_LEN == pvt->mce_in) {
diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 104b376..1fdef88 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -57,16 +57,15 @@ MODULE_PARM_DESC(tjmax, "TjMax value in degrees Celsius");
 #define TOTAL_ATTRS		(MAX_CORE_ATTRS + 1)
 #define MAX_CORE_DATA		(NUM_REAL_CORES + BASE_SYSFS_ATTR_NO)
 
-#ifdef CONFIG_SMP
 #define TO_PHYS_ID(cpu)		cpu_data(cpu).phys_proc_id
 #define TO_CORE_ID(cpu)		cpu_data(cpu).cpu_core_id
+#define TO_ATTR_NO(cpu)		(TO_CORE_ID(cpu) + BASE_SYSFS_ATTR_NO)
+
+#ifdef CONFIG_SMP
 #define for_each_sibling(i, cpu)	for_each_cpu(i, cpu_sibling_mask(cpu))
 #else
-#define TO_PHYS_ID(cpu)		(cpu)
-#define TO_CORE_ID(cpu)		(cpu)
 #define for_each_sibling(i, cpu)	for (i = 0; false; )
 #endif
-#define TO_ATTR_NO(cpu)		(TO_CORE_ID(cpu) + BASE_SYSFS_ATTR_NO)
 
 /*
  * Per-Core Temperature Data
diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index f02b523..37856f7 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -98,11 +98,11 @@ config PCI_PASID
 	  If unsure, say N.
 
 config PCI_IOAPIC
-	bool
+	tristate "PCI IO-APIC hotplug support" if X86
 	depends on PCI
 	depends on ACPI
 	depends on HOTPLUG
-	default y
+	default !X86
 
 config PCI_LABEL
 	def_bool y if (DMI || ACPI)
diff --git a/drivers/pci/ioapic.c b/drivers/pci/ioapic.c
index 5775638..205af8d 100644
--- a/drivers/pci/ioapic.c
+++ b/drivers/pci/ioapic.c
@@ -17,7 +17,7 @@
  */
 
 #include <linux/pci.h>
-#include <linux/export.h>
+#include <linux/module.h>
 #include <linux/acpi.h>
 #include <linux/slab.h>
 #include <acpi/acpi_bus.h>
@@ -27,7 +27,7 @@ struct ioapic {
 	u32		gsi_base;
 };
 
-static int ioapic_probe(struct pci_dev *dev, const struct pci_device_id *ent)
+static int __devinit ioapic_probe(struct pci_dev *dev, const struct pci_device_id *ent)
 {
 	acpi_handle handle;
 	acpi_status status;
@@ -88,7 +88,7 @@ exit_free:
 	return -ENODEV;
 }
 
-static void ioapic_remove(struct pci_dev *dev)
+static void __devexit ioapic_remove(struct pci_dev *dev)
 {
 	struct ioapic *ioapic = pci_get_drvdata(dev);
 
@@ -99,13 +99,12 @@ static void ioapic_remove(struct pci_dev *dev)
 }
 
 
-static struct pci_device_id ioapic_devices[] = {
-	{ PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
-	  PCI_CLASS_SYSTEM_PIC_IOAPIC << 8, 0xffff00, },
-	{ PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
-	  PCI_CLASS_SYSTEM_PIC_IOXAPIC << 8, 0xffff00, },
+static DEFINE_PCI_DEVICE_TABLE(ioapic_devices) = {
+	{ PCI_DEVICE_CLASS(PCI_CLASS_SYSTEM_PIC_IOAPIC, ~0) },
+	{ PCI_DEVICE_CLASS(PCI_CLASS_SYSTEM_PIC_IOXAPIC, ~0) },
 	{ }
 };
+MODULE_DEVICE_TABLE(pci, ioapic_devices);
 
 static struct pci_driver ioapic_driver = {
 	.name		= "ioapic",
