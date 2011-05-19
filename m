Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971Ab1ESVO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 17:14:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34519 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714Ab1ESVO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 17:14:27 -0400
Date: Thu, 19 May 2011 23:14:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
Subject: [GIT PULL] x86/mm changes for v2.6.40
Message-ID: <20110519211403.GA15870@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-mm-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-mm-for-linus

In hindsight this commit should have gone through the ACPI tree:

   out-of-topic modifications in x86-mm-for-linus:
   -----------------------------------------------
   drivers/acpi/processor_throttling.c# 9d42a53: acpi throttling: Use this_cpu_has

 Thanks,

	Ingo

------------------>
Christoph Lameter (3):
      x86: A fast way to check capabilities of the current cpu
      x86: Use this_cpu_has for thermal_interrupt current cpu
      acpi throttling: Use this_cpu_has and simplify code current cpu

David Rientjes (1):
      x86, mm: Allow ZONE_DMA to be configurable

Florian Mickler (1):
      x86-64, NUMA: Remove unused variable

Rakib Mullick (1):
      x86, mpparse: Put check_slot() into .init section

Tejun Heo (41):
      x86-64, NUMA: Remove custom phys_to_nid() implementation
      x86: Clean up memory model related configs in arch/x86/Kconfig
      x86-32, numa: Fix failure condition check in alloc_remap()
      x86-32, numa: Align pgdat size while initializing alloc_remap
      x86-32, numa: Remove redundant top-down alloc code from remap initialization
      x86-32, numa: Reorganize calculate_numa_remap_page()
      x86-32, numa: Rename @node_kva to @node_pa in init_alloc_remap()
      x86-32, numa: Make @size in init_aloc_remap() represent bytes
      x86-32, numa: Calculate remap size in common code
      x86-32, numa: Make init_alloc_remap() less panicky
      x86-32, numa: Move lowmem address space reservation to init_alloc_remap()
      x86-32, numa: Move remapping for remap allocator into init_alloc_remap()
      x86-32, numa: Make pgdat allocation use alloc_remap()
      x86-32, numa: Remove now useless node_remap_offset[]
      x86-32, numa: Remove redundant node_remap_size[]
      x86-32, numa: Update remap allocator comments
      x86-64, NUMA: Simplify hotadd memory handling
      x86-64, NUMA: trivial cleanups for setup_node_bootmem()
      x86-64, NUMA: simplify nodedata allocation
      x86-32, NUMA: Automatically set apicid -> node in setup_local_APIC()
      x86, NUMA: Unify 32/64bit numa_cpu_node() implementation
      x86-32, NUMA: Make apic->x86_32_numa_cpu_node() optional
      x86-32, NUMA: use sparse_memory_present_with_active_regions()
      x86, NUMA: trivial cleanups
      x86, NUMA: rename srat_64.c to srat.c
      x86, NUMA: make srat.c 32bit safe
      x86-32, NUMA: Move get_memcfg_numa() into numa_32.c
      x86, NUMA: Move numa_nodes_parsed to numa.[hc]
      x86-32, NUMA: implement temporary NUMA init shims
      x86-32, NUMA: Replace srat_32.c with srat.c
      x86-32, NUMA: Update numaq to use new NUMA init protocol
      x86, NUMA: Move NUMA init logic from numa_64.c to numa.c
      x86, NUMA: Enable build of generic NUMA init code on 32bit
      x86, NUMA: Remove long 64bit assumption from numa.c
      x86-32, NUMA: Add @start and @end to init_alloc_remap()
      x86, NUMA: Initialize and use remap allocator from setup_node_bootmem()
      x86, NUMA: Make 32bit use common NUMA init path
      x86, NUMA: Make numa_init_array() static
      x86, NUMA: Rename amdtopology_64.c to amdtopology.c
      x86, NUMA: Enable CONFIG_AMD_NUMA on 32bit too
      x86, NUMA: Enable emulation on 32bit too

Tim Gardner (1):
      ioremap: Delay sanity check until after a successful mapping

Yinghai Lu (2):
      x86, NUMA: Rename setup_node_bootmem() to setup_node_data()
      x86, NUMA: Trim numa meminfo with max_pfn in a separate loop


 arch/x86/Kconfig                                |   43 +-
 arch/x86/include/asm/acpi.h                     |    2 -
 arch/x86/include/asm/amd_nb.h                   |    1 -
 arch/x86/include/asm/apic.h                     |    9 +-
 arch/x86/include/asm/cpufeature.h               |   13 +-
 arch/x86/include/asm/dma.h                      |   12 +-
 arch/x86/include/asm/mmzone_32.h                |   20 -
 arch/x86/include/asm/mmzone_64.h                |   23 -
 arch/x86/include/asm/numa.h                     |   32 +-
 arch/x86/include/asm/numa_32.h                  |   10 -
 arch/x86/include/asm/numa_64.h                  |   36 --
 arch/x86/include/asm/numaq.h                    |    7 +-
 arch/x86/include/asm/percpu.h                   |   27 +
 arch/x86/include/asm/srat.h                     |   39 --
 arch/x86/include/asm/topology.h                 |    8 -
 arch/x86/kernel/apic/apic.c                     |   28 +-
 arch/x86/kernel/apic/apic_noop.c                |    9 -
 arch/x86/kernel/apic/bigsmp_32.c                |    1 -
 arch/x86/kernel/apic/es7000_32.c                |    7 -
 arch/x86/kernel/apic/numaq_32.c                 |   34 +-
 arch/x86/kernel/apic/probe_32.c                 |    1 -
 arch/x86/kernel/apic/summit_32.c                |    1 -
 arch/x86/kernel/cpu/mcheck/therm_throt.c        |    7 +-
 arch/x86/kernel/mpparse.c                       |    2 +-
 arch/x86/kernel/process.c                       |    4 +-
 arch/x86/kernel/smpboot.c                       |    4 +-
 arch/x86/mm/Makefile                            |    4 +-
 arch/x86/mm/{amdtopology_64.c => amdtopology.c} |   21 +-
 arch/x86/mm/init_32.c                           |    3 +
 arch/x86/mm/init_64.c                           |   10 +-
 arch/x86/mm/ioremap.c                           |   14 +-
 arch/x86/mm/numa.c                              |  550 +++++++++++++++++++-
 arch/x86/mm/numa_32.c                           |  398 ++++-----------
 arch/x86/mm/numa_64.c                           |  644 +----------------------
 arch/x86/mm/numa_emulation.c                    |   16 +-
 arch/x86/mm/numa_internal.h                     |    8 +
 arch/x86/mm/{srat_64.c => srat.c}               |   82 +---
 arch/x86/mm/srat_32.c                           |  288 ----------
 drivers/acpi/processor_throttling.c             |   32 +-
 39 files changed, 836 insertions(+), 1614 deletions(-)
 delete mode 100644 arch/x86/include/asm/srat.h
 rename arch/x86/mm/{amdtopology_64.c => amdtopology.c} (90%)
 rename arch/x86/mm/{srat_64.c => srat.c} (67%)
 delete mode 100644 arch/x86/mm/srat_32.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cc6c53a..0eb801a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -112,7 +112,14 @@ config MMU
 	def_bool y
 
 config ZONE_DMA
-	def_bool y
+	bool "DMA memory allocation support" if EXPERT
+	default y
+	help
+	  DMA memory allocation support allows devices with less than 32-bit
+	  addressing to allocate within the first 16MB of address space.
+	  Disable if no such devices will be used.
+
+	  If unsure, say Y.
 
 config SBUS
 	bool
@@ -1174,7 +1181,7 @@ comment "NUMA (Summit) requires SMP, 64GB highmem support, ACPI"
 config AMD_NUMA
 	def_bool y
 	prompt "Old style AMD Opteron NUMA detection"
-	depends on X86_64 && NUMA && PCI
+	depends on NUMA && PCI
 	---help---
 	  Enable AMD NUMA node topology detection.  You should say Y here if
 	  you have a multi processor AMD system. This uses an old method to
@@ -1201,7 +1208,7 @@ config NODES_SPAN_OTHER_NODES
 
 config NUMA_EMU
 	bool "NUMA emulation"
-	depends on X86_64 && NUMA
+	depends on NUMA
 	---help---
 	  Enable NUMA emulation. A flat machine will be split
 	  into virtual nodes when booted with "numa=fake=N", where N is the
@@ -1223,6 +1230,10 @@ config HAVE_ARCH_BOOTMEM
 	def_bool y
 	depends on X86_32 && NUMA
 
+config HAVE_ARCH_ALLOC_REMAP
+	def_bool y
+	depends on X86_32 && NUMA
+
 config ARCH_HAVE_MEMORY_PRESENT
 	def_bool y
 	depends on X86_32 && DISCONTIGMEM
@@ -1231,13 +1242,9 @@ config NEED_NODE_MEMMAP_SIZE
 	def_bool y
 	depends on X86_32 && (DISCONTIGMEM || SPARSEMEM)
 
-config HAVE_ARCH_ALLOC_REMAP
-	def_bool y
-	depends on X86_32 && NUMA
-
 config ARCH_FLATMEM_ENABLE
 	def_bool y
-	depends on X86_32 && ARCH_SELECT_MEMORY_MODEL && !NUMA
+	depends on X86_32 && !NUMA
 
 config ARCH_DISCONTIGMEM_ENABLE
 	def_bool y
@@ -1247,20 +1254,16 @@ config ARCH_DISCONTIGMEM_DEFAULT
 	def_bool y
 	depends on NUMA && X86_32
 
-config ARCH_PROC_KCORE_TEXT
-	def_bool y
-	depends on X86_64 && PROC_KCORE
-
-config ARCH_SPARSEMEM_DEFAULT
-	def_bool y
-	depends on X86_64
-
 config ARCH_SPARSEMEM_ENABLE
 	def_bool y
 	depends on X86_64 || NUMA || (EXPERIMENTAL && X86_32) || X86_32_NON_STANDARD
 	select SPARSEMEM_STATIC if X86_32
 	select SPARSEMEM_VMEMMAP_ENABLE if X86_64
 
+config ARCH_SPARSEMEM_DEFAULT
+	def_bool y
+	depends on X86_64
+
 config ARCH_SELECT_MEMORY_MODEL
 	def_bool y
 	depends on ARCH_SPARSEMEM_ENABLE
@@ -1269,6 +1272,10 @@ config ARCH_MEMORY_PROBE
 	def_bool X86_64
 	depends on MEMORY_HOTPLUG
 
+config ARCH_PROC_KCORE_TEXT
+	def_bool y
+	depends on X86_64 && PROC_KCORE
+
 config ILLEGAL_POINTER_VALUE
        hex
        default 0 if X86_32
@@ -1703,10 +1710,6 @@ config ARCH_ENABLE_MEMORY_HOTREMOVE
 	def_bool y
 	depends on MEMORY_HOTPLUG
 
-config HAVE_ARCH_EARLY_PFN_TO_NID
-	def_bool X86_64
-	depends on NUMA
-
 config USE_PERCPU_NUMA_NODE_ID
 	def_bool y
 	depends on NUMA
diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index 12e0e7d..416d865 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -183,8 +183,6 @@ static inline void disable_acpi(void) { }
 
 #define ARCH_HAS_POWER_INIT	1
 
-struct bootnode;
-
 #ifdef CONFIG_ACPI_NUMA
 extern int acpi_numa;
 extern int x86_acpi_numa_init(void);
diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
index 3316822..67f87f2 100644
--- a/arch/x86/include/asm/amd_nb.h
+++ b/arch/x86/include/asm/amd_nb.h
@@ -11,7 +11,6 @@ struct amd_nb_bus_dev_range {
 
 extern const struct pci_device_id amd_nb_misc_ids[];
 extern const struct amd_nb_bus_dev_range amd_nb_bus_dev_ranges[];
-struct bootnode;
 
 extern bool early_is_amd_nb(u32 value);
 extern int amd_cache_northbridges(void);
diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 2b7d573..a0c46f0 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -363,7 +363,12 @@ struct apic {
 	 */
 	int (*x86_32_early_logical_apicid)(int cpu);
 
-	/* determine CPU -> NUMA node mapping */
+	/*
+	 * Optional method called from setup_local_APIC() after logical
+	 * apicid is guaranteed to be known to initialize apicid -> node
+	 * mapping if NUMA initialization hasn't done so already.  Don't
+	 * add new users.
+	 */
 	int (*x86_32_numa_cpu_node)(int cpu);
 #endif
 };
@@ -537,8 +542,6 @@ static inline int default_phys_pkg_id(int cpuid_apic, int index_msb)
 	return cpuid_apic >> index_msb;
 }
 
-extern int default_x86_32_numa_cpu_node(int cpu);
-
 #endif
 
 static inline unsigned int
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 91f3e087..50c0d30 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -207,8 +207,7 @@ extern const char * const x86_power_flags[32];
 #define test_cpu_cap(c, bit)						\
 	 test_bit(bit, (unsigned long *)((c)->x86_capability))
 
-#define cpu_has(c, bit)							\
-	(__builtin_constant_p(bit) &&					\
+#define REQUIRED_MASK_BIT_SET(bit)					\
 	 ( (((bit)>>5)==0 && (1UL<<((bit)&31) & REQUIRED_MASK0)) ||	\
 	   (((bit)>>5)==1 && (1UL<<((bit)&31) & REQUIRED_MASK1)) ||	\
 	   (((bit)>>5)==2 && (1UL<<((bit)&31) & REQUIRED_MASK2)) ||	\
@@ -218,10 +217,16 @@ extern const char * const x86_power_flags[32];
 	   (((bit)>>5)==6 && (1UL<<((bit)&31) & REQUIRED_MASK6)) ||	\
 	   (((bit)>>5)==7 && (1UL<<((bit)&31) & REQUIRED_MASK7)) ||	\
 	   (((bit)>>5)==8 && (1UL<<((bit)&31) & REQUIRED_MASK8)) ||	\
-	   (((bit)>>5)==9 && (1UL<<((bit)&31) & REQUIRED_MASK9)) )	\
-	  ? 1 :								\
+	   (((bit)>>5)==9 && (1UL<<((bit)&31) & REQUIRED_MASK9)) )
+
+#define cpu_has(c, bit)							\
+	(__builtin_constant_p(bit) && REQUIRED_MASK_BIT_SET(bit) ? 1 :	\
 	 test_cpu_cap(c, bit))
 
+#define this_cpu_has(bit)						\
+	(__builtin_constant_p(bit) && REQUIRED_MASK_BIT_SET(bit) ? 1 : 	\
+	 x86_this_cpu_test_bit(bit, (unsigned long *)&cpu_info.x86_capability))
+
 #define boot_cpu_has(bit)	cpu_has(&boot_cpu_data, bit)
 
 #define set_cpu_cap(c, bit)	set_bit(bit, (unsigned long *)((c)->x86_capability))
diff --git a/arch/x86/include/asm/dma.h b/arch/x86/include/asm/dma.h
index 057099e..0bdb0c5 100644
--- a/arch/x86/include/asm/dma.h
+++ b/arch/x86/include/asm/dma.h
@@ -69,22 +69,18 @@
 
 #define MAX_DMA_CHANNELS	8
 
-#ifdef CONFIG_X86_32
-
-/* The maximum address that we can perform a DMA transfer to on this platform */
-#define MAX_DMA_ADDRESS      (PAGE_OFFSET + 0x1000000)
-
-#else
-
 /* 16MB ISA DMA zone */
 #define MAX_DMA_PFN   ((16 * 1024 * 1024) >> PAGE_SHIFT)
 
 /* 4GB broken PCI/AGP hardware bus master zone */
 #define MAX_DMA32_PFN ((4UL * 1024 * 1024 * 1024) >> PAGE_SHIFT)
 
+#ifdef CONFIG_X86_32
+/* The maximum address that we can perform a DMA transfer to on this platform */
+#define MAX_DMA_ADDRESS      (PAGE_OFFSET + 0x1000000)
+#else
 /* Compat define for old dma zone */
 #define MAX_DMA_ADDRESS ((unsigned long)__va(MAX_DMA_PFN << PAGE_SHIFT))
-
 #endif
 
 /* 8237 DMA controllers */
diff --git a/arch/x86/include/asm/mmzone_32.h b/arch/x86/include/asm/mmzone_32.h
index 91df7c5..5e83a41 100644
--- a/arch/x86/include/asm/mmzone_32.h
+++ b/arch/x86/include/asm/mmzone_32.h
@@ -13,31 +13,11 @@ extern struct pglist_data *node_data[];
 #define NODE_DATA(nid)	(node_data[nid])
 
 #include <asm/numaq.h>
