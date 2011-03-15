Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838Ab1COVPq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 17:15:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54680 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758635Ab1COVPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 17:15:42 -0400
Date: Tue, 15 Mar 2011 22:14:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/mm changes for v2.6.39
Message-ID: <20110315211458.GA15294@elte.hu>
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


out-of-topic modifications in x86-mm-for-linus:
-----------------------------------------------
drivers/acpi/numa.c                # 940fed2: x86-64, NUMA: Unify {acpi|amd}_{n
include/linux/mm.h                 # 8bc1f91: bootmem: Move __alloc_memory_core
include/linux/pci_ids.h            # 41b2610: x86, amd: Extend AMD northbridge 
mm/Makefile                        # 0932587: bootmem: Separate out CONFIG_NO_B
mm/bootmem.c                       # e782ab4: bootmem: Move contig_page_data de
                                   # 0932587: bootmem: Separate out CONFIG_NO_B
mm/nobootmem.c                     # 8bc1f91: bootmem: Move __alloc_memory_core
                                   # e782ab4: bootmem: Move contig_page_data de
                                   # 0932587: bootmem: Separate out CONFIG_NO_B
mm/page_alloc.c                    # cc28989: mm: Move early_node_map[] reverse
                                   # 8bc1f91: bootmem: Move __alloc_memory_core
                                   # e782ab4: bootmem: Move contig_page_data de
                                   # 1a4a678: memblock: Make find_memory_core_e

 Thanks,

	Ingo

------------------>
Andreas Herrmann (1):
      x86, amd: Normalize compute unit IDs on multi-node processors

Borislav Petkov (1):
      x86, amd: Initialize variable properly

David Rientjes (3):
      x86, numa: Add error handling for bad cpu-to-node mappings
      x86-64, NUMA: Fix size of numa_distance array
      x86-64, NUMA: Clean up initmem_init()

Hans Rosenfeld (3):
      x86, amd: Enable L3 cache index disable on family 0x15
      x86, amd: Extend AMD northbridge caching code to support "Link Control" devices
      x86, amd: Support L3 Cache Partitioning on AMD family 0x15 CPUs

Jan Beulich (2):
      x86: Adjust section placement in AMD northbridge related code
      x86: Work around old gas bug

Kamal Mostafa (2):
      x86: Fix panic when handling "mem={invalid}" param
      x86: Emit "mem=nopentium ignored" warning when not supported

Shaohua Li (4):
      x86: Cleanup vector usage
      x86: Allocate 32 tlb_invalidate_interrupt handler stubs
      x86: Scale up the number of TLB invalidate vectors with NR_CPUs, up to 32
      x86: Avoid tlbstate lock if not enough cpus

Tejun Heo (58):
      x86: Kill unused static boot_cpu_logical_apicid in smpboot.c
      x86: Drop x86_32 MAX_APICID
      x86: Make default_send_IPI_mask_sequence/allbutself_logical() 32bit only
      x86: Replace cpu_2_logical_apicid[] with early percpu variable
      x86: Always use x86_cpu_to_logical_apicid for cpu -> logical apic id
      x86: Kill apic->cpu_to_logical_apicid()
      x86: Add apic->x86_32_early_logical_apicid()
      x86: Implement the default x86_32_early_logical_apicid()
      x86: Implement x86_32_early_logical_apicid() for bigsmp_32
      x86: Implement x86_32_early_logical_apicid() for summit_32
      x86: Implement x86_32_early_logical_apicid() for numaq_32
      x86: Replace apic->apicid_to_node() with ->x86_32_numa_cpu_node()
      x86: Unify cpu/apicid <-> NUMA node mapping between 32 and 64bit
      x86: Unify CPU -> NUMA node mapping between 32 and 64bit
      x86: Unify node_to_cpumask_map handling between 32 and 64bit
      x86: Unify NUMA initialization between 32 and 64bit
      x86: Fix build failure on X86_UP_APIC
      x86: Rename incorrectly named parameter of numa_cpu_node()
      x86-64, NUMA: Make dummy node initialization path similar to non-dummy ones
      x86-64, NUMA: Simplify hotplug node handling in acpi_numa_memory_affinity_init()
      x86, NUMA: Drop @start/last_pfn from initmem_init()
      x86-64, NUMA: Unify {acpi|amd}_{numa_init|scan_nodes}() arguments and return values
      x86-64, NUMA: Wrap acpi_numa_init() so that failure can be indicated by return value
      x86, NUMA: Move *_numa_init() invocations into initmem_init()
      x86-64, NUMA: Restructure initmem_init()
      x86-64, NUMA: Use common {cpu|mem}_nodes_parsed
      x86-64, NUMA: Remove local variable found from amd_numa_init()
      x86-64, NUMA: Move apicid to numa mapping initialization from amd_scan_nodes() to amd_numa_init()
      x86-64, NUMA: Use common numa_nodes[]
      x86-64, NUMA: Kill {acpi|amd}_get_nodes()
      x86-64, NUMA: Factor out memblk handling into numa_{add|register}_memblk()
      x86-64, NUMA: Unify use of memblk in all init methods
      x86-64, NUMA: Unify the rest of memblk registration
      x86-64, NUMA: Kill {acpi|amd|dummy}_scan_nodes()
      x86-64, NUMA: Remove %NULL @nodeids handling from compute_hash_shift()
      x86-64, NUMA: Introduce struct numa_meminfo
      x86-64, NUMA: Separate out numa_cleanup_meminfo()
      x86-64, NUMA: make numa_cleanup_meminfo() prettier
      x86-64, NUMA: consolidate and improve memblk sanity checks
      x86-64, NUMA: Add common find_node_by_addr()
      x86-64, NUMA: Kill numa_nodes[]
      x86-64, NUMA: Rename cpu_nodes_parsed to numa_nodes_parsed
      x86-64, NUMA: Kill mem_nodes_parsed
      x86-64, NUMA: Implement generic node distance handling
      x86-64, NUMA: Trivial changes to prepare for emulation updates
      x86-64, NUMA: Build and use direct emulated nid -> phys nid mapping
      x86-64, NUMA: Make emulation code build numa_meminfo and share the registration path
      x86-64, NUMA: Wrap node ID during emulation
      x86-64, NUMA: Emulate directly from numa_meminfo
      x86-64, NUMA: Unify emulated apicid -> node mapping transformation
      x86-64, NUMA: Unify emulated distance mapping
      x86-64, NUMA: Prepare numa_emulation() for moving NUMA emulation into a separate file
      x86-64, NUMA: Move NUMA emulation into numa_emulation.c
      x86-64, NUMA: Add proper function comments to global functions
      x86-64, NUMA: Better explain numa_distance handling
      x86-64, NUMA: Revert NUMA affine page table allocation
      x86-64, NUMA: Don't assume phys node 0 is always online in numa_emulation()
      x86-64, NUMA: Don't call numa_set_distanc() for all possible node combinations during emulation

Xiao Guangrong (1):
      x86, tlb, UV: Do small micro-optimization for native_flush_tlb_others()

Yinghai Lu (18):
      x86-64, mm: Put early page table high
      x86-64, gart: Fix allocation with memblock
      memblock: Make find_memory_core_early() find from top-down
      x86: Change get_max_mapped() to inline
      x86-64, numa: Allocate memnodemap under max_pfn_mapped
      x86-64, numa: Put pgtable to local node memory
      x86-64: Move out cleanup higmap [_brk_end, _end) out of init_memory_mapping()
      x86-64, NUMA: Don't call __pa() with invalid address in numa_reset_distance()
      x86-64, NUMA: Put dummy_numa_init() in the init section
      x86-64, NUMA: Do not scan two times for setup_node_bootmem()
      x86-64, NUMA: Seperate out numa_alloc_distance() from numa_set_distance()
      bootmem: Separate out CONFIG_NO_BOOTMEM code into nobootmem.c
      bootmem: Move contig_page_data definition to bootmem.c/nobootmem.c
      bootmem: Move __alloc_memory_core_early() to nobootmem.c
      x86: Rename e820_table_* to pgt_buf_*
      mm: Move early_node_map[] reverse scan helpers under HAVE_MEMBLOCK
      x86-64, NUMA: Fix distance table handling
      x86-64, NUMA: Fix numa_emulation code with node0 without RAM


 arch/x86/Kconfig                      |    2 +-
 arch/x86/include/asm/acpi.h           |   10 +-
 arch/x86/include/asm/amd_nb.h         |   14 +-
 arch/x86/include/asm/apic.h           |   36 +-
 arch/x86/include/asm/entry_arch.h     |    5 +-
 arch/x86/include/asm/hw_irq.h         |   24 +
 arch/x86/include/asm/init.h           |    6 +-
 arch/x86/include/asm/ipi.h            |    8 +-
 arch/x86/include/asm/irq_vectors.h    |   45 +-
 arch/x86/include/asm/mpspec.h         |    3 -
 arch/x86/include/asm/numa.h           |   52 ++
 arch/x86/include/asm/numa_32.h        |    7 +-
 arch/x86/include/asm/numa_64.h        |   23 +-
 arch/x86/include/asm/page_types.h     |    9 +-
 arch/x86/include/asm/smp.h            |    3 +
 arch/x86/include/asm/topology.h       |   19 +-
 arch/x86/kernel/acpi/boot.c           |    8 +-
 arch/x86/kernel/amd_nb.c              |   84 +++-
 arch/x86/kernel/aperture_64.c         |   33 +-
 arch/x86/kernel/apic/apic.c           |   37 ++-
 arch/x86/kernel/apic/apic_flat_64.c   |    4 -
 arch/x86/kernel/apic/apic_noop.c      |   26 +-
 arch/x86/kernel/apic/bigsmp_32.c      |   34 +-
 arch/x86/kernel/apic/es7000_32.c      |   35 +-
 arch/x86/kernel/apic/ipi.c            |   12 +-
 arch/x86/kernel/apic/numaq_32.c       |   21 +-
 arch/x86/kernel/apic/probe_32.c       |   10 +-
 arch/x86/kernel/apic/summit_32.c      |   47 +-
 arch/x86/kernel/apic/x2apic_cluster.c |    2 -
 arch/x86/kernel/apic/x2apic_phys.c    |    2 -
 arch/x86/kernel/apic/x2apic_uv_x.c    |    2 -
 arch/x86/kernel/cpu/amd.c             |   61 ++-
 arch/x86/kernel/cpu/common.c          |    2 +-
 arch/x86/kernel/cpu/intel.c           |    5 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c |   76 ++-
 arch/x86/kernel/e820.c                |   10 +-
 arch/x86/kernel/entry_64.S            |    5 +-
 arch/x86/kernel/irqinit.c             |   79 +++-
 arch/x86/kernel/setup.c               |   51 +-
 arch/x86/kernel/setup_percpu.c        |   11 +-
 arch/x86/kernel/smpboot.c             |   69 +---
 arch/x86/mm/Makefile                  |    1 +
 arch/x86/mm/amdtopology_64.c          |  142 +----
 arch/x86/mm/init.c                    |   56 +--
 arch/x86/mm/init_32.c                 |   11 +-
 arch/x86/mm/init_64.c                 |   72 +--
 arch/x86/mm/numa.c                    |  212 +++++++-
 arch/x86/mm/numa_32.c                 |   10 +-
 arch/x86/mm/numa_64.c                 |  984 ++++++++++++---------------------
 arch/x86/mm/numa_emulation.c          |  494 +++++++++++++++++
 arch/x86/mm/numa_internal.h           |   31 +
 arch/x86/mm/srat_32.c                 |    6 +-
 arch/x86/mm/srat_64.c                 |  367 +------------
 arch/x86/mm/tlb.c                     |   14 +-
 arch/x86/pci/amd_bus.c                |    2 +-
 arch/x86/xen/mmu.c                    |    2 +-
 drivers/acpi/numa.c                   |    9 +-
 include/linux/mm.h                    |    2 -
 include/linux/pci_ids.h               |    1 +
 mm/Makefile                           |    8 +-
 mm/bootmem.c                          |  180 +------
 mm/nobootmem.c                        |  435 +++++++++++++++
 mm/page_alloc.c                       |   71 ++--
 63 files changed, 2306 insertions(+), 1796 deletions(-)
 create mode 100644 arch/x86/mm/numa_emulation.c
 create mode 100644 arch/x86/mm/numa_internal.h
 create mode 100644 mm/nobootmem.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d5ed94d..95c36c4 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1705,7 +1705,7 @@ config HAVE_ARCH_EARLY_PFN_TO_NID
 	depends on NUMA
 
 config USE_PERCPU_NUMA_NODE_ID
-	def_bool X86_64
+	def_bool y
 	depends on NUMA
 
 menu "Power management and ACPI options"
diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index 4ea15ca..b964ec4 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -186,15 +186,7 @@ struct bootnode;
 
 #ifdef CONFIG_ACPI_NUMA
 extern int acpi_numa;
-extern void acpi_get_nodes(struct bootnode *physnodes, unsigned long start,
-				unsigned long end);
-extern int acpi_scan_nodes(unsigned long start, unsigned long end);
-#define NR_NODE_MEMBLKS (MAX_NUMNODES*2)
-
-#ifdef CONFIG_NUMA_EMU
-extern void acpi_fake_nodes(const struct bootnode *fake_nodes,
-				   int num_nodes);
-#endif
+extern int x86_acpi_numa_init(void);
 #endif /* CONFIG_ACPI_NUMA */
 
 #define acpi_unlazy_tlb(x)	leave_mm(x)
diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
index 64dc82e..e264ae5 100644
--- a/arch/x86/include/asm/amd_nb.h
+++ b/arch/x86/include/asm/amd_nb.h
@@ -9,23 +9,20 @@ struct amd_nb_bus_dev_range {
 	u8 dev_limit;
 };
 
-extern struct pci_device_id amd_nb_misc_ids[];
+extern const struct pci_device_id amd_nb_misc_ids[];
 extern const struct amd_nb_bus_dev_range amd_nb_bus_dev_ranges[];
 struct bootnode;
 
 extern int early_is_amd_nb(u32 value);
 extern int amd_cache_northbridges(void);
 extern void amd_flush_garts(void);
-extern int amd_numa_init(unsigned long start_pfn, unsigned long end_pfn);
-extern int amd_scan_nodes(void);
-
-#ifdef CONFIG_NUMA_EMU
-extern void amd_fake_nodes(const struct bootnode *nodes, int nr_nodes);
-extern void amd_get_nodes(struct bootnode *nodes);
-#endif
+extern int amd_numa_init(void);
+extern int amd_get_subcaches(int);
+extern int amd_set_subcaches(int, int);
 
 struct amd_northbridge {
 	struct pci_dev *misc;
+	struct pci_dev *link;
 };
 
 struct amd_northbridge_info {
@@ -37,6 +34,7 @@ extern struct amd_northbridge_info amd_northbridges;
 
 #define AMD_NB_GART			0x1
 #define AMD_NB_L3_INDEX_DISABLE		0x2
+#define AMD_NB_L3_PARTITIONING		0x4
 
 #ifdef CONFIG_AMD_NB
 
diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 3c89694..b8a3484 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -307,8 +307,6 @@ struct apic {
 
 	void (*setup_apic_routing)(void);
 	int (*multi_timer_check)(int apic, int irq);
-	int (*apicid_to_node)(int logical_apicid);
-	int (*cpu_to_logical_apicid)(int cpu);
 	int (*cpu_present_to_apicid)(int mps_cpu);
 	void (*apicid_to_cpu_present)(int phys_apicid, physid_mask_t *retmap);
 	void (*setup_portio_remap)(void);
@@ -356,6 +354,23 @@ struct apic {
 	void (*icr_write)(u32 low, u32 high);
 	void (*wait_icr_idle)(void);
 	u32 (*safe_wait_icr_idle)(void);
+
+#ifdef CONFIG_X86_32
+	/*
+	 * Called very early during boot from get_smp_config().  It should
+	 * return the logical apicid.  x86_[bios]_cpu_to_apicid is
+	 * initialized before this function is called.
+	 *
+	 * If logical apicid can't be determined that early, the function
+	 * may return BAD_APICID.  Logical apicid will be configured after
+	 * init_apic_ldr() while bringing up CPUs.  Note that NUMA affinity
+	 * won't be applied properly during early boot in this case.
+	 */
+	int (*x86_32_early_logical_apicid)(int cpu);
+
+	/* determine CPU -> NUMA node mapping */
+	int (*x86_32_numa_cpu_node)(int cpu);
+#endif
 };
 
 /*
@@ -503,6 +518,11 @@ extern struct apic apic_noop;
 
 extern struct apic apic_default;
 
+static inline int noop_x86_32_early_logical_apicid(int cpu)
+{
+	return BAD_APICID;
+}
+
 /*
  * Set up the logical destination ID.
  *
@@ -522,7 +542,7 @@ static inline int default_phys_pkg_id(int cpuid_apic, int index_msb)
 	return cpuid_apic >> index_msb;
 }
 
-extern int default_apicid_to_node(int logical_apicid);
+extern int default_x86_32_numa_cpu_node(int cpu);
 
 #endif
 
@@ -558,12 +578,6 @@ static inline void default_ioapic_phys_id_map(physid_mask_t *phys_map, physid_ma
 	*retmap = *phys_map;
 }
 
-/* Mapping from cpu number to logical apicid */
-static inline int default_cpu_to_logical_apicid(int cpu)
-{
-	return 1 << cpu;
-}
-
 static inline int __default_cpu_present_to_apicid(int mps_cpu)
 {
 	if (mps_cpu < nr_cpu_ids && cpu_present(mps_cpu))
@@ -596,8 +610,4 @@ extern int default_check_phys_apicid_present(int phys_apicid);
 
 #endif /* CONFIG_X86_LOCAL_APIC */
 
-#ifdef CONFIG_X86_32
-extern u8 cpu_2_logical_apicid[NR_CPUS];
-#endif
-
 #endif /* _ASM_X86_APIC_H */
diff --git a/arch/x86/include/asm/entry_arch.h b/arch/x86/include/asm/entry_arch.h
index 57650ab..1cd6d26 100644
--- a/arch/x86/include/asm/entry_arch.h
+++ b/arch/x86/include/asm/entry_arch.h
@@ -16,10 +16,13 @@ BUILD_INTERRUPT(call_function_single_interrupt,CALL_FUNCTION_SINGLE_VECTOR)
 BUILD_INTERRUPT(irq_move_cleanup_interrupt,IRQ_MOVE_CLEANUP_VECTOR)
 BUILD_INTERRUPT(reboot_interrupt,REBOOT_VECTOR)
 
-.irpc idx, "01234567"
+.irp idx,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15, \
+	16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
+.if NUM_INVALIDATE_TLB_VECTORS > \idx
 BUILD_INTERRUPT3(invalidate_interrupt\idx,
 		 (INVALIDATE_TLB_VECTOR_START)+\idx,
 		 smp_invalidate_interrupt)
+.endif
 .endr
 #endif
 
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 0274ec5..bb9efe8 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -45,6 +45,30 @@ extern void invalidate_interrupt4(void);
 extern void invalidate_interrupt5(void);
 extern void invalidate_interrupt6(void);
 extern void invalidate_interrupt7(void);
+extern void invalidate_interrupt8(void);
+extern void invalidate_interrupt9(void);
+extern void invalidate_interrupt10(void);
+extern void invalidate_interrupt11(void);
+extern void invalidate_interrupt12(void);
+extern void invalidate_interrupt13(void);
+extern void invalidate_interrupt14(void);
+extern void invalidate_interrupt15(void);
+extern void invalidate_interrupt16(void);
+extern void invalidate_interrupt17(void);
+extern void invalidate_interrupt18(void);
+extern void invalidate_interrupt19(void);
+extern void invalidate_interrupt20(void);
+extern void invalidate_interrupt21(void);
+extern void invalidate_interrupt22(void);
+extern void invalidate_interrupt23(void);
+extern void invalidate_interrupt24(void);
+extern void invalidate_interrupt25(void);
+extern void invalidate_interrupt26(void);
+extern void invalidate_interrupt27(void);
+extern void invalidate_interrupt28(void);
+extern void invalidate_interrupt29(void);
+extern void invalidate_interrupt30(void);
+extern void invalidate_interrupt31(void);
 
 extern void irq_move_cleanup_interrupt(void);
 extern void reboot_interrupt(void);
diff --git a/arch/x86/include/asm/init.h b/arch/x86/include/asm/init.h
index 36fb1a6..8dbe353 100644
--- a/arch/x86/include/asm/init.h
+++ b/arch/x86/include/asm/init.h
@@ -11,8 +11,8 @@ kernel_physical_mapping_init(unsigned long start,
 			     unsigned long page_size_mask);
 
 
-extern unsigned long __initdata e820_table_start;
-extern unsigned long __meminitdata e820_table_end;
-extern unsigned long __meminitdata e820_table_top;
+extern unsigned long __initdata pgt_buf_start;
+extern unsigned long __meminitdata pgt_buf_end;
+extern unsigned long __meminitdata pgt_buf_top;
 
 #endif /* _ASM_X86_INIT_32_H */
diff --git a/arch/x86/include/asm/ipi.h b/arch/x86/include/asm/ipi.h
index 0b72282..615fa90 100644
--- a/arch/x86/include/asm/ipi.h
+++ b/arch/x86/include/asm/ipi.h
@@ -123,10 +123,6 @@ extern void default_send_IPI_mask_sequence_phys(const struct cpumask *mask,
 						 int vector);
 extern void default_send_IPI_mask_allbutself_phys(const struct cpumask *mask,
 							 int vector);
-extern void default_send_IPI_mask_sequence_logical(const struct cpumask *mask,
-							 int vector);
-extern void default_send_IPI_mask_allbutself_logical(const struct cpumask *mask,
-							 int vector);
 
 /* Avoid include hell */
 #define NMI_VECTOR 0x02
@@ -150,6 +146,10 @@ static inline void __default_local_send_IPI_all(int vector)
 }
 
 #ifdef CONFIG_X86_32
+extern void default_send_IPI_mask_sequence_logical(const struct cpumask *mask,
+							 int vector);
+extern void default_send_IPI_mask_allbutself_logical(const struct cpumask *mask,
+							 int vector);
 extern void default_send_IPI_mask_logical(const struct cpumask *mask,
 						 int vector);
 extern void default_send_IPI_allbutself(int vector);
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 6af0894..6e976ee 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_X86_IRQ_VECTORS_H
 #define _ASM_X86_IRQ_VECTORS_H
 
+#include <linux/threads.h>
 /*
  * Linux IRQ vector layout.
  *
@@ -16,8 +17,8 @@
  *  Vectors   0 ...  31 : system traps and exceptions - hardcoded events
  *  Vectors  32 ... 127 : device interrupts
  *  Vector  128         : legacy int80 syscall interface
- *  Vectors 129 ... 237 : device interrupts
- *  Vectors 238 ... 255 : special interrupts
+ *  Vectors 129 ... INVALIDATE_TLB_VECTOR_START-1 : device interrupts
+ *  Vectors INVALIDATE_TLB_VECTOR_START ... 255 : special interrupts
  *
  * 64-bit x86 has per CPU IDT tables, 32-bit has one shared IDT table.
  *
@@ -96,37 +97,43 @@
 #define THRESHOLD_APIC_VECTOR		0xf9
 #define REBOOT_VECTOR			0xf8
 
-/* f0-f7 used for spreading out TLB flushes: */
-#define INVALIDATE_TLB_VECTOR_END	0xf7
-#define INVALIDATE_TLB_VECTOR_START	0xf0
-#define NUM_INVALIDATE_TLB_VECTORS	   8
-
-/*
- * Local APIC timer IRQ vector is on a different priority level,
- * to work around the 'lost local interrupt if more than 2 IRQ
- * sources per level' errata.
- */
-#define LOCAL_TIMER_VECTOR		0xef
-
 /*
  * Generic system vector for platform specific use
  */
-#define X86_PLATFORM_IPI_VECTOR		0xed
+#define X86_PLATFORM_IPI_VECTOR		0xf7
 
 /*
  * IRQ work vector:
  */
-#define IRQ_WORK_VECTOR			0xec
+#define IRQ_WORK_VECTOR			0xf6
 
-#define UV_BAU_MESSAGE			0xea
+#define UV_BAU_MESSAGE			0xf5
 
 /*
  * Self IPI vector for machine checks
  */
-#define MCE_SELF_VECTOR			0xeb
+#define MCE_SELF_VECTOR			0xf4
 
 /* Xen vector callback to receive events in a HVM domain */
-#define XEN_HVM_EVTCHN_CALLBACK		0xe9
+#define XEN_HVM_EVTCHN_CALLBACK		0xf3
+
+/*
+ * Local APIC timer IRQ vector is on a different priority level,
+ * to work around the 'lost local interrupt if more than 2 IRQ
+ * sources per level' errata.
+ */
+#define LOCAL_TIMER_VECTOR		0xef
+
+/* up to 32 vectors used for spreading out TLB flushes: */
+#if NR_CPUS <= 32
+# define NUM_INVALIDATE_TLB_VECTORS	(NR_CPUS)
+#else
+# define NUM_INVALIDATE_TLB_VECTORS	(32)
+#endif
+
+#define INVALIDATE_TLB_VECTOR_END	(0xee)
+#define INVALIDATE_TLB_VECTOR_START	\
+	(INVALIDATE_TLB_VECTOR_END-NUM_INVALIDATE_TLB_VECTORS+1)
 
 #define NR_VECTORS			 256
 
diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index 0c90dd9..9c7d95f 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -25,7 +25,6 @@ extern int pic_mode;
 #define MAX_IRQ_SOURCES		256
 
 extern unsigned int def_to_bigsmp;
-extern u8 apicid_2_node[];
 
 #ifdef CONFIG_X86_NUMAQ
 extern int mp_bus_id_to_node[MAX_MP_BUSSES];
@@ -33,8 +32,6 @@ extern int mp_bus_id_to_local[MAX_MP_BUSSES];
 extern int quad_local_to_mp_bus_id [NR_CPUS/4][4];
 #endif
 
-#define MAX_APICID		256
-
 #else /* CONFIG_X86_64: */
 
 #define MAX_MP_BUSSES		256
diff --git a/arch/x86/include/asm/numa.h b/arch/x86/include/asm/numa.h
index 27da400..3d4dab4 100644
--- a/arch/x86/include/asm/numa.h
+++ b/arch/x86/include/asm/numa.h
@@ -1,5 +1,57 @@
+#ifndef _ASM_X86_NUMA_H
+#define _ASM_X86_NUMA_H
+
+#include <asm/topology.h>
+#include <asm/apicdef.h>
+
+#ifdef CONFIG_NUMA
+
+#define NR_NODE_MEMBLKS		(MAX_NUMNODES*2)
+
+/*
+ * __apicid_to_node[] stores the raw mapping between physical apicid and
+ * node and is used to initialize cpu_to_node mapping.
+ *
+ * The mapping may be overridden by apic->numa_cpu_node() on 32bit and thus
+ * should be accessed by the accessors - set_apicid_to_node() and
+ * numa_cpu_node().
+ */
+extern s16 __apicid_to_node[MAX_LOCAL_APIC];
+
+static inline void set_apicid_to_node(int apicid, s16 node)
+{
+	__apicid_to_node[apicid] = node;
+}
+#else	/* CONFIG_NUMA */
+static inline void set_apicid_to_node(int apicid, s16 node)
+{
+}
+#endif	/* CONFIG_NUMA */
+
 #ifdef CONFIG_X86_32
 # include "numa_32.h"
 #else
 # include "numa_64.h"
 #endif
+
+#ifdef CONFIG_NUMA
+extern void __cpuinit numa_set_node(int cpu, int node);
+extern void __cpuinit numa_clear_node(int cpu);
+extern void __init numa_init_array(void);
+extern void __init init_cpu_to_node(void);
+extern void __cpuinit numa_add_cpu(int cpu);
+extern void __cpuinit numa_remove_cpu(int cpu);
+#else	/* CONFIG_NUMA */
+static inline void numa_set_node(int cpu, int node)	{ }
+static inline void numa_clear_node(int cpu)		{ }
+static inline void numa_init_array(void)		{ }
+static inline void init_cpu_to_node(void)		{ }
+static inline void numa_add_cpu(int cpu)		{ }
+static inline void numa_remove_cpu(int cpu)		{ }
+#endif	/* CONFIG_NUMA */
+
+#ifdef CONFIG_DEBUG_PER_CPU_MAPS
+struct cpumask __cpuinit *debug_cpumask_set_cpu(int cpu, int enable);
+#endif
+
+#endif	/* _ASM_X86_NUMA_H */
diff --git a/arch/x86/include/asm/numa_32.h b/arch/x86/include/asm/numa_32.h
index b0ef2b4..c6beed1 100644
--- a/arch/x86/include/asm/numa_32.h
+++ b/arch/x86/include/asm/numa_32.h
@@ -4,7 +4,12 @@
 extern int numa_off;
 
 extern int pxm_to_nid(int pxm);
-extern void numa_remove_cpu(int cpu);
+
+#ifdef CONFIG_NUMA
+extern int __cpuinit numa_cpu_node(int cpu);
+#else	/* CONFIG_NUMA */
+static inline int numa_cpu_node(int cpu)		{ return NUMA_NO_NODE; }
+#endif	/* CONFIG_NUMA */
 
 #ifdef CONFIG_HIGHMEM
 extern void set_highmem_pages_init(void);
diff --git a/arch/x86/include/asm/numa_64.h b/arch/x86/include/asm/numa_64.h
index 0493be3..344eb17 100644
--- a/arch/x86/include/asm/numa_64.h
+++ b/arch/x86/include/asm/numa_64.h
@@ -2,23 +2,16 @@
 #define _ASM_X86_NUMA_64_H
 
 #include <linux/nodemask.h>
-#include <asm/apicdef.h>
 
 struct bootnode {
 	u64 start;
 	u64 end;
 };
 
-extern int compute_hash_shift(struct bootnode *nodes, int numblks,
-			      int *nodeids);
-
 #define ZONE_ALIGN (1UL << (MAX_ORDER+PAGE_SHIFT))
 
-extern void numa_init_array(void);
 extern int numa_off;
 
-extern s16 apicid_to_node[MAX_LOCAL_APIC];
-
 extern unsigned long numa_free_all_bootmem(void);
 extern void setup_node_bootmem(int nodeid, unsigned long start,
 			       unsigned long end);
@@ -31,11 +24,11 @@ extern void setup_node_bootmem(int nodeid, unsigned long start,
  */
 #define NODE_MIN_SIZE (4*1024*1024)
 
-extern void __init init_cpu_to_node(void);
-extern void __cpuinit numa_set_node(int cpu, int node);
-extern void __cpuinit numa_clear_node(int cpu);
-extern void __cpuinit numa_add_cpu(int cpu);
-extern void __cpuinit numa_remove_cpu(int cpu);
+extern nodemask_t numa_nodes_parsed __initdata;
+
+extern int __cpuinit numa_cpu_node(int cpu);
+extern int __init numa_add_memblk(int nodeid, u64 start, u64 end);
+extern void __init numa_set_distance(int from, int to, int distance);
 
 #ifdef CONFIG_NUMA_EMU
 #define FAKE_NODE_MIN_SIZE	((u64)32 << 20)
@@ -43,11 +36,7 @@ extern void __cpuinit numa_remove_cpu(int cpu);
 void numa_emu_cmdline(char *);
 #endif /* CONFIG_NUMA_EMU */
 #else
-static inline void init_cpu_to_node(void)		{ }
-static inline void numa_set_node(int cpu, int node)	{ }
-static inline void numa_clear_node(int cpu)		{ }
-static inline void numa_add_cpu(int cpu, int node)	{ }
-static inline void numa_remove_cpu(int cpu)		{ }
+static inline int numa_cpu_node(int cpu)		{ return NUMA_NO_NODE; }
 #endif
 
 #endif /* _ASM_X86_NUMA_64_H */
diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
index 1df6621..bce688d 100644
--- a/arch/x86/include/asm/page_types.h
+++ b/arch/x86/include/asm/page_types.h
@@ -2,6 +2,7 @@
 #define _ASM_X86_PAGE_DEFS_H
 
 #include <linux/const.h>
+#include <linux/types.h>
 
 /* PAGE_SHIFT determines the page size */
 #define PAGE_SHIFT	12
@@ -45,11 +46,15 @@ extern int devmem_is_allowed(unsigned long pagenr);
 extern unsigned long max_low_pfn_mapped;
 extern unsigned long max_pfn_mapped;
 
+static inline phys_addr_t get_max_mapped(void)
+{
+	return (phys_addr_t)max_pfn_mapped << PAGE_SHIFT;
+}
+
 extern unsigned long init_memory_mapping(unsigned long start,
 					 unsigned long end);
 
-extern void initmem_init(unsigned long start_pfn, unsigned long end_pfn,
-				int acpi, int k8);
+extern void initmem_init(void);
 extern void free_initmem(void);
 
 #endif	/* !__ASSEMBLY__ */
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 1f46951..b296ca6 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -38,6 +38,9 @@ static inline struct cpumask *cpu_core_mask(int cpu)
 
 DECLARE_EARLY_PER_CPU(u16, x86_cpu_to_apicid);
 DECLARE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid);
+#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86_32)
+DECLARE_EARLY_PER_CPU(int, x86_cpu_to_logical_apicid);
+#endif
 
 /* Static state in head.S used to set up a CPU */
 extern unsigned long stack_start; /* Initial stack pointer address */
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 21899cc3..910a708 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -47,21 +47,6 @@
 
 #include <asm/mpspec.h>
 
-#ifdef CONFIG_X86_32
-
-/* Mappings between logical cpu number and node number */
-extern int cpu_to_node_map[];
-
-/* Returns the number of the node containing CPU 'cpu' */
-static inline int __cpu_to_node(int cpu)
-{
-	return cpu_to_node_map[cpu];
-}
-#define early_cpu_to_node __cpu_to_node
-#define cpu_to_node __cpu_to_node
-
-#else /* CONFIG_X86_64 */
-
 /* Mappings between logical cpu number and node number */
 DECLARE_EARLY_PER_CPU(int, x86_cpu_to_node_map);
 
@@ -84,8 +69,6 @@ static inline int early_cpu_to_node(int cpu)
 
 #endif /* !CONFIG_DEBUG_PER_CPU_MAPS */
 
-#endif /* CONFIG_X86_64 */
-
 /* Mappings between node number and cpus on that node. */
 extern cpumask_var_t node_to_cpumask_map[MAX_NUMNODES];
 
@@ -155,7 +138,7 @@ extern unsigned long node_remap_size[];
 	.balance_interval	= 1,					\
 }
 
-#ifdef CONFIG_X86_64_ACPI_NUMA
+#ifdef CONFIG_X86_64
 extern int __node_distance(int, int);
 #define node_distance(a, b) __node_distance(a, b)
 #endif
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 3e6e2d6..9a966c5 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -595,14 +595,8 @@ static void acpi_map_cpu2node(acpi_handle handle, int cpu, int physid)
 	nid = acpi_get_node(handle);
 	if (nid == -1 || !node_online(nid))
 		return;
-#ifdef CONFIG_X86_64
-	apicid_to_node[physid] = nid;
+	set_apicid_to_node(physid, nid);
 	numa_set_node(cpu, nid);
-#else /* CONFIG_X86_32 */
-	apicid_2_node[physid] = nid;
-	cpu_to_node_map[cpu] = nid;
-#endif
-
 #endif
 }
 
diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index 0a99f71..ed3c2e5 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -12,7 +12,7 @@
 
 static u32 *flush_words;
 
-struct pci_device_id amd_nb_misc_ids[] = {
+const struct pci_device_id amd_nb_misc_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB_MISC) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_MISC) },
@@ -20,6 +20,11 @@ struct pci_device_id amd_nb_misc_ids[] = {
 };
 EXPORT_SYMBOL(amd_nb_misc_ids);
 
+static struct pci_device_id amd_nb_link_ids[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_LINK) },
+	{}
+};
+
 const struct amd_nb_bus_dev_range amd_nb_bus_dev_ranges[] __initconst = {
 	{ 0x00, 0x18, 0x20 },
 	{ 0xff, 0x00, 0x20 },
@@ -31,7 +36,7 @@ struct amd_northbridge_info amd_northbridges;
 EXPORT_SYMBOL(amd_northbridges);
 
 static struct pci_dev *next_northbridge(struct pci_dev *dev,
-					struct pci_device_id *ids)
+					const struct pci_device_id *ids)
 {
 	do {
 		dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev);
@@ -45,7 +50,7 @@ int amd_cache_northbridges(void)
 {
 	int i = 0;
 	struct amd_northbridge *nb;
-	struct pci_dev *misc;
+	struct pci_dev *misc, *link;
 
 	if (amd_nb_num())
 		return 0;
@@ -64,10 +69,12 @@ int amd_cache_northbridges(void)
 	amd_northbridges.nb = nb;
 	amd_northbridges.num = i;
 
-	misc = NULL;
+	link = misc = NULL;
 	for (i = 0; i != amd_nb_num(); i++) {
 		node_to_amd_nb(i)->misc = misc =
 			next_northbridge(misc, amd_nb_misc_ids);
+		node_to_amd_nb(i)->link = link =
+			next_northbridge(link, amd_nb_link_ids);
         }
 
 	/* some CPU families (e.g. family 0x11) do not support GART */
@@ -85,6 +92,13 @@ int amd_cache_northbridges(void)
 	     boot_cpu_data.x86_mask >= 0x1))
 		amd_northbridges.flags |= AMD_NB_L3_INDEX_DISABLE;
 
+	if (boot_cpu_data.x86 == 0x15)
+		amd_northbridges.flags |= AMD_NB_L3_INDEX_DISABLE;
+
+	/* L3 cache partitioning is supported on family 0x15 */
+	if (boot_cpu_data.x86 == 0x15)
+		amd_northbridges.flags |= AMD_NB_L3_PARTITIONING;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(amd_cache_northbridges);
@@ -93,8 +107,9 @@ EXPORT_SYMBOL_GPL(amd_cache_northbridges);
    they're useless anyways */
 int __init early_is_amd_nb(u32 device)
 {
-	struct pci_device_id *id;
+	const struct pci_device_id *id;
 	u32 vendor = device & 0xffff;
+
 	device >>= 16;
 	for (id = amd_nb_misc_ids; id->vendor; id++)
 		if (vendor == id->vendor && device == id->device)
@@ -102,6 +117,65 @@ int __init early_is_amd_nb(u32 device)
 	return 0;
 }
 
+int amd_get_subcaches(int cpu)
+{
+	struct pci_dev *link = node_to_amd_nb(amd_get_nb_id(cpu))->link;
+	unsigned int mask;
+	int cuid = 0;
+
+	if (!amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
+		return 0;
+
+	pci_read_config_dword(link, 0x1d4, &mask);
+
+#ifdef CONFIG_SMP
+	cuid = cpu_data(cpu).compute_unit_id;
+#endif
+	return (mask >> (4 * cuid)) & 0xf;
+}
+
+int amd_set_subcaches(int cpu, int mask)
+{
+	static unsigned int reset, ban;
+	struct amd_northbridge *nb = node_to_amd_nb(amd_get_nb_id(cpu));
+	unsigned int reg;
+	int cuid = 0;
+
+	if (!amd_nb_has_feature(AMD_NB_L3_PARTITIONING) || mask > 0xf)
+		return -EINVAL;
+
+	/* if necessary, collect reset state of L3 partitioning and BAN mode */
+	if (reset == 0) {
+		pci_read_config_dword(nb->link, 0x1d4, &reset);
+		pci_read_config_dword(nb->misc, 0x1b8, &ban);
+		ban &= 0x180000;
+	}
+
+	/* deactivate BAN mode if any subcaches are to be disabled */
+	if (mask != 0xf) {
+		pci_read_config_dword(nb->misc, 0x1b8, &reg);
+		pci_write_config_dword(nb->misc, 0x1b8, reg & ~0x180000);
+	}
+
+#ifdef CONFIG_SMP
+	cuid = cpu_data(cpu).compute_unit_id;
+#endif
+	mask <<= 4 * cuid;
+	mask |= (0xf ^ (1 << cuid)) << 26;
+
+	pci_write_config_dword(nb->link, 0x1d4, mask);
+
+	/* reset BAN mode if L3 partitioning returned to reset state */
+	pci_read_config_dword(nb->link, 0x1d4, &reg);
+	if (reg == reset) {
+		pci_read_config_dword(nb->misc, 0x1b8, &reg);
+		reg &= ~0x180000;
+		pci_write_config_dword(nb->misc, 0x1b8, reg | ban);
+	}
+
+	return 0;
+}
+
 int amd_cache_gart(void)
 {
        int i;
diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 5955a78..7b1e8e1 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -13,7 +13,7 @@
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/init.h>
-#include <linux/bootmem.h>
+#include <linux/memblock.h>
 #include <linux/mmzone.h>
 #include <linux/pci_ids.h>
 #include <linux/pci.h>
@@ -57,7 +57,7 @@ static void __init insert_aperture_resource(u32 aper_base, u32 aper_size)
 static u32 __init allocate_aperture(void)
 {
 	u32 aper_size;
-	void *p;
+	unsigned long addr;
 
 	/* aper_size should <= 1G */
 	if (fallback_aper_order > 5)
@@ -83,27 +83,26 @@ static u32 __init allocate_aperture(void)
 	 * so don't use 512M below as gart iommu, leave the space for kernel
 	 * code for safe
 	 */
-	p = __alloc_bootmem_nopanic(aper_size, aper_size, 512ULL<<20);
+	addr = memblock_find_in_range(0, 1ULL<<32, aper_size, 512ULL<<20);
+	if (addr == MEMBLOCK_ERROR || addr + aper_size > 0xffffffff) {
+		printk(KERN_ERR
+			"Cannot allocate aperture memory hole (%lx,%uK)\n",
+				addr, aper_size>>10);
+		return 0;
+	}
+	memblock_x86_reserve_range(addr, addr + aper_size, "aperture64");
 	/*
 	 * Kmemleak should not scan this block as it may not be mapped via the
 	 * kernel direct mapping.
 	 */
-	kmemleak_ignore(p);
-	if (!p || __pa(p)+aper_size > 0xffffffff) {
-		printk(KERN_ERR
-			"Cannot allocate aperture memory hole (%p,%uK)\n",
-				p, aper_size>>10);
-		if (p)
-			free_bootmem(__pa(p), aper_size);
-		return 0;
-	}
+	kmemleak_ignore(phys_to_virt(addr));
 	printk(KERN_INFO "Mapping aperture over %d KB of RAM @ %lx\n",
-			aper_size >> 10, __pa(p));
-	insert_aperture_resource((u32)__pa(p), aper_size);
-	register_nosave_region((u32)__pa(p) >> PAGE_SHIFT,
-				(u32)__pa(p+aper_size) >> PAGE_SHIFT);
+			aper_size >> 10, addr);
+	insert_aperture_resource((u32)addr, aper_size);
+	register_nosave_region(addr >> PAGE_SHIFT,
+			       (addr+aper_size) >> PAGE_SHIFT);
 
-	return (u32)__pa(p);
+	return (u32)addr;
 }
 
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 76b96d7..306386f 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -78,6 +78,15 @@ EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_apicid);
 EXPORT_EARLY_PER_CPU_SYMBOL(x86_bios_cpu_apicid);
 
 #ifdef CONFIG_X86_32
+
+/*
+ * On x86_32, the mapping between cpu and logical apicid may vary
+ * depending on apic in use.  The following early percpu variable is
+ * used for the mapping.  This is where the behaviors of x86_64 and 32
+ * actually diverge.  Let's keep it ugly for now.
+ */
+DEFINE_EARLY_PER_CPU(int, x86_cpu_to_logical_apicid, BAD_APICID);
+
 /*
  * Knob to control our willingness to enable the local APIC.
  *
@@ -1237,6 +1246,19 @@ void __cpuinit setup_local_APIC(void)
 	 */
 	apic->init_apic_ldr();
 
+#ifdef CONFIG_X86_32
+	/*
+	 * APIC LDR is initialized.  If logical_apicid mapping was
+	 * initialized during get_smp_config(), make sure it matches the
+	 * actual value.
+	 */
+	i = early_per_cpu(x86_cpu_to_logical_apicid, cpu);
+	WARN_ON(i != BAD_APICID && i != logical_smp_processor_id());
+	/* always use the value from LDR */
+	early_per_cpu(x86_cpu_to_logical_apicid, cpu) =
+		logical_smp_processor_id();
+#endif
+
 	/*
 	 * Set Task Priority to 'accept all'. We never change this
 	 * later on.
@@ -1977,7 +1999,10 @@ void __cpuinit generic_processor_info(int apicid, int version)
 	early_per_cpu(x86_cpu_to_apicid, cpu) = apicid;
 	early_per_cpu(x86_bios_cpu_apicid, cpu) = apicid;
 #endif
-
+#ifdef CONFIG_X86_32
+	early_per_cpu(x86_cpu_to_logical_apicid, cpu) =
+		apic->x86_32_early_logical_apicid(cpu);
+#endif
 	set_cpu_possible(cpu, true);
 	set_cpu_present(cpu, true);
 }
@@ -1998,10 +2023,14 @@ void default_init_apic_ldr(void)
 }
 
 #ifdef CONFIG_X86_32
-int default_apicid_to_node(int logical_apicid)
+int default_x86_32_numa_cpu_node(int cpu)
 {
-#ifdef CONFIG_SMP
-	return apicid_2_node[hard_smp_processor_id()];
+#ifdef CONFIG_NUMA
+	int apicid = early_per_cpu(x86_cpu_to_apicid, cpu);
+
+	if (apicid != BAD_APICID)
+		return __apicid_to_node[apicid];
+	return NUMA_NO_NODE;
 #else
 	return 0;
 #endif
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index 09d3b17..5652d31 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -185,8 +185,6 @@ struct apic apic_flat =  {
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
 	.multi_timer_check		= NULL,
-	.apicid_to_node			= NULL,
-	.cpu_to_logical_apicid		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.setup_portio_remap		= NULL,
@@ -337,8 +335,6 @@ struct apic apic_physflat =  {
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
 	.multi_timer_check		= NULL,
-	.apicid_to_node			= NULL,
-	.cpu_to_logical_apicid		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.setup_portio_remap		= NULL,
diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
index e31b9ff..f1baa2d 100644
--- a/arch/x86/kernel/apic/apic_noop.c
+++ b/arch/x86/kernel/apic/apic_noop.c
@@ -54,11 +54,6 @@ static u64 noop_apic_icr_read(void)
 	return 0;
 }
 
-static int noop_cpu_to_logical_apicid(int cpu)
-{
-	return 0;
-}
-
 static int noop_phys_pkg_id(int cpuid_apic, int index_msb)
 {
 	return 0;
@@ -113,12 +108,6 @@ static void noop_vector_allocation_domain(int cpu, struct cpumask *retmask)
 	cpumask_set_cpu(cpu, retmask);
 }
 
-int noop_apicid_to_node(int logical_apicid)
-{
-	/* we're always on node 0 */
-	return 0;
-}
-
 static u32 noop_apic_read(u32 reg)
 {
 	WARN_ON_ONCE((cpu_has_apic && !disable_apic));
@@ -130,6 +119,14 @@ static void noop_apic_write(u32 reg, u32 v)
 	WARN_ON_ONCE(cpu_has_apic && !disable_apic);
 }
 
+#ifdef CONFIG_X86_32
+static int noop_x86_32_numa_cpu_node(int cpu)
+{
+	/* we're always on node 0 */
+	return 0;
+}
+#endif
+
 struct apic apic_noop = {
 	.name				= "noop",
 	.probe				= noop_probe,
@@ -153,9 +150,7 @@ struct apic apic_noop = {
 	.ioapic_phys_id_map		= default_ioapic_phys_id_map,
 	.setup_apic_routing		= NULL,
 	.multi_timer_check		= NULL,
-	.apicid_to_node			= noop_apicid_to_node,
 
-	.cpu_to_logical_apicid		= noop_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= physid_set_mask_of_physid,
 
@@ -197,4 +192,9 @@ struct apic apic_noop = {
 	.icr_write			= noop_apic_icr_write,
 	.wait_icr_idle			= noop_apic_wait_icr_idle,
 	.safe_wait_icr_idle		= noop_safe_apic_wait_icr_idle,
+
+#ifdef CONFIG_X86_32
+	.x86_32_early_logical_apicid	= noop_x86_32_early_logical_apicid,
+	.x86_32_numa_cpu_node		= noop_x86_32_numa_cpu_node,
+#endif
 };
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
index cb804c5..541a2e4 100644
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -45,6 +45,12 @@ static unsigned long bigsmp_check_apicid_present(int bit)
 	return 1;
 }
 
+static int bigsmp_early_logical_apicid(int cpu)
+{
+	/* on bigsmp, logical apicid is the same as physical */
+	return early_per_cpu(x86_cpu_to_apicid, cpu);
+}
+
 static inline unsigned long calculate_ldr(int cpu)
 {
 	unsigned long val, id;
@@ -80,11 +86,6 @@ static void bigsmp_setup_apic_routing(void)
 		nr_ioapics);
 }
 
-static int bigsmp_apicid_to_node(int logical_apicid)
-{
-	return apicid_2_node[hard_smp_processor_id()];
-}
-
 static int bigsmp_cpu_present_to_apicid(int mps_cpu)
 {
 	if (mps_cpu < nr_cpu_ids)
@@ -93,14 +94,6 @@ static int bigsmp_cpu_present_to_apicid(int mps_cpu)
 	return BAD_APICID;
 }
 
-/* Mapping from cpu number to logical apicid */
-static inline int bigsmp_cpu_to_logical_apicid(int cpu)
-{
-	if (cpu >= nr_cpu_ids)
-		return BAD_APICID;
-	return cpu_physical_id(cpu);
-}
-
 static void bigsmp_ioapic_phys_id_map(physid_mask_t *phys_map, physid_mask_t *retmap)
 {
 	/* For clustered we don't have a good way to do this yet - hack */
@@ -115,7 +108,11 @@ static int bigsmp_check_phys_apicid_present(int phys_apicid)
 /* As we are using single CPU as destination, pick only one CPU here */
 static unsigned int bigsmp_cpu_mask_to_apicid(const struct cpumask *cpumask)
 {
-	return bigsmp_cpu_to_logical_apicid(cpumask_first(cpumask));
+	int cpu = cpumask_first(cpumask);
+
+	if (cpu < nr_cpu_ids)
+		return cpu_physical_id(cpu);
+	return BAD_APICID;
 }
 
 static unsigned int bigsmp_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
@@ -129,9 +126,9 @@ static unsigned int bigsmp_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 	 */
 	for_each_cpu_and(cpu, cpumask, andmask) {
 		if (cpumask_test_cpu(cpu, cpu_online_mask))
-			break;
+			return cpu_physical_id(cpu);
 	}
-	return bigsmp_cpu_to_logical_apicid(cpu);
+	return BAD_APICID;
 }
 
 static int bigsmp_phys_pkg_id(int cpuid_apic, int index_msb)
@@ -219,8 +216,6 @@ struct apic apic_bigsmp = {
 	.ioapic_phys_id_map		= bigsmp_ioapic_phys_id_map,
 	.setup_apic_routing		= bigsmp_setup_apic_routing,
 	.multi_timer_check		= NULL,
-	.apicid_to_node			= bigsmp_apicid_to_node,
-	.cpu_to_logical_apicid		= bigsmp_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= bigsmp_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= physid_set_mask_of_physid,
 	.setup_portio_remap		= NULL,
@@ -256,4 +251,7 @@ struct apic apic_bigsmp = {
 	.icr_write			= native_apic_icr_write,
 	.wait_icr_idle			= native_apic_wait_icr_idle,
 	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
+
+	.x86_32_early_logical_apicid	= bigsmp_early_logical_apicid,
+	.x86_32_numa_cpu_node		= default_x86_32_numa_cpu_node,
 };
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 8593582..3e9de48 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -460,6 +460,12 @@ static unsigned long es7000_check_apicid_present(int bit)
 	return physid_isset(bit, phys_cpu_present_map);
 }
 
+static int es7000_early_logical_apicid(int cpu)
+{
+	/* on es7000, logical apicid is the same as physical */
+	return early_per_cpu(x86_bios_cpu_apicid, cpu);
+}
+
 static unsigned long calculate_ldr(int cpu)
 {
 	unsigned long id = per_cpu(x86_bios_cpu_apicid, cpu);
@@ -504,12 +510,11 @@ static void es7000_setup_apic_routing(void)
 		nr_ioapics, cpumask_bits(es7000_target_cpus())[0]);
 }
 
-static int es7000_apicid_to_node(int logical_apicid)
+static int es7000_numa_cpu_node(int cpu)
 {
 	return 0;
 }
 
-
 static int es7000_cpu_present_to_apicid(int mps_cpu)
 {
 	if (!mps_cpu)
@@ -528,18 +533,6 @@ static void es7000_apicid_to_cpu_present(int phys_apicid, physid_mask_t *retmap)
 	++cpu_id;
 }
 
