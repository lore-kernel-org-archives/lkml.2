Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437Ab2AENj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 08:39:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36508 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932267Ab2AENjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 08:39:52 -0500
Date: Thu, 5 Jan 2012 14:37:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core/memblock changes for v3.3
Message-ID: <20120105133733.GA27988@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
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

Please pull the latest core-memblock-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-memblock-for-linus

 Thanks,

	Ingo

------------------>
H. Peter Anvin (1):
      memblock: Cast phys_addr_t to unsigned long long for printf use

Tejun Heo (51):
      x86: Fix memblock_x86_check_reserved_size() use in efi_reserve_boot_services()
      bootmem: Fix __free_pages_bootmem() to use @order properly
      memblock: Use MEMBLOCK_ALLOC_ACCESSIBLE instead of ANYWHERE in memblock_alloc_try_nid()
      memblock: Use round_up/down() instead of memblock_align_up/down()
      memblock: Kill MEMBLOCK_ERROR
      memblock: Replace memblock_find_base() with memblock_find_in_range()
      bootmem: Replace work_with_active_regions() with for_each_mem_pfn_range()
      bootmem: Reimplement __absent_pages_in_range() using for_each_mem_pfn_range()
      bootmem: Use for_each_mem_pfn_range() in page_alloc.c
      memblock: Improve generic memblock_nid_range() using for_each_mem_pfn_range()
      memblock: Don't allow archs to override memblock_nid_range()
      memblock: Make memblock_alloc_[try_]nid() top-down
      memblock: Separate out memblock_find_in_range_node()
      memblock, x86: Replace memblock_x86_find_in_range_node() with generic memblock calls
      memblock: Remove memblock_memory_can_coalesce()
      memblock: Reimplement memblock_add_region()
      memblock: Use __meminit[data] instead of __init[data]
      memblock: Add optional region->nid
      x86: Use HAVE_MEMBLOCK_NODE_MAP
      x86: Use __memblock_alloc_base() in early_reserve_e820()
      memblock: Implement for_each_free_mem_range()
      x86: Replace memblock_x86_find_in_range_size() with for_each_free_mem_range()
      memblock, x86: Make free_all_memory_core_early() explicitly free lowmem only
      memblock, x86: Replace __get_free_all_memory_range() with for_each_free_mem_range()
      memblock, x86: Reimplement memblock_find_dma_reserve() using iterators
      x86: Use absent_pages_in_range() instead of memblock_x86_hole_size()
      memblock, x86: Make ARCH_DISCARD_MEMBLOCK a config option
      memblock, x86: Replace memblock_x86_reserve/free_range() with generic ones
      memblock: Fix include breakages caused by 24aa07882b
      memblock: Make memblock_{add|remove|free|reserve}() return int and update prototypes
      memblock: Use memblock_reserve() in memblock internal functions
      memblock: Add __memblock_dump_all()
      memblock: Kill sentinel entries at the end of static region arrays
      memblock: Kill memblock_init()
      memblock: Separate out memblock_isolate_range() from memblock_set_node()
      memblock: Reimplement __memblock_remove() using memblock_isolate_range()
      memblock: Make memblock functions handle overflowing range @size
      memblock: Reimplement memblock_enforce_memory_limit() using __memblock_remove()
      powerpc: Cleanup memblock usage
      memblock: Track total size of regions automatically
      memblock: s/memblock_analyze()/memblock_allow_resize()/ and update users
      memblock: Implement memblock_add_node()
      powerpc: Use HAVE_MEMBLOCK_NODE_MAP
      sparc: Use HAVE_MEMBLOCK_NODE_MAP
      SuperH: Use HAVE_MEMBLOCK_NODE_MAP
      ia64: Use HAVE_MEMBLOCK_NODE_MAP
      mips: Use HAVE_MEMBLOCK_NODE_MAP
      s390: Use HAVE_MEMBLOCK_NODE_MAP
      score: Use HAVE_MEMBLOCK_NODE_MAP
      memblock: Kill early_node_map[]
      memblock: Reimplement memblock allocation using reverse free area iterator


 arch/arm/kernel/setup.c                  |    1 +
 arch/arm/mm/init.c                       |    4 +-
 arch/ia64/Kconfig                        |    6 +-
 arch/ia64/mm/contig.c                    |    3 +-
 arch/ia64/mm/init.c                      |    4 +-
 arch/microblaze/include/asm/memblock.h   |   14 -
 arch/microblaze/kernel/prom.c            |    3 +-
 arch/mips/Kconfig                        |    6 +-
 arch/mips/kernel/setup.c                 |    3 +-
 arch/mips/sgi-ip27/ip27-memory.c         |    5 +-
 arch/openrisc/include/asm/memblock.h     |   24 -
 arch/openrisc/kernel/prom.c              |    3 +-
 arch/powerpc/Kconfig                     |    4 +-
 arch/powerpc/include/asm/memblock.h      |    8 -
 arch/powerpc/kernel/machine_kexec.c      |    3 -
 arch/powerpc/kernel/prom.c               |   20 +-
 arch/powerpc/mm/init_32.c                |    4 +-
 arch/powerpc/mm/mem.c                    |    2 +-
 arch/powerpc/mm/numa.c                   |   60 +--
 arch/powerpc/mm/tlb_nohash.c             |    1 -
 arch/powerpc/platforms/embedded6xx/wii.c |   23 +-
 arch/powerpc/platforms/ps3/mm.c          |    1 -
 arch/s390/Kconfig                        |    6 +-
 arch/s390/kernel/setup.c                 |    4 +-
 arch/score/Kconfig                       |    6 +-
 arch/score/kernel/setup.c                |    4 +-
 arch/sh/Kconfig                          |    1 +
 arch/sh/include/asm/memblock.h           |    4 -
 arch/sh/kernel/machine_kexec.c           |    3 -
 arch/sh/kernel/setup.c                   |    3 +-
 arch/sh/mm/Kconfig                       |    3 -
 arch/sh/mm/init.c                        |    3 +-
 arch/sparc/Kconfig                       |    4 +-
 arch/sparc/include/asm/memblock.h        |    8 -
 arch/sparc/mm/init_64.c                  |   32 +-
 arch/unicore32/kernel/setup.c            |    1 +
 arch/unicore32/mm/init.c                 |    4 +-
 arch/unicore32/mm/mmu.c                  |    1 +
 arch/x86/Kconfig                         |    5 +-
 arch/x86/include/asm/e820.h              |    2 +-
 arch/x86/include/asm/memblock.h          |   23 -
 arch/x86/kernel/aperture_64.c            |    4 +-
 arch/x86/kernel/check.c                  |   34 +-
 arch/x86/kernel/e820.c                   |   58 +-
 arch/x86/kernel/head.c                   |    2 +-
 arch/x86/kernel/head32.c                 |    7 +-
 arch/x86/kernel/head64.c                 |    7 +-
 arch/x86/kernel/mpparse.c                |   12 +-
 arch/x86/kernel/setup.c                  |   21 +-
 arch/x86/kernel/trampoline.c             |    4 +-
 arch/x86/mm/Makefile                     |    2 -
 arch/x86/mm/init.c                       |    8 +-
 arch/x86/mm/init_32.c                    |   36 +-
 arch/x86/mm/init_64.c                    |    2 +-
 arch/x86/mm/memblock.c                   |  348 -----------
 arch/x86/mm/memtest.c                    |   33 +-
 arch/x86/mm/numa.c                       |   37 +-
 arch/x86/mm/numa_32.c                    |   10 +-
 arch/x86/mm/numa_64.c                    |    2 +-
 arch/x86/mm/numa_emulation.c             |   36 +-
 arch/x86/platform/efi/efi.c              |    9 +-
 arch/x86/xen/enlighten.c                 |    2 -
 arch/x86/xen/mmu.c                       |   12 +-
 arch/x86/xen/setup.c                     |    7 +-
 drivers/iommu/intel-iommu.c              |   25 +-
 include/linux/bootmem.h                  |    2 +-
 include/linux/memblock.h                 |  170 ++++--
 include/linux/mm.h                       |   34 +-
 include/linux/mmzone.h                   |    8 +-
 include/linux/poison.h                   |    6 -
 kernel/printk.c                          |    2 +-
 mm/Kconfig                               |    6 +
 mm/memblock.c                            |  961 ++++++++++++++++-------------
 mm/nobootmem.c                           |   45 +-
 mm/page_alloc.c                          |  508 +++-------------
 75 files changed, 1032 insertions(+), 1747 deletions(-)
 delete mode 100644 arch/microblaze/include/asm/memblock.h
 delete mode 100644 arch/openrisc/include/asm/memblock.h
 delete mode 100644 arch/powerpc/include/asm/memblock.h
 delete mode 100644 arch/sh/include/asm/memblock.h
 delete mode 100644 arch/sparc/include/asm/memblock.h
 delete mode 100644 arch/x86/include/asm/memblock.h
 delete mode 100644 arch/x86/mm/memblock.c

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 8fc2c8f..c0b59bf 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -52,6 +52,7 @@
 #include <asm/mach/time.h>
 #include <asm/traps.h>
 #include <asm/unwind.h>
+#include <asm/memblock.h>
 
 #if defined(CONFIG_DEPRECATED_PARAM_STRUCT)
 #include "compat.h"
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index fbdd12e..7c38474 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -32,6 +32,7 @@
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
+#include <asm/memblock.h>
 
 #include "mm.h"
 
@@ -332,7 +333,6 @@ void __init arm_memblock_init(struct meminfo *mi, struct machine_desc *mdesc)
 
 	sort(&meminfo.bank, meminfo.nr_banks, sizeof(meminfo.bank[0]), meminfo_cmp, NULL);
 
-	memblock_init();
 	for (i = 0; i < mi->nr_banks; i++)
 		memblock_add(mi->bank[i].start, mi->bank[i].size);
 
@@ -371,7 +371,7 @@ void __init arm_memblock_init(struct meminfo *mi, struct machine_desc *mdesc)
 	if (mdesc->reserve)
 		mdesc->reserve();
 
-	memblock_analyze();
+	memblock_allow_resize();
 	memblock_dump_all();
 }
 
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 27489b6..3b7a7c4 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -23,6 +23,9 @@ config IA64
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_DMA_API_DEBUG
 	select HAVE_GENERIC_HARDIRQS
+	select HAVE_MEMBLOCK
+	select HAVE_MEMBLOCK_NODE_MAP
+	select ARCH_DISCARD_MEMBLOCK
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
 	select IRQ_PER_CPU
@@ -474,9 +477,6 @@ config NODES_SHIFT
 	  MAX_NUMNODES will be 2^(This value).
 	  If in doubt, use the default.
 
-config ARCH_POPULATES_NODE_MAP
-	def_bool y
-
 # VIRTUAL_MEM_MAP and FLAT_NODE_MEM_MAP are functionally equivalent.
 # VIRTUAL_MEM_MAP has been retained for historical reasons.
 config VIRTUAL_MEM_MAP
diff --git a/arch/ia64/mm/contig.c b/arch/ia64/mm/contig.c
index f114a3b..1516d1d 100644
--- a/arch/ia64/mm/contig.c
+++ b/arch/ia64/mm/contig.c
@@ -16,6 +16,7 @@
  */
 #include <linux/bootmem.h>
 #include <linux/efi.h>
+#include <linux/memblock.h>
 #include <linux/mm.h>
 #include <linux/nmi.h>
 #include <linux/swap.h>
@@ -348,7 +349,7 @@ paging_init (void)
 		printk("Virtual mem_map starts at 0x%p\n", mem_map);
 	}
 #else /* !CONFIG_VIRTUAL_MEM_MAP */
-	add_active_range(0, 0, max_low_pfn);
+	memblock_add_node(0, PFN_PHYS(max_low_pfn), 0);
 	free_area_init_nodes(max_zone_pfns);
 #endif /* !CONFIG_VIRTUAL_MEM_MAP */
 	zero_page_memmap_ptr = virt_to_page(ia64_imva(empty_zero_page));
diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
index 00cb0e2..13df239d 100644
--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -10,6 +10,7 @@
 #include <linux/bootmem.h>
 #include <linux/efi.h>
 #include <linux/elf.h>
+#include <linux/memblock.h>
 #include <linux/mm.h>
 #include <linux/mmzone.h>
 #include <linux/module.h>
@@ -557,8 +558,7 @@ int __init register_active_ranges(u64 start, u64 len, int nid)
 #endif
 
 	if (start < end)
-		add_active_range(nid, __pa(start) >> PAGE_SHIFT,
-			__pa(end) >> PAGE_SHIFT);
+		memblock_add_node(__pa(start), end - start, nid);
 	return 0;
 }
 
diff --git a/arch/microblaze/include/asm/memblock.h b/arch/microblaze/include/asm/memblock.h
deleted file mode 100644
index 20a8e25..0000000
--- a/arch/microblaze/include/asm/memblock.h
+++ /dev/null
@@ -1,14 +0,0 @@
-/*
- * Copyright (C) 2008 Michal Simek <monstr@monstr.eu>
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License. See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#ifndef _ASM_MICROBLAZE_MEMBLOCK_H
-#define _ASM_MICROBLAZE_MEMBLOCK_H
-
-#endif /* _ASM_MICROBLAZE_MEMBLOCK_H */
-
-
diff --git a/arch/microblaze/kernel/prom.c b/arch/microblaze/kernel/prom.c
index 977484a..80d314e 100644
--- a/arch/microblaze/kernel/prom.c
+++ b/arch/microblaze/kernel/prom.c
@@ -122,7 +122,6 @@ void __init early_init_devtree(void *params)
 	of_scan_flat_dt(early_init_dt_scan_chosen, cmd_line);
 
 	/* Scan memory nodes and rebuild MEMBLOCKs */
-	memblock_init();
 	of_scan_flat_dt(early_init_dt_scan_root, NULL);
 	of_scan_flat_dt(early_init_dt_scan_memory, NULL);
 
@@ -130,7 +129,7 @@ void __init early_init_devtree(void *params)
 	strlcpy(boot_command_line, cmd_line, COMMAND_LINE_SIZE);
 	parse_early_param();
 
-	memblock_analyze();
+	memblock_allow_resize();
 
 	pr_debug("Phys. mem: %lx\n", (unsigned long) memblock_phys_mem_size());
 
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index d46f1da..9c652eb 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -25,6 +25,9 @@ config MIPS
 	select GENERIC_IRQ_SHOW
 	select HAVE_ARCH_JUMP_LABEL
 	select IRQ_FORCED_THREADING
+	select HAVE_MEMBLOCK
+	select HAVE_MEMBLOCK_NODE_MAP
+	select ARCH_DISCARD_MEMBLOCK
 
 menu "Machine selection"
 
@@ -2064,9 +2067,6 @@ config ARCH_DISCONTIGMEM_ENABLE
 	  or have huge holes in the physical address space for other reasons.
 	  See <file:Documentation/vm/numa> for more.
 
-config ARCH_POPULATES_NODE_MAP
-	def_bool y
-
 config ARCH_SPARSEMEM_ENABLE
 	bool
 	select SPARSEMEM_STATIC
diff --git a/arch/mips/kernel/setup.c b/arch/mips/kernel/setup.c
index 84af26a..b1cb8f8 100644
--- a/arch/mips/kernel/setup.c
+++ b/arch/mips/kernel/setup.c
@@ -14,6 +14,7 @@
 #include <linux/ioport.h>
 #include <linux/export.h>
 #include <linux/screen_info.h>
+#include <linux/memblock.h>
 #include <linux/bootmem.h>
 #include <linux/initrd.h>
 #include <linux/root_dev.h>
@@ -352,7 +353,7 @@ static void __init bootmem_init(void)
 			continue;
 #endif
 
-		add_active_range(0, start, end);
+		memblock_add_node(PFN_PHYS(start), PFN_PHYS(end - start), 0);
 	}
 
 	/*
diff --git a/arch/mips/sgi-ip27/ip27-memory.c b/arch/mips/sgi-ip27/ip27-memory.c
index bc12971..b105eca 100644
--- a/arch/mips/sgi-ip27/ip27-memory.c
+++ b/arch/mips/sgi-ip27/ip27-memory.c
@@ -12,6 +12,7 @@
  */
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/memblock.h>
 #include <linux/mm.h>
 #include <linux/mmzone.h>
 #include <linux/module.h>
@@ -381,8 +382,8 @@ static void __init szmem(void)
 				continue;
 			}
 			num_physpages += slot_psize;
-			add_active_range(node, slot_getbasepfn(node, slot),
-					 slot_getbasepfn(node, slot) + slot_psize);
+			memblock_add_node(PFN_PHYS(slot_getbasepfn(node, slot)),
+					  PFN_PHYS(slot_psize), node);
 		}
 	}
 }
diff --git a/arch/openrisc/include/asm/memblock.h b/arch/openrisc/include/asm/memblock.h
deleted file mode 100644
index bbe5a1c..0000000
--- a/arch/openrisc/include/asm/memblock.h
+++ /dev/null
@@ -1,24 +0,0 @@
-/*
- * OpenRISC Linux
- *
- * Linux architectural port borrowing liberally from similar works of
- * others.  All original copyrights apply as per the original source
- * declaration.
- *
- * OpenRISC implementation:
- * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
- * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
- * et al.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifndef __ASM_OPENRISC_MEMBLOCK_H
-#define __ASM_OPENRISC_MEMBLOCK_H
-
-/* empty */
-
-#endif /* __ASM_OPENRISC_MEMBLOCK_H */
diff --git a/arch/openrisc/kernel/prom.c b/arch/openrisc/kernel/prom.c
index 1bb58ba..3d4478f 100644
--- a/arch/openrisc/kernel/prom.c
+++ b/arch/openrisc/kernel/prom.c
@@ -76,14 +76,13 @@ void __init early_init_devtree(void *params)
 	of_scan_flat_dt(early_init_dt_scan_chosen, cmd_line);
 
 	/* Scan memory nodes and rebuild MEMBLOCKs */
-	memblock_init();
 	of_scan_flat_dt(early_init_dt_scan_root, NULL);
 	of_scan_flat_dt(early_init_dt_scan_memory, NULL);
 
 	/* Save command line for /proc/cmdline and then parse parameters */
 	strlcpy(boot_command_line, cmd_line, COMMAND_LINE_SIZE);
 
-	memblock_analyze();
+	memblock_allow_resize();
 
 	/* We must copy the flattend device tree from init memory to regular
 	 * memory because the device tree references the strings in it
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 951e18f..ead0bc6 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -117,6 +117,7 @@ config PPC
 	select HAVE_KRETPROBES
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_MEMBLOCK
+	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_DMA_ATTRS
 	select HAVE_DMA_API_DEBUG
 	select USE_GENERIC_SMP_HELPERS if SMP
@@ -421,9 +422,6 @@ config ARCH_SPARSEMEM_DEFAULT
 	def_bool y
 	depends on (SMP && PPC_PSERIES) || PPC_PS3
 
-config ARCH_POPULATES_NODE_MAP
-	def_bool y
-
 config SYS_SUPPORTS_HUGETLBFS
 	bool
 
diff --git a/arch/powerpc/include/asm/memblock.h b/arch/powerpc/include/asm/memblock.h
deleted file mode 100644
index 43efc34..0000000
--- a/arch/powerpc/include/asm/memblock.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef _ASM_POWERPC_MEMBLOCK_H
-#define _ASM_POWERPC_MEMBLOCK_H
-
-#include <asm/udbg.h>
-
-#define MEMBLOCK_DBG(fmt...) udbg_printf(fmt)
-
-#endif /* _ASM_POWERPC_MEMBLOCK_H */
diff --git a/arch/powerpc/kernel/machine_kexec.c b/arch/powerpc/kernel/machine_kexec.c
index 9ce1672..a2158a3 100644
--- a/arch/powerpc/kernel/machine_kexec.c
+++ b/arch/powerpc/kernel/machine_kexec.c
@@ -107,9 +107,6 @@ void __init reserve_crashkernel(void)
 	unsigned long long crash_size, crash_base;
 	int ret;
 
-	/* this is necessary because of memblock_phys_mem_size() */
-	memblock_analyze();
-
 	/* use common parsing */
 	ret = parse_crashkernel(boot_command_line, memblock_phys_mem_size(),
 			&crash_size, &crash_base);
diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index fa1235b..abe405d 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -733,8 +733,6 @@ void __init early_init_devtree(void *params)
 	of_scan_flat_dt(early_init_dt_scan_chosen_ppc, cmd_line);
 
 	/* Scan memory nodes and rebuild MEMBLOCKs */
-	memblock_init();
-
 	of_scan_flat_dt(early_init_dt_scan_root, NULL);
 	of_scan_flat_dt(early_init_dt_scan_memory_ppc, NULL);
 
@@ -756,20 +754,14 @@ void __init early_init_devtree(void *params)
 	early_reserve_mem();
 	phyp_dump_reserve_mem();
 
-	limit = memory_limit;
-	if (! limit) {
-		phys_addr_t memsize;
-
-		/* Ensure that total memory size is page-aligned, because
-		 * otherwise mark_bootmem() gets upset. */
-		memblock_analyze();
-		memsize = memblock_phys_mem_size();
-		if ((memsize & PAGE_MASK) != memsize)
-			limit = memsize & PAGE_MASK;
-	}
+	/*
+	 * Ensure that total memory size is page-aligned, because otherwise
+	 * mark_bootmem() gets upset.
+	 */
+	limit = ALIGN(memory_limit ?: memblock_phys_mem_size(), PAGE_SIZE);
 	memblock_enforce_memory_limit(limit);
 
-	memblock_analyze();
+	memblock_allow_resize();
 	memblock_dump_all();
 
 	DBG("Phys. mem: %llx\n", memblock_phys_mem_size());
diff --git a/arch/powerpc/mm/init_32.c b/arch/powerpc/mm/init_32.c
index 161cefd..58861fa 100644
--- a/arch/powerpc/mm/init_32.c
+++ b/arch/powerpc/mm/init_32.c
@@ -134,8 +134,7 @@ void __init MMU_init(void)
 
 	if (memblock.memory.cnt > 1) {
 #ifndef CONFIG_WII
-		memblock.memory.cnt = 1;
-		memblock_analyze();
+		memblock_enforce_memory_limit(memblock.memory.regions[0].size);
 		printk(KERN_WARNING "Only using first contiguous memory region");
 #else
 		wii_memory_fixups();
@@ -158,7 +157,6 @@ void __init MMU_init(void)
 #ifndef CONFIG_HIGHMEM
 		total_memory = total_lowmem;
 		memblock_enforce_memory_limit(total_lowmem);
-		memblock_analyze();
 #endif /* CONFIG_HIGHMEM */
 	}
 
diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 2dd6bdd..8e2eb66 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -199,7 +199,7 @@ void __init do_init_bootmem(void)
 		unsigned long start_pfn, end_pfn;
 		start_pfn = memblock_region_memory_base_pfn(reg);
 		end_pfn = memblock_region_memory_end_pfn(reg);
-		add_active_range(0, start_pfn, end_pfn);
+		memblock_set_node(0, (phys_addr_t)ULLONG_MAX, 0);
 	}
 
 	/* Add all physical memory to the bootmem map, mark each area
diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index b22a83a..e6eea0a 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -127,45 +127,25 @@ static int __cpuinit fake_numa_create_new_node(unsigned long end_pfn,
 }
 
 /*
- * get_active_region_work_fn - A helper function for get_node_active_region
- *	Returns datax set to the start_pfn and end_pfn if they contain
- *	the initial value of datax->start_pfn between them
- * @start_pfn: start page(inclusive) of region to check
- * @end_pfn: end page(exclusive) of region to check
- * @datax: comes in with ->start_pfn set to value to search for and
- *	goes out with active range if it contains it
- * Returns 1 if search value is in range else 0
- */
-static int __init get_active_region_work_fn(unsigned long start_pfn,
-					unsigned long end_pfn, void *datax)
-{
-	struct node_active_region *data;
-	data = (struct node_active_region *)datax;
-
-	if (start_pfn <= data->start_pfn && end_pfn > data->start_pfn) {
-		data->start_pfn = start_pfn;
-		data->end_pfn = end_pfn;
-		return 1;
-	}
-	return 0;
-
-}
-
-/*
- * get_node_active_region - Return active region containing start_pfn
+ * get_node_active_region - Return active region containing pfn
  * Active range returned is empty if none found.
- * @start_pfn: The page to return the region for.
- * @node_ar: Returned set to the active region containing start_pfn
+ * @pfn: The page to return the region for
+ * @node_ar: Returned set to the active region containing @pfn
  */