-/* summit or generic arch */
-#include <asm/srat.h>
-
-extern int get_memcfg_numa_flat(void);
-/*
- * This allows any one NUMA architecture to be compiled
- * for, and still fall back to the flat function if it
- * fails.
- */
-static inline void get_memcfg_numa(void)
-{
-
-	if (get_memcfg_numaq())
-		return;
-	if (get_memcfg_from_srat())
-		return;
-	get_memcfg_numa_flat();
-}
 
 extern void resume_map_numa_kva(pgd_t *pgd);
 
 #else /* !CONFIG_NUMA */
 
-#define get_memcfg_numa get_memcfg_numa_flat
-
 static inline void resume_map_numa_kva(pgd_t *pgd) {}
 
 #endif /* CONFIG_NUMA */
diff --git a/arch/x86/include/asm/mmzone_64.h b/arch/x86/include/asm/mmzone_64.h
index 288b96f..b3f88d7 100644
--- a/arch/x86/include/asm/mmzone_64.h
+++ b/arch/x86/include/asm/mmzone_64.h
@@ -4,36 +4,13 @@
 #ifndef _ASM_X86_MMZONE_64_H
 #define _ASM_X86_MMZONE_64_H
 
-
 #ifdef CONFIG_NUMA
 
 #include <linux/mmdebug.h>
-
 #include <asm/smp.h>
 
-/* Simple perfect hash to map physical addresses to node numbers */
-struct memnode {
-	int shift;
-	unsigned int mapsize;
-	s16 *map;
-	s16 embedded_map[64 - 8];
-} ____cacheline_aligned; /* total size = 128 bytes */
-extern struct memnode memnode;
-#define memnode_shift memnode.shift
-#define memnodemap memnode.map
-#define memnodemapsize memnode.mapsize
-
 extern struct pglist_data *node_data[];
 
-static inline __attribute__((pure)) int phys_to_nid(unsigned long addr)
-{
-	unsigned nid;
-	VIRTUAL_BUG_ON(!memnodemap);
-	nid = memnodemap[addr >> memnode_shift];
-	VIRTUAL_BUG_ON(nid >= MAX_NUMNODES || !node_data[nid]);
-	return nid;
-}
-
 #define NODE_DATA(nid)		(node_data[nid])
 
 #define node_start_pfn(nid)	(NODE_DATA(nid)->node_start_pfn)
diff --git a/arch/x86/include/asm/numa.h b/arch/x86/include/asm/numa.h
index a50fc9f..bfacd2c 100644
--- a/arch/x86/include/asm/numa.h
+++ b/arch/x86/include/asm/numa.h
@@ -1,12 +1,24 @@
 #ifndef _ASM_X86_NUMA_H
 #define _ASM_X86_NUMA_H
 
+#include <linux/nodemask.h>
+
 #include <asm/topology.h>
 #include <asm/apicdef.h>
 
 #ifdef CONFIG_NUMA
 
 #define NR_NODE_MEMBLKS		(MAX_NUMNODES*2)
+#define ZONE_ALIGN (1UL << (MAX_ORDER+PAGE_SHIFT))
+
+/*
+ * Too small node sizes may confuse the VM badly. Usually they
+ * result from BIOS bugs. So dont recognize nodes as standalone
+ * NUMA entities that have less than this amount of RAM listed:
+ */
+#define NODE_MIN_SIZE (4*1024*1024)
+
+extern int numa_off;
 
 /*
  * __apicid_to_node[] stores the raw mapping between physical apicid and
@@ -17,15 +29,27 @@
  * numa_cpu_node().
  */
 extern s16 __apicid_to_node[MAX_LOCAL_APIC];
+extern nodemask_t numa_nodes_parsed __initdata;
+
+extern int __init numa_add_memblk(int nodeid, u64 start, u64 end);
+extern void __init numa_set_distance(int from, int to, int distance);
 
 static inline void set_apicid_to_node(int apicid, s16 node)
 {
 	__apicid_to_node[apicid] = node;
 }
+
+extern int __cpuinit numa_cpu_node(int cpu);
+
 #else	/* CONFIG_NUMA */
 static inline void set_apicid_to_node(int apicid, s16 node)
 {
 }
+
+static inline int numa_cpu_node(int cpu)
+{
+	return NUMA_NO_NODE;
+}
 #endif	/* CONFIG_NUMA */
 
 #ifdef CONFIG_X86_32
@@ -37,14 +61,12 @@ static inline void set_apicid_to_node(int apicid, s16 node)
 #ifdef CONFIG_NUMA
 extern void __cpuinit numa_set_node(int cpu, int node);
 extern void __cpuinit numa_clear_node(int cpu);
-extern void __init numa_init_array(void);
 extern void __init init_cpu_to_node(void);
 extern void __cpuinit numa_add_cpu(int cpu);
 extern void __cpuinit numa_remove_cpu(int cpu);
 #else	/* CONFIG_NUMA */
 static inline void numa_set_node(int cpu, int node)	{ }
 static inline void numa_clear_node(int cpu)		{ }
-static inline void numa_init_array(void)		{ }
 static inline void init_cpu_to_node(void)		{ }
 static inline void numa_add_cpu(int cpu)		{ }
 static inline void numa_remove_cpu(int cpu)		{ }
@@ -54,4 +76,10 @@ static inline void numa_remove_cpu(int cpu)		{ }
 void debug_cpumask_set_cpu(int cpu, int node, bool enable);
 #endif
 
+#ifdef CONFIG_NUMA_EMU
+#define FAKE_NODE_MIN_SIZE	((u64)32 << 20)
+#define FAKE_NODE_MIN_HASH_MASK	(~(FAKE_NODE_MIN_SIZE - 1UL))
+void numa_emu_cmdline(char *);
+#endif /* CONFIG_NUMA_EMU */
+
 #endif	/* _ASM_X86_NUMA_H */
diff --git a/arch/x86/include/asm/numa_32.h b/arch/x86/include/asm/numa_32.h
index c6beed1..e7d6b82 100644
--- a/arch/x86/include/asm/numa_32.h
+++ b/arch/x86/include/asm/numa_32.h
@@ -1,16 +1,6 @@
 #ifndef _ASM_X86_NUMA_32_H
 #define _ASM_X86_NUMA_32_H
 
-extern int numa_off;
-
-extern int pxm_to_nid(int pxm);
-
-#ifdef CONFIG_NUMA
-extern int __cpuinit numa_cpu_node(int cpu);
-#else	/* CONFIG_NUMA */
-static inline int numa_cpu_node(int cpu)		{ return NUMA_NO_NODE; }
-#endif	/* CONFIG_NUMA */
-
 #ifdef CONFIG_HIGHMEM
 extern void set_highmem_pages_init(void);
 #else
diff --git a/arch/x86/include/asm/numa_64.h b/arch/x86/include/asm/numa_64.h
index 344eb17..0c05f7a 100644
--- a/arch/x86/include/asm/numa_64.h
+++ b/arch/x86/include/asm/numa_64.h
@@ -1,42 +1,6 @@
 #ifndef _ASM_X86_NUMA_64_H
 #define _ASM_X86_NUMA_64_H
 
-#include <linux/nodemask.h>
-
-struct bootnode {
-	u64 start;
-	u64 end;
-};
-
-#define ZONE_ALIGN (1UL << (MAX_ORDER+PAGE_SHIFT))
-
-extern int numa_off;
-
 extern unsigned long numa_free_all_bootmem(void);
-extern void setup_node_bootmem(int nodeid, unsigned long start,
-			       unsigned long end);
-
-#ifdef CONFIG_NUMA
-/*
- * Too small node sizes may confuse the VM badly. Usually they
- * result from BIOS bugs. So dont recognize nodes as standalone
- * NUMA entities that have less than this amount of RAM listed:
- */
-#define NODE_MIN_SIZE (4*1024*1024)
-
-extern nodemask_t numa_nodes_parsed __initdata;
-
-extern int __cpuinit numa_cpu_node(int cpu);
-extern int __init numa_add_memblk(int nodeid, u64 start, u64 end);
-extern void __init numa_set_distance(int from, int to, int distance);
-
-#ifdef CONFIG_NUMA_EMU
-#define FAKE_NODE_MIN_SIZE	((u64)32 << 20)
-#define FAKE_NODE_MIN_HASH_MASK	(~(FAKE_NODE_MIN_SIZE - 1UL))
-void numa_emu_cmdline(char *);
-#endif /* CONFIG_NUMA_EMU */
-#else
-static inline int numa_cpu_node(int cpu)		{ return NUMA_NO_NODE; }
-#endif
 
 #endif /* _ASM_X86_NUMA_64_H */
diff --git a/arch/x86/include/asm/numaq.h b/arch/x86/include/asm/numaq.h
index 37c5165..c3b3c32 100644
--- a/arch/x86/include/asm/numaq.h
+++ b/arch/x86/include/asm/numaq.h
@@ -29,7 +29,7 @@
 #ifdef CONFIG_X86_NUMAQ
 
 extern int found_numaq;
-extern int get_memcfg_numaq(void);
+extern int numaq_numa_init(void);
 extern int pci_numaq_init(void);
 
 extern void *xquad_portio;
@@ -166,11 +166,6 @@ struct sys_cfg_data {
 
 void numaq_tsc_disable(void);
 
-#else
-static inline int get_memcfg_numaq(void)
-{
-	return 0;
-}
 #endif /* CONFIG_X86_NUMAQ */
 #endif /* _ASM_X86_NUMAQ_H */
 
diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index d475b43..76042d9 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -542,6 +542,33 @@ do {									\
 	old__;								\
 })
 
+static __always_inline int x86_this_cpu_constant_test_bit(unsigned int nr,
+                        const unsigned long __percpu *addr)
+{
+	unsigned long __percpu *a = (unsigned long *)addr + nr / BITS_PER_LONG;
+
+	return ((1UL << (nr % BITS_PER_LONG)) & percpu_read(*a)) != 0;
+}
+
+static inline int x86_this_cpu_variable_test_bit(int nr,
+                        const unsigned long __percpu *addr)
+{
+	int oldbit;
+
+	asm volatile("bt "__percpu_arg(2)",%1\n\t"
+			"sbb %0,%0"
+			: "=r" (oldbit)
+			: "m" (*(unsigned long *)addr), "Ir" (nr));
+
+	return oldbit;
+}
+
+#define x86_this_cpu_test_bit(nr, addr)			\
+	(__builtin_constant_p((nr))			\
+	 ? x86_this_cpu_constant_test_bit((nr), (addr))	\
+	 : x86_this_cpu_variable_test_bit((nr), (addr)))
+
+
 #include <asm-generic/percpu.h>
 
 /* We can use this directly for local CPU (faster). */
diff --git a/arch/x86/include/asm/srat.h b/arch/x86/include/asm/srat.h
deleted file mode 100644
index b508d63..0000000
--- a/arch/x86/include/asm/srat.h
+++ /dev/null
@@ -1,39 +0,0 @@
-/*
- * Some of the code in this file has been gleaned from the 64 bit
- * discontigmem support code base.
- *
- * Copyright (C) 2002, IBM Corp.
- *
- * All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
- * NON INFRINGEMENT.  See the GNU General Public License for more
- * details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- *
- * Send feedback to Pat Gaughen <gone@us.ibm.com>
- */
-
-#ifndef _ASM_X86_SRAT_H
-#define _ASM_X86_SRAT_H
-
-#ifdef CONFIG_ACPI_NUMA
-extern int get_memcfg_from_srat(void);
-#else
-static inline int get_memcfg_from_srat(void)
-{
-	return 0;
-}
-#endif
-
-#endif /* _ASM_X86_SRAT_H */
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 910a708..c006924 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -93,19 +93,11 @@ extern void setup_node_to_cpumask_map(void);
 #define pcibus_to_node(bus) __pcibus_to_node(bus)
 
 #ifdef CONFIG_X86_32
-extern unsigned long node_start_pfn[];
-extern unsigned long node_end_pfn[];
-extern unsigned long node_remap_size[];
-#define node_has_online_mem(nid) (node_start_pfn[nid] != node_end_pfn[nid])
-
 # define SD_CACHE_NICE_TRIES	1
 # define SD_IDLE_IDX		1
-
 #else
-
 # define SD_CACHE_NICE_TRIES	2
 # define SD_IDLE_IDX		2
-
 #endif
 
 /* sched_domains SD_NODE_INIT for NUMA machines */
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index fabf01e..0c67b4f 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -505,7 +505,7 @@ static void __cpuinit setup_APIC_timer(void)
 {
 	struct clock_event_device *levt = &__get_cpu_var(lapic_events);
 
-	if (cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_ARAT)) {
+	if (this_cpu_has(X86_FEATURE_ARAT)) {
 		lapic_clockevent.features &= ~CLOCK_EVT_FEAT_C3STOP;
 		/* Make LAPIC timer preferrable over percpu HPET */
 		lapic_clockevent.rating = 150;
@@ -1237,6 +1237,17 @@ void __cpuinit setup_local_APIC(void)
 	/* always use the value from LDR */
 	early_per_cpu(x86_cpu_to_logical_apicid, cpu) =
 		logical_smp_processor_id();
+
+	/*
+	 * Some NUMA implementations (NUMAQ) don't initialize apicid to
+	 * node mapping during NUMA init.  Now that logical apicid is
+	 * guaranteed to be known, give it another chance.  This is already
+	 * a bit too late - percpu allocation has already happened without
+	 * proper NUMA affinity.
+	 */
+	if (apic->x86_32_numa_cpu_node)
+		set_apicid_to_node(early_per_cpu(x86_cpu_to_apicid, cpu),
+				   apic->x86_32_numa_cpu_node(cpu));
 #endif
 
 	/*
@@ -2003,21 +2014,6 @@ void default_init_apic_ldr(void)
 	apic_write(APIC_LDR, val);
 }
 
-#ifdef CONFIG_X86_32
-int default_x86_32_numa_cpu_node(int cpu)
-{
-#ifdef CONFIG_NUMA
-	int apicid = early_per_cpu(x86_cpu_to_apicid, cpu);
-
-	if (apicid != BAD_APICID)
-		return __apicid_to_node[apicid];
-	return NUMA_NO_NODE;
-#else
-	return 0;
-#endif
-}
-#endif
-
 /*
  * Power management
  */
diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
index f1baa2d..775b82b 100644
--- a/arch/x86/kernel/apic/apic_noop.c
+++ b/arch/x86/kernel/apic/apic_noop.c
@@ -119,14 +119,6 @@ static void noop_apic_write(u32 reg, u32 v)
 	WARN_ON_ONCE(cpu_has_apic && !disable_apic);
 }
 
-#ifdef CONFIG_X86_32
-static int noop_x86_32_numa_cpu_node(int cpu)
-{
-	/* we're always on node 0 */
-	return 0;
-}
-#endif
-
 struct apic apic_noop = {
 	.name				= "noop",
 	.probe				= noop_probe,
@@ -195,6 +187,5 @@ struct apic apic_noop = {
 
 #ifdef CONFIG_X86_32
 	.x86_32_early_logical_apicid	= noop_x86_32_early_logical_apicid,
-	.x86_32_numa_cpu_node		= noop_x86_32_numa_cpu_node,
 #endif
 };
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
index 541a2e4..d84ac5a5 100644
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -253,5 +253,4 @@ struct apic apic_bigsmp = {
 	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
 
 	.x86_32_early_logical_apicid	= bigsmp_early_logical_apicid,
-	.x86_32_numa_cpu_node		= default_x86_32_numa_cpu_node,
 };
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 3e9de48..70533de 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -510,11 +510,6 @@ static void es7000_setup_apic_routing(void)
 		nr_ioapics, cpumask_bits(es7000_target_cpus())[0]);
 }
 