-/* Mapping from cpu number to logical apicid */
-static int es7000_cpu_to_logical_apicid(int cpu)
-{
-#ifdef CONFIG_SMP
-	if (cpu >= nr_cpu_ids)
-		return BAD_APICID;
-	return cpu_2_logical_apicid[cpu];
-#else
-	return logical_smp_processor_id();
-#endif
-}
-
 static void es7000_ioapic_phys_id_map(physid_mask_t *phys_map, physid_mask_t *retmap)
 {
 	/* For clustered we don't have a good way to do this yet - hack */
@@ -561,7 +554,7 @@ static unsigned int es7000_cpu_mask_to_apicid(const struct cpumask *cpumask)
 	 * The cpus in the mask must all be on the apic cluster.
 	 */
 	for_each_cpu(cpu, cpumask) {
-		int new_apicid = es7000_cpu_to_logical_apicid(cpu);
+		int new_apicid = early_per_cpu(x86_cpu_to_logical_apicid, cpu);
 
 		if (round && APIC_CLUSTER(apicid) != APIC_CLUSTER(new_apicid)) {
 			WARN(1, "Not a valid mask!");
@@ -578,7 +571,7 @@ static unsigned int
 es7000_cpu_mask_to_apicid_and(const struct cpumask *inmask,
 			      const struct cpumask *andmask)
 {
-	int apicid = es7000_cpu_to_logical_apicid(0);
+	int apicid = early_per_cpu(x86_cpu_to_logical_apicid, 0);
 	cpumask_var_t cpumask;
 
 	if (!alloc_cpumask_var(&cpumask, GFP_ATOMIC))
@@ -655,8 +648,6 @@ struct apic __refdata apic_es7000_cluster = {
 	.ioapic_phys_id_map		= es7000_ioapic_phys_id_map,
 	.setup_apic_routing		= es7000_setup_apic_routing,
 	.multi_timer_check		= NULL,
-	.apicid_to_node			= es7000_apicid_to_node,
-	.cpu_to_logical_apicid		= es7000_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= es7000_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= es7000_apicid_to_cpu_present,
 	.setup_portio_remap		= NULL,
@@ -695,6 +686,9 @@ struct apic __refdata apic_es7000_cluster = {
 	.icr_write			= native_apic_icr_write,
 	.wait_icr_idle			= native_apic_wait_icr_idle,
 	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
+
+	.x86_32_early_logical_apicid	= es7000_early_logical_apicid,
+	.x86_32_numa_cpu_node		= es7000_numa_cpu_node,
 };
 
 struct apic __refdata apic_es7000 = {
@@ -720,8 +714,6 @@ struct apic __refdata apic_es7000 = {
 	.ioapic_phys_id_map		= es7000_ioapic_phys_id_map,
 	.setup_apic_routing		= es7000_setup_apic_routing,
 	.multi_timer_check		= NULL,
-	.apicid_to_node			= es7000_apicid_to_node,
-	.cpu_to_logical_apicid		= es7000_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= es7000_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= es7000_apicid_to_cpu_present,
 	.setup_portio_remap		= NULL,
@@ -758,4 +750,7 @@ struct apic __refdata apic_es7000 = {
 	.icr_write			= native_apic_icr_write,
 	.wait_icr_idle			= native_apic_wait_icr_idle,
 	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
+
+	.x86_32_early_logical_apicid	= es7000_early_logical_apicid,
+	.x86_32_numa_cpu_node		= es7000_numa_cpu_node,
 };
diff --git a/arch/x86/kernel/apic/ipi.c b/arch/x86/kernel/apic/ipi.c
index 08385e0..cce91bf 100644
--- a/arch/x86/kernel/apic/ipi.c
+++ b/arch/x86/kernel/apic/ipi.c
@@ -56,6 +56,8 @@ void default_send_IPI_mask_allbutself_phys(const struct cpumask *mask,
 	local_irq_restore(flags);
 }
 
+#ifdef CONFIG_X86_32
+
 void default_send_IPI_mask_sequence_logical(const struct cpumask *mask,
 						 int vector)
 {
@@ -71,8 +73,8 @@ void default_send_IPI_mask_sequence_logical(const struct cpumask *mask,
 	local_irq_save(flags);
 	for_each_cpu(query_cpu, mask)
 		__default_send_IPI_dest_field(
-			apic->cpu_to_logical_apicid(query_cpu), vector,
-			apic->dest_logical);
+			early_per_cpu(x86_cpu_to_logical_apicid, query_cpu),
+			vector, apic->dest_logical);
 	local_irq_restore(flags);
 }
 
@@ -90,14 +92,12 @@ void default_send_IPI_mask_allbutself_logical(const struct cpumask *mask,
 		if (query_cpu == this_cpu)
 			continue;
 		__default_send_IPI_dest_field(
-			apic->cpu_to_logical_apicid(query_cpu), vector,
-			apic->dest_logical);
+			early_per_cpu(x86_cpu_to_logical_apicid, query_cpu),
+			vector, apic->dest_logical);
 		}
 	local_irq_restore(flags);
 }
 
-#ifdef CONFIG_X86_32
-
 /*
  * This is only used on smaller machines.
  */
diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index 960f26a..6273eee 100644
--- a/arch/x86/kernel/apic/numaq_32.c
+++ b/arch/x86/kernel/apic/numaq_32.c
@@ -373,13 +373,6 @@ static inline void numaq_ioapic_phys_id_map(physid_mask_t *phys_map, physid_mask
 	return physids_promote(0xFUL, retmap);
 }
 
-static inline int numaq_cpu_to_logical_apicid(int cpu)
-{
-	if (cpu >= nr_cpu_ids)
-		return BAD_APICID;
-	return cpu_2_logical_apicid[cpu];
-}
-
 /*
  * Supporting over 60 cpus on NUMA-Q requires a locality-dependent
  * cpu to APIC ID relation to properly interact with the intelligent
@@ -398,6 +391,15 @@ static inline int numaq_apicid_to_node(int logical_apicid)
 	return logical_apicid >> 4;
 }
 
+static int numaq_numa_cpu_node(int cpu)
+{
+	int logical_apicid = early_per_cpu(x86_cpu_to_logical_apicid, cpu);
+
+	if (logical_apicid != BAD_APICID)
+		return numaq_apicid_to_node(logical_apicid);
+	return NUMA_NO_NODE;
+}
+
 static void numaq_apicid_to_cpu_present(int logical_apicid, physid_mask_t *retmap)
 {
 	int node = numaq_apicid_to_node(logical_apicid);
@@ -508,8 +510,6 @@ struct apic __refdata apic_numaq = {
 	.ioapic_phys_id_map		= numaq_ioapic_phys_id_map,
 	.setup_apic_routing		= numaq_setup_apic_routing,
 	.multi_timer_check		= numaq_multi_timer_check,
-	.apicid_to_node			= numaq_apicid_to_node,
-	.cpu_to_logical_apicid		= numaq_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= numaq_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= numaq_apicid_to_cpu_present,
 	.setup_portio_remap		= numaq_setup_portio_remap,
@@ -547,4 +547,7 @@ struct apic __refdata apic_numaq = {
 	.icr_write			= native_apic_icr_write,
 	.wait_icr_idle			= native_apic_wait_icr_idle,
 	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
+
+	.x86_32_early_logical_apicid	= noop_x86_32_early_logical_apicid,
+	.x86_32_numa_cpu_node		= numaq_numa_cpu_node,
 };
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index 99d2fe0..fc84c7b 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -77,6 +77,11 @@ void __init default_setup_apic_routing(void)
 		apic->setup_apic_routing();
 }
 
+static int default_x86_32_early_logical_apicid(int cpu)
+{
+	return 1 << cpu;
+}
+
 static void setup_apic_flat_routing(void)
 {
 #ifdef CONFIG_X86_IO_APIC
@@ -130,8 +135,6 @@ struct apic apic_default = {
 	.ioapic_phys_id_map		= default_ioapic_phys_id_map,
 	.setup_apic_routing		= setup_apic_flat_routing,
 	.multi_timer_check		= NULL,
-	.apicid_to_node			= default_apicid_to_node,
-	.cpu_to_logical_apicid		= default_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= physid_set_mask_of_physid,
 	.setup_portio_remap		= NULL,
@@ -167,6 +170,9 @@ struct apic apic_default = {
 	.icr_write			= native_apic_icr_write,
 	.wait_icr_idle			= native_apic_wait_icr_idle,
 	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
+
+	.x86_32_early_logical_apicid	= default_x86_32_early_logical_apicid,
+	.x86_32_numa_cpu_node		= default_x86_32_numa_cpu_node,
 };
 
 extern struct apic apic_numaq;
diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index 9b41926..e4b8059 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -194,11 +194,10 @@ static unsigned long summit_check_apicid_present(int bit)
 	return 1;
 }
 
-static void summit_init_apic_ldr(void)
+static int summit_early_logical_apicid(int cpu)
 {
-	unsigned long val, id;
 	int count = 0;
-	u8 my_id = (u8)hard_smp_processor_id();
+	u8 my_id = early_per_cpu(x86_cpu_to_apicid, cpu);
 	u8 my_cluster = APIC_CLUSTER(my_id);
 #ifdef CONFIG_SMP
 	u8 lid;
@@ -206,7 +205,7 @@ static void summit_init_apic_ldr(void)
 
 	/* Create logical APIC IDs by counting CPUs already in cluster. */
 	for (count = 0, i = nr_cpu_ids; --i >= 0; ) {
-		lid = cpu_2_logical_apicid[i];
+		lid = early_per_cpu(x86_cpu_to_logical_apicid, i);
 		if (lid != BAD_APICID && APIC_CLUSTER(lid) == my_cluster)
 			++count;
 	}
@@ -214,7 +213,15 @@ static void summit_init_apic_ldr(void)
 	/* We only have a 4 wide bitmap in cluster mode.  If a deranged
 	 * BIOS puts 5 CPUs in one APIC cluster, we're hosed. */
 	BUG_ON(count >= XAPIC_DEST_CPUS_SHIFT);
-	id = my_cluster | (1UL << count);
+	return my_cluster | (1UL << count);
+}
+
+static void summit_init_apic_ldr(void)
+{
+	int cpu = smp_processor_id();
+	unsigned long id = early_per_cpu(x86_cpu_to_logical_apicid, cpu);
+	unsigned long val;
+
 	apic_write(APIC_DFR, SUMMIT_APIC_DFR_VALUE);
 	val = apic_read(APIC_LDR) & ~APIC_LDR_MASK;
 	val |= SET_APIC_LOGICAL_ID(id);
@@ -232,27 +239,6 @@ static void summit_setup_apic_routing(void)
 						nr_ioapics);
 }
 
-static int summit_apicid_to_node(int logical_apicid)
-{
-#ifdef CONFIG_SMP
-	return apicid_2_node[hard_smp_processor_id()];
-#else
-	return 0;
-#endif
-}
-
-/* Mapping from cpu number to logical apicid */
-static inline int summit_cpu_to_logical_apicid(int cpu)
-{
-#ifdef CONFIG_SMP
-	if (cpu >= nr_cpu_ids)
-		return BAD_APICID;
-	return cpu_2_logical_apicid[cpu];
-#else
-	return logical_smp_processor_id();
-#endif
-}
-
 static int summit_cpu_present_to_apicid(int mps_cpu)
 {
 	if (mps_cpu < nr_cpu_ids)
@@ -286,7 +272,7 @@ static unsigned int summit_cpu_mask_to_apicid(const struct cpumask *cpumask)
 	 * The cpus in the mask must all be on the apic cluster.
 	 */
 	for_each_cpu(cpu, cpumask) {
-		int new_apicid = summit_cpu_to_logical_apicid(cpu);
+		int new_apicid = early_per_cpu(x86_cpu_to_logical_apicid, cpu);
 
 		if (round && APIC_CLUSTER(apicid) != APIC_CLUSTER(new_apicid)) {
 			printk("%s: Not a valid mask!\n", __func__);
@@ -301,7 +287,7 @@ static unsigned int summit_cpu_mask_to_apicid(const struct cpumask *cpumask)
 static unsigned int summit_cpu_mask_to_apicid_and(const struct cpumask *inmask,
 			      const struct cpumask *andmask)
 {
-	int apicid = summit_cpu_to_logical_apicid(0);
+	int apicid = early_per_cpu(x86_cpu_to_logical_apicid, 0);
 	cpumask_var_t cpumask;
 
 	if (!alloc_cpumask_var(&cpumask, GFP_ATOMIC))
@@ -528,8 +514,6 @@ struct apic apic_summit = {
 	.ioapic_phys_id_map		= summit_ioapic_phys_id_map,
 	.setup_apic_routing		= summit_setup_apic_routing,
 	.multi_timer_check		= NULL,
-	.apicid_to_node			= summit_apicid_to_node,
-	.cpu_to_logical_apicid		= summit_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= summit_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= summit_apicid_to_cpu_present,
 	.setup_portio_remap		= NULL,
@@ -565,4 +549,7 @@ struct apic apic_summit = {
 	.icr_write			= native_apic_icr_write,
 	.wait_icr_idle			= native_apic_wait_icr_idle,
 	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
+
+	.x86_32_early_logical_apicid	= summit_early_logical_apicid,
+	.x86_32_numa_cpu_node		= default_x86_32_numa_cpu_node,
 };
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index cf69c59..90949bb 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -206,8 +206,6 @@ struct apic apic_x2apic_cluster = {
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
 	.multi_timer_check		= NULL,
-	.apicid_to_node			= NULL,
-	.cpu_to_logical_apicid		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.setup_portio_remap		= NULL,
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index 8972f38..c7e6d66 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -195,8 +195,6 @@ struct apic apic_x2apic_phys = {
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
 	.multi_timer_check		= NULL,
-	.apicid_to_node			= NULL,
-	.cpu_to_logical_apicid		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.setup_portio_remap		= NULL,
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index bd16b58..3c28928 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -338,8 +338,6 @@ struct apic __refdata apic_x2apic_uv_x = {
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
 	.multi_timer_check		= NULL,
-	.apicid_to_node			= NULL,
-	.cpu_to_logical_apicid		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.setup_portio_remap		= NULL,
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 7c7bedb..f771ab6 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -233,18 +233,22 @@ static void __cpuinit init_amd_k7(struct cpuinfo_x86 *c)
 }
 #endif
 
-#if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
+#ifdef CONFIG_NUMA
+/*
+ * To workaround broken NUMA config.  Read the comment in
+ * srat_detect_node().
+ */
 static int __cpuinit nearby_node(int apicid)
 {
 	int i, node;
 
 	for (i = apicid - 1; i >= 0; i--) {
-		node = apicid_to_node[i];
+		node = __apicid_to_node[i];
 		if (node != NUMA_NO_NODE && node_online(node))
 			return node;
 	}
 	for (i = apicid + 1; i < MAX_LOCAL_APIC; i++) {
-		node = apicid_to_node[i];
+		node = __apicid_to_node[i];
 		if (node != NUMA_NO_NODE && node_online(node))
 			return node;
 	}
@@ -261,7 +265,7 @@ static int __cpuinit nearby_node(int apicid)
 #ifdef CONFIG_X86_HT
 static void __cpuinit amd_get_topology(struct cpuinfo_x86 *c)
 {
-	u32 nodes;
+	u32 nodes, cores_per_cu = 1;
 	u8 node_id;
 	int cpu = smp_processor_id();
 
@@ -276,6 +280,7 @@ static void __cpuinit amd_get_topology(struct cpuinfo_x86 *c)
 		/* get compute unit information */
 		smp_num_siblings = ((ebx >> 8) & 3) + 1;
 		c->compute_unit_id = ebx & 0xff;
+		cores_per_cu += ((ebx >> 8) & 3);
 	} else if (cpu_has(c, X86_FEATURE_NODEID_MSR)) {
 		u64 value;
 
@@ -288,15 +293,18 @@ static void __cpuinit amd_get_topology(struct cpuinfo_x86 *c)
 	/* fixup multi-node processor information */
 	if (nodes > 1) {
 		u32 cores_per_node;
+		u32 cus_per_node;
 
 		set_cpu_cap(c, X86_FEATURE_AMD_DCM);
 		cores_per_node = c->x86_max_cores / nodes;
+		cus_per_node = cores_per_node / cores_per_cu;
 
 		/* store NodeID, use llc_shared_map to store sibling info */
 		per_cpu(cpu_llc_id, cpu) = node_id;
 
-		/* core id to be in range from 0 to (cores_per_node - 1) */
-		c->cpu_core_id = c->cpu_core_id % cores_per_node;
+		/* core id has to be in the [0 .. cores_per_node - 1] range */
+		c->cpu_core_id %= cores_per_node;
+		c->compute_unit_id %= cus_per_node;
 	}
 }
 #endif
@@ -334,31 +342,40 @@ EXPORT_SYMBOL_GPL(amd_get_nb_id);
 
 static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
 {
-#if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
+#ifdef CONFIG_NUMA
 	int cpu = smp_processor_id();
 	int node;
 	unsigned apicid = c->apicid;
 
-	node = per_cpu(cpu_llc_id, cpu);
+	node = numa_cpu_node(cpu);
+	if (node == NUMA_NO_NODE)
+		node = per_cpu(cpu_llc_id, cpu);
 
-	if (apicid_to_node[apicid] != NUMA_NO_NODE)
-		node = apicid_to_node[apicid];
 	if (!node_online(node)) {
-		/* Two possibilities here:
-		   - The CPU is missing memory and no node was created.
-		   In that case try picking one from a nearby CPU
-		   - The APIC IDs differ from the HyperTransport node IDs
-		   which the K8 northbridge parsing fills in.
-		   Assume they are all increased by a constant offset,
-		   but in the same order as the HT nodeids.
-		   If that doesn't result in a usable node fall back to the
-		   path for the previous case.  */
-
+		/*
+		 * Two possibilities here:
+		 *
+		 * - The CPU is missing memory and no node was created.  In
+		 *   that case try picking one from a nearby CPU.
+		 *
+		 * - The APIC IDs differ from the HyperTransport node IDs
+		 *   which the K8 northbridge parsing fills in.  Assume
+		 *   they are all increased by a constant offset, but in
+		 *   the same order as the HT nodeids.  If that doesn't
+		 *   result in a usable node fall back to the path for the
+		 *   previous case.
+		 *
+		 * This workaround operates directly on the mapping between
+		 * APIC ID and NUMA node, assuming certain relationship
+		 * between APIC ID, HT node ID and NUMA topology.  As going
+		 * through CPU mapping may alter the outcome, directly
+		 * access __apicid_to_node[].
+		 */
 		int ht_nodeid = c->initial_apicid;
 
 		if (ht_nodeid >= 0 &&
-		    apicid_to_node[ht_nodeid] != NUMA_NO_NODE)
-			node = apicid_to_node[ht_nodeid];
+		    __apicid_to_node[ht_nodeid] != NUMA_NO_NODE)
+			node = __apicid_to_node[ht_nodeid];
 		/* Pick a nearby node */
 		if (!node_online(node))
 			node = nearby_node(apicid);
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 1d59834..a2559c3 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -869,7 +869,7 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 
 	select_idle_routine(c);
 
-#if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
+#ifdef CONFIG_NUMA
 	numa_add_cpu(smp_processor_id());
 #endif
 }
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index d16c2c5..df86bc8 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -276,14 +276,13 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
 
 static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
 {
-#if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
+#ifdef CONFIG_NUMA
 	unsigned node;
 	int cpu = smp_processor_id();
-	int apicid = cpu_has_apic ? hard_smp_processor_id() : c->apicid;
 
 	/* Don't do the funky fallback heuristics the AMD version employs
 	   for now. */
-	node = apicid_to_node[apicid];
+	node = numa_cpu_node(cpu);
 	if (node == NUMA_NO_NODE || !node_online(node)) {
 		/* reuse the value from init_cpu_to_node() */
 		node = cpu_to_node(cpu);
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index ec2c19a..90cc675 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -304,8 +304,9 @@ amd_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
 
 struct _cache_attr {
 	struct attribute attr;
-	ssize_t (*show)(struct _cpuid4_info *, char *);
-	ssize_t (*store)(struct _cpuid4_info *, const char *, size_t count);
+	ssize_t (*show)(struct _cpuid4_info *, char *, unsigned int);
+	ssize_t (*store)(struct _cpuid4_info *, const char *, size_t count,
+			 unsigned int);
 };
 
 #ifdef CONFIG_AMD_NB
@@ -400,7 +401,8 @@ static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
 
 #define SHOW_CACHE_DISABLE(slot)					\
 static ssize_t								\
-show_cache_disable_##slot(struct _cpuid4_info *this_leaf, char *buf)	\
+show_cache_disable_##slot(struct _cpuid4_info *this_leaf, char *buf,	\
+			  unsigned int cpu)				\
 {									\
 	return show_cache_disable(this_leaf, buf, slot);		\
 }
@@ -512,7 +514,8 @@ static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
 #define STORE_CACHE_DISABLE(slot)					\
 static ssize_t								\
 store_cache_disable_##slot(struct _cpuid4_info *this_leaf,		\
-			   const char *buf, size_t count)		\
+			   const char *buf, size_t count,		\
+			   unsigned int cpu)				\
 {									\
 	return store_cache_disable(this_leaf, buf, count, slot);	\
 }
@@ -524,6 +527,39 @@ static struct _cache_attr cache_disable_0 = __ATTR(cache_disable_0, 0644,
 static struct _cache_attr cache_disable_1 = __ATTR(cache_disable_1, 0644,
 		show_cache_disable_1, store_cache_disable_1);
 
+static ssize_t
+show_subcaches(struct _cpuid4_info *this_leaf, char *buf, unsigned int cpu)
+{
+	if (!this_leaf->l3 || !amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
+		return -EINVAL;
+
+	return sprintf(buf, "%x\n", amd_get_subcaches(cpu));
+}
+
+static ssize_t
+store_subcaches(struct _cpuid4_info *this_leaf, const char *buf, size_t count,
+		unsigned int cpu)
+{
+	unsigned long val;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (!this_leaf->l3 || !amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
+		return -EINVAL;
+
+	if (strict_strtoul(buf, 16, &val) < 0)
+		return -EINVAL;
+
+	if (amd_set_subcaches(cpu, val))
+		return -EINVAL;
+
+	return count;
+}
+
+static struct _cache_attr subcaches =
+	__ATTR(subcaches, 0644, show_subcaches, store_subcaches);
+
 #else	/* CONFIG_AMD_NB */
 #define amd_init_l3_cache(x, y)
 #endif /* CONFIG_AMD_NB */
@@ -532,9 +568,9 @@ static int
 __cpuinit cpuid4_cache_lookup_regs(int index,
 				   struct _cpuid4_info_regs *this_leaf)
 {
-	union _cpuid4_leaf_eax 	eax;
-	union _cpuid4_leaf_ebx 	ebx;
-	union _cpuid4_leaf_ecx 	ecx;
+	union _cpuid4_leaf_eax	eax;
+	union _cpuid4_leaf_ebx	ebx;
+	union _cpuid4_leaf_ecx	ecx;
 	unsigned		edx;
 
 	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD) {
@@ -870,8 +906,8 @@ static DEFINE_PER_CPU(struct _index_kobject *, ici_index_kobject);
 #define INDEX_KOBJECT_PTR(x, y)		(&((per_cpu(ici_index_kobject, x))[y]))
 
 #define show_one_plus(file_name, object, val)				\
-static ssize_t show_##file_name						\
-			(struct _cpuid4_info *this_leaf, char *buf)	\
+static ssize_t show_##file_name(struct _cpuid4_info *this_leaf, char *buf, \
+				unsigned int cpu)			\
 {									\
 	return sprintf(buf, "%lu\n", (unsigned long)this_leaf->object + val); \
 }
@@ -882,7 +918,8 @@ show_one_plus(physical_line_partition, ebx.split.physical_line_partition, 1);
 show_one_plus(ways_of_associativity, ebx.split.ways_of_associativity, 1);
 show_one_plus(number_of_sets, ecx.split.number_of_sets, 1);
 
-static ssize_t show_size(struct _cpuid4_info *this_leaf, char *buf)
+static ssize_t show_size(struct _cpuid4_info *this_leaf, char *buf,
+			 unsigned int cpu)
 {
 	return sprintf(buf, "%luK\n", this_leaf->size / 1024);
 }
@@ -906,17 +943,20 @@ static ssize_t show_shared_cpu_map_func(struct _cpuid4_info *this_leaf,
 	return n;
 }
 
-static inline ssize_t show_shared_cpu_map(struct _cpuid4_info *leaf, char *buf)
+static inline ssize_t show_shared_cpu_map(struct _cpuid4_info *leaf, char *buf,
+					  unsigned int cpu)
 {
 	return show_shared_cpu_map_func(leaf, 0, buf);
 }
 
-static inline ssize_t show_shared_cpu_list(struct _cpuid4_info *leaf, char *buf)
+static inline ssize_t show_shared_cpu_list(struct _cpuid4_info *leaf, char *buf,
+					   unsigned int cpu)
 {
 	return show_shared_cpu_map_func(leaf, 1, buf);
 }
 
-static ssize_t show_type(struct _cpuid4_info *this_leaf, char *buf)
+static ssize_t show_type(struct _cpuid4_info *this_leaf, char *buf,
+			 unsigned int cpu)
 {
 	switch (this_leaf->eax.split.type) {
 	case CACHE_TYPE_DATA:
@@ -974,6 +1014,9 @@ static struct attribute ** __cpuinit amd_l3_attrs(void)
 	if (amd_nb_has_feature(AMD_NB_L3_INDEX_DISABLE))
 		n += 2;
 
+	if (amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
+		n += 1;
+
 	attrs = kzalloc(n * sizeof (struct attribute *), GFP_KERNEL);
 	if (attrs == NULL)
 		return attrs = default_attrs;
@@ -986,6 +1029,9 @@ static struct attribute ** __cpuinit amd_l3_attrs(void)
 		attrs[n++] = &cache_disable_1.attr;
 	}
 
+	if (amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
+		attrs[n++] = &subcaches.attr;
+
 	return attrs;
 }
 #endif
@@ -998,7 +1044,7 @@ static ssize_t show(struct kobject *kobj, struct attribute *attr, char *buf)
 
 	ret = fattr->show ?
 		fattr->show(CPUID4_INFO_IDX(this_leaf->cpu, this_leaf->index),
-			buf) :
+			buf, this_leaf->cpu) :
 		0;
 	return ret;
 }
@@ -1012,7 +1058,7 @@ static ssize_t store(struct kobject *kobj, struct attribute *attr,
 
 	ret = fattr->store ?
 		fattr->store(CPUID4_INFO_IDX(this_leaf->cpu, this_leaf->index),
-			buf, count) :
+			buf, count, this_leaf->cpu) :
 		0;
 	return ret;
 }
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 294f26d..0b5e2b5 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -847,15 +847,21 @@ static int __init parse_memopt(char *p)
 	if (!p)
 		return -EINVAL;
 
-#ifdef CONFIG_X86_32
 	if (!strcmp(p, "nopentium")) {
+#ifdef CONFIG_X86_32
 		setup_clear_cpu_cap(X86_FEATURE_PSE);
 		return 0;
-	}
+#else
+		printk(KERN_WARNING "mem=nopentium ignored! (only supported on x86_32)\n");
+		return -EINVAL;
 #endif
+	}
 
 	userdef = 1;
 	mem_size = memparse(p, &p);
+	/* don't remove all of memory when handling "mem={invalid}" param */
+	if (mem_size == 0)
+		return -EINVAL;
 	e820_remove_range(mem_size, ULLONG_MAX - mem_size, E820_RAM, 1);
 
 	return 0;
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index aed1ffb..891268c 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -975,9 +975,12 @@ apicinterrupt X86_PLATFORM_IPI_VECTOR \
 	x86_platform_ipi smp_x86_platform_ipi
 
 #ifdef CONFIG_SMP
-.irpc idx, "01234567"
+.irp idx,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15, \
+	16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
+.if NUM_INVALIDATE_TLB_VECTORS > \idx
 apicinterrupt (INVALIDATE_TLB_VECTOR_START)+\idx \
 	invalidate_interrupt\idx smp_invalidate_interrupt
+.endif
 .endr
 #endif
 
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index c752e97..7aad10a 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -164,14 +164,77 @@ static void __init smp_intr_init(void)
 	alloc_intr_gate(RESCHEDULE_VECTOR, reschedule_interrupt);
 
 	/* IPIs for invalidation */
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+0, invalidate_interrupt0);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+1, invalidate_interrupt1);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+2, invalidate_interrupt2);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+3, invalidate_interrupt3);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+4, invalidate_interrupt4);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+5, invalidate_interrupt5);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+6, invalidate_interrupt6);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+7, invalidate_interrupt7);
+#define ALLOC_INVTLB_VEC(NR) \
+	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+NR, \
+		invalidate_interrupt##NR)
+
+	switch (NUM_INVALIDATE_TLB_VECTORS) {
+	default:
+		ALLOC_INVTLB_VEC(31);
+	case 31:
+		ALLOC_INVTLB_VEC(30);
+	case 30:
+		ALLOC_INVTLB_VEC(29);
+	case 29:
+		ALLOC_INVTLB_VEC(28);
+	case 28:
+		ALLOC_INVTLB_VEC(27);
+	case 27:
+		ALLOC_INVTLB_VEC(26);
+	case 26:
+		ALLOC_INVTLB_VEC(25);
+	case 25:
+		ALLOC_INVTLB_VEC(24);
+	case 24:
+		ALLOC_INVTLB_VEC(23);
+	case 23:
+		ALLOC_INVTLB_VEC(22);
+	case 22:
+		ALLOC_INVTLB_VEC(21);
+	case 21:
+		ALLOC_INVTLB_VEC(20);
+	case 20:
+		ALLOC_INVTLB_VEC(19);
+	case 19:
+		ALLOC_INVTLB_VEC(18);
+	case 18:
+		ALLOC_INVTLB_VEC(17);
+	case 17:
+		ALLOC_INVTLB_VEC(16);
+	case 16:
+		ALLOC_INVTLB_VEC(15);
+	case 15:
+		ALLOC_INVTLB_VEC(14);
+	case 14:
+		ALLOC_INVTLB_VEC(13);
+	case 13:
+		ALLOC_INVTLB_VEC(12);
+	case 12:
+		ALLOC_INVTLB_VEC(11);
+	case 11:
+		ALLOC_INVTLB_VEC(10);
+	case 10:
+		ALLOC_INVTLB_VEC(9);
+	case 9:
+		ALLOC_INVTLB_VEC(8);
+	case 8:
+		ALLOC_INVTLB_VEC(7);
+	case 7:
+		ALLOC_INVTLB_VEC(6);
+	case 6:
+		ALLOC_INVTLB_VEC(5);
+	case 5:
+		ALLOC_INVTLB_VEC(4);
+	case 4:
+		ALLOC_INVTLB_VEC(3);
+	case 3:
+		ALLOC_INVTLB_VEC(2);
+	case 2:
+		ALLOC_INVTLB_VEC(1);
+	case 1:
+		ALLOC_INVTLB_VEC(0);
+		break;
+	}
 
 	/* IPI for generic function call */
 	alloc_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index d3cfe26..c3a606c 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -293,10 +293,32 @@ static void __init init_gbpages(void)
 	else
 		direct_gbpages = 0;
 }
+
+static void __init cleanup_highmap_brk_end(void)
+{
+	pud_t *pud;
+	pmd_t *pmd;
+
+	mmu_cr4_features = read_cr4();
+
+	/*
+	 * _brk_end cannot change anymore, but it and _end may be
+	 * located on different 2M pages. cleanup_highmap(), however,
+	 * can only consider _end when it runs, so destroy any
+	 * mappings beyond _brk_end here.
+	 */
+	pud = pud_offset(pgd_offset_k(_brk_end), _brk_end);
+	pmd = pmd_offset(pud, _brk_end - 1);
+	while (++pmd <= pmd_offset(pud, (unsigned long)_end - 1))
+		pmd_clear(pmd);
+}
 #else
 static inline void init_gbpages(void)
 {
 }
+static inline void cleanup_highmap_brk_end(void)
+{
+}
 #endif
 
 static void __init reserve_brk(void)
@@ -307,6 +329,8 @@ static void __init reserve_brk(void)
 	/* Mark brk area as locked down and no longer taking any
 	   new allocations */
 	_brk_start = 0;
+
+	cleanup_highmap_brk_end();
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
@@ -680,15 +704,6 @@ static int __init parse_reservelow(char *p)
 
 early_param("reservelow", parse_reservelow);
 
-static u64 __init get_max_mapped(void)
-{
-	u64 end = max_pfn_mapped;
-
-	end <<= PAGE_SHIFT;
-
-	return end;
-}
-
 /*
  * Determine if we were loaded by an EFI loader.  If so, then we have also been
  * passed the efi memmap, systab, etc., so we should use these data structures
@@ -704,8 +719,6 @@ static u64 __init get_max_mapped(void)
 
 void __init setup_arch(char **cmdline_p)
 {
-	int acpi = 0;
-	int amd = 0;
 	unsigned long flags;
 
 #ifdef CONFIG_X86_32
@@ -984,19 +997,7 @@ void __init setup_arch(char **cmdline_p)
 
 	early_acpi_boot_init();
 
-#ifdef CONFIG_ACPI_NUMA
-	/*
-	 * Parse SRAT to discover nodes.
-	 */
-	acpi = acpi_numa_init();
-#endif
-
-#ifdef CONFIG_AMD_NUMA
-	if (!acpi)
-		amd = !amd_numa_init(0, max_pfn);
-#endif
-
-	initmem_init(0, max_pfn, acpi, amd);
+	initmem_init();
 	memblock_find_dma_reserve();
 	dma32_reserve_bootmem();
 
@@ -1040,9 +1041,7 @@ void __init setup_arch(char **cmdline_p)
 
 	prefill_possible_map();
 
-#ifdef CONFIG_X86_64
 	init_cpu_to_node();
-#endif
 
 	init_apic_mappings();
 	ioapic_and_gsi_init();
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 002b796..71f4727 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -225,10 +225,15 @@ void __init setup_per_cpu_areas(void)
 		per_cpu(x86_bios_cpu_apicid, cpu) =
 			early_per_cpu_map(x86_bios_cpu_apicid, cpu);
 #endif
+#ifdef CONFIG_X86_32
+		per_cpu(x86_cpu_to_logical_apicid, cpu) =
+			early_per_cpu_map(x86_cpu_to_logical_apicid, cpu);
+#endif
 #ifdef CONFIG_X86_64
 		per_cpu(irq_stack_ptr, cpu) =
 			per_cpu(irq_stack_union.irq_stack, cpu) +
 			IRQ_STACK_SIZE - 64;
+#endif
 #ifdef CONFIG_NUMA
 		per_cpu(x86_cpu_to_node_map, cpu) =
 			early_per_cpu_map(x86_cpu_to_node_map, cpu);
@@ -242,7 +247,6 @@ void __init setup_per_cpu_areas(void)
 		 */
 		set_cpu_numa_node(cpu, early_cpu_to_node(cpu));
 #endif
-#endif
 		/*
 		 * Up to this point, the boot CPU has been using .init.data
 		 * area.  Reload any changed state for the boot CPU.
@@ -256,7 +260,10 @@ void __init setup_per_cpu_areas(void)
 	early_per_cpu_ptr(x86_cpu_to_apicid) = NULL;
 	early_per_cpu_ptr(x86_bios_cpu_apicid) = NULL;
 #endif
-#if defined(CONFIG_X86_64) && defined(CONFIG_NUMA)
+#ifdef CONFIG_X86_32
+	early_per_cpu_ptr(x86_cpu_to_logical_apicid) = NULL;
+#endif
+#ifdef CONFIG_NUMA
 	early_per_cpu_ptr(x86_cpu_to_node_map) = NULL;
 #endif
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 08776a9..a9d805f 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -71,10 +71,6 @@
 #include <asm/smpboot_hooks.h>
 #include <asm/i8259.h>
 
-#ifdef CONFIG_X86_32
-u8 apicid_2_node[MAX_APICID];
-#endif
-
 /* State of each CPU */
 DEFINE_PER_CPU(int, cpu_state) = { 0 };
 
@@ -136,62 +132,6 @@ EXPORT_PER_CPU_SYMBOL(cpu_info);
 
 atomic_t init_deasserted;
 
-#if defined(CONFIG_NUMA) && defined(CONFIG_X86_32)
-/* which node each logical CPU is on */
-int cpu_to_node_map[NR_CPUS] __read_mostly = { [0 ... NR_CPUS-1] = 0 };
-EXPORT_SYMBOL(cpu_to_node_map);
-
-/* set up a mapping between cpu and node. */
-static void map_cpu_to_node(int cpu, int node)
-{
-	printk(KERN_INFO "Mapping cpu %d to node %d\n", cpu, node);
-	cpumask_set_cpu(cpu, node_to_cpumask_map[node]);
-	cpu_to_node_map[cpu] = node;
-}
-
-/* undo a mapping between cpu and node. */
-static void unmap_cpu_to_node(int cpu)
-{
-	int node;
-
-	printk(KERN_INFO "Unmapping cpu %d from all nodes\n", cpu);
-	for (node = 0; node < MAX_NUMNODES; node++)
-		cpumask_clear_cpu(cpu, node_to_cpumask_map[node]);
-	cpu_to_node_map[cpu] = 0;
-}
-#else /* !(CONFIG_NUMA && CONFIG_X86_32) */
-#define map_cpu_to_node(cpu, node)	({})
-#define unmap_cpu_to_node(cpu)	({})
-#endif
-
-#ifdef CONFIG_X86_32
-static int boot_cpu_logical_apicid;
-
-u8 cpu_2_logical_apicid[NR_CPUS] __read_mostly =
-					{ [0 ... NR_CPUS-1] = BAD_APICID };
-
-static void map_cpu_to_logical_apicid(void)
-{
-	int cpu = smp_processor_id();
-	int apicid = logical_smp_processor_id();
-	int node = apic->apicid_to_node(apicid);
-
-	if (!node_online(node))
-		node = first_online_node;
-
-	cpu_2_logical_apicid[cpu] = apicid;
-	map_cpu_to_node(cpu, node);
-}
-
-void numa_remove_cpu(int cpu)
-{
-	cpu_2_logical_apicid[cpu] = BAD_APICID;
-	unmap_cpu_to_node(cpu);
-}
-#else
-#define map_cpu_to_logical_apicid()  do {} while (0)
-#endif
-
 /*
  * Report back to the Boot Processor.
  * Running on AP.
@@ -259,7 +199,6 @@ static void __cpuinit smp_callin(void)
 		apic->smp_callin_clear_local_apic();
 	setup_local_APIC();
 	end_local_APIC_setup();
-	map_cpu_to_logical_apicid();
 
 	/*
 	 * Need to setup vector mappings before we enable interrupts.
@@ -414,6 +353,7 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 
 			if (cpu_has(c, X86_FEATURE_TOPOEXT)) {
 				if (c->phys_proc_id == o->phys_proc_id &&
+				    per_cpu(cpu_llc_id, cpu) == per_cpu(cpu_llc_id, i) &&
 				    c->compute_unit_id == o->compute_unit_id)
 					link_thread_siblings(cpu, i);
 			} else if (c->phys_proc_id == o->phys_proc_id &&
@@ -960,7 +900,6 @@ static __init void disable_smp(void)
 		physid_set_mask_of_physid(boot_cpu_physical_apicid, &phys_cpu_present_map);
 	else
 		physid_set_mask_of_physid(0, &phys_cpu_present_map);
-	map_cpu_to_logical_apicid();
 	cpumask_set_cpu(0, cpu_sibling_mask(0));
 	cpumask_set_cpu(0, cpu_core_mask(0));
 }
@@ -1096,9 +1035,7 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	 * Setup boot CPU information
 	 */
 	smp_store_cpu_info(0); /* Final full version of the data */
-#ifdef CONFIG_X86_32
-	boot_cpu_logical_apicid = logical_smp_processor_id();
-#endif
+
 	current_thread_info()->cpu = 0;  /* needed? */
 	for_each_possible_cpu(i) {
 		zalloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
@@ -1139,8 +1076,6 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 
 	bsp_end_local_APIC_setup();
 
-	map_cpu_to_logical_apicid();
-
 	if (apic->setup_portio_remap)
 		apic->setup_portio_remap();
 
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 09df2f9..3e608ed 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -25,6 +25,7 @@ obj-$(CONFIG_MMIOTRACE_TEST)	+= testmmiotrace.o
 obj-$(CONFIG_NUMA)		+= numa.o numa_$(BITS).o
 obj-$(CONFIG_AMD_NUMA)		+= amdtopology_64.o
 obj-$(CONFIG_ACPI_NUMA)		+= srat_$(BITS).o
+obj-$(CONFIG_NUMA_EMU)		+= numa_emulation.o
 
 obj-$(CONFIG_HAVE_MEMBLOCK)		+= memblock.o
 
diff --git a/arch/x86/mm/amdtopology_64.c b/arch/x86/mm/amdtopology_64.c
index f21962c..0919c26 100644
--- a/arch/x86/mm/amdtopology_64.c
+++ b/arch/x86/mm/amdtopology_64.c
@@ -26,9 +26,7 @@
 #include <asm/apic.h>
 #include <asm/amd_nb.h>
 
-static struct bootnode __initdata nodes[8];
 static unsigned char __initdata nodeids[8];
-static nodemask_t __initdata nodes_parsed = NODE_MASK_NONE;
 
 static __init int find_northbridge(void)
 {
@@ -51,7 +49,7 @@ static __init int find_northbridge(void)
 		return num;
 	}
 
-	return -1;
+	return -ENOENT;
 }
 
 static __init void early_get_boot_cpu_id(void)
@@ -69,17 +67,18 @@ static __init void early_get_boot_cpu_id(void)
 #endif
 }
 
-int __init amd_numa_init(unsigned long start_pfn, unsigned long end_pfn)
+int __init amd_numa_init(void)
 {
-	unsigned long start = PFN_PHYS(start_pfn);
-	unsigned long end = PFN_PHYS(end_pfn);
+	unsigned long start = PFN_PHYS(0);
+	unsigned long end = PFN_PHYS(max_pfn);
 	unsigned numnodes;
 	unsigned long prevbase;
-	int i, nb, found = 0;
+	int i, j, nb;
 	u32 nodeid, reg;
+	unsigned int bits, cores, apicid_base;
 
 	if (!early_pci_allowed())
-		return -1;
+		return -EINVAL;
 
 	nb = find_northbridge();
 	if (nb < 0)
@@ -90,7 +89,7 @@ int __init amd_numa_init(unsigned long start_pfn, unsigned long end_pfn)
 	reg = read_pci_config(0, nb, 0, 0x60);
 	numnodes = ((reg >> 4) & 0xF) + 1;
 	if (numnodes <= 1)
-		return -1;
+		return -ENOENT;
 
 	pr_info("Number of physical nodes %d\n", numnodes);
 
@@ -121,9 +120,9 @@ int __init amd_numa_init(unsigned long start_pfn, unsigned long end_pfn)
 		if ((base >> 8) & 3 || (limit >> 8) & 3) {
 			pr_err("Node %d using interleaving mode %lx/%lx\n",
 			       nodeid, (base >> 8) & 3, (limit >> 8) & 3);
-			return -1;
+			return -EINVAL;
 		}
-		if (node_isset(nodeid, nodes_parsed)) {
+		if (node_isset(nodeid, numa_nodes_parsed)) {
 			pr_info("Node %d already present, skipping\n",
 				nodeid);
 			continue;
@@ -160,117 +159,28 @@ int __init amd_numa_init(unsigned long start_pfn, unsigned long end_pfn)
 		if (prevbase > base) {
 			pr_err("Node map not sorted %lx,%lx\n",
 			       prevbase, base);
-			return -1;
+			return -EINVAL;
 		}
 
 		pr_info("Node %d MemBase %016lx Limit %016lx\n",
 			nodeid, base, limit);
 
-		found++;
-
-		nodes[nodeid].start = base;
-		nodes[nodeid].end = limit;
-
 		prevbase = base;
-
-		node_set(nodeid, nodes_parsed);
-	}
-
-	if (!found)
-		return -1;
-	return 0;
-}
-
-#ifdef CONFIG_NUMA_EMU
-static s16 fake_apicid_to_node[MAX_LOCAL_APIC] __initdata = {
-	[0 ... MAX_LOCAL_APIC-1] = NUMA_NO_NODE
-};
-
-void __init amd_get_nodes(struct bootnode *physnodes)
-{
-	int i;
-
-	for_each_node_mask(i, nodes_parsed) {
-		physnodes[i].start = nodes[i].start;
-		physnodes[i].end = nodes[i].end;
+		numa_add_memblk(nodeid, base, limit);
+		node_set(nodeid, numa_nodes_parsed);
 	}
-}
-
-static int __init find_node_by_addr(unsigned long addr)
-{
-	int ret = NUMA_NO_NODE;
-	int i;
-
-	for (i = 0; i < 8; i++)
-		if (addr >= nodes[i].start && addr < nodes[i].end) {
-			ret = i;
-			break;
-		}
-	return ret;
-}
 
-/*
- * For NUMA emulation, fake proximity domain (_PXM) to node id mappings must be
- * setup to represent the physical topology but reflect the emulated
- * environment.  For each emulated node, the real node which it appears on is
- * found and a fake pxm to nid mapping is created which mirrors the actual
- * locality.  node_distance() then represents the correct distances between
- * emulated nodes by using the fake acpi mappings to pxms.
- */
-void __init amd_fake_nodes(const struct bootnode *nodes, int nr_nodes)
-{
-	unsigned int bits;
-	unsigned int cores;
-	unsigned int apicid_base = 0;
-	int i;
+	if (!nodes_weight(numa_nodes_parsed))
+		return -ENOENT;
 
+	/*
+	 * We seem to have valid NUMA configuration.  Map apicids to nodes
+	 * using the coreid bits from early_identify_cpu.
+	 */
 	bits = boot_cpu_data.x86_coreid_bits;
 	cores = 1 << bits;
-	early_get_boot_cpu_id();
-	if (boot_cpu_physical_apicid > 0)
-		apicid_base = boot_cpu_physical_apicid;
-
-	for (i = 0; i < nr_nodes; i++) {
-		int index;
-		int nid;
-		int j;
-
-		nid = find_node_by_addr(nodes[i].start);
-		if (nid == NUMA_NO_NODE)
-			continue;
-
-		index = nodeids[nid] << bits;
-		if (fake_apicid_to_node[index + apicid_base] == NUMA_NO_NODE)
-			for (j = apicid_base; j < cores + apicid_base; j++)
-				fake_apicid_to_node[index + j] = i;
-#ifdef CONFIG_ACPI_NUMA
-		__acpi_map_pxm_to_node(nid, i);
-#endif
-	}
-	memcpy(apicid_to_node, fake_apicid_to_node, sizeof(apicid_to_node));
-}
-#endif /* CONFIG_NUMA_EMU */
-
-int __init amd_scan_nodes(void)
-{
-	unsigned int bits;
-	unsigned int cores;
-	unsigned int apicid_base;
-	int i;
-
-	BUG_ON(nodes_empty(nodes_parsed));
-	node_possible_map = nodes_parsed;
-	memnode_shift = compute_hash_shift(nodes, 8, NULL);
-	if (memnode_shift < 0) {
-		pr_err("No NUMA node hash function found. Contact maintainer\n");
-		return -1;
-	}
-	pr_info("Using node hash shift of %d\n", memnode_shift);
-
-	/* use the coreid bits from early_identify_cpu */
-	bits = boot_cpu_data.x86_coreid_bits;
-	cores = (1<<bits);
 	apicid_base = 0;
+
 	/* get the APIC ID of the BSP early for systems with apicid lifting */
 	early_get_boot_cpu_id();
 	if (boot_cpu_physical_apicid > 0) {
@@ -278,17 +188,9 @@ int __init amd_scan_nodes(void)
 		apicid_base = boot_cpu_physical_apicid;
 	}
 
-	for_each_node_mask(i, node_possible_map) {
-		int j;
-
-		memblock_x86_register_active_regions(i,
-				nodes[i].start >> PAGE_SHIFT,
-				nodes[i].end >> PAGE_SHIFT);
+	for_each_node_mask(i, numa_nodes_parsed)
 		for (j = apicid_base; j < cores + apicid_base; j++)
-			apicid_to_node[(i << bits) + j] = i;
-		setup_node_bootmem(i, nodes[i].start, nodes[i].end);
-	}
+			set_apicid_to_node((i << bits) + j, i);
 
-	numa_init_array();
 	return 0;
 }
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 947f42a..286d289 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -18,9 +18,9 @@
 
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 
-unsigned long __initdata e820_table_start;
-unsigned long __meminitdata e820_table_end;
-unsigned long __meminitdata e820_table_top;
+unsigned long __initdata pgt_buf_start;
+unsigned long __meminitdata pgt_buf_end;
+unsigned long __meminitdata pgt_buf_top;
 
 int after_bootmem;
 
@@ -33,7 +33,7 @@ int direct_gbpages
 static void __init find_early_table_space(unsigned long end, int use_pse,
 					  int use_gbpages)
 {
-	unsigned long puds, pmds, ptes, tables, start;
+	unsigned long puds, pmds, ptes, tables, start = 0, good_end = end;
 	phys_addr_t base;
 
 	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
@@ -65,29 +65,20 @@ static void __init find_early_table_space(unsigned long end, int use_pse,
 #ifdef CONFIG_X86_32
 	/* for fixmap */
 	tables += roundup(__end_of_fixed_addresses * sizeof(pte_t), PAGE_SIZE);
-#endif
 
-	/*
-	 * RED-PEN putting page tables only on node 0 could
-	 * cause a hotspot and fill up ZONE_DMA. The page tables
-	 * need roughly 0.5KB per GB.
-	 */
-#ifdef CONFIG_X86_32
-	start = 0x7000;
-#else
-	start = 0x8000;
+	good_end = max_pfn_mapped << PAGE_SHIFT;
 #endif
-	base = memblock_find_in_range(start, max_pfn_mapped<<PAGE_SHIFT,
-					tables, PAGE_SIZE);
+
+	base = memblock_find_in_range(start, good_end, tables, PAGE_SIZE);
 	if (base == MEMBLOCK_ERROR)
 		panic("Cannot find space for the kernel page tables");
 
-	e820_table_start = base >> PAGE_SHIFT;
-	e820_table_end = e820_table_start;
-	e820_table_top = e820_table_start + (tables >> PAGE_SHIFT);
+	pgt_buf_start = base >> PAGE_SHIFT;
+	pgt_buf_end = pgt_buf_start;
+	pgt_buf_top = pgt_buf_start + (tables >> PAGE_SHIFT);
 
 	printk(KERN_DEBUG "kernel direct mapping tables up to %lx @ %lx-%lx\n",
-		end, e820_table_start << PAGE_SHIFT, e820_table_top << PAGE_SHIFT);
+		end, pgt_buf_start << PAGE_SHIFT, pgt_buf_top << PAGE_SHIFT);
 }
 
 struct map_range {
@@ -279,30 +270,11 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	load_cr3(swapper_pg_dir);
 #endif
 
-#ifdef CONFIG_X86_64
-	if (!after_bootmem && !start) {
-		pud_t *pud;
-		pmd_t *pmd;
-
-		mmu_cr4_features = read_cr4();
-
-		/*
-		 * _brk_end cannot change anymore, but it and _end may be
-		 * located on different 2M pages. cleanup_highmap(), however,
-		 * can only consider _end when it runs, so destroy any
-		 * mappings beyond _brk_end here.
-		 */
-		pud = pud_offset(pgd_offset_k(_brk_end), _brk_end);
-		pmd = pmd_offset(pud, _brk_end - 1);
-		while (++pmd <= pmd_offset(pud, (unsigned long)_end - 1))
-			pmd_clear(pmd);
-	}
-#endif
 	__flush_tlb_all();
 
-	if (!after_bootmem && e820_table_end > e820_table_start)
-		memblock_x86_reserve_range(e820_table_start << PAGE_SHIFT,
-				 e820_table_end << PAGE_SHIFT, "PGTABLE");
+	if (!after_bootmem && pgt_buf_end > pgt_buf_start)
+		memblock_x86_reserve_range(pgt_buf_start << PAGE_SHIFT,
+				 pgt_buf_end << PAGE_SHIFT, "PGTABLE");
 
 	if (!after_bootmem)
 		early_memtest(start, end);
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index c821074..73ad7eb 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -62,10 +62,10 @@ bool __read_mostly __vmalloc_start_set = false;
 
 static __init void *alloc_low_page(void)
 {
-	unsigned long pfn = e820_table_end++;
+	unsigned long pfn = pgt_buf_end++;
 	void *adr;
 
-	if (pfn >= e820_table_top)
+	if (pfn >= pgt_buf_top)
 		panic("alloc_low_page: ran out of memory");
 
 	adr = __va(pfn * PAGE_SIZE);
@@ -163,8 +163,8 @@ static pte_t *__init page_table_kmap_check(pte_t *pte, pmd_t *pmd,
 	if (pmd_idx_kmap_begin != pmd_idx_kmap_end
 	    && (vaddr >> PMD_SHIFT) >= pmd_idx_kmap_begin
 	    && (vaddr >> PMD_SHIFT) <= pmd_idx_kmap_end
-	    && ((__pa(pte) >> PAGE_SHIFT) < e820_table_start
-		|| (__pa(pte) >> PAGE_SHIFT) >= e820_table_end)) {
+	    && ((__pa(pte) >> PAGE_SHIFT) < pgt_buf_start
+		|| (__pa(pte) >> PAGE_SHIFT) >= pgt_buf_end)) {
 		pte_t *newpte;
 		int i;
 
@@ -644,8 +644,7 @@ void __init find_low_pfn_range(void)
 }
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
-void __init initmem_init(unsigned long start_pfn, unsigned long end_pfn,
-				int acpi, int k8)
+void __init initmem_init(void)
 {
 #ifdef CONFIG_HIGHMEM
 	highstart_pfn = highend_pfn = max_pfn;
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index c14a542..a08a62c 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -314,7 +314,7 @@ void __init cleanup_highmap(void)
 
 static __ref void *alloc_low_page(unsigned long *phys)
 {
-	unsigned long pfn = e820_table_end++;
+	unsigned long pfn = pgt_buf_end++;
 	void *adr;
 
 	if (after_bootmem) {
@@ -324,7 +324,7 @@ static __ref void *alloc_low_page(unsigned long *phys)
 		return adr;
 	}
 
-	if (pfn >= e820_table_top)
+	if (pfn >= pgt_buf_top)
 		panic("alloc_low_page: ran out of memory");
 
 	adr = early_memremap(pfn * PAGE_SIZE, PAGE_SIZE);
@@ -333,12 +333,28 @@ static __ref void *alloc_low_page(unsigned long *phys)
 	return adr;
 }
 
+static __ref void *map_low_page(void *virt)
+{
+	void *adr;
+	unsigned long phys, left;
+
+	if (after_bootmem)
+		return virt;
+
+	phys = __pa(virt);
+	left = phys & (PAGE_SIZE - 1);
+	adr = early_memremap(phys & PAGE_MASK, PAGE_SIZE);
+	adr = (void *)(((unsigned long)adr) | left);
+
+	return adr;
+}
+
 static __ref void unmap_low_page(void *adr)
 {
 	if (after_bootmem)
 		return;
 
-	early_iounmap(adr, PAGE_SIZE);
+	early_iounmap((void *)((unsigned long)adr & PAGE_MASK), PAGE_SIZE);
 }
 
 static unsigned long __meminit
@@ -386,15 +402,6 @@ phys_pte_init(pte_t *pte_page, unsigned long addr, unsigned long end,
 }
 
 static unsigned long __meminit
-phys_pte_update(pmd_t *pmd, unsigned long address, unsigned long end,
-		pgprot_t prot)
-{
-	pte_t *pte = (pte_t *)pmd_page_vaddr(*pmd);
-
-	return phys_pte_init(pte, address, end, prot);
-}
-
-static unsigned long __meminit
 phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 	      unsigned long page_size_mask, pgprot_t prot)
 {
@@ -420,8 +427,10 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 		if (pmd_val(*pmd)) {
 			if (!pmd_large(*pmd)) {
 				spin_lock(&init_mm.page_table_lock);
-				last_map_addr = phys_pte_update(pmd, address,
+				pte = map_low_page((pte_t *)pmd_page_vaddr(*pmd));
+				last_map_addr = phys_pte_init(pte, address,
 								end, prot);
+				unmap_low_page(pte);
 				spin_unlock(&init_mm.page_table_lock);
 				continue;
 			}
@@ -468,18 +477,6 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 }
 
 static unsigned long __meminit
-phys_pmd_update(pud_t *pud, unsigned long address, unsigned long end,
-		unsigned long page_size_mask, pgprot_t prot)
-{
-	pmd_t *pmd = pmd_offset(pud, 0);
-	unsigned long last_map_addr;
-
-	last_map_addr = phys_pmd_init(pmd, address, end, page_size_mask, prot);
-	__flush_tlb_all();
-	return last_map_addr;
-}
-
-static unsigned long __meminit
 phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 			 unsigned long page_size_mask)
 {
@@ -504,8 +501,11 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 
 		if (pud_val(*pud)) {
 			if (!pud_large(*pud)) {
-				last_map_addr = phys_pmd_update(pud, addr, end,
+				pmd = map_low_page(pmd_offset(pud, 0));
+				last_map_addr = phys_pmd_init(pmd, addr, end,
 							 page_size_mask, prot);
+				unmap_low_page(pmd);
+				__flush_tlb_all();
 				continue;
 			}
 			/*
@@ -553,17 +553,6 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 	return last_map_addr;
 }
 
-static unsigned long __meminit
-phys_pud_update(pgd_t *pgd, unsigned long addr, unsigned long end,
-		 unsigned long page_size_mask)
-{
-	pud_t *pud;
-
-	pud = (pud_t *)pgd_page_vaddr(*pgd);
-
-	return phys_pud_init(pud, addr, end, page_size_mask);
-}
-
 unsigned long __meminit
 kernel_physical_mapping_init(unsigned long start,
 			     unsigned long end,
@@ -587,8 +576,10 @@ kernel_physical_mapping_init(unsigned long start,
 			next = end;
 
 		if (pgd_val(*pgd)) {
-			last_map_addr = phys_pud_update(pgd, __pa(start),
+			pud = map_low_page((pud_t *)pgd_page_vaddr(*pgd));
+			last_map_addr = phys_pud_init(pud, __pa(start),
 						 __pa(end), page_size_mask);
+			unmap_low_page(pud);
 			continue;
 		}
 
@@ -612,10 +603,9 @@ kernel_physical_mapping_init(unsigned long start,
 }
 
 #ifndef CONFIG_NUMA
-void __init initmem_init(unsigned long start_pfn, unsigned long end_pfn,
-				int acpi, int k8)
+void __init initmem_init(void)
 {
-	memblock_x86_register_active_regions(0, start_pfn, end_pfn);
+	memblock_x86_register_active_regions(0, 0, max_pfn);
 }
 #endif
 
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index ebf6d78..9559d36 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -26,12 +26,50 @@ static __init int numa_setup(char *opt)
 early_param("numa", numa_setup);
 
 /*
- * Which logical CPUs are on which nodes
+ * apicid, cpu, node mappings
  */
+s16 __apicid_to_node[MAX_LOCAL_APIC] __cpuinitdata = {
+	[0 ... MAX_LOCAL_APIC-1] = NUMA_NO_NODE
+};
+
 cpumask_var_t node_to_cpumask_map[MAX_NUMNODES];
 EXPORT_SYMBOL(node_to_cpumask_map);
 
 /*
+ * Map cpu index to node index
+ */
+DEFINE_EARLY_PER_CPU(int, x86_cpu_to_node_map, NUMA_NO_NODE);
+EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_node_map);
+
+void __cpuinit numa_set_node(int cpu, int node)
+{
+	int *cpu_to_node_map = early_per_cpu_ptr(x86_cpu_to_node_map);
+
+	/* early setting, no percpu area yet */
+	if (cpu_to_node_map) {
+		cpu_to_node_map[cpu] = node;
+		return;
+	}
+
+#ifdef CONFIG_DEBUG_PER_CPU_MAPS
+	if (cpu >= nr_cpu_ids || !cpu_possible(cpu)) {
+		printk(KERN_ERR "numa_set_node: invalid cpu# (%d)\n", cpu);
+		dump_stack();
+		return;
+	}
+#endif
+	per_cpu(x86_cpu_to_node_map, cpu) = node;
+
+	if (node != NUMA_NO_NODE)
+		set_cpu_numa_node(cpu, node);
+}
+
+void __cpuinit numa_clear_node(int cpu)
+{
+	numa_set_node(cpu, NUMA_NO_NODE);
+}
+
+/*
  * Allocate node_to_cpumask_map based on number of available nodes
  * Requires node_possible_map to be valid.
  *
@@ -57,7 +95,174 @@ void __init setup_node_to_cpumask_map(void)
 	pr_debug("Node to cpumask map for %d nodes\n", nr_node_ids);
 }
 
-#ifdef CONFIG_DEBUG_PER_CPU_MAPS
+/*
+ * There are unfortunately some poorly designed mainboards around that
+ * only connect memory to a single CPU. This breaks the 1:1 cpu->node
+ * mapping. To avoid this fill in the mapping for all possible CPUs,
+ * as the number of CPUs is not known yet. We round robin the existing
+ * nodes.
+ */
+void __init numa_init_array(void)
+{
+	int rr, i;
+
+	rr = first_node(node_online_map);
+	for (i = 0; i < nr_cpu_ids; i++) {
+		if (early_cpu_to_node(i) != NUMA_NO_NODE)
+			continue;
+		numa_set_node(i, rr);
+		rr = next_node(rr, node_online_map);
+		if (rr == MAX_NUMNODES)
+			rr = first_node(node_online_map);
+	}
+}
+
+static __init int find_near_online_node(int node)
+{
+	int n, val;
+	int min_val = INT_MAX;
+	int best_node = -1;
+
+	for_each_online_node(n) {
+		val = node_distance(node, n);
+
+		if (val < min_val) {
+			min_val = val;
+			best_node = n;
+		}
+	}
+
+	return best_node;
+}
+
+/*
+ * Setup early cpu_to_node.
+ *
+ * Populate cpu_to_node[] only if x86_cpu_to_apicid[],
+ * and apicid_to_node[] tables have valid entries for a CPU.
+ * This means we skip cpu_to_node[] initialisation for NUMA
+ * emulation and faking node case (when running a kernel compiled
+ * for NUMA on a non NUMA box), which is OK as cpu_to_node[]
+ * is already initialized in a round robin manner at numa_init_array,
+ * prior to this call, and this initialization is good enough
+ * for the fake NUMA cases.
+ *
+ * Called before the per_cpu areas are setup.
+ */
+void __init init_cpu_to_node(void)
+{
+	int cpu;
+	u16 *cpu_to_apicid = early_per_cpu_ptr(x86_cpu_to_apicid);
+
+	BUG_ON(cpu_to_apicid == NULL);
+
+	for_each_possible_cpu(cpu) {
+		int node = numa_cpu_node(cpu);
+
+		if (node == NUMA_NO_NODE)
+			continue;
+		if (!node_online(node))
+			node = find_near_online_node(node);
+		numa_set_node(cpu, node);
+	}
+}
+
+#ifndef CONFIG_DEBUG_PER_CPU_MAPS
+
+# ifndef CONFIG_NUMA_EMU
+void __cpuinit numa_add_cpu(int cpu)
+{
+	cpumask_set_cpu(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
+}
+
+void __cpuinit numa_remove_cpu(int cpu)
+{
+	cpumask_clear_cpu(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
+}
+# endif	/* !CONFIG_NUMA_EMU */
+
+#else	/* !CONFIG_DEBUG_PER_CPU_MAPS */
+
+int __cpu_to_node(int cpu)
+{
+	if (early_per_cpu_ptr(x86_cpu_to_node_map)) {
+		printk(KERN_WARNING
+			"cpu_to_node(%d): usage too early!\n", cpu);
+		dump_stack();
+		return early_per_cpu_ptr(x86_cpu_to_node_map)[cpu];
+	}
+	return per_cpu(x86_cpu_to_node_map, cpu);
+}
+EXPORT_SYMBOL(__cpu_to_node);
+
+/*
+ * Same function as cpu_to_node() but used if called before the
+ * per_cpu areas are setup.
+ */
+int early_cpu_to_node(int cpu)
+{
+	if (early_per_cpu_ptr(x86_cpu_to_node_map))
+		return early_per_cpu_ptr(x86_cpu_to_node_map)[cpu];
+
+	if (!cpu_possible(cpu)) {
+		printk(KERN_WARNING
+			"early_cpu_to_node(%d): no per_cpu area!\n", cpu);
+		dump_stack();
+		return NUMA_NO_NODE;
+	}
+	return per_cpu(x86_cpu_to_node_map, cpu);
+}
+
+struct cpumask __cpuinit *debug_cpumask_set_cpu(int cpu, int enable)
+{
+	int node = early_cpu_to_node(cpu);
+	struct cpumask *mask;
+	char buf[64];
+
+	if (node == NUMA_NO_NODE) {
+		/* early_cpu_to_node() already emits a warning and trace */
+		return NULL;
+	}
+	mask = node_to_cpumask_map[node];
+	if (!mask) {
+		pr_err("node_to_cpumask_map[%i] NULL\n", node);
+		dump_stack();
+		return NULL;
+	}
+
+	cpulist_scnprintf(buf, sizeof(buf), mask);
+	printk(KERN_DEBUG "%s cpu %d node %d: mask now %s\n",
+		enable ? "numa_add_cpu" : "numa_remove_cpu",
+		cpu, node, buf);
+	return mask;
+}
+
+# ifndef CONFIG_NUMA_EMU
+static void __cpuinit numa_set_cpumask(int cpu, int enable)
+{
+	struct cpumask *mask;
+
+	mask = debug_cpumask_set_cpu(cpu, enable);
+	if (!mask)
+		return;
+
+	if (enable)
+		cpumask_set_cpu(cpu, mask);
+	else
+		cpumask_clear_cpu(cpu, mask);
+}
+
+void __cpuinit numa_add_cpu(int cpu)
+{
+	numa_set_cpumask(cpu, 1);
+}
+
+void __cpuinit numa_remove_cpu(int cpu)
+{
+	numa_set_cpumask(cpu, 0);
+}
+# endif	/* !CONFIG_NUMA_EMU */
+
 /*
  * Returns a pointer to the bitmask of CPUs on Node 'node'.
  */
@@ -80,4 +285,5 @@ const struct cpumask *cpumask_of_node(int node)
 	return node_to_cpumask_map[node];
 }
 EXPORT_SYMBOL(cpumask_of_node);
-#endif
+
+#endif	/* !CONFIG_DEBUG_PER_CPU_MAPS */
diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index 84a3e4c..bde3906 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -110,6 +110,12 @@ void set_pmd_pfn(unsigned long vaddr, unsigned long pfn, pgprot_t flags);
 
 static unsigned long kva_start_pfn;
 static unsigned long kva_pages;
+
+int __cpuinit numa_cpu_node(int cpu)
+{
+	return apic->x86_32_numa_cpu_node(cpu);
+}
+
 /*
  * FLAT - support for basic PC memory model with discontig enabled, essentially
  *        a single node with all available processors in it with a flat
@@ -346,8 +352,7 @@ static void init_remap_allocator(int nid)
 		(ulong) node_remap_end_vaddr[nid]);
 }
 
-void __init initmem_init(unsigned long start_pfn, unsigned long end_pfn,
-				int acpi, int k8)
+void __init initmem_init(void)
 {
 	int nid;
 	long kva_target_pfn;
@@ -361,6 +366,7 @@ void __init initmem_init(unsigned long start_pfn, unsigned long end_pfn,
 	 */
 
 	get_memcfg_numa();
+	numa_init_array();
 
 	kva_pages = roundup(calculate_numa_remap_pages(), PTRS_PER_PTE);
 
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 1337c51..9ec0f20 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -13,31 +13,30 @@
 #include <linux/module.h>
 #include <linux/nodemask.h>
 #include <linux/sched.h>
+#include <linux/acpi.h>
 
 #include <asm/e820.h>
 #include <asm/proto.h>
 #include <asm/dma.h>
-#include <asm/numa.h>
 #include <asm/acpi.h>
 #include <asm/amd_nb.h>
 
+#include "numa_internal.h"
+
 struct pglist_data *node_data[MAX_NUMNODES] __read_mostly;
 EXPORT_SYMBOL(node_data);
 
-struct memnode memnode;
+nodemask_t numa_nodes_parsed __initdata;
 
-s16 apicid_to_node[MAX_LOCAL_APIC] __cpuinitdata = {
-	[0 ... MAX_LOCAL_APIC-1] = NUMA_NO_NODE
-};
+struct memnode memnode;
 
 static unsigned long __initdata nodemap_addr;
 static unsigned long __initdata nodemap_size;
 
-/*
- * Map cpu index to node index
- */
-DEFINE_EARLY_PER_CPU(int, x86_cpu_to_node_map, NUMA_NO_NODE);
-EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_node_map);
+static struct numa_meminfo numa_meminfo __initdata;
+
+static int numa_distance_cnt;
+static u8 *numa_distance;
 
 /*
  * Given a shift value, try to populate memnodemap[]
@@ -46,16 +45,15 @@ EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_node_map);
  * 0 if memnodmap[] too small (of shift too small)
  * -1 if node overlap or lost ram (shift too big)
  */
-static int __init populate_memnodemap(const struct bootnode *nodes,
-				      int numnodes, int shift, int *nodeids)
+static int __init populate_memnodemap(const struct numa_meminfo *mi, int shift)
 {
 	unsigned long addr, end;
 	int i, res = -1;
 
 	memset(memnodemap, 0xff, sizeof(s16)*memnodemapsize);
-	for (i = 0; i < numnodes; i++) {
-		addr = nodes[i].start;
-		end = nodes[i].end;
+	for (i = 0; i < mi->nr_blks; i++) {
+		addr = mi->blk[i].start;
+		end = mi->blk[i].end;
 		if (addr >= end)
 			continue;
 		if ((end >> shift) >= memnodemapsize)
@@ -63,12 +61,7 @@ static int __init populate_memnodemap(const struct bootnode *nodes,
 		do {
 			if (memnodemap[addr >> shift] != NUMA_NO_NODE)
 				return -1;
-
-			if (!nodeids)
-				memnodemap[addr >> shift] = i;
-			else
-				memnodemap[addr >> shift] = nodeids[i];
-
+			memnodemap[addr >> shift] = mi->blk[i].nid;
 			addr += (1UL << shift);
 		} while (addr < end);
 		res = 1;
@@ -86,7 +79,7 @@ static int __init allocate_cachealigned_memnodemap(void)
 
 	addr = 0x8000;
 	nodemap_size = roundup(sizeof(s16) * memnodemapsize, L1_CACHE_BYTES);
-	nodemap_addr = memblock_find_in_range(addr, max_pfn<<PAGE_SHIFT,
+	nodemap_addr = memblock_find_in_range(addr, get_max_mapped(),
 				      nodemap_size, L1_CACHE_BYTES);
 	if (nodemap_addr == MEMBLOCK_ERROR) {
 		printk(KERN_ERR
@@ -106,16 +99,15 @@ static int __init allocate_cachealigned_memnodemap(void)
  * The LSB of all start and end addresses in the node map is the value of the
  * maximum possible shift.
  */
-static int __init extract_lsb_from_nodes(const struct bootnode *nodes,
-					 int numnodes)
+static int __init extract_lsb_from_nodes(const struct numa_meminfo *mi)
 {
 	int i, nodes_used = 0;
 	unsigned long start, end;
 	unsigned long bitfield = 0, memtop = 0;
 
-	for (i = 0; i < numnodes; i++) {
-		start = nodes[i].start;
-		end = nodes[i].end;
+	for (i = 0; i < mi->nr_blks; i++) {
+		start = mi->blk[i].start;
+		end = mi->blk[i].end;
 		if (start >= end)
 			continue;
 		bitfield |= start;
@@ -131,18 +123,17 @@ static int __init extract_lsb_from_nodes(const struct bootnode *nodes,
 	return i;
 }
 
-int __init compute_hash_shift(struct bootnode *nodes, int numnodes,
-			      int *nodeids)
+static int __init compute_hash_shift(const struct numa_meminfo *mi)
 {
 	int shift;
 
-	shift = extract_lsb_from_nodes(nodes, numnodes);
+	shift = extract_lsb_from_nodes(mi);
 	if (allocate_cachealigned_memnodemap())
 		return -1;
 	printk(KERN_DEBUG "NUMA: Using %d for the hash shift.\n",
 		shift);
 
-	if (populate_memnodemap(nodes, numnodes, shift, nodeids) != 1) {
+	if (populate_memnodemap(mi, shift) != 1) {
 		printk(KERN_INFO "Your memory is not aligned you need to "
 		       "rebuild your kernel with a bigger NODEMAPSIZE "
 		       "shift=%d\n", shift);
@@ -188,6 +179,63 @@ static void * __init early_node_mem(int nodeid, unsigned long start,
 	return NULL;
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
 /* Initialize bootmem allocator for a node */
 void __init
 setup_node_bootmem(int nodeid, unsigned long start, unsigned long end)
@@ -234,692 +282,386 @@ setup_node_bootmem(int nodeid, unsigned long start, unsigned long end)
 	node_set_online(nodeid);
 }
 
-/*
- * There are unfortunately some poorly designed mainboards around that
- * only connect memory to a single CPU. This breaks the 1:1 cpu->node
- * mapping. To avoid this fill in the mapping for all possible CPUs,
- * as the number of CPUs is not known yet. We round robin the existing
- * nodes.
+/**
+ * numa_cleanup_meminfo - Cleanup a numa_meminfo
+ * @mi: numa_meminfo to clean up
+ *
+ * Sanitize @mi by merging and removing unncessary memblks.  Also check for
+ * conflicts and clear unused memblks.
+ *
+ * RETURNS:
+ * 0 on success, -errno on failure.
  */
-void __init numa_init_array(void)
+int __init numa_cleanup_meminfo(struct numa_meminfo *mi)
 {
-	int rr, i;
+	const u64 low = 0;
+	const u64 high = (u64)max_pfn << PAGE_SHIFT;
+	int i, j, k;
 
-	rr = first_node(node_online_map);
-	for (i = 0; i < nr_cpu_ids; i++) {
-		if (early_cpu_to_node(i) != NUMA_NO_NODE)
-			continue;
-		numa_set_node(i, rr);
-		rr = next_node(rr, node_online_map);
-		if (rr == MAX_NUMNODES)
-			rr = first_node(node_online_map);
-	}
-}
-
-#ifdef CONFIG_NUMA_EMU
-/* Numa emulation */
-static struct bootnode nodes[MAX_NUMNODES] __initdata;
-static struct bootnode physnodes[MAX_NUMNODES] __cpuinitdata;
-static char *cmdline __initdata;
+	for (i = 0; i < mi->nr_blks; i++) {
+		struct numa_memblk *bi = &mi->blk[i];
 
-void __init numa_emu_cmdline(char *str)
-{
-	cmdline = str;
-}
+		/* make sure all blocks are inside the limits */
+		bi->start = max(bi->start, low);
+		bi->end = min(bi->end, high);
 
-static int __init setup_physnodes(unsigned long start, unsigned long end,
-					int acpi, int amd)
-{
-	int ret = 0;
-	int i;
-
-	memset(physnodes, 0, sizeof(physnodes));
-#ifdef CONFIG_ACPI_NUMA
-	if (acpi)
-		acpi_get_nodes(physnodes, start, end);
-#endif
-#ifdef CONFIG_AMD_NUMA
-	if (amd)
-		amd_get_nodes(physnodes);
-#endif
-	/*
-	 * Basic sanity checking on the physical node map: there may be errors
-	 * if the SRAT or AMD code incorrectly reported the topology or the mem=
-	 * kernel parameter is used.
-	 */
-	for (i = 0; i < MAX_NUMNODES; i++) {
-		if (physnodes[i].start == physnodes[i].end)
-			continue;
-		if (physnodes[i].start > end) {
-			physnodes[i].end = physnodes[i].start;
-			continue;
-		}
-		if (physnodes[i].end < start) {
-			physnodes[i].start = physnodes[i].end;
+		/* and there's no empty block */
+		if (bi->start == bi->end) {
+			numa_remove_memblk_from(i--, mi);
 			continue;
 		}
-		if (physnodes[i].start < start)
-			physnodes[i].start = start;
-		if (physnodes[i].end > end)
-			physnodes[i].end = end;
-		ret++;
-	}
 
-	/*
-	 * If no physical topology was detected, a single node is faked to cover
-	 * the entire address space.
-	 */
-	if (!ret) {
-		physnodes[ret].start = start;
-		physnodes[ret].end = end;
-		ret = 1;
-	}
-	return ret;
-}
-
-static void __init fake_physnodes(int acpi, int amd, int nr_nodes)
-{
-	int i;
-
-	BUG_ON(acpi && amd);
-#ifdef CONFIG_ACPI_NUMA
-	if (acpi)
-		acpi_fake_nodes(nodes, nr_nodes);
-#endif
-#ifdef CONFIG_AMD_NUMA
-	if (amd)
-		amd_fake_nodes(nodes, nr_nodes);
-#endif
-	if (!acpi && !amd)
-		for (i = 0; i < nr_cpu_ids; i++)
-			numa_set_node(i, 0);
-}
-
-/*
- * Setups up nid to range from addr to addr + size.  If the end
- * boundary is greater than max_addr, then max_addr is used instead.
- * The return value is 0 if there is additional memory left for
- * allocation past addr and -1 otherwise.  addr is adjusted to be at
- * the end of the node.
- */
-static int __init setup_node_range(int nid, u64 *addr, u64 size, u64 max_addr)
-{
-	int ret = 0;
-	nodes[nid].start = *addr;
-	*addr += size;
-	if (*addr >= max_addr) {
-		*addr = max_addr;
-		ret = -1;
-	}
-	nodes[nid].end = *addr;
-	node_set(nid, node_possible_map);
-	printk(KERN_INFO "Faking node %d at %016Lx-%016Lx (%LuMB)\n", nid,
-	       nodes[nid].start, nodes[nid].end,
-	       (nodes[nid].end - nodes[nid].start) >> 20);
-	return ret;
-}
-
-/*
- * Sets up nr_nodes fake nodes interleaved over physical nodes ranging from addr
- * to max_addr.  The return value is the number of nodes allocated.
- */
-static int __init split_nodes_interleave(u64 addr, u64 max_addr, int nr_nodes)
-{
-	nodemask_t physnode_mask = NODE_MASK_NONE;
-	u64 size;
-	int big;
-	int ret = 0;
-	int i;
-
-	if (nr_nodes <= 0)
-		return -1;
-	if (nr_nodes > MAX_NUMNODES) {
-		pr_info("numa=fake=%d too large, reducing to %d\n",
-			nr_nodes, MAX_NUMNODES);
-		nr_nodes = MAX_NUMNODES;
-	}
-
-	size = (max_addr - addr - memblock_x86_hole_size(addr, max_addr)) / nr_nodes;
-	/*
-	 * Calculate the number of big nodes that can be allocated as a result
-	 * of consolidating the remainder.
-	 */
-	big = ((size & ~FAKE_NODE_MIN_HASH_MASK) * nr_nodes) /
-		FAKE_NODE_MIN_SIZE;
-
-	size &= FAKE_NODE_MIN_HASH_MASK;
-	if (!size) {
-		pr_err("Not enough memory for each node.  "
-			"NUMA emulation disabled.\n");
-		return -1;
-	}
-
-	for (i = 0; i < MAX_NUMNODES; i++)
-		if (physnodes[i].start != physnodes[i].end)
-			node_set(i, physnode_mask);
-
-	/*
-	 * Continue to fill physical nodes with fake nodes until there is no
-	 * memory left on any of them.
-	 */
-	while (nodes_weight(physnode_mask)) {
-		for_each_node_mask(i, physnode_mask) {
-			u64 end = physnodes[i].start + size;
-			u64 dma32_end = PFN_PHYS(MAX_DMA32_PFN);
-
-			if (ret < big)
-				end += FAKE_NODE_MIN_SIZE;
+		for (j = i + 1; j < mi->nr_blks; j++) {
+			struct numa_memblk *bj = &mi->blk[j];
+			unsigned long start, end;
 
 			/*
-			 * Continue to add memory to this fake node if its
-			 * non-reserved memory is less than the per-node size.
+			 * See whether there are overlapping blocks.  Whine
+			 * about but allow overlaps of the same nid.  They
+			 * will be merged below.
 			 */
-			while (end - physnodes[i].start -
-				memblock_x86_hole_size(physnodes[i].start, end) < size) {
-				end += FAKE_NODE_MIN_SIZE;
-				if (end > physnodes[i].end) {
-					end = physnodes[i].end;
-					break;
+			if (bi->end > bj->start && bi->start < bj->end) {
+				if (bi->nid != bj->nid) {
+					pr_err("NUMA: node %d (%Lx-%Lx) overlaps with node %d (%Lx-%Lx)\n",
+					       bi->nid, bi->start, bi->end,
+					       bj->nid, bj->start, bj->end);
+					return -EINVAL;
 				}
+				pr_warning("NUMA: Warning: node %d (%Lx-%Lx) overlaps with itself (%Lx-%Lx)\n",
+					   bi->nid, bi->start, bi->end,
+					   bj->start, bj->end);
 			}
 
 			/*
-			 * If there won't be at least FAKE_NODE_MIN_SIZE of
-			 * non-reserved memory in ZONE_DMA32 for the next node,
-			 * this one must extend to the boundary.
-			 */
-			if (end < dma32_end && dma32_end - end -
-			    memblock_x86_hole_size(end, dma32_end) < FAKE_NODE_MIN_SIZE)
-				end = dma32_end;
-
-			/*
-			 * If there won't be enough non-reserved memory for the
-			 * next node, this one must extend to the end of the
-			 * physical node.
+			 * Join together blocks on the same node, holes
+			 * between which don't overlap with memory on other
+			 * nodes.
 			 */
-			if (physnodes[i].end - end -
-			    memblock_x86_hole_size(end, physnodes[i].end) < size)
-				end = physnodes[i].end;
-
-			/*
-			 * Avoid allocating more nodes than requested, which can
-			 * happen as a result of rounding down each node's size
-			 * to FAKE_NODE_MIN_SIZE.
-			 */
-			if (nodes_weight(physnode_mask) + ret >= nr_nodes)
-				end = physnodes[i].end;
-
-			if (setup_node_range(ret++, &physnodes[i].start,
-						end - physnodes[i].start,
-						physnodes[i].end) < 0)
-				node_clear(i, physnode_mask);
+			if (bi->nid != bj->nid)
+				continue;
+			start = max(min(bi->start, bj->start), low);
+			end = min(max(bi->end, bj->end), high);
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
+			printk(KERN_INFO "NUMA: Node %d [%Lx,%Lx) + [%Lx,%Lx) -> [%lx,%lx)\n",
+			       bi->nid, bi->start, bi->end, bj->start, bj->end,
+			       start, end);
+			bi->start = start;
+			bi->end = end;
+			numa_remove_memblk_from(j--, mi);
 		}
 	}
-	return ret;
-}
-
-/*
- * Returns the end address of a node so that there is at least `size' amount of
- * non-reserved memory or `max_addr' is reached.
- */
-static u64 __init find_end_of_node(u64 start, u64 max_addr, u64 size)
-{
-	u64 end = start + size;
 
-	while (end - start - memblock_x86_hole_size(start, end) < size) {
-		end += FAKE_NODE_MIN_SIZE;
-		if (end > max_addr) {
-			end = max_addr;
-			break;
-		}
+	for (i = mi->nr_blks; i < ARRAY_SIZE(mi->blk); i++) {
+		mi->blk[i].start = mi->blk[i].end = 0;
+		mi->blk[i].nid = NUMA_NO_NODE;
 	}
-	return end;
+
+	return 0;
 }
 
 /*
- * Sets up fake nodes of `size' interleaved over physical nodes ranging from
- * `addr' to `max_addr'.  The return value is the number of nodes allocated.
+ * Set nodes, which have memory in @mi, in *@nodemask.
  */
-static int __init split_nodes_size_interleave(u64 addr, u64 max_addr, u64 size)
+static void __init numa_nodemask_from_meminfo(nodemask_t *nodemask,
+					      const struct numa_meminfo *mi)
 {
-	nodemask_t physnode_mask = NODE_MASK_NONE;
-	u64 min_size;
-	int ret = 0;
 	int i;
 
-	if (!size)
-		return -1;
-	/*
-	 * The limit on emulated nodes is MAX_NUMNODES, so the size per node is
-	 * increased accordingly if the requested size is too small.  This
-	 * creates a uniform distribution of node sizes across the entire
-	 * machine (but not necessarily over physical nodes).
-	 */
-	min_size = (max_addr - addr - memblock_x86_hole_size(addr, max_addr)) /
-						MAX_NUMNODES;
-	min_size = max(min_size, FAKE_NODE_MIN_SIZE);
-	if ((min_size & FAKE_NODE_MIN_HASH_MASK) < min_size)
-		min_size = (min_size + FAKE_NODE_MIN_SIZE) &
-						FAKE_NODE_MIN_HASH_MASK;
-	if (size < min_size) {
-		pr_err("Fake node size %LuMB too small, increasing to %LuMB\n",
-			size >> 20, min_size >> 20);
-		size = min_size;
-	}
-	size &= FAKE_NODE_MIN_HASH_MASK;
-
-	for (i = 0; i < MAX_NUMNODES; i++)
-		if (physnodes[i].start != physnodes[i].end)
-			node_set(i, physnode_mask);
-	/*
-	 * Fill physical nodes with fake nodes of size until there is no memory
-	 * left on any of them.
-	 */
-	while (nodes_weight(physnode_mask)) {
-		for_each_node_mask(i, physnode_mask) {
-			u64 dma32_end = MAX_DMA32_PFN << PAGE_SHIFT;
-			u64 end;
-
-			end = find_end_of_node(physnodes[i].start,
-						physnodes[i].end, size);
-			/*
-			 * If there won't be at least FAKE_NODE_MIN_SIZE of
-			 * non-reserved memory in ZONE_DMA32 for the next node,
-			 * this one must extend to the boundary.
-			 */
-			if (end < dma32_end && dma32_end - end -
-			    memblock_x86_hole_size(end, dma32_end) < FAKE_NODE_MIN_SIZE)
-				end = dma32_end;
+	for (i = 0; i < ARRAY_SIZE(mi->blk); i++)
+		if (mi->blk[i].start != mi->blk[i].end &&
+		    mi->blk[i].nid != NUMA_NO_NODE)
+			node_set(mi->blk[i].nid, *nodemask);
+}
 
-			/*
-			 * If there won't be enough non-reserved memory for the
-			 * next node, this one must extend to the end of the
-			 * physical node.
-			 */
-			if (physnodes[i].end - end -
-			    memblock_x86_hole_size(end, physnodes[i].end) < size)
-				end = physnodes[i].end;
+/**
+ * numa_reset_distance - Reset NUMA distance table
+ *
+ * The current table is freed.  The next numa_set_distance() call will
+ * create a new one.
+ */
+void __init numa_reset_distance(void)
+{
+	size_t size = numa_distance_cnt * numa_distance_cnt * sizeof(numa_distance[0]);
 
-			/*
-			 * Setup the fake node that will be allocated as bootmem
-			 * later.  If setup_node_range() returns non-zero, there
-			 * is no more memory available on this physical node.
-			 */
-			if (setup_node_range(ret++, &physnodes[i].start,
-						end - physnodes[i].start,
-						physnodes[i].end) < 0)
-				node_clear(i, physnode_mask);
-		}
-	}
-	return ret;
+	/* numa_distance could be 1LU marking allocation failure, test cnt */
+	if (numa_distance_cnt)
+		memblock_x86_free_range(__pa(numa_distance),
+					__pa(numa_distance) + size);
+	numa_distance_cnt = 0;
+	numa_distance = NULL;	/* enable table creation */
 }
 
-/*
- * Sets up the system RAM area from start_pfn to last_pfn according to the
- * numa=fake command-line option.
- */
-static int __init numa_emulation(unsigned long start_pfn,
-			unsigned long last_pfn, int acpi, int amd)
+static int __init numa_alloc_distance(void)
 {
-	u64 addr = start_pfn << PAGE_SHIFT;
-	u64 max_addr = last_pfn << PAGE_SHIFT;
-	int num_nodes;
-	int i;
+	nodemask_t nodes_parsed;
+	size_t size;
+	int i, j, cnt = 0;
+	u64 phys;
 
-	/*
-	 * If the numa=fake command-line contains a 'M' or 'G', it represents
-	 * the fixed node size.  Otherwise, if it is just a single number N,
-	 * split the system RAM into N fake nodes.
-	 */
-	if (strchr(cmdline, 'M') || strchr(cmdline, 'G')) {
-		u64 size;
+	/* size the new table and allocate it */
+	nodes_parsed = numa_nodes_parsed;
+	numa_nodemask_from_meminfo(&nodes_parsed, &numa_meminfo);
 
-		size = memparse(cmdline, &cmdline);
-		num_nodes = split_nodes_size_interleave(addr, max_addr, size);
-	} else {
-		unsigned long n;
+	for_each_node_mask(i, nodes_parsed)
+		cnt = i;
+	cnt++;
+	size = cnt * cnt * sizeof(numa_distance[0]);
 
-		n = simple_strtoul(cmdline, NULL, 0);
-		num_nodes = split_nodes_interleave(addr, max_addr, n);
+	phys = memblock_find_in_range(0, (u64)max_pfn_mapped << PAGE_SHIFT,
+				      size, PAGE_SIZE);
+	if (phys == MEMBLOCK_ERROR) {
+		pr_warning("NUMA: Warning: can't allocate distance table!\n");
+		/* don't retry until explicitly reset */
+		numa_distance = (void *)1LU;
+		return -ENOMEM;
 	}
+	memblock_x86_reserve_range(phys, phys + size, "NUMA DIST");
 
-	if (num_nodes < 0)
-		return num_nodes;
-	memnode_shift = compute_hash_shift(nodes, num_nodes, NULL);
-	if (memnode_shift < 0) {
-		memnode_shift = 0;
-		printk(KERN_ERR "No NUMA hash function found.  NUMA emulation "
-		       "disabled.\n");
-		return -1;
-	}
+	numa_distance = __va(phys);
+	numa_distance_cnt = cnt;
+
+	/* fill with the default distances */
+	for (i = 0; i < cnt; i++)
+		for (j = 0; j < cnt; j++)
+			numa_distance[i * cnt + j] = i == j ?
+				LOCAL_DISTANCE : REMOTE_DISTANCE;
+	printk(KERN_DEBUG "NUMA: Initialized distance table, cnt=%d\n", cnt);
 
-	/*
-	 * We need to vacate all active ranges that may have been registered for
-	 * the e820 memory map.
-	 */
-	remove_all_active_ranges();
-	for_each_node_mask(i, node_possible_map) {
-		memblock_x86_register_active_regions(i, nodes[i].start >> PAGE_SHIFT,
-						nodes[i].end >> PAGE_SHIFT);
-		setup_node_bootmem(i, nodes[i].start, nodes[i].end);
-	}
-	setup_physnodes(addr, max_addr, acpi, amd);
-	fake_physnodes(acpi, amd, num_nodes);
-	numa_init_array();
 	return 0;
 }
-#endif /* CONFIG_NUMA_EMU */
 
-void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn,
-				int acpi, int amd)
+/**
+ * numa_set_distance - Set NUMA distance from one NUMA to another
+ * @from: the 'from' node to set distance
+ * @to: the 'to'  node to set distance
+ * @distance: NUMA distance
+ *
+ * Set the distance from node @from to @to to @distance.  If distance table
+ * doesn't exist, one which is large enough to accomodate all the currently
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
 {
-	int i;
-
-	nodes_clear(node_possible_map);
-	nodes_clear(node_online_map);
-
-#ifdef CONFIG_NUMA_EMU
-	setup_physnodes(start_pfn << PAGE_SHIFT, last_pfn << PAGE_SHIFT,
-			acpi, amd);
-	if (cmdline && !numa_emulation(start_pfn, last_pfn, acpi, amd))
+	if (!numa_distance && numa_alloc_distance() < 0)
 		return;
-	setup_physnodes(start_pfn << PAGE_SHIFT, last_pfn << PAGE_SHIFT,
-			acpi, amd);
-	nodes_clear(node_possible_map);
-	nodes_clear(node_online_map);
-#endif
 
-#ifdef CONFIG_ACPI_NUMA
-	if (!numa_off && acpi && !acpi_scan_nodes(start_pfn << PAGE_SHIFT,
-						  last_pfn << PAGE_SHIFT))
+	if (from >= numa_distance_cnt || to >= numa_distance_cnt) {
+		printk_once(KERN_DEBUG "NUMA: Debug: distance out of bound, from=%d to=%d distance=%d\n",
+			    from, to, distance);
 		return;
-	nodes_clear(node_possible_map);
-	nodes_clear(node_online_map);
-#endif
+	}
 
-#ifdef CONFIG_AMD_NUMA
-	if (!numa_off && amd && !amd_scan_nodes())
+	if ((u8)distance != distance ||
+	    (from == to && distance != LOCAL_DISTANCE)) {
+		pr_warn_once("NUMA: Warning: invalid distance parameter, from=%d to=%d distance=%d\n",
+			     from, to, distance);
 		return;
-	nodes_clear(node_possible_map);
-	nodes_clear(node_online_map);
-#endif
-	printk(KERN_INFO "%s\n",
-	       numa_off ? "NUMA turned off" : "No NUMA configuration found");
+	}
 
-	printk(KERN_INFO "Faking a node at %016lx-%016lx\n",
-	       start_pfn << PAGE_SHIFT,
-	       last_pfn << PAGE_SHIFT);
-	/* setup dummy node covering all memory */
-	memnode_shift = 63;
-	memnodemap = memnode.embedded_map;
-	memnodemap[0] = 0;
-	node_set_online(0);
-	node_set(0, node_possible_map);
-	for (i = 0; i < nr_cpu_ids; i++)
-		numa_set_node(i, 0);
-	memblock_x86_register_active_regions(0, start_pfn, last_pfn);
-	setup_node_bootmem(0, start_pfn << PAGE_SHIFT, last_pfn << PAGE_SHIFT);
+	numa_distance[from * numa_distance_cnt + to] = distance;
 }
 
-unsigned long __init numa_free_all_bootmem(void)
+int __node_distance(int from, int to)
 {
-	unsigned long pages = 0;
-	int i;
+	if (from >= numa_distance_cnt || to >= numa_distance_cnt)
+		return from == to ? LOCAL_DISTANCE : REMOTE_DISTANCE;
+	return numa_distance[from * numa_distance_cnt + to];
+}
+EXPORT_SYMBOL(__node_distance);
 
-	for_each_online_node(i)
-		pages += free_all_bootmem_node(NODE_DATA(i));
+/*
+ * Sanity check to catch more bad NUMA configurations (they are amazingly
+ * common).  Make sure the nodes cover all memory.
+ */
+static bool __init numa_meminfo_cover_memory(const struct numa_meminfo *mi)
+{
+	unsigned long numaram, e820ram;
+	int i;
 
-	pages += free_all_memory_core_early(MAX_NUMNODES);
+	numaram = 0;
+	for (i = 0; i < mi->nr_blks; i++) {
+		unsigned long s = mi->blk[i].start >> PAGE_SHIFT;
+		unsigned long e = mi->blk[i].end >> PAGE_SHIFT;
+		numaram += e - s;
+		numaram -= __absent_pages_in_range(mi->blk[i].nid, s, e);
+		if ((long)numaram < 0)
+			numaram = 0;
+	}
 
-	return pages;
+	e820ram = max_pfn - (memblock_x86_hole_size(0,
+					max_pfn << PAGE_SHIFT) >> PAGE_SHIFT);
+	/* We seem to lose 3 pages somewhere. Allow 1M of slack. */
+	if ((long)(e820ram - numaram) >= (1 << (20 - PAGE_SHIFT))) {
+		printk(KERN_ERR "NUMA: nodes only cover %luMB of your %luMB e820 RAM. Not used.\n",
+		       (numaram << PAGE_SHIFT) >> 20,
+		       (e820ram << PAGE_SHIFT) >> 20);
+		return false;
+	}
+	return true;
 }
 
-#ifdef CONFIG_NUMA
-
-static __init int find_near_online_node(int node)
+static int __init numa_register_memblks(struct numa_meminfo *mi)
 {
-	int n, val;
-	int min_val = INT_MAX;
-	int best_node = -1;
+	int i, nid;
 
-	for_each_online_node(n) {
-		val = node_distance(node, n);
+	/* Account for nodes with cpus and no memory */
+	node_possible_map = numa_nodes_parsed;
+	numa_nodemask_from_meminfo(&node_possible_map, mi);
+	if (WARN_ON(nodes_empty(node_possible_map)))
+		return -EINVAL;
 
-		if (val < min_val) {
-			min_val = val;
-			best_node = n;
+	memnode_shift = compute_hash_shift(mi);
+	if (memnode_shift < 0) {
+		printk(KERN_ERR "NUMA: No NUMA node hash function found. Contact maintainer\n");
+		return -EINVAL;
+	}
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
+		u64 start = (u64)max_pfn << PAGE_SHIFT;
+		u64 end = 0;
+
+		for (i = 0; i < mi->nr_blks; i++) {
+			if (nid != mi->blk[i].nid)
+				continue;
+			start = min(mi->blk[i].start, start);
+			end = max(mi->blk[i].end, end);
 		}
+
+		if (start < end)
+			setup_node_bootmem(nid, start, end);
 	}
 
-	return best_node;
+	return 0;
 }
 
-/*
- * Setup early cpu_to_node.
+/**
+ * dummy_numma_init - Fallback dummy NUMA init
  *
- * Populate cpu_to_node[] only if x86_cpu_to_apicid[],
- * and apicid_to_node[] tables have valid entries for a CPU.
- * This means we skip cpu_to_node[] initialisation for NUMA
- * emulation and faking node case (when running a kernel compiled
- * for NUMA on a non NUMA box), which is OK as cpu_to_node[]
- * is already initialized in a round robin manner at numa_init_array,
- * prior to this call, and this initialization is good enough
- * for the fake NUMA cases.
+ * Used if there's no underlying NUMA architecture, NUMA initialization
+ * fails, or NUMA is disabled on the command line.
  *
- * Called before the per_cpu areas are setup.
+ * Must online at least one node and add memory blocks that cover all
+ * allowed memory.  This function must not fail.
  */
-void __init init_cpu_to_node(void)
+static int __init dummy_numa_init(void)
 {
-	int cpu;
-	u16 *cpu_to_apicid = early_per_cpu_ptr(x86_cpu_to_apicid);
-
-	BUG_ON(cpu_to_apicid == NULL);
+	printk(KERN_INFO "%s\n",
+	       numa_off ? "NUMA turned off" : "No NUMA configuration found");
+	printk(KERN_INFO "Faking a node at %016lx-%016lx\n",
+	       0LU, max_pfn << PAGE_SHIFT);
 
-	for_each_possible_cpu(cpu) {
-		int node;
-		u16 apicid = cpu_to_apicid[cpu];
+	node_set(0, numa_nodes_parsed);
+	numa_add_memblk(0, 0, (u64)max_pfn << PAGE_SHIFT);
 
-		if (apicid == BAD_APICID)
-			continue;
-		node = apicid_to_node[apicid];
-		if (node == NUMA_NO_NODE)
-			continue;
-		if (!node_online(node))
-			node = find_near_online_node(node);
-		numa_set_node(cpu, node);
-	}
+	return 0;
 }
-#endif
 
-
-void __cpuinit numa_set_node(int cpu, int node)
+static int __init numa_init(int (*init_func)(void))
 {
-	int *cpu_to_node_map = early_per_cpu_ptr(x86_cpu_to_node_map);
-
-	/* early setting, no percpu area yet */
-	if (cpu_to_node_map) {
-		cpu_to_node_map[cpu] = node;
-		return;
-	}
-
-#ifdef CONFIG_DEBUG_PER_CPU_MAPS
-	if (cpu >= nr_cpu_ids || !cpu_possible(cpu)) {
-		printk(KERN_ERR "numa_set_node: invalid cpu# (%d)\n", cpu);
-		dump_stack();
-		return;
-	}
-#endif
-	per_cpu(x86_cpu_to_node_map, cpu) = node;
+	int i;
+	int ret;
 
-	if (node != NUMA_NO_NODE)
-		set_cpu_numa_node(cpu, node);
-}
+	for (i = 0; i < MAX_LOCAL_APIC; i++)
+		set_apicid_to_node(i, NUMA_NO_NODE);
 
-void __cpuinit numa_clear_node(int cpu)
-{
-	numa_set_node(cpu, NUMA_NO_NODE);
-}
-
-#ifndef CONFIG_DEBUG_PER_CPU_MAPS
+	nodes_clear(numa_nodes_parsed);
+	nodes_clear(node_possible_map);
+	nodes_clear(node_online_map);
+	memset(&numa_meminfo, 0, sizeof(numa_meminfo));
+	remove_all_active_ranges();
+	numa_reset_distance();
 
-#ifndef CONFIG_NUMA_EMU
-void __cpuinit numa_add_cpu(int cpu)
-{
-	cpumask_set_cpu(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
-}
+	ret = init_func();
+	if (ret < 0)
+		return ret;
+	ret = numa_cleanup_meminfo(&numa_meminfo);
+	if (ret < 0)
+		return ret;
 
-void __cpuinit numa_remove_cpu(int cpu)
-{
-	cpumask_clear_cpu(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
-}
-#else
-void __cpuinit numa_add_cpu(int cpu)
-{
-	unsigned long addr;
-	u16 apicid;
-	int physnid;
-	int nid = NUMA_NO_NODE;
+	numa_emulation(&numa_meminfo, numa_distance_cnt);
 
-	nid = early_cpu_to_node(cpu);
-	BUG_ON(nid == NUMA_NO_NODE || !node_online(nid));
+	ret = numa_register_memblks(&numa_meminfo);
+	if (ret < 0)
+		return ret;
 
-	/*
-	 * Use the starting address of the emulated node to find which physical
-	 * node it is allocated on.
-	 */
-	addr = node_start_pfn(nid) << PAGE_SHIFT;
-	for (physnid = 0; physnid < MAX_NUMNODES; physnid++)
-		if (addr >= physnodes[physnid].start &&
-		    addr < physnodes[physnid].end)
-			break;
+	for (i = 0; i < nr_cpu_ids; i++) {
+		int nid = early_cpu_to_node(i);
 
-	/*
-	 * Map the cpu to each emulated node that is allocated on the physical
-	 * node of the cpu's apic id.
-	 */
-	for_each_online_node(nid) {
-		addr = node_start_pfn(nid) << PAGE_SHIFT;
-		if (addr >= physnodes[physnid].start &&
-		    addr < physnodes[physnid].end)
-			cpumask_set_cpu(cpu, node_to_cpumask_map[nid]);
+		if (nid == NUMA_NO_NODE)
+			continue;
+		if (!node_online(nid))
+			numa_clear_node(i);
 	}
+	numa_init_array();
+	return 0;
 }
 
-void __cpuinit numa_remove_cpu(int cpu)
+void __init initmem_init(void)
 {
-	int i;
+	int ret;
 
-	for_each_online_node(i)
-		cpumask_clear_cpu(cpu, node_to_cpumask_map[i]);
-}
-#endif /* !CONFIG_NUMA_EMU */
-
-#else /* CONFIG_DEBUG_PER_CPU_MAPS */
-static struct cpumask __cpuinit *debug_cpumask_set_cpu(int cpu, int enable)
-{
-	int node = early_cpu_to_node(cpu);
-	struct cpumask *mask;
-	char buf[64];
-
-	mask = node_to_cpumask_map[node];
-	if (!mask) {
-		pr_err("node_to_cpumask_map[%i] NULL\n", node);
-		dump_stack();
-		return NULL;
+	if (!numa_off) {
+#ifdef CONFIG_ACPI_NUMA
+		ret = numa_init(x86_acpi_numa_init);
+		if (!ret)
+			return;
+#endif
+#ifdef CONFIG_AMD_NUMA
+		ret = numa_init(amd_numa_init);
+		if (!ret)
+			return;
+#endif
 	}
 
-	cpulist_scnprintf(buf, sizeof(buf), mask);
-	printk(KERN_DEBUG "%s cpu %d node %d: mask now %s\n",
-		enable ? "numa_add_cpu" : "numa_remove_cpu",
-		cpu, node, buf);
-	return mask;
+	numa_init(dummy_numa_init);
 }
 
-/*
- * --------- debug versions of the numa functions ---------
- */
-#ifndef CONFIG_NUMA_EMU
-static void __cpuinit numa_set_cpumask(int cpu, int enable)
-{
-	struct cpumask *mask;
-
-	mask = debug_cpumask_set_cpu(cpu, enable);
-	if (!mask)
-		return;
-
-	if (enable)
-		cpumask_set_cpu(cpu, mask);
-	else
-		cpumask_clear_cpu(cpu, mask);
-}
-#else
-static void __cpuinit numa_set_cpumask(int cpu, int enable)
+unsigned long __init numa_free_all_bootmem(void)
 {
-	int node = early_cpu_to_node(cpu);
-	struct cpumask *mask;
+	unsigned long pages = 0;
 	int i;
 
-	for_each_online_node(i) {
-		unsigned long addr;
-
-		addr = node_start_pfn(i) << PAGE_SHIFT;
-		if (addr < physnodes[node].start ||
-					addr >= physnodes[node].end)
-			continue;
-		mask = debug_cpumask_set_cpu(cpu, enable);
-		if (!mask)
-			return;
-
-		if (enable)
-			cpumask_set_cpu(cpu, mask);
-		else
-			cpumask_clear_cpu(cpu, mask);
-	}
-}
-#endif /* CONFIG_NUMA_EMU */
+	for_each_online_node(i)
+		pages += free_all_bootmem_node(NODE_DATA(i));
 
-void __cpuinit numa_add_cpu(int cpu)
-{
-	numa_set_cpumask(cpu, 1);
-}
+	pages += free_all_memory_core_early(MAX_NUMNODES);
 
-void __cpuinit numa_remove_cpu(int cpu)
-{
-	numa_set_cpumask(cpu, 0);
+	return pages;
 }
 
-int __cpu_to_node(int cpu)
+int __cpuinit numa_cpu_node(int cpu)
 {
-	if (early_per_cpu_ptr(x86_cpu_to_node_map)) {
-		printk(KERN_WARNING
-			"cpu_to_node(%d): usage too early!\n", cpu);
-		dump_stack();
-		return early_per_cpu_ptr(x86_cpu_to_node_map)[cpu];
-	}
-	return per_cpu(x86_cpu_to_node_map, cpu);
-}
-EXPORT_SYMBOL(__cpu_to_node);
+	int apicid = early_per_cpu(x86_cpu_to_apicid, cpu);
 
-/*
- * Same function as cpu_to_node() but used if called before the
- * per_cpu areas are setup.
- */
-int early_cpu_to_node(int cpu)
-{
-	if (early_per_cpu_ptr(x86_cpu_to_node_map))
-		return early_per_cpu_ptr(x86_cpu_to_node_map)[cpu];
-
-	if (!cpu_possible(cpu)) {
-		printk(KERN_WARNING
-			"early_cpu_to_node(%d): no per_cpu area!\n", cpu);
-		dump_stack();
-		return NUMA_NO_NODE;
-	}
-	return per_cpu(x86_cpu_to_node_map, cpu);
+	if (apicid != BAD_APICID)
+		return __apicid_to_node[apicid];
+	return NUMA_NO_NODE;
 }
-
-/*
- * --------- end of debug versions of the numa functions ---------
- */
-
-#endif /* CONFIG_DEBUG_PER_CPU_MAPS */
diff --git a/arch/x86/mm/numa_emulation.c b/arch/x86/mm/numa_emulation.c
new file mode 100644
index 0000000..ad091e4
--- /dev/null
+++ b/arch/x86/mm/numa_emulation.c
@@ -0,0 +1,494 @@
+/*
+ * NUMA emulation
+ */
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/topology.h>
+#include <linux/memblock.h>
+#include <asm/dma.h>
+
+#include "numa_internal.h"
+
+static int emu_nid_to_phys[MAX_NUMNODES] __cpuinitdata;
+static char *emu_cmdline __initdata;
+
+void __init numa_emu_cmdline(char *str)
+{
+	emu_cmdline = str;
+}
+
+static int __init emu_find_memblk_by_nid(int nid, const struct numa_meminfo *mi)
+{
+	int i;
+
+	for (i = 0; i < mi->nr_blks; i++)
+		if (mi->blk[i].nid == nid)
+			return i;
+	return -ENOENT;
+}
+
+/*
+ * Sets up nid to range from @start to @end.  The return value is -errno if
+ * something went wrong, 0 otherwise.
+ */
+static int __init emu_setup_memblk(struct numa_meminfo *ei,
+				   struct numa_meminfo *pi,
+				   int nid, int phys_blk, u64 size)
+{
+	struct numa_memblk *eb = &ei->blk[ei->nr_blks];
+	struct numa_memblk *pb = &pi->blk[phys_blk];
+
+	if (ei->nr_blks >= NR_NODE_MEMBLKS) {
+		pr_err("NUMA: Too many emulated memblks, failing emulation\n");
+		return -EINVAL;
+	}
+
+	ei->nr_blks++;
+	eb->start = pb->start;
+	eb->end = pb->start + size;
+	eb->nid = nid;
+
+	if (emu_nid_to_phys[nid] == NUMA_NO_NODE)
+		emu_nid_to_phys[nid] = pb->nid;
+
+	pb->start += size;
+	if (pb->start >= pb->end) {
+		WARN_ON_ONCE(pb->start > pb->end);
+		numa_remove_memblk_from(phys_blk, pi);
+	}
+
+	printk(KERN_INFO "Faking node %d at %016Lx-%016Lx (%LuMB)\n", nid,
+	       eb->start, eb->end, (eb->end - eb->start) >> 20);
+	return 0;
+}
+
+/*
+ * Sets up nr_nodes fake nodes interleaved over physical nodes ranging from addr
+ * to max_addr.  The return value is the number of nodes allocated.
+ */
+static int __init split_nodes_interleave(struct numa_meminfo *ei,
+					 struct numa_meminfo *pi,
+					 u64 addr, u64 max_addr, int nr_nodes)
+{
+	nodemask_t physnode_mask = NODE_MASK_NONE;
+	u64 size;
+	int big;
+	int nid = 0;
+	int i, ret;
+
+	if (nr_nodes <= 0)
+		return -1;
+	if (nr_nodes > MAX_NUMNODES) {
+		pr_info("numa=fake=%d too large, reducing to %d\n",
+			nr_nodes, MAX_NUMNODES);
+		nr_nodes = MAX_NUMNODES;
+	}
+
+	size = (max_addr - addr - memblock_x86_hole_size(addr, max_addr)) / nr_nodes;
+	/*
+	 * Calculate the number of big nodes that can be allocated as a result
+	 * of consolidating the remainder.
+	 */
+	big = ((size & ~FAKE_NODE_MIN_HASH_MASK) * nr_nodes) /
+		FAKE_NODE_MIN_SIZE;
+
+	size &= FAKE_NODE_MIN_HASH_MASK;
+	if (!size) {
+		pr_err("Not enough memory for each node.  "
+			"NUMA emulation disabled.\n");
+		return -1;
+	}
+
+	for (i = 0; i < pi->nr_blks; i++)
+		node_set(pi->blk[i].nid, physnode_mask);
+
+	/*
+	 * Continue to fill physical nodes with fake nodes until there is no
+	 * memory left on any of them.
+	 */
+	while (nodes_weight(physnode_mask)) {
+		for_each_node_mask(i, physnode_mask) {
+			u64 dma32_end = PFN_PHYS(MAX_DMA32_PFN);
+			u64 start, limit, end;
+			int phys_blk;
+
+			phys_blk = emu_find_memblk_by_nid(i, pi);
+			if (phys_blk < 0) {
+				node_clear(i, physnode_mask);
+				continue;
+			}
+			start = pi->blk[phys_blk].start;
+			limit = pi->blk[phys_blk].end;
+			end = start + size;
+
+			if (nid < big)
+				end += FAKE_NODE_MIN_SIZE;
+
+			/*
+			 * Continue to add memory to this fake node if its
+			 * non-reserved memory is less than the per-node size.
+			 */
+			while (end - start -
+			       memblock_x86_hole_size(start, end) < size) {
+				end += FAKE_NODE_MIN_SIZE;
+				if (end > limit) {
+					end = limit;
+					break;
+				}
+			}
+
+			/*
+			 * If there won't be at least FAKE_NODE_MIN_SIZE of
+			 * non-reserved memory in ZONE_DMA32 for the next node,
+			 * this one must extend to the boundary.
+			 */
+			if (end < dma32_end && dma32_end - end -
+			    memblock_x86_hole_size(end, dma32_end) < FAKE_NODE_MIN_SIZE)
+				end = dma32_end;
+
+			/*
+			 * If there won't be enough non-reserved memory for the
+			 * next node, this one must extend to the end of the
+			 * physical node.
+			 */
+			if (limit - end -
+			    memblock_x86_hole_size(end, limit) < size)
+				end = limit;
+
+			ret = emu_setup_memblk(ei, pi, nid++ % nr_nodes,
+					       phys_blk,
+					       min(end, limit) - start);
+			if (ret < 0)
+				return ret;
+		}
+	}
+	return 0;
+}
+
+/*
+ * Returns the end address of a node so that there is at least `size' amount of
+ * non-reserved memory or `max_addr' is reached.
+ */
+static u64 __init find_end_of_node(u64 start, u64 max_addr, u64 size)
+{
+	u64 end = start + size;
+
+	while (end - start - memblock_x86_hole_size(start, end) < size) {
+		end += FAKE_NODE_MIN_SIZE;
+		if (end > max_addr) {
+			end = max_addr;
+			break;
+		}
+	}
+	return end;
+}
+
+/*
+ * Sets up fake nodes of `size' interleaved over physical nodes ranging from
+ * `addr' to `max_addr'.  The return value is the number of nodes allocated.
+ */
+static int __init split_nodes_size_interleave(struct numa_meminfo *ei,
+					      struct numa_meminfo *pi,
+					      u64 addr, u64 max_addr, u64 size)
+{
+	nodemask_t physnode_mask = NODE_MASK_NONE;
+	u64 min_size;
+	int nid = 0;
+	int i, ret;
+
+	if (!size)
+		return -1;
+	/*
+	 * The limit on emulated nodes is MAX_NUMNODES, so the size per node is
+	 * increased accordingly if the requested size is too small.  This
+	 * creates a uniform distribution of node sizes across the entire
+	 * machine (but not necessarily over physical nodes).
+	 */
+	min_size = (max_addr - addr - memblock_x86_hole_size(addr, max_addr)) /
+						MAX_NUMNODES;
+	min_size = max(min_size, FAKE_NODE_MIN_SIZE);
+	if ((min_size & FAKE_NODE_MIN_HASH_MASK) < min_size)
+		min_size = (min_size + FAKE_NODE_MIN_SIZE) &
+						FAKE_NODE_MIN_HASH_MASK;
+	if (size < min_size) {
+		pr_err("Fake node size %LuMB too small, increasing to %LuMB\n",
+			size >> 20, min_size >> 20);
+		size = min_size;
+	}
+	size &= FAKE_NODE_MIN_HASH_MASK;
+
+	for (i = 0; i < pi->nr_blks; i++)
+		node_set(pi->blk[i].nid, physnode_mask);
+
+	/*
+	 * Fill physical nodes with fake nodes of size until there is no memory
+	 * left on any of them.
+	 */
+	while (nodes_weight(physnode_mask)) {
+		for_each_node_mask(i, physnode_mask) {
+			u64 dma32_end = MAX_DMA32_PFN << PAGE_SHIFT;
+			u64 start, limit, end;
+			int phys_blk;
+
+			phys_blk = emu_find_memblk_by_nid(i, pi);
+			if (phys_blk < 0) {
+				node_clear(i, physnode_mask);
+				continue;
+			}
+			start = pi->blk[phys_blk].start;
+			limit = pi->blk[phys_blk].end;
+
+			end = find_end_of_node(start, limit, size);
+			/*
+			 * If there won't be at least FAKE_NODE_MIN_SIZE of
+			 * non-reserved memory in ZONE_DMA32 for the next node,
+			 * this one must extend to the boundary.
+			 */
+			if (end < dma32_end && dma32_end - end -
+			    memblock_x86_hole_size(end, dma32_end) < FAKE_NODE_MIN_SIZE)
+				end = dma32_end;
+
+			/*
+			 * If there won't be enough non-reserved memory for the
+			 * next node, this one must extend to the end of the
+			 * physical node.
+			 */
+			if (limit - end -
+			    memblock_x86_hole_size(end, limit) < size)
+				end = limit;
+
+			ret = emu_setup_memblk(ei, pi, nid++ % MAX_NUMNODES,
+					       phys_blk,
+					       min(end, limit) - start);
+			if (ret < 0)
+				return ret;
+		}
+	}
+	return 0;
+}
+
+/**
+ * numa_emulation - Emulate NUMA nodes
+ * @numa_meminfo: NUMA configuration to massage
+ * @numa_dist_cnt: The size of the physical NUMA distance table
+ *
+ * Emulate NUMA nodes according to the numa=fake kernel parameter.
+ * @numa_meminfo contains the physical memory configuration and is modified
+ * to reflect the emulated configuration on success.  @numa_dist_cnt is
+ * used to determine the size of the physical distance table.
+ *
+ * On success, the following modifications are made.
+ *
+ * - @numa_meminfo is updated to reflect the emulated nodes.
+ *
+ * - __apicid_to_node[] is updated such that APIC IDs are mapped to the
+ *   emulated nodes.
+ *
+ * - NUMA distance table is rebuilt to represent distances between emulated
+ *   nodes.  The distances are determined considering how emulated nodes
+ *   are mapped to physical nodes and match the actual distances.
+ *
+ * - emu_nid_to_phys[] reflects how emulated nodes are mapped to physical
+ *   nodes.  This is used by numa_add_cpu() and numa_remove_cpu().
+ *
+ * If emulation is not enabled or fails, emu_nid_to_phys[] is filled with
+ * identity mapping and no other modification is made.
+ */
+void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
+{
+	static struct numa_meminfo ei __initdata;
+	static struct numa_meminfo pi __initdata;
+	const u64 max_addr = max_pfn << PAGE_SHIFT;
+	u8 *phys_dist = NULL;
+	size_t phys_size = numa_dist_cnt * numa_dist_cnt * sizeof(phys_dist[0]);
+	int max_emu_nid, dfl_phys_nid;
+	int i, j, ret;
+
+	if (!emu_cmdline)
+		goto no_emu;
+
+	memset(&ei, 0, sizeof(ei));
+	pi = *numa_meminfo;
+
+	for (i = 0; i < MAX_NUMNODES; i++)
+		emu_nid_to_phys[i] = NUMA_NO_NODE;
+
+	/*
+	 * If the numa=fake command-line contains a 'M' or 'G', it represents
+	 * the fixed node size.  Otherwise, if it is just a single number N,
+	 * split the system RAM into N fake nodes.
+	 */
+	if (strchr(emu_cmdline, 'M') || strchr(emu_cmdline, 'G')) {
+		u64 size;
+
+		size = memparse(emu_cmdline, &emu_cmdline);
+		ret = split_nodes_size_interleave(&ei, &pi, 0, max_addr, size);
+	} else {
+		unsigned long n;
+
+		n = simple_strtoul(emu_cmdline, NULL, 0);
+		ret = split_nodes_interleave(&ei, &pi, 0, max_addr, n);
+	}
+
+	if (ret < 0)
+		goto no_emu;
+
+	if (numa_cleanup_meminfo(&ei) < 0) {
+		pr_warning("NUMA: Warning: constructed meminfo invalid, disabling emulation\n");
+		goto no_emu;
+	}
+
+	/* copy the physical distance table */
+	if (numa_dist_cnt) {
+		u64 phys;
+
+		phys = memblock_find_in_range(0,
+					      (u64)max_pfn_mapped << PAGE_SHIFT,
+					      phys_size, PAGE_SIZE);
+		if (phys == MEMBLOCK_ERROR) {
+			pr_warning("NUMA: Warning: can't allocate copy of distance table, disabling emulation\n");
+			goto no_emu;
+		}
+		memblock_x86_reserve_range(phys, phys + phys_size, "TMP NUMA DIST");
+		phys_dist = __va(phys);
+
+		for (i = 0; i < numa_dist_cnt; i++)
+			for (j = 0; j < numa_dist_cnt; j++)
+				phys_dist[i * numa_dist_cnt + j] =
+					node_distance(i, j);
+	}
+
+	/*
+	 * Determine the max emulated nid and the default phys nid to use
+	 * for unmapped nodes.
+	 */
+	max_emu_nid = 0;
+	dfl_phys_nid = NUMA_NO_NODE;
+	for (i = 0; i < ARRAY_SIZE(emu_nid_to_phys); i++) {
+		if (emu_nid_to_phys[i] != NUMA_NO_NODE) {
+			max_emu_nid = i;
+			if (dfl_phys_nid == NUMA_NO_NODE)
+				dfl_phys_nid = emu_nid_to_phys[i];
+		}
+	}
+	if (dfl_phys_nid == NUMA_NO_NODE) {
+		pr_warning("NUMA: Warning: can't determine default physical node, disabling emulation\n");
+		goto no_emu;
+	}
+
+	/* commit */
+	*numa_meminfo = ei;
+
+	/*
+	 * Transform __apicid_to_node table to use emulated nids by
+	 * reverse-mapping phys_nid.  The maps should always exist but fall
+	 * back to zero just in case.
+	 */
+	for (i = 0; i < ARRAY_SIZE(__apicid_to_node); i++) {
+		if (__apicid_to_node[i] == NUMA_NO_NODE)
+			continue;
+		for (j = 0; j < ARRAY_SIZE(emu_nid_to_phys); j++)
+			if (__apicid_to_node[i] == emu_nid_to_phys[j])
+				break;
+		__apicid_to_node[i] = j < ARRAY_SIZE(emu_nid_to_phys) ? j : 0;
+	}
+
+	/* make sure all emulated nodes are mapped to a physical node */
+	for (i = 0; i < ARRAY_SIZE(emu_nid_to_phys); i++)
+		if (emu_nid_to_phys[i] == NUMA_NO_NODE)
+			emu_nid_to_phys[i] = dfl_phys_nid;
+
+	/* transform distance table */
+	numa_reset_distance();
+	for (i = 0; i < max_emu_nid + 1; i++) {
+		for (j = 0; j < max_emu_nid + 1; j++) {
+			int physi = emu_nid_to_phys[i];
+			int physj = emu_nid_to_phys[j];
+			int dist;
+
+			if (physi >= numa_dist_cnt || physj >= numa_dist_cnt)
+				dist = physi == physj ?
+					LOCAL_DISTANCE : REMOTE_DISTANCE;
+			else
+				dist = phys_dist[physi * numa_dist_cnt + physj];
+
+			numa_set_distance(i, j, dist);
+		}
+	}
+
+	/* free the copied physical distance table */
+	if (phys_dist)
+		memblock_x86_free_range(__pa(phys_dist), __pa(phys_dist) + phys_size);
+	return;
+
+no_emu:
+	/* No emulation.  Build identity emu_nid_to_phys[] for numa_add_cpu() */
+	for (i = 0; i < ARRAY_SIZE(emu_nid_to_phys); i++)
+		emu_nid_to_phys[i] = i;
+}
+
+#ifndef CONFIG_DEBUG_PER_CPU_MAPS
+void __cpuinit numa_add_cpu(int cpu)
+{
+	int physnid, nid;
+
+	nid = early_cpu_to_node(cpu);
+	BUG_ON(nid == NUMA_NO_NODE || !node_online(nid));
+
+	physnid = emu_nid_to_phys[nid];
+
+	/*
+	 * Map the cpu to each emulated node that is allocated on the physical
+	 * node of the cpu's apic id.
+	 */
+	for_each_online_node(nid)
+		if (emu_nid_to_phys[nid] == physnid)
+			cpumask_set_cpu(cpu, node_to_cpumask_map[nid]);
+}
+
+void __cpuinit numa_remove_cpu(int cpu)
+{
+	int i;
+
+	for_each_online_node(i)
+		cpumask_clear_cpu(cpu, node_to_cpumask_map[i]);
+}
+#else	/* !CONFIG_DEBUG_PER_CPU_MAPS */
+static void __cpuinit numa_set_cpumask(int cpu, int enable)
+{
+	struct cpumask *mask;
+	int nid, physnid, i;
+
+	nid = early_cpu_to_node(cpu);
+	if (nid == NUMA_NO_NODE) {
+		/* early_cpu_to_node() already emits a warning and trace */
+		return;
+	}
+
+	physnid = emu_nid_to_phys[nid];
+
+	for_each_online_node(i) {
+		if (emu_nid_to_phys[nid] != physnid)
+			continue;
+
+		mask = debug_cpumask_set_cpu(cpu, enable);
+		if (!mask)
+			return;
+
+		if (enable)
+			cpumask_set_cpu(cpu, mask);
+		else
+			cpumask_clear_cpu(cpu, mask);
+	}
+}
+
+void __cpuinit numa_add_cpu(int cpu)
+{
+	numa_set_cpumask(cpu, 1);
+}
+
+void __cpuinit numa_remove_cpu(int cpu)
+{
+	numa_set_cpumask(cpu, 0);
+}
+#endif	/* !CONFIG_DEBUG_PER_CPU_MAPS */
diff --git a/arch/x86/mm/numa_internal.h b/arch/x86/mm/numa_internal.h
new file mode 100644
index 0000000..ef2d973
--- /dev/null
+++ b/arch/x86/mm/numa_internal.h
@@ -0,0 +1,31 @@
+#ifndef __X86_MM_NUMA_INTERNAL_H
+#define __X86_MM_NUMA_INTERNAL_H
+
+#include <linux/types.h>
+#include <asm/numa.h>
+
+struct numa_memblk {
+	u64			start;
+	u64			end;
+	int			nid;
+};
+
+struct numa_meminfo {
+	int			nr_blks;
+	struct numa_memblk	blk[NR_NODE_MEMBLKS];
+};
+
+void __init numa_remove_memblk_from(int idx, struct numa_meminfo *mi);
+int __init numa_cleanup_meminfo(struct numa_meminfo *mi);
+void __init numa_reset_distance(void);
+
+#ifdef CONFIG_NUMA_EMU
+void __init numa_emulation(struct numa_meminfo *numa_meminfo,
+			   int numa_dist_cnt);
+#else
+static inline void numa_emulation(struct numa_meminfo *numa_meminfo,
+				  int numa_dist_cnt)
+{ }
+#endif
+
+#endif	/* __X86_MM_NUMA_INTERNAL_H */
diff --git a/arch/x86/mm/srat_32.c b/arch/x86/mm/srat_32.c
index ae96e7b..48651c6 100644
--- a/arch/x86/mm/srat_32.c
+++ b/arch/x86/mm/srat_32.c
@@ -57,7 +57,7 @@ struct node_memory_chunk_s {
 static struct node_memory_chunk_s __initdata node_memory_chunk[MAXCHUNKS];
 
 static int __initdata num_memory_chunks; /* total number of memory chunks */
-static u8 __initdata apicid_to_pxm[MAX_APICID];
+static u8 __initdata apicid_to_pxm[MAX_LOCAL_APIC];
 
 int acpi_numa __initdata;
 
@@ -254,8 +254,8 @@ int __init get_memcfg_from_srat(void)
 	printk(KERN_DEBUG "Number of memory chunks in system = %d\n",
 			 num_memory_chunks);
 
-	for (i = 0; i < MAX_APICID; i++)
-		apicid_2_node[i] = pxm_to_node(apicid_to_pxm[i]);
+	for (i = 0; i < MAX_LOCAL_APIC; i++)
+		set_apicid_to_node(i, pxm_to_node(apicid_to_pxm[i]));
 
 	for (j = 0; j < num_memory_chunks; j++){
 		struct node_memory_chunk_s * chunk = &node_memory_chunk[j];
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index 603d285..8e9d339 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -26,88 +26,34 @@
 
 int acpi_numa __initdata;
 
-static struct acpi_table_slit *acpi_slit;
-
-static nodemask_t nodes_parsed __initdata;
-static nodemask_t cpu_nodes_parsed __initdata;
-static struct bootnode nodes[MAX_NUMNODES] __initdata;
 static struct bootnode nodes_add[MAX_NUMNODES];
 
-static int num_node_memblks __initdata;
-static struct bootnode node_memblk_range[NR_NODE_MEMBLKS] __initdata;
-static int memblk_nodeid[NR_NODE_MEMBLKS] __initdata;
-
 static __init int setup_node(int pxm)
 {
 	return acpi_map_pxm_to_node(pxm);
 }
 
-static __init int conflicting_memblks(unsigned long start, unsigned long end)
-{
-	int i;
-	for (i = 0; i < num_node_memblks; i++) {
-		struct bootnode *nd = &node_memblk_range[i];
-		if (nd->start == nd->end)
-			continue;
-		if (nd->end > start && nd->start < end)
-			return memblk_nodeid[i];
-		if (nd->end == end && nd->start == start)
-			return memblk_nodeid[i];
-	}
-	return -1;
-}
-
-static __init void cutoff_node(int i, unsigned long start, unsigned long end)
-{
-	struct bootnode *nd = &nodes[i];
-
-	if (nd->start < start) {
-		nd->start = start;
-		if (nd->end < nd->start)
-			nd->start = nd->end;
-	}
-	if (nd->end > end) {
-		nd->end = end;
-		if (nd->start > nd->end)
-			nd->start = nd->end;
-	}
-}
-
 static __init void bad_srat(void)
 {
-	int i;
 	printk(KERN_ERR "SRAT: SRAT not used.\n");
 	acpi_numa = -1;
-	for (i = 0; i < MAX_LOCAL_APIC; i++)
-		apicid_to_node[i] = NUMA_NO_NODE;
-	for (i = 0; i < MAX_NUMNODES; i++) {
-		nodes[i].start = nodes[i].end = 0;
-		nodes_add[i].start = nodes_add[i].end = 0;
-	}
-	remove_all_active_ranges();
+	memset(nodes_add, 0, sizeof(nodes_add));
 }
 
 static __init inline int srat_disabled(void)
 {
-	return numa_off || acpi_numa < 0;
+	return acpi_numa < 0;
 }
 
 /* Callback for SLIT parsing */
 void __init acpi_numa_slit_init(struct acpi_table_slit *slit)
 {
-	unsigned length;
-	unsigned long phys;
-
-	length = slit->header.length;
-	phys = memblock_find_in_range(0, max_pfn_mapped<<PAGE_SHIFT, length,
-		 PAGE_SIZE);
-
-	if (phys == MEMBLOCK_ERROR)
-		panic(" Can not save slit!\n");
+	int i, j;
 
-	acpi_slit = __va(phys);
-	memcpy(acpi_slit, slit, length);
-	memblock_x86_reserve_range(phys, phys + length, "ACPI SLIT");
+	for (i = 0; i < slit->locality_count; i++)
+		for (j = 0; j < slit->locality_count; j++)
+			numa_set_distance(pxm_to_node(i), pxm_to_node(j),
+				slit->entry[slit->locality_count * i + j]);
 }
 
 /* Callback for Proximity Domain -> x2APIC mapping */
@@ -138,8 +84,8 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
 		printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%04x -> Node %u skipped apicid that is too big\n", pxm, apic_id, node);
 		return;
 	}
-	apicid_to_node[apic_id] = node;
-	node_set(node, cpu_nodes_parsed);
+	set_apicid_to_node(apic_id, node);
+	node_set(node, numa_nodes_parsed);
 	acpi_numa = 1;
 	printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%04x -> Node %u\n",
 	       pxm, apic_id, node);
@@ -178,8 +124,8 @@ acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
 		return;
 	}
 
-	apicid_to_node[apic_id] = node;
-	node_set(node, cpu_nodes_parsed);
+	set_apicid_to_node(apic_id, node);
+	node_set(node, numa_nodes_parsed);
 	acpi_numa = 1;
 	printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%02x -> Node %u\n",
 	       pxm, apic_id, node);
@@ -241,7 +187,7 @@ update_nodes_add(int node, unsigned long start, unsigned long end)
 	}
 
 	if (changed) {
-		node_set(node, cpu_nodes_parsed);
+		node_set(node, numa_nodes_parsed);
 		printk(KERN_INFO "SRAT: hot plug zone found %Lx - %Lx\n",
 				 nd->start, nd->end);
 	}
@@ -251,10 +197,8 @@ update_nodes_add(int node, unsigned long start, unsigned long end)
 void __init
 acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 {
-	struct bootnode *nd, oldnode;
 	unsigned long start, end;
 	int node, pxm;
-	int i;
 
 	if (srat_disabled())
 		return;
@@ -276,300 +220,31 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 		bad_srat();
 		return;
 	}
-	i = conflicting_memblks(start, end);
-	if (i == node) {
-		printk(KERN_WARNING
-		"SRAT: Warning: PXM %d (%lx-%lx) overlaps with itself (%Lx-%Lx)\n",
-			pxm, start, end, nodes[i].start, nodes[i].end);
-	} else if (i >= 0) {
-		printk(KERN_ERR
-		       "SRAT: PXM %d (%lx-%lx) overlaps with PXM %d (%Lx-%Lx)\n",
-		       pxm, start, end, node_to_pxm(i),
-			nodes[i].start, nodes[i].end);
+
+	if (numa_add_memblk(node, start, end) < 0) {
 		bad_srat();
 		return;
 	}
-	nd = &nodes[node];
-	oldnode = *nd;
-	if (!node_test_and_set(node, nodes_parsed)) {
-		nd->start = start;
-		nd->end = end;
-	} else {
-		if (start < nd->start)
-			nd->start = start;
-		if (nd->end < end)
-			nd->end = end;
-	}
 
 	printk(KERN_INFO "SRAT: Node %u PXM %u %lx-%lx\n", node, pxm,
 	       start, end);
 
-	if (ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) {
+	if (ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE)
 		update_nodes_add(node, start, end);
-		/* restore nodes[node] */
-		*nd = oldnode;
-		if ((nd->start | nd->end) == 0)
-			node_clear(node, nodes_parsed);
-	}
-
-	node_memblk_range[num_node_memblks].start = start;
-	node_memblk_range[num_node_memblks].end = end;
-	memblk_nodeid[num_node_memblks] = node;
-	num_node_memblks++;
-}
-
-/* Sanity check to catch more bad SRATs (they are amazingly common).
-   Make sure the PXMs cover all memory. */
-static int __init nodes_cover_memory(const struct bootnode *nodes)
-{
-	int i;
-	unsigned long pxmram, e820ram;
-
-	pxmram = 0;
-	for_each_node_mask(i, nodes_parsed) {
-		unsigned long s = nodes[i].start >> PAGE_SHIFT;
-		unsigned long e = nodes[i].end >> PAGE_SHIFT;
-		pxmram += e - s;
-		pxmram -= __absent_pages_in_range(i, s, e);
-		if ((long)pxmram < 0)
-			pxmram = 0;
-	}
-
-	e820ram = max_pfn - (memblock_x86_hole_size(0, max_pfn<<PAGE_SHIFT)>>PAGE_SHIFT);
-	/* We seem to lose 3 pages somewhere. Allow 1M of slack. */
-	if ((long)(e820ram - pxmram) >= (1<<(20 - PAGE_SHIFT))) {
-		printk(KERN_ERR
-	"SRAT: PXMs only cover %luMB of your %luMB e820 RAM. Not used.\n",
-			(pxmram << PAGE_SHIFT) >> 20,
-			(e820ram << PAGE_SHIFT) >> 20);
-		return 0;
-	}
-	return 1;
 }
 
 void __init acpi_numa_arch_fixup(void) {}
 
-#ifdef CONFIG_NUMA_EMU
-void __init acpi_get_nodes(struct bootnode *physnodes, unsigned long start,
-				unsigned long end)
-{
-	int i;
-
-	for_each_node_mask(i, nodes_parsed) {
-		cutoff_node(i, start, end);
-		physnodes[i].start = nodes[i].start;
-		physnodes[i].end = nodes[i].end;
-	}
-}
-#endif /* CONFIG_NUMA_EMU */
-
-/* Use the information discovered above to actually set up the nodes. */
-int __init acpi_scan_nodes(unsigned long start, unsigned long end)
+int __init x86_acpi_numa_init(void)
 {
-	int i;
-
-	if (acpi_numa <= 0)
-		return -1;
-
-	/* First clean up the node list */
-	for (i = 0; i < MAX_NUMNODES; i++)
-		cutoff_node(i, start, end);
-
-	/*
-	 * Join together blocks on the same node, holes between
-	 * which don't overlap with memory on other nodes.
-	 */
-	for (i = 0; i < num_node_memblks; ++i) {
-		int j, k;
-
-		for (j = i + 1; j < num_node_memblks; ++j) {
-			unsigned long start, end;
-
-			if (memblk_nodeid[i] != memblk_nodeid[j])
-				continue;
-			start = min(node_memblk_range[i].end,
-			            node_memblk_range[j].end);
-			end = max(node_memblk_range[i].start,
-			          node_memblk_range[j].start);
-			for (k = 0; k < num_node_memblks; ++k) {
-				if (memblk_nodeid[i] == memblk_nodeid[k])
-					continue;
-				if (start < node_memblk_range[k].end &&
-				    end > node_memblk_range[k].start)
-					break;
-			}
-			if (k < num_node_memblks)
-				continue;
-			start = min(node_memblk_range[i].start,
-			            node_memblk_range[j].start);
-			end = max(node_memblk_range[i].end,
-			          node_memblk_range[j].end);
-			printk(KERN_INFO "SRAT: Node %d "
-			       "[%Lx,%Lx) + [%Lx,%Lx) -> [%lx,%lx)\n",
-			       memblk_nodeid[i],
-			       node_memblk_range[i].start,
-			       node_memblk_range[i].end,
-			       node_memblk_range[j].start,
-			       node_memblk_range[j].end,
-			       start, end);
-			node_memblk_range[i].start = start;
-			node_memblk_range[i].end = end;
-			k = --num_node_memblks - j;
-			memmove(memblk_nodeid + j, memblk_nodeid + j+1,
-				k * sizeof(*memblk_nodeid));
-			memmove(node_memblk_range + j, node_memblk_range + j+1,
-				k * sizeof(*node_memblk_range));
-			--j;
-		}
-	}
-
-	memnode_shift = compute_hash_shift(node_memblk_range, num_node_memblks,
-					   memblk_nodeid);
-	if (memnode_shift < 0) {
-		printk(KERN_ERR
-		     "SRAT: No NUMA node hash function found. Contact maintainer\n");
-		bad_srat();
-		return -1;
-	}
-
-	for (i = 0; i < num_node_memblks; i++)
-		memblock_x86_register_active_regions(memblk_nodeid[i],
-				node_memblk_range[i].start >> PAGE_SHIFT,
-				node_memblk_range[i].end >> PAGE_SHIFT);
-
-	/* for out of order entries in SRAT */
-	sort_node_map();
-	if (!nodes_cover_memory(nodes)) {
-		bad_srat();
-		return -1;
-	}
+	int ret;
 
-	/* Account for nodes with cpus and no memory */
-	nodes_or(node_possible_map, nodes_parsed, cpu_nodes_parsed);
-
-	/* Finally register nodes */
-	for_each_node_mask(i, node_possible_map)
-		setup_node_bootmem(i, nodes[i].start, nodes[i].end);
-	/* Try again in case setup_node_bootmem missed one due
-	   to missing bootmem */
-	for_each_node_mask(i, node_possible_map)
-		if (!node_online(i))
-			setup_node_bootmem(i, nodes[i].start, nodes[i].end);
-
-	for (i = 0; i < nr_cpu_ids; i++) {
-		int node = early_cpu_to_node(i);
-
-		if (node == NUMA_NO_NODE)
-			continue;
-		if (!node_online(node))
-			numa_clear_node(i);
-	}
-	numa_init_array();
-	return 0;
-}
-
-#ifdef CONFIG_NUMA_EMU
-static int fake_node_to_pxm_map[MAX_NUMNODES] __initdata = {
-	[0 ... MAX_NUMNODES-1] = PXM_INVAL
-};
-static s16 fake_apicid_to_node[MAX_LOCAL_APIC] __initdata = {
-	[0 ... MAX_LOCAL_APIC-1] = NUMA_NO_NODE
-};
-static int __init find_node_by_addr(unsigned long addr)
-{
-	int ret = NUMA_NO_NODE;
-	int i;
-
-	for_each_node_mask(i, nodes_parsed) {
-		/*
-		 * Find the real node that this emulated node appears on.  For
-		 * the sake of simplicity, we only use a real node's starting
-		 * address to determine which emulated node it appears on.
-		 */
-		if (addr >= nodes[i].start && addr < nodes[i].end) {
-			ret = i;
-			break;
-		}
-	}
-	return ret;
+	ret = acpi_numa_init();
+	if (ret < 0)
+		return ret;
+	return srat_disabled() ? -EINVAL : 0;
 }
 
-/*
- * In NUMA emulation, we need to setup proximity domain (_PXM) to node ID
- * mappings that respect the real ACPI topology but reflect our emulated
- * environment.  For each emulated node, we find which real node it appears on
- * and create PXM to NID mappings for those fake nodes which mirror that
- * locality.  SLIT will now represent the correct distances between emulated
- * nodes as a result of the real topology.
- */
-void __init acpi_fake_nodes(const struct bootnode *fake_nodes, int num_nodes)
-{
-	int i, j;
-
-	for (i = 0; i < num_nodes; i++) {
-		int nid, pxm;
-
-		nid = find_node_by_addr(fake_nodes[i].start);
-		if (nid == NUMA_NO_NODE)
-			continue;
-		pxm = node_to_pxm(nid);
-		if (pxm == PXM_INVAL)
-			continue;
-		fake_node_to_pxm_map[i] = pxm;
-		/*
-		 * For each apicid_to_node mapping that exists for this real
-		 * node, it must now point to the fake node ID.
-		 */
-		for (j = 0; j < MAX_LOCAL_APIC; j++)
-			if (apicid_to_node[j] == nid &&
-			    fake_apicid_to_node[j] == NUMA_NO_NODE)
-				fake_apicid_to_node[j] = i;
-	}
-
-	/*
-	 * If there are apicid-to-node mappings for physical nodes that do not
-	 * have a corresponding emulated node, it should default to a guaranteed
-	 * value.
-	 */
-	for (i = 0; i < MAX_LOCAL_APIC; i++)
-		if (apicid_to_node[i] != NUMA_NO_NODE &&
-		    fake_apicid_to_node[i] == NUMA_NO_NODE)
-			fake_apicid_to_node[i] = 0;
-
-	for (i = 0; i < num_nodes; i++)
-		__acpi_map_pxm_to_node(fake_node_to_pxm_map[i], i);
-	memcpy(apicid_to_node, fake_apicid_to_node, sizeof(apicid_to_node));
-
-	nodes_clear(nodes_parsed);
-	for (i = 0; i < num_nodes; i++)
-		if (fake_nodes[i].start != fake_nodes[i].end)
-			node_set(i, nodes_parsed);
-}
-
-static int null_slit_node_compare(int a, int b)
-{
-	return node_to_pxm(a) == node_to_pxm(b);
-}
-#else
-static int null_slit_node_compare(int a, int b)
-{
-	return a == b;
-}
-#endif /* CONFIG_NUMA_EMU */
-
-int __node_distance(int a, int b)
-{
-	int index;
-
-	if (!acpi_slit)
-		return null_slit_node_compare(a, b) ? LOCAL_DISTANCE :
-						      REMOTE_DISTANCE;
-	index = acpi_slit->locality_count * node_to_pxm(a);
-	return acpi_slit->entry[index + node_to_pxm(b)];
-}
-
-EXPORT_SYMBOL(__node_distance);
-
 #if defined(CONFIG_MEMORY_HOTPLUG_SPARSE) || defined(CONFIG_ACPI_HOTPLUG_MEMORY)
 int memory_add_physaddr_to_nid(u64 start)
 {
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 6acc724..d6c0418 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -179,12 +179,8 @@ static void flush_tlb_others_ipi(const struct cpumask *cpumask,
 	sender = this_cpu_read(tlb_vector_offset);
 	f = &flush_state[sender];
 
-	/*
-	 * Could avoid this lock when
-	 * num_online_cpus() <= NUM_INVALIDATE_TLB_VECTORS, but it is
-	 * probably not worth checking this for a cache-hot lock.
-	 */
-	raw_spin_lock(&f->tlbstate_lock);
+	if (nr_cpu_ids > NUM_INVALIDATE_TLB_VECTORS)
+		raw_spin_lock(&f->tlbstate_lock);
 
 	f->flush_mm = mm;
 	f->flush_va = va;
@@ -202,7 +198,8 @@ static void flush_tlb_others_ipi(const struct cpumask *cpumask,
 
 	f->flush_mm = NULL;
 	f->flush_va = 0;
-	raw_spin_unlock(&f->tlbstate_lock);
+	if (nr_cpu_ids > NUM_INVALIDATE_TLB_VECTORS)
+		raw_spin_unlock(&f->tlbstate_lock);
 }
 
 void native_flush_tlb_others(const struct cpumask *cpumask,
@@ -211,11 +208,10 @@ void native_flush_tlb_others(const struct cpumask *cpumask,
 	if (is_uv_system()) {
 		unsigned int cpu;
 
-		cpu = get_cpu();
+		cpu = smp_processor_id();
 		cpumask = uv_flush_tlb_others(cpumask, mm, va, cpu);
 		if (cpumask)
 			flush_tlb_others_ipi(cpumask, mm, va);
-		put_cpu();
 		return;
 	}
 	flush_tlb_others_ipi(cpumask, mm, va);
diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index e27dffbb..026e493 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -350,7 +350,7 @@ static int __init early_fill_mp_bus_info(void)
 
 #define ENABLE_CF8_EXT_CFG      (1ULL << 46)
 
-static void enable_pci_io_ecs(void *unused)
+static void __cpuinit enable_pci_io_ecs(void *unused)
 {
 	u64 reg;
 	rdmsrl(MSR_AMD64_NB_CFG, reg);
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index f608942..77f3228 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1441,7 +1441,7 @@ static __init pte_t mask_rw_pte(pte_t *ptep, pte_t pte)
 	 * early_ioremap fixmap slot, make sure it is RO.
 	 */
 	if (!is_early_ioremap_ptep(ptep) &&
-	    pfn >= e820_table_start && pfn < e820_table_end)
+	    pfn >= pgt_buf_start && pfn < pgt_buf_end)
 		pte = pte_wrprotect(pte);
 
 	return pte;
diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
index 5eb25eb..3b5c318 100644
--- a/drivers/acpi/numa.c
+++ b/drivers/acpi/numa.c
@@ -274,7 +274,7 @@ acpi_table_parse_srat(enum acpi_srat_type id,
 
 int __init acpi_numa_init(void)
 {
-	int ret = 0;
+	int cnt = 0;
 
 	/*
 	 * Should not limit number with cpu num that is from NR_CPUS or nr_cpus=
@@ -288,7 +288,7 @@ int __init acpi_numa_init(void)
 				     acpi_parse_x2apic_affinity, 0);
 		acpi_table_parse_srat(ACPI_SRAT_TYPE_CPU_AFFINITY,
 				     acpi_parse_processor_affinity, 0);
-		ret = acpi_table_parse_srat(ACPI_SRAT_TYPE_MEMORY_AFFINITY,
+		cnt = acpi_table_parse_srat(ACPI_SRAT_TYPE_MEMORY_AFFINITY,
 					    acpi_parse_memory_affinity,
 					    NR_NODE_MEMBLKS);
 	}
@@ -297,7 +297,10 @@ int __init acpi_numa_init(void)
 	acpi_table_parse(ACPI_SIG_SLIT, acpi_parse_slit);
 
 	acpi_numa_arch_fixup();
-	return ret;
+
+	if (cnt <= 0)
+		return cnt ?: -ENOENT;
+	return 0;
 }
 
 int acpi_get_pxm(acpi_handle h)
diff --git a/include/linux/mm.h b/include/linux/mm.h
index f6385fc..679300c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1309,8 +1309,6 @@ int add_from_early_node_map(struct range *range, int az,
 				   int nr_range, int nid);
 u64 __init find_memory_core_early(int nid, u64 size, u64 align,
 					u64 goal, u64 limit);
-void *__alloc_memory_core_early(int nodeid, u64 size, u64 align,
-				 u64 goal, u64 limit);
 typedef int (*work_fn_t)(unsigned long, unsigned long, void *);
 extern void work_with_active_regions(int nid, work_fn_t work_fn, void *data);
 extern void sparse_memory_present_with_active_regions(int nid);
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 3adb06e..580de67 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -518,6 +518,7 @@
 #define PCI_DEVICE_ID_AMD_11H_NB_MISC	0x1303
 #define PCI_DEVICE_ID_AMD_11H_NB_LINK	0x1304
 #define PCI_DEVICE_ID_AMD_15H_NB_MISC	0x1603
+#define PCI_DEVICE_ID_AMD_15H_NB_LINK	0x1604
 #define PCI_DEVICE_ID_AMD_CNB17H_F3	0x1703
 #define PCI_DEVICE_ID_AMD_LANCE		0x2000
 #define PCI_DEVICE_ID_AMD_LANCE_HOME	0x2001
diff --git a/mm/Makefile b/mm/Makefile
index 2b1b575..42a8326 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -7,7 +7,7 @@ mmu-$(CONFIG_MMU)	:= fremap.o highmem.o madvise.o memory.o mincore.o \
 			   mlock.o mmap.o mprotect.o mremap.o msync.o rmap.o \
 			   vmalloc.o pagewalk.o pgtable-generic.o
 
-obj-y			:= bootmem.o filemap.o mempool.o oom_kill.o fadvise.o \
+obj-y			:= filemap.o mempool.o oom_kill.o fadvise.o \
 			   maccess.o page_alloc.o page-writeback.o \
 			   readahead.o swap.o truncate.o vmscan.o shmem.o \
 			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
@@ -15,6 +15,12 @@ obj-y			:= bootmem.o filemap.o mempool.o oom_kill.o fadvise.o \
 			   $(mmu-y)
 obj-y += init-mm.o
 
+ifdef CONFIG_NO_BOOTMEM
+	obj-y		+= nobootmem.o
+else
+	obj-y		+= bootmem.o
+endif
+
 obj-$(CONFIG_HAVE_MEMBLOCK) += memblock.o
 
 obj-$(CONFIG_BOUNCE)	+= bounce.o
diff --git a/mm/bootmem.c b/mm/bootmem.c
index 13b0caa..07aeb89 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -23,6 +23,13 @@
 
 #include "internal.h"
 
+#ifndef CONFIG_NEED_MULTIPLE_NODES
+struct pglist_data __refdata contig_page_data = {
+	.bdata = &bootmem_node_data[0]
+};
+EXPORT_SYMBOL(contig_page_data);
+#endif
+
 unsigned long max_low_pfn;
 unsigned long min_low_pfn;
 unsigned long max_pfn;
@@ -35,7 +42,6 @@ unsigned long max_pfn;
 unsigned long saved_max_pfn;
 #endif
 
-#ifndef CONFIG_NO_BOOTMEM
 bootmem_data_t bootmem_node_data[MAX_NUMNODES] __initdata;
 
 static struct list_head bdata_list __initdata = LIST_HEAD_INIT(bdata_list);
@@ -146,7 +152,7 @@ unsigned long __init init_bootmem(unsigned long start, unsigned long pages)
 	min_low_pfn = start;
 	return init_bootmem_core(NODE_DATA(0)->bdata, start, 0, pages);
 }
-#endif
+
 /*
  * free_bootmem_late - free bootmem pages directly to page allocator
  * @addr: starting address of the range
@@ -171,53 +177,6 @@ void __init free_bootmem_late(unsigned long addr, unsigned long size)
 	}
 }
 
-#ifdef CONFIG_NO_BOOTMEM
-static void __init __free_pages_memory(unsigned long start, unsigned long end)
-{
-	int i;
-	unsigned long start_aligned, end_aligned;
-	int order = ilog2(BITS_PER_LONG);
-
-	start_aligned = (start + (BITS_PER_LONG - 1)) & ~(BITS_PER_LONG - 1);
-	end_aligned = end & ~(BITS_PER_LONG - 1);
-
-	if (end_aligned <= start_aligned) {
-		for (i = start; i < end; i++)
-			__free_pages_bootmem(pfn_to_page(i), 0);
-
-		return;
-	}
-
-	for (i = start; i < start_aligned; i++)
-		__free_pages_bootmem(pfn_to_page(i), 0);
-
-	for (i = start_aligned; i < end_aligned; i += BITS_PER_LONG)
-		__free_pages_bootmem(pfn_to_page(i), order);
-
-	for (i = end_aligned; i < end; i++)
-		__free_pages_bootmem(pfn_to_page(i), 0);
-}
-
-unsigned long __init free_all_memory_core_early(int nodeid)
-{
-	int i;
-	u64 start, end;
-	unsigned long count = 0;
-	struct range *range = NULL;
-	int nr_range;
-
-	nr_range = get_free_all_memory_range(&range, nodeid);
-
-	for (i = 0; i < nr_range; i++) {
-		start = range[i].start;
-		end = range[i].end;
-		count += end - start;
-		__free_pages_memory(start, end);
-	}
-
-	return count;
-}
-#else
 static unsigned long __init free_all_bootmem_core(bootmem_data_t *bdata)
 {
 	int aligned;
@@ -278,7 +237,6 @@ static unsigned long __init free_all_bootmem_core(bootmem_data_t *bdata)
 
 	return count;
 }
-#endif
 
 /**
  * free_all_bootmem_node - release a node's free pages to the buddy allocator
@@ -289,12 +247,7 @@ static unsigned long __init free_all_bootmem_core(bootmem_data_t *bdata)
 unsigned long __init free_all_bootmem_node(pg_data_t *pgdat)
 {
 	register_page_bootmem_info_node(pgdat);
-#ifdef CONFIG_NO_BOOTMEM
-	/* free_all_memory_core_early(MAX_NUMNODES) will be called later */
-	return 0;
-#else
 	return free_all_bootmem_core(pgdat->bdata);
-#endif
 }
 
 /**
@@ -304,16 +257,6 @@ unsigned long __init free_all_bootmem_node(pg_data_t *pgdat)
  */
 unsigned long __init free_all_bootmem(void)
 {
-#ifdef CONFIG_NO_BOOTMEM
-	/*
-	 * We need to use MAX_NUMNODES instead of NODE_DATA(0)->node_id
-	 *  because in some case like Node0 doesnt have RAM installed
-	 *  low ram will be on Node1
-	 * Use MAX_NUMNODES will make sure all ranges in early_node_map[]
-	 *  will be used instead of only Node0 related
-	 */
-	return free_all_memory_core_early(MAX_NUMNODES);
-#else
 	unsigned long total_pages = 0;
 	bootmem_data_t *bdata;
 
@@ -321,10 +264,8 @@ unsigned long __init free_all_bootmem(void)
 		total_pages += free_all_bootmem_core(bdata);
 
 	return total_pages;
-#endif
 }
 
-#ifndef CONFIG_NO_BOOTMEM
 static void __init __free(bootmem_data_t *bdata,
 			unsigned long sidx, unsigned long eidx)
 {
@@ -419,7 +360,6 @@ static int __init mark_bootmem(unsigned long start, unsigned long end,
 	}
 	BUG();
 }
-#endif
 
 /**
  * free_bootmem_node - mark a page range as usable
@@ -434,10 +374,6 @@ static int __init mark_bootmem(unsigned long start, unsigned long end,
 void __init free_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
 			      unsigned long size)
 {
-#ifdef CONFIG_NO_BOOTMEM
-	kmemleak_free_part(__va(physaddr), size);
-	memblock_x86_free_range(physaddr, physaddr + size);
-#else
 	unsigned long start, end;
 
 	kmemleak_free_part(__va(physaddr), size);
@@ -446,7 +382,6 @@ void __init free_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
 	end = PFN_DOWN(physaddr + size);
 
 	mark_bootmem_node(pgdat->bdata, start, end, 0, 0);
-#endif
 }
 
 /**
@@ -460,10 +395,6 @@ void __init free_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
  */
 void __init free_bootmem(unsigned long addr, unsigned long size)
 {
-#ifdef CONFIG_NO_BOOTMEM
-	kmemleak_free_part(__va(addr), size);
-	memblock_x86_free_range(addr, addr + size);
-#else
 	unsigned long start, end;
 
 	kmemleak_free_part(__va(addr), size);
@@ -472,7 +403,6 @@ void __init free_bootmem(unsigned long addr, unsigned long size)
 	end = PFN_DOWN(addr + size);
 
 	mark_bootmem(start, end, 0, 0);
-#endif
 }
 
 /**
@@ -489,17 +419,12 @@ void __init free_bootmem(unsigned long addr, unsigned long size)
 int __init reserve_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
 				 unsigned long size, int flags)
 {
-#ifdef CONFIG_NO_BOOTMEM
-	panic("no bootmem");
-	return 0;
-#else
 	unsigned long start, end;
 
 	start = PFN_DOWN(physaddr);
 	end = PFN_UP(physaddr + size);
 
 	return mark_bootmem_node(pgdat->bdata, start, end, 1, flags);
-#endif
 }
 
 /**
@@ -515,20 +440,14 @@ int __init reserve_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
 int __init reserve_bootmem(unsigned long addr, unsigned long size,
 			    int flags)
 {
-#ifdef CONFIG_NO_BOOTMEM
-	panic("no bootmem");
-	return 0;
-#else
 	unsigned long start, end;
 
 	start = PFN_DOWN(addr);
 	end = PFN_UP(addr + size);
 
 	return mark_bootmem(start, end, 1, flags);
-#endif
 }
 
-#ifndef CONFIG_NO_BOOTMEM
 int __weak __init reserve_bootmem_generic(unsigned long phys, unsigned long len,
 				   int flags)
 {
@@ -685,33 +604,12 @@ static void * __init alloc_arch_preferred_bootmem(bootmem_data_t *bdata,
 #endif
 	return NULL;
 }
-#endif
 
 static void * __init ___alloc_bootmem_nopanic(unsigned long size,
 					unsigned long align,
 					unsigned long goal,
 					unsigned long limit)
 {
-#ifdef CONFIG_NO_BOOTMEM
-	void *ptr;
-
-	if (WARN_ON_ONCE(slab_is_available()))
-		return kzalloc(size, GFP_NOWAIT);
-
-restart:
-
-	ptr = __alloc_memory_core_early(MAX_NUMNODES, size, align, goal, limit);
-
-	if (ptr)
-		return ptr;
-
-	if (goal != 0) {
-		goal = 0;
-		goto restart;
-	}
-
-	return NULL;
-#else
 	bootmem_data_t *bdata;
 	void *region;
 
@@ -737,7 +635,6 @@ restart:
 	}
 
 	return NULL;
-#endif
 }
 
 /**
@@ -758,10 +655,6 @@ void * __init __alloc_bootmem_nopanic(unsigned long size, unsigned long align,
 {
 	unsigned long limit = 0;
 
-#ifdef CONFIG_NO_BOOTMEM
-	limit = -1UL;
-#endif
-
 	return ___alloc_bootmem_nopanic(size, align, goal, limit);
 }
 
@@ -798,14 +691,9 @@ void * __init __alloc_bootmem(unsigned long size, unsigned long align,
 {
 	unsigned long limit = 0;
 
-#ifdef CONFIG_NO_BOOTMEM
-	limit = -1UL;
-#endif
-
 	return ___alloc_bootmem(size, align, goal, limit);
 }
 
-#ifndef CONFIG_NO_BOOTMEM
 static void * __init ___alloc_bootmem_node(bootmem_data_t *bdata,
 				unsigned long size, unsigned long align,
 				unsigned long goal, unsigned long limit)
@@ -822,7 +710,6 @@ static void * __init ___alloc_bootmem_node(bootmem_data_t *bdata,
 
 	return ___alloc_bootmem(size, align, goal, limit);
 }
-#endif
 
 /**
  * __alloc_bootmem_node - allocate boot memory from a specific node
@@ -842,24 +729,10 @@ static void * __init ___alloc_bootmem_node(bootmem_data_t *bdata,
 void * __init __alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
 				   unsigned long align, unsigned long goal)
 {
-	void *ptr;
-
 	if (WARN_ON_ONCE(slab_is_available()))
 		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
 
-#ifdef CONFIG_NO_BOOTMEM
-	ptr = __alloc_memory_core_early(pgdat->node_id, size, align,
-					 goal, -1ULL);
-	if (ptr)
-		return ptr;
-
-	ptr = __alloc_memory_core_early(MAX_NUMNODES, size, align,
-					 goal, -1ULL);
-#else
-	ptr = ___alloc_bootmem_node(pgdat->bdata, size, align, goal, 0);
-#endif
-
-	return ptr;
+	return  ___alloc_bootmem_node(pgdat->bdata, size, align, goal, 0);
 }
 
 void * __init __alloc_bootmem_node_high(pg_data_t *pgdat, unsigned long size,
@@ -880,13 +753,8 @@ void * __init __alloc_bootmem_node_high(pg_data_t *pgdat, unsigned long size,
 		unsigned long new_goal;
 
 		new_goal = MAX_DMA32_PFN << PAGE_SHIFT;
-#ifdef CONFIG_NO_BOOTMEM
-		ptr =  __alloc_memory_core_early(pgdat->node_id, size, align,
-						 new_goal, -1ULL);
-#else
 		ptr = alloc_bootmem_core(pgdat->bdata, size, align,
 						 new_goal, 0);
-#endif
 		if (ptr)
 			return ptr;
 	}
@@ -907,16 +775,6 @@ void * __init __alloc_bootmem_node_high(pg_data_t *pgdat, unsigned long size,
 void * __init alloc_bootmem_section(unsigned long size,
 				    unsigned long section_nr)
 {
-#ifdef CONFIG_NO_BOOTMEM
-	unsigned long pfn, goal, limit;
-
-	pfn = section_nr_to_pfn(section_nr);
-	goal = pfn << PAGE_SHIFT;
-	limit = section_nr_to_pfn(section_nr + 1) << PAGE_SHIFT;
-
-	return __alloc_memory_core_early(early_pfn_to_nid(pfn), size,
-					 SMP_CACHE_BYTES, goal, limit);
-#else
 	bootmem_data_t *bdata;
 	unsigned long pfn, goal, limit;
 
@@ -926,7 +784,6 @@ void * __init alloc_bootmem_section(unsigned long size,
 	bdata = &bootmem_node_data[early_pfn_to_nid(pfn)];
 
 	return alloc_bootmem_core(bdata, size, SMP_CACHE_BYTES, goal, limit);
-#endif
 }
 #endif
 
@@ -938,16 +795,11 @@ void * __init __alloc_bootmem_node_nopanic(pg_data_t *pgdat, unsigned long size,
 	if (WARN_ON_ONCE(slab_is_available()))
 		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
 
-#ifdef CONFIG_NO_BOOTMEM
-	ptr =  __alloc_memory_core_early(pgdat->node_id, size, align,
-						 goal, -1ULL);
-#else
 	ptr = alloc_arch_preferred_bootmem(pgdat->bdata, size, align, goal, 0);
 	if (ptr)
 		return ptr;
 
 	ptr = alloc_bootmem_core(pgdat->bdata, size, align, goal, 0);
-#endif
 	if (ptr)
 		return ptr;
 
@@ -995,21 +847,9 @@ void * __init __alloc_bootmem_low(unsigned long size, unsigned long align,
 void * __init __alloc_bootmem_low_node(pg_data_t *pgdat, unsigned long size,
 				       unsigned long align, unsigned long goal)
 {
-	void *ptr;
-
 	if (WARN_ON_ONCE(slab_is_available()))
 		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
 
-#ifdef CONFIG_NO_BOOTMEM
-	ptr = __alloc_memory_core_early(pgdat->node_id, size, align,
+	return ___alloc_bootmem_node(pgdat->bdata, size, align,
 				goal, ARCH_LOW_ADDRESS_LIMIT);
-	if (ptr)
-		return ptr;
-	ptr = __alloc_memory_core_early(MAX_NUMNODES, size, align,
-				goal, ARCH_LOW_ADDRESS_LIMIT);
-#else
-	ptr = ___alloc_bootmem_node(pgdat->bdata, size, align,
-				goal, ARCH_LOW_ADDRESS_LIMIT);
-#endif
-	return ptr;
 }
diff --git a/mm/nobootmem.c b/mm/nobootmem.c
new file mode 100644
index 0000000..e2bdb07
--- /dev/null
+++ b/mm/nobootmem.c
@@ -0,0 +1,435 @@
+/*
+ *  bootmem - A boot-time physical memory allocator and configurator
+ *
+ *  Copyright (C) 1999 Ingo Molnar
+ *                1999 Kanoj Sarcar, SGI
+ *                2008 Johannes Weiner
+ *
+ * Access to this subsystem has to be serialized externally (which is true
+ * for the boot process anyway).
+ */
+#include <linux/init.h>
+#include <linux/pfn.h>
+#include <linux/slab.h>
+#include <linux/bootmem.h>
+#include <linux/module.h>
+#include <linux/kmemleak.h>
+#include <linux/range.h>
+#include <linux/memblock.h>
+
+#include <asm/bug.h>
+#include <asm/io.h>
+#include <asm/processor.h>
+
+#include "internal.h"
+
+#ifndef CONFIG_NEED_MULTIPLE_NODES
+struct pglist_data __refdata contig_page_data;
+EXPORT_SYMBOL(contig_page_data);
+#endif
+
+unsigned long max_low_pfn;
+unsigned long min_low_pfn;
+unsigned long max_pfn;
+
+#ifdef CONFIG_CRASH_DUMP
+/*
+ * If we have booted due to a crash, max_pfn will be a very low value. We need
+ * to know the amount of memory that the previous kernel used.
+ */
+unsigned long saved_max_pfn;
+#endif
+
+static void * __init __alloc_memory_core_early(int nid, u64 size, u64 align,
+					u64 goal, u64 limit)
+{
+	void *ptr;
+	u64 addr;
+
+	if (limit > memblock.current_limit)
+		limit = memblock.current_limit;
+
+	addr = find_memory_core_early(nid, size, align, goal, limit);
+
+	if (addr == MEMBLOCK_ERROR)
+		return NULL;
+
+	ptr = phys_to_virt(addr);
+	memset(ptr, 0, size);
+	memblock_x86_reserve_range(addr, addr + size, "BOOTMEM");
+	/*
+	 * The min_count is set to 0 so that bootmem allocated blocks
+	 * are never reported as leaks.
+	 */
+	kmemleak_alloc(ptr, size, 0, 0);
+	return ptr;
+}
+
+/*
+ * free_bootmem_late - free bootmem pages directly to page allocator
+ * @addr: starting address of the range
+ * @size: size of the range in bytes
+ *
+ * This is only useful when the bootmem allocator has already been torn
+ * down, but we are still initializing the system.  Pages are given directly
+ * to the page allocator, no bootmem metadata is updated because it is gone.
+ */
+void __init free_bootmem_late(unsigned long addr, unsigned long size)
+{
+	unsigned long cursor, end;
+
+	kmemleak_free_part(__va(addr), size);
+
+	cursor = PFN_UP(addr);
+	end = PFN_DOWN(addr + size);
+
+	for (; cursor < end; cursor++) {
+		__free_pages_bootmem(pfn_to_page(cursor), 0);
+		totalram_pages++;
+	}
+}
+
+static void __init __free_pages_memory(unsigned long start, unsigned long end)
+{
+	int i;
+	unsigned long start_aligned, end_aligned;
+	int order = ilog2(BITS_PER_LONG);
+
+	start_aligned = (start + (BITS_PER_LONG - 1)) & ~(BITS_PER_LONG - 1);
+	end_aligned = end & ~(BITS_PER_LONG - 1);
+
+	if (end_aligned <= start_aligned) {
+		for (i = start; i < end; i++)
+			__free_pages_bootmem(pfn_to_page(i), 0);
+
+		return;
+	}
+
+	for (i = start; i < start_aligned; i++)
+		__free_pages_bootmem(pfn_to_page(i), 0);
+
+	for (i = start_aligned; i < end_aligned; i += BITS_PER_LONG)
+		__free_pages_bootmem(pfn_to_page(i), order);
+
+	for (i = end_aligned; i < end; i++)
+		__free_pages_bootmem(pfn_to_page(i), 0);
+}
+
+unsigned long __init free_all_memory_core_early(int nodeid)
+{
+	int i;
+	u64 start, end;
+	unsigned long count = 0;
+	struct range *range = NULL;
+	int nr_range;
+
+	nr_range = get_free_all_memory_range(&range, nodeid);
+
+	for (i = 0; i < nr_range; i++) {
+		start = range[i].start;
+		end = range[i].end;
+		count += end - start;
+		__free_pages_memory(start, end);
+	}
+
+	return count;
+}
+
+/**
+ * free_all_bootmem_node - release a node's free pages to the buddy allocator
+ * @pgdat: node to be released
+ *
+ * Returns the number of pages actually released.
+ */
+unsigned long __init free_all_bootmem_node(pg_data_t *pgdat)
+{
+	register_page_bootmem_info_node(pgdat);
+
+	/* free_all_memory_core_early(MAX_NUMNODES) will be called later */
+	return 0;
+}
+
+/**
+ * free_all_bootmem - release free pages to the buddy allocator
+ *
+ * Returns the number of pages actually released.
+ */
+unsigned long __init free_all_bootmem(void)
+{
+	/*
+	 * We need to use MAX_NUMNODES instead of NODE_DATA(0)->node_id
+	 *  because in some case like Node0 doesnt have RAM installed
+	 *  low ram will be on Node1
+	 * Use MAX_NUMNODES will make sure all ranges in early_node_map[]
+	 *  will be used instead of only Node0 related
+	 */
+	return free_all_memory_core_early(MAX_NUMNODES);
+}
+
+/**
+ * free_bootmem_node - mark a page range as usable
+ * @pgdat: node the range resides on
+ * @physaddr: starting address of the range
+ * @size: size of the range in bytes
+ *
+ * Partial pages will be considered reserved and left as they are.
+ *
+ * The range must reside completely on the specified node.
+ */
+void __init free_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
+			      unsigned long size)
+{
+	kmemleak_free_part(__va(physaddr), size);
+	memblock_x86_free_range(physaddr, physaddr + size);
+}
+
+/**
+ * free_bootmem - mark a page range as usable
+ * @addr: starting address of the range
+ * @size: size of the range in bytes
+ *
+ * Partial pages will be considered reserved and left as they are.
+ *
+ * The range must be contiguous but may span node boundaries.
+ */
+void __init free_bootmem(unsigned long addr, unsigned long size)
+{
+	kmemleak_free_part(__va(addr), size);
+	memblock_x86_free_range(addr, addr + size);
+}
+
+static void * __init ___alloc_bootmem_nopanic(unsigned long size,
+					unsigned long align,
+					unsigned long goal,
+					unsigned long limit)
+{
+	void *ptr;
+
+	if (WARN_ON_ONCE(slab_is_available()))
+		return kzalloc(size, GFP_NOWAIT);
+
+restart:
+
+	ptr = __alloc_memory_core_early(MAX_NUMNODES, size, align, goal, limit);
+
+	if (ptr)
+		return ptr;
+
+	if (goal != 0) {
+		goal = 0;
+		goto restart;
+	}
+
+	return NULL;
+}
+
+/**
+ * __alloc_bootmem_nopanic - allocate boot memory without panicking
+ * @size: size of the request in bytes
+ * @align: alignment of the region
+ * @goal: preferred starting address of the region
+ *
+ * The goal is dropped if it can not be satisfied and the allocation will
+ * fall back to memory below @goal.
+ *
+ * Allocation may happen on any node in the system.
+ *
+ * Returns NULL on failure.
+ */
+void * __init __alloc_bootmem_nopanic(unsigned long size, unsigned long align,
+					unsigned long goal)
+{
+	unsigned long limit = -1UL;
+
+	return ___alloc_bootmem_nopanic(size, align, goal, limit);
+}
+
+static void * __init ___alloc_bootmem(unsigned long size, unsigned long align,
+					unsigned long goal, unsigned long limit)
+{
+	void *mem = ___alloc_bootmem_nopanic(size, align, goal, limit);
+
+	if (mem)
+		return mem;
+	/*
+	 * Whoops, we cannot satisfy the allocation request.
+	 */
+	printk(KERN_ALERT "bootmem alloc of %lu bytes failed!\n", size);
+	panic("Out of memory");
+	return NULL;
+}
+
+/**
+ * __alloc_bootmem - allocate boot memory
+ * @size: size of the request in bytes
+ * @align: alignment of the region
+ * @goal: preferred starting address of the region
+ *
+ * The goal is dropped if it can not be satisfied and the allocation will
+ * fall back to memory below @goal.
+ *
+ * Allocation may happen on any node in the system.
+ *
+ * The function panics if the request can not be satisfied.
+ */
+void * __init __alloc_bootmem(unsigned long size, unsigned long align,
+			      unsigned long goal)
+{
+	unsigned long limit = -1UL;
+
+	return ___alloc_bootmem(size, align, goal, limit);
+}
+
+/**
+ * __alloc_bootmem_node - allocate boot memory from a specific node
+ * @pgdat: node to allocate from
+ * @size: size of the request in bytes
+ * @align: alignment of the region
+ * @goal: preferred starting address of the region
+ *
+ * The goal is dropped if it can not be satisfied and the allocation will
+ * fall back to memory below @goal.
+ *
+ * Allocation may fall back to any node in the system if the specified node
+ * can not hold the requested memory.
+ *
+ * The function panics if the request can not be satisfied.
+ */
+void * __init __alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
+				   unsigned long align, unsigned long goal)
+{
+	void *ptr;
+
+	if (WARN_ON_ONCE(slab_is_available()))
+		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
+
+	ptr = __alloc_memory_core_early(pgdat->node_id, size, align,
+					 goal, -1ULL);
+	if (ptr)
+		return ptr;
+
+	return __alloc_memory_core_early(MAX_NUMNODES, size, align,
+					 goal, -1ULL);
+}
+
+void * __init __alloc_bootmem_node_high(pg_data_t *pgdat, unsigned long size,
+				   unsigned long align, unsigned long goal)
+{
+#ifdef MAX_DMA32_PFN
+	unsigned long end_pfn;
+
+	if (WARN_ON_ONCE(slab_is_available()))
+		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
+
+	/* update goal according ...MAX_DMA32_PFN */
+	end_pfn = pgdat->node_start_pfn + pgdat->node_spanned_pages;
+
+	if (end_pfn > MAX_DMA32_PFN + (128 >> (20 - PAGE_SHIFT)) &&
+	    (goal >> PAGE_SHIFT) < MAX_DMA32_PFN) {
+		void *ptr;
+		unsigned long new_goal;
+
+		new_goal = MAX_DMA32_PFN << PAGE_SHIFT;
+		ptr =  __alloc_memory_core_early(pgdat->node_id, size, align,
+						 new_goal, -1ULL);
+		if (ptr)
+			return ptr;
+	}
+#endif
+
+	return __alloc_bootmem_node(pgdat, size, align, goal);
+
+}
+
+#ifdef CONFIG_SPARSEMEM
+/**
+ * alloc_bootmem_section - allocate boot memory from a specific section
+ * @size: size of the request in bytes
+ * @section_nr: sparse map section to allocate from
+ *
+ * Return NULL on failure.
+ */
+void * __init alloc_bootmem_section(unsigned long size,
+				    unsigned long section_nr)
+{
+	unsigned long pfn, goal, limit;
+
+	pfn = section_nr_to_pfn(section_nr);
+	goal = pfn << PAGE_SHIFT;
+	limit = section_nr_to_pfn(section_nr + 1) << PAGE_SHIFT;
+
+	return __alloc_memory_core_early(early_pfn_to_nid(pfn), size,
+					 SMP_CACHE_BYTES, goal, limit);
+}
+#endif
+
+void * __init __alloc_bootmem_node_nopanic(pg_data_t *pgdat, unsigned long size,
+				   unsigned long align, unsigned long goal)
+{
+	void *ptr;
+
+	if (WARN_ON_ONCE(slab_is_available()))
+		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
+
+	ptr =  __alloc_memory_core_early(pgdat->node_id, size, align,
+						 goal, -1ULL);
+	if (ptr)
+		return ptr;
+
+	return __alloc_bootmem_nopanic(size, align, goal);
+}
+
+#ifndef ARCH_LOW_ADDRESS_LIMIT
+#define ARCH_LOW_ADDRESS_LIMIT	0xffffffffUL
+#endif
+
+/**
+ * __alloc_bootmem_low - allocate low boot memory
+ * @size: size of the request in bytes
+ * @align: alignment of the region
+ * @goal: preferred starting address of the region
+ *
+ * The goal is dropped if it can not be satisfied and the allocation will
+ * fall back to memory below @goal.
+ *
+ * Allocation may happen on any node in the system.
+ *
+ * The function panics if the request can not be satisfied.
+ */
+void * __init __alloc_bootmem_low(unsigned long size, unsigned long align,
+				  unsigned long goal)
+{
+	return ___alloc_bootmem(size, align, goal, ARCH_LOW_ADDRESS_LIMIT);
+}
+
+/**
+ * __alloc_bootmem_low_node - allocate low boot memory from a specific node
+ * @pgdat: node to allocate from
+ * @size: size of the request in bytes
+ * @align: alignment of the region
+ * @goal: preferred starting address of the region
+ *
+ * The goal is dropped if it can not be satisfied and the allocation will
+ * fall back to memory below @goal.
+ *
+ * Allocation may fall back to any node in the system if the specified node
+ * can not hold the requested memory.
+ *
+ * The function panics if the request can not be satisfied.
+ */
+void * __init __alloc_bootmem_low_node(pg_data_t *pgdat, unsigned long size,
+				       unsigned long align, unsigned long goal)
+{
+	void *ptr;
+
+	if (WARN_ON_ONCE(slab_is_available()))
+		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
+
+	ptr = __alloc_memory_core_early(pgdat->node_id, size, align,
+				goal, ARCH_LOW_ADDRESS_LIMIT);
+	if (ptr)
+		return ptr;
+
+	return  __alloc_memory_core_early(MAX_NUMNODES, size, align,
+				goal, ARCH_LOW_ADDRESS_LIMIT);
+}
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index cdef1d4..bd76256 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3699,13 +3699,45 @@ void __init free_bootmem_with_active_regions(int nid,
 }
 
 #ifdef CONFIG_HAVE_MEMBLOCK
+/*
+ * Basic iterator support. Return the last range of PFNs for a node
+ * Note: nid == MAX_NUMNODES returns last region regardless of node
+ */
+static int __meminit last_active_region_index_in_nid(int nid)
+{
+	int i;
+
+	for (i = nr_nodemap_entries - 1; i >= 0; i--)
+		if (nid == MAX_NUMNODES || early_node_map[i].nid == nid)
+			return i;
+
+	return -1;
+}
+
+/*
+ * Basic iterator support. Return the previous active range of PFNs for a node
+ * Note: nid == MAX_NUMNODES returns next region regardless of node
+ */
+static int __meminit previous_active_region_index_in_nid(int index, int nid)
+{
+	for (index = index - 1; index >= 0; index--)
+		if (nid == MAX_NUMNODES || early_node_map[index].nid == nid)
+			return index;
+
+	return -1;
+}
+
+#define for_each_active_range_index_in_nid_reverse(i, nid) \
+	for (i = last_active_region_index_in_nid(nid); i != -1; \
+				i = previous_active_region_index_in_nid(i, nid))
+
 u64 __init find_memory_core_early(int nid, u64 size, u64 align,
 					u64 goal, u64 limit)
 {
 	int i;
 
 	/* Need to go over early_node_map to find out good range for node */
-	for_each_active_range_index_in_nid(i, nid) {
+	for_each_active_range_index_in_nid_reverse(i, nid) {
 		u64 addr;
 		u64 ei_start, ei_last;
 		u64 final_start, final_end;
@@ -3748,34 +3780,6 @@ int __init add_from_early_node_map(struct range *range, int az,
 	return nr_range;
 }
 
-#ifdef CONFIG_NO_BOOTMEM
-void * __init __alloc_memory_core_early(int nid, u64 size, u64 align,
-					u64 goal, u64 limit)
-{
-	void *ptr;
-	u64 addr;
-
-	if (limit > memblock.current_limit)
-		limit = memblock.current_limit;
-
-	addr = find_memory_core_early(nid, size, align, goal, limit);
-
-	if (addr == MEMBLOCK_ERROR)
-		return NULL;
-
-	ptr = phys_to_virt(addr);
-	memset(ptr, 0, size);
-	memblock_x86_reserve_range(addr, addr + size, "BOOTMEM");
-	/*
-	 * The min_count is set to 0 so that bootmem allocated blocks
-	 * are never reported as leaks.
-	 */
-	kmemleak_alloc(ptr, size, 0, 0);
-	return ptr;
-}
-#endif
-
-
 void __init work_with_active_regions(int nid, work_fn_t work_fn, void *data)
 {
 	int i;
@@ -4809,15 +4813,6 @@ void __init set_dma_reserve(unsigned long new_dma_reserve)
 	dma_reserve = new_dma_reserve;
 }
 
-#ifndef CONFIG_NEED_MULTIPLE_NODES
-struct pglist_data __refdata contig_page_data = {
-#ifndef CONFIG_NO_BOOTMEM
- .bdata = &bootmem_node_data[0]
-#endif
- };
-EXPORT_SYMBOL(contig_page_data);
-#endif
-
 void __init free_area_init(unsigned long *zones_size)
 {
 	free_area_init_node(0, zones_size,