-static void __init get_node_active_region(unsigned long start_pfn,
-		       struct node_active_region *node_ar)
+static void __init get_node_active_region(unsigned long pfn,
+					  struct node_active_region *node_ar)
 {
-	int nid = early_pfn_to_nid(start_pfn);
+	unsigned long start_pfn, end_pfn;
+	int i, nid;
 
-	node_ar->nid = nid;
-	node_ar->start_pfn = start_pfn;
-	node_ar->end_pfn = start_pfn;
-	work_with_active_regions(nid, get_active_region_work_fn, node_ar);
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
+		if (pfn >= start_pfn && pfn < end_pfn) {
+			node_ar->nid = nid;
+			node_ar->start_pfn = start_pfn;
+			node_ar->end_pfn = end_pfn;
+			break;
+		}
+	}
 }
 
 static void map_cpu_to_node(int cpu, int node)
@@ -710,9 +690,7 @@ static void __init parse_drconf_memory(struct device_node *memory)
 			node_set_online(nid);
 			sz = numa_enforce_memory_limit(base, size);
 			if (sz)
-				add_active_range(nid, base >> PAGE_SHIFT,
-						 (base >> PAGE_SHIFT)
-						 + (sz >> PAGE_SHIFT));
+				memblock_set_node(base, sz, nid);
 		} while (--ranges);
 	}
 }
@@ -802,8 +780,7 @@ new_range:
 				continue;
 		}
 
-		add_active_range(nid, start >> PAGE_SHIFT,
-				(start >> PAGE_SHIFT) + (size >> PAGE_SHIFT));
+		memblock_set_node(start, size, nid);
 
 		if (--ranges)
 			goto new_range;
@@ -839,7 +816,8 @@ static void __init setup_nonnuma(void)
 		end_pfn = memblock_region_memory_end_pfn(reg);
 
 		fake_numa_create_new_node(end_pfn, &nid);
-		add_active_range(nid, start_pfn, end_pfn);
+		memblock_set_node(PFN_PHYS(start_pfn),
+				  PFN_PHYS(end_pfn - start_pfn), nid);
 		node_set_online(nid);
 	}
 }
diff --git a/arch/powerpc/mm/tlb_nohash.c b/arch/powerpc/mm/tlb_nohash.c
index 4e13d6f..573ba3b 100644
--- a/arch/powerpc/mm/tlb_nohash.c
+++ b/arch/powerpc/mm/tlb_nohash.c
@@ -615,7 +615,6 @@ static void __early_init_mmu(int boot_cpu)
 
 		/* limit memory so we dont have linear faults */
 		memblock_enforce_memory_limit(linear_map_top);
-		memblock_analyze();
 
 		patch_exception(0x1c0, exc_data_tlb_miss_bolted_book3e);
 		patch_exception(0x1e0, exc_instruction_tlb_miss_bolted_book3e);
diff --git a/arch/powerpc/platforms/embedded6xx/wii.c b/arch/powerpc/platforms/embedded6xx/wii.c
index 1b5dc1a..6d8dadf 100644
--- a/arch/powerpc/platforms/embedded6xx/wii.c
+++ b/arch/powerpc/platforms/embedded6xx/wii.c
@@ -79,24 +79,19 @@ void __init wii_memory_fixups(void)
 	BUG_ON(memblock.memory.cnt != 2);
 	BUG_ON(!page_aligned(p[0].base) || !page_aligned(p[1].base));
 
-	p[0].size = _ALIGN_DOWN(p[0].size, PAGE_SIZE);
-	p[1].size = _ALIGN_DOWN(p[1].size, PAGE_SIZE);
+	/* trim unaligned tail */
+	memblock_remove(ALIGN(p[1].base + p[1].size, PAGE_SIZE),
+			(phys_addr_t)ULLONG_MAX);
 
-	wii_hole_start = p[0].base + p[0].size;
+	/* determine hole, add & reserve them */
+	wii_hole_start = ALIGN(p[0].base + p[0].size, PAGE_SIZE);
 	wii_hole_size = p[1].base - wii_hole_start;
-
-	pr_info("MEM1: <%08llx %08llx>\n", p[0].base, p[0].size);
-	pr_info("HOLE: <%08lx %08lx>\n", wii_hole_start, wii_hole_size);
-	pr_info("MEM2: <%08llx %08llx>\n", p[1].base, p[1].size);
-
-	p[0].size += wii_hole_size + p[1].size;
-
-	memblock.memory.cnt = 1;
-	memblock_analyze();
-
-	/* reserve the hole */
+	memblock_add(wii_hole_start, wii_hole_size);
 	memblock_reserve(wii_hole_start, wii_hole_size);
 
+	BUG_ON(memblock.memory.cnt != 1);
+	__memblock_dump_all();
+
 	/* allow ioremapping the address space in the hole */
 	__allow_ioremap_reserved = 1;
 }
diff --git a/arch/powerpc/platforms/ps3/mm.c b/arch/powerpc/platforms/ps3/mm.c
index 72714ad..8bd6ba5 100644
--- a/arch/powerpc/platforms/ps3/mm.c
+++ b/arch/powerpc/platforms/ps3/mm.c
@@ -319,7 +319,6 @@ static int __init ps3_mm_add_memory(void)
 	}
 
 	memblock_add(start_addr, map.r1.size);
-	memblock_analyze();
 
 	result = online_pages(start_pfn, nr_pages);
 
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 373679b..d48ede3 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -92,6 +92,9 @@ config S390
 	select HAVE_ARCH_JUMP_LABEL if !MARCH_G5
 	select HAVE_RCU_TABLE_FREE if SMP
 	select ARCH_SAVE_PAGE_KEYS if HIBERNATION
+	select HAVE_MEMBLOCK
+	select HAVE_MEMBLOCK_NODE_MAP
+	select ARCH_DISCARD_MEMBLOCK
 	select ARCH_INLINE_SPIN_TRYLOCK
 	select ARCH_INLINE_SPIN_TRYLOCK_BH
 	select ARCH_INLINE_SPIN_LOCK
@@ -345,9 +348,6 @@ config WARN_DYNAMIC_STACK
 
 	  Say N if you are unsure.
 
-config ARCH_POPULATES_NODE_MAP
-	def_bool y
-
 comment "Kernel preemption"
 
 source "kernel/Kconfig.preempt"
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index e54c4ff..f11d1b0 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/kernel.h>
+#include <linux/memblock.h>
 #include <linux/mm.h>
 #include <linux/stddef.h>
 #include <linux/unistd.h>
@@ -820,7 +821,8 @@ setup_memory(void)
 		end_chunk = min(end_chunk, end_pfn);
 		if (start_chunk >= end_chunk)
 			continue;
-		add_active_range(0, start_chunk, end_chunk);
+		memblock_add_node(PFN_PHYS(start_chunk),
+				  PFN_PHYS(end_chunk - start_chunk), 0);
 		pfn = max(start_chunk, start_pfn);
 		for (; pfn < end_chunk; pfn++)
 			page_set_storage_key(PFN_PHYS(pfn),
diff --git a/arch/score/Kconfig b/arch/score/Kconfig
index df169e8..8b0c946 100644
--- a/arch/score/Kconfig
+++ b/arch/score/Kconfig
@@ -4,6 +4,9 @@ config SCORE
        def_bool y
        select HAVE_GENERIC_HARDIRQS
        select GENERIC_IRQ_SHOW
+       select HAVE_MEMBLOCK
+       select HAVE_MEMBLOCK_NODE_MAP
+       select ARCH_DISCARD_MEMBLOCK
 
 choice
 	prompt "System type"
@@ -60,9 +63,6 @@ config 32BIT
 config ARCH_FLATMEM_ENABLE
 	def_bool y
 
-config ARCH_POPULATES_NODE_MAP
-	def_bool y
-
 source "mm/Kconfig"
 
 config MEMORY_START
diff --git a/arch/score/kernel/setup.c b/arch/score/kernel/setup.c
index 6f898c0..b48459a 100644
--- a/arch/score/kernel/setup.c
+++ b/arch/score/kernel/setup.c
@@ -26,6 +26,7 @@
 #include <linux/bootmem.h>
 #include <linux/initrd.h>
 #include <linux/ioport.h>
+#include <linux/memblock.h>
 #include <linux/mm.h>
 #include <linux/seq_file.h>
 #include <linux/screen_info.h>
@@ -54,7 +55,8 @@ static void __init bootmem_init(void)
 	/* Initialize the boot-time allocator with low memory only. */
 	bootmap_size = init_bootmem_node(NODE_DATA(0), start_pfn,
 					 min_low_pfn, max_low_pfn);
-	add_active_range(0, min_low_pfn, max_low_pfn);
+	memblock_add_node(PFN_PHYS(min_low_pfn),
+			  PFN_PHYS(max_low_pfn - min_low_pfn), 0);
 
 	free_bootmem(PFN_PHYS(start_pfn),
 		     (max_low_pfn - start_pfn) << PAGE_SHIFT);
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 5629e20..47a2f1c 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -4,6 +4,7 @@ config SUPERH
 	select CLKDEV_LOOKUP
 	select HAVE_IDE if HAS_IOPORT
 	select HAVE_MEMBLOCK
+	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_OPROFILE
 	select HAVE_GENERIC_DMA_COHERENT
 	select HAVE_ARCH_TRACEHOOK
diff --git a/arch/sh/include/asm/memblock.h b/arch/sh/include/asm/memblock.h
deleted file mode 100644
index e87063f..0000000
--- a/arch/sh/include/asm/memblock.h
+++ /dev/null
@@ -1,4 +0,0 @@
-#ifndef __ASM_SH_MEMBLOCK_H
-#define __ASM_SH_MEMBLOCK_H
-
-#endif /* __ASM_SH_MEMBLOCK_H */
diff --git a/arch/sh/kernel/machine_kexec.c b/arch/sh/kernel/machine_kexec.c
index c5a33f0..9fea49f 100644
--- a/arch/sh/kernel/machine_kexec.c
+++ b/arch/sh/kernel/machine_kexec.c
@@ -157,9 +157,6 @@ void __init reserve_crashkernel(void)
 	unsigned long long crash_size, crash_base;
 	int ret;
 
-	/* this is necessary because of memblock_phys_mem_size() */
-	memblock_analyze();
-
 	ret = parse_crashkernel(boot_command_line, memblock_phys_mem_size(),
 			&crash_size, &crash_base);
 	if (ret == 0 && crash_size > 0) {
diff --git a/arch/sh/kernel/setup.c b/arch/sh/kernel/setup.c
index 1a0e946..7b57bf1 100644
--- a/arch/sh/kernel/setup.c
+++ b/arch/sh/kernel/setup.c
@@ -230,7 +230,8 @@ void __init __add_active_range(unsigned int nid, unsigned long start_pfn,
 	pmb_bolt_mapping((unsigned long)__va(start), start, end - start,
 			 PAGE_KERNEL);
 
-	add_active_range(nid, start_pfn, end_pfn);
+	memblock_set_node(PFN_PHYS(start_pfn),
+			  PFN_PHYS(end_pfn - start_pfn), nid);
 }
 
 void __init __weak plat_early_device_setup(void)
diff --git a/arch/sh/mm/Kconfig b/arch/sh/mm/Kconfig
index c3e61b3..cb8f992 100644
--- a/arch/sh/mm/Kconfig
+++ b/arch/sh/mm/Kconfig
@@ -143,9 +143,6 @@ config MAX_ACTIVE_REGIONS
 		       CPU_SUBTYPE_SH7785)
 	default "1"
 
-config ARCH_POPULATES_NODE_MAP
-	def_bool y
-
 config ARCH_SELECT_MEMORY_MODEL
 	def_bool y
 
diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
index 939ca0f..82cc576 100644
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -324,7 +324,6 @@ void __init paging_init(void)
 	unsigned long vaddr, end;
 	int nid;
 
-	memblock_init();
 	sh_mv.mv_mem_init();
 
 	early_reserve_mem();
@@ -337,7 +336,7 @@ void __init paging_init(void)
 		sh_mv.mv_mem_reserve();
 
 	memblock_enforce_memory_limit(memory_limit);
-	memblock_analyze();
+	memblock_allow_resize();
 
 	memblock_dump_all();
 
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index f92602e..70ae9d8 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -43,6 +43,7 @@ config SPARC64
 	select HAVE_KPROBES
 	select HAVE_RCU_TABLE_FREE if SMP
 	select HAVE_MEMBLOCK
+	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_SYSCALL_WRAPPERS
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE_MCOUNT_RECORD
@@ -352,9 +353,6 @@ config NODES_SPAN_OTHER_NODES
 	def_bool y
 	depends on NEED_MULTIPLE_NODES
 
-config ARCH_POPULATES_NODE_MAP
-	def_bool y if SPARC64
-
 config ARCH_SELECT_MEMORY_MODEL
 	def_bool y if SPARC64
 
diff --git a/arch/sparc/include/asm/memblock.h b/arch/sparc/include/asm/memblock.h
deleted file mode 100644
index c67b047..0000000
--- a/arch/sparc/include/asm/memblock.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef _SPARC64_MEMBLOCK_H
-#define _SPARC64_MEMBLOCK_H
-
-#include <asm/oplib.h>
-
-#define MEMBLOCK_DBG(fmt...) prom_printf(fmt)
-
-#endif /* !(_SPARC64_MEMBLOCK_H) */
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 8e073d8..b3f5e7d 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -790,7 +790,7 @@ static int find_node(unsigned long addr)
 	return -1;
 }
 
-u64 memblock_nid_range(u64 start, u64 end, int *nid)
+static u64 memblock_nid_range(u64 start, u64 end, int *nid)
 {
 	*nid = find_node(start);
 	start += PAGE_SIZE;
@@ -808,7 +808,7 @@ u64 memblock_nid_range(u64 start, u64 end, int *nid)
 	return start;
 }
 #else
-u64 memblock_nid_range(u64 start, u64 end, int *nid)
+static u64 memblock_nid_range(u64 start, u64 end, int *nid)
 {
 	*nid = 0;
 	return end;
@@ -816,7 +816,7 @@ u64 memblock_nid_range(u64 start, u64 end, int *nid)
 #endif
 
 /* This must be invoked after performing all of the necessary
- * add_active_range() calls for 'nid'.  We need to be able to get
+ * memblock_set_node() calls for 'nid'.  We need to be able to get
  * correct data from get_pfn_range_for_nid().
  */
 static void __init allocate_node_data(int nid)
@@ -987,14 +987,11 @@ static void __init add_node_ranges(void)
 
 			this_end = memblock_nid_range(start, end, &nid);
 
-			numadbg("Adding active range nid[%d] "
+			numadbg("Setting memblock NUMA node nid[%d] "
 				"start[%lx] end[%lx]\n",
 				nid, start, this_end);
 
-			add_active_range(nid,
-					 start >> PAGE_SHIFT,
-					 this_end >> PAGE_SHIFT);
-
+			memblock_set_node(start, this_end - start, nid);
 			start = this_end;
 		}
 	}
@@ -1282,7 +1279,6 @@ static void __init bootmem_init_nonnuma(void)
 {
 	unsigned long top_of_ram = memblock_end_of_DRAM();
 	unsigned long total_ram = memblock_phys_mem_size();
-	struct memblock_region *reg;
 
 	numadbg("bootmem_init_nonnuma()\n");
 
@@ -1292,20 +1288,8 @@ static void __init bootmem_init_nonnuma(void)
 	       (top_of_ram - total_ram) >> 20);
 
 	init_node_masks_nonnuma();
-
-	for_each_memblock(memory, reg) {
-		unsigned long start_pfn, end_pfn;
-
-		if (!reg->size)
-			continue;
-
-		start_pfn = memblock_region_memory_base_pfn(reg);
-		end_pfn = memblock_region_memory_end_pfn(reg);
-		add_active_range(0, start_pfn, end_pfn);
-	}
-
+	memblock_set_node(0, (phys_addr_t)ULLONG_MAX, 0);
 	allocate_node_data(0);
-
 	node_set_online(0);
 }
 
@@ -1769,8 +1753,6 @@ void __init paging_init(void)
 		sun4v_ktsb_init();
 	}
 
-	memblock_init();
-
 	/* Find available physical memory...
 	 *
 	 * Read it twice in order to work around a bug in openfirmware.
@@ -1796,7 +1778,7 @@ void __init paging_init(void)
 
 	memblock_enforce_memory_limit(cmdline_memory_size);
 
-	memblock_analyze();
+	memblock_allow_resize();
 	memblock_dump_all();
 
 	set_bit(0, mmu_context_bmap);
diff --git a/arch/unicore32/kernel/setup.c b/arch/unicore32/kernel/setup.c
index 471b6bc..673d7a8 100644
--- a/arch/unicore32/kernel/setup.c
+++ b/arch/unicore32/kernel/setup.c
@@ -37,6 +37,7 @@
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 #include <asm/traps.h>
+#include <asm/memblock.h>
 
 #include "setup.h"
 
diff --git a/arch/unicore32/mm/init.c b/arch/unicore32/mm/init.c
index 3b379cd..de186bd 100644
--- a/arch/unicore32/mm/init.c
+++ b/arch/unicore32/mm/init.c
@@ -26,6 +26,7 @@
 #include <asm/setup.h>
 #include <asm/sizes.h>
 #include <asm/tlb.h>
+#include <asm/memblock.h>
 #include <mach/map.h>
 
 #include "mm.h"
@@ -245,7 +246,6 @@ void __init uc32_memblock_init(struct meminfo *mi)
 	sort(&meminfo.bank, meminfo.nr_banks, sizeof(meminfo.bank[0]),
 		meminfo_cmp, NULL);
 
-	memblock_init();
 	for (i = 0; i < mi->nr_banks; i++)
 		memblock_add(mi->bank[i].start, mi->bank[i].size);
 
@@ -264,7 +264,7 @@ void __init uc32_memblock_init(struct meminfo *mi)
 
 	uc32_mm_memblock_reserve();
 
-	memblock_analyze();
+	memblock_allow_resize();
 	memblock_dump_all();
 }
 
diff --git a/arch/unicore32/mm/mmu.c b/arch/unicore32/mm/mmu.c
index 3e5c3e5..43c20b4 100644
--- a/arch/unicore32/mm/mmu.c
+++ b/arch/unicore32/mm/mmu.c
@@ -25,6 +25,7 @@
 #include <asm/setup.h>
 #include <asm/sizes.h>
 #include <asm/tlb.h>
+#include <asm/memblock.h>
 
 #include <mach/map.h>
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index efb4294..67d6af3 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -26,6 +26,8 @@ config X86
 	select HAVE_IOREMAP_PROT
 	select HAVE_KPROBES
 	select HAVE_MEMBLOCK
+	select HAVE_MEMBLOCK_NODE_MAP
+	select ARCH_DISCARD_MEMBLOCK
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_WANT_FRAME_POINTERS
 	select HAVE_DMA_ATTRS
@@ -204,9 +206,6 @@ config ZONE_DMA32
 	bool
 	default X86_64
 
-config ARCH_POPULATES_NODE_MAP
-	def_bool y
-
 config AUDIT_ARCH
 	bool
 	default X86_64
diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
index 908b969..3778256 100644
--- a/arch/x86/include/asm/e820.h
+++ b/arch/x86/include/asm/e820.h
@@ -117,7 +117,7 @@ static inline void early_memtest(unsigned long start, unsigned long end)
 
 extern unsigned long e820_end_of_ram_pfn(void);
 extern unsigned long e820_end_of_low_ram_pfn(void);
-extern u64 early_reserve_e820(u64 startt, u64 sizet, u64 align);
+extern u64 early_reserve_e820(u64 sizet, u64 align);
 
 void memblock_x86_fill(void);
 void memblock_find_dma_reserve(void);
diff --git a/arch/x86/include/asm/memblock.h b/arch/x86/include/asm/memblock.h
deleted file mode 100644
index 0cd3800..0000000
--- a/arch/x86/include/asm/memblock.h
+++ /dev/null
@@ -1,23 +0,0 @@
-#ifndef _X86_MEMBLOCK_H
-#define _X86_MEMBLOCK_H
-
-#define ARCH_DISCARD_MEMBLOCK
-
-u64 memblock_x86_find_in_range_size(u64 start, u64 *sizep, u64 align);
-
-void memblock_x86_reserve_range(u64 start, u64 end, char *name);
-void memblock_x86_free_range(u64 start, u64 end);
-struct range;
-int __get_free_all_memory_range(struct range **range, int nodeid,
-			 unsigned long start_pfn, unsigned long end_pfn);
-int get_free_all_memory_range(struct range **rangep, int nodeid);
-
-void memblock_x86_register_active_regions(int nid, unsigned long start_pfn,
-					 unsigned long last_pfn);
-u64 memblock_x86_hole_size(u64 start, u64 end);
-u64 memblock_x86_find_in_range_node(int nid, u64 start, u64 end, u64 size, u64 align);
-u64 memblock_x86_free_memory_in_range(u64 addr, u64 limit);
-u64 memblock_x86_memory_in_range(u64 addr, u64 limit);
-bool memblock_x86_check_reserved_size(u64 *addrp, u64 *sizep, u64 align);
-
-#endif
diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 3d2661c..6e76c19 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -88,13 +88,13 @@ static u32 __init allocate_aperture(void)
 	 */
 	addr = memblock_find_in_range(GART_MIN_ADDR, GART_MAX_ADDR,
 				      aper_size, aper_size);