-static int es7000_numa_cpu_node(int cpu)
-{
-	return 0;
-}
-
 static int es7000_cpu_present_to_apicid(int mps_cpu)
 {
 	if (!mps_cpu)
@@ -688,7 +683,6 @@ struct apic __refdata apic_es7000_cluster = {
 	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
 
 	.x86_32_early_logical_apicid	= es7000_early_logical_apicid,
-	.x86_32_numa_cpu_node		= es7000_numa_cpu_node,
 };
 
 struct apic __refdata apic_es7000 = {
@@ -752,5 +746,4 @@ struct apic __refdata apic_es7000 = {
 	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
 
 	.x86_32_early_logical_apicid	= es7000_early_logical_apicid,
-	.x86_32_numa_cpu_node		= es7000_numa_cpu_node,
 };
diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index 6273eee..30f1331 100644
--- a/arch/x86/kernel/apic/numaq_32.c
+++ b/arch/x86/kernel/apic/numaq_32.c
@@ -48,8 +48,6 @@
 #include <asm/e820.h>
 #include <asm/ipi.h>
 
-#define	MB_TO_PAGES(addr)		((addr) << (20 - PAGE_SHIFT))
-
 int found_numaq;
 
 /*
@@ -79,31 +77,20 @@ int					quad_local_to_mp_bus_id[NR_CPUS/4][4];
 static inline void numaq_register_node(int node, struct sys_cfg_data *scd)
 {
 	struct eachquadmem *eq = scd->eq + node;
+	u64 start = (u64)(eq->hi_shrd_mem_start - eq->priv_mem_size) << 20;
+	u64 end = (u64)(eq->hi_shrd_mem_start + eq->hi_shrd_mem_size) << 20;
+	int ret;
 
-	node_set_online(node);
-
-	/* Convert to pages */
-	node_start_pfn[node] =
-		 MB_TO_PAGES(eq->hi_shrd_mem_start - eq->priv_mem_size);
-
-	node_end_pfn[node] =
-		 MB_TO_PAGES(eq->hi_shrd_mem_start + eq->hi_shrd_mem_size);
-
-	memblock_x86_register_active_regions(node, node_start_pfn[node],
-						node_end_pfn[node]);
-
-	memory_present(node, node_start_pfn[node], node_end_pfn[node]);
-
-	node_remap_size[node] = node_memmap_size_bytes(node,
-					node_start_pfn[node],
-					node_end_pfn[node]);
+	node_set(node, numa_nodes_parsed);
+	ret = numa_add_memblk(node, start, end);
+	BUG_ON(ret < 0);
 }
 
 /*
  * Function: smp_dump_qct()
  *
  * Description: gets memory layout from the quad config table.  This
- * function also updates node_online_map with the nodes (quads) present.
+ * function also updates numa_nodes_parsed with the nodes (quads) present.
  */
 static void __init smp_dump_qct(void)
 {
@@ -112,7 +99,6 @@ static void __init smp_dump_qct(void)
 
 	scd = (void *)__va(SYS_CFG_DATA_PRIV_ADDR);
 
-	nodes_clear(node_online_map);
 	for_each_node(node) {
 		if (scd->quads_present31_0 & (1 << node))
 			numaq_register_node(node, scd);
@@ -282,14 +268,14 @@ static __init void early_check_numaq(void)
 	}
 }
 
-int __init get_memcfg_numaq(void)
+int __init numaq_numa_init(void)
 {
 	early_check_numaq();
 	if (!found_numaq)
-		return 0;
+		return -ENOENT;
 	smp_dump_qct();
 
-	return 1;
+	return 0;
 }
 
 #define NUMAQ_APIC_DFR_VALUE	(APIC_DFR_CLUSTER)
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index fc84c7b..6541e47 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -172,7 +172,6 @@ struct apic apic_default = {
 	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
 
 	.x86_32_early_logical_apicid	= default_x86_32_early_logical_apicid,
-	.x86_32_numa_cpu_node		= default_x86_32_numa_cpu_node,
 };
 
 extern struct apic apic_numaq;
diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index e4b8059..35bcd7d 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -551,5 +551,4 @@ struct apic apic_summit = {
 	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
 
 	.x86_32_early_logical_apicid	= summit_early_logical_apicid,
-	.x86_32_numa_cpu_node		= default_x86_32_numa_cpu_node,
 };
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 6f8c5e9..6b0f4cd 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -355,7 +355,6 @@ static void notify_thresholds(__u64 msr_val)
 static void intel_thermal_interrupt(void)
 {
 	__u64 msr_val;
-	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
 
 	rdmsrl(MSR_IA32_THERM_STATUS, msr_val);
 
@@ -367,19 +366,19 @@ static void intel_thermal_interrupt(void)
 				CORE_LEVEL) != 0)
 		mce_log_therm_throt_event(CORE_THROTTLED | msr_val);
 
-	if (cpu_has(c, X86_FEATURE_PLN))
+	if (this_cpu_has(X86_FEATURE_PLN))
 		if (therm_throt_process(msr_val & THERM_STATUS_POWER_LIMIT,
 					POWER_LIMIT_EVENT,
 					CORE_LEVEL) != 0)
 			mce_log_therm_throt_event(CORE_POWER_LIMIT | msr_val);
 
-	if (cpu_has(c, X86_FEATURE_PTS)) {
+	if (this_cpu_has(X86_FEATURE_PTS)) {
 		rdmsrl(MSR_IA32_PACKAGE_THERM_STATUS, msr_val);
 		if (therm_throt_process(msr_val & PACKAGE_THERM_STATUS_PROCHOT,
 					THERMAL_THROTTLING_EVENT,
 					PACKAGE_LEVEL) != 0)
 			mce_log_therm_throt_event(PACKAGE_THROTTLED | msr_val);
-		if (cpu_has(c, X86_FEATURE_PLN))
+		if (this_cpu_has(X86_FEATURE_PLN))
 			if (therm_throt_process(msr_val &
 					PACKAGE_THERM_STATUS_POWER_LIMIT,
 					POWER_LIMIT_EVENT,
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 5a532ce..f1b2718 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -715,7 +715,7 @@ static void __init check_irq_src(struct mpc_intsrc *m, int *nr_m_spare)
 	}
 }
 
-static int
+static int __init
 check_slot(unsigned long mpc_new_phys, unsigned long mpc_new_length, int count)
 {
 	int ret = 0;
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index d46cbe4..88a90a9 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -449,7 +449,7 @@ EXPORT_SYMBOL_GPL(cpu_idle_wait);
 void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
 {
 	if (!need_resched()) {
-		if (cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_CLFLUSH_MONITOR))
+		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
 			clflush((void *)&current_thread_info()->flags);
 
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
@@ -465,7 +465,7 @@ static void mwait_idle(void)
 	if (!need_resched()) {
 		trace_power_start(POWER_CSTATE, 1, smp_processor_id());
 		trace_cpu_idle(1, smp_processor_id());
-		if (cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_CLFLUSH_MONITOR))
+		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
 			clflush((void *)&current_thread_info()->flags);
 
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index c2871d3..a3c430b 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1332,9 +1332,9 @@ static inline void mwait_play_dead(void)
 	void *mwait_ptr;
 	struct cpuinfo_x86 *c = __this_cpu_ptr(&cpu_info);
 
-	if (!(cpu_has(c, X86_FEATURE_MWAIT) && mwait_usable(c)))
+	if (!this_cpu_has(X86_FEATURE_MWAIT) && mwait_usable(c))
 		return;
-	if (!cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_CLFLSH))
+	if (!this_cpu_has(X86_FEATURE_CLFLSH))
 		return;
 	if (__this_cpu_read(cpu_info.cpuid_level) < CPUID_MWAIT_LEAF)
 		return;
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 3e608ed..3d11327 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -23,8 +23,8 @@ mmiotrace-y			:= kmmio.o pf_in.o mmio-mod.o
 obj-$(CONFIG_MMIOTRACE_TEST)	+= testmmiotrace.o
 
 obj-$(CONFIG_NUMA)		+= numa.o numa_$(BITS).o
-obj-$(CONFIG_AMD_NUMA)		+= amdtopology_64.o
-obj-$(CONFIG_ACPI_NUMA)		+= srat_$(BITS).o
+obj-$(CONFIG_AMD_NUMA)		+= amdtopology.o
+obj-$(CONFIG_ACPI_NUMA)		+= srat.o
 obj-$(CONFIG_NUMA_EMU)		+= numa_emulation.o
 
 obj-$(CONFIG_HAVE_MEMBLOCK)		+= memblock.o
diff --git a/arch/x86/mm/amdtopology_64.c b/arch/x86/mm/amdtopology.c
similarity index 90%
rename from arch/x86/mm/amdtopology_64.c
rename to arch/x86/mm/amdtopology.c
index 0919c26..5247d01 100644
--- a/arch/x86/mm/amdtopology_64.c
+++ b/arch/x86/mm/amdtopology.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/nodemask.h>
 #include <linux/memblock.h>
+#include <linux/bootmem.h>
 
 #include <asm/io.h>
 #include <linux/pci_ids.h>
@@ -69,10 +70,10 @@ static __init void early_get_boot_cpu_id(void)
 
 int __init amd_numa_init(void)
 {
-	unsigned long start = PFN_PHYS(0);
-	unsigned long end = PFN_PHYS(max_pfn);
+	u64 start = PFN_PHYS(0);
+	u64 end = PFN_PHYS(max_pfn);
 	unsigned numnodes;
-	unsigned long prevbase;
+	u64 prevbase;
 	int i, j, nb;
 	u32 nodeid, reg;
 	unsigned int bits, cores, apicid_base;
@@ -95,7 +96,7 @@ int __init amd_numa_init(void)
 
 	prevbase = 0;
 	for (i = 0; i < 8; i++) {
-		unsigned long base, limit;
+		u64 base, limit;
 
 		base = read_pci_config(0, nb, 1, 0x40 + i*8);
 		limit = read_pci_config(0, nb, 1, 0x44 + i*8);
@@ -107,18 +108,18 @@ int __init amd_numa_init(void)
 			continue;
 		}
 		if (nodeid >= numnodes) {
-			pr_info("Ignoring excess node %d (%lx:%lx)\n", nodeid,
+			pr_info("Ignoring excess node %d (%Lx:%Lx)\n", nodeid,
 				base, limit);
 			continue;
 		}
 
 		if (!limit) {
-			pr_info("Skipping node entry %d (base %lx)\n",
+			pr_info("Skipping node entry %d (base %Lx)\n",
 				i, base);
 			continue;
 		}
 		if ((base >> 8) & 3 || (limit >> 8) & 3) {
-			pr_err("Node %d using interleaving mode %lx/%lx\n",
+			pr_err("Node %d using interleaving mode %Lx/%Lx\n",
 			       nodeid, (base >> 8) & 3, (limit >> 8) & 3);
 			return -EINVAL;
 		}
@@ -150,19 +151,19 @@ int __init amd_numa_init(void)
 			continue;
 		}
 		if (limit < base) {
-			pr_err("Node %d bogus settings %lx-%lx.\n",
+			pr_err("Node %d bogus settings %Lx-%Lx.\n",
 			       nodeid, base, limit);
 			continue;
 		}
 
 		/* Could sort here, but pun for now. Should not happen anyroads. */
 		if (prevbase > base) {
-			pr_err("Node map not sorted %lx,%lx\n",
+			pr_err("Node map not sorted %Lx,%Lx\n",
 			       prevbase, base);
 			return -EINVAL;
 		}
 
-		pr_info("Node %d MemBase %016lx Limit %016lx\n",
+		pr_info("Node %d MemBase %016Lx Limit %016Lx\n",
 			nodeid, base, limit);
 
 		prevbase = base;
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 80088f9..29f7c6d 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -678,8 +678,10 @@ static void __init zone_sizes_init(void)
 {
 	unsigned long max_zone_pfns[MAX_NR_ZONES];
 	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
+#ifdef CONFIG_ZONE_DMA
 	max_zone_pfns[ZONE_DMA] =
 		virt_to_phys((char *)MAX_DMA_ADDRESS) >> PAGE_SHIFT;
+#endif
 	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
 #ifdef CONFIG_HIGHMEM
 	max_zone_pfns[ZONE_HIGHMEM] = highend_pfn;
@@ -716,6 +718,7 @@ void __init paging_init(void)
 	 * NOTE: at this point the bootmem allocator is fully available.
 	 */
 	olpc_dt_build_devicetree();
+	sparse_memory_present_with_active_regions(MAX_NUMNODES);
 	sparse_init();
 	zone_sizes_init();
 }
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 7942335..d865c4a 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -616,7 +616,9 @@ void __init paging_init(void)
 	unsigned long max_zone_pfns[MAX_NR_ZONES];
 
 	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
+#ifdef CONFIG_ZONE_DMA
 	max_zone_pfns[ZONE_DMA] = MAX_DMA_PFN;
+#endif
 	max_zone_pfns[ZONE_DMA32] = MAX_DMA32_PFN;
 	max_zone_pfns[ZONE_NORMAL] = max_pfn;
 
@@ -679,14 +681,6 @@ int arch_add_memory(int nid, u64 start, u64 size)
 }
 EXPORT_SYMBOL_GPL(arch_add_memory);
 
-#if !defined(CONFIG_ACPI_NUMA) && defined(CONFIG_NUMA)
-int memory_add_physaddr_to_nid(u64 start)
-{
-	return 0;
-}
-EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
-#endif
-
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
 static struct kcore_list kcore_vsyscall;
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 0369843..be1ef57 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -91,13 +91,6 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 		return (__force void __iomem *)phys_to_virt(phys_addr);
 
 	/*
-	 * Check if the request spans more than any BAR in the iomem resource
-	 * tree.
-	 */
-	WARN_ONCE(iomem_map_sanity_check(phys_addr, size),
-		  KERN_INFO "Info: mapping multiple BARs. Your kernel is fine.");
-
-	/*
 	 * Don't allow anybody to remap normal RAM that we're using..
 	 */
 	last_pfn = last_addr >> PAGE_SHIFT;
@@ -170,6 +163,13 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 	ret_addr = (void __iomem *) (vaddr + offset);
 	mmiotrace_ioremap(unaligned_phys_addr, unaligned_size, ret_addr);
 
+	/*
+	 * Check if the request spans more than any BAR in the iomem resource
+	 * tree.
+	 */
+	WARN_ONCE(iomem_map_sanity_check(unaligned_phys_addr, unaligned_size),
+		  KERN_INFO "Info: mapping multiple BARs. Your kernel is fine.");
+
 	return ret_addr;
 err_free_area:
 	free_vm_area(area);
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 745258d..f5510d8 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -1,11 +1,39 @@
 /* Common code for 32 and 64-bit NUMA */
-#include <linux/topology.h>
-#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/string.h>
+#include <linux/init.h>
 #include <linux/bootmem.h>
-#include <asm/numa.h>
+#include <linux/memblock.h>
+#include <linux/mmzone.h>
+#include <linux/ctype.h>
+#include <linux/module.h>
+#include <linux/nodemask.h>
+#include <linux/sched.h>
+#include <linux/topology.h>
+
+#include <asm/e820.h>
+#include <asm/proto.h>
+#include <asm/dma.h>
 #include <asm/acpi.h>
+#include <asm/amd_nb.h>
+
+#include "numa_internal.h"
 
 int __initdata numa_off;
+nodemask_t numa_nodes_parsed __initdata;
+
+struct pglist_data *node_data[MAX_NUMNODES] __read_mostly;
+EXPORT_SYMBOL(node_data);
+
+static struct numa_meminfo numa_meminfo
+#ifndef CONFIG_MEMORY_HOTPLUG
+__initdata
+#endif
+;
+
+static int numa_distance_cnt;
+static u8 *numa_distance;
 
 static __init int numa_setup(char *opt)
 {
@@ -32,6 +60,15 @@ s16 __apicid_to_node[MAX_LOCAL_APIC] __cpuinitdata = {
 	[0 ... MAX_LOCAL_APIC-1] = NUMA_NO_NODE
 };
 
+int __cpuinit numa_cpu_node(int cpu)
+{
+	int apicid = early_per_cpu(x86_cpu_to_apicid, cpu);
+
+	if (apicid != BAD_APICID)
+		return __apicid_to_node[apicid];
+	return NUMA_NO_NODE;
+}
+
 cpumask_var_t node_to_cpumask_map[MAX_NUMNODES];
 EXPORT_SYMBOL(node_to_cpumask_map);
 
@@ -95,6 +132,407 @@ void __init setup_node_to_cpumask_map(void)
 	pr_debug("Node to cpumask map for %d nodes\n", nr_node_ids);
 }
 
+static int __init numa_add_memblk_to(int nid, u64 start, u64 end,
+				     struct numa_meminfo *mi)
+{
+	/* ignore zero length blks */
+	if (start == end)
+		return 0;
+
+	/* whine about and ignore invalid blks */
+	if (start > end || nid < 0 || nid >= MAX_NUMNODES) {
+		pr_warning("NUMA: Warning: invalid memblk node %d (%Lx-%Lx)\n",
+			   nid, start, end);
+		return 0;
+	}
+
+	if (mi->nr_blks >= NR_NODE_MEMBLKS) {
+		pr_err("NUMA: too many memblk ranges\n");
+		return -EINVAL;
+	}
+
+	mi->blk[mi->nr_blks].start = start;
+	mi->blk[mi->nr_blks].end = end;
+	mi->blk[mi->nr_blks].nid = nid;
+	mi->nr_blks++;
+	return 0;
+}
+
+/**
+ * numa_remove_memblk_from - Remove one numa_memblk from a numa_meminfo
+ * @idx: Index of memblk to remove
+ * @mi: numa_meminfo to remove memblk from
+ *
+ * Remove @idx'th numa_memblk from @mi by shifting @mi->blk[] and
+ * decrementing @mi->nr_blks.
+ */
+void __init numa_remove_memblk_from(int idx, struct numa_meminfo *mi)
+{
+	mi->nr_blks--;
+	memmove(&mi->blk[idx], &mi->blk[idx + 1],
+		(mi->nr_blks - idx) * sizeof(mi->blk[0]));
+}
+
+/**
+ * numa_add_memblk - Add one numa_memblk to numa_meminfo
+ * @nid: NUMA node ID of the new memblk
+ * @start: Start address of the new memblk
+ * @end: End address of the new memblk
+ *
+ * Add a new memblk to the default numa_meminfo.
+ *
+ * RETURNS:
+ * 0 on success, -errno on failure.
+ */
+int __init numa_add_memblk(int nid, u64 start, u64 end)
+{
+	return numa_add_memblk_to(nid, start, end, &numa_meminfo);
+}
+
+/* Initialize NODE_DATA for a node on the local memory */
+static void __init setup_node_data(int nid, u64 start, u64 end)
+{
+	const u64 nd_low = PFN_PHYS(MAX_DMA_PFN);
+	const u64 nd_high = PFN_PHYS(max_pfn_mapped);
+	const size_t nd_size = roundup(sizeof(pg_data_t), PAGE_SIZE);
+	bool remapped = false;
+	u64 nd_pa;
+	void *nd;
+	int tnid;
+
+	/*
+	 * Don't confuse VM with a node that doesn't have the
+	 * minimum amount of memory:
+	 */
+	if (end && (end - start) < NODE_MIN_SIZE)
+		return;
+
+	/* initialize remap allocator before aligning to ZONE_ALIGN */
+	init_alloc_remap(nid, start, end);
+
+	start = roundup(start, ZONE_ALIGN);
+
+	printk(KERN_INFO "Initmem setup node %d %016Lx-%016Lx\n",
+	       nid, start, end);
+
+	/*
+	 * Allocate node data.  Try remap allocator first, node-local
+	 * memory and then any node.  Never allocate in DMA zone.
+	 */
+	nd = alloc_remap(nid, nd_size);
+	if (nd) {
+		nd_pa = __pa(nd);
+		remapped = true;
+	} else {
+		nd_pa = memblock_x86_find_in_range_node(nid, nd_low, nd_high,
+						nd_size, SMP_CACHE_BYTES);
+		if (nd_pa == MEMBLOCK_ERROR)
+			nd_pa = memblock_find_in_range(nd_low, nd_high,
+						nd_size, SMP_CACHE_BYTES);
+		if (nd_pa == MEMBLOCK_ERROR) {
+			pr_err("Cannot find %zu bytes in node %d\n",
+			       nd_size, nid);
+			return;
+		}
+		memblock_x86_reserve_range(nd_pa, nd_pa + nd_size, "NODE_DATA");
+		nd = __va(nd_pa);
+	}
+
+	/* report and initialize */
+	printk(KERN_INFO "  NODE_DATA [%016Lx - %016Lx]%s\n",
+	       nd_pa, nd_pa + nd_size - 1, remapped ? " (remapped)" : "");
+	tnid = early_pfn_to_nid(nd_pa >> PAGE_SHIFT);
+	if (!remapped && tnid != nid)
+		printk(KERN_INFO "    NODE_DATA(%d) on node %d\n", nid, tnid);
+
+	node_data[nid] = nd;
+	memset(NODE_DATA(nid), 0, sizeof(pg_data_t));
+	NODE_DATA(nid)->node_id = nid;
+	NODE_DATA(nid)->node_start_pfn = start >> PAGE_SHIFT;
+	NODE_DATA(nid)->node_spanned_pages = (end - start) >> PAGE_SHIFT;
+
+	node_set_online(nid);
+}
+
+/**
+ * numa_cleanup_meminfo - Cleanup a numa_meminfo
+ * @mi: numa_meminfo to clean up
+ *
+ * Sanitize @mi by merging and removing unncessary memblks.  Also check for
+ * conflicts and clear unused memblks.
+ *
+ * RETURNS:
+ * 0 on success, -errno on failure.
+ */
+int __init numa_cleanup_meminfo(struct numa_meminfo *mi)
+{
+	const u64 low = 0;
+	const u64 high = PFN_PHYS(max_pfn);
+	int i, j, k;
+
+	/* first, trim all entries */
+	for (i = 0; i < mi->nr_blks; i++) {
+		struct numa_memblk *bi = &mi->blk[i];
+
+		/* make sure all blocks are inside the limits */
+		bi->start = max(bi->start, low);
+		bi->end = min(bi->end, high);
+
+		/* and there's no empty block */
+		if (bi->start >= bi->end)
+			numa_remove_memblk_from(i--, mi);
+	}
+
+	/* merge neighboring / overlapping entries */
+	for (i = 0; i < mi->nr_blks; i++) {
+		struct numa_memblk *bi = &mi->blk[i];
+
+		for (j = i + 1; j < mi->nr_blks; j++) {
+			struct numa_memblk *bj = &mi->blk[j];
+			u64 start, end;
+
+			/*
+			 * See whether there are overlapping blocks.  Whine
+			 * about but allow overlaps of the same nid.  They
+			 * will be merged below.
+			 */
+			if (bi->end > bj->start && bi->start < bj->end) {
+				if (bi->nid != bj->nid) {
+					pr_err("NUMA: node %d (%Lx-%Lx) overlaps with node %d (%Lx-%Lx)\n",
+					       bi->nid, bi->start, bi->end,
+					       bj->nid, bj->start, bj->end);
+					return -EINVAL;
+				}
+				pr_warning("NUMA: Warning: node %d (%Lx-%Lx) overlaps with itself (%Lx-%Lx)\n",
+					   bi->nid, bi->start, bi->end,
+					   bj->start, bj->end);
+			}
+
+			/*
+			 * Join together blocks on the same node, holes
+			 * between which don't overlap with memory on other
+			 * nodes.
+			 */
+			if (bi->nid != bj->nid)
+				continue;
+			start = min(bi->start, bj->start);
+			end = max(bi->end, bj->end);
+			for (k = 0; k < mi->nr_blks; k++) {
+				struct numa_memblk *bk = &mi->blk[k];
+
+				if (bi->nid == bk->nid)
+					continue;
+				if (start < bk->end && end > bk->start)
+					break;
+			}
+			if (k < mi->nr_blks)
+				continue;
+			printk(KERN_INFO "NUMA: Node %d [%Lx,%Lx) + [%Lx,%Lx) -> [%Lx,%Lx)\n",
+			       bi->nid, bi->start, bi->end, bj->start, bj->end,
+			       start, end);
+			bi->start = start;
+			bi->end = end;
+			numa_remove_memblk_from(j--, mi);
+		}
+	}
+
+	/* clear unused ones */
+	for (i = mi->nr_blks; i < ARRAY_SIZE(mi->blk); i++) {
+		mi->blk[i].start = mi->blk[i].end = 0;
+		mi->blk[i].nid = NUMA_NO_NODE;
+	}
+
+	return 0;
+}
+
+/*
+ * Set nodes, which have memory in @mi, in *@nodemask.
+ */
+static void __init numa_nodemask_from_meminfo(nodemask_t *nodemask,
+					      const struct numa_meminfo *mi)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(mi->blk); i++)
+		if (mi->blk[i].start != mi->blk[i].end &&
+		    mi->blk[i].nid != NUMA_NO_NODE)
+			node_set(mi->blk[i].nid, *nodemask);
+}
+
+/**
+ * numa_reset_distance - Reset NUMA distance table
+ *
+ * The current table is freed.  The next numa_set_distance() call will
+ * create a new one.
+ */
+void __init numa_reset_distance(void)
+{
+	size_t size = numa_distance_cnt * numa_distance_cnt * sizeof(numa_distance[0]);
+
+	/* numa_distance could be 1LU marking allocation failure, test cnt */
+	if (numa_distance_cnt)
+		memblock_x86_free_range(__pa(numa_distance),
+					__pa(numa_distance) + size);
+	numa_distance_cnt = 0;
+	numa_distance = NULL;	/* enable table creation */
+}
+
+static int __init numa_alloc_distance(void)
+{
+	nodemask_t nodes_parsed;
+	size_t size;
+	int i, j, cnt = 0;
+	u64 phys;
+
+	/* size the new table and allocate it */
+	nodes_parsed = numa_nodes_parsed;
+	numa_nodemask_from_meminfo(&nodes_parsed, &numa_meminfo);
+
+	for_each_node_mask(i, nodes_parsed)
+		cnt = i;
+	cnt++;
+	size = cnt * cnt * sizeof(numa_distance[0]);
+
+	phys = memblock_find_in_range(0, PFN_PHYS(max_pfn_mapped),
+				      size, PAGE_SIZE);
+	if (phys == MEMBLOCK_ERROR) {
+		pr_warning("NUMA: Warning: can't allocate distance table!\n");
+		/* don't retry until explicitly reset */
+		numa_distance = (void *)1LU;
+		return -ENOMEM;
+	}
+	memblock_x86_reserve_range(phys, phys + size, "NUMA DIST");
+
+	numa_distance = __va(phys);
+	numa_distance_cnt = cnt;
+
+	/* fill with the default distances */
+	for (i = 0; i < cnt; i++)
+		for (j = 0; j < cnt; j++)
+			numa_distance[i * cnt + j] = i == j ?
+				LOCAL_DISTANCE : REMOTE_DISTANCE;
+	printk(KERN_DEBUG "NUMA: Initialized distance table, cnt=%d\n", cnt);
+
+	return 0;
+}
+
+/**
+ * numa_set_distance - Set NUMA distance from one NUMA to another
+ * @from: the 'from' node to set distance
+ * @to: the 'to'  node to set distance
+ * @distance: NUMA distance
+ *
+ * Set the distance from node @from to @to to @distance.  If distance table
+ * doesn't exist, one which is large enough to accommodate all the currently
+ * known nodes will be created.
+ *
+ * If such table cannot be allocated, a warning is printed and further
+ * calls are ignored until the distance table is reset with
+ * numa_reset_distance().
+ *
+ * If @from or @to is higher than the highest known node at the time of
+ * table creation or @distance doesn't make sense, the call is ignored.
+ * This is to allow simplification of specific NUMA config implementations.
+ */
+void __init numa_set_distance(int from, int to, int distance)
+{
+	if (!numa_distance && numa_alloc_distance() < 0)
+		return;
+
+	if (from >= numa_distance_cnt || to >= numa_distance_cnt) {
+		printk_once(KERN_DEBUG "NUMA: Debug: distance out of bound, from=%d to=%d distance=%d\n",
+			    from, to, distance);
+		return;
+	}
+
+	if ((u8)distance != distance ||
+	    (from == to && distance != LOCAL_DISTANCE)) {
+		pr_warn_once("NUMA: Warning: invalid distance parameter, from=%d to=%d distance=%d\n",
+			     from, to, distance);
+		return;
+	}
+
+	numa_distance[from * numa_distance_cnt + to] = distance;
+}
+
+int __node_distance(int from, int to)
+{
+	if (from >= numa_distance_cnt || to >= numa_distance_cnt)
+		return from == to ? LOCAL_DISTANCE : REMOTE_DISTANCE;
+	return numa_distance[from * numa_distance_cnt + to];
+}
+EXPORT_SYMBOL(__node_distance);
+
+/*
+ * Sanity check to catch more bad NUMA configurations (they are amazingly
+ * common).  Make sure the nodes cover all memory.
+ */
+static bool __init numa_meminfo_cover_memory(const struct numa_meminfo *mi)
+{
+	u64 numaram, e820ram;
+	int i;
+
+	numaram = 0;
+	for (i = 0; i < mi->nr_blks; i++) {
+		u64 s = mi->blk[i].start >> PAGE_SHIFT;
+		u64 e = mi->blk[i].end >> PAGE_SHIFT;
+		numaram += e - s;
+		numaram -= __absent_pages_in_range(mi->blk[i].nid, s, e);
+		if ((s64)numaram < 0)
+			numaram = 0;
+	}
+
+	e820ram = max_pfn - (memblock_x86_hole_size(0,
+					PFN_PHYS(max_pfn)) >> PAGE_SHIFT);
+	/* We seem to lose 3 pages somewhere. Allow 1M of slack. */
+	if ((s64)(e820ram - numaram) >= (1 << (20 - PAGE_SHIFT))) {
+		printk(KERN_ERR "NUMA: nodes only cover %LuMB of your %LuMB e820 RAM. Not used.\n",
+		       (numaram << PAGE_SHIFT) >> 20,
+		       (e820ram << PAGE_SHIFT) >> 20);
+		return false;
+	}
+	return true;
+}
+
+static int __init numa_register_memblks(struct numa_meminfo *mi)
+{
+	int i, nid;
+
+	/* Account for nodes with cpus and no memory */
+	node_possible_map = numa_nodes_parsed;
+	numa_nodemask_from_meminfo(&node_possible_map, mi);
+	if (WARN_ON(nodes_empty(node_possible_map)))
+		return -EINVAL;
+
+	for (i = 0; i < mi->nr_blks; i++)
+		memblock_x86_register_active_regions(mi->blk[i].nid,
+					mi->blk[i].start >> PAGE_SHIFT,
+					mi->blk[i].end >> PAGE_SHIFT);
+
+	/* for out of order entries */
+	sort_node_map();
+	if (!numa_meminfo_cover_memory(mi))
+		return -EINVAL;
+
+	/* Finally register nodes. */
+	for_each_node_mask(nid, node_possible_map) {
+		u64 start = PFN_PHYS(max_pfn);
+		u64 end = 0;
+
+		for (i = 0; i < mi->nr_blks; i++) {
+			if (nid != mi->blk[i].nid)
+				continue;
+			start = min(mi->blk[i].start, start);
+			end = max(mi->blk[i].end, end);
+		}
+
+		if (start < end)
+			setup_node_data(nid, start, end);
+	}
+
+	return 0;
+}
+
 /*
  * There are unfortunately some poorly designed mainboards around that
  * only connect memory to a single CPU. This breaks the 1:1 cpu->node
@@ -102,7 +540,7 @@ void __init setup_node_to_cpumask_map(void)
  * as the number of CPUs is not known yet. We round robin the existing
  * nodes.
  */
-void __init numa_init_array(void)
+static void __init numa_init_array(void)
 {
 	int rr, i;
 
@@ -117,6 +555,95 @@ void __init numa_init_array(void)
 	}
 }
 
+static int __init numa_init(int (*init_func)(void))
+{
+	int i;
+	int ret;
+
+	for (i = 0; i < MAX_LOCAL_APIC; i++)
+		set_apicid_to_node(i, NUMA_NO_NODE);
+
+	nodes_clear(numa_nodes_parsed);
+	nodes_clear(node_possible_map);
+	nodes_clear(node_online_map);
+	memset(&numa_meminfo, 0, sizeof(numa_meminfo));
+	remove_all_active_ranges();
+	numa_reset_distance();
+
+	ret = init_func();
+	if (ret < 0)
+		return ret;
+	ret = numa_cleanup_meminfo(&numa_meminfo);
+	if (ret < 0)
+		return ret;
+
+	numa_emulation(&numa_meminfo, numa_distance_cnt);
+
+	ret = numa_register_memblks(&numa_meminfo);
+	if (ret < 0)
+		return ret;
+
+	for (i = 0; i < nr_cpu_ids; i++) {
+		int nid = early_cpu_to_node(i);
+
+		if (nid == NUMA_NO_NODE)
+			continue;
+		if (!node_online(nid))
+			numa_clear_node(i);
+	}
+	numa_init_array();
+	return 0;
+}
+
+/**
+ * dummy_numa_init - Fallback dummy NUMA init
+ *
+ * Used if there's no underlying NUMA architecture, NUMA initialization
+ * fails, or NUMA is disabled on the command line.
+ *
+ * Must online at least one node and add memory blocks that cover all
+ * allowed memory.  This function must not fail.
+ */
+static int __init dummy_numa_init(void)
+{
+	printk(KERN_INFO "%s\n",
+	       numa_off ? "NUMA turned off" : "No NUMA configuration found");
+	printk(KERN_INFO "Faking a node at %016Lx-%016Lx\n",
+	       0LLU, PFN_PHYS(max_pfn));
+
+	node_set(0, numa_nodes_parsed);
+	numa_add_memblk(0, 0, PFN_PHYS(max_pfn));
+
+	return 0;
+}
+
+/**
+ * x86_numa_init - Initialize NUMA
+ *
+ * Try each configured NUMA initialization method until one succeeds.  The
+ * last fallback is dummy single node config encomapssing whole memory and
+ * never fails.
+ */
+void __init x86_numa_init(void)
+{
+	if (!numa_off) {
+#ifdef CONFIG_X86_NUMAQ
+		if (!numa_init(numaq_numa_init))
+			return;
+#endif
+#ifdef CONFIG_ACPI_NUMA
+		if (!numa_init(x86_acpi_numa_init))
+			return;
+#endif
+#ifdef CONFIG_AMD_NUMA
+		if (!numa_init(amd_numa_init))
+			return;
+#endif
+	}
+
+	numa_init(dummy_numa_init);
+}
+
 static __init int find_near_online_node(int node)
 {
 	int n, val;
@@ -282,3 +809,18 @@ const struct cpumask *cpumask_of_node(int node)
 EXPORT_SYMBOL(cpumask_of_node);
 
 #endif	/* !CONFIG_DEBUG_PER_CPU_MAPS */
+
+#ifdef CONFIG_MEMORY_HOTPLUG
+int memory_add_physaddr_to_nid(u64 start)
+{
+	struct numa_meminfo *mi = &numa_meminfo;
+	int nid = mi->blk[0].nid;
+	int i;
+
+	for (i = 0; i < mi->nr_blks; i++)
+		if (mi->blk[i].start <= start && mi->blk[i].end > start)
+			nid = mi->blk[i].nid;
+	return nid;
+}
+EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
+#endif
diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index bde3906..849a975 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -22,39 +22,11 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/mm.h>
 #include <linux/bootmem.h>
 #include <linux/memblock.h>
-#include <linux/mmzone.h>
-#include <linux/highmem.h>
-#include <linux/initrd.h>
-#include <linux/nodemask.h>
 #include <linux/module.h>
-#include <linux/kexec.h>
-#include <linux/pfn.h>
-#include <linux/swap.h>
-#include <linux/acpi.h>
-
-#include <asm/e820.h>
-#include <asm/setup.h>
-#include <asm/mmzone.h>
-#include <asm/bios_ebda.h>
-#include <asm/proto.h>
-
-struct pglist_data *node_data[MAX_NUMNODES] __read_mostly;
-EXPORT_SYMBOL(node_data);
-
-/*
- * numa interface - we expect the numa architecture specific code to have
- *                  populated the following initialisation.
- *
- * 1) node_online_map  - the map of all nodes configured (online) in the system
- * 2) node_start_pfn   - the starting page frame number for a node
- * 3) node_end_pfn     - the ending page fram number for a node
- */
-unsigned long node_start_pfn[MAX_NUMNODES] __read_mostly;
-unsigned long node_end_pfn[MAX_NUMNODES] __read_mostly;
 
+#include "numa_internal.h"
 
 #ifdef CONFIG_DISCONTIGMEM
 /*
@@ -99,108 +71,46 @@ unsigned long node_memmap_size_bytes(int nid, unsigned long start_pfn,
 }
 #endif
 
-extern unsigned long find_max_low_pfn(void);
 extern unsigned long highend_pfn, highstart_pfn;
 
 #define LARGE_PAGE_BYTES (PTRS_PER_PTE * PAGE_SIZE)
 
-unsigned long node_remap_size[MAX_NUMNODES];
 static void *node_remap_start_vaddr[MAX_NUMNODES];
 void set_pmd_pfn(unsigned long vaddr, unsigned long pfn, pgprot_t flags);
 
-static unsigned long kva_start_pfn;
-static unsigned long kva_pages;
-
-int __cpuinit numa_cpu_node(int cpu)
-{
-	return apic->x86_32_numa_cpu_node(cpu);
-}
-
-/*
- * FLAT - support for basic PC memory model with discontig enabled, essentially
- *        a single node with all available processors in it with a flat
- *        memory map.
- */
-int __init get_memcfg_numa_flat(void)
-{
-	printk(KERN_DEBUG "NUMA - single node, flat memory mode\n");
-
-	node_start_pfn[0] = 0;
-	node_end_pfn[0] = max_pfn;
-	memblock_x86_register_active_regions(0, 0, max_pfn);
-	memory_present(0, 0, max_pfn);
-	node_remap_size[0] = node_memmap_size_bytes(0, 0, max_pfn);
-
-        /* Indicate there is one node available. */
-	nodes_clear(node_online_map);
-	node_set_online(0);
-	return 1;
-}
-
-/*
- * Find the highest page frame number we have available for the node
- */
-static void __init propagate_e820_map_node(int nid)
-{
-	if (node_end_pfn[nid] > max_pfn)
-		node_end_pfn[nid] = max_pfn;
-	/*
-	 * if a user has given mem=XXXX, then we need to make sure 
-	 * that the node _starts_ before that, too, not just ends
-	 */
-	if (node_start_pfn[nid] > max_pfn)
-		node_start_pfn[nid] = max_pfn;
-	BUG_ON(node_start_pfn[nid] > node_end_pfn[nid]);
-}
-
-/* 
- * Allocate memory for the pg_data_t for this node via a crude pre-bootmem
- * method.  For node zero take this from the bottom of memory, for
- * subsequent nodes place them at node_remap_start_vaddr which contains
- * node local data in physically node local memory.  See setup_memory()
- * for details.
- */
-static void __init allocate_pgdat(int nid)
-{
-	char buf[16];
-
-	if (node_has_online_mem(nid) && node_remap_start_vaddr[nid])
-		NODE_DATA(nid) = (pg_data_t *)node_remap_start_vaddr[nid];
-	else {
-		unsigned long pgdat_phys;
-		pgdat_phys = memblock_find_in_range(min_low_pfn<<PAGE_SHIFT,
-				 max_pfn_mapped<<PAGE_SHIFT,
-				 sizeof(pg_data_t),
-				 PAGE_SIZE);
-		NODE_DATA(nid) = (pg_data_t *)(pfn_to_kaddr(pgdat_phys>>PAGE_SHIFT));
-		memset(buf, 0, sizeof(buf));
-		sprintf(buf, "NODE_DATA %d",  nid);
-		memblock_x86_reserve_range(pgdat_phys, pgdat_phys + sizeof(pg_data_t), buf);
-	}
-	printk(KERN_DEBUG "allocate_pgdat: node %d NODE_DATA %08lx\n",
-		nid, (unsigned long)NODE_DATA(nid));
-}
-
 /*
- * In the DISCONTIGMEM and SPARSEMEM memory model, a portion of the kernel
- * virtual address space (KVA) is reserved and portions of nodes are mapped
- * using it. This is to allow node-local memory to be allocated for
- * structures that would normally require ZONE_NORMAL. The memory is
- * allocated with alloc_remap() and callers should be prepared to allocate
- * from the bootmem allocator instead.
+ * Remap memory allocator
  */
 static unsigned long node_remap_start_pfn[MAX_NUMNODES];
 static void *node_remap_end_vaddr[MAX_NUMNODES];
 static void *node_remap_alloc_vaddr[MAX_NUMNODES];
-static unsigned long node_remap_offset[MAX_NUMNODES];
 
+/**
+ * alloc_remap - Allocate remapped memory
+ * @nid: NUMA node to allocate memory from
+ * @size: The size of allocation
+ *
+ * Allocate @size bytes from the remap area of NUMA node @nid.  The
+ * size of the remap area is predetermined by init_alloc_remap() and
+ * only the callers considered there should call this function.  For
+ * more info, please read the comment on top of init_alloc_remap().
+ *
+ * The caller must be ready to handle allocation failure from this
+ * function and fall back to regular memory allocator in such cases.
+ *
+ * CONTEXT:
+ * Single CPU early boot context.
+ *
+ * RETURNS:
+ * Pointer to the allocated memory on success, %NULL on failure.
+ */
 void *alloc_remap(int nid, unsigned long size)
 {
 	void *allocation = node_remap_alloc_vaddr[nid];
 
 	size = ALIGN(size, L1_CACHE_BYTES);
 
-	if (!allocation || (allocation + size) >= node_remap_end_vaddr[nid])
+	if (!allocation || (allocation + size) > node_remap_end_vaddr[nid])
 		return NULL;
 
 	node_remap_alloc_vaddr[nid] += size;
@@ -209,26 +119,6 @@ void *alloc_remap(int nid, unsigned long size)
 	return allocation;
 }
 
-static void __init remap_numa_kva(void)
-{
-	void *vaddr;
-	unsigned long pfn;
-	int node;
-
-	for_each_online_node(node) {
-		printk(KERN_DEBUG "remap_numa_kva: node %d\n", node);
-		for (pfn=0; pfn < node_remap_size[node]; pfn += PTRS_PER_PTE) {
-			vaddr = node_remap_start_vaddr[node]+(pfn<<PAGE_SHIFT);
-			printk(KERN_DEBUG "remap_numa_kva: %08lx to pfn %08lx\n",
-				(unsigned long)vaddr,
-				node_remap_start_pfn[node] + pfn);
-			set_pmd_pfn((ulong) vaddr, 
-				node_remap_start_pfn[node] + pfn, 
-				PAGE_KERNEL_LARGE);
-		}
-	}
-}
-
 #ifdef CONFIG_HIBERNATION
 /**
  * resume_map_numa_kva - add KVA mapping to the temporary page tables created
@@ -240,15 +130,16 @@ void resume_map_numa_kva(pgd_t *pgd_base)
 	int node;
 
 	for_each_online_node(node) {
-		unsigned long start_va, start_pfn, size, pfn;
+		unsigned long start_va, start_pfn, nr_pages, pfn;
 
 		start_va = (unsigned long)node_remap_start_vaddr[node];
 		start_pfn = node_remap_start_pfn[node];
-		size = node_remap_size[node];
+		nr_pages = (node_remap_end_vaddr[node] -
+			    node_remap_start_vaddr[node]) >> PAGE_SHIFT;
 
 		printk(KERN_DEBUG "%s: node %d\n", __func__, node);
 
-		for (pfn = 0; pfn < size; pfn += PTRS_PER_PTE) {
+		for (pfn = 0; pfn < nr_pages; pfn += PTRS_PER_PTE) {
 			unsigned long vaddr = start_va + (pfn << PAGE_SHIFT);
 			pgd_t *pgd = pgd_base + pgd_index(vaddr);
 			pud_t *pud = pud_offset(pgd, vaddr);
@@ -264,132 +155,89 @@ void resume_map_numa_kva(pgd_t *pgd_base)
 }
 #endif
 
-static __init unsigned long calculate_numa_remap_pages(void)
+/**
+ * init_alloc_remap - Initialize remap allocator for a NUMA node
+ * @nid: NUMA node to initizlie remap allocator for
+ *
+ * NUMA nodes may end up without any lowmem.  As allocating pgdat and
+ * memmap on a different node with lowmem is inefficient, a special
+ * remap allocator is implemented which can be used by alloc_remap().
+ *
+ * For each node, the amount of memory which will be necessary for
+ * pgdat and memmap is calculated and two memory areas of the size are
+ * allocated - one in the node and the other in lowmem; then, the area
+ * in the node is remapped to the lowmem area.
+ *
+ * As pgdat and memmap must be allocated in lowmem anyway, this
+ * doesn't waste lowmem address space; however, the actual lowmem
+ * which gets remapped over is wasted.  The amount shouldn't be
+ * problematic on machines this feature will be used.
+ *
+ * Initialization failure isn't fatal.  alloc_remap() is used
+ * opportunistically and the callers will fall back to other memory
+ * allocation mechanisms on failure.
+ */
+void __init init_alloc_remap(int nid, u64 start, u64 end)
 {
-	int nid;
-	unsigned long size, reserve_pages = 0;
-
-	for_each_online_node(nid) {
-		u64 node_kva_target;
-		u64 node_kva_final;
-
-		/*
-		 * The acpi/srat node info can show hot-add memroy zones
-		 * where memory could be added but not currently present.
-		 */
-		printk(KERN_DEBUG "node %d pfn: [%lx - %lx]\n",
-			nid, node_start_pfn[nid], node_end_pfn[nid]);
-		if (node_start_pfn[nid] > max_pfn)
-			continue;
-		if (!node_end_pfn[nid])
-			continue;
-		if (node_end_pfn[nid] > max_pfn)
-			node_end_pfn[nid] = max_pfn;
-
-		/* ensure the remap includes space for the pgdat. */
-		size = node_remap_size[nid] + sizeof(pg_data_t);
-
-		/* convert size to large (pmd size) pages, rounding up */
-		size = (size + LARGE_PAGE_BYTES - 1) / LARGE_PAGE_BYTES;
-		/* now the roundup is correct, convert to PAGE_SIZE pages */
-		size = size * PTRS_PER_PTE;
-
-		node_kva_target = round_down(node_end_pfn[nid] - size,
-						 PTRS_PER_PTE);
-		node_kva_target <<= PAGE_SHIFT;
-		do {
-			node_kva_final = memblock_find_in_range(node_kva_target,
-					((u64)node_end_pfn[nid])<<PAGE_SHIFT,
-						((u64)size)<<PAGE_SHIFT,
-						LARGE_PAGE_BYTES);
-			node_kva_target -= LARGE_PAGE_BYTES;
-		} while (node_kva_final == MEMBLOCK_ERROR &&
-			 (node_kva_target>>PAGE_SHIFT) > (node_start_pfn[nid]));
-
-		if (node_kva_final == MEMBLOCK_ERROR)
-			panic("Can not get kva ram\n");
-
-		node_remap_size[nid] = size;
-		node_remap_offset[nid] = reserve_pages;
-		reserve_pages += size;
-		printk(KERN_DEBUG "Reserving %ld pages of KVA for lmem_map of"
-				  " node %d at %llx\n",
-				size, nid, node_kva_final>>PAGE_SHIFT);
-
-		/*
-		 *  prevent kva address below max_low_pfn want it on system
-		 *  with less memory later.
-		 *  layout will be: KVA address , KVA RAM
-		 *
-		 *  we are supposed to only record the one less then max_low_pfn
-		 *  but we could have some hole in high memory, and it will only
-		 *  check page_is_ram(pfn) && !page_is_reserved_early(pfn) to decide
-		 *  to use it as free.
-		 *  So memblock_x86_reserve_range here, hope we don't run out of that array
-		 */
-		memblock_x86_reserve_range(node_kva_final,
-			      node_kva_final+(((u64)size)<<PAGE_SHIFT),
-			      "KVA RAM");
-
-		node_remap_start_pfn[nid] = node_kva_final>>PAGE_SHIFT;
-	}
-	printk(KERN_INFO "Reserving total of %lx pages for numa KVA remap\n",
-			reserve_pages);
-	return reserve_pages;
-}
+	unsigned long start_pfn = start >> PAGE_SHIFT;
+	unsigned long end_pfn = end >> PAGE_SHIFT;
+	unsigned long size, pfn;
+	u64 node_pa, remap_pa;
+	void *remap_va;
 
-static void init_remap_allocator(int nid)
-{
-	node_remap_start_vaddr[nid] = pfn_to_kaddr(
-			kva_start_pfn + node_remap_offset[nid]);
-	node_remap_end_vaddr[nid] = node_remap_start_vaddr[nid] +
-		(node_remap_size[nid] * PAGE_SIZE);
-	node_remap_alloc_vaddr[nid] = node_remap_start_vaddr[nid] +
-		ALIGN(sizeof(pg_data_t), PAGE_SIZE);
-
-	printk(KERN_DEBUG "node %d will remap to vaddr %08lx - %08lx\n", nid,
-		(ulong) node_remap_start_vaddr[nid],
-		(ulong) node_remap_end_vaddr[nid]);
+	/*
+	 * The acpi/srat node info can show hot-add memroy zones where
+	 * memory could be added but not currently present.
+	 */
+	printk(KERN_DEBUG "node %d pfn: [%lx - %lx]\n",
+	       nid, start_pfn, end_pfn);
+
+	/* calculate the necessary space aligned to large page size */
+	size = node_memmap_size_bytes(nid, start_pfn, end_pfn);
+	size += ALIGN(sizeof(pg_data_t), PAGE_SIZE);
+	size = ALIGN(size, LARGE_PAGE_BYTES);
+
+	/* allocate node memory and the lowmem remap area */
+	node_pa = memblock_find_in_range(start, end, size, LARGE_PAGE_BYTES);
+	if (node_pa == MEMBLOCK_ERROR) {
+		pr_warning("remap_alloc: failed to allocate %lu bytes for node %d\n",
+			   size, nid);
+		return;
+	}
+	memblock_x86_reserve_range(node_pa, node_pa + size, "KVA RAM");
+
+	remap_pa = memblock_find_in_range(min_low_pfn << PAGE_SHIFT,
+					  max_low_pfn << PAGE_SHIFT,
+					  size, LARGE_PAGE_BYTES);
+	if (remap_pa == MEMBLOCK_ERROR) {
+		pr_warning("remap_alloc: failed to allocate %lu bytes remap area for node %d\n",
+			   size, nid);
+		memblock_x86_free_range(node_pa, node_pa + size);
+		return;
+	}
+	memblock_x86_reserve_range(remap_pa, remap_pa + size, "KVA PG");
+	remap_va = phys_to_virt(remap_pa);
+
+	/* perform actual remap */
+	for (pfn = 0; pfn < size >> PAGE_SHIFT; pfn += PTRS_PER_PTE)
+		set_pmd_pfn((unsigned long)remap_va + (pfn << PAGE_SHIFT),
+			    (node_pa >> PAGE_SHIFT) + pfn,
+			    PAGE_KERNEL_LARGE);
+
+	/* initialize remap allocator parameters */
+	node_remap_start_pfn[nid] = node_pa >> PAGE_SHIFT;
+	node_remap_start_vaddr[nid] = remap_va;
+	node_remap_end_vaddr[nid] = remap_va + size;
+	node_remap_alloc_vaddr[nid] = remap_va;
+
+	printk(KERN_DEBUG "remap_alloc: node %d [%08llx-%08llx) -> [%p-%p)\n",
+	       nid, node_pa, node_pa + size, remap_va, remap_va + size);
 }
 
 void __init initmem_init(void)
 {
-	int nid;
-	long kva_target_pfn;
-
-	/*
-	 * When mapping a NUMA machine we allocate the node_mem_map arrays
-	 * from node local memory.  They are then mapped directly into KVA
-	 * between zone normal and vmalloc space.  Calculate the size of
-	 * this space and use it to adjust the boundary between ZONE_NORMAL
-	 * and ZONE_HIGHMEM.
-	 */
-
-	get_memcfg_numa();
-	numa_init_array();
-
-	kva_pages = roundup(calculate_numa_remap_pages(), PTRS_PER_PTE);
+	x86_numa_init();
 
-	kva_target_pfn = round_down(max_low_pfn - kva_pages, PTRS_PER_PTE);
-	do {
-		kva_start_pfn = memblock_find_in_range(kva_target_pfn<<PAGE_SHIFT,
-					max_low_pfn<<PAGE_SHIFT,
-					kva_pages<<PAGE_SHIFT,
-					PTRS_PER_PTE<<PAGE_SHIFT) >> PAGE_SHIFT;
-		kva_target_pfn -= PTRS_PER_PTE;
-	} while (kva_start_pfn == MEMBLOCK_ERROR && kva_target_pfn > min_low_pfn);
-
-	if (kva_start_pfn == MEMBLOCK_ERROR)
-		panic("Can not get kva space\n");
-
-	printk(KERN_INFO "kva_start_pfn ~ %lx max_low_pfn ~ %lx\n",
-		kva_start_pfn, max_low_pfn);
-	printk(KERN_INFO "max_pfn = %lx\n", max_pfn);
-
-	/* avoid clash with initrd */
-	memblock_x86_reserve_range(kva_start_pfn<<PAGE_SHIFT,
-		      (kva_start_pfn + kva_pages)<<PAGE_SHIFT,
-		     "KVA PG");
 #ifdef CONFIG_HIGHMEM
 	highstart_pfn = highend_pfn = max_pfn;
 	if (max_pfn > max_low_pfn)
@@ -409,51 +257,9 @@ void __init initmem_init(void)
 
 	printk(KERN_DEBUG "Low memory ends at vaddr %08lx\n",
 			(ulong) pfn_to_kaddr(max_low_pfn));
-	for_each_online_node(nid) {
-		init_remap_allocator(nid);
-
-		allocate_pgdat(nid);
-	}
-	remap_numa_kva();
 
 	printk(KERN_DEBUG "High memory starts at vaddr %08lx\n",
 			(ulong) pfn_to_kaddr(highstart_pfn));
-	for_each_online_node(nid)
-		propagate_e820_map_node(nid);
-
-	for_each_online_node(nid) {
-		memset(NODE_DATA(nid), 0, sizeof(struct pglist_data));
-		NODE_DATA(nid)->node_id = nid;
-	}
 
 	setup_bootmem_allocator();
 }
-
-#ifdef CONFIG_MEMORY_HOTPLUG
-static int paddr_to_nid(u64 addr)
-{
-	int nid;
-	unsigned long pfn = PFN_DOWN(addr);
-
-	for_each_node(nid)
-		if (node_start_pfn[nid] <= pfn &&
-		    pfn < node_end_pfn[nid])
-			return nid;
-
-	return -1;
-}
-
-/*
- * This function is used to ask node id BEFORE memmap and mem_section's
- * initialization (pfn_to_nid() can't be used yet).
- * If _PXM is not defined on ACPI's DSDT, node id must be found by this.
- */
-int memory_add_physaddr_to_nid(u64 addr)
-{
-	int nid = paddr_to_nid(addr);
-	return (nid >= 0) ? nid : 0;
-}
-
-EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
-#endif
-
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 85b52fc..dd27f40 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -2,646 +2,13 @@
  * Generic VM initialization for x86-64 NUMA setups.
  * Copyright 2002,2003 Andi Kleen, SuSE Labs.
  */
-#include <linux/kernel.h>
-#include <linux/mm.h>
-#include <linux/string.h>
-#include <linux/init.h>
 #include <linux/bootmem.h>
-#include <linux/memblock.h>
-#include <linux/mmzone.h>
-#include <linux/ctype.h>
-#include <linux/module.h>
-#include <linux/nodemask.h>
-#include <linux/sched.h>
-#include <linux/acpi.h>
-
-#include <asm/e820.h>
-#include <asm/proto.h>
-#include <asm/dma.h>
-#include <asm/acpi.h>
-#include <asm/amd_nb.h>
 
 #include "numa_internal.h"
 
-struct pglist_data *node_data[MAX_NUMNODES] __read_mostly;
-EXPORT_SYMBOL(node_data);
-
-nodemask_t numa_nodes_parsed __initdata;
-
-struct memnode memnode;
-
-static unsigned long __initdata nodemap_addr;
-static unsigned long __initdata nodemap_size;
-
-static struct numa_meminfo numa_meminfo __initdata;
-
-static int numa_distance_cnt;
-static u8 *numa_distance;
-
-/*
- * Given a shift value, try to populate memnodemap[]
- * Returns :
- * 1 if OK
- * 0 if memnodmap[] too small (of shift too small)
- * -1 if node overlap or lost ram (shift too big)
- */
-static int __init populate_memnodemap(const struct numa_meminfo *mi, int shift)
-{
-	unsigned long addr, end;
-	int i, res = -1;
-
-	memset(memnodemap, 0xff, sizeof(s16)*memnodemapsize);
-	for (i = 0; i < mi->nr_blks; i++) {
-		addr = mi->blk[i].start;
-		end = mi->blk[i].end;
-		if (addr >= end)
-			continue;
-		if ((end >> shift) >= memnodemapsize)
-			return 0;
-		do {
-			if (memnodemap[addr >> shift] != NUMA_NO_NODE)
-				return -1;
-			memnodemap[addr >> shift] = mi->blk[i].nid;
-			addr += (1UL << shift);
-		} while (addr < end);
-		res = 1;
-	}
-	return res;
-}
-
-static int __init allocate_cachealigned_memnodemap(void)
-{
-	unsigned long addr;
-
-	memnodemap = memnode.embedded_map;
-	if (memnodemapsize <= ARRAY_SIZE(memnode.embedded_map))
-		return 0;
-
-	addr = 0x8000;
-	nodemap_size = roundup(sizeof(s16) * memnodemapsize, L1_CACHE_BYTES);
-	nodemap_addr = memblock_find_in_range(addr, get_max_mapped(),
-				      nodemap_size, L1_CACHE_BYTES);
-	if (nodemap_addr == MEMBLOCK_ERROR) {
-		printk(KERN_ERR
-		       "NUMA: Unable to allocate Memory to Node hash map\n");
-		nodemap_addr = nodemap_size = 0;
-		return -1;
-	}
-	memnodemap = phys_to_virt(nodemap_addr);
-	memblock_x86_reserve_range(nodemap_addr, nodemap_addr + nodemap_size, "MEMNODEMAP");
-
-	printk(KERN_DEBUG "NUMA: Allocated memnodemap from %lx - %lx\n",
-	       nodemap_addr, nodemap_addr + nodemap_size);
-	return 0;
-}
-
-/*
- * The LSB of all start and end addresses in the node map is the value of the
- * maximum possible shift.
- */
-static int __init extract_lsb_from_nodes(const struct numa_meminfo *mi)
-{
-	int i, nodes_used = 0;
-	unsigned long start, end;
-	unsigned long bitfield = 0, memtop = 0;
-
-	for (i = 0; i < mi->nr_blks; i++) {
-		start = mi->blk[i].start;
-		end = mi->blk[i].end;
-		if (start >= end)
-			continue;
-		bitfield |= start;
-		nodes_used++;
-		if (end > memtop)
-			memtop = end;
-	}
-	if (nodes_used <= 1)
-		i = 63;
-	else
-		i = find_first_bit(&bitfield, sizeof(unsigned long)*8);
-	memnodemapsize = (memtop >> i)+1;
-	return i;
-}
-
-static int __init compute_hash_shift(const struct numa_meminfo *mi)
-{
-	int shift;
-
-	shift = extract_lsb_from_nodes(mi);
-	if (allocate_cachealigned_memnodemap())
-		return -1;
-	printk(KERN_DEBUG "NUMA: Using %d for the hash shift.\n",
-		shift);
-
-	if (populate_memnodemap(mi, shift) != 1) {
-		printk(KERN_INFO "Your memory is not aligned you need to "
-		       "rebuild your kernel with a bigger NODEMAPSIZE "
-		       "shift=%d\n", shift);
-		return -1;
-	}
-	return shift;
-}
-
-int __meminit  __early_pfn_to_nid(unsigned long pfn)
-{
-	return phys_to_nid(pfn << PAGE_SHIFT);
-}
-
-static void * __init early_node_mem(int nodeid, unsigned long start,
-				    unsigned long end, unsigned long size,
-				    unsigned long align)
-{
-	unsigned long mem;
-
-	/*
-	 * put it on high as possible
-	 * something will go with NODE_DATA
-	 */
-	if (start < (MAX_DMA_PFN<<PAGE_SHIFT))
-		start = MAX_DMA_PFN<<PAGE_SHIFT;
-	if (start < (MAX_DMA32_PFN<<PAGE_SHIFT) &&
-	    end > (MAX_DMA32_PFN<<PAGE_SHIFT))
-		start = MAX_DMA32_PFN<<PAGE_SHIFT;
-	mem = memblock_x86_find_in_range_node(nodeid, start, end, size, align);
-	if (mem != MEMBLOCK_ERROR)
-		return __va(mem);
-
-	/* extend the search scope */
-	end = max_pfn_mapped << PAGE_SHIFT;
-	start = MAX_DMA_PFN << PAGE_SHIFT;
-	mem = memblock_find_in_range(start, end, size, align);
-	if (mem != MEMBLOCK_ERROR)
-		return __va(mem);
-
-	printk(KERN_ERR "Cannot find %lu bytes in node %d\n",
-		       size, nodeid);
-
-	return NULL;
-}
-
-static int __init numa_add_memblk_to(int nid, u64 start, u64 end,
-				     struct numa_meminfo *mi)
-{
-	/* ignore zero length blks */
-	if (start == end)
-		return 0;
-
-	/* whine about and ignore invalid blks */
-	if (start > end || nid < 0 || nid >= MAX_NUMNODES) {
-		pr_warning("NUMA: Warning: invalid memblk node %d (%Lx-%Lx)\n",
-			   nid, start, end);
-		return 0;
-	}
-
-	if (mi->nr_blks >= NR_NODE_MEMBLKS) {
-		pr_err("NUMA: too many memblk ranges\n");
-		return -EINVAL;
-	}
-
-	mi->blk[mi->nr_blks].start = start;
-	mi->blk[mi->nr_blks].end = end;
-	mi->blk[mi->nr_blks].nid = nid;
-	mi->nr_blks++;
-	return 0;
-}
-
-/**
- * numa_remove_memblk_from - Remove one numa_memblk from a numa_meminfo
- * @idx: Index of memblk to remove
- * @mi: numa_meminfo to remove memblk from
- *
- * Remove @idx'th numa_memblk from @mi by shifting @mi->blk[] and
- * decrementing @mi->nr_blks.
- */
-void __init numa_remove_memblk_from(int idx, struct numa_meminfo *mi)
-{
-	mi->nr_blks--;
-	memmove(&mi->blk[idx], &mi->blk[idx + 1],
-		(mi->nr_blks - idx) * sizeof(mi->blk[0]));
-}
-
-/**
- * numa_add_memblk - Add one numa_memblk to numa_meminfo
- * @nid: NUMA node ID of the new memblk
- * @start: Start address of the new memblk
- * @end: End address of the new memblk
- *
- * Add a new memblk to the default numa_meminfo.
- *
- * RETURNS:
- * 0 on success, -errno on failure.
- */
-int __init numa_add_memblk(int nid, u64 start, u64 end)
-{
-	return numa_add_memblk_to(nid, start, end, &numa_meminfo);
-}
-
-/* Initialize bootmem allocator for a node */
-void __init
-setup_node_bootmem(int nodeid, unsigned long start, unsigned long end)
-{
-	unsigned long start_pfn, last_pfn, nodedata_phys;
-	const int pgdat_size = roundup(sizeof(pg_data_t), PAGE_SIZE);
-	int nid;
-
-	if (!end)
-		return;
-
-	/*
-	 * Don't confuse VM with a node that doesn't have the
-	 * minimum amount of memory:
-	 */
-	if (end && (end - start) < NODE_MIN_SIZE)
-		return;
-
-	start = roundup(start, ZONE_ALIGN);
-
-	printk(KERN_INFO "Initmem setup node %d %016lx-%016lx\n", nodeid,
-	       start, end);
-
-	start_pfn = start >> PAGE_SHIFT;
-	last_pfn = end >> PAGE_SHIFT;
-
-	node_data[nodeid] = early_node_mem(nodeid, start, end, pgdat_size,
-					   SMP_CACHE_BYTES);
-	if (node_data[nodeid] == NULL)
-		return;
-	nodedata_phys = __pa(node_data[nodeid]);
-	memblock_x86_reserve_range(nodedata_phys, nodedata_phys + pgdat_size, "NODE_DATA");
-	printk(KERN_INFO "  NODE_DATA [%016lx - %016lx]\n", nodedata_phys,
-		nodedata_phys + pgdat_size - 1);
-	nid = phys_to_nid(nodedata_phys);
-	if (nid != nodeid)
-		printk(KERN_INFO "    NODE_DATA(%d) on node %d\n", nodeid, nid);
-
-	memset(NODE_DATA(nodeid), 0, sizeof(pg_data_t));
-	NODE_DATA(nodeid)->node_id = nodeid;
-	NODE_DATA(nodeid)->node_start_pfn = start_pfn;
-	NODE_DATA(nodeid)->node_spanned_pages = last_pfn - start_pfn;
-
-	node_set_online(nodeid);
-}
-
-/**
- * numa_cleanup_meminfo - Cleanup a numa_meminfo
- * @mi: numa_meminfo to clean up
- *
- * Sanitize @mi by merging and removing unncessary memblks.  Also check for
- * conflicts and clear unused memblks.
- *
- * RETURNS:
- * 0 on success, -errno on failure.
- */
-int __init numa_cleanup_meminfo(struct numa_meminfo *mi)
-{
-	const u64 low = 0;
-	const u64 high = (u64)max_pfn << PAGE_SHIFT;
-	int i, j, k;
-
-	for (i = 0; i < mi->nr_blks; i++) {
-		struct numa_memblk *bi = &mi->blk[i];
-
-		/* make sure all blocks are inside the limits */
-		bi->start = max(bi->start, low);
-		bi->end = min(bi->end, high);
-
-		/* and there's no empty block */
-		if (bi->start >= bi->end) {
-			numa_remove_memblk_from(i--, mi);
-			continue;
-		}
-
-		for (j = i + 1; j < mi->nr_blks; j++) {
-			struct numa_memblk *bj = &mi->blk[j];
-			unsigned long start, end;
-
-			/*
-			 * See whether there are overlapping blocks.  Whine
-			 * about but allow overlaps of the same nid.  They
-			 * will be merged below.
-			 */
-			if (bi->end > bj->start && bi->start < bj->end) {
-				if (bi->nid != bj->nid) {
-					pr_err("NUMA: node %d (%Lx-%Lx) overlaps with node %d (%Lx-%Lx)\n",
-					       bi->nid, bi->start, bi->end,
-					       bj->nid, bj->start, bj->end);
-					return -EINVAL;
-				}
-				pr_warning("NUMA: Warning: node %d (%Lx-%Lx) overlaps with itself (%Lx-%Lx)\n",
-					   bi->nid, bi->start, bi->end,
-					   bj->start, bj->end);
-			}
-
-			/*
-			 * Join together blocks on the same node, holes
-			 * between which don't overlap with memory on other
-			 * nodes.
-			 */
-			if (bi->nid != bj->nid)
-				continue;
-			start = max(min(bi->start, bj->start), low);
-			end = min(max(bi->end, bj->end), high);
-			for (k = 0; k < mi->nr_blks; k++) {
-				struct numa_memblk *bk = &mi->blk[k];
-
-				if (bi->nid == bk->nid)
-					continue;
-				if (start < bk->end && end > bk->start)
-					break;
-			}
-			if (k < mi->nr_blks)
-				continue;
-			printk(KERN_INFO "NUMA: Node %d [%Lx,%Lx) + [%Lx,%Lx) -> [%lx,%lx)\n",
-			       bi->nid, bi->start, bi->end, bj->start, bj->end,
-			       start, end);
-			bi->start = start;
-			bi->end = end;
-			numa_remove_memblk_from(j--, mi);
-		}
-	}
-
-	for (i = mi->nr_blks; i < ARRAY_SIZE(mi->blk); i++) {
-		mi->blk[i].start = mi->blk[i].end = 0;
-		mi->blk[i].nid = NUMA_NO_NODE;
-	}
-
-	return 0;
-}
-
-/*
- * Set nodes, which have memory in @mi, in *@nodemask.
- */
-static void __init numa_nodemask_from_meminfo(nodemask_t *nodemask,
-					      const struct numa_meminfo *mi)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(mi->blk); i++)
-		if (mi->blk[i].start != mi->blk[i].end &&
-		    mi->blk[i].nid != NUMA_NO_NODE)
-			node_set(mi->blk[i].nid, *nodemask);
-}
-
-/**
- * numa_reset_distance - Reset NUMA distance table
- *
- * The current table is freed.  The next numa_set_distance() call will
- * create a new one.
- */
-void __init numa_reset_distance(void)
-{
-	size_t size = numa_distance_cnt * numa_distance_cnt * sizeof(numa_distance[0]);
-
-	/* numa_distance could be 1LU marking allocation failure, test cnt */
-	if (numa_distance_cnt)
-		memblock_x86_free_range(__pa(numa_distance),
-					__pa(numa_distance) + size);
-	numa_distance_cnt = 0;
-	numa_distance = NULL;	/* enable table creation */
-}
-
-static int __init numa_alloc_distance(void)
-{
-	nodemask_t nodes_parsed;
-	size_t size;
-	int i, j, cnt = 0;
-	u64 phys;
-
-	/* size the new table and allocate it */
-	nodes_parsed = numa_nodes_parsed;
-	numa_nodemask_from_meminfo(&nodes_parsed, &numa_meminfo);
-
-	for_each_node_mask(i, nodes_parsed)
-		cnt = i;
-	cnt++;
-	size = cnt * cnt * sizeof(numa_distance[0]);
-
-	phys = memblock_find_in_range(0, (u64)max_pfn_mapped << PAGE_SHIFT,
-				      size, PAGE_SIZE);
-	if (phys == MEMBLOCK_ERROR) {
-		pr_warning("NUMA: Warning: can't allocate distance table!\n");
-		/* don't retry until explicitly reset */
-		numa_distance = (void *)1LU;
-		return -ENOMEM;
-	}
-	memblock_x86_reserve_range(phys, phys + size, "NUMA DIST");
-
-	numa_distance = __va(phys);
-	numa_distance_cnt = cnt;
-
-	/* fill with the default distances */
-	for (i = 0; i < cnt; i++)
-		for (j = 0; j < cnt; j++)
-			numa_distance[i * cnt + j] = i == j ?
-				LOCAL_DISTANCE : REMOTE_DISTANCE;
-	printk(KERN_DEBUG "NUMA: Initialized distance table, cnt=%d\n", cnt);
-
-	return 0;
-}
-
-/**
- * numa_set_distance - Set NUMA distance from one NUMA to another
- * @from: the 'from' node to set distance
- * @to: the 'to'  node to set distance
- * @distance: NUMA distance
- *
- * Set the distance from node @from to @to to @distance.  If distance table
- * doesn't exist, one which is large enough to accommodate all the currently
- * known nodes will be created.
- *
- * If such table cannot be allocated, a warning is printed and further
- * calls are ignored until the distance table is reset with
- * numa_reset_distance().
- *
- * If @from or @to is higher than the highest known node at the time of
- * table creation or @distance doesn't make sense, the call is ignored.
- * This is to allow simplification of specific NUMA config implementations.
- */
-void __init numa_set_distance(int from, int to, int distance)
-{
-	if (!numa_distance && numa_alloc_distance() < 0)
-		return;
-
-	if (from >= numa_distance_cnt || to >= numa_distance_cnt) {
-		printk_once(KERN_DEBUG "NUMA: Debug: distance out of bound, from=%d to=%d distance=%d\n",
-			    from, to, distance);
-		return;
-	}
-
-	if ((u8)distance != distance ||
-	    (from == to && distance != LOCAL_DISTANCE)) {
-		pr_warn_once("NUMA: Warning: invalid distance parameter, from=%d to=%d distance=%d\n",
-			     from, to, distance);
-		return;
-	}
-
-	numa_distance[from * numa_distance_cnt + to] = distance;
-}
-
-int __node_distance(int from, int to)
-{
-	if (from >= numa_distance_cnt || to >= numa_distance_cnt)
-		return from == to ? LOCAL_DISTANCE : REMOTE_DISTANCE;
-	return numa_distance[from * numa_distance_cnt + to];
-}
-EXPORT_SYMBOL(__node_distance);
-
-/*
- * Sanity check to catch more bad NUMA configurations (they are amazingly
- * common).  Make sure the nodes cover all memory.
- */
-static bool __init numa_meminfo_cover_memory(const struct numa_meminfo *mi)
-{
-	unsigned long numaram, e820ram;
-	int i;
-
-	numaram = 0;
-	for (i = 0; i < mi->nr_blks; i++) {
-		unsigned long s = mi->blk[i].start >> PAGE_SHIFT;
-		unsigned long e = mi->blk[i].end >> PAGE_SHIFT;
-		numaram += e - s;
-		numaram -= __absent_pages_in_range(mi->blk[i].nid, s, e);
-		if ((long)numaram < 0)
-			numaram = 0;
-	}
-
-	e820ram = max_pfn - (memblock_x86_hole_size(0,
-					max_pfn << PAGE_SHIFT) >> PAGE_SHIFT);
-	/* We seem to lose 3 pages somewhere. Allow 1M of slack. */
-	if ((long)(e820ram - numaram) >= (1 << (20 - PAGE_SHIFT))) {
-		printk(KERN_ERR "NUMA: nodes only cover %luMB of your %luMB e820 RAM. Not used.\n",
-		       (numaram << PAGE_SHIFT) >> 20,
-		       (e820ram << PAGE_SHIFT) >> 20);
-		return false;
-	}
-	return true;
-}
-
-static int __init numa_register_memblks(struct numa_meminfo *mi)
-{
-	int i, nid;
-
-	/* Account for nodes with cpus and no memory */
-	node_possible_map = numa_nodes_parsed;
-	numa_nodemask_from_meminfo(&node_possible_map, mi);
-	if (WARN_ON(nodes_empty(node_possible_map)))
-		return -EINVAL;
-
-	memnode_shift = compute_hash_shift(mi);
-	if (memnode_shift < 0) {
-		printk(KERN_ERR "NUMA: No NUMA node hash function found. Contact maintainer\n");
-		return -EINVAL;
-	}
-
-	for (i = 0; i < mi->nr_blks; i++)
-		memblock_x86_register_active_regions(mi->blk[i].nid,
-					mi->blk[i].start >> PAGE_SHIFT,
-					mi->blk[i].end >> PAGE_SHIFT);
-
-	/* for out of order entries */
-	sort_node_map();
-	if (!numa_meminfo_cover_memory(mi))
-		return -EINVAL;
-
-	/* Finally register nodes. */
-	for_each_node_mask(nid, node_possible_map) {
-		u64 start = (u64)max_pfn << PAGE_SHIFT;
-		u64 end = 0;
-
-		for (i = 0; i < mi->nr_blks; i++) {
-			if (nid != mi->blk[i].nid)
-				continue;
-			start = min(mi->blk[i].start, start);
-			end = max(mi->blk[i].end, end);
-		}
-
-		if (start < end)
-			setup_node_bootmem(nid, start, end);
-	}
-
-	return 0;
-}
-
-/**
- * dummy_numma_init - Fallback dummy NUMA init
- *
- * Used if there's no underlying NUMA architecture, NUMA initialization
- * fails, or NUMA is disabled on the command line.
- *
- * Must online at least one node and add memory blocks that cover all
- * allowed memory.  This function must not fail.
- */
-static int __init dummy_numa_init(void)
-{
-	printk(KERN_INFO "%s\n",
-	       numa_off ? "NUMA turned off" : "No NUMA configuration found");
-	printk(KERN_INFO "Faking a node at %016lx-%016lx\n",
-	       0LU, max_pfn << PAGE_SHIFT);
-
-	node_set(0, numa_nodes_parsed);
-	numa_add_memblk(0, 0, (u64)max_pfn << PAGE_SHIFT);
-
-	return 0;
-}
-
-static int __init numa_init(int (*init_func)(void))
-{
-	int i;
-	int ret;
-
-	for (i = 0; i < MAX_LOCAL_APIC; i++)
-		set_apicid_to_node(i, NUMA_NO_NODE);
-
-	nodes_clear(numa_nodes_parsed);
-	nodes_clear(node_possible_map);
-	nodes_clear(node_online_map);
-	memset(&numa_meminfo, 0, sizeof(numa_meminfo));
-	remove_all_active_ranges();
-	numa_reset_distance();
-
-	ret = init_func();
-	if (ret < 0)
-		return ret;
-	ret = numa_cleanup_meminfo(&numa_meminfo);
-	if (ret < 0)
-		return ret;
-
-	numa_emulation(&numa_meminfo, numa_distance_cnt);
-
-	ret = numa_register_memblks(&numa_meminfo);
-	if (ret < 0)
-		return ret;
-
-	for (i = 0; i < nr_cpu_ids; i++) {
-		int nid = early_cpu_to_node(i);
-
-		if (nid == NUMA_NO_NODE)
-			continue;
-		if (!node_online(nid))
-			numa_clear_node(i);
-	}
-	numa_init_array();
-	return 0;
-}
-
 void __init initmem_init(void)
 {
-	int ret;
-
-	if (!numa_off) {
-#ifdef CONFIG_ACPI_NUMA
-		ret = numa_init(x86_acpi_numa_init);
-		if (!ret)
-			return;
-#endif
-#ifdef CONFIG_AMD_NUMA
-		ret = numa_init(amd_numa_init);
-		if (!ret)
-			return;
-#endif
-	}
-
-	numa_init(dummy_numa_init);
+	x86_numa_init();
 }
 
 unsigned long __init numa_free_all_bootmem(void)
@@ -656,12 +23,3 @@ unsigned long __init numa_free_all_bootmem(void)
 
 	return pages;
 }
-
-int __cpuinit numa_cpu_node(int cpu)
-{
-	int apicid = early_per_cpu(x86_cpu_to_apicid, cpu);
-
-	if (apicid != BAD_APICID)
-		return __apicid_to_node[apicid];
-	return NUMA_NO_NODE;
-}
diff --git a/arch/x86/mm/numa_emulation.c b/arch/x86/mm/numa_emulation.c
index de84cc1..d0ed086 100644
--- a/arch/x86/mm/numa_emulation.c
+++ b/arch/x86/mm/numa_emulation.c
@@ -5,6 +5,7 @@
 #include <linux/errno.h>
 #include <linux/topology.h>
 #include <linux/memblock.h>
+#include <linux/bootmem.h>
 #include <asm/dma.h>
 
 #include "numa_internal.h"
@@ -84,7 +85,13 @@ static int __init split_nodes_interleave(struct numa_meminfo *ei,
 		nr_nodes = MAX_NUMNODES;
 	}
 
-	size = (max_addr - addr - memblock_x86_hole_size(addr, max_addr)) / nr_nodes;
+	/*
+	 * Calculate target node size.  x86_32 freaks on __udivdi3() so do
+	 * the division in ulong number of pages and convert back.
+	 */
+	size = max_addr - addr - memblock_x86_hole_size(addr, max_addr);
+	size = PFN_PHYS((unsigned long)(size >> PAGE_SHIFT) / nr_nodes);
+
 	/*
 	 * Calculate the number of big nodes that can be allocated as a result
 	 * of consolidating the remainder.
@@ -226,7 +233,7 @@ static int __init split_nodes_size_interleave(struct numa_meminfo *ei,
 	 */
 	while (nodes_weight(physnode_mask)) {
 		for_each_node_mask(i, physnode_mask) {
-			u64 dma32_end = MAX_DMA32_PFN << PAGE_SHIFT;
+			u64 dma32_end = PFN_PHYS(MAX_DMA32_PFN);
 			u64 start, limit, end;
 			int phys_blk;
 
@@ -298,7 +305,7 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
 {
 	static struct numa_meminfo ei __initdata;
 	static struct numa_meminfo pi __initdata;
-	const u64 max_addr = max_pfn << PAGE_SHIFT;
+	const u64 max_addr = PFN_PHYS(max_pfn);
 	u8 *phys_dist = NULL;
 	size_t phys_size = numa_dist_cnt * numa_dist_cnt * sizeof(phys_dist[0]);
 	int max_emu_nid, dfl_phys_nid;
@@ -342,8 +349,7 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
 	if (numa_dist_cnt) {
 		u64 phys;
 
-		phys = memblock_find_in_range(0,
-					      (u64)max_pfn_mapped << PAGE_SHIFT,
+		phys = memblock_find_in_range(0, PFN_PHYS(max_pfn_mapped),
 					      phys_size, PAGE_SIZE);
 		if (phys == MEMBLOCK_ERROR) {
 			pr_warning("NUMA: Warning: can't allocate copy of distance table, disabling emulation\n");
diff --git a/arch/x86/mm/numa_internal.h b/arch/x86/mm/numa_internal.h
index ef2d973..7178c3a 100644
--- a/arch/x86/mm/numa_internal.h
+++ b/arch/x86/mm/numa_internal.h
@@ -19,6 +19,14 @@ void __init numa_remove_memblk_from(int idx, struct numa_meminfo *mi);
 int __init numa_cleanup_meminfo(struct numa_meminfo *mi);
 void __init numa_reset_distance(void);
 
+void __init x86_numa_init(void);
+
+#ifdef CONFIG_X86_64
+static inline void init_alloc_remap(int nid, u64 start, u64 end)	{ }
+#else
+void __init init_alloc_remap(int nid, u64 start, u64 end);
+#endif
+
 #ifdef CONFIG_NUMA_EMU
 void __init numa_emulation(struct numa_meminfo *numa_meminfo,
 			   int numa_dist_cnt);
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat.c
similarity index 67%
rename from arch/x86/mm/srat_64.c
rename to arch/x86/mm/srat.c
index 8e9d339..81dbfde 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat.c
@@ -26,8 +26,6 @@
 
 int acpi_numa __initdata;
 
-static struct bootnode nodes_add[MAX_NUMNODES];
-
 static __init int setup_node(int pxm)
 {
 	return acpi_map_pxm_to_node(pxm);
@@ -37,7 +35,6 @@ static __init void bad_srat(void)
 {
 	printk(KERN_ERR "SRAT: SRAT not used.\n");
 	acpi_numa = -1;
-	memset(nodes_add, 0, sizeof(nodes_add));
 }
 
 static __init inline int srat_disabled(void)
@@ -131,73 +128,17 @@ acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
 	       pxm, apic_id, node);
 }
 
-#ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
+#ifdef CONFIG_MEMORY_HOTPLUG
 static inline int save_add_info(void) {return 1;}
 #else
 static inline int save_add_info(void) {return 0;}
 #endif
-/*
- * Update nodes_add[]
- * This code supports one contiguous hot add area per node
- */
-static void __init
-update_nodes_add(int node, unsigned long start, unsigned long end)
-{
-	unsigned long s_pfn = start >> PAGE_SHIFT;
-	unsigned long e_pfn = end >> PAGE_SHIFT;
-	int changed = 0;
-	struct bootnode *nd = &nodes_add[node];
-
-	/* I had some trouble with strange memory hotadd regions breaking
-	   the boot. Be very strict here and reject anything unexpected.
-	   If you want working memory hotadd write correct SRATs.
-
-	   The node size check is a basic sanity check to guard against
-	   mistakes */
-	if ((signed long)(end - start) < NODE_MIN_SIZE) {
-		printk(KERN_ERR "SRAT: Hotplug area too small\n");
-		return;
-	}
-
-	/* This check might be a bit too strict, but I'm keeping it for now. */
-	if (absent_pages_in_range(s_pfn, e_pfn) != e_pfn - s_pfn) {
-		printk(KERN_ERR
-			"SRAT: Hotplug area %lu -> %lu has existing memory\n",
-			s_pfn, e_pfn);
-		return;
-	}
-
-	/* Looks good */
-
-	if (nd->start == nd->end) {
-		nd->start = start;
-		nd->end = end;
-		changed = 1;
-	} else {
-		if (nd->start == end) {
-			nd->start = start;
-			changed = 1;
-		}
-		if (nd->end == start) {
-			nd->end = end;
-			changed = 1;
-		}
-		if (!changed)
-			printk(KERN_ERR "SRAT: Hotplug zone not continuous. Partly ignored\n");
-	}
-
-	if (changed) {
-		node_set(node, numa_nodes_parsed);
-		printk(KERN_INFO "SRAT: hot plug zone found %Lx - %Lx\n",
-				 nd->start, nd->end);
-	}
-}
 
 /* Callback for parsing of the Proximity Domain <-> Memory Area mappings */
 void __init
 acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 {
-	unsigned long start, end;
+	u64 start, end;
 	int node, pxm;
 
 	if (srat_disabled())
@@ -226,11 +167,8 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 		return;
 	}
 
-	printk(KERN_INFO "SRAT: Node %u PXM %u %lx-%lx\n", node, pxm,
+	printk(KERN_INFO "SRAT: Node %u PXM %u %Lx-%Lx\n", node, pxm,
 	       start, end);
-
-	if (ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE)
-		update_nodes_add(node, start, end);
 }
 
 void __init acpi_numa_arch_fixup(void) {}
@@ -244,17 +182,3 @@ int __init x86_acpi_numa_init(void)
 		return ret;
 	return srat_disabled() ? -EINVAL : 0;
 }
-
-#if defined(CONFIG_MEMORY_HOTPLUG_SPARSE) || defined(CONFIG_ACPI_HOTPLUG_MEMORY)
-int memory_add_physaddr_to_nid(u64 start)
-{
-	int i, ret = 0;
-
-	for_each_node(i)
-		if (nodes_add[i].start <= start && nodes_add[i].end > start)
-			ret = i;
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
-#endif
diff --git a/arch/x86/mm/srat_32.c b/arch/x86/mm/srat_32.c
deleted file mode 100644
index 364f36b..0000000
--- a/arch/x86/mm/srat_32.c
+++ /dev/null
@@ -1,288 +0,0 @@
-/*
- * Some of the code in this file has been gleaned from the 64 bit 
- * discontigmem support code base.
- *
- * Copyright (C) 2002, IBM Corp.
- *
- * All rights reserved.          
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
- * NON INFRINGEMENT.  See the GNU General Public License for more
- * details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- *
- * Send feedback to Pat Gaughen <gone@us.ibm.com>
- */
-#include <linux/mm.h>
-#include <linux/bootmem.h>
-#include <linux/memblock.h>
-#include <linux/mmzone.h>
-#include <linux/acpi.h>
-#include <linux/nodemask.h>
-#include <asm/srat.h>
-#include <asm/topology.h>
-#include <asm/smp.h>
-#include <asm/e820.h>
-
-/*
- * proximity macros and definitions
- */
-#define NODE_ARRAY_INDEX(x)	((x) / 8)	/* 8 bits/char */
-#define NODE_ARRAY_OFFSET(x)	((x) % 8)	/* 8 bits/char */
-#define BMAP_SET(bmap, bit)	((bmap)[NODE_ARRAY_INDEX(bit)] |= 1 << NODE_ARRAY_OFFSET(bit))
-#define BMAP_TEST(bmap, bit)	((bmap)[NODE_ARRAY_INDEX(bit)] & (1 << NODE_ARRAY_OFFSET(bit)))
-/* bitmap length; _PXM is at most 255 */
-#define PXM_BITMAP_LEN (MAX_PXM_DOMAINS / 8) 
-static u8 __initdata pxm_bitmap[PXM_BITMAP_LEN];	/* bitmap of proximity domains */
-
-#define MAX_CHUNKS_PER_NODE	3
-#define MAXCHUNKS		(MAX_CHUNKS_PER_NODE * MAX_NUMNODES)
-struct node_memory_chunk_s {
-	unsigned long	start_pfn;
-	unsigned long	end_pfn;
-	u8	pxm;		// proximity domain of node
-	u8	nid;		// which cnode contains this chunk?
-	u8	bank;		// which mem bank on this node
-};
-static struct node_memory_chunk_s __initdata node_memory_chunk[MAXCHUNKS];
-
-static int __initdata num_memory_chunks; /* total number of memory chunks */
-static u8 __initdata apicid_to_pxm[MAX_LOCAL_APIC];
-
-int acpi_numa __initdata;
-
-static __init void bad_srat(void)
-{
-        printk(KERN_ERR "SRAT: SRAT not used.\n");
-        acpi_numa = -1;
-	num_memory_chunks = 0;
-}
-
-static __init inline int srat_disabled(void)
-{
-	return numa_off || acpi_numa < 0;
-}
-
-/* Identify CPU proximity domains */
-void __init
-acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *cpu_affinity)
-{
-	if (srat_disabled())
-		return;
-	if (cpu_affinity->header.length !=
-	     sizeof(struct acpi_srat_cpu_affinity)) {
-		bad_srat();
-		return;
-	}
-
-	if ((cpu_affinity->flags & ACPI_SRAT_CPU_ENABLED) == 0)
-		return;		/* empty entry */
-
-	/* mark this node as "seen" in node bitmap */
-	BMAP_SET(pxm_bitmap, cpu_affinity->proximity_domain_lo);
-
-	/* don't need to check apic_id here, because it is always 8 bits */
-	apicid_to_pxm[cpu_affinity->apic_id] = cpu_affinity->proximity_domain_lo;
-
-	printk(KERN_DEBUG "CPU %02x in proximity domain %02x\n",
-		cpu_affinity->apic_id, cpu_affinity->proximity_domain_lo);
-}
-
-/*
- * Identify memory proximity domains and hot-remove capabilities.
- * Fill node memory chunk list structure.
- */
-void __init
-acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *memory_affinity)
-{
-	unsigned long long paddr, size;
-	unsigned long start_pfn, end_pfn;
-	u8 pxm;
-	struct node_memory_chunk_s *p, *q, *pend;
-
-	if (srat_disabled())
-		return;
-	if (memory_affinity->header.length !=
-	     sizeof(struct acpi_srat_mem_affinity)) {
-		bad_srat();
-		return;
-	}
-
-	if ((memory_affinity->flags & ACPI_SRAT_MEM_ENABLED) == 0)
-		return;		/* empty entry */
-
-	pxm = memory_affinity->proximity_domain & 0xff;
-
-	/* mark this node as "seen" in node bitmap */
-	BMAP_SET(pxm_bitmap, pxm);
-
-	/* calculate info for memory chunk structure */
-	paddr = memory_affinity->base_address;
-	size = memory_affinity->length;
-
-	start_pfn = paddr >> PAGE_SHIFT;
-	end_pfn = (paddr + size) >> PAGE_SHIFT;
-
-
-	if (num_memory_chunks >= MAXCHUNKS) {
-		printk(KERN_WARNING "Too many mem chunks in SRAT."
-			" Ignoring %lld MBytes at %llx\n",
-			size/(1024*1024), paddr);
-		return;
-	}
-
-	/* Insertion sort based on base address */
-	pend = &node_memory_chunk[num_memory_chunks];
-	for (p = &node_memory_chunk[0]; p < pend; p++) {
-		if (start_pfn < p->start_pfn)
-			break;
-	}
-	if (p < pend) {
-		for (q = pend; q >= p; q--)
-			*(q + 1) = *q;
-	}
-	p->start_pfn = start_pfn;
-	p->end_pfn = end_pfn;
-	p->pxm = pxm;
-
-	num_memory_chunks++;
-
-	printk(KERN_DEBUG "Memory range %08lx to %08lx"
-			  " in proximity domain %02x %s\n",
-		start_pfn, end_pfn,
-		pxm,
-		((memory_affinity->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) ?
-		 "enabled and removable" : "enabled" ) );
-}
-
-/* Callback for SLIT parsing */
-void __init acpi_numa_slit_init(struct acpi_table_slit *slit)
-{
-}
-
-void acpi_numa_arch_fixup(void)
-{
-}
-/*
- * The SRAT table always lists ascending addresses, so can always
- * assume that the first "start" address that you see is the real
- * start of the node, and that the current "end" address is after
- * the previous one.
- */
-static __init int node_read_chunk(int nid, struct node_memory_chunk_s *memory_chunk)
-{
-	/*
-	 * Only add present memory as told by the e820.
-	 * There is no guarantee from the SRAT that the memory it
-	 * enumerates is present at boot time because it represents
-	 * *possible* memory hotplug areas the same as normal RAM.
-	 */
-	if (memory_chunk->start_pfn >= max_pfn) {
-		printk(KERN_INFO "Ignoring SRAT pfns: %08lx - %08lx\n",
-			memory_chunk->start_pfn, memory_chunk->end_pfn);
-		return -1;
-	}
-	if (memory_chunk->nid != nid)
-		return -1;
-
-	if (!node_has_online_mem(nid))
-		node_start_pfn[nid] = memory_chunk->start_pfn;
-
-	if (node_start_pfn[nid] > memory_chunk->start_pfn)
-		node_start_pfn[nid] = memory_chunk->start_pfn;
-
-	if (node_end_pfn[nid] < memory_chunk->end_pfn)
-		node_end_pfn[nid] = memory_chunk->end_pfn;
-
-	return 0;
-}
-
-int __init get_memcfg_from_srat(void)
-{
-	int i, j, nid;
-
-	if (srat_disabled())
-		goto out_fail;
-
-	if (acpi_numa_init() < 0)
-		goto out_fail;
-
-	if (num_memory_chunks == 0) {
-		printk(KERN_DEBUG
-			 "could not find any ACPI SRAT memory areas.\n");
-		goto out_fail;
-	}
-
-	/* Calculate total number of nodes in system from PXM bitmap and create
-	 * a set of sequential node IDs starting at zero.  (ACPI doesn't seem
-	 * to specify the range of _PXM values.)
-	 */
-	/*
-	 * MCD - we no longer HAVE to number nodes sequentially.  PXM domain
-	 * numbers could go as high as 256, and MAX_NUMNODES for i386 is typically
-	 * 32, so we will continue numbering them in this manner until MAX_NUMNODES
-	 * approaches MAX_PXM_DOMAINS for i386.
-	 */
-	nodes_clear(node_online_map);
-	for (i = 0; i < MAX_PXM_DOMAINS; i++) {
-		if (BMAP_TEST(pxm_bitmap, i)) {
-			int nid = acpi_map_pxm_to_node(i);
-			node_set_online(nid);
-		}
-	}
-	BUG_ON(num_online_nodes() == 0);
-
-	/* set cnode id in memory chunk structure */
-	for (i = 0; i < num_memory_chunks; i++)
-		node_memory_chunk[i].nid = pxm_to_node(node_memory_chunk[i].pxm);
-
-	printk(KERN_DEBUG "pxm bitmap: ");
-	for (i = 0; i < sizeof(pxm_bitmap); i++) {
-		printk(KERN_CONT "%02x ", pxm_bitmap[i]);
-	}
-	printk(KERN_CONT "\n");
-	printk(KERN_DEBUG "Number of logical nodes in system = %d\n",
-			 num_online_nodes());
-	printk(KERN_DEBUG "Number of memory chunks in system = %d\n",
-			 num_memory_chunks);
-
-	for (i = 0; i < MAX_LOCAL_APIC; i++)
-		set_apicid_to_node(i, pxm_to_node(apicid_to_pxm[i]));
-
-	for (j = 0; j < num_memory_chunks; j++){
-		struct node_memory_chunk_s * chunk = &node_memory_chunk[j];
-		printk(KERN_DEBUG
-			"chunk %d nid %d start_pfn %08lx end_pfn %08lx\n",
-		       j, chunk->nid, chunk->start_pfn, chunk->end_pfn);
-		if (node_read_chunk(chunk->nid, chunk))
-			continue;
-
-		memblock_x86_register_active_regions(chunk->nid, chunk->start_pfn,
-					     min(chunk->end_pfn, max_pfn));
-	}
-	/* for out of order entries in SRAT */
-	sort_node_map();
-
-	for_each_online_node(nid) {
-		unsigned long start = node_start_pfn[nid];
-		unsigned long end = min(node_end_pfn[nid], max_pfn);
-
-		memory_present(nid, start, end);
-		node_remap_size[nid] = node_memmap_size_bytes(nid, start, end);
-	}
-	return 1;
-out_fail:
-	printk(KERN_DEBUG "failed to get NUMA memory information from SRAT"
-			" table\n");
-	return 0;
-}
diff --git a/drivers/acpi/processor_throttling.c b/drivers/acpi/processor_throttling.c
index ad35017..605a295 100644
--- a/drivers/acpi/processor_throttling.c
+++ b/drivers/acpi/processor_throttling.c
@@ -710,20 +710,14 @@ static int acpi_processor_get_throttling_fadt(struct acpi_processor *pr)
 }
 
 #ifdef CONFIG_X86
-static int acpi_throttling_rdmsr(struct acpi_processor *pr,
-					u64 *value)
+static int acpi_throttling_rdmsr(u64 *value)
 {
-	struct cpuinfo_x86 *c;
 	u64 msr_high, msr_low;
-	unsigned int cpu;
 	u64 msr = 0;
 	int ret = -1;
 
-	cpu = pr->id;
-	c = &cpu_data(cpu);
-
-	if ((c->x86_vendor != X86_VENDOR_INTEL) ||
-		!cpu_has(c, X86_FEATURE_ACPI)) {
+	if ((this_cpu_read(cpu_info.x86_vendor) != X86_VENDOR_INTEL) ||
+		!this_cpu_has(X86_FEATURE_ACPI)) {
 		printk(KERN_ERR PREFIX
 			"HARDWARE addr space,NOT supported yet\n");
 	} else {
@@ -738,18 +732,13 @@ static int acpi_throttling_rdmsr(struct acpi_processor *pr,
 	return ret;
 }
 
-static int acpi_throttling_wrmsr(struct acpi_processor *pr, u64 value)
+static int acpi_throttling_wrmsr(u64 value)
 {
-	struct cpuinfo_x86 *c;
-	unsigned int cpu;
 	int ret = -1;
 	u64 msr;
 
-	cpu = pr->id;
-	c = &cpu_data(cpu);
-
-	if ((c->x86_vendor != X86_VENDOR_INTEL) ||
-		!cpu_has(c, X86_FEATURE_ACPI)) {
+	if ((this_cpu_read(cpu_info.x86_vendor) != X86_VENDOR_INTEL) ||
+		!this_cpu_has(X86_FEATURE_ACPI)) {
 		printk(KERN_ERR PREFIX
 			"HARDWARE addr space,NOT supported yet\n");
 	} else {
@@ -761,15 +750,14 @@ static int acpi_throttling_wrmsr(struct acpi_processor *pr, u64 value)
 	return ret;
 }
 #else
-static int acpi_throttling_rdmsr(struct acpi_processor *pr,
-				u64 *value)
+static int acpi_throttling_rdmsr(u64 *value)
 {
 	printk(KERN_ERR PREFIX
 		"HARDWARE addr space,NOT supported yet\n");
 	return -1;
 }
 
-static int acpi_throttling_wrmsr(struct acpi_processor *pr, u64 value)
+static int acpi_throttling_wrmsr(u64 value)
 {
 	printk(KERN_ERR PREFIX
 		"HARDWARE addr space,NOT supported yet\n");
@@ -801,7 +789,7 @@ static int acpi_read_throttling_status(struct acpi_processor *pr,
 		ret = 0;
 		break;
 	case ACPI_ADR_SPACE_FIXED_HARDWARE:
-		ret = acpi_throttling_rdmsr(pr, value);
+		ret = acpi_throttling_rdmsr(value);
 		break;
 	default:
 		printk(KERN_ERR PREFIX "Unknown addr space %d\n",
@@ -834,7 +822,7 @@ static int acpi_write_throttling_state(struct acpi_processor *pr,
 		ret = 0;
 		break;
 	case ACPI_ADR_SPACE_FIXED_HARDWARE:
-		ret = acpi_throttling_wrmsr(pr, value);
+		ret = acpi_throttling_wrmsr(value);
 		break;
 	default:
 		printk(KERN_ERR PREFIX "Unknown addr space %d\n",