-	if (addr == MEMBLOCK_ERROR || addr + aper_size > GART_MAX_ADDR) {
+	if (!addr || addr + aper_size > GART_MAX_ADDR) {
 		printk(KERN_ERR
 			"Cannot allocate aperture memory hole (%lx,%uK)\n",
 				addr, aper_size>>10);
 		return 0;
 	}
-	memblock_x86_reserve_range(addr, addr + aper_size, "aperture64");
+	memblock_reserve(addr, aper_size);
 	/*
 	 * Kmemleak should not scan this block as it may not be mapped via the
 	 * kernel direct mapping.
diff --git a/arch/x86/kernel/check.c b/arch/x86/kernel/check.c
index 452932d..5da1269 100644
--- a/arch/x86/kernel/check.c
+++ b/arch/x86/kernel/check.c
@@ -62,7 +62,8 @@ early_param("memory_corruption_check_size", set_corruption_check_size);
 
 void __init setup_bios_corruption_check(void)
 {
-	u64 addr = PAGE_SIZE;	/* assume first page is reserved anyway */
+	phys_addr_t start, end;
+	u64 i;
 
 	if (memory_corruption_check == -1) {
 		memory_corruption_check =
@@ -82,28 +83,23 @@ void __init setup_bios_corruption_check(void)
 
 	corruption_check_size = round_up(corruption_check_size, PAGE_SIZE);
 
-	while (addr < corruption_check_size && num_scan_areas < MAX_SCAN_AREAS) {
-		u64 size;
-		addr = memblock_x86_find_in_range_size(addr, &size, PAGE_SIZE);
+	for_each_free_mem_range(i, MAX_NUMNODES, &start, &end, NULL) {
+		start = clamp_t(phys_addr_t, round_up(start, PAGE_SIZE),
+				PAGE_SIZE, corruption_check_size);
+		end = clamp_t(phys_addr_t, round_down(end, PAGE_SIZE),
+			      PAGE_SIZE, corruption_check_size);
+		if (start >= end)
+			continue;
 
-		if (addr == MEMBLOCK_ERROR)
-			break;
-
-		if (addr >= corruption_check_size)
-			break;
-
-		if ((addr + size) > corruption_check_size)
-			size = corruption_check_size - addr;
-
-		memblock_x86_reserve_range(addr, addr + size, "SCAN RAM");
-		scan_areas[num_scan_areas].addr = addr;
-		scan_areas[num_scan_areas].size = size;
-		num_scan_areas++;
+		memblock_reserve(start, end - start);
+		scan_areas[num_scan_areas].addr = start;
+		scan_areas[num_scan_areas].size = end - start;
 
 		/* Assume we've already mapped this early memory */
-		memset(__va(addr), 0, size);
+		memset(__va(start), 0, end - start);
 
-		addr += size;
+		if (++num_scan_areas >= MAX_SCAN_AREAS)
+			break;
 	}
 
 	if (num_scan_areas)
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 303a0e4..8071e2f 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -738,35 +738,17 @@ core_initcall(e820_mark_nvs_memory);
 /*
  * pre allocated 4k and reserved it in memblock and e820_saved
  */
-u64 __init early_reserve_e820(u64 startt, u64 sizet, u64 align)
+u64 __init early_reserve_e820(u64 size, u64 align)
 {
-	u64 size = 0;
 	u64 addr;
-	u64 start;
 
-	for (start = startt; ; start += size) {
-		start = memblock_x86_find_in_range_size(start, &size, align);
-		if (start == MEMBLOCK_ERROR)
-			return 0;
-		if (size >= sizet)
-			break;
+	addr = __memblock_alloc_base(size, align, MEMBLOCK_ALLOC_ACCESSIBLE);
+	if (addr) {
+		e820_update_range_saved(addr, size, E820_RAM, E820_RESERVED);
+		printk(KERN_INFO "update e820_saved for early_reserve_e820\n");
+		update_e820_saved();
 	}
 
-#ifdef CONFIG_X86_32
-	if (start >= MAXMEM)
-		return 0;
-	if (start + size > MAXMEM)
-		size = MAXMEM - start;
-#endif
-
-	addr = round_down(start + size - sizet, align);
-	if (addr < start)
-		return 0;
-	memblock_x86_reserve_range(addr, addr + sizet, "new next");
-	e820_update_range_saved(addr, sizet, E820_RAM, E820_RESERVED);
-	printk(KERN_INFO "update e820_saved for early_reserve_e820\n");
-	update_e820_saved();
-
 	return addr;
 }
 
@@ -1090,7 +1072,7 @@ void __init memblock_x86_fill(void)
 	 * We are safe to enable resizing, beause memblock_x86_fill()
 	 * is rather later for x86
 	 */
-	memblock_can_resize = 1;
+	memblock_allow_resize();
 
 	for (i = 0; i < e820.nr_map; i++) {
 		struct e820entry *ei = &e820.map[i];
@@ -1105,22 +1087,36 @@ void __init memblock_x86_fill(void)
 		memblock_add(ei->addr, ei->size);
 	}
 
-	memblock_analyze();
 	memblock_dump_all();
 }
 
 void __init memblock_find_dma_reserve(void)
 {
 #ifdef CONFIG_X86_64
-	u64 free_size_pfn;
-	u64 mem_size_pfn;
+	u64 nr_pages = 0, nr_free_pages = 0;
+	unsigned long start_pfn, end_pfn;
+	phys_addr_t start, end;
+	int i;
+	u64 u;
+
 	/*
 	 * need to find out used area below MAX_DMA_PFN
 	 * need to use memblock to get free size in [0, MAX_DMA_PFN]
 	 * at first, and assume boot_mem will not take below MAX_DMA_PFN
 	 */
-	mem_size_pfn = memblock_x86_memory_in_range(0, MAX_DMA_PFN << PAGE_SHIFT) >> PAGE_SHIFT;
-	free_size_pfn = memblock_x86_free_memory_in_range(0, MAX_DMA_PFN << PAGE_SHIFT) >> PAGE_SHIFT;
-	set_dma_reserve(mem_size_pfn - free_size_pfn);
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, NULL) {
+		start_pfn = min_t(unsigned long, start_pfn, MAX_DMA_PFN);
+		end_pfn = min_t(unsigned long, end_pfn, MAX_DMA_PFN);
+		nr_pages += end_pfn - start_pfn;
+	}
+
+	for_each_free_mem_range(u, MAX_NUMNODES, &start, &end, NULL) {
+		start_pfn = min_t(unsigned long, PFN_UP(start), MAX_DMA_PFN);
+		end_pfn = min_t(unsigned long, PFN_DOWN(end), MAX_DMA_PFN);
+		if (start_pfn < end_pfn)
+			nr_free_pages += end_pfn - start_pfn;
+	}
+
+	set_dma_reserve(nr_pages - nr_free_pages);
 #endif
 }
diff --git a/arch/x86/kernel/head.c b/arch/x86/kernel/head.c
index af0699b..48d9d4e 100644
--- a/arch/x86/kernel/head.c
+++ b/arch/x86/kernel/head.c
@@ -52,5 +52,5 @@ void __init reserve_ebda_region(void)
 		lowmem = 0x9f000;
 
 	/* reserve all memory between lowmem and the 1MB mark */
-	memblock_x86_reserve_range(lowmem, 0x100000, "* BIOS reserved");
+	memblock_reserve(lowmem, 0x100000 - lowmem);
 }
diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index 3bb0850..51ff186 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -31,9 +31,8 @@ static void __init i386_default_early_setup(void)
 
 void __init i386_start_kernel(void)
 {
-	memblock_init();
-
-	memblock_x86_reserve_range(__pa_symbol(&_text), __pa_symbol(&__bss_stop), "TEXT DATA BSS");
+	memblock_reserve(__pa_symbol(&_text),
+			 __pa_symbol(&__bss_stop) - __pa_symbol(&_text));
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	/* Reserve INITRD */
@@ -42,7 +41,7 @@ void __init i386_start_kernel(void)
 		u64 ramdisk_image = boot_params.hdr.ramdisk_image;
 		u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
 		u64 ramdisk_end   = PAGE_ALIGN(ramdisk_image + ramdisk_size);
-		memblock_x86_reserve_range(ramdisk_image, ramdisk_end, "RAMDISK");
+		memblock_reserve(ramdisk_image, ramdisk_end - ramdisk_image);
 	}
 #endif
 
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 5655c22..3a3b779 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -98,9 +98,8 @@ void __init x86_64_start_reservations(char *real_mode_data)
 {
 	copy_bootdata(__va(real_mode_data));
 
-	memblock_init();
-
-	memblock_x86_reserve_range(__pa_symbol(&_text), __pa_symbol(&__bss_stop), "TEXT DATA BSS");
+	memblock_reserve(__pa_symbol(&_text),
+			 __pa_symbol(&__bss_stop) - __pa_symbol(&_text));
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	/* Reserve INITRD */
@@ -109,7 +108,7 @@ void __init x86_64_start_reservations(char *real_mode_data)
 		unsigned long ramdisk_image = boot_params.hdr.ramdisk_image;
 		unsigned long ramdisk_size  = boot_params.hdr.ramdisk_size;
 		unsigned long ramdisk_end   = PAGE_ALIGN(ramdisk_image + ramdisk_size);
-		memblock_x86_reserve_range(ramdisk_image, ramdisk_end, "RAMDISK");
+		memblock_reserve(ramdisk_image, ramdisk_end - ramdisk_image);
 	}
 #endif
 
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 0741b062..ca470e4 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -564,9 +564,7 @@ void __init default_get_smp_config(unsigned int early)
 
 static void __init smp_reserve_memory(struct mpf_intel *mpf)
 {
-	unsigned long size = get_mpc_size(mpf->physptr);
-
-	memblock_x86_reserve_range(mpf->physptr, mpf->physptr+size, "* MP-table mpc");
+	memblock_reserve(mpf->physptr, get_mpc_size(mpf->physptr));
 }
 
 static int __init smp_scan_config(unsigned long base, unsigned long length)
@@ -595,7 +593,7 @@ static int __init smp_scan_config(unsigned long base, unsigned long length)
 			       mpf, (u64)virt_to_phys(mpf));
 
 			mem = virt_to_phys(mpf);
-			memblock_x86_reserve_range(mem, mem + sizeof(*mpf), "* MP-table mpf");
+			memblock_reserve(mem, sizeof(*mpf));
 			if (mpf->physptr)
 				smp_reserve_memory(mpf);
 
@@ -836,10 +834,8 @@ early_param("alloc_mptable", parse_alloc_mptable_opt);
 
 void __init early_reserve_e820_mpc_new(void)
 {
-	if (enable_update_mptable && alloc_mptable) {
-		u64 startt = 0;
-		mpc_new_phys = early_reserve_e820(startt, mpc_new_length, 4);
-	}
+	if (enable_update_mptable && alloc_mptable)
+		mpc_new_phys = early_reserve_e820(mpc_new_length, 4);
 }
 
 static int __init update_mp_table(void)
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index cf0ef98..d05444a 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -306,7 +306,8 @@ static void __init cleanup_highmap(void)
 static void __init reserve_brk(void)
 {
 	if (_brk_end > _brk_start)
-		memblock_x86_reserve_range(__pa(_brk_start), __pa(_brk_end), "BRK");
+		memblock_reserve(__pa(_brk_start),
+				 __pa(_brk_end) - __pa(_brk_start));
 
 	/* Mark brk area as locked down and no longer taking any
 	   new allocations */
@@ -331,13 +332,13 @@ static void __init relocate_initrd(void)
 	ramdisk_here = memblock_find_in_range(0, end_of_lowmem, area_size,
 					 PAGE_SIZE);
 
-	if (ramdisk_here == MEMBLOCK_ERROR)
+	if (!ramdisk_here)
 		panic("Cannot find place for new RAMDISK of size %lld\n",
 			 ramdisk_size);
 
 	/* Note: this includes all the lowmem currently occupied by
 	   the initrd, we rely on that fact to keep the data intact. */
-	memblock_x86_reserve_range(ramdisk_here, ramdisk_here + area_size, "NEW RAMDISK");
+	memblock_reserve(ramdisk_here, area_size);
 	initrd_start = ramdisk_here + PAGE_OFFSET;
 	initrd_end   = initrd_start + ramdisk_size;
 	printk(KERN_INFO "Allocated new RAMDISK: %08llx - %08llx\n",
@@ -393,7 +394,7 @@ static void __init reserve_initrd(void)
 	initrd_start = 0;
 
 	if (ramdisk_size >= (end_of_lowmem>>1)) {
-		memblock_x86_free_range(ramdisk_image, ramdisk_end);
+		memblock_free(ramdisk_image, ramdisk_end - ramdisk_image);
 		printk(KERN_ERR "initrd too large to handle, "
 		       "disabling initrd\n");
 		return;
@@ -416,7 +417,7 @@ static void __init reserve_initrd(void)
 
 	relocate_initrd();
 
-	memblock_x86_free_range(ramdisk_image, ramdisk_end);
+	memblock_free(ramdisk_image, ramdisk_end - ramdisk_image);
 }
 #else
 static void __init reserve_initrd(void)
@@ -490,15 +491,13 @@ static void __init memblock_x86_reserve_range_setup_data(void)
 {
 	struct setup_data *data;
 	u64 pa_data;
-	char buf[32];
 
 	if (boot_params.hdr.version < 0x0209)
 		return;
 	pa_data = boot_params.hdr.setup_data;
 	while (pa_data) {
 		data = early_memremap(pa_data, sizeof(*data));
-		sprintf(buf, "setup data %x", data->type);
-		memblock_x86_reserve_range(pa_data, pa_data+sizeof(*data)+data->len, buf);
+		memblock_reserve(pa_data, sizeof(*data) + data->len);
 		pa_data = data->next;
 		early_iounmap(data, sizeof(*data));
 	}
@@ -554,7 +553,7 @@ static void __init reserve_crashkernel(void)
 		crash_base = memblock_find_in_range(alignment,
 			       CRASH_KERNEL_ADDR_MAX, crash_size, alignment);
 
-		if (crash_base == MEMBLOCK_ERROR) {
+		if (!crash_base) {
 			pr_info("crashkernel reservation failed - No suitable area found.\n");
 			return;
 		}
@@ -568,7 +567,7 @@ static void __init reserve_crashkernel(void)
 			return;
 		}
 	}
-	memblock_x86_reserve_range(crash_base, crash_base + crash_size, "CRASH KERNEL");
+	memblock_reserve(crash_base, crash_size);
 
 	printk(KERN_INFO "Reserving %ldMB of memory at %ldMB "
 			"for crashkernel (System RAM: %ldMB)\n",
@@ -626,7 +625,7 @@ static __init void reserve_ibft_region(void)
 	addr = find_ibft_region(&size);
 
 	if (size)
-		memblock_x86_reserve_range(addr, addr + size, "* ibft");
+		memblock_reserve(addr, size);
 }
 
 static unsigned reserve_low = CONFIG_X86_RESERVE_LOW << 10;
diff --git a/arch/x86/kernel/trampoline.c b/arch/x86/kernel/trampoline.c
index a91ae77..a73b610 100644
--- a/arch/x86/kernel/trampoline.c
+++ b/arch/x86/kernel/trampoline.c
@@ -14,11 +14,11 @@ void __init setup_trampolines(void)
 
 	/* Has to be in very low memory so we can execute real-mode AP code. */
 	mem = memblock_find_in_range(0, 1<<20, size, PAGE_SIZE);
-	if (mem == MEMBLOCK_ERROR)
+	if (!mem)
 		panic("Cannot allocate trampoline\n");
 
 	x86_trampoline_base = __va(mem);
-	memblock_x86_reserve_range(mem, mem + size, "TRAMPOLINE");
+	memblock_reserve(mem, size);
 
 	printk(KERN_DEBUG "Base memory trampoline at [%p] %llx size %zu\n",
 	       x86_trampoline_base, (unsigned long long)mem, size);
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 3d11327..23d8e5f 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -27,6 +27,4 @@ obj-$(CONFIG_AMD_NUMA)		+= amdtopology.o
 obj-$(CONFIG_ACPI_NUMA)		+= srat.o
 obj-$(CONFIG_NUMA_EMU)		+= numa_emulation.o
 
-obj-$(CONFIG_HAVE_MEMBLOCK)		+= memblock.o
-
 obj-$(CONFIG_MEMTEST)		+= memtest.o
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 87488b9..a298914 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -67,7 +67,7 @@ static void __init find_early_table_space(unsigned long end, int use_pse,
 	good_end = max_pfn_mapped << PAGE_SHIFT;
 
 	base = memblock_find_in_range(start, good_end, tables, PAGE_SIZE);
-	if (base == MEMBLOCK_ERROR)
+	if (!base)
 		panic("Cannot find space for the kernel page tables");
 
 	pgt_buf_start = base >> PAGE_SHIFT;
@@ -80,7 +80,7 @@ static void __init find_early_table_space(unsigned long end, int use_pse,
 
 void __init native_pagetable_reserve(u64 start, u64 end)
 {
-	memblock_x86_reserve_range(start, end, "PGTABLE");
+	memblock_reserve(start, end - start);
 }
 
 struct map_range {
@@ -279,8 +279,8 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	 * pgt_buf_end) and free the other ones (pgt_buf_end - pgt_buf_top)
 	 * so that they can be reused for other purposes.
 	 *
-	 * On native it just means calling memblock_x86_reserve_range, on Xen it
-	 * also means marking RW the pagetable pages that we allocated before
+	 * On native it just means calling memblock_reserve, on Xen it also
+	 * means marking RW the pagetable pages that we allocated before
 	 * but that haven't been used.
 	 *
 	 * In fact on xen we mark RO the whole range pgt_buf_start -
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 29f7c6d..0c1da39 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -427,23 +427,17 @@ static void __init add_one_highpage_init(struct page *page)
 void __init add_highpages_with_active_regions(int nid,
 			 unsigned long start_pfn, unsigned long end_pfn)
 {
-	struct range *range;
-	int nr_range;
-	int i;
-
-	nr_range = __get_free_all_memory_range(&range, nid, start_pfn, end_pfn);
-
-	for (i = 0; i < nr_range; i++) {
-		struct page *page;
-		int node_pfn;
-
-		for (node_pfn = range[i].start; node_pfn < range[i].end;
-		     node_pfn++) {
-			if (!pfn_valid(node_pfn))
-				continue;
-			page = pfn_to_page(node_pfn);
-			add_one_highpage_init(page);
-		}
+	phys_addr_t start, end;
+	u64 i;
+
+	for_each_free_mem_range(i, nid, &start, &end, NULL) {
+		unsigned long pfn = clamp_t(unsigned long, PFN_UP(start),
+					    start_pfn, end_pfn);
+		unsigned long e_pfn = clamp_t(unsigned long, PFN_DOWN(end),
+					      start_pfn, end_pfn);
+		for ( ; pfn < e_pfn; pfn++)
+			if (pfn_valid(pfn))
+				add_one_highpage_init(pfn_to_page(pfn));
 	}
 }
 #else
@@ -650,18 +644,18 @@ void __init initmem_init(void)
 	highstart_pfn = highend_pfn = max_pfn;
 	if (max_pfn > max_low_pfn)
 		highstart_pfn = max_low_pfn;
-	memblock_x86_register_active_regions(0, 0, highend_pfn);
-	sparse_memory_present_with_active_regions(0);
 	printk(KERN_NOTICE "%ldMB HIGHMEM available.\n",
 		pages_to_mb(highend_pfn - highstart_pfn));
 	num_physpages = highend_pfn;
 	high_memory = (void *) __va(highstart_pfn * PAGE_SIZE - 1) + 1;
 #else
-	memblock_x86_register_active_regions(0, 0, max_low_pfn);
-	sparse_memory_present_with_active_regions(0);
 	num_physpages = max_low_pfn;
 	high_memory = (void *) __va(max_low_pfn * PAGE_SIZE - 1) + 1;
 #endif
+
+	memblock_set_node(0, (phys_addr_t)ULLONG_MAX, 0);
+	sparse_memory_present_with_active_regions(0);
+
 #ifdef CONFIG_FLATMEM
 	max_mapnr = num_physpages;
 #endif
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index bbaaa00..a8a56ce 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -608,7 +608,7 @@ kernel_physical_mapping_init(unsigned long start,
 #ifndef CONFIG_NUMA
 void __init initmem_init(void)
 {
-	memblock_x86_register_active_regions(0, 0, max_pfn);
+	memblock_set_node(0, (phys_addr_t)ULLONG_MAX, 0);
 }
 #endif
 
diff --git a/arch/x86/mm/memblock.c b/arch/x86/mm/memblock.c
deleted file mode 100644
index 992da5e..0000000
--- a/arch/x86/mm/memblock.c
+++ /dev/null
@@ -1,348 +0,0 @@
-#include <linux/kernel.h>
-#include <linux/types.h>
-#include <linux/init.h>
-#include <linux/bitops.h>
-#include <linux/memblock.h>
-#include <linux/bootmem.h>
-#include <linux/mm.h>
-#include <linux/range.h>
-
-/* Check for already reserved areas */
-bool __init memblock_x86_check_reserved_size(u64 *addrp, u64 *sizep, u64 align)
-{
-	struct memblock_region *r;
-	u64 addr = *addrp, last;
-	u64 size = *sizep;
-	bool changed = false;
-
-again:
-	last = addr + size;
-	for_each_memblock(reserved, r) {
-		if (last > r->base && addr < r->base) {
-			size = r->base - addr;
-			changed = true;
-			goto again;
-		}
-		if (last > (r->base + r->size) && addr < (r->base + r->size)) {
-			addr = round_up(r->base + r->size, align);
-			size = last - addr;
-			changed = true;
-			goto again;
-		}
-		if (last <= (r->base + r->size) && addr >= r->base) {
-			*sizep = 0;
-			return false;
-		}
-	}
-	if (changed) {
-		*addrp = addr;
-		*sizep = size;
-	}
-	return changed;
-}
-
-/*
- * Find next free range after start, and size is returned in *sizep
- */
-u64 __init memblock_x86_find_in_range_size(u64 start, u64 *sizep, u64 align)
-{
-	struct memblock_region *r;
-
-	for_each_memblock(memory, r) {
-		u64 ei_start = r->base;
-		u64 ei_last = ei_start + r->size;
-		u64 addr;
-
-		addr = round_up(ei_start, align);
-		if (addr < start)
-			addr = round_up(start, align);
-		if (addr >= ei_last)
-			continue;
-		*sizep = ei_last - addr;
-		while (memblock_x86_check_reserved_size(&addr, sizep, align))
-			;
-
-		if (*sizep)
-			return addr;
-	}
-
-	return MEMBLOCK_ERROR;
-}
-
-static __init struct range *find_range_array(int count)
-{
-	u64 end, size, mem;
-	struct range *range;
-
-	size = sizeof(struct range) * count;
-	end = memblock.current_limit;
-
-	mem = memblock_find_in_range(0, end, size, sizeof(struct range));
-	if (mem == MEMBLOCK_ERROR)
-		panic("can not find more space for range array");
-
-	/*
-	 * This range is tempoaray, so don't reserve it, it will not be
-	 * overlapped because We will not alloccate new buffer before
-	 * We discard this one
-	 */
-	range = __va(mem);
-	memset(range, 0, size);
-
-	return range;
-}
-
-static void __init memblock_x86_subtract_reserved(struct range *range, int az)
-{
-	u64 final_start, final_end;
-	struct memblock_region *r;
-
-	/* Take out region array itself at first*/
-	memblock_free_reserved_regions();
-
-	memblock_dbg("Subtract (%ld early reservations)\n", memblock.reserved.cnt);
-
-	for_each_memblock(reserved, r) {
-		memblock_dbg("  [%010llx-%010llx]\n", (u64)r->base, (u64)r->base + r->size - 1);
-		final_start = PFN_DOWN(r->base);
-		final_end = PFN_UP(r->base + r->size);
-		if (final_start >= final_end)
-			continue;
-		subtract_range(range, az, final_start, final_end);
-	}
-
-	/* Put region array back ? */
-	memblock_reserve_reserved_regions();
-}
-
-struct count_data {
-	int nr;
-};
-
-static int __init count_work_fn(unsigned long start_pfn,
-				unsigned long end_pfn, void *datax)
-{
-	struct count_data *data = datax;
-
-	data->nr++;
-
-	return 0;
-}
-
-static int __init count_early_node_map(int nodeid)
-{
-	struct count_data data;
-
-	data.nr = 0;
-	work_with_active_regions(nodeid, count_work_fn, &data);
-
-	return data.nr;
-}
-
-int __init __get_free_all_memory_range(struct range **rangep, int nodeid,
-			 unsigned long start_pfn, unsigned long end_pfn)
-{
-	int count;
-	struct range *range;
-	int nr_range;
-
-	count = (memblock.reserved.cnt + count_early_node_map(nodeid)) * 2;
-
-	range = find_range_array(count);
-	nr_range = 0;
-
-	/*
-	 * Use early_node_map[] and memblock.reserved.region to get range array
-	 * at first
-	 */
-	nr_range = add_from_early_node_map(range, count, nr_range, nodeid);
-	subtract_range(range, count, 0, start_pfn);
-	subtract_range(range, count, end_pfn, -1ULL);
-
-	memblock_x86_subtract_reserved(range, count);
-	nr_range = clean_sort_range(range, count);
-
-	*rangep = range;
-	return nr_range;
-}
-
-int __init get_free_all_memory_range(struct range **rangep, int nodeid)
-{
-	unsigned long end_pfn = -1UL;
-
-#ifdef CONFIG_X86_32
-	end_pfn = max_low_pfn;
-#endif
-	return __get_free_all_memory_range(rangep, nodeid, 0, end_pfn);
-}
-
-static u64 __init __memblock_x86_memory_in_range(u64 addr, u64 limit, bool get_free)
-{
-	int i, count;
-	struct range *range;
-	int nr_range;
-	u64 final_start, final_end;
-	u64 free_size;
-	struct memblock_region *r;
-
-	count = (memblock.reserved.cnt + memblock.memory.cnt) * 2;
-
-	range = find_range_array(count);
-	nr_range = 0;
-
-	addr = PFN_UP(addr);
-	limit = PFN_DOWN(limit);
-
-	for_each_memblock(memory, r) {
-		final_start = PFN_UP(r->base);
-		final_end = PFN_DOWN(r->base + r->size);
-		if (final_start >= final_end)
-			continue;
-		if (final_start >= limit || final_end <= addr)
-			continue;
-
-		nr_range = add_range(range, count, nr_range, final_start, final_end);
-	}
-	subtract_range(range, count, 0, addr);
-	subtract_range(range, count, limit, -1ULL);
-
-	/* Subtract memblock.reserved.region in range ? */
-	if (!get_free)
-		goto sort_and_count_them;
-	for_each_memblock(reserved, r) {
-		final_start = PFN_DOWN(r->base);
-		final_end = PFN_UP(r->base + r->size);
-		if (final_start >= final_end)
-			continue;
-		if (final_start >= limit || final_end <= addr)
-			continue;
-
-		subtract_range(range, count, final_start, final_end);
-	}
-
-sort_and_count_them:
-	nr_range = clean_sort_range(range, count);
-
-	free_size = 0;
-	for (i = 0; i < nr_range; i++)
-		free_size += range[i].end - range[i].start;
-
-	return free_size << PAGE_SHIFT;
-}
-
-u64 __init memblock_x86_free_memory_in_range(u64 addr, u64 limit)
-{
-	return __memblock_x86_memory_in_range(addr, limit, true);
-}
-
-u64 __init memblock_x86_memory_in_range(u64 addr, u64 limit)
-{
-	return __memblock_x86_memory_in_range(addr, limit, false);
-}
-
-void __init memblock_x86_reserve_range(u64 start, u64 end, char *name)
-{
-	if (start == end)
-		return;
-
-	if (WARN_ONCE(start > end, "memblock_x86_reserve_range: wrong range [%#llx, %#llx)\n", start, end))
-		return;
-
-	memblock_dbg("    memblock_x86_reserve_range: [%#010llx-%#010llx] %16s\n", start, end - 1, name);
-
-	memblock_reserve(start, end - start);
-}
-
-void __init memblock_x86_free_range(u64 start, u64 end)
-{
-	if (start == end)
-		return;
-
-	if (WARN_ONCE(start > end, "memblock_x86_free_range: wrong range [%#llx, %#llx)\n", start, end))
-		return;
-
-	memblock_dbg("       memblock_x86_free_range: [%#010llx-%#010llx]\n", start, end - 1);
-
-	memblock_free(start, end - start);
-}
-
-/*
- * Need to call this function after memblock_x86_register_active_regions,
- * so early_node_map[] is filled already.
- */
-u64 __init memblock_x86_find_in_range_node(int nid, u64 start, u64 end, u64 size, u64 align)
-{
-	u64 addr;
-	addr = find_memory_core_early(nid, size, align, start, end);
-	if (addr != MEMBLOCK_ERROR)
-		return addr;
-
-	/* Fallback, should already have start end within node range */
-	return memblock_find_in_range(start, end, size, align);
-}
-
-/*
- * Finds an active region in the address range from start_pfn to last_pfn and
- * returns its range in ei_startpfn and ei_endpfn for the memblock entry.
- */
-static int __init memblock_x86_find_active_region(const struct memblock_region *ei,
-				  unsigned long start_pfn,
-				  unsigned long last_pfn,
-				  unsigned long *ei_startpfn,
-				  unsigned long *ei_endpfn)
-{
-	u64 align = PAGE_SIZE;
-
-	*ei_startpfn = round_up(ei->base, align) >> PAGE_SHIFT;
-	*ei_endpfn = round_down(ei->base + ei->size, align) >> PAGE_SHIFT;
-
-	/* Skip map entries smaller than a page */
-	if (*ei_startpfn >= *ei_endpfn)
-		return 0;
-
-	/* Skip if map is outside the node */
-	if (*ei_endpfn <= start_pfn || *ei_startpfn >= last_pfn)
-		return 0;
-
-	/* Check for overlaps */
-	if (*ei_startpfn < start_pfn)
-		*ei_startpfn = start_pfn;
-	if (*ei_endpfn > last_pfn)
-		*ei_endpfn = last_pfn;
-
-	return 1;
-}
-
-/* Walk the memblock.memory map and register active regions within a node */
-void __init memblock_x86_register_active_regions(int nid, unsigned long start_pfn,
-					 unsigned long last_pfn)
-{
-	unsigned long ei_startpfn;
-	unsigned long ei_endpfn;
-	struct memblock_region *r;
-
-	for_each_memblock(memory, r)
-		if (memblock_x86_find_active_region(r, start_pfn, last_pfn,
-					   &ei_startpfn, &ei_endpfn))
-			add_active_range(nid, ei_startpfn, ei_endpfn);
-}
-
-/*
- * Find the hole size (in bytes) in the memory range.
- * @start: starting address of the memory range to scan
- * @end: ending address of the memory range to scan
- */
-u64 __init memblock_x86_hole_size(u64 start, u64 end)
-{
-	unsigned long start_pfn = start >> PAGE_SHIFT;
-	unsigned long last_pfn = end >> PAGE_SHIFT;
-	unsigned long ei_startpfn, ei_endpfn, ram = 0;
-	struct memblock_region *r;
-
-	for_each_memblock(memory, r)
-		if (memblock_x86_find_active_region(r, start_pfn, last_pfn,
-					   &ei_startpfn, &ei_endpfn))
-			ram += ei_endpfn - ei_startpfn;
-
-	return end - start - ((u64)ram << PAGE_SHIFT);
-}
diff --git a/arch/x86/mm/memtest.c b/arch/x86/mm/memtest.c
index 92faf3a..c80b9fb 100644
--- a/arch/x86/mm/memtest.c
+++ b/arch/x86/mm/memtest.c
@@ -34,7 +34,7 @@ static void __init reserve_bad_mem(u64 pattern, u64 start_bad, u64 end_bad)
 	       (unsigned long long) pattern,
 	       (unsigned long long) start_bad,
 	       (unsigned long long) end_bad);
-	memblock_x86_reserve_range(start_bad, end_bad, "BAD RAM");
+	memblock_reserve(start_bad, end_bad - start_bad);
 }
 
 static void __init memtest(u64 pattern, u64 start_phys, u64 size)
@@ -70,24 +70,19 @@ static void __init memtest(u64 pattern, u64 start_phys, u64 size)
 
 static void __init do_one_pass(u64 pattern, u64 start, u64 end)
 {
-	u64 size = 0;
-
-	while (start < end) {
-		start = memblock_x86_find_in_range_size(start, &size, 1);
-
-		/* done ? */
-		if (start >= end)
-			break;
-		if (start + size > end)
-			size = end - start;
-
-		printk(KERN_INFO "  %010llx - %010llx pattern %016llx\n",
-		       (unsigned long long) start,
-		       (unsigned long long) start + size,
-		       (unsigned long long) cpu_to_be64(pattern));
-		memtest(pattern, start, size);
-
-		start += size;
+	u64 i;
+	phys_addr_t this_start, this_end;
+
+	for_each_free_mem_range(i, MAX_NUMNODES, &this_start, &this_end, NULL) {
+		this_start = clamp_t(phys_addr_t, this_start, start, end);
+		this_end = clamp_t(phys_addr_t, this_end, start, end);
+		if (this_start < this_end) {
+			printk(KERN_INFO "  %010llx - %010llx pattern %016llx\n",
+			       (unsigned long long)this_start,
+			       (unsigned long long)this_end,
+			       (unsigned long long)cpu_to_be64(pattern));
+			memtest(pattern, this_start, this_end - this_start);
+		}
 	}
 }
 
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index fbeaaf4..496f494 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -192,8 +192,6 @@ int __init numa_add_memblk(int nid, u64 start, u64 end)
 /* Initialize NODE_DATA for a node on the local memory */
 static void __init setup_node_data(int nid, u64 start, u64 end)
 {
-	const u64 nd_low = PFN_PHYS(MAX_DMA_PFN);
-	const u64 nd_high = PFN_PHYS(max_pfn_mapped);
 	const size_t nd_size = roundup(sizeof(pg_data_t), PAGE_SIZE);
 	bool remapped = false;
 	u64 nd_pa;
@@ -224,17 +222,12 @@ static void __init setup_node_data(int nid, u64 start, u64 end)
 		nd_pa = __pa(nd);
 		remapped = true;
 	} else {
-		nd_pa = memblock_x86_find_in_range_node(nid, nd_low, nd_high,
-						nd_size, SMP_CACHE_BYTES);
-		if (nd_pa == MEMBLOCK_ERROR)
-			nd_pa = memblock_find_in_range(nd_low, nd_high,
-						nd_size, SMP_CACHE_BYTES);
-		if (nd_pa == MEMBLOCK_ERROR) {
+		nd_pa = memblock_alloc_nid(nd_size, SMP_CACHE_BYTES, nid);
+		if (!nd_pa) {
 			pr_err("Cannot find %zu bytes in node %d\n",
 			       nd_size, nid);
 			return;
 		}
-		memblock_x86_reserve_range(nd_pa, nd_pa + nd_size, "NODE_DATA");
 		nd = __va(nd_pa);
 	}
 
@@ -371,8 +364,7 @@ void __init numa_reset_distance(void)
 
 	/* numa_distance could be 1LU marking allocation failure, test cnt */
 	if (numa_distance_cnt)
-		memblock_x86_free_range(__pa(numa_distance),
-					__pa(numa_distance) + size);
+		memblock_free(__pa(numa_distance), size);
 	numa_distance_cnt = 0;
 	numa_distance = NULL;	/* enable table creation */
 }
@@ -395,13 +387,13 @@ static int __init numa_alloc_distance(void)
 
 	phys = memblock_find_in_range(0, PFN_PHYS(max_pfn_mapped),
 				      size, PAGE_SIZE);
-	if (phys == MEMBLOCK_ERROR) {
+	if (!phys) {
 		pr_warning("NUMA: Warning: can't allocate distance table!\n");
 		/* don't retry until explicitly reset */
 		numa_distance = (void *)1LU;
 		return -ENOMEM;
 	}
-	memblock_x86_reserve_range(phys, phys + size, "NUMA DIST");
+	memblock_reserve(phys, size);
 
 	numa_distance = __va(phys);
 	numa_distance_cnt = cnt;
@@ -482,8 +474,8 @@ static bool __init numa_meminfo_cover_memory(const struct numa_meminfo *mi)
 			numaram = 0;
 	}
 
-	e820ram = max_pfn - (memblock_x86_hole_size(0,
-					PFN_PHYS(max_pfn)) >> PAGE_SHIFT);
+	e820ram = max_pfn - absent_pages_in_range(0, max_pfn);
+
 	/* We seem to lose 3 pages somewhere. Allow 1M of slack. */
 	if ((s64)(e820ram - numaram) >= (1 << (20 - PAGE_SHIFT))) {
 		printk(KERN_ERR "NUMA: nodes only cover %LuMB of your %LuMB e820 RAM. Not used.\n",
@@ -505,13 +497,10 @@ static int __init numa_register_memblks(struct numa_meminfo *mi)
 	if (WARN_ON(nodes_empty(node_possible_map)))
 		return -EINVAL;
 
-	for (i = 0; i < mi->nr_blks; i++)
-		memblock_x86_register_active_regions(mi->blk[i].nid,
-					mi->blk[i].start >> PAGE_SHIFT,
-					mi->blk[i].end >> PAGE_SHIFT);
-
-	/* for out of order entries */
-	sort_node_map();
+	for (i = 0; i < mi->nr_blks; i++) {
+		struct numa_memblk *mb = &mi->blk[i];
+		memblock_set_node(mb->start, mb->end - mb->start, mb->nid);
+	}
 
 	/*
 	 * If sections array is gonna be used for pfn -> nid mapping, check
@@ -545,6 +534,8 @@ static int __init numa_register_memblks(struct numa_meminfo *mi)
 			setup_node_data(nid, start, end);
 	}
 
+	/* Dump memblock with node info and return. */
+	memblock_dump_all();
 	return 0;
 }
 
@@ -582,7 +573,7 @@ static int __init numa_init(int (*init_func)(void))
 	nodes_clear(node_possible_map);
 	nodes_clear(node_online_map);
 	memset(&numa_meminfo, 0, sizeof(numa_meminfo));
-	remove_all_active_ranges();
+	WARN_ON(memblock_set_node(0, ULLONG_MAX, MAX_NUMNODES));
 	numa_reset_distance();
 
 	ret = init_func();
diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index 3adebe7..534255a 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -199,23 +199,23 @@ void __init init_alloc_remap(int nid, u64 start, u64 end)
 
 	/* allocate node memory and the lowmem remap area */
 	node_pa = memblock_find_in_range(start, end, size, LARGE_PAGE_BYTES);
-	if (node_pa == MEMBLOCK_ERROR) {
+	if (!node_pa) {
 		pr_warning("remap_alloc: failed to allocate %lu bytes for node %d\n",
 			   size, nid);
 		return;
 	}
-	memblock_x86_reserve_range(node_pa, node_pa + size, "KVA RAM");
+	memblock_reserve(node_pa, size);
 
 	remap_pa = memblock_find_in_range(min_low_pfn << PAGE_SHIFT,
 					  max_low_pfn << PAGE_SHIFT,
 					  size, LARGE_PAGE_BYTES);
-	if (remap_pa == MEMBLOCK_ERROR) {
+	if (!remap_pa) {
 		pr_warning("remap_alloc: failed to allocate %lu bytes remap area for node %d\n",
 			   size, nid);
-		memblock_x86_free_range(node_pa, node_pa + size);
+		memblock_free(node_pa, size);
 		return;
 	}
-	memblock_x86_reserve_range(remap_pa, remap_pa + size, "KVA PG");
+	memblock_reserve(remap_pa, size);
 	remap_va = phys_to_virt(remap_pa);
 
 	/* perform actual remap */
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index dd27f40..92e2711 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -19,7 +19,7 @@ unsigned long __init numa_free_all_bootmem(void)
 	for_each_online_node(i)
 		pages += free_all_bootmem_node(NODE_DATA(i));
 
-	pages += free_all_memory_core_early(MAX_NUMNODES);
+	pages += free_low_memory_core_early(MAX_NUMNODES);
 
 	return pages;
 }
diff --git a/arch/x86/mm/numa_emulation.c b/arch/x86/mm/numa_emulation.c
index d0ed086..46db568 100644
--- a/arch/x86/mm/numa_emulation.c
+++ b/arch/x86/mm/numa_emulation.c
@@ -28,6 +28,16 @@ static int __init emu_find_memblk_by_nid(int nid, const struct numa_meminfo *mi)
 	return -ENOENT;
 }
 
+static u64 mem_hole_size(u64 start, u64 end)
+{
+	unsigned long start_pfn = PFN_UP(start);
+	unsigned long end_pfn = PFN_DOWN(end);
+
+	if (start_pfn < end_pfn)
+		return PFN_PHYS(absent_pages_in_range(start_pfn, end_pfn));
+	return 0;
+}
+
 /*
  * Sets up nid to range from @start to @end.  The return value is -errno if
  * something went wrong, 0 otherwise.
@@ -89,7 +99,7 @@ static int __init split_nodes_interleave(struct numa_meminfo *ei,
 	 * Calculate target node size.  x86_32 freaks on __udivdi3() so do
 	 * the division in ulong number of pages and convert back.
 	 */
-	size = max_addr - addr - memblock_x86_hole_size(addr, max_addr);
+	size = max_addr - addr - mem_hole_size(addr, max_addr);
 	size = PFN_PHYS((unsigned long)(size >> PAGE_SHIFT) / nr_nodes);
 
 	/*
@@ -135,8 +145,7 @@ static int __init split_nodes_interleave(struct numa_meminfo *ei,
 			 * Continue to add memory to this fake node if its
 			 * non-reserved memory is less than the per-node size.
 			 */
-			while (end - start -
-			       memblock_x86_hole_size(start, end) < size) {
+			while (end - start - mem_hole_size(start, end) < size) {
 				end += FAKE_NODE_MIN_SIZE;
 				if (end > limit) {
 					end = limit;
@@ -150,7 +159,7 @@ static int __init split_nodes_interleave(struct numa_meminfo *ei,
 			 * this one must extend to the boundary.
 			 */
 			if (end < dma32_end && dma32_end - end -
-			    memblock_x86_hole_size(end, dma32_end) < FAKE_NODE_MIN_SIZE)
+			    mem_hole_size(end, dma32_end) < FAKE_NODE_MIN_SIZE)
 				end = dma32_end;
 
 			/*
@@ -158,8 +167,7 @@ static int __init split_nodes_interleave(struct numa_meminfo *ei,
 			 * next node, this one must extend to the end of the
 			 * physical node.
 			 */
-			if (limit - end -
-			    memblock_x86_hole_size(end, limit) < size)
+			if (limit - end - mem_hole_size(end, limit) < size)
 				end = limit;
 
 			ret = emu_setup_memblk(ei, pi, nid++ % nr_nodes,
@@ -180,7 +188,7 @@ static u64 __init find_end_of_node(u64 start, u64 max_addr, u64 size)
 {
 	u64 end = start + size;
 
-	while (end - start - memblock_x86_hole_size(start, end) < size) {
+	while (end - start - mem_hole_size(start, end) < size) {
 		end += FAKE_NODE_MIN_SIZE;
 		if (end > max_addr) {
 			end = max_addr;
@@ -211,8 +219,7 @@ static int __init split_nodes_size_interleave(struct numa_meminfo *ei,
 	 * creates a uniform distribution of node sizes across the entire
 	 * machine (but not necessarily over physical nodes).
 	 */
-	min_size = (max_addr - addr - memblock_x86_hole_size(addr, max_addr)) /
-						MAX_NUMNODES;
+	min_size = (max_addr - addr - mem_hole_size(addr, max_addr)) / MAX_NUMNODES;
 	min_size = max(min_size, FAKE_NODE_MIN_SIZE);
 	if ((min_size & FAKE_NODE_MIN_HASH_MASK) < min_size)
 		min_size = (min_size + FAKE_NODE_MIN_SIZE) &
@@ -252,7 +259,7 @@ static int __init split_nodes_size_interleave(struct numa_meminfo *ei,
 			 * this one must extend to the boundary.
 			 */
 			if (end < dma32_end && dma32_end - end -
-			    memblock_x86_hole_size(end, dma32_end) < FAKE_NODE_MIN_SIZE)
+			    mem_hole_size(end, dma32_end) < FAKE_NODE_MIN_SIZE)
 				end = dma32_end;
 
 			/*
@@ -260,8 +267,7 @@ static int __init split_nodes_size_interleave(struct numa_meminfo *ei,
 			 * next node, this one must extend to the end of the
 			 * physical node.
 			 */
-			if (limit - end -
-			    memblock_x86_hole_size(end, limit) < size)
+			if (limit - end - mem_hole_size(end, limit) < size)
 				end = limit;
 
 			ret = emu_setup_memblk(ei, pi, nid++ % MAX_NUMNODES,
@@ -351,11 +357,11 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
 
 		phys = memblock_find_in_range(0, PFN_PHYS(max_pfn_mapped),
 					      phys_size, PAGE_SIZE);
-		if (phys == MEMBLOCK_ERROR) {
+		if (!phys) {
 			pr_warning("NUMA: Warning: can't allocate copy of distance table, disabling emulation\n");
 			goto no_emu;
 		}
-		memblock_x86_reserve_range(phys, phys + phys_size, "TMP NUMA DIST");
+		memblock_reserve(phys, phys_size);
 		phys_dist = __va(phys);
 
 		for (i = 0; i < numa_dist_cnt; i++)
@@ -424,7 +430,7 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
 
 	/* free the copied physical distance table */
 	if (phys_dist)
-		memblock_x86_free_range(__pa(phys_dist), __pa(phys_dist) + phys_size);
+		memblock_free(__pa(phys_dist), phys_size);
 	return;
 
 no_emu:
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 37718f0..4a01967 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -352,8 +352,7 @@ void __init efi_memblock_x86_reserve_range(void)
 		boot_params.efi_info.efi_memdesc_size;
 	memmap.desc_version = boot_params.efi_info.efi_memdesc_version;
 	memmap.desc_size = boot_params.efi_info.efi_memdesc_size;
-	memblock_x86_reserve_range(pmap, pmap + memmap.nr_map * memmap.desc_size,
-		      "EFI memmap");
+	memblock_reserve(pmap, memmap.nr_map * memmap.desc_size);
 }
 
 #if EFI_DEBUG
@@ -397,16 +396,14 @@ void __init efi_reserve_boot_services(void)
 		if ((start+size >= virt_to_phys(_text)
 				&& start <= virt_to_phys(_end)) ||
 			!e820_all_mapped(start, start+size, E820_RAM) ||
-			memblock_x86_check_reserved_size(&start, &size,
-							1<<EFI_PAGE_SHIFT)) {
+			memblock_is_region_reserved(start, size)) {
 			/* Could not reserve, skip it */
 			md->num_pages = 0;
 			memblock_dbg(PFX "Could not reserve boot range "
 					"[0x%010llx-0x%010llx]\n",
 						start, start+size-1);
 		} else
-			memblock_x86_reserve_range(start, start+size,
-							"EFI Boot");
+			memblock_reserve(start, size);
 	}
 }
 
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 1f92865..12eb07b 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1215,8 +1215,6 @@ asmlinkage void __init xen_start_kernel(void)
 	local_irq_disable();
 	early_boot_irqs_disabled = true;
 
-	memblock_init();
-
 	xen_raw_console_write("mapping kernel into physical memory\n");
 	pgd = xen_setup_kernel_pagetable(pgd, xen_start_info->nr_pages);
 	xen_ident_map_ISA();
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 87f6673..f4bf8aa 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1774,10 +1774,8 @@ pgd_t * __init xen_setup_kernel_pagetable(pgd_t *pgd,
 	__xen_write_cr3(true, __pa(pgd));
 	xen_mc_issue(PARAVIRT_LAZY_CPU);
 
-	memblock_x86_reserve_range(__pa(xen_start_info->pt_base),
-		      __pa(xen_start_info->pt_base +
-			   xen_start_info->nr_pt_frames * PAGE_SIZE),
-		      "XEN PAGETABLES");
+	memblock_reserve(__pa(xen_start_info->pt_base),
+			 xen_start_info->nr_pt_frames * PAGE_SIZE);
 
 	return pgd;
 }
@@ -1853,10 +1851,8 @@ pgd_t * __init xen_setup_kernel_pagetable(pgd_t *pgd,
 			  PFN_DOWN(__pa(initial_page_table)));
 	xen_write_cr3(__pa(initial_page_table));
 
-	memblock_x86_reserve_range(__pa(xen_start_info->pt_base),
-		      __pa(xen_start_info->pt_base +
-			   xen_start_info->nr_pt_frames * PAGE_SIZE),
-		      "XEN PAGETABLES");
+	memblock_reserve(__pa(xen_start_info->pt_base),
+			 xen_start_info->nr_pt_frames * PAGE_SIZE));
 
 	return initial_page_table;
 }
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index b2c7179..e03c636 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -75,7 +75,7 @@ static void __init xen_add_extra_mem(u64 start, u64 size)
 	if (i == XEN_EXTRA_MEM_MAX_REGIONS)
 		printk(KERN_WARNING "Warning: not enough extra memory regions\n");
 
-	memblock_x86_reserve_range(start, start + size, "XEN EXTRA");
+	memblock_reserve(start, size);
 
 	xen_max_p2m_pfn = PFN_DOWN(start + size);
 
@@ -311,9 +311,8 @@ char * __init xen_memory_setup(void)
 	 *  - xen_start_info
 	 * See comment above "struct start_info" in <xen/interface/xen.h>
 	 */
-	memblock_x86_reserve_range(__pa(xen_start_info->mfn_list),
-		      __pa(xen_start_info->pt_base),
-			"XEN START INFO");
+	memblock_reserve(__pa(xen_start_info->mfn_list),
+			 xen_start_info->pt_base - xen_start_info->mfn_list);
 
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
 
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index bdc447f..31053a9 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -41,6 +41,7 @@
 #include <linux/tboot.h>
 #include <linux/dmi.h>
 #include <linux/pci-ats.h>
+#include <linux/memblock.h>
 #include <asm/cacheflush.h>
 #include <asm/iommu.h>
 
@@ -2188,18 +2189,6 @@ static inline void iommu_prepare_isa(void)
 
 static int md_domain_init(struct dmar_domain *domain, int guest_width);
 
-static int __init si_domain_work_fn(unsigned long start_pfn,
-				    unsigned long end_pfn, void *datax)
-{
-	int *ret = datax;
-
-	*ret = iommu_domain_identity_map(si_domain,
-					 (uint64_t)start_pfn << PAGE_SHIFT,
-					 (uint64_t)end_pfn << PAGE_SHIFT);
-	return *ret;
-
-}
-
 static int __init si_domain_init(int hw)
 {
 	struct dmar_drhd_unit *drhd;
@@ -2231,9 +2220,15 @@ static int __init si_domain_init(int hw)
 		return 0;
 
 	for_each_online_node(nid) {
-		work_with_active_regions(nid, si_domain_work_fn, &ret);
-		if (ret)
-			return ret;
+		unsigned long start_pfn, end_pfn;
+		int i;
+
+		for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
+			ret = iommu_domain_identity_map(si_domain,
+					PFN_PHYS(start_pfn), PFN_PHYS(end_pfn));
+			if (ret)
+				return ret;
+		}
 	}
 
 	return 0;
diff --git a/include/linux/bootmem.h b/include/linux/bootmem.h
index ab344a5..66d3e95 100644
--- a/include/linux/bootmem.h
+++ b/include/linux/bootmem.h
@@ -44,7 +44,7 @@ extern unsigned long init_bootmem_node(pg_data_t *pgdat,
 				       unsigned long endpfn);
 extern unsigned long init_bootmem(unsigned long addr, unsigned long memend);
 
-unsigned long free_all_memory_core_early(int nodeid);
+extern unsigned long free_low_memory_core_early(int nodeid);
 extern unsigned long free_all_bootmem_node(pg_data_t *pgdat);
 extern unsigned long free_all_bootmem(void);
 
diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index e6b843e..a6bb102 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -2,8 +2,6 @@
 #define _LINUX_MEMBLOCK_H
 #ifdef __KERNEL__
 
-#define MEMBLOCK_ERROR	0
-
 #ifdef CONFIG_HAVE_MEMBLOCK
 /*
  * Logical memory blocks.
@@ -19,81 +17,161 @@
 #include <linux/init.h>
 #include <linux/mm.h>
 
-#include <asm/memblock.h>
-
 #define INIT_MEMBLOCK_REGIONS	128
 
 struct memblock_region {
 	phys_addr_t base;
 	phys_addr_t size;
+#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
+	int nid;
+#endif
 };
 
 struct memblock_type {
 	unsigned long cnt;	/* number of regions */
 	unsigned long max;	/* size of the allocated array */
+	phys_addr_t total_size;	/* size of all regions */
 	struct memblock_region *regions;
 };
 
 struct memblock {
 	phys_addr_t current_limit;
-	phys_addr_t memory_size;	/* Updated by memblock_analyze() */
 	struct memblock_type memory;
 	struct memblock_type reserved;
 };
 
 extern struct memblock memblock;
 extern int memblock_debug;
-extern int memblock_can_resize;
 
 #define memblock_dbg(fmt, ...) \
 	if (memblock_debug) printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
 
-u64 memblock_find_in_range(u64 start, u64 end, u64 size, u64 align);
+phys_addr_t memblock_find_in_range_node(phys_addr_t start, phys_addr_t end,
+				phys_addr_t size, phys_addr_t align, int nid);
+phys_addr_t memblock_find_in_range(phys_addr_t start, phys_addr_t end,
+				   phys_addr_t size, phys_addr_t align);
 int memblock_free_reserved_regions(void);
 int memblock_reserve_reserved_regions(void);
 
-extern void memblock_init(void);
-extern void memblock_analyze(void);
-extern long memblock_add(phys_addr_t base, phys_addr_t size);
-extern long memblock_remove(phys_addr_t base, phys_addr_t size);
-extern long memblock_free(phys_addr_t base, phys_addr_t size);
-extern long memblock_reserve(phys_addr_t base, phys_addr_t size);
+void memblock_allow_resize(void);
+int memblock_add_node(phys_addr_t base, phys_addr_t size, int nid);
+int memblock_add(phys_addr_t base, phys_addr_t size);
+int memblock_remove(phys_addr_t base, phys_addr_t size);
+int memblock_free(phys_addr_t base, phys_addr_t size);
+int memblock_reserve(phys_addr_t base, phys_addr_t size);
+
+#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
+void __next_mem_pfn_range(int *idx, int nid, unsigned long *out_start_pfn,
+			  unsigned long *out_end_pfn, int *out_nid);
+
+/**
+ * for_each_mem_pfn_range - early memory pfn range iterator
+ * @i: an integer used as loop variable
+ * @nid: node selector, %MAX_NUMNODES for all nodes
+ * @p_start: ptr to ulong for start pfn of the range, can be %NULL
+ * @p_end: ptr to ulong for end pfn of the range, can be %NULL
+ * @p_nid: ptr to int for nid of the range, can be %NULL
+ *
+ * Walks over configured memory ranges.  Available after early_node_map is
+ * populated.
+ */
+#define for_each_mem_pfn_range(i, nid, p_start, p_end, p_nid)		\
+	for (i = -1, __next_mem_pfn_range(&i, nid, p_start, p_end, p_nid); \
+	     i >= 0; __next_mem_pfn_range(&i, nid, p_start, p_end, p_nid))
+#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
+
+void __next_free_mem_range(u64 *idx, int nid, phys_addr_t *out_start,
+			   phys_addr_t *out_end, int *out_nid);
+
+/**
+ * for_each_free_mem_range - iterate through free memblock areas
+ * @i: u64 used as loop variable
+ * @nid: node selector, %MAX_NUMNODES for all nodes
+ * @p_start: ptr to phys_addr_t for start address of the range, can be %NULL
+ * @p_end: ptr to phys_addr_t for end address of the range, can be %NULL
+ * @p_nid: ptr to int for nid of the range, can be %NULL
+ *
+ * Walks over free (memory && !reserved) areas of memblock.  Available as
+ * soon as memblock is initialized.
+ */
+#define for_each_free_mem_range(i, nid, p_start, p_end, p_nid)		\
+	for (i = 0,							\
+	     __next_free_mem_range(&i, nid, p_start, p_end, p_nid);	\
+	     i != (u64)ULLONG_MAX;					\
+	     __next_free_mem_range(&i, nid, p_start, p_end, p_nid))
+
+void __next_free_mem_range_rev(u64 *idx, int nid, phys_addr_t *out_start,
+			       phys_addr_t *out_end, int *out_nid);
 
-/* The numa aware allocator is only available if
- * CONFIG_ARCH_POPULATES_NODE_MAP is set
+/**
+ * for_each_free_mem_range_reverse - rev-iterate through free memblock areas
+ * @i: u64 used as loop variable
+ * @nid: node selector, %MAX_NUMNODES for all nodes
+ * @p_start: ptr to phys_addr_t for start address of the range, can be %NULL
+ * @p_end: ptr to phys_addr_t for end address of the range, can be %NULL
+ * @p_nid: ptr to int for nid of the range, can be %NULL
+ *
+ * Walks over free (memory && !reserved) areas of memblock in reverse
+ * order.  Available as soon as memblock is initialized.
  */
-extern phys_addr_t memblock_alloc_nid(phys_addr_t size, phys_addr_t align,
-					int nid);
-extern phys_addr_t memblock_alloc_try_nid(phys_addr_t size, phys_addr_t align,
-					    int nid);
+#define for_each_free_mem_range_reverse(i, nid, p_start, p_end, p_nid)	\
+	for (i = (u64)ULLONG_MAX,					\
+	     __next_free_mem_range_rev(&i, nid, p_start, p_end, p_nid);	\
+	     i != (u64)ULLONG_MAX;					\
+	     __next_free_mem_range_rev(&i, nid, p_start, p_end, p_nid))
 
-extern phys_addr_t memblock_alloc(phys_addr_t size, phys_addr_t align);
+#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
+int memblock_set_node(phys_addr_t base, phys_addr_t size, int nid);
+
+static inline void memblock_set_region_node(struct memblock_region *r, int nid)
+{
+	r->nid = nid;
+}
+
+static inline int memblock_get_region_node(const struct memblock_region *r)
+{
+	return r->nid;
+}
+#else
+static inline void memblock_set_region_node(struct memblock_region *r, int nid)
+{
+}
+
+static inline int memblock_get_region_node(const struct memblock_region *r)
+{
+	return 0;
+}
+#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
+
+phys_addr_t memblock_alloc_nid(phys_addr_t size, phys_addr_t align, int nid);
+phys_addr_t memblock_alloc_try_nid(phys_addr_t size, phys_addr_t align, int nid);
+
+phys_addr_t memblock_alloc(phys_addr_t size, phys_addr_t align);
 
 /* Flags for memblock_alloc_base() amd __memblock_alloc_base() */
 #define MEMBLOCK_ALLOC_ANYWHERE	(~(phys_addr_t)0)
 #define MEMBLOCK_ALLOC_ACCESSIBLE	0
 
-extern phys_addr_t memblock_alloc_base(phys_addr_t size,
-					 phys_addr_t align,
-					 phys_addr_t max_addr);
-extern phys_addr_t __memblock_alloc_base(phys_addr_t size,
-					   phys_addr_t align,
-					   phys_addr_t max_addr);
-extern phys_addr_t memblock_phys_mem_size(void);
-extern phys_addr_t memblock_start_of_DRAM(void);
-extern phys_addr_t memblock_end_of_DRAM(void);
-extern void memblock_enforce_memory_limit(phys_addr_t memory_limit);
-extern int memblock_is_memory(phys_addr_t addr);
-extern int memblock_is_region_memory(phys_addr_t base, phys_addr_t size);
-extern int memblock_is_reserved(phys_addr_t addr);
-extern int memblock_is_region_reserved(phys_addr_t base, phys_addr_t size);
-
-extern void memblock_dump_all(void);
-
-/* Provided by the architecture */
-extern phys_addr_t memblock_nid_range(phys_addr_t start, phys_addr_t end, int *nid);
-extern int memblock_memory_can_coalesce(phys_addr_t addr1, phys_addr_t size1,
-				   phys_addr_t addr2, phys_addr_t size2);
+phys_addr_t memblock_alloc_base(phys_addr_t size, phys_addr_t align,
+				phys_addr_t max_addr);
+phys_addr_t __memblock_alloc_base(phys_addr_t size, phys_addr_t align,
+				  phys_addr_t max_addr);
+phys_addr_t memblock_phys_mem_size(void);
+phys_addr_t memblock_start_of_DRAM(void);
+phys_addr_t memblock_end_of_DRAM(void);
+void memblock_enforce_memory_limit(phys_addr_t memory_limit);
+int memblock_is_memory(phys_addr_t addr);
+int memblock_is_region_memory(phys_addr_t base, phys_addr_t size);
+int memblock_is_reserved(phys_addr_t addr);
+int memblock_is_region_reserved(phys_addr_t base, phys_addr_t size);
+
+extern void __memblock_dump_all(void);
+
+static inline void memblock_dump_all(void)
+{
+	if (memblock_debug)
+		__memblock_dump_all();
+}
 
 /**
  * memblock_set_current_limit - Set the current allocation limit to allow
@@ -101,7 +179,7 @@ extern int memblock_memory_can_coalesce(phys_addr_t addr1, phys_addr_t size1,
  *                         accessible during boot
  * @limit: New limit value (physical address)
  */
-extern void memblock_set_current_limit(phys_addr_t limit);
+void memblock_set_current_limit(phys_addr_t limit);
 
 
 /*
@@ -154,9 +232,9 @@ static inline unsigned long memblock_region_reserved_end_pfn(const struct memblo
 	     region++)
 
 
-#ifdef ARCH_DISCARD_MEMBLOCK
-#define __init_memblock __init
-#define __initdata_memblock __initdata
+#ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
+#define __init_memblock __meminit
+#define __initdata_memblock __meminitdata
 #else
 #define __init_memblock
 #define __initdata_memblock
@@ -165,7 +243,7 @@ static inline unsigned long memblock_region_reserved_end_pfn(const struct memblo
 #else
 static inline phys_addr_t memblock_alloc(phys_addr_t size, phys_addr_t align)
 {
-	return MEMBLOCK_ERROR;
+	return 0;
 }
 
 #endif /* CONFIG_HAVE_MEMBLOCK */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 4baadd1..5d9b4c9 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1253,41 +1253,34 @@ static inline void pgtable_page_dtor(struct page *page)
 extern void free_area_init(unsigned long * zones_size);
 extern void free_area_init_node(int nid, unsigned long * zones_size,
 		unsigned long zone_start_pfn, unsigned long *zholes_size);
-#ifdef CONFIG_ARCH_POPULATES_NODE_MAP
+#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 /*
- * With CONFIG_ARCH_POPULATES_NODE_MAP set, an architecture may initialise its
+ * With CONFIG_HAVE_MEMBLOCK_NODE_MAP set, an architecture may initialise its
  * zones, allocate the backing mem_map and account for memory holes in a more
  * architecture independent manner. This is a substitute for creating the
  * zone_sizes[] and zholes_size[] arrays and passing them to
  * free_area_init_node()
  *
  * An architecture is expected to register range of page frames backed by
- * physical memory with add_active_range() before calling
+ * physical memory with memblock_add[_node]() before calling
  * free_area_init_nodes() passing in the PFN each zone ends at. At a basic
  * usage, an architecture is expected to do something like
  *
  * unsigned long max_zone_pfns[MAX_NR_ZONES] = {max_dma, max_normal_pfn,
  * 							 max_highmem_pfn};
  * for_each_valid_physical_page_range()
- * 	add_active_range(node_id, start_pfn, end_pfn)
+ * 	memblock_add_node(base, size, nid)
  * free_area_init_nodes(max_zone_pfns);
  *
- * If the architecture guarantees that there are no holes in the ranges
- * registered with add_active_range(), free_bootmem_active_regions()
- * will call free_bootmem_node() for each registered physical page range.
- * Similarly sparse_memory_present_with_active_regions() calls
- * memory_present() for each range when SPARSEMEM is enabled.
+ * free_bootmem_with_active_regions() calls free_bootmem_node() for each
+ * registered physical page range.  Similarly
+ * sparse_memory_present_with_active_regions() calls memory_present() for
+ * each range when SPARSEMEM is enabled.
  *
  * See mm/page_alloc.c for more information on each function exposed by
- * CONFIG_ARCH_POPULATES_NODE_MAP
+ * CONFIG_HAVE_MEMBLOCK_NODE_MAP.
  */
 extern void free_area_init_nodes(unsigned long *max_zone_pfn);
-extern void add_active_range(unsigned int nid, unsigned long start_pfn,
-					unsigned long end_pfn);
-extern void remove_active_range(unsigned int nid, unsigned long start_pfn,
-					unsigned long end_pfn);
-extern void remove_all_active_ranges(void);
-void sort_node_map(void);
 unsigned long node_map_pfn_alignment(void);
 unsigned long __absent_pages_in_range(int nid, unsigned long start_pfn,
 						unsigned long end_pfn);
@@ -1300,14 +1293,11 @@ extern void free_bootmem_with_active_regions(int nid,
 						unsigned long max_low_pfn);
 int add_from_early_node_map(struct range *range, int az,
 				   int nr_range, int nid);
-u64 __init find_memory_core_early(int nid, u64 size, u64 align,
-					u64 goal, u64 limit);
-typedef int (*work_fn_t)(unsigned long, unsigned long, void *);
-extern void work_with_active_regions(int nid, work_fn_t work_fn, void *data);
 extern void sparse_memory_present_with_active_regions(int nid);
-#endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
 
-#if !defined(CONFIG_ARCH_POPULATES_NODE_MAP) && \
+#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
+
+#if !defined(CONFIG_HAVE_MEMBLOCK_NODE_MAP) && \
     !defined(CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID)
 static inline int __early_pfn_to_nid(unsigned long pfn)
 {
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 188cb2f..3ac040f 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -598,13 +598,13 @@ struct zonelist {
 #endif
 };
 
-#ifdef CONFIG_ARCH_POPULATES_NODE_MAP
+#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 struct node_active_region {
 	unsigned long start_pfn;
 	unsigned long end_pfn;
 	int nid;
 };
-#endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
+#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
 #ifndef CONFIG_DISCONTIGMEM
 /* The array of struct pages - for discontigmem use pgdat->lmem_map */
@@ -720,7 +720,7 @@ extern int movable_zone;
 
 static inline int zone_movable_is_highmem(void)
 {
-#if defined(CONFIG_HIGHMEM) && defined(CONFIG_ARCH_POPULATES_NODE_MAP)
+#if defined(CONFIG_HIGHMEM) && defined(CONFIG_HAVE_MEMBLOCK_NODE)
 	return movable_zone == ZONE_HIGHMEM;
 #else
 	return 0;
@@ -938,7 +938,7 @@ static inline struct zoneref *first_zones_zonelist(struct zonelist *zonelist,
 #endif
 
 #if !defined(CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID) && \
-	!defined(CONFIG_ARCH_POPULATES_NODE_MAP)
+	!defined(CONFIG_HAVE_MEMBLOCK_NODE_MAP)
 static inline unsigned long early_pfn_to_nid(unsigned long pfn)
 {
 	return 0;
diff --git a/include/linux/poison.h b/include/linux/poison.h
index 79159de..2110a81 100644
--- a/include/linux/poison.h
+++ b/include/linux/poison.h
@@ -40,12 +40,6 @@
 #define	RED_INACTIVE	0x09F911029D74E35BULL	/* when obj is inactive */
 #define	RED_ACTIVE	0xD84156C5635688C0ULL	/* when obj is active */
 
-#ifdef CONFIG_PHYS_ADDR_T_64BIT
-#define MEMBLOCK_INACTIVE	0x3a84fb0144c9e71bULL
-#else
-#define MEMBLOCK_INACTIVE	0x44c9e71bUL
-#endif
-
 #define SLUB_RED_INACTIVE	0xbb
 #define SLUB_RED_ACTIVE		0xcc
 
diff --git a/kernel/printk.c b/kernel/printk.c
index 7982a0a..afc8310c 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -199,7 +199,7 @@ void __init setup_log_buf(int early)
 		unsigned long mem;
 
 		mem = memblock_alloc(new_log_buf_len, PAGE_SIZE);
-		if (mem == MEMBLOCK_ERROR)
+		if (!mem)
 			return;
 		new_log_buf = __va(mem);
 	} else {
diff --git a/mm/Kconfig b/mm/Kconfig
index 011b110..e338407 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -131,6 +131,12 @@ config SPARSEMEM_VMEMMAP
 config HAVE_MEMBLOCK
 	boolean
 
+config HAVE_MEMBLOCK_NODE_MAP
+	boolean
+
+config ARCH_DISCARD_MEMBLOCK
+	boolean
+
 config NO_BOOTMEM
 	boolean
 
diff --git a/mm/memblock.c b/mm/memblock.c
index 84bec49..2f55f19 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -20,12 +20,23 @@
 #include <linux/seq_file.h>
 #include <linux/memblock.h>
 
-struct memblock memblock __initdata_memblock;
+static struct memblock_region memblock_memory_init_regions[INIT_MEMBLOCK_REGIONS] __initdata_memblock;
+static struct memblock_region memblock_reserved_init_regions[INIT_MEMBLOCK_REGIONS] __initdata_memblock;
+
+struct memblock memblock __initdata_memblock = {
+	.memory.regions		= memblock_memory_init_regions,
+	.memory.cnt		= 1,	/* empty dummy entry */
+	.memory.max		= INIT_MEMBLOCK_REGIONS,
+
+	.reserved.regions	= memblock_reserved_init_regions,
+	.reserved.cnt		= 1,	/* empty dummy entry */
+	.reserved.max		= INIT_MEMBLOCK_REGIONS,
+
+	.current_limit		= MEMBLOCK_ALLOC_ANYWHERE,
+};
 
 int memblock_debug __initdata_memblock;
-int memblock_can_resize __initdata_memblock;
-static struct memblock_region memblock_memory_init_regions[INIT_MEMBLOCK_REGIONS + 1] __initdata_memblock;
-static struct memblock_region memblock_reserved_init_regions[INIT_MEMBLOCK_REGIONS + 1] __initdata_memblock;
+static int memblock_can_resize __initdata_memblock;
 
 /* inline so we don't get a warning when pr_debug is compiled out */
 static inline const char *memblock_type_name(struct memblock_type *type)
@@ -38,20 +49,15 @@ static inline const char *memblock_type_name(struct memblock_type *type)
 		return "unknown";
 }
 
-/*
- * Address comparison utilities
- */
-
-static phys_addr_t __init_memblock memblock_align_down(phys_addr_t addr, phys_addr_t size)
-{
-	return addr & ~(size - 1);
-}
-
-static phys_addr_t __init_memblock memblock_align_up(phys_addr_t addr, phys_addr_t size)
+/* adjust *@size so that (@base + *@size) doesn't overflow, return new size */
+static inline phys_addr_t memblock_cap_size(phys_addr_t base, phys_addr_t *size)
 {
-	return (addr + (size - 1)) & ~(size - 1);
+	return *size = min(*size, (phys_addr_t)ULLONG_MAX - base);
 }
 
+/*
+ * Address comparison utilities
+ */
 static unsigned long __init_memblock memblock_addrs_overlap(phys_addr_t base1, phys_addr_t size1,
 				       phys_addr_t base2, phys_addr_t size2)
 {
@@ -73,83 +79,66 @@ static long __init_memblock memblock_overlaps_region(struct memblock_type *type,
 	return (i < type->cnt) ? i : -1;
 }
 
-/*
- * Find, allocate, deallocate or reserve unreserved regions. All allocations
- * are top-down.
+/**
+ * memblock_find_in_range_node - find free area in given range and node
+ * @start: start of candidate range
+ * @end: end of candidate range, can be %MEMBLOCK_ALLOC_{ANYWHERE|ACCESSIBLE}
+ * @size: size of free area to find
+ * @align: alignment of free area to find
+ * @nid: nid of the free area to find, %MAX_NUMNODES for any node
+ *
+ * Find @size free area aligned to @align in the specified range and node.
+ *
+ * RETURNS:
+ * Found address on success, %0 on failure.
  */
-
-static phys_addr_t __init_memblock memblock_find_region(phys_addr_t start, phys_addr_t end,
-					  phys_addr_t size, phys_addr_t align)
+phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
+					phys_addr_t end, phys_addr_t size,
+					phys_addr_t align, int nid)
 {
-	phys_addr_t base, res_base;
-	long j;
-
-	/* In case, huge size is requested */
-	if (end < size)
-		return MEMBLOCK_ERROR;
-
-	base = memblock_align_down((end - size), align);
+	phys_addr_t this_start, this_end, cand;
+	u64 i;
 
-	/* Prevent allocations returning 0 as it's also used to
-	 * indicate an allocation failure
-	 */
-	if (start == 0)
-		start = PAGE_SIZE;
-
-	while (start <= base) {
-		j = memblock_overlaps_region(&memblock.reserved, base, size);
-		if (j < 0)
-			return base;
-		res_base = memblock.reserved.regions[j].base;
-		if (res_base < size)
-			break;
-		base = memblock_align_down(res_base - size, align);
-	}
+	/* align @size to avoid excessive fragmentation on reserved array */
+	size = round_up(size, align);
 
-	return MEMBLOCK_ERROR;
-}
-
-static phys_addr_t __init_memblock memblock_find_base(phys_addr_t size,
-			phys_addr_t align, phys_addr_t start, phys_addr_t end)
-{
-	long i;
-
-	BUG_ON(0 == size);
-
-	/* Pump up max_addr */
+	/* pump up @end */
 	if (end == MEMBLOCK_ALLOC_ACCESSIBLE)
 		end = memblock.current_limit;
 
-	/* We do a top-down search, this tends to limit memory
-	 * fragmentation by keeping early boot allocs near the
-	 * top of memory
-	 */
-	for (i = memblock.memory.cnt - 1; i >= 0; i--) {
-		phys_addr_t memblockbase = memblock.memory.regions[i].base;
-		phys_addr_t memblocksize = memblock.memory.regions[i].size;
-		phys_addr_t bottom, top, found;
+	/* adjust @start to avoid underflow and allocating the first page */
+	start = max3(start, size, (phys_addr_t)PAGE_SIZE);
+	end = max(start, end);
 
-		if (memblocksize < size)
-			continue;
-		if ((memblockbase + memblocksize) <= start)
-			break;
-		bottom = max(memblockbase, start);
-		top = min(memblockbase + memblocksize, end);
-		if (bottom >= top)
-			continue;
-		found = memblock_find_region(bottom, top, size, align);
-		if (found != MEMBLOCK_ERROR)
-			return found;
+	for_each_free_mem_range_reverse(i, nid, &this_start, &this_end, NULL) {
+		this_start = clamp(this_start, start, end);
+		this_end = clamp(this_end, start, end);
+
+		cand = round_down(this_end - size, align);
+		if (cand >= this_start)
+			return cand;
 	}
-	return MEMBLOCK_ERROR;
+	return 0;
 }
 
-/*
- * Find a free area with specified alignment in a specific range.
+/**
+ * memblock_find_in_range - find free area in given range
+ * @start: start of candidate range
+ * @end: end of candidate range, can be %MEMBLOCK_ALLOC_{ANYWHERE|ACCESSIBLE}
+ * @size: size of free area to find
+ * @align: alignment of free area to find
+ *
+ * Find @size free area aligned to @align in the specified range.
+ *
+ * RETURNS:
+ * Found address on success, %0 on failure.
  */
-u64 __init_memblock memblock_find_in_range(u64 start, u64 end, u64 size, u64 align)
+phys_addr_t __init_memblock memblock_find_in_range(phys_addr_t start,
+					phys_addr_t end, phys_addr_t size,
+					phys_addr_t align)
 {
-	return memblock_find_base(size, align, start, end);
+	return memblock_find_in_range_node(start, end, size, align,
+					   MAX_NUMNODES);
 }
 
 /*
@@ -178,25 +167,21 @@ int __init_memblock memblock_reserve_reserved_regions(void)
 
 static void __init_memblock memblock_remove_region(struct memblock_type *type, unsigned long r)
 {
-	unsigned long i;
-
-	for (i = r; i < type->cnt - 1; i++) {
-		type->regions[i].base = type->regions[i + 1].base;
-		type->regions[i].size = type->regions[i + 1].size;
-	}
+	type->total_size -= type->regions[r].size;
+	memmove(&type->regions[r], &type->regions[r + 1],
+		(type->cnt - (r + 1)) * sizeof(type->regions[r]));
 	type->cnt--;
 
 	/* Special case for empty arrays */
 	if (type->cnt == 0) {
+		WARN_ON(type->total_size != 0);
 		type->cnt = 1;
 		type->regions[0].base = 0;
 		type->regions[0].size = 0;
+		memblock_set_region_node(&type->regions[0], MAX_NUMNODES);
 	}
 }
 
-/* Defined below but needed now */
-static long memblock_add_region(struct memblock_type *type, phys_addr_t base, phys_addr_t size);
-
 static int __init_memblock memblock_double_array(struct memblock_type *type)
 {
 	struct memblock_region *new_array, *old_array;
@@ -226,10 +211,10 @@ static int __init_memblock memblock_double_array(struct memblock_type *type)
 	 */
 	if (use_slab) {
 		new_array = kmalloc(new_size, GFP_KERNEL);
-		addr = new_array == NULL ? MEMBLOCK_ERROR : __pa(new_array);
+		addr = new_array ? __pa(new_array) : 0;
 	} else
-		addr = memblock_find_base(new_size, sizeof(phys_addr_t), 0, MEMBLOCK_ALLOC_ACCESSIBLE);
-	if (addr == MEMBLOCK_ERROR) {
+		addr = memblock_find_in_range(0, MEMBLOCK_ALLOC_ACCESSIBLE, new_size, sizeof(phys_addr_t));
+	if (!addr) {
 		pr_err("memblock: Failed to double %s array from %ld to %ld entries !\n",
 		       memblock_type_name(type), type->max, type->max * 2);
 		return -1;
@@ -254,7 +239,7 @@ static int __init_memblock memblock_double_array(struct memblock_type *type)
 		return 0;
 
 	/* Add the new reserved region now. Should not fail ! */
-	BUG_ON(memblock_add_region(&memblock.reserved, addr, new_size));
+	BUG_ON(memblock_reserve(addr, new_size));
 
 	/* If the array wasn't our static init one, then free it. We only do
 	 * that before SLAB is available as later on, we don't know whether
@@ -268,343 +253,514 @@ static int __init_memblock memblock_double_array(struct memblock_type *type)
 	return 0;
 }
 
-int __init_memblock __weak memblock_memory_can_coalesce(phys_addr_t addr1, phys_addr_t size1,
-					  phys_addr_t addr2, phys_addr_t size2)
-{
-	return 1;
-}
-
-static long __init_memblock memblock_add_region(struct memblock_type *type,
-						phys_addr_t base, phys_addr_t size)
+/**
+ * memblock_merge_regions - merge neighboring compatible regions
+ * @type: memblock type to scan
+ *
+ * Scan @type and merge neighboring compatible regions.
+ */
+static void __init_memblock memblock_merge_regions(struct memblock_type *type)
 {
-	phys_addr_t end = base + size;
-	int i, slot = -1;
-
-	/* First try and coalesce this MEMBLOCK with others */
-	for (i = 0; i < type->cnt; i++) {
-		struct memblock_region *rgn = &type->regions[i];
-		phys_addr_t rend = rgn->base + rgn->size;
+	int i = 0;
 
-		/* Exit if there's no possible hits */
-		if (rgn->base > end || rgn->size == 0)
-			break;
+	/* cnt never goes below 1 */
+	while (i < type->cnt - 1) {
+		struct memblock_region *this = &type->regions[i];
+		struct memblock_region *next = &type->regions[i + 1];
 
-		/* Check if we are fully enclosed within an existing
-		 * block
-		 */
-		if (rgn->base <= base && rend >= end)
-			return 0;
+		if (this->base + this->size != next->base ||
+		    memblock_get_region_node(this) !=
+		    memblock_get_region_node(next)) {
+			BUG_ON(this->base + this->size > next->base);
+			i++;
+			continue;
+		}
 
-		/* Check if we overlap or are adjacent with the bottom
-		 * of a block.
-		 */
-		if (base < rgn->base && end >= rgn->base) {
-			/* If we can't coalesce, create a new block */
-			if (!memblock_memory_can_coalesce(base, size,
-							  rgn->base,
-							  rgn->size)) {
-				/* Overlap & can't coalesce are mutually
-				 * exclusive, if you do that, be prepared
-				 * for trouble
-				 */
-				WARN_ON(end != rgn->base);
-				goto new_block;
-			}
-			/* We extend the bottom of the block down to our
-			 * base
-			 */
-			rgn->base = base;
-			rgn->size = rend - base;
+		this->size += next->size;
+		memmove(next, next + 1, (type->cnt - (i + 1)) * sizeof(*next));
+		type->cnt--;
+	}
+}
 
-			/* Return if we have nothing else to allocate
-			 * (fully coalesced)
-			 */
-			if (rend >= end)
-				return 0;
+/**
+ * memblock_insert_region - insert new memblock region
+ * @type: memblock type to insert into
+ * @idx: index for the insertion point
+ * @base: base address of the new region
+ * @size: size of the new region
+ *
+ * Insert new memblock region [@base,@base+@size) into @type at @idx.
+ * @type must already have extra room to accomodate the new region.
+ */
+static void __init_memblock memblock_insert_region(struct memblock_type *type,
+						   int idx, phys_addr_t base,
+						   phys_addr_t size, int nid)
+{
+	struct memblock_region *rgn = &type->regions[idx];
 
-			/* We continue processing from the end of the
-			 * coalesced block.
-			 */
-			base = rend;
-			size = end - base;
-		}
+	BUG_ON(type->cnt >= type->max);
+	memmove(rgn + 1, rgn, (type->cnt - idx) * sizeof(*rgn));
+	rgn->base = base;
+	rgn->size = size;
+	memblock_set_region_node(rgn, nid);
+	type->cnt++;
+	type->total_size += size;
+}
 
-		/* Now check if we overlap or are adjacent with the
-		 * top of a block
-		 */
-		if (base <= rend && end >= rend) {
-			/* If we can't coalesce, create a new block */
-			if (!memblock_memory_can_coalesce(rgn->base,
-							  rgn->size,
-							  base, size)) {
-				/* Overlap & can't coalesce are mutually
-				 * exclusive, if you do that, be prepared
-				 * for trouble
-				 */
-				WARN_ON(rend != base);
-				goto new_block;
-			}
-			/* We adjust our base down to enclose the
-			 * original block and destroy it. It will be
-			 * part of our new allocation. Since we've
-			 * freed an entry, we know we won't fail
-			 * to allocate one later, so we won't risk
-			 * losing the original block allocation.
-			 */
-			size += (base - rgn->base);
-			base = rgn->base;
-			memblock_remove_region(type, i--);
-		}
-	}
+/**
+ * memblock_add_region - add new memblock region
+ * @type: memblock type to add new region into
+ * @base: base address of the new region
+ * @size: size of the new region
+ * @nid: nid of the new region
+ *
+ * Add new memblock region [@base,@base+@size) into @type.  The new region
+ * is allowed to overlap with existing ones - overlaps don't affect already
+ * existing regions.  @type is guaranteed to be minimal (all neighbouring
+ * compatible regions are merged) after the addition.
+ *
+ * RETURNS:
+ * 0 on success, -errno on failure.
+ */
+static int __init_memblock memblock_add_region(struct memblock_type *type,
+				phys_addr_t base, phys_addr_t size, int nid)
+{
+	bool insert = false;
+	phys_addr_t obase = base;
+	phys_addr_t end = base + memblock_cap_size(base, &size);
+	int i, nr_new;
 
-	/* If the array is empty, special case, replace the fake
-	 * filler region and return
-	 */
-	if ((type->cnt == 1) && (type->regions[0].size == 0)) {
+	/* special case for empty array */
+	if (type->regions[0].size == 0) {
+		WARN_ON(type->cnt != 1 || type->total_size);
 		type->regions[0].base = base;
 		type->regions[0].size = size;
+		memblock_set_region_node(&type->regions[0], nid);
+		type->total_size = size;
 		return 0;
 	}
-
- new_block:
-	/* If we are out of space, we fail. It's too late to resize the array
-	 * but then this shouldn't have happened in the first place.
+repeat:
+	/*
+	 * The following is executed twice.  Once with %false @insert and
+	 * then with %true.  The first counts the number of regions needed
+	 * to accomodate the new area.  The second actually inserts them.
 	 */
-	if (WARN_ON(type->cnt >= type->max))
-		return -1;
+	base = obase;
+	nr_new = 0;
 
-	/* Couldn't coalesce the MEMBLOCK, so add it to the sorted table. */
-	for (i = type->cnt - 1; i >= 0; i--) {
-		if (base < type->regions[i].base) {
-			type->regions[i+1].base = type->regions[i].base;
-			type->regions[i+1].size = type->regions[i].size;
-		} else {
-			type->regions[i+1].base = base;
-			type->regions[i+1].size = size;
-			slot = i + 1;
+	for (i = 0; i < type->cnt; i++) {
+		struct memblock_region *rgn = &type->regions[i];
+		phys_addr_t rbase = rgn->base;
+		phys_addr_t rend = rbase + rgn->size;
+
+		if (rbase >= end)
 			break;
+		if (rend <= base)
+			continue;
+		/*
+		 * @rgn overlaps.  If it separates the lower part of new
+		 * area, insert that portion.
+		 */
+		if (rbase > base) {
+			nr_new++;
+			if (insert)
+				memblock_insert_region(type, i++, base,
+						       rbase - base, nid);
 		}
+		/* area below @rend is dealt with, forget about it */
+		base = min(rend, end);
 	}
-	if (base < type->regions[0].base) {
-		type->regions[0].base = base;
-		type->regions[0].size = size;
-		slot = 0;
+
+	/* insert the remaining portion */
+	if (base < end) {
+		nr_new++;
+		if (insert)
+			memblock_insert_region(type, i, base, end - base, nid);
 	}
-	type->cnt++;
 
-	/* The array is full ? Try to resize it. If that fails, we undo
-	 * our allocation and return an error
+	/*
+	 * If this was the first round, resize array and repeat for actual
+	 * insertions; otherwise, merge and return.
 	 */
-	if (type->cnt == type->max && memblock_double_array(type)) {
-		BUG_ON(slot < 0);
-		memblock_remove_region(type, slot);
-		return -1;
+	if (!insert) {
+		while (type->cnt + nr_new > type->max)
+			if (memblock_double_array(type) < 0)
+				return -ENOMEM;
+		insert = true;
+		goto repeat;
+	} else {
+		memblock_merge_regions(type);
+		return 0;
 	}
-
-	return 0;
 }
 
-long __init_memblock memblock_add(phys_addr_t base, phys_addr_t size)
+int __init_memblock memblock_add_node(phys_addr_t base, phys_addr_t size,
+				       int nid)
 {
-	return memblock_add_region(&memblock.memory, base, size);
+	return memblock_add_region(&memblock.memory, base, size, nid);
+}
 
+int __init_memblock memblock_add(phys_addr_t base, phys_addr_t size)
+{
+	return memblock_add_region(&memblock.memory, base, size, MAX_NUMNODES);
 }
 
-static long __init_memblock __memblock_remove(struct memblock_type *type,
-					      phys_addr_t base, phys_addr_t size)
+/**
+ * memblock_isolate_range - isolate given range into disjoint memblocks
+ * @type: memblock type to isolate range for
+ * @base: base of range to isolate
+ * @size: size of range to isolate
+ * @start_rgn: out parameter for the start of isolated region
+ * @end_rgn: out parameter for the end of isolated region
+ *
+ * Walk @type and ensure that regions don't cross the boundaries defined by
+ * [@base,@base+@size).  Crossing regions are split at the boundaries,
+ * which may create at most two more regions.  The index of the first
+ * region inside the range is returned in *@start_rgn and end in *@end_rgn.
+ *
+ * RETURNS:
+ * 0 on success, -errno on failure.
+ */
+static int __init_memblock memblock_isolate_range(struct memblock_type *type,
+					phys_addr_t base, phys_addr_t size,
+					int *start_rgn, int *end_rgn)
 {
-	phys_addr_t end = base + size;
+	phys_addr_t end = base + memblock_cap_size(base, &size);
 	int i;
 
-	/* Walk through the array for collisions */
+	*start_rgn = *end_rgn = 0;
+
+	/* we'll create at most two more regions */
+	while (type->cnt + 2 > type->max)
+		if (memblock_double_array(type) < 0)
+			return -ENOMEM;
+
 	for (i = 0; i < type->cnt; i++) {
 		struct memblock_region *rgn = &type->regions[i];
-		phys_addr_t rend = rgn->base + rgn->size;
+		phys_addr_t rbase = rgn->base;
+		phys_addr_t rend = rbase + rgn->size;
 
-		/* Nothing more to do, exit */
-		if (rgn->base > end || rgn->size == 0)
+		if (rbase >= end)
 			break;
-
-		/* If we fully enclose the block, drop it */
-		if (base <= rgn->base && end >= rend) {
-			memblock_remove_region(type, i--);
+		if (rend <= base)
 			continue;
-		}
 
-		/* If we are fully enclosed within a block
-		 * then we need to split it and we are done
-		 */
-		if (base > rgn->base && end < rend) {
-			rgn->size = base - rgn->base;
-			if (!memblock_add_region(type, end, rend - end))
-				return 0;
-			/* Failure to split is bad, we at least
-			 * restore the block before erroring
+		if (rbase < base) {
+			/*
+			 * @rgn intersects from below.  Split and continue
+			 * to process the next region - the new top half.
+			 */
+			rgn->base = base;
+			rgn->size -= base - rbase;
+			type->total_size -= base - rbase;
+			memblock_insert_region(type, i, rbase, base - rbase,
+					       memblock_get_region_node(rgn));
+		} else if (rend > end) {
+			/*
+			 * @rgn intersects from above.  Split and redo the
+			 * current region - the new bottom half.
 			 */
-			rgn->size = rend - rgn->base;
-			WARN_ON(1);
-			return -1;
-		}
-
-		/* Check if we need to trim the bottom of a block */
-		if (rgn->base < end && rend > end) {
-			rgn->size -= end - rgn->base;
 			rgn->base = end;
-			break;
+			rgn->size -= end - rbase;
+			type->total_size -= end - rbase;
+			memblock_insert_region(type, i--, rbase, end - rbase,
+					       memblock_get_region_node(rgn));
+		} else {
+			/* @rgn is fully contained, record it */
+			if (!*end_rgn)
+				*start_rgn = i;
+			*end_rgn = i + 1;
 		}
+	}
 
-		/* And check if we need to trim the top of a block */
-		if (base < rend)
-			rgn->size -= rend - base;
+	return 0;
+}
 
-	}
+static int __init_memblock __memblock_remove(struct memblock_type *type,
+					     phys_addr_t base, phys_addr_t size)
+{
+	int start_rgn, end_rgn;
+	int i, ret;
+
+	ret = memblock_isolate_range(type, base, size, &start_rgn, &end_rgn);
+	if (ret)
+		return ret;
+
+	for (i = end_rgn - 1; i >= start_rgn; i--)
+		memblock_remove_region(type, i);
 	return 0;
 }
 
-long __init_memblock memblock_remove(phys_addr_t base, phys_addr_t size)
+int __init_memblock memblock_remove(phys_addr_t base, phys_addr_t size)
 {
 	return __memblock_remove(&memblock.memory, base, size);
 }
 
-long __init_memblock memblock_free(phys_addr_t base, phys_addr_t size)
+int __init_memblock memblock_free(phys_addr_t base, phys_addr_t size)
 {
+	memblock_dbg("   memblock_free: [%#016llx-%#016llx] %pF\n",
+		     (unsigned long long)base,
+		     (unsigned long long)base + size,
+		     (void *)_RET_IP_);
+
 	return __memblock_remove(&memblock.reserved, base, size);
 }
 
-long __init_memblock memblock_reserve(phys_addr_t base, phys_addr_t size)
+int __init_memblock memblock_reserve(phys_addr_t base, phys_addr_t size)
 {
 	struct memblock_type *_rgn = &memblock.reserved;
 
+	memblock_dbg("memblock_reserve: [%#016llx-%#016llx] %pF\n",
+		     (unsigned long long)base,
+		     (unsigned long long)base + size,
+		     (void *)_RET_IP_);
 	BUG_ON(0 == size);
 
-	return memblock_add_region(_rgn, base, size);
+	return memblock_add_region(_rgn, base, size, MAX_NUMNODES);
 }
 
-phys_addr_t __init __memblock_alloc_base(phys_addr_t size, phys_addr_t align, phys_addr_t max_addr)
+/**
+ * __next_free_mem_range - next function for for_each_free_mem_range()
+ * @idx: pointer to u64 loop variable
+ * @nid: nid: node selector, %MAX_NUMNODES for all nodes
+ * @p_start: ptr to phys_addr_t for start address of the range, can be %NULL
+ * @p_end: ptr to phys_addr_t for end address of the range, can be %NULL
+ * @p_nid: ptr to int for nid of the range, can be %NULL
+ *
+ * Find the first free area from *@idx which matches @nid, fill the out
+ * parameters, and update *@idx for the next iteration.  The lower 32bit of
+ * *@idx contains index into memory region and the upper 32bit indexes the
+ * areas before each reserved region.  For example, if reserved regions
+ * look like the following,
+ *
+ *	0:[0-16), 1:[32-48), 2:[128-130)
+ *
+ * The upper 32bit indexes the following regions.
+ *
+ *	0:[0-0), 1:[16-32), 2:[48-128), 3:[130-MAX)
+ *
+ * As both region arrays are sorted, the function advances the two indices
+ * in lockstep and returns each intersection.
+ */
+void __init_memblock __next_free_mem_range(u64 *idx, int nid,
+					   phys_addr_t *out_start,
+					   phys_addr_t *out_end, int *out_nid)
 {
-	phys_addr_t found;
+	struct memblock_type *mem = &memblock.memory;
+	struct memblock_type *rsv = &memblock.reserved;
+	int mi = *idx & 0xffffffff;
+	int ri = *idx >> 32;
 
-	/* We align the size to limit fragmentation. Without this, a lot of
-	 * small allocs quickly eat up the whole reserve array on sparc
-	 */
-	size = memblock_align_up(size, align);
+	for ( ; mi < mem->cnt; mi++) {
+		struct memblock_region *m = &mem->regions[mi];
+		phys_addr_t m_start = m->base;
+		phys_addr_t m_end = m->base + m->size;
 
-	found = memblock_find_base(size, align, 0, max_addr);
-	if (found != MEMBLOCK_ERROR &&
-	    !memblock_add_region(&memblock.reserved, found, size))
-		return found;
+		/* only memory regions are associated with nodes, check it */
+		if (nid != MAX_NUMNODES && nid != memblock_get_region_node(m))
+			continue;
 
-	return 0;
+		/* scan areas before each reservation for intersection */
+		for ( ; ri < rsv->cnt + 1; ri++) {
+			struct memblock_region *r = &rsv->regions[ri];
+			phys_addr_t r_start = ri ? r[-1].base + r[-1].size : 0;
+			phys_addr_t r_end = ri < rsv->cnt ? r->base : ULLONG_MAX;
+
+			/* if ri advanced past mi, break out to advance mi */
+			if (r_start >= m_end)
+				break;
+			/* if the two regions intersect, we're done */
+			if (m_start < r_end) {
+				if (out_start)
+					*out_start = max(m_start, r_start);
+				if (out_end)
+					*out_end = min(m_end, r_end);
+				if (out_nid)
+					*out_nid = memblock_get_region_node(m);
+				/*
+				 * The region which ends first is advanced
+				 * for the next iteration.
+				 */
+				if (m_end <= r_end)
+					mi++;
+				else
+					ri++;
+				*idx = (u32)mi | (u64)ri << 32;
+				return;
+			}
+		}
+	}
+
+	/* signal end of iteration */
+	*idx = ULLONG_MAX;
 }
 
-phys_addr_t __init memblock_alloc_base(phys_addr_t size, phys_addr_t align, phys_addr_t max_addr)
+/**
+ * __next_free_mem_range_rev - next function for for_each_free_mem_range_reverse()
+ * @idx: pointer to u64 loop variable
+ * @nid: nid: node selector, %MAX_NUMNODES for all nodes
+ * @p_start: ptr to phys_addr_t for start address of the range, can be %NULL
+ * @p_end: ptr to phys_addr_t for end address of the range, can be %NULL
+ * @p_nid: ptr to int for nid of the range, can be %NULL
+ *
+ * Reverse of __next_free_mem_range().
+ */
+void __init_memblock __next_free_mem_range_rev(u64 *idx, int nid,
+					   phys_addr_t *out_start,
+					   phys_addr_t *out_end, int *out_nid)
 {
-	phys_addr_t alloc;
+	struct memblock_type *mem = &memblock.memory;
+	struct memblock_type *rsv = &memblock.reserved;
+	int mi = *idx & 0xffffffff;
+	int ri = *idx >> 32;
 
-	alloc = __memblock_alloc_base(size, align, max_addr);
+	if (*idx == (u64)ULLONG_MAX) {
+		mi = mem->cnt - 1;
+		ri = rsv->cnt;
+	}
 
-	if (alloc == 0)
-		panic("ERROR: Failed to allocate 0x%llx bytes below 0x%llx.\n",
-		      (unsigned long long) size, (unsigned long long) max_addr);
+	for ( ; mi >= 0; mi--) {
+		struct memblock_region *m = &mem->regions[mi];
+		phys_addr_t m_start = m->base;
+		phys_addr_t m_end = m->base + m->size;
 
-	return alloc;
-}
+		/* only memory regions are associated with nodes, check it */
+		if (nid != MAX_NUMNODES && nid != memblock_get_region_node(m))
+			continue;
 
-phys_addr_t __init memblock_alloc(phys_addr_t size, phys_addr_t align)
-{
-	return memblock_alloc_base(size, align, MEMBLOCK_ALLOC_ACCESSIBLE);
-}
+		/* scan areas before each reservation for intersection */
+		for ( ; ri >= 0; ri--) {
+			struct memblock_region *r = &rsv->regions[ri];
+			phys_addr_t r_start = ri ? r[-1].base + r[-1].size : 0;
+			phys_addr_t r_end = ri < rsv->cnt ? r->base : ULLONG_MAX;
+
+			/* if ri advanced past mi, break out to advance mi */
+			if (r_end <= m_start)
+				break;
+			/* if the two regions intersect, we're done */
+			if (m_end > r_start) {
+				if (out_start)
+					*out_start = max(m_start, r_start);
+				if (out_end)
+					*out_end = min(m_end, r_end);
+				if (out_nid)
+					*out_nid = memblock_get_region_node(m);
+
+				if (m_start >= r_start)
+					mi--;
+				else
+					ri--;
+				*idx = (u32)mi | (u64)ri << 32;
+				return;
+			}
+		}
+	}
 
+	*idx = ULLONG_MAX;
+}
 
+#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 /*
- * Additional node-local allocators. Search for node memory is bottom up
- * and walks memblock regions within that node bottom-up as well, but allocation
- * within an memblock region is top-down. XXX I plan to fix that at some stage
- *
- * WARNING: Only available after early_node_map[] has been populated,
- * on some architectures, that is after all the calls to add_active_range()
- * have been done to populate it.
+ * Common iterator interface used to define for_each_mem_range().
  */
-
-phys_addr_t __weak __init memblock_nid_range(phys_addr_t start, phys_addr_t end, int *nid)
+void __init_memblock __next_mem_pfn_range(int *idx, int nid,
+				unsigned long *out_start_pfn,
+				unsigned long *out_end_pfn, int *out_nid)
 {
-#ifdef CONFIG_ARCH_POPULATES_NODE_MAP
-	/*
-	 * This code originates from sparc which really wants use to walk by addresses
-	 * and returns the nid. This is not very convenient for early_pfn_map[] users
-	 * as the map isn't sorted yet, and it really wants to be walked by nid.
-	 *
-	 * For now, I implement the inefficient method below which walks the early
-	 * map multiple times. Eventually we may want to use an ARCH config option
-	 * to implement a completely different method for both case.
-	 */
-	unsigned long start_pfn, end_pfn;
-	int i;
+	struct memblock_type *type = &memblock.memory;
+	struct memblock_region *r;
 
-	for (i = 0; i < MAX_NUMNODES; i++) {
-		get_pfn_range_for_nid(i, &start_pfn, &end_pfn);
-		if (start < PFN_PHYS(start_pfn) || start >= PFN_PHYS(end_pfn))
+	while (++*idx < type->cnt) {
+		r = &type->regions[*idx];
+
+		if (PFN_UP(r->base) >= PFN_DOWN(r->base + r->size))
 			continue;
-		*nid = i;
-		return min(end, PFN_PHYS(end_pfn));
+		if (nid == MAX_NUMNODES || nid == r->nid)
+			break;
+	}
+	if (*idx >= type->cnt) {
+		*idx = -1;
+		return;
 	}
-#endif
-	*nid = 0;
 
-	return end;
+	if (out_start_pfn)
+		*out_start_pfn = PFN_UP(r->base);
+	if (out_end_pfn)
+		*out_end_pfn = PFN_DOWN(r->base + r->size);
+	if (out_nid)
+		*out_nid = r->nid;
 }
 
-static phys_addr_t __init memblock_alloc_nid_region(struct memblock_region *mp,
-					       phys_addr_t size,
-					       phys_addr_t align, int nid)
+/**
+ * memblock_set_node - set node ID on memblock regions
+ * @base: base of area to set node ID for
+ * @size: size of area to set node ID for
+ * @nid: node ID to set
+ *
+ * Set the nid of memblock memory regions in [@base,@base+@size) to @nid.
+ * Regions which cross the area boundaries are split as necessary.
+ *
+ * RETURNS:
+ * 0 on success, -errno on failure.
+ */
+int __init_memblock memblock_set_node(phys_addr_t base, phys_addr_t size,
+				      int nid)
 {
-	phys_addr_t start, end;
+	struct memblock_type *type = &memblock.memory;
+	int start_rgn, end_rgn;
+	int i, ret;
 
-	start = mp->base;
-	end = start + mp->size;
+	ret = memblock_isolate_range(type, base, size, &start_rgn, &end_rgn);
+	if (ret)
+		return ret;
 
-	start = memblock_align_up(start, align);
-	while (start < end) {
-		phys_addr_t this_end;
-		int this_nid;
+	for (i = start_rgn; i < end_rgn; i++)
+		type->regions[i].nid = nid;
 
-		this_end = memblock_nid_range(start, end, &this_nid);
-		if (this_nid == nid) {
-			phys_addr_t ret = memblock_find_region(start, this_end, size, align);
-			if (ret != MEMBLOCK_ERROR &&
-			    !memblock_add_region(&memblock.reserved, ret, size))
-				return ret;
-		}
-		start = this_end;
-	}
+	memblock_merge_regions(type);
+	return 0;
+}
+#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
+
+static phys_addr_t __init memblock_alloc_base_nid(phys_addr_t size,
+					phys_addr_t align, phys_addr_t max_addr,
+					int nid)
+{
+	phys_addr_t found;
 
-	return MEMBLOCK_ERROR;
+	found = memblock_find_in_range_node(0, max_addr, size, align, nid);
+	if (found && !memblock_reserve(found, size))
+		return found;
+
+	return 0;
 }
 
 phys_addr_t __init memblock_alloc_nid(phys_addr_t size, phys_addr_t align, int nid)
 {
-	struct memblock_type *mem = &memblock.memory;
-	int i;
+	return memblock_alloc_base_nid(size, align, MEMBLOCK_ALLOC_ACCESSIBLE, nid);
+}
 
-	BUG_ON(0 == size);
+phys_addr_t __init __memblock_alloc_base(phys_addr_t size, phys_addr_t align, phys_addr_t max_addr)
+{
+	return memblock_alloc_base_nid(size, align, max_addr, MAX_NUMNODES);
+}
 
-	/* We align the size to limit fragmentation. Without this, a lot of
-	 * small allocs quickly eat up the whole reserve array on sparc
-	 */
-	size = memblock_align_up(size, align);
+phys_addr_t __init memblock_alloc_base(phys_addr_t size, phys_addr_t align, phys_addr_t max_addr)
+{
+	phys_addr_t alloc;
 
-	/* We do a bottom-up search for a region with the right
-	 * nid since that's easier considering how memblock_nid_range()
-	 * works
-	 */
-	for (i = 0; i < mem->cnt; i++) {
-		phys_addr_t ret = memblock_alloc_nid_region(&mem->regions[i],
-					       size, align, nid);
-		if (ret != MEMBLOCK_ERROR)
-			return ret;
-	}
+	alloc = __memblock_alloc_base(size, align, max_addr);
 
-	return 0;
+	if (alloc == 0)
+		panic("ERROR: Failed to allocate 0x%llx bytes below 0x%llx.\n",
+		      (unsigned long long) size, (unsigned long long) max_addr);
+
+	return alloc;
+}
+
+phys_addr_t __init memblock_alloc(phys_addr_t size, phys_addr_t align)
+{
+	return memblock_alloc_base(size, align, MEMBLOCK_ALLOC_ACCESSIBLE);
 }
 
 phys_addr_t __init memblock_alloc_try_nid(phys_addr_t size, phys_addr_t align, int nid)
@@ -613,7 +769,7 @@ phys_addr_t __init memblock_alloc_try_nid(phys_addr_t size, phys_addr_t align, i
 
 	if (res)
 		return res;
-	return memblock_alloc_base(size, align, MEMBLOCK_ALLOC_ANYWHERE);
+	return memblock_alloc_base(size, align, MEMBLOCK_ALLOC_ACCESSIBLE);
 }
 
 
@@ -621,10 +777,9 @@ phys_addr_t __init memblock_alloc_try_nid(phys_addr_t size, phys_addr_t align, i
  * Remaining API functions
  */
 
-/* You must call memblock_analyze() before this. */
 phys_addr_t __init memblock_phys_mem_size(void)
 {
-	return memblock.memory_size;
+	return memblock.memory.total_size;
 }
 
 /* lowest address */
@@ -640,45 +795,28 @@ phys_addr_t __init_memblock memblock_end_of_DRAM(void)
 	return (memblock.memory.regions[idx].base + memblock.memory.regions[idx].size);
 }
 
-/* You must call memblock_analyze() after this. */
-void __init memblock_enforce_memory_limit(phys_addr_t memory_limit)
+void __init memblock_enforce_memory_limit(phys_addr_t limit)
 {
 	unsigned long i;
-	phys_addr_t limit;
-	struct memblock_region *p;
+	phys_addr_t max_addr = (phys_addr_t)ULLONG_MAX;
 
-	if (!memory_limit)
+	if (!limit)
 		return;
 
-	/* Truncate the memblock regions to satisfy the memory limit. */
-	limit = memory_limit;
+	/* find out max address */
 	for (i = 0; i < memblock.memory.cnt; i++) {
-		if (limit > memblock.memory.regions[i].size) {
-			limit -= memblock.memory.regions[i].size;
-			continue;
-		}
-
-		memblock.memory.regions[i].size = limit;
-		memblock.memory.cnt = i + 1;
-		break;
-	}
-
-	memory_limit = memblock_end_of_DRAM();
+		struct memblock_region *r = &memblock.memory.regions[i];
 
-	/* And truncate any reserves above the limit also. */
-	for (i = 0; i < memblock.reserved.cnt; i++) {
-		p = &memblock.reserved.regions[i];
-
-		if (p->base > memory_limit)
-			p->size = 0;
-		else if ((p->base + p->size) > memory_limit)
-			p->size = memory_limit - p->base;
-
-		if (p->size == 0) {
-			memblock_remove_region(&memblock.reserved, i);
-			i--;
+		if (limit <= r->size) {
+			max_addr = r->base + limit;
+			break;
 		}
+		limit -= r->size;
 	}
+
+	/* truncate both memory and reserved regions */
+	__memblock_remove(&memblock.memory, max_addr, (phys_addr_t)ULLONG_MAX);
+	__memblock_remove(&memblock.reserved, max_addr, (phys_addr_t)ULLONG_MAX);
 }
 
 static int __init_memblock memblock_search(struct memblock_type *type, phys_addr_t addr)
@@ -712,16 +850,18 @@ int __init_memblock memblock_is_memory(phys_addr_t addr)
 int __init_memblock memblock_is_region_memory(phys_addr_t base, phys_addr_t size)
 {
 	int idx = memblock_search(&memblock.memory, base);
+	phys_addr_t end = base + memblock_cap_size(base, &size);
 
 	if (idx == -1)
 		return 0;
 	return memblock.memory.regions[idx].base <= base &&
 		(memblock.memory.regions[idx].base +
-		 memblock.memory.regions[idx].size) >= (base + size);
+		 memblock.memory.regions[idx].size) >= end;
 }
 
 int __init_memblock memblock_is_region_reserved(phys_addr_t base, phys_addr_t size)
 {
+	memblock_cap_size(base, &size);
 	return memblock_overlaps_region(&memblock.reserved, base, size) >= 0;
 }
 
@@ -731,86 +871,45 @@ void __init_memblock memblock_set_current_limit(phys_addr_t limit)
 	memblock.current_limit = limit;
 }
 
-static void __init_memblock memblock_dump(struct memblock_type *region, char *name)
+static void __init_memblock memblock_dump(struct memblock_type *type, char *name)
 {
 	unsigned long long base, size;
 	int i;
 
-	pr_info(" %s.cnt  = 0x%lx\n", name, region->cnt);
+	pr_info(" %s.cnt  = 0x%lx\n", name, type->cnt);
 
-	for (i = 0; i < region->cnt; i++) {
-		base = region->regions[i].base;
-		size = region->regions[i].size;
-
-		pr_info(" %s[%#x]\t[%#016llx-%#016llx], %#llx bytes\n",
-		    name, i, base, base + size - 1, size);
+	for (i = 0; i < type->cnt; i++) {
+		struct memblock_region *rgn = &type->regions[i];
+		char nid_buf[32] = "";
+
+		base = rgn->base;
+		size = rgn->size;
+#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
+		if (memblock_get_region_node(rgn) != MAX_NUMNODES)
+			snprintf(nid_buf, sizeof(nid_buf), " on node %d",
+				 memblock_get_region_node(rgn));
+#endif
+		pr_info(" %s[%#x]\t[%#016llx-%#016llx], %#llx bytes%s\n",
+			name, i, base, base + size - 1, size, nid_buf);
 	}
 }
 
-void __init_memblock memblock_dump_all(void)
+void __init_memblock __memblock_dump_all(void)
 {
-	if (!memblock_debug)
-		return;
-
 	pr_info("MEMBLOCK configuration:\n");
-	pr_info(" memory size = 0x%llx\n", (unsigned long long)memblock.memory_size);
+	pr_info(" memory size = %#llx reserved size = %#llx\n",
+		(unsigned long long)memblock.memory.total_size,
+		(unsigned long long)memblock.reserved.total_size);
 
 	memblock_dump(&memblock.memory, "memory");
 	memblock_dump(&memblock.reserved, "reserved");
 }
 
-void __init memblock_analyze(void)
+void __init memblock_allow_resize(void)
 {
-	int i;
-
-	/* Check marker in the unused last array entry */
-	WARN_ON(memblock_memory_init_regions[INIT_MEMBLOCK_REGIONS].base
-		!= MEMBLOCK_INACTIVE);
-	WARN_ON(memblock_reserved_init_regions[INIT_MEMBLOCK_REGIONS].base
-		!= MEMBLOCK_INACTIVE);
-
-	memblock.memory_size = 0;
-
-	for (i = 0; i < memblock.memory.cnt; i++)
-		memblock.memory_size += memblock.memory.regions[i].size;
-
-	/* We allow resizing from there */
 	memblock_can_resize = 1;
 }
 
-void __init memblock_init(void)
-{
-	static int init_done __initdata = 0;
-
-	if (init_done)
-		return;
-	init_done = 1;
-
-	/* Hookup the initial arrays */
-	memblock.memory.regions	= memblock_memory_init_regions;
-	memblock.memory.max		= INIT_MEMBLOCK_REGIONS;
-	memblock.reserved.regions	= memblock_reserved_init_regions;
-	memblock.reserved.max	= INIT_MEMBLOCK_REGIONS;
-
-	/* Write a marker in the unused last array entry */
-	memblock.memory.regions[INIT_MEMBLOCK_REGIONS].base = MEMBLOCK_INACTIVE;
-	memblock.reserved.regions[INIT_MEMBLOCK_REGIONS].base = MEMBLOCK_INACTIVE;
-
-	/* Create a dummy zero size MEMBLOCK which will get coalesced away later.
-	 * This simplifies the memblock_add() code below...
-	 */
-	memblock.memory.regions[0].base = 0;
-	memblock.memory.regions[0].size = 0;
-	memblock.memory.cnt = 1;
-
-	/* Ditto. */
-	memblock.reserved.regions[0].base = 0;
-	memblock.reserved.regions[0].size = 0;
-	memblock.reserved.cnt = 1;
-
-	memblock.current_limit = MEMBLOCK_ALLOC_ANYWHERE;
-}
-
 static int __init early_memblock(char *p)
 {
 	if (p && strstr(p, "debug"))
@@ -819,7 +918,7 @@ static int __init early_memblock(char *p)
 }
 early_param("memblock", early_memblock);
 
-#if defined(CONFIG_DEBUG_FS) && !defined(ARCH_DISCARD_MEMBLOCK)
+#if defined(CONFIG_DEBUG_FS) && !defined(CONFIG_ARCH_DISCARD_MEMBLOCK)
 
 static int memblock_debug_show(struct seq_file *m, void *private)
 {
diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index 7fa41b4..24f0fc1 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -41,14 +41,13 @@ static void * __init __alloc_memory_core_early(int nid, u64 size, u64 align,
 	if (limit > memblock.current_limit)
 		limit = memblock.current_limit;
 
-	addr = find_memory_core_early(nid, size, align, goal, limit);
-
-	if (addr == MEMBLOCK_ERROR)
+	addr = memblock_find_in_range_node(goal, limit, size, align, nid);
+	if (!addr)
 		return NULL;
 
 	ptr = phys_to_virt(addr);
 	memset(ptr, 0, size);
-	memblock_x86_reserve_range(addr, addr + size, "BOOTMEM");
+	memblock_reserve(addr, size);
 	/*
 	 * The min_count is set to 0 so that bootmem allocated blocks
 	 * are never reported as leaks.
@@ -107,23 +106,27 @@ static void __init __free_pages_memory(unsigned long start, unsigned long end)
 		__free_pages_bootmem(pfn_to_page(i), 0);
 }
 
-unsigned long __init free_all_memory_core_early(int nodeid)
+unsigned long __init free_low_memory_core_early(int nodeid)
 {
-	int i;
-	u64 start, end;
 	unsigned long count = 0;
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
+	phys_addr_t start, end;
+	u64 i;
+
+	/* free reserved array temporarily so that it's treated as free area */
+	memblock_free_reserved_regions();
+
+	for_each_free_mem_range(i, MAX_NUMNODES, &start, &end, NULL) {
+		unsigned long start_pfn = PFN_UP(start);
+		unsigned long end_pfn = min_t(unsigned long,
+					      PFN_DOWN(end), max_low_pfn);
+		if (start_pfn < end_pfn) {
+			__free_pages_memory(start_pfn, end_pfn);
+			count += end_pfn - start_pfn;
+		}
 	}
 
+	/* put region array back? */
+	memblock_reserve_reserved_regions();
 	return count;
 }
 
@@ -137,7 +140,7 @@ unsigned long __init free_all_bootmem_node(pg_data_t *pgdat)
 {
 	register_page_bootmem_info_node(pgdat);
 
-	/* free_all_memory_core_early(MAX_NUMNODES) will be called later */
+	/* free_low_memory_core_early(MAX_NUMNODES) will be called later */
 	return 0;
 }
 
@@ -155,7 +158,7 @@ unsigned long __init free_all_bootmem(void)
 	 * Use MAX_NUMNODES will make sure all ranges in early_node_map[]
 	 *  will be used instead of only Node0 related
 	 */
-	return free_all_memory_core_early(MAX_NUMNODES);
+	return free_low_memory_core_early(MAX_NUMNODES);
 }
 
 /**
@@ -172,7 +175,7 @@ void __init free_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
 			      unsigned long size)
 {
 	kmemleak_free_part(__va(physaddr), size);
-	memblock_x86_free_range(physaddr, physaddr + size);
+	memblock_free(physaddr, size);
 }
 
 /**
@@ -187,7 +190,7 @@ void __init free_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
 void __init free_bootmem(unsigned long addr, unsigned long size)
 {
 	kmemleak_free_part(__va(addr), size);
-	memblock_x86_free_range(addr, addr + size);
+	memblock_free(addr, size);
 }
 
 static void * __init ___alloc_bootmem_nopanic(unsigned long size,
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2b8ba3a..bdc804c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -181,39 +181,17 @@ static unsigned long __meminitdata nr_kernel_pages;
 static unsigned long __meminitdata nr_all_pages;
 static unsigned long __meminitdata dma_reserve;
 
-#ifdef CONFIG_ARCH_POPULATES_NODE_MAP
-  /*
-   * MAX_ACTIVE_REGIONS determines the maximum number of distinct
-   * ranges of memory (RAM) that may be registered with add_active_range().
-   * Ranges passed to add_active_range() will be merged if possible
-   * so the number of times add_active_range() can be called is
-   * related to the number of nodes and the number of holes
-   */
-  #ifdef CONFIG_MAX_ACTIVE_REGIONS
-    /* Allow an architecture to set MAX_ACTIVE_REGIONS to save memory */
-    #define MAX_ACTIVE_REGIONS CONFIG_MAX_ACTIVE_REGIONS
-  #else
-    #if MAX_NUMNODES >= 32
-      /* If there can be many nodes, allow up to 50 holes per node */
-      #define MAX_ACTIVE_REGIONS (MAX_NUMNODES*50)
-    #else
-      /* By default, allow up to 256 distinct regions */
-      #define MAX_ACTIVE_REGIONS 256
-    #endif
-  #endif
-
-  static struct node_active_region __meminitdata early_node_map[MAX_ACTIVE_REGIONS];
-  static int __meminitdata nr_nodemap_entries;
-  static unsigned long __meminitdata arch_zone_lowest_possible_pfn[MAX_NR_ZONES];
-  static unsigned long __meminitdata arch_zone_highest_possible_pfn[MAX_NR_ZONES];
-  static unsigned long __initdata required_kernelcore;
-  static unsigned long __initdata required_movablecore;
-  static unsigned long __meminitdata zone_movable_pfn[MAX_NUMNODES];
-
-  /* movable_zone is the "real" zone pages in ZONE_MOVABLE are taken from */
-  int movable_zone;
-  EXPORT_SYMBOL(movable_zone);
-#endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
+#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
+static unsigned long __meminitdata arch_zone_lowest_possible_pfn[MAX_NR_ZONES];
+static unsigned long __meminitdata arch_zone_highest_possible_pfn[MAX_NR_ZONES];
+static unsigned long __initdata required_kernelcore;
+static unsigned long __initdata required_movablecore;
+static unsigned long __meminitdata zone_movable_pfn[MAX_NUMNODES];
+
+/* movable_zone is the "real" zone pages in ZONE_MOVABLE are taken from */
+int movable_zone;
+EXPORT_SYMBOL(movable_zone);
+#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
 #if MAX_NUMNODES > 1
 int nr_node_ids __read_mostly = MAX_NUMNODES;
@@ -706,10 +684,10 @@ void __meminit __free_pages_bootmem(struct page *page, unsigned int order)
 		int loop;
 
 		prefetchw(page);
-		for (loop = 0; loop < BITS_PER_LONG; loop++) {
+		for (loop = 0; loop < (1 << order); loop++) {
 			struct page *p = &page[loop];
 
-			if (loop + 1 < BITS_PER_LONG)
+			if (loop + 1 < (1 << order))
 				prefetchw(p + 1);
 			__ClearPageReserved(p);
 			set_page_count(p, 0);
@@ -3737,35 +3715,7 @@ __meminit int init_currently_empty_zone(struct zone *zone,
 	return 0;
 }
 
-#ifdef CONFIG_ARCH_POPULATES_NODE_MAP
-/*
- * Basic iterator support. Return the first range of PFNs for a node
- * Note: nid == MAX_NUMNODES returns first region regardless of node
- */
-static int __meminit first_active_region_index_in_nid(int nid)
-{
-	int i;
-
-	for (i = 0; i < nr_nodemap_entries; i++)
-		if (nid == MAX_NUMNODES || early_node_map[i].nid == nid)
-			return i;
-
-	return -1;
-}
-
-/*
- * Basic iterator support. Return the next active range of PFNs for a node
- * Note: nid == MAX_NUMNODES returns next region regardless of node
- */
-static int __meminit next_active_region_index_in_nid(int index, int nid)
-{
-	for (index = index + 1; index < nr_nodemap_entries; index++)
-		if (nid == MAX_NUMNODES || early_node_map[index].nid == nid)
-			return index;
-
-	return -1;
-}
-
+#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 #ifndef CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
 /*
  * Required by SPARSEMEM. Given a PFN, return what node the PFN is on.
@@ -3775,15 +3725,12 @@ static int __meminit next_active_region_index_in_nid(int index, int nid)
  */
 int __meminit __early_pfn_to_nid(unsigned long pfn)
 {
-	int i;
-
-	for (i = 0; i < nr_nodemap_entries; i++) {
-		unsigned long start_pfn = early_node_map[i].start_pfn;
-		unsigned long end_pfn = early_node_map[i].end_pfn;
+	unsigned long start_pfn, end_pfn;
+	int i, nid;
 
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid)
 		if (start_pfn <= pfn && pfn < end_pfn)
-			return early_node_map[i].nid;
-	}
+			return nid;
 	/* This is a memory hole */
 	return -1;
 }
@@ -3812,11 +3759,6 @@ bool __meminit early_pfn_in_nid(unsigned long pfn, int node)
 }
 #endif
 
-/* Basic iterator support to walk early_node_map[] */
-#define for_each_active_range_index_in_nid(i, nid) \
-	for (i = first_active_region_index_in_nid(nid); i != -1; \
-				i = next_active_region_index_in_nid(i, nid))
-
 /**
  * free_bootmem_with_active_regions - Call free_bootmem_node for each active range
  * @nid: The node to free memory on. If MAX_NUMNODES, all nodes are freed.
@@ -3826,122 +3768,34 @@ bool __meminit early_pfn_in_nid(unsigned long pfn, int node)
  * add_active_ranges() contain no holes and may be freed, this
  * this function may be used instead of calling free_bootmem() manually.
  */
-void __init free_bootmem_with_active_regions(int nid,
-						unsigned long max_low_pfn)
-{
-	int i;
-
-	for_each_active_range_index_in_nid(i, nid) {
-		unsigned long size_pages = 0;
-		unsigned long end_pfn = early_node_map[i].end_pfn;
-
-		if (early_node_map[i].start_pfn >= max_low_pfn)
-			continue;
-
-		if (end_pfn > max_low_pfn)
-			end_pfn = max_low_pfn;
-
-		size_pages = end_pfn - early_node_map[i].start_pfn;
-		free_bootmem_node(NODE_DATA(early_node_map[i].nid),
-				PFN_PHYS(early_node_map[i].start_pfn),
-				size_pages << PAGE_SHIFT);
-	}
-}
-
-#ifdef CONFIG_HAVE_MEMBLOCK
-/*
- * Basic iterator support. Return the last range of PFNs for a node
- * Note: nid == MAX_NUMNODES returns last region regardless of node
- */
-static int __meminit last_active_region_index_in_nid(int nid)
+void __init free_bootmem_with_active_regions(int nid, unsigned long max_low_pfn)
 {
-	int i;
-
-	for (i = nr_nodemap_entries - 1; i >= 0; i--)
-		if (nid == MAX_NUMNODES || early_node_map[i].nid == nid)
-			return i;
-
-	return -1;
-}
-
-/*
- * Basic iterator support. Return the previous active range of PFNs for a node
- * Note: nid == MAX_NUMNODES returns next region regardless of node
- */
-static int __meminit previous_active_region_index_in_nid(int index, int nid)
-{
-	for (index = index - 1; index >= 0; index--)
-		if (nid == MAX_NUMNODES || early_node_map[index].nid == nid)
-			return index;
-
-	return -1;
-}
-
-#define for_each_active_range_index_in_nid_reverse(i, nid) \
-	for (i = last_active_region_index_in_nid(nid); i != -1; \
-				i = previous_active_region_index_in_nid(i, nid))
-
-u64 __init find_memory_core_early(int nid, u64 size, u64 align,
-					u64 goal, u64 limit)
-{
-	int i;
-
-	/* Need to go over early_node_map to find out good range for node */
-	for_each_active_range_index_in_nid_reverse(i, nid) {
-		u64 addr;
-		u64 ei_start, ei_last;
-		u64 final_start, final_end;
-
-		ei_last = early_node_map[i].end_pfn;
-		ei_last <<= PAGE_SHIFT;
-		ei_start = early_node_map[i].start_pfn;
-		ei_start <<= PAGE_SHIFT;
-
-		final_start = max(ei_start, goal);
-		final_end = min(ei_last, limit);
-
-		if (final_start >= final_end)
-			continue;
-
-		addr = memblock_find_in_range(final_start, final_end, size, align);
+	unsigned long start_pfn, end_pfn;
+	int i, this_nid;
 
-		if (addr == MEMBLOCK_ERROR)
-			continue;
+	for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, &this_nid) {
+		start_pfn = min(start_pfn, max_low_pfn);
+		end_pfn = min(end_pfn, max_low_pfn);
 
-		return addr;
+		if (start_pfn < end_pfn)
+			free_bootmem_node(NODE_DATA(this_nid),
+					  PFN_PHYS(start_pfn),
+					  (end_pfn - start_pfn) << PAGE_SHIFT);
 	}
-
-	return MEMBLOCK_ERROR;
 }
-#endif
 
 int __init add_from_early_node_map(struct range *range, int az,
 				   int nr_range, int nid)
 {
+	unsigned long start_pfn, end_pfn;
 	int i;
-	u64 start, end;
 
 	/* need to go over early_node_map to find out good range for node */
-	for_each_active_range_index_in_nid(i, nid) {
-		start = early_node_map[i].start_pfn;
-		end = early_node_map[i].end_pfn;
-		nr_range = add_range(range, az, nr_range, start, end);
-	}
+	for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL)
+		nr_range = add_range(range, az, nr_range, start_pfn, end_pfn);
 	return nr_range;
 }
 
-void __init work_with_active_regions(int nid, work_fn_t work_fn, void *data)
-{
-	int i;
-	int ret;
-
-	for_each_active_range_index_in_nid(i, nid) {
-		ret = work_fn(early_node_map[i].start_pfn,
-			      early_node_map[i].end_pfn, data);
-		if (ret)
-			break;
-	}
-}
 /**
  * sparse_memory_present_with_active_regions - Call memory_present for each active range
  * @nid: The node to call memory_present for. If MAX_NUMNODES, all nodes will be used.
@@ -3952,12 +3806,11 @@ void __init work_with_active_regions(int nid, work_fn_t work_fn, void *data)
  */
 void __init sparse_memory_present_with_active_regions(int nid)
 {
-	int i;
+	unsigned long start_pfn, end_pfn;
+	int i, this_nid;
 
-	for_each_active_range_index_in_nid(i, nid)
-		memory_present(early_node_map[i].nid,
-				early_node_map[i].start_pfn,
-				early_node_map[i].end_pfn);
+	for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, &this_nid)
+		memory_present(this_nid, start_pfn, end_pfn);
 }
 
 /**
@@ -3974,13 +3827,15 @@ void __init sparse_memory_present_with_active_regions(int nid)
 void __meminit get_pfn_range_for_nid(unsigned int nid,
 			unsigned long *start_pfn, unsigned long *end_pfn)
 {
+	unsigned long this_start_pfn, this_end_pfn;
 	int i;
+
 	*start_pfn = -1UL;
 	*end_pfn = 0;
 
-	for_each_active_range_index_in_nid(i, nid) {
-		*start_pfn = min(*start_pfn, early_node_map[i].start_pfn);
-		*end_pfn = max(*end_pfn, early_node_map[i].end_pfn);
+	for_each_mem_pfn_range(i, nid, &this_start_pfn, &this_end_pfn, NULL) {
+		*start_pfn = min(*start_pfn, this_start_pfn);
+		*end_pfn = max(*end_pfn, this_end_pfn);
 	}
 
 	if (*start_pfn == -1UL)
@@ -4083,46 +3938,16 @@ unsigned long __meminit __absent_pages_in_range(int nid,
 				unsigned long range_start_pfn,
 				unsigned long range_end_pfn)
 {
-	int i = 0;
-	unsigned long prev_end_pfn = 0, hole_pages = 0;
-	unsigned long start_pfn;
-
-	/* Find the end_pfn of the first active range of pfns in the node */
-	i = first_active_region_index_in_nid(nid);
-	if (i == -1)
-		return 0;
-
-	prev_end_pfn = min(early_node_map[i].start_pfn, range_end_pfn);
-
-	/* Account for ranges before physical memory on this node */
-	if (early_node_map[i].start_pfn > range_start_pfn)
-		hole_pages = prev_end_pfn - range_start_pfn;
-
-	/* Find all holes for the zone within the node */
-	for (; i != -1; i = next_active_region_index_in_nid(i, nid)) {
-
-		/* No need to continue if prev_end_pfn is outside the zone */
-		if (prev_end_pfn >= range_end_pfn)
-			break;
-
-		/* Make sure the end of the zone is not within the hole */
-		start_pfn = min(early_node_map[i].start_pfn, range_end_pfn);
-		prev_end_pfn = max(prev_end_pfn, range_start_pfn);
+	unsigned long nr_absent = range_end_pfn - range_start_pfn;
+	unsigned long start_pfn, end_pfn;
+	int i;
 
-		/* Update the hole size cound and move on */
-		if (start_pfn > range_start_pfn) {
-			BUG_ON(prev_end_pfn > start_pfn);
-			hole_pages += start_pfn - prev_end_pfn;
-		}
-		prev_end_pfn = early_node_map[i].end_pfn;
+	for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
+		start_pfn = clamp(start_pfn, range_start_pfn, range_end_pfn);
+		end_pfn = clamp(end_pfn, range_start_pfn, range_end_pfn);
+		nr_absent -= end_pfn - start_pfn;
 	}
-
-	/* Account for ranges past physical memory on this node */
-	if (range_end_pfn > prev_end_pfn)
-		hole_pages += range_end_pfn -
-				max(range_start_pfn, prev_end_pfn);
-
-	return hole_pages;
+	return nr_absent;
 }
 
 /**
@@ -4143,14 +3968,14 @@ static unsigned long __meminit zone_absent_pages_in_node(int nid,
 					unsigned long zone_type,
 					unsigned long *ignored)
 {
+	unsigned long zone_low = arch_zone_lowest_possible_pfn[zone_type];
+	unsigned long zone_high = arch_zone_highest_possible_pfn[zone_type];
 	unsigned long node_start_pfn, node_end_pfn;
 	unsigned long zone_start_pfn, zone_end_pfn;
 
 	get_pfn_range_for_nid(nid, &node_start_pfn, &node_end_pfn);
-	zone_start_pfn = max(arch_zone_lowest_possible_pfn[zone_type],
-							node_start_pfn);
-	zone_end_pfn = min(arch_zone_highest_possible_pfn[zone_type],
-							node_end_pfn);
+	zone_start_pfn = clamp(node_start_pfn, zone_low, zone_high);
+	zone_end_pfn = clamp(node_end_pfn, zone_low, zone_high);
 
 	adjust_zone_range_for_zone_movable(nid, zone_type,
 			node_start_pfn, node_end_pfn,
@@ -4158,7 +3983,7 @@ static unsigned long __meminit zone_absent_pages_in_node(int nid,
 	return __absent_pages_in_range(nid, zone_start_pfn, zone_end_pfn);
 }
 
-#else
+#else /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 static inline unsigned long __meminit zone_spanned_pages_in_node(int nid,
 					unsigned long zone_type,
 					unsigned long *zones_size)
@@ -4176,7 +4001,7 @@ static inline unsigned long __meminit zone_absent_pages_in_node(int nid,
 	return zholes_size[zone_type];
 }
 
-#endif
+#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
 static void __meminit calculate_node_totalpages(struct pglist_data *pgdat,
 		unsigned long *zones_size, unsigned long *zholes_size)
@@ -4399,10 +4224,10 @@ static void __init_refok alloc_node_mem_map(struct pglist_data *pgdat)
 	 */
 	if (pgdat == NODE_DATA(0)) {
 		mem_map = NODE_DATA(0)->node_mem_map;
-#ifdef CONFIG_ARCH_POPULATES_NODE_MAP
+#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 		if (page_to_pfn(mem_map) != pgdat->node_start_pfn)
 			mem_map -= (pgdat->node_start_pfn - ARCH_PFN_OFFSET);
-#endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
+#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 	}
 #endif
 #endif /* CONFIG_FLAT_NODE_MEM_MAP */
@@ -4427,7 +4252,7 @@ void __paginginit free_area_init_node(int nid, unsigned long *zones_size,
 	free_area_init_core(pgdat, zones_size, zholes_size);
 }
 
-#ifdef CONFIG_ARCH_POPULATES_NODE_MAP
+#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 
 #if MAX_NUMNODES > 1
 /*
@@ -4449,170 +4274,6 @@ static inline void setup_nr_node_ids(void)
 #endif
 
 /**
- * add_active_range - Register a range of PFNs backed by physical memory
- * @nid: The node ID the range resides on
- * @start_pfn: The start PFN of the available physical memory
- * @end_pfn: The end PFN of the available physical memory
- *
- * These ranges are stored in an early_node_map[] and later used by
- * free_area_init_nodes() to calculate zone sizes and holes. If the
- * range spans a memory hole, it is up to the architecture to ensure
- * the memory is not freed by the bootmem allocator. If possible
- * the range being registered will be merged with existing ranges.
- */
-void __init add_active_range(unsigned int nid, unsigned long start_pfn,
-						unsigned long end_pfn)
-{
-	int i;
-
-	mminit_dprintk(MMINIT_TRACE, "memory_register",
-			"Entering add_active_range(%d, %#lx, %#lx) "
-			"%d entries of %d used\n",
-			nid, start_pfn, end_pfn,
-			nr_nodemap_entries, MAX_ACTIVE_REGIONS);
-
-	mminit_validate_memmodel_limits(&start_pfn, &end_pfn);
-
-	/* Merge with existing active regions if possible */
-	for (i = 0; i < nr_nodemap_entries; i++) {
-		if (early_node_map[i].nid != nid)
-			continue;
-
-		/* Skip if an existing region covers this new one */
-		if (start_pfn >= early_node_map[i].start_pfn &&
-				end_pfn <= early_node_map[i].end_pfn)
-			return;
-
-		/* Merge forward if suitable */
-		if (start_pfn <= early_node_map[i].end_pfn &&
-				end_pfn > early_node_map[i].end_pfn) {
-			early_node_map[i].end_pfn = end_pfn;
-			return;
-		}
-
-		/* Merge backward if suitable */
-		if (start_pfn < early_node_map[i].start_pfn &&
-				end_pfn >= early_node_map[i].start_pfn) {
-			early_node_map[i].start_pfn = start_pfn;
-			return;
-		}
-	}
-
-	/* Check that early_node_map is large enough */
-	if (i >= MAX_ACTIVE_REGIONS) {
-		printk(KERN_CRIT "More than %d memory regions, truncating\n",
-							MAX_ACTIVE_REGIONS);
-		return;
-	}
-
-	early_node_map[i].nid = nid;
-	early_node_map[i].start_pfn = start_pfn;
-	early_node_map[i].end_pfn = end_pfn;
-	nr_nodemap_entries = i + 1;
-}
-
-/**
- * remove_active_range - Shrink an existing registered range of PFNs
- * @nid: The node id the range is on that should be shrunk
- * @start_pfn: The new PFN of the range
- * @end_pfn: The new PFN of the range
- *
- * i386 with NUMA use alloc_remap() to store a node_mem_map on a local node.
- * The map is kept near the end physical page range that has already been
- * registered. This function allows an arch to shrink an existing registered
- * range.
- */
-void __init remove_active_range(unsigned int nid, unsigned long start_pfn,
-				unsigned long end_pfn)
-{
-	int i, j;
-	int removed = 0;
-
-	printk(KERN_DEBUG "remove_active_range (%d, %lu, %lu)\n",
-			  nid, start_pfn, end_pfn);
-
-	/* Find the old active region end and shrink */
-	for_each_active_range_index_in_nid(i, nid) {
-		if (early_node_map[i].start_pfn >= start_pfn &&
-		    early_node_map[i].end_pfn <= end_pfn) {
-			/* clear it */
-			early_node_map[i].start_pfn = 0;
-			early_node_map[i].end_pfn = 0;
-			removed = 1;
-			continue;
-		}
-		if (early_node_map[i].start_pfn < start_pfn &&
-		    early_node_map[i].end_pfn > start_pfn) {
-			unsigned long temp_end_pfn = early_node_map[i].end_pfn;
-			early_node_map[i].end_pfn = start_pfn;
-			if (temp_end_pfn > end_pfn)
-				add_active_range(nid, end_pfn, temp_end_pfn);
-			continue;
-		}
-		if (early_node_map[i].start_pfn >= start_pfn &&
-		    early_node_map[i].end_pfn > end_pfn &&
-		    early_node_map[i].start_pfn < end_pfn) {
-			early_node_map[i].start_pfn = end_pfn;
-			continue;
-		}
-	}
-
-	if (!removed)
-		return;
-
-	/* remove the blank ones */
-	for (i = nr_nodemap_entries - 1; i > 0; i--) {
-		if (early_node_map[i].nid != nid)
-			continue;
-		if (early_node_map[i].end_pfn)
-			continue;
-		/* we found it, get rid of it */
-		for (j = i; j < nr_nodemap_entries - 1; j++)
-			memcpy(&early_node_map[j], &early_node_map[j+1],
-				sizeof(early_node_map[j]));
-		j = nr_nodemap_entries - 1;
-		memset(&early_node_map[j], 0, sizeof(early_node_map[j]));
-		nr_nodemap_entries--;
-	}
-}
-
-/**
- * remove_all_active_ranges - Remove all currently registered regions
- *
- * During discovery, it may be found that a table like SRAT is invalid
- * and an alternative discovery method must be used. This function removes
- * all currently registered regions.
- */
-void __init remove_all_active_ranges(void)
-{
-	memset(early_node_map, 0, sizeof(early_node_map));
-	nr_nodemap_entries = 0;
-}
-
-/* Compare two active node_active_regions */
-static int __init cmp_node_active_region(const void *a, const void *b)
-{
-	struct node_active_region *arange = (struct node_active_region *)a;
-	struct node_active_region *brange = (struct node_active_region *)b;
-
-	/* Done this way to avoid overflows */
-	if (arange->start_pfn > brange->start_pfn)
-		return 1;
-	if (arange->start_pfn < brange->start_pfn)
-		return -1;
-
-	return 0;
-}
-
-/* sort the node_map by start_pfn */
-void __init sort_node_map(void)
-{
-	sort(early_node_map, (size_t)nr_nodemap_entries,
-			sizeof(struct node_active_region),
-			cmp_node_active_region, NULL);
-}
-
-/**
  * node_map_pfn_alignment - determine the maximum internode alignment
  *
  * This function should be called after node map is populated and sorted.
@@ -4634,15 +4295,11 @@ void __init sort_node_map(void)
 unsigned long __init node_map_pfn_alignment(void)
 {
 	unsigned long accl_mask = 0, last_end = 0;
+	unsigned long start, end, mask;
 	int last_nid = -1;
-	int i;
-
-	for_each_active_range_index_in_nid(i, MAX_NUMNODES) {
-		int nid = early_node_map[i].nid;
-		unsigned long start = early_node_map[i].start_pfn;
-		unsigned long end = early_node_map[i].end_pfn;
-		unsigned long mask;
+	int i, nid;
 
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start, &end, &nid) {
 		if (!start || last_nid < 0 || last_nid == nid) {
 			last_nid = nid;
 			last_end = end;
@@ -4669,12 +4326,12 @@ unsigned long __init node_map_pfn_alignment(void)
 /* Find the lowest pfn for a node */
 static unsigned long __init find_min_pfn_for_node(int nid)
 {
-	int i;
 	unsigned long min_pfn = ULONG_MAX;
+	unsigned long start_pfn;
+	int i;
 
-	/* Assuming a sorted map, the first range found has the starting pfn */
-	for_each_active_range_index_in_nid(i, nid)
-		min_pfn = min(min_pfn, early_node_map[i].start_pfn);
+	for_each_mem_pfn_range(i, nid, &start_pfn, NULL, NULL)
+		min_pfn = min(min_pfn, start_pfn);
 
 	if (min_pfn == ULONG_MAX) {
 		printk(KERN_WARNING
@@ -4703,15 +4360,16 @@ unsigned long __init find_min_pfn_with_active_regions(void)
  */
 static unsigned long __init early_calculate_totalpages(void)
 {
-	int i;
 	unsigned long totalpages = 0;
+	unsigned long start_pfn, end_pfn;
+	int i, nid;
+
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
+		unsigned long pages = end_pfn - start_pfn;
 
-	for (i = 0; i < nr_nodemap_entries; i++) {
-		unsigned long pages = early_node_map[i].end_pfn -
-						early_node_map[i].start_pfn;
 		totalpages += pages;
 		if (pages)
-			node_set_state(early_node_map[i].nid, N_HIGH_MEMORY);
+			node_set_state(nid, N_HIGH_MEMORY);
 	}
   	return totalpages;
 }
@@ -4766,6 +4424,8 @@ restart:
 	/* Spread kernelcore memory as evenly as possible throughout nodes */
 	kernelcore_node = required_kernelcore / usable_nodes;
 	for_each_node_state(nid, N_HIGH_MEMORY) {
+		unsigned long start_pfn, end_pfn;
+
 		/*
 		 * Recalculate kernelcore_node if the division per node
 		 * now exceeds what is necessary to satisfy the requested
@@ -4782,13 +4442,10 @@ restart:
 		kernelcore_remaining = kernelcore_node;
 
 		/* Go through each range of PFNs within this node */
-		for_each_active_range_index_in_nid(i, nid) {
-			unsigned long start_pfn, end_pfn;
+		for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
 			unsigned long size_pages;
 
-			start_pfn = max(early_node_map[i].start_pfn,
-						zone_movable_pfn[nid]);
-			end_pfn = early_node_map[i].end_pfn;
+			start_pfn = max(start_pfn, zone_movable_pfn[nid]);
 			if (start_pfn >= end_pfn)
 				continue;
 
@@ -4890,11 +4547,8 @@ static void check_for_regular_memory(pg_data_t *pgdat)
  */
 void __init free_area_init_nodes(unsigned long *max_zone_pfn)
 {
-	unsigned long nid;
-	int i;
-
-	/* Sort early_node_map as initialisation assumes it is sorted */
-	sort_node_map();
+	unsigned long start_pfn, end_pfn;
+	int i, nid;
 
 	/* Record where the zone boundaries are */
 	memset(arch_zone_lowest_possible_pfn, 0,
@@ -4941,11 +4595,9 @@ void __init free_area_init_nodes(unsigned long *max_zone_pfn)
 	}
 
 	/* Print out the early_node_map[] */
-	printk("early_node_map[%d] active PFN ranges\n", nr_nodemap_entries);
-	for (i = 0; i < nr_nodemap_entries; i++)
-		printk("  %3d: %0#10lx -> %0#10lx\n", early_node_map[i].nid,
-						early_node_map[i].start_pfn,
-						early_node_map[i].end_pfn);
+	printk("Early memory PFN ranges\n");
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid)
+		printk("  %3d: %0#10lx -> %0#10lx\n", nid, start_pfn, end_pfn);
 
 	/* Initialise every node */
 	mminit_verify_pageflags_layout();
@@ -4998,7 +4650,7 @@ static int __init cmdline_parse_movablecore(char *p)
 early_param("kernelcore", cmdline_parse_kernelcore);
 early_param("movablecore", cmdline_parse_movablecore);
 
-#endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
+#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
 /**
  * set_dma_reserve - set the specified number of pages reserved in the first zone
