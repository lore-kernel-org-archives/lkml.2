Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477Ab0GIR2Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 13:28:25 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:59901 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755994Ab0GIR2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 13:28:22 -0400
Message-ID: <4C375B3D.7070603@kernel.org>
Date: Fri, 09 Jul 2010 10:24:13 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v2 01/49] lmb: rename to memblock
References: <1278455982-24621-1-git-send-email-yinghai@kernel.org>
In-Reply-To: <1278455982-24621-1-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4C375C05.0186,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

via following scripts

      FILES=$(find * -type f | grep -vE 'oprofile|[^K]config')

      sed -i \
        -e 's/lmb/memblock/g' \
        -e 's/LMB/MEMBLOCK/g' \
        $FILES

      for N in $(find . -name lmb.[ch]); do
        M=$(echo $N | sed 's/lmb/memblock/g')
        mv $N $M
      done

and remove some wrong change like lmbench and dlmb etc.

also move memblock.c from lib/ to mm/

-v2: remove microblaze dts wrong change

Suggested-by: Ingo Molnar <mingo@elte.hu>
Acked-by: "H. Peter Anvin" <hpa@zytor.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Michal Simek <monstr@monstr.eu> 
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 Documentation/kernel-parameters.txt               |    2 +-
 arch/microblaze/Kconfig                           |    2 +-
 arch/microblaze/include/asm/{lmb.h => memblock.h} |   10 +-
 arch/microblaze/kernel/prom.c                     |   14 +-
 arch/microblaze/mm/init.c                         |   40 +-
 arch/powerpc/Kconfig                              |    2 +-
 arch/powerpc/include/asm/abs_addr.h               |    2 +-
 arch/powerpc/include/asm/lmb.h                    |   15 -
 arch/powerpc/include/asm/memblock.h               |   15 +
 arch/powerpc/kernel/btext.c                       |    2 +-
 arch/powerpc/kernel/crash.c                       |    2 +-
 arch/powerpc/kernel/crash_dump.c                  |    4 +-
 arch/powerpc/kernel/dma-swiotlb.c                 |    2 +-
 arch/powerpc/kernel/dma.c                         |    4 +-
 arch/powerpc/kernel/machine_kexec.c               |   12 +-
 arch/powerpc/kernel/paca.c                        |    8 +-
 arch/powerpc/kernel/prom.c                        |   62 ++--
 arch/powerpc/kernel/rtas.c                        |    6 +-
 arch/powerpc/kernel/setup-common.c                |    2 +-
 arch/powerpc/kernel/setup_32.c                    |   16 +-
 arch/powerpc/kernel/setup_64.c                    |   20 +-
 arch/powerpc/kernel/vdso.c                        |    4 +-
 arch/powerpc/mm/40x_mmu.c                         |    2 +-
 arch/powerpc/mm/hash_utils_64.c                   |   26 +-
 arch/powerpc/mm/init_32.c                         |   16 +-
 arch/powerpc/mm/init_64.c                         |    2 +-
 arch/powerpc/mm/mem.c                             |   78 ++--
 arch/powerpc/mm/numa.c                            |   84 ++--
 arch/powerpc/mm/pgtable_32.c                      |    6 +-
 arch/powerpc/mm/pgtable_64.c                      |    4 +-
 arch/powerpc/mm/ppc_mmu_32.c                      |    4 +-
 arch/powerpc/mm/stab.c                            |    4 +-
 arch/powerpc/mm/tlb_nohash.c                      |    4 +-
 arch/powerpc/platforms/85xx/corenet_ds.c          |    4 +-
 arch/powerpc/platforms/85xx/mpc8536_ds.c          |    4 +-
 arch/powerpc/platforms/85xx/mpc85xx_ds.c          |    4 +-
 arch/powerpc/platforms/85xx/mpc85xx_mds.c         |    4 +-
 arch/powerpc/platforms/86xx/mpc86xx_hpcn.c        |    4 +-
 arch/powerpc/platforms/cell/iommu.c               |   10 +-
 arch/powerpc/platforms/embedded6xx/wii.c          |   12 +-
 arch/powerpc/platforms/maple/setup.c              |    2 +-
 arch/powerpc/platforms/pasemi/iommu.c             |    4 +-
 arch/powerpc/platforms/powermac/setup.c           |    4 +-
 arch/powerpc/platforms/ps3/htab.c                 |    2 +-
 arch/powerpc/platforms/ps3/mm.c                   |    6 +-
 arch/powerpc/platforms/ps3/os-area.c              |    4 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c   |   38 +-
 arch/powerpc/platforms/pseries/iommu.c            |    2 +-
 arch/powerpc/platforms/pseries/phyp_dump.c        |    4 +-
 arch/powerpc/sysdev/dart_iommu.c                  |    8 +-
 arch/powerpc/sysdev/fsl_pci.c                     |    4 +-
 arch/sh/Kconfig                                   |    2 +-
 arch/sh/include/asm/lmb.h                         |    6 -
 arch/sh/include/asm/memblock.h                    |    6 +
 arch/sh/kernel/machine_kexec.c                    |   18 +-
 arch/sh/kernel/setup.c                            |    8 +-
 arch/sh/mm/init.c                                 |   40 +-
 arch/sh/mm/numa.c                                 |    8 +-
 arch/sparc/Kconfig                                |    2 +-
 arch/sparc/include/asm/lmb.h                      |   10 -
 arch/sparc/include/asm/memblock.h                 |   10 +
 arch/sparc/kernel/mdesc.c                         |   16 +-
 arch/sparc/kernel/prom_64.c                       |    4 +-
 arch/sparc/mm/init_64.c                           |   54 +-
 include/linux/lmb.h                               |   89 ----
 include/linux/memblock.h                          |   89 ++++
 lib/Kconfig                                       |    3 -
 lib/Makefile                                      |    2 -
 lib/lmb.c                                         |  541 ---------------------
 mm/Kconfig                                        |    3 +
 mm/Makefile                                       |    2 +
 mm/memblock.c                                     |  541 +++++++++++++++++++++
 73 files changed, 1025 insertions(+), 1025 deletions(-)
 rename arch/microblaze/include/asm/{lmb.h => memblock.h} (57%)
 delete mode 100644 arch/powerpc/include/asm/lmb.h
 create mode 100644 arch/powerpc/include/asm/memblock.h
 delete mode 100644 arch/sh/include/asm/lmb.h
 create mode 100644 arch/sh/include/asm/memblock.h
 delete mode 100644 arch/sparc/include/asm/lmb.h
 create mode 100644 arch/sparc/include/asm/memblock.h
 delete mode 100644 include/linux/lmb.h
 create mode 100644 include/linux/memblock.h
 delete mode 100644 lib/lmb.c
 create mode 100644 mm/memblock.c

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 616414a..94c65b2 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1265,7 +1265,7 @@ and is between 256 and 4096 characters. It is defined in the file
 			If there are multiple matching configurations changing
 			the same attribute, the last one is used.
 
-	lmb=debug	[KNL] Enable lmb debug messages.
+	memblock=debug	[KNL] Enable memblock debug messages.
 
 	load_ramdisk=	[RAM] List of ramdisks to load from floppy
 			See Documentation/blockdev/ramdisk.txt.
diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index 76818f9..505a085 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -5,7 +5,7 @@ mainmenu "Linux/Microblaze Kernel Configuration"
 
 config MICROBLAZE
 	def_bool y
-	select HAVE_LMB
+	select HAVE_MEMBLOCK
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_FUNCTION_GRAPH_TRACER
diff --git a/arch/microblaze/include/asm/lmb.h b/arch/microblaze/include/asm/memblock.h
similarity index 57%
rename from arch/microblaze/include/asm/lmb.h
rename to arch/microblaze/include/asm/memblock.h
index a0a0a92..f9c2fa3 100644
--- a/arch/microblaze/include/asm/lmb.h
+++ b/arch/microblaze/include/asm/memblock.h
@@ -6,12 +6,12 @@
  * for more details.
  */
 
-#ifndef _ASM_MICROBLAZE_LMB_H
-#define _ASM_MICROBLAZE_LMB_H
+#ifndef _ASM_MICROBLAZE_MEMBLOCK_H
+#define _ASM_MICROBLAZE_MEMBLOCK_H
 
-/* LMB limit is OFF */
-#define LMB_REAL_LIMIT	0xFFFFFFFF
+/* MEMBLOCK limit is OFF */
+#define MEMBLOCK_REAL_LIMIT	0xFFFFFFFF
 
-#endif /* _ASM_MICROBLAZE_LMB_H */
+#endif /* _ASM_MICROBLAZE_MEMBLOCK_H */
 
 
diff --git a/arch/microblaze/kernel/prom.c b/arch/microblaze/kernel/prom.c
index a15ef6d..427b13b 100644
--- a/arch/microblaze/kernel/prom.c
+++ b/arch/microblaze/kernel/prom.c
@@ -29,7 +29,7 @@
 #include <linux/kexec.h>
 #include <linux/debugfs.h>
 #include <linux/irq.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 
 #include <asm/prom.h>
 #include <asm/page.h>
@@ -49,12 +49,12 @@ void __init early_init_dt_scan_chosen_arch(unsigned long node)
 
 void __init early_init_dt_add_memory_arch(u64 base, u64 size)
 {
-	lmb_add(base, size);
+	memblock_add(base, size);
 }
 
 u64 __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
 {
-	return lmb_alloc(size, align);
+	return memblock_alloc(size, align);
 }
 
 #ifdef CONFIG_EARLY_PRINTK
@@ -104,8 +104,8 @@ void __init early_init_devtree(void *params)
 	 */
 	of_scan_flat_dt(early_init_dt_scan_chosen, NULL);
 
-	/* Scan memory nodes and rebuild LMBs */
-	lmb_init();
+	/* Scan memory nodes and rebuild MEMBLOCKs */
+	memblock_init();
 	of_scan_flat_dt(early_init_dt_scan_root, NULL);
 	of_scan_flat_dt(early_init_dt_scan_memory, NULL);
 
@@ -113,9 +113,9 @@ void __init early_init_devtree(void *params)
 	strlcpy(boot_command_line, cmd_line, COMMAND_LINE_SIZE);
 	parse_early_param();
 
-	lmb_analyze();
+	memblock_analyze();
 
-	pr_debug("Phys. mem: %lx\n", (unsigned long) lmb_phys_mem_size());
+	pr_debug("Phys. mem: %lx\n", (unsigned long) memblock_phys_mem_size());
 
 	pr_debug(" <- early_init_devtree()\n");
 }
diff --git a/arch/microblaze/mm/init.c b/arch/microblaze/mm/init.c
index cca3579..db59349 100644
--- a/arch/microblaze/mm/init.c
+++ b/arch/microblaze/mm/init.c
@@ -10,7 +10,7 @@
 #include <linux/bootmem.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 #include <linux/mm.h> /* mem_init */
 #include <linux/initrd.h>
 #include <linux/pagemap.h>
@@ -76,10 +76,10 @@ void __init setup_memory(void)
 	u32 kernel_align_start, kernel_align_size;
 
 	/* Find main memory where is the kernel */
-	for (i = 0; i < lmb.memory.cnt; i++) {
-		memory_start = (u32) lmb.memory.region[i].base;
-		memory_end = (u32) lmb.memory.region[i].base
-				+ (u32) lmb.memory.region[i].size;
+	for (i = 0; i < memblock.memory.cnt; i++) {
+		memory_start = (u32) memblock.memory.region[i].base;
+		memory_end = (u32) memblock.memory.region[i].base
+				+ (u32) memblock.memory.region[i].size;
 		if ((memory_start <= (u32)_text) &&
 					((u32)_text <= memory_end)) {
 			memory_size = memory_end - memory_start;
@@ -100,7 +100,7 @@ void __init setup_memory(void)
 	kernel_align_start = PAGE_DOWN((u32)_text);
 	/* ALIGN can be remove because _end in vmlinux.lds.S is align */
 	kernel_align_size = PAGE_UP((u32)klimit) - kernel_align_start;
-	lmb_reserve(kernel_align_start, kernel_align_size);
+	memblock_reserve(kernel_align_start, kernel_align_size);
 	printk(KERN_INFO "%s: kernel addr=0x%08x-0x%08x size=0x%08x\n",
 		__func__, kernel_align_start, kernel_align_start
 			+ kernel_align_size, kernel_align_size);
@@ -141,18 +141,18 @@ void __init setup_memory(void)
 	map_size = init_bootmem_node(&contig_page_data,
 		PFN_UP(TOPHYS((u32)klimit)), min_low_pfn, max_low_pfn);
 #endif
-	lmb_reserve(PFN_UP(TOPHYS((u32)klimit)) << PAGE_SHIFT, map_size);
+	memblock_reserve(PFN_UP(TOPHYS((u32)klimit)) << PAGE_SHIFT, map_size);
 
 	/* free bootmem is whole main memory */
 	free_bootmem(memory_start, memory_size);
 
 	/* reserve allocate blocks */
-	for (i = 0; i < lmb.reserved.cnt; i++) {
+	for (i = 0; i < memblock.reserved.cnt; i++) {
 		pr_debug("reserved %d - 0x%08x-0x%08x\n", i,
-			(u32) lmb.reserved.region[i].base,
-			(u32) lmb_size_bytes(&lmb.reserved, i));
-		reserve_bootmem(lmb.reserved.region[i].base,
-			lmb_size_bytes(&lmb.reserved, i) - 1, BOOTMEM_DEFAULT);
+			(u32) memblock.reserved.region[i].base,
+			(u32) memblock_size_bytes(&memblock.reserved, i));
+		reserve_bootmem(memblock.reserved.region[i].base,
+			memblock_size_bytes(&memblock.reserved, i) - 1, BOOTMEM_DEFAULT);
 	}
 #ifdef CONFIG_MMU
 	init_bootmem_done = 1;
@@ -235,7 +235,7 @@ static void mm_cmdline_setup(void)
 		if (maxmem && memory_size > maxmem) {
 			memory_size = maxmem;
 			memory_end = memory_start + memory_size;
-			lmb.memory.region[0].size = memory_size;
+			memblock.memory.region[0].size = memory_size;
 		}
 	}
 }
@@ -273,19 +273,19 @@ asmlinkage void __init mmu_init(void)
 {
 	unsigned int kstart, ksize;
 
-	if (!lmb.reserved.cnt) {
+	if (!memblock.reserved.cnt) {
 		printk(KERN_EMERG "Error memory count\n");
 		machine_restart(NULL);
 	}
 
-	if ((u32) lmb.memory.region[0].size < 0x1000000) {
+	if ((u32) memblock.memory.region[0].size < 0x1000000) {
 		printk(KERN_EMERG "Memory must be greater than 16MB\n");
 		machine_restart(NULL);
 	}
 	/* Find main memory where the kernel is */
-	memory_start = (u32) lmb.memory.region[0].base;
-	memory_end = (u32) lmb.memory.region[0].base +
-				(u32) lmb.memory.region[0].size;
+	memory_start = (u32) memblock.memory.region[0].base;
+	memory_end = (u32) memblock.memory.region[0].base +
+				(u32) memblock.memory.region[0].size;
 	memory_size = memory_end - memory_start;
 
 	mm_cmdline_setup(); /* FIXME parse args from command line - not used */
@@ -297,7 +297,7 @@ asmlinkage void __init mmu_init(void)
 	kstart = __pa(CONFIG_KERNEL_START); /* kernel start */
 	/* kernel size */
 	ksize = PAGE_ALIGN(((u32)_end - (u32)CONFIG_KERNEL_START));
-	lmb_reserve(kstart, ksize);
+	memblock_reserve(kstart, ksize);
 
 #if defined(CONFIG_BLK_DEV_INITRD)
 	/* Remove the init RAM disk from the available memory. */
@@ -335,7 +335,7 @@ void __init *early_get_page(void)
 		 * Mem start + 32MB -> here is limit
 		 * because of mem mapping from head.S
 		 */
-		p = __va(lmb_alloc_base(PAGE_SIZE, PAGE_SIZE,
+		p = __va(memblock_alloc_base(PAGE_SIZE, PAGE_SIZE,
 					memory_start + 0x2000000));
 	}
 	return p;
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 328774b..6e12e6f 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -132,7 +132,7 @@ config PPC
 	select HAVE_ARCH_KGDB
 	select HAVE_KRETPROBES
 	select HAVE_ARCH_TRACEHOOK
-	select HAVE_LMB
+	select HAVE_MEMBLOCK
 	select HAVE_DMA_ATTRS
 	select HAVE_DMA_API_DEBUG
 	select USE_GENERIC_SMP_HELPERS if SMP
diff --git a/arch/powerpc/include/asm/abs_addr.h b/arch/powerpc/include/asm/abs_addr.h
index 98324c5..9a846ef 100644
--- a/arch/powerpc/include/asm/abs_addr.h
+++ b/arch/powerpc/include/asm/abs_addr.h
@@ -12,7 +12,7 @@
  * 2 of the License, or (at your option) any later version.
  */
 
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 
 #include <asm/types.h>
 #include <asm/page.h>
diff --git a/arch/powerpc/include/asm/lmb.h b/arch/powerpc/include/asm/lmb.h
deleted file mode 100644
index 6f5fdf0..0000000
--- a/arch/powerpc/include/asm/lmb.h
+++ /dev/null
@@ -1,15 +0,0 @@
-#ifndef _ASM_POWERPC_LMB_H
-#define _ASM_POWERPC_LMB_H
-
-#include <asm/udbg.h>
-
-#define LMB_DBG(fmt...) udbg_printf(fmt)
-
-#ifdef CONFIG_PPC32
-extern phys_addr_t lowmem_end_addr;
-#define LMB_REAL_LIMIT	lowmem_end_addr
-#else
-#define LMB_REAL_LIMIT	0
-#endif
-
-#endif /* _ASM_POWERPC_LMB_H */
diff --git a/arch/powerpc/include/asm/memblock.h b/arch/powerpc/include/asm/memblock.h
new file mode 100644
index 0000000..3c29728
--- /dev/null
+++ b/arch/powerpc/include/asm/memblock.h
@@ -0,0 +1,15 @@
+#ifndef _ASM_POWERPC_MEMBLOCK_H
+#define _ASM_POWERPC_MEMBLOCK_H
+
+#include <asm/udbg.h>
+
+#define MEMBLOCK_DBG(fmt...) udbg_printf(fmt)
+
+#ifdef CONFIG_PPC32
+extern phys_addr_t lowmem_end_addr;
+#define MEMBLOCK_REAL_LIMIT	lowmem_end_addr
+#else
+#define MEMBLOCK_REAL_LIMIT	0
+#endif
+
+#endif /* _ASM_POWERPC_MEMBLOCK_H */
diff --git a/arch/powerpc/kernel/btext.c b/arch/powerpc/kernel/btext.c
index 26e5863..625942a 100644
--- a/arch/powerpc/kernel/btext.c
+++ b/arch/powerpc/kernel/btext.c
@@ -7,7 +7,7 @@
 #include <linux/string.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 
 #include <asm/sections.h>
 #include <asm/prom.h>
diff --git a/arch/powerpc/kernel/crash.c b/arch/powerpc/kernel/crash.c
index b46f2e0..765ec14 100644
--- a/arch/powerpc/kernel/crash.c
+++ b/arch/powerpc/kernel/crash.c
@@ -24,7 +24,7 @@
 #include <linux/init.h>
 #include <linux/irq.h>
 #include <linux/types.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 
 #include <asm/processor.h>
 #include <asm/machdep.h>
diff --git a/arch/powerpc/kernel/crash_dump.c b/arch/powerpc/kernel/crash_dump.c
index 5fb667a..40f5246 100644
--- a/arch/powerpc/kernel/crash_dump.c
+++ b/arch/powerpc/kernel/crash_dump.c
@@ -13,7 +13,7 @@
 
 #include <linux/crash_dump.h>
 #include <linux/bootmem.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 #include <asm/code-patching.h>
 #include <asm/kdump.h>
 #include <asm/prom.h>
@@ -33,7 +33,7 @@ unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
 #ifndef CONFIG_RELOCATABLE
 void __init reserve_kdump_trampoline(void)
 {
-	lmb_reserve(0, KDUMP_RESERVE_LIMIT);
+	memblock_reserve(0, KDUMP_RESERVE_LIMIT);
 }
 
 static void __init create_trampoline(unsigned long addr)
diff --git a/arch/powerpc/kernel/dma-swiotlb.c b/arch/powerpc/kernel/dma-swiotlb.c
index e7fe218..02f724f 100644
--- a/arch/powerpc/kernel/dma-swiotlb.c
+++ b/arch/powerpc/kernel/dma-swiotlb.c
@@ -71,7 +71,7 @@ static int ppc_swiotlb_bus_notify(struct notifier_block *nb,
 	sd->max_direct_dma_addr = 0;
 
 	/* May need to bounce if the device can't address all of DRAM */
-	if ((dma_get_mask(dev) + 1) < lmb_end_of_DRAM())
+	if ((dma_get_mask(dev) + 1) < memblock_end_of_DRAM())
 		set_dma_ops(dev, &swiotlb_dma_ops);
 
 	return NOTIFY_DONE;
diff --git a/arch/powerpc/kernel/dma.c b/arch/powerpc/kernel/dma.c
index 8d1de6f..84d6367 100644
--- a/arch/powerpc/kernel/dma.c
+++ b/arch/powerpc/kernel/dma.c
@@ -9,7 +9,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/dma-debug.h>
 #include <linux/gfp.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 #include <asm/bug.h>
 #include <asm/abs_addr.h>
 
@@ -89,7 +89,7 @@ static int dma_direct_dma_supported(struct device *dev, u64 mask)
 	/* Could be improved so platforms can set the limit in case
 	 * they have limited DMA windows
 	 */
-	return mask >= (lmb_end_of_DRAM() - 1);
+	return mask >= (memblock_end_of_DRAM() - 1);
 #else
 	return 1;
 #endif
diff --git a/arch/powerpc/kernel/machine_kexec.c b/arch/powerpc/kernel/machine_kexec.c
index bb3d893..89f0051 100644
--- a/arch/powerpc/kernel/machine_kexec.c
+++ b/arch/powerpc/kernel/machine_kexec.c
@@ -12,7 +12,7 @@
 #include <linux/kexec.h>
 #include <linux/reboot.h>
 #include <linux/threads.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 #include <linux/of.h>
 #include <asm/machdep.h>
 #include <asm/prom.h>
@@ -66,11 +66,11 @@ void __init reserve_crashkernel(void)
 	unsigned long long crash_size, crash_base;
 	int ret;
 
-	/* this is necessary because of lmb_phys_mem_size() */
-	lmb_analyze();
+	/* this is necessary because of memblock_phys_mem_size() */
+	memblock_analyze();
 
 	/* use common parsing */
-	ret = parse_crashkernel(boot_command_line, lmb_phys_mem_size(),
+	ret = parse_crashkernel(boot_command_line, memblock_phys_mem_size(),
 			&crash_size, &crash_base);
 	if (ret == 0 && crash_size > 0) {
 		crashk_res.start = crash_base;
@@ -133,9 +133,9 @@ void __init reserve_crashkernel(void)
 			"for crashkernel (System RAM: %ldMB)\n",
 			(unsigned long)(crash_size >> 20),
 			(unsigned long)(crashk_res.start >> 20),
-			(unsigned long)(lmb_phys_mem_size() >> 20));
+			(unsigned long)(memblock_phys_mem_size() >> 20));
 
-	lmb_reserve(crashk_res.start, crash_size);
+	memblock_reserve(crashk_res.start, crash_size);
 }
 
 int overlaps_crashkernel(unsigned long start, unsigned long size)
diff --git a/arch/powerpc/kernel/paca.c b/arch/powerpc/kernel/paca.c
index f88acf0..139a773 100644
--- a/arch/powerpc/kernel/paca.c
+++ b/arch/powerpc/kernel/paca.c
@@ -9,7 +9,7 @@
 
 #include <linux/threads.h>
 #include <linux/module.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 
 #include <asm/firmware.h>
 #include <asm/lppaca.h>
@@ -117,7 +117,7 @@ void __init allocate_pacas(void)
 	 * the first segment. On iSeries they must be within the area mapped
 	 * by the HV, which is HvPagesToMap * HVPAGESIZE bytes.
 	 */
-	limit = min(0x10000000ULL, lmb.rmo_size);
+	limit = min(0x10000000ULL, memblock.rmo_size);
 	if (firmware_has_feature(FW_FEATURE_ISERIES))
 		limit = min(limit, HvPagesToMap * HVPAGESIZE);
 
@@ -128,7 +128,7 @@ void __init allocate_pacas(void)
 
 	paca_size = PAGE_ALIGN(sizeof(struct paca_struct) * nr_cpus);
 
-	paca = __va(lmb_alloc_base(paca_size, PAGE_SIZE, limit));
+	paca = __va(memblock_alloc_base(paca_size, PAGE_SIZE, limit));
 	memset(paca, 0, paca_size);
 
 	printk(KERN_DEBUG "Allocated %u bytes for %d pacas at %p\n",
@@ -148,7 +148,7 @@ void __init free_unused_pacas(void)
 	if (new_size >= paca_size)
 		return;
 
-	lmb_free(__pa(paca) + new_size, paca_size - new_size);
+	memblock_free(__pa(paca) + new_size, paca_size - new_size);
 
 	printk(KERN_DEBUG "Freed %u bytes for unused pacas\n",
 		paca_size - new_size);
diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index 05131d6..9d39539 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -31,7 +31,7 @@
 #include <linux/kexec.h>
 #include <linux/debugfs.h>
 #include <linux/irq.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 
 #include <asm/prom.h>
 #include <asm/rtas.h>
@@ -98,7 +98,7 @@ static void __init move_device_tree(void)
 
 	if ((memory_limit && (start + size) > memory_limit) ||
 			overlaps_crashkernel(start, size)) {
-		p = __va(lmb_alloc_base(size, PAGE_SIZE, lmb.rmo_size));
+		p = __va(memblock_alloc_base(size, PAGE_SIZE, memblock.rmo_size));
 		memcpy(p, initial_boot_params, size);
 		initial_boot_params = (struct boot_param_header *)p;
 		DBG("Moved device tree to 0x%p\n", p);
@@ -411,13 +411,13 @@ static int __init early_init_dt_scan_drconf_memory(unsigned long node)
 {
 	__be32 *dm, *ls, *usm;
 	unsigned long l, n, flags;
-	u64 base, size, lmb_size;
+	u64 base, size, memblock_size;
 	unsigned int is_kexec_kdump = 0, rngs;
 
-	ls = of_get_flat_dt_prop(node, "ibm,lmb-size", &l);
+	ls = of_get_flat_dt_prop(node, "ibm,memblock-size", &l);
 	if (ls == NULL || l < dt_root_size_cells * sizeof(__be32))
 		return 0;
-	lmb_size = dt_mem_next_cell(dt_root_size_cells, &ls);
+	memblock_size = dt_mem_next_cell(dt_root_size_cells, &ls);
 
 	dm = of_get_flat_dt_prop(node, "ibm,dynamic-memory", &l);
 	if (dm == NULL || l < sizeof(__be32))
@@ -442,11 +442,11 @@ static int __init early_init_dt_scan_drconf_memory(unsigned long node)
 		   or if the block is not assigned to this partition (0x8) */
 		if ((flags & 0x80) || !(flags & 0x8))
 			continue;
-		size = lmb_size;
+		size = memblock_size;
 		rngs = 1;
 		if (is_kexec_kdump) {
 			/*
-			 * For each lmb in ibm,dynamic-memory, a corresponding
+			 * For each memblock in ibm,dynamic-memory, a corresponding
 			 * entry in linux,drconf-usable-memory property contains
 			 * a counter 'p' followed by 'p' (base, size) duple.
 			 * Now read the counter from
@@ -469,10 +469,10 @@ static int __init early_init_dt_scan_drconf_memory(unsigned long node)
 				if ((base + size) > 0x80000000ul)
 					size = 0x80000000ul - base;
 			}
-			lmb_add(base, size);
+			memblock_add(base, size);
 		} while (--rngs);
 	}
-	lmb_dump_all();
+	memblock_dump_all();
 	return 0;
 }
 #else
@@ -501,14 +501,14 @@ void __init early_init_dt_add_memory_arch(u64 base, u64 size)
 	}
 #endif
 
-	lmb_add(base, size);
+	memblock_add(base, size);
 
 	memstart_addr = min((u64)memstart_addr, base);
 }
 
 u64 __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
 {
-	return lmb_alloc(size, align);
+	return memblock_alloc(size, align);
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
@@ -534,12 +534,12 @@ static void __init early_reserve_mem(void)
 	/* before we do anything, lets reserve the dt blob */
 	self_base = __pa((unsigned long)initial_boot_params);
 	self_size = initial_boot_params->totalsize;
-	lmb_reserve(self_base, self_size);
+	memblock_reserve(self_base, self_size);
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	/* then reserve the initrd, if any */
 	if (initrd_start && (initrd_end > initrd_start))
-		lmb_reserve(__pa(initrd_start), initrd_end - initrd_start);
+		memblock_reserve(__pa(initrd_start), initrd_end - initrd_start);
 #endif /* CONFIG_BLK_DEV_INITRD */
 
 #ifdef CONFIG_PPC32
@@ -560,7 +560,7 @@ static void __init early_reserve_mem(void)
 			if (base_32 == self_base && size_32 == self_size)
 				continue;
 			DBG("reserving: %x -> %x\n", base_32, size_32);
-			lmb_reserve(base_32, size_32);
+			memblock_reserve(base_32, size_32);
 		}
 		return;
 	}
@@ -571,7 +571,7 @@ static void __init early_reserve_mem(void)
 		if (size == 0)
 			break;
 		DBG("reserving: %llx -> %llx\n", base, size);
-		lmb_reserve(base, size);
+		memblock_reserve(base, size);
 	}
 }
 
@@ -594,7 +594,7 @@ static inline unsigned long phyp_dump_calculate_reserve_size(void)
 		return phyp_dump_info->reserve_bootvar;
 
 	/* divide by 20 to get 5% of value */
-	tmp = lmb_end_of_DRAM();
+	tmp = memblock_end_of_DRAM();
 	do_div(tmp, 20);
 
 	/* round it down in multiples of 256 */
@@ -633,11 +633,11 @@ static void __init phyp_dump_reserve_mem(void)
 	if (phyp_dump_info->phyp_dump_is_active) {
 		/* Reserve *everything* above RMR.Area freed by userland tools*/
 		base = variable_reserve_size;
-		size = lmb_end_of_DRAM() - base;
+		size = memblock_end_of_DRAM() - base;
 
 		/* XXX crashed_ram_end is wrong, since it may be beyond
 		 * the memory_limit, it will need to be adjusted. */
-		lmb_reserve(base, size);
+		memblock_reserve(base, size);
 
 		phyp_dump_info->init_reserve_start = base;
 		phyp_dump_info->init_reserve_size = size;
@@ -645,8 +645,8 @@ static void __init phyp_dump_reserve_mem(void)
 		size = phyp_dump_info->cpu_state_size +
 			phyp_dump_info->hpte_region_size +
 			variable_reserve_size;
-		base = lmb_end_of_DRAM() - size;
-		lmb_reserve(base, size);
+		base = memblock_end_of_DRAM() - size;
+		memblock_reserve(base, size);
 		phyp_dump_info->init_reserve_start = base;
 		phyp_dump_info->init_reserve_size = size;
 	}
@@ -681,8 +681,8 @@ void __init early_init_devtree(void *params)
 	 */
 	of_scan_flat_dt(early_init_dt_scan_chosen, NULL);
 
-	/* Scan memory nodes and rebuild LMBs */
-	lmb_init();
+	/* Scan memory nodes and rebuild MEMBLOCKs */
+	memblock_init();
 	of_scan_flat_dt(early_init_dt_scan_root, NULL);
 	of_scan_flat_dt(early_init_dt_scan_memory_ppc, NULL);
 
@@ -690,11 +690,11 @@ void __init early_init_devtree(void *params)
 	strlcpy(boot_command_line, cmd_line, COMMAND_LINE_SIZE);
 	parse_early_param();
 
-	/* Reserve LMB regions used by kernel, initrd, dt, etc... */
-	lmb_reserve(PHYSICAL_START, __pa(klimit) - PHYSICAL_START);
+	/* Reserve MEMBLOCK regions used by kernel, initrd, dt, etc... */
+	memblock_reserve(PHYSICAL_START, __pa(klimit) - PHYSICAL_START);
 	/* If relocatable, reserve first 32k for interrupt vectors etc. */
 	if (PHYSICAL_START > MEMORY_START)
-		lmb_reserve(MEMORY_START, 0x8000);
+		memblock_reserve(MEMORY_START, 0x8000);
 	reserve_kdump_trampoline();
 	reserve_crashkernel();
 	early_reserve_mem();
@@ -706,17 +706,17 @@ void __init early_init_devtree(void *params)
 
 		/* Ensure that total memory size is page-aligned, because
 		 * otherwise mark_bootmem() gets upset. */
-		lmb_analyze();
-		memsize = lmb_phys_mem_size();
+		memblock_analyze();
+		memsize = memblock_phys_mem_size();
 		if ((memsize & PAGE_MASK) != memsize)
 			limit = memsize & PAGE_MASK;
 	}
-	lmb_enforce_memory_limit(limit);
+	memblock_enforce_memory_limit(limit);
 
-	lmb_analyze();
-	lmb_dump_all();
+	memblock_analyze();
+	memblock_dump_all();
 
-	DBG("Phys. mem: %llx\n", lmb_phys_mem_size());
+	DBG("Phys. mem: %llx\n", memblock_phys_mem_size());
 
 	/* We may need to relocate the flat tree, do it now.
 	 * FIXME .. and the initrd too? */
diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index 0e1ec6f..d0516db 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -22,7 +22,7 @@
 #include <linux/smp.h>
 #include <linux/completion.h>
 #include <linux/cpumask.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 #include <linux/slab.h>
 
 #include <asm/prom.h>
@@ -934,11 +934,11 @@ void __init rtas_initialize(void)
 	 */
 #ifdef CONFIG_PPC64
 	if (machine_is(pseries) && firmware_has_feature(FW_FEATURE_LPAR)) {
-		rtas_region = min(lmb.rmo_size, RTAS_INSTANTIATE_MAX);
+		rtas_region = min(memblock.rmo_size, RTAS_INSTANTIATE_MAX);
 		ibm_suspend_me_token = rtas_token("ibm,suspend-me");
 	}
 #endif
-	rtas_rmo_buf = lmb_alloc_base(RTAS_RMOBUF_MAX, PAGE_SIZE, rtas_region);
+	rtas_rmo_buf = memblock_alloc_base(RTAS_RMOBUF_MAX, PAGE_SIZE, rtas_region);
 
 #ifdef CONFIG_RTAS_ERROR_LOGGING
 	rtas_last_error_token = rtas_token("rtas-last-error");
diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index 5e4d852..b7e6c7e 100644
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -33,7 +33,7 @@
 #include <linux/serial_8250.h>
 #include <linux/debugfs.h>
 #include <linux/percpu.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 #include <linux/of_platform.h>
 #include <asm/io.h>
 #include <asm/paca.h>
diff --git a/arch/powerpc/kernel/setup_32.c b/arch/powerpc/kernel/setup_32.c
index 7d84b21..a10ffc8 100644
--- a/arch/powerpc/kernel/setup_32.c
+++ b/arch/powerpc/kernel/setup_32.c
@@ -16,7 +16,7 @@
 #include <linux/root_dev.h>
 #include <linux/cpu.h>
 #include <linux/console.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 
 #include <asm/io.h>
 #include <asm/prom.h>
@@ -246,12 +246,12 @@ static void __init irqstack_early_init(void)
 	unsigned int i;
 
 	/* interrupt stacks must be in lowmem, we get that for free on ppc32
-	 * as the lmb is limited to lowmem by LMB_REAL_LIMIT */
+	 * as the memblock is limited to lowmem by MEMBLOCK_REAL_LIMIT */
 	for_each_possible_cpu(i) {
 		softirq_ctx[i] = (struct thread_info *)
-			__va(lmb_alloc(THREAD_SIZE, THREAD_SIZE));
+			__va(memblock_alloc(THREAD_SIZE, THREAD_SIZE));
 		hardirq_ctx[i] = (struct thread_info *)
-			__va(lmb_alloc(THREAD_SIZE, THREAD_SIZE));
+			__va(memblock_alloc(THREAD_SIZE, THREAD_SIZE));
 	}
 }
 
@@ -261,15 +261,15 @@ static void __init exc_lvl_early_init(void)
 	unsigned int i;
 
 	/* interrupt stacks must be in lowmem, we get that for free on ppc32
-	 * as the lmb is limited to lowmem by LMB_REAL_LIMIT */
+	 * as the memblock is limited to lowmem by MEMBLOCK_REAL_LIMIT */
 	for_each_possible_cpu(i) {
 		critirq_ctx[i] = (struct thread_info *)
-			__va(lmb_alloc(THREAD_SIZE, THREAD_SIZE));
+			__va(memblock_alloc(THREAD_SIZE, THREAD_SIZE));
 #ifdef CONFIG_BOOKE
 		dbgirq_ctx[i] = (struct thread_info *)
-			__va(lmb_alloc(THREAD_SIZE, THREAD_SIZE));
+			__va(memblock_alloc(THREAD_SIZE, THREAD_SIZE));
 		mcheckirq_ctx[i] = (struct thread_info *)
-			__va(lmb_alloc(THREAD_SIZE, THREAD_SIZE));
+			__va(memblock_alloc(THREAD_SIZE, THREAD_SIZE));
 #endif
 	}
 }
diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index 643dcac..d135f93 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -34,7 +34,7 @@
 #include <linux/bootmem.h>
 #include <linux/pci.h>
 #include <linux/lockdep.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 #include <asm/io.h>
 #include <asm/kdump.h>
 #include <asm/prom.h>
@@ -158,7 +158,7 @@ static void __init setup_paca(struct paca_struct *new_paca)
  * the CPU that ignores the top 2 bits of the address in real
  * mode so we can access kernel globals normally provided we
  * only toy with things in the RMO region. From here, we do
- * some early parsing of the device-tree to setup out LMB
+ * some early parsing of the device-tree to setup out MEMBLOCK
  * data structures, and allocate & initialize the hash table
  * and segment tables so we can start running with translation
  * enabled.
@@ -404,7 +404,7 @@ void __init setup_system(void)
 
 	printk("-----------------------------------------------------\n");
 	printk("ppc64_pft_size                = 0x%llx\n", ppc64_pft_size);
-	printk("physicalMemorySize            = 0x%llx\n", lmb_phys_mem_size());
+	printk("physicalMemorySize            = 0x%llx\n", memblock_phys_mem_size());
 	if (ppc64_caches.dline_size != 0x80)
 		printk("ppc64_caches.dcache_line_size = 0x%x\n",
 		       ppc64_caches.dline_size);
@@ -443,10 +443,10 @@ static void __init irqstack_early_init(void)
 	 */
 	for_each_possible_cpu(i) {
 		softirq_ctx[i] = (struct thread_info *)
-			__va(lmb_alloc_base(THREAD_SIZE,
+			__va(memblock_alloc_base(THREAD_SIZE,
 					    THREAD_SIZE, limit));
 		hardirq_ctx[i] = (struct thread_info *)
-			__va(lmb_alloc_base(THREAD_SIZE,
+			__va(memblock_alloc_base(THREAD_SIZE,
 					    THREAD_SIZE, limit));
 	}
 }
@@ -458,11 +458,11 @@ static void __init exc_lvl_early_init(void)
 
 	for_each_possible_cpu(i) {
 		critirq_ctx[i] = (struct thread_info *)
-			__va(lmb_alloc(THREAD_SIZE, THREAD_SIZE));
+			__va(memblock_alloc(THREAD_SIZE, THREAD_SIZE));
 		dbgirq_ctx[i] = (struct thread_info *)
-			__va(lmb_alloc(THREAD_SIZE, THREAD_SIZE));
+			__va(memblock_alloc(THREAD_SIZE, THREAD_SIZE));
 		mcheckirq_ctx[i] = (struct thread_info *)
-			__va(lmb_alloc(THREAD_SIZE, THREAD_SIZE));
+			__va(memblock_alloc(THREAD_SIZE, THREAD_SIZE));
 	}
 }
 #else
@@ -487,11 +487,11 @@ static void __init emergency_stack_init(void)
 	 * bringup, we need to get at them in real mode. This means they
 	 * must also be within the RMO region.
 	 */
-	limit = min(slb0_limit(), lmb.rmo_size);
+	limit = min(slb0_limit(), memblock.rmo_size);
 
 	for_each_possible_cpu(i) {
 		unsigned long sp;
-		sp  = lmb_alloc_base(THREAD_SIZE, THREAD_SIZE, limit);
+		sp  = memblock_alloc_base(THREAD_SIZE, THREAD_SIZE, limit);
 		sp += THREAD_SIZE;
 		paca[i].emergency_sp = __va(sp);
 	}
diff --git a/arch/powerpc/kernel/vdso.c b/arch/powerpc/kernel/vdso.c
index d84d192..13002fe 100644
--- a/arch/powerpc/kernel/vdso.c
+++ b/arch/powerpc/kernel/vdso.c
@@ -22,7 +22,7 @@
 #include <linux/elf.h>
 #include <linux/security.h>
 #include <linux/bootmem.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 
 #include <asm/pgtable.h>
 #include <asm/system.h>
@@ -734,7 +734,7 @@ static int __init vdso_init(void)
 	vdso_data->platform = machine_is(iseries) ? 0x200 : 0x100;
 	if (firmware_has_feature(FW_FEATURE_LPAR))
 		vdso_data->platform |= 1;
-	vdso_data->physicalMemorySize = lmb_phys_mem_size();
+	vdso_data->physicalMemorySize = memblock_phys_mem_size();
 	vdso_data->dcache_size = ppc64_caches.dsize;
 	vdso_data->dcache_line_size = ppc64_caches.dline_size;
 	vdso_data->icache_size = ppc64_caches.isize;
diff --git a/arch/powerpc/mm/40x_mmu.c b/arch/powerpc/mm/40x_mmu.c
index 65abfcf..1dc2fa5 100644
--- a/arch/powerpc/mm/40x_mmu.c
+++ b/arch/powerpc/mm/40x_mmu.c
@@ -135,7 +135,7 @@ unsigned long __init mmu_mapin_ram(unsigned long top)
 	/* If the size of RAM is not an exact power of two, we may not
 	 * have covered RAM in its entirety with 16 and 4 MiB
 	 * pages. Consequently, restrict the top end of RAM currently
-	 * allocable so that calls to the LMB to allocate PTEs for "tail"
+	 * allocable so that calls to the MEMBLOCK to allocate PTEs for "tail"
 	 * coverage with normal-sized pages (or other reasons) do not
 	 * attempt to allocate outside the allowed range.
 	 */
diff --git a/arch/powerpc/mm/hash_utils_64.c b/arch/powerpc/mm/hash_utils_64.c
index 3ecdcec..98f262d 100644
--- a/arch/powerpc/mm/hash_utils_64.c
+++ b/arch/powerpc/mm/hash_utils_64.c
@@ -31,7 +31,7 @@
 #include <linux/cache.h>
 #include <linux/init.h>
 #include <linux/signal.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 
 #include <asm/processor.h>
 #include <asm/pgtable.h>
@@ -384,8 +384,8 @@ static int __init htab_dt_scan_hugepage_blocks(unsigned long node,
 	printk(KERN_INFO "Huge page(16GB) memory: "
 			"addr = 0x%lX size = 0x%lX pages = %d\n",
 			phys_addr, block_size, expected_pages);
-	if (phys_addr + (16 * GB) <= lmb_end_of_DRAM()) {
-		lmb_reserve(phys_addr, block_size * expected_pages);
+	if (phys_addr + (16 * GB) <= memblock_end_of_DRAM()) {
+		memblock_reserve(phys_addr, block_size * expected_pages);
 		add_gpage(phys_addr, block_size, expected_pages);
 	}
 	return 0;
@@ -458,7 +458,7 @@ static void __init htab_init_page_sizes(void)
 	 * and we have at least 1G of RAM at boot
 	 */
 	if (mmu_psize_defs[MMU_PAGE_16M].shift &&
-	    lmb_phys_mem_size() >= 0x40000000)
+	    memblock_phys_mem_size() >= 0x40000000)
 		mmu_vmemmap_psize = MMU_PAGE_16M;
 	else if (mmu_psize_defs[MMU_PAGE_64K].shift)
 		mmu_vmemmap_psize = MMU_PAGE_64K;
@@ -520,7 +520,7 @@ static unsigned long __init htab_get_table_size(void)
 		return 1UL << ppc64_pft_size;
 
 	/* round mem_size up to next power of 2 */
-	mem_size = lmb_phys_mem_size();
+	mem_size = memblock_phys_mem_size();
 	rnd_mem_size = 1UL << __ilog2(mem_size);
 	if (rnd_mem_size < mem_size)
 		rnd_mem_size <<= 1;
@@ -627,7 +627,7 @@ static void __init htab_initialize(void)
 		else
 			limit = 0;
 
-		table = lmb_alloc_base(htab_size_bytes, htab_size_bytes, limit);
+		table = memblock_alloc_base(htab_size_bytes, htab_size_bytes, limit);
 
 		DBG("Hash table allocated at %lx, size: %lx\n", table,
 		    htab_size_bytes);
@@ -647,9 +647,9 @@ static void __init htab_initialize(void)
 	prot = pgprot_val(PAGE_KERNEL);
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
-	linear_map_hash_count = lmb_end_of_DRAM() >> PAGE_SHIFT;
-	linear_map_hash_slots = __va(lmb_alloc_base(linear_map_hash_count,
-						    1, lmb.rmo_size));
+	linear_map_hash_count = memblock_end_of_DRAM() >> PAGE_SHIFT;
+	linear_map_hash_slots = __va(memblock_alloc_base(linear_map_hash_count,
+						    1, memblock.rmo_size));
 	memset(linear_map_hash_slots, 0, linear_map_hash_count);
 #endif /* CONFIG_DEBUG_PAGEALLOC */
 
@@ -659,16 +659,16 @@ static void __init htab_initialize(void)
 	 */
 
 	/* create bolted the linear mapping in the hash table */
-	for (i=0; i < lmb.memory.cnt; i++) {
-		base = (unsigned long)__va(lmb.memory.region[i].base);
-		size = lmb.memory.region[i].size;
+	for (i=0; i < memblock.memory.cnt; i++) {
+		base = (unsigned long)__va(memblock.memory.region[i].base);
+		size = memblock.memory.region[i].size;
 
 		DBG("creating mapping for region: %lx..%lx (prot: %lx)\n",
 		    base, size, prot);
 
 #ifdef CONFIG_U3_DART
 		/* Do not map the DART space. Fortunately, it will be aligned
-		 * in such a way that it will not cross two lmb regions and
+		 * in such a way that it will not cross two memblock regions and
 		 * will fit within a single 16Mb page.
 		 * The DART space is assumed to be a full 16Mb region even if
 		 * we only use 2Mb of that space. We will use more of it later
diff --git a/arch/powerpc/mm/init_32.c b/arch/powerpc/mm/init_32.c
index 7673330..6a6975d 100644
--- a/arch/powerpc/mm/init_32.c
+++ b/arch/powerpc/mm/init_32.c
@@ -30,7 +30,7 @@
 #include <linux/highmem.h>
 #include <linux/initrd.h>
 #include <linux/pagemap.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 #include <linux/gfp.h>
 
 #include <asm/pgalloc.h>
@@ -136,17 +136,17 @@ void __init MMU_init(void)
 	/* parse args from command line */
 	MMU_setup();
 
-	if (lmb.memory.cnt > 1) {
+	if (memblock.memory.cnt > 1) {
 #ifndef CONFIG_WII
-		lmb.memory.cnt = 1;
-		lmb_analyze();
+		memblock.memory.cnt = 1;
+		memblock_analyze();
 		printk(KERN_WARNING "Only using first contiguous memory region");
 #else
 		wii_memory_fixups();
 #endif
 	}
 
-	total_lowmem = total_memory = lmb_end_of_DRAM() - memstart_addr;
+	total_lowmem = total_memory = memblock_end_of_DRAM() - memstart_addr;
 	lowmem_end_addr = memstart_addr + total_lowmem;
 
 #ifdef CONFIG_FSL_BOOKE
@@ -161,8 +161,8 @@ void __init MMU_init(void)
 		lowmem_end_addr = memstart_addr + total_lowmem;
 #ifndef CONFIG_HIGHMEM
 		total_memory = total_lowmem;
-		lmb_enforce_memory_limit(lowmem_end_addr);
-		lmb_analyze();
+		memblock_enforce_memory_limit(lowmem_end_addr);
+		memblock_analyze();
 #endif /* CONFIG_HIGHMEM */
 	}
 
@@ -200,7 +200,7 @@ void __init *early_get_page(void)
 	if (init_bootmem_done) {
 		p = alloc_bootmem_pages(PAGE_SIZE);
 	} else {
-		p = __va(lmb_alloc_base(PAGE_SIZE, PAGE_SIZE,
+		p = __va(memblock_alloc_base(PAGE_SIZE, PAGE_SIZE,
 					__initial_memory_limit_addr));
 	}
 	return p;
diff --git a/arch/powerpc/mm/init_64.c b/arch/powerpc/mm/init_64.c
index e267f22..71f1415 100644
--- a/arch/powerpc/mm/init_64.c
+++ b/arch/powerpc/mm/init_64.c
@@ -40,7 +40,7 @@
 #include <linux/nodemask.h>
 #include <linux/module.h>
 #include <linux/poison.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 #include <linux/hugetlb.h>
 #include <linux/slab.h>
 
diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 0f594d7..1a84a8d 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -32,7 +32,7 @@
 #include <linux/initrd.h>
 #include <linux/pagemap.h>
 #include <linux/suspend.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 #include <linux/hugetlb.h>
 
 #include <asm/pgalloc.h>
@@ -83,13 +83,13 @@ int page_is_ram(unsigned long pfn)
 #else
 	unsigned long paddr = (pfn << PAGE_SHIFT);
 	int i;
-	for (i=0; i < lmb.memory.cnt; i++) {
+	for (i=0; i < memblock.memory.cnt; i++) {
 		unsigned long base;
 
-		base = lmb.memory.region[i].base;
+		base = memblock.memory.region[i].base;
 
 		if ((paddr >= base) &&
-			(paddr < (base + lmb.memory.region[i].size))) {
+			(paddr < (base + memblock.memory.region[i].size))) {
 			return 1;
 		}
 	}
@@ -142,14 +142,14 @@ int arch_add_memory(int nid, u64 start, u64 size)
 /*
  * walk_memory_resource() needs to make sure there is no holes in a given
  * memory range.  PPC64 does not maintain the memory layout in /proc/iomem.
- * Instead it maintains it in lmb.memory structures.  Walk through the
+ * Instead it maintains it in memblock.memory structures.  Walk through the
  * memory regions, find holes and callback for contiguous regions.
  */
 int
 walk_system_ram_range(unsigned long start_pfn, unsigned long nr_pages,
 		void *arg, int (*func)(unsigned long, unsigned long, void *))
 {
-	struct lmb_property res;
+	struct memblock_property res;
 	unsigned long pfn, len;
 	u64 end;
 	int ret = -1;
@@ -158,7 +158,7 @@ walk_system_ram_range(unsigned long start_pfn, unsigned long nr_pages,
 	res.size = (u64) nr_pages << PAGE_SHIFT;
 
 	end = res.base + res.size - 1;
-	while ((res.base < end) && (lmb_find(&res) >= 0)) {
+	while ((res.base < end) && (memblock_find(&res) >= 0)) {
 		pfn = (unsigned long)(res.base >> PAGE_SHIFT);
 		len = (unsigned long)(res.size >> PAGE_SHIFT);
 		ret = (*func)(pfn, len, arg);
@@ -184,8 +184,8 @@ void __init do_init_bootmem(void)
 	unsigned long total_pages;
 	int boot_mapsize;
 
-	max_low_pfn = max_pfn = lmb_end_of_DRAM() >> PAGE_SHIFT;
-	total_pages = (lmb_end_of_DRAM() - memstart_addr) >> PAGE_SHIFT;
+	max_low_pfn = max_pfn = memblock_end_of_DRAM() >> PAGE_SHIFT;
+	total_pages = (memblock_end_of_DRAM() - memstart_addr) >> PAGE_SHIFT;
 #ifdef CONFIG_HIGHMEM
 	total_pages = total_lowmem >> PAGE_SHIFT;
 	max_low_pfn = lowmem_end_addr >> PAGE_SHIFT;
@@ -198,16 +198,16 @@ void __init do_init_bootmem(void)
 	 */
 	bootmap_pages = bootmem_bootmap_pages(total_pages);
 
-	start = lmb_alloc(bootmap_pages << PAGE_SHIFT, PAGE_SIZE);
+	start = memblock_alloc(bootmap_pages << PAGE_SHIFT, PAGE_SIZE);
 
 	min_low_pfn = MEMORY_START >> PAGE_SHIFT;
 	boot_mapsize = init_bootmem_node(NODE_DATA(0), start >> PAGE_SHIFT, min_low_pfn, max_low_pfn);
 
 	/* Add active regions with valid PFNs */
-	for (i = 0; i < lmb.memory.cnt; i++) {
+	for (i = 0; i < memblock.memory.cnt; i++) {
 		unsigned long start_pfn, end_pfn;
-		start_pfn = lmb.memory.region[i].base >> PAGE_SHIFT;
-		end_pfn = start_pfn + lmb_size_pages(&lmb.memory, i);
+		start_pfn = memblock.memory.region[i].base >> PAGE_SHIFT;
+		end_pfn = start_pfn + memblock_size_pages(&memblock.memory, i);
 		add_active_range(0, start_pfn, end_pfn);
 	}
 
@@ -218,17 +218,17 @@ void __init do_init_bootmem(void)
 	free_bootmem_with_active_regions(0, lowmem_end_addr >> PAGE_SHIFT);
 
 	/* reserve the sections we're already using */
-	for (i = 0; i < lmb.reserved.cnt; i++) {
-		unsigned long addr = lmb.reserved.region[i].base +
-				     lmb_size_bytes(&lmb.reserved, i) - 1;
+	for (i = 0; i < memblock.reserved.cnt; i++) {
+		unsigned long addr = memblock.reserved.region[i].base +
+				     memblock_size_bytes(&memblock.reserved, i) - 1;
 		if (addr < lowmem_end_addr)
-			reserve_bootmem(lmb.reserved.region[i].base,
-					lmb_size_bytes(&lmb.reserved, i),
+			reserve_bootmem(memblock.reserved.region[i].base,
+					memblock_size_bytes(&memblock.reserved, i),
 					BOOTMEM_DEFAULT);
-		else if (lmb.reserved.region[i].base < lowmem_end_addr) {
+		else if (memblock.reserved.region[i].base < lowmem_end_addr) {
 			unsigned long adjusted_size = lowmem_end_addr -
-				      lmb.reserved.region[i].base;
-			reserve_bootmem(lmb.reserved.region[i].base,
+				      memblock.reserved.region[i].base;
+			reserve_bootmem(memblock.reserved.region[i].base,
 					adjusted_size, BOOTMEM_DEFAULT);
 		}
 	}
@@ -236,9 +236,9 @@ void __init do_init_bootmem(void)
 	free_bootmem_with_active_regions(0, max_pfn);
 
 	/* reserve the sections we're already using */
-	for (i = 0; i < lmb.reserved.cnt; i++)
-		reserve_bootmem(lmb.reserved.region[i].base,
-				lmb_size_bytes(&lmb.reserved, i),
+	for (i = 0; i < memblock.reserved.cnt; i++)
+		reserve_bootmem(memblock.reserved.region[i].base,
+				memblock_size_bytes(&memblock.reserved, i),
 				BOOTMEM_DEFAULT);
 
 #endif
@@ -251,20 +251,20 @@ void __init do_init_bootmem(void)
 /* mark pages that don't exist as nosave */
 static int __init mark_nonram_nosave(void)
 {
-	unsigned long lmb_next_region_start_pfn,
-		      lmb_region_max_pfn;
+	unsigned long memblock_next_region_start_pfn,
+		      memblock_region_max_pfn;
 	int i;
 
-	for (i = 0; i < lmb.memory.cnt - 1; i++) {
-		lmb_region_max_pfn =
-			(lmb.memory.region[i].base >> PAGE_SHIFT) +
-			(lmb.memory.region[i].size >> PAGE_SHIFT);
-		lmb_next_region_start_pfn =
-			lmb.memory.region[i+1].base >> PAGE_SHIFT;
+	for (i = 0; i < memblock.memory.cnt - 1; i++) {
+		memblock_region_max_pfn =
+			(memblock.memory.region[i].base >> PAGE_SHIFT) +
+			(memblock.memory.region[i].size >> PAGE_SHIFT);
+		memblock_next_region_start_pfn =
+			memblock.memory.region[i+1].base >> PAGE_SHIFT;
 
-		if (lmb_region_max_pfn < lmb_next_region_start_pfn)
-			register_nosave_region(lmb_region_max_pfn,
-					       lmb_next_region_start_pfn);
+		if (memblock_region_max_pfn < memblock_next_region_start_pfn)
+			register_nosave_region(memblock_region_max_pfn,
+					       memblock_next_region_start_pfn);
 	}
 
 	return 0;
@@ -275,8 +275,8 @@ static int __init mark_nonram_nosave(void)
  */
 void __init paging_init(void)
 {
-	unsigned long total_ram = lmb_phys_mem_size();
-	phys_addr_t top_of_ram = lmb_end_of_DRAM();
+	unsigned long total_ram = memblock_phys_mem_size();
+	phys_addr_t top_of_ram = memblock_end_of_DRAM();
 	unsigned long max_zone_pfns[MAX_NR_ZONES];
 
 #ifdef CONFIG_PPC32
@@ -327,7 +327,7 @@ void __init mem_init(void)
 		swiotlb_init(1);
 #endif
 
-	num_physpages = lmb.memory.size >> PAGE_SHIFT;
+	num_physpages = memblock.memory.size >> PAGE_SHIFT;
 	high_memory = (void *) __va(max_low_pfn * PAGE_SIZE);
 
 #ifdef CONFIG_NEED_MULTIPLE_NODES
@@ -364,7 +364,7 @@ void __init mem_init(void)
 		highmem_mapnr = lowmem_end_addr >> PAGE_SHIFT;
 		for (pfn = highmem_mapnr; pfn < max_mapnr; ++pfn) {
 			struct page *page = pfn_to_page(pfn);
-			if (lmb_is_reserved(pfn << PAGE_SHIFT))
+			if (memblock_is_reserved(pfn << PAGE_SHIFT))
 				continue;
 			ClearPageReserved(page);
 			init_page_count(page);
diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 80d1106..f473645 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -17,7 +17,7 @@
 #include <linux/nodemask.h>
 #include <linux/cpu.h>
 #include <linux/notifier.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 #include <linux/of.h>
 #include <linux/pfn.h>
 #include <asm/sparsemem.h>
@@ -351,7 +351,7 @@ struct of_drconf_cell {
 #define DRCONF_MEM_RESERVED	0x00000080
 
 /*
- * Read the next lmb list entry from the ibm,dynamic-memory property
+ * Read the next memblock list entry from the ibm,dynamic-memory property
  * and return the information in the provided of_drconf_cell structure.
  */
 static void read_drconf_cell(struct of_drconf_cell *drmem, const u32 **cellp)
@@ -372,8 +372,8 @@ static void read_drconf_cell(struct of_drconf_cell *drmem, const u32 **cellp)
 /*
  * Retreive and validate the ibm,dynamic-memory property of the device tree.
  *
- * The layout of the ibm,dynamic-memory property is a number N of lmb
- * list entries followed by N lmb list entries.  Each lmb list entry
+ * The layout of the ibm,dynamic-memory property is a number N of memblock
+ * list entries followed by N memblock list entries.  Each memblock list entry
  * contains information as layed out in the of_drconf_cell struct above.
  */
 static int of_get_drconf_memory(struct device_node *memory, const u32 **dm)
@@ -398,15 +398,15 @@ static int of_get_drconf_memory(struct device_node *memory, const u32 **dm)
 }
 
 /*
- * Retreive and validate the ibm,lmb-size property for drconf memory
+ * Retreive and validate the ibm,memblock-size property for drconf memory
  * from the device tree.
  */
-static u64 of_get_lmb_size(struct device_node *memory)
+static u64 of_get_memblock_size(struct device_node *memory)
 {
 	const u32 *prop;
 	u32 len;
 
-	prop = of_get_property(memory, "ibm,lmb-size", &len);
+	prop = of_get_property(memory, "ibm,memblock-size", &len);
 	if (!prop || len < sizeof(unsigned int))
 		return 0;
 
@@ -540,19 +540,19 @@ static unsigned long __init numa_enforce_memory_limit(unsigned long start,
 						      unsigned long size)
 {
 	/*
-	 * We use lmb_end_of_DRAM() in here instead of memory_limit because
+	 * We use memblock_end_of_DRAM() in here instead of memory_limit because
 	 * we've already adjusted it for the limit and it takes care of
 	 * having memory holes below the limit.  Also, in the case of
 	 * iommu_is_off, memory_limit is not set but is implicitly enforced.
 	 */
 
-	if (start + size <= lmb_end_of_DRAM())
+	if (start + size <= memblock_end_of_DRAM())
 		return size;
 
-	if (start >= lmb_end_of_DRAM())
+	if (start >= memblock_end_of_DRAM())
 		return 0;
 
-	return lmb_end_of_DRAM() - start;
+	return memblock_end_of_DRAM() - start;
 }
 
 /*
@@ -562,7 +562,7 @@ static unsigned long __init numa_enforce_memory_limit(unsigned long start,
 static inline int __init read_usm_ranges(const u32 **usm)
 {
 	/*
-	 * For each lmb in ibm,dynamic-memory a corresponding
+	 * For each memblock in ibm,dynamic-memory a corresponding
 	 * entry in linux,drconf-usable-memory property contains
 	 * a counter followed by that many (base, size) duple.
 	 * read the counter from linux,drconf-usable-memory
@@ -578,7 +578,7 @@ static void __init parse_drconf_memory(struct device_node *memory)
 {
 	const u32 *dm, *usm;
 	unsigned int n, rc, ranges, is_kexec_kdump = 0;
-	unsigned long lmb_size, base, size, sz;
+	unsigned long memblock_size, base, size, sz;
 	int nid;
 	struct assoc_arrays aa;
 
@@ -586,8 +586,8 @@ static void __init parse_drconf_memory(struct device_node *memory)
 	if (!n)
 		return;
 
-	lmb_size = of_get_lmb_size(memory);
-	if (!lmb_size)
+	memblock_size = of_get_memblock_size(memory);
+	if (!memblock_size)
 		return;
 
 	rc = of_get_assoc_arrays(memory, &aa);
@@ -611,7 +611,7 @@ static void __init parse_drconf_memory(struct device_node *memory)
 			continue;
 
 		base = drmem.base_addr;
-		size = lmb_size;
+		size = memblock_size;
 		ranges = 1;
 
 		if (is_kexec_kdump) {
@@ -731,7 +731,7 @@ new_range:
 	}
 
 	/*
-	 * Now do the same thing for each LMB listed in the ibm,dynamic-memory
+	 * Now do the same thing for each MEMBLOCK listed in the ibm,dynamic-memory
 	 * property in the ibm,dynamic-reconfiguration-memory node.
 	 */
 	memory = of_find_node_by_path("/ibm,dynamic-reconfiguration-memory");
@@ -743,8 +743,8 @@ new_range:
 
 static void __init setup_nonnuma(void)
 {
-	unsigned long top_of_ram = lmb_end_of_DRAM();
-	unsigned long total_ram = lmb_phys_mem_size();
+	unsigned long top_of_ram = memblock_end_of_DRAM();
+	unsigned long total_ram = memblock_phys_mem_size();
 	unsigned long start_pfn, end_pfn;
 	unsigned int i, nid = 0;
 
@@ -753,9 +753,9 @@ static void __init setup_nonnuma(void)
 	printk(KERN_DEBUG "Memory hole size: %ldMB\n",
 	       (top_of_ram - total_ram) >> 20);
 
-	for (i = 0; i < lmb.memory.cnt; ++i) {
-		start_pfn = lmb.memory.region[i].base >> PAGE_SHIFT;
-		end_pfn = start_pfn + lmb_size_pages(&lmb.memory, i);
+	for (i = 0; i < memblock.memory.cnt; ++i) {
+		start_pfn = memblock.memory.region[i].base >> PAGE_SHIFT;
+		end_pfn = start_pfn + memblock_size_pages(&memblock.memory, i);
 
 		fake_numa_create_new_node(end_pfn, &nid);
 		add_active_range(nid, start_pfn, end_pfn);
@@ -813,7 +813,7 @@ static void __init dump_numa_memory_topology(void)
 
 		count = 0;
 
-		for (i = 0; i < lmb_end_of_DRAM();
+		for (i = 0; i < memblock_end_of_DRAM();
 		     i += (1 << SECTION_SIZE_BITS)) {
 			if (early_pfn_to_nid(i >> PAGE_SHIFT) == node) {
 				if (count == 0)
@@ -833,7 +833,7 @@ static void __init dump_numa_memory_topology(void)
 }
 
 /*
- * Allocate some memory, satisfying the lmb or bootmem allocator where
+ * Allocate some memory, satisfying the memblock or bootmem allocator where
  * required. nid is the preferred node and end is the physical address of
  * the highest address in the node.
  *
@@ -847,11 +847,11 @@ static void __init *careful_zallocation(int nid, unsigned long size,
 	int new_nid;
 	unsigned long ret_paddr;
 
-	ret_paddr = __lmb_alloc_base(size, align, end_pfn << PAGE_SHIFT);
+	ret_paddr = __memblock_alloc_base(size, align, end_pfn << PAGE_SHIFT);
 
 	/* retry over all memory */
 	if (!ret_paddr)
-		ret_paddr = __lmb_alloc_base(size, align, lmb_end_of_DRAM());
+		ret_paddr = __memblock_alloc_base(size, align, memblock_end_of_DRAM());
 
 	if (!ret_paddr)
 		panic("numa.c: cannot allocate %lu bytes for node %d",
@@ -861,14 +861,14 @@ static void __init *careful_zallocation(int nid, unsigned long size,
 
 	/*
 	 * We initialize the nodes in numeric order: 0, 1, 2...
-	 * and hand over control from the LMB allocator to the
+	 * and hand over control from the MEMBLOCK allocator to the
 	 * bootmem allocator.  If this function is called for
 	 * node 5, then we know that all nodes <5 are using the
-	 * bootmem allocator instead of the LMB allocator.
+	 * bootmem allocator instead of the MEMBLOCK allocator.
 	 *
 	 * So, check the nid from which this allocation came
 	 * and double check to see if we need to use bootmem
-	 * instead of the LMB.  We don't free the LMB memory
+	 * instead of the MEMBLOCK.  We don't free the MEMBLOCK memory
 	 * since it would be useless.
 	 */
 	new_nid = early_pfn_to_nid(ret_paddr >> PAGE_SHIFT);
@@ -893,9 +893,9 @@ static void mark_reserved_regions_for_nid(int nid)
 	struct pglist_data *node = NODE_DATA(nid);
 	int i;
 
-	for (i = 0; i < lmb.reserved.cnt; i++) {
-		unsigned long physbase = lmb.reserved.region[i].base;
-		unsigned long size = lmb.reserved.region[i].size;
+	for (i = 0; i < memblock.reserved.cnt; i++) {
+		unsigned long physbase = memblock.reserved.region[i].base;
+		unsigned long size = memblock.reserved.region[i].size;
 		unsigned long start_pfn = physbase >> PAGE_SHIFT;
 		unsigned long end_pfn = PFN_UP(physbase + size);
 		struct node_active_region node_ar;
@@ -903,7 +903,7 @@ static void mark_reserved_regions_for_nid(int nid)
 					     node->node_spanned_pages;
 
 		/*
-		 * Check to make sure that this lmb.reserved area is
+		 * Check to make sure that this memblock.reserved area is
 		 * within the bounds of the node that we care about.
 		 * Checking the nid of the start and end points is not
 		 * sufficient because the reserved area could span the
@@ -961,7 +961,7 @@ void __init do_init_bootmem(void)
 	int nid;
 
 	min_low_pfn = 0;
-	max_low_pfn = lmb_end_of_DRAM() >> PAGE_SHIFT;
+	max_low_pfn = memblock_end_of_DRAM() >> PAGE_SHIFT;
 	max_pfn = max_low_pfn;
 
 	if (parse_numa_properties())
@@ -1038,7 +1038,7 @@ void __init paging_init(void)
 {
 	unsigned long max_zone_pfns[MAX_NR_ZONES];
 	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
-	max_zone_pfns[ZONE_DMA] = lmb_end_of_DRAM() >> PAGE_SHIFT;
+	max_zone_pfns[ZONE_DMA] = memblock_end_of_DRAM() >> PAGE_SHIFT;
 	free_area_init_nodes(max_zone_pfns);
 }
 
@@ -1072,7 +1072,7 @@ static int hot_add_drconf_scn_to_nid(struct device_node *memory,
 {
 	const u32 *dm;
 	unsigned int drconf_cell_cnt, rc;
-	unsigned long lmb_size;
+	unsigned long memblock_size;
 	struct assoc_arrays aa;
 	int nid = -1;
 
@@ -1080,8 +1080,8 @@ static int hot_add_drconf_scn_to_nid(struct device_node *memory,
 	if (!drconf_cell_cnt)
 		return -1;
 
-	lmb_size = of_get_lmb_size(memory);
-	if (!lmb_size)
+	memblock_size = of_get_memblock_size(memory);
+	if (!memblock_size)
 		return -1;
 
 	rc = of_get_assoc_arrays(memory, &aa);
@@ -1100,7 +1100,7 @@ static int hot_add_drconf_scn_to_nid(struct device_node *memory,
 			continue;
 
 		if ((scn_addr < drmem.base_addr)
-		    || (scn_addr >= (drmem.base_addr + lmb_size)))
+		    || (scn_addr >= (drmem.base_addr + memblock_size)))
 			continue;
 
 		nid = of_drconf_to_nid_single(&drmem, &aa);
@@ -1113,7 +1113,7 @@ static int hot_add_drconf_scn_to_nid(struct device_node *memory,
 /*
  * Find the node associated with a hot added memory section for memory
  * represented in the device tree as a node (i.e. memory@XXXX) for
- * each lmb.
+ * each memblock.
  */
 int hot_add_node_scn_to_nid(unsigned long scn_addr)
 {
@@ -1154,8 +1154,8 @@ int hot_add_node_scn_to_nid(unsigned long scn_addr)
 
 /*
  * Find the node associated with a hot added memory section.  Section
- * corresponds to a SPARSEMEM section, not an LMB.  It is assumed that
- * sections are fully contained within a single LMB.
+ * corresponds to a SPARSEMEM section, not an MEMBLOCK.  It is assumed that
+ * sections are fully contained within a single MEMBLOCK.
  */
 int hot_add_scn_to_nid(unsigned long scn_addr)
 {
diff --git a/arch/powerpc/mm/pgtable_32.c b/arch/powerpc/mm/pgtable_32.c
index 34347b2..a87ead0 100644
--- a/arch/powerpc/mm/pgtable_32.c
+++ b/arch/powerpc/mm/pgtable_32.c
@@ -26,7 +26,7 @@
 #include <linux/vmalloc.h>
 #include <linux/init.h>
 #include <linux/highmem.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 #include <linux/slab.h>
 
 #include <asm/pgtable.h>
@@ -198,7 +198,7 @@ __ioremap_caller(phys_addr_t addr, unsigned long size, unsigned long flags,
 	 * mem_init() sets high_memory so only do the check after that.
 	 */
 	if (mem_init_done && (p < virt_to_phys(high_memory)) &&
-	    !(__allow_ioremap_reserved && lmb_is_region_reserved(p, size))) {
+	    !(__allow_ioremap_reserved && memblock_is_region_reserved(p, size))) {
 		printk("__ioremap(): phys addr 0x%llx is RAM lr %p\n",
 		       (unsigned long long)p, __builtin_return_address(0));
 		return NULL;
@@ -331,7 +331,7 @@ void __init mapin_ram(void)
 		s = mmu_mapin_ram(top);
 		__mapin_ram_chunk(s, top);
 
-		top = lmb_end_of_DRAM();
+		top = memblock_end_of_DRAM();
 		s = wii_mmu_mapin_mem2(top);
 		__mapin_ram_chunk(s, top);
 	}
diff --git a/arch/powerpc/mm/pgtable_64.c b/arch/powerpc/mm/pgtable_64.c
index d050fc8..21d6dfa 100644
--- a/arch/powerpc/mm/pgtable_64.c
+++ b/arch/powerpc/mm/pgtable_64.c
@@ -34,7 +34,7 @@
 #include <linux/vmalloc.h>
 #include <linux/init.h>
 #include <linux/bootmem.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 #include <linux/slab.h>
 
 #include <asm/pgalloc.h>
@@ -67,7 +67,7 @@ static void *early_alloc_pgtable(unsigned long size)
 	if (init_bootmem_done)
 		pt = __alloc_bootmem(size, size, __pa(MAX_DMA_ADDRESS));
 	else
-		pt = __va(lmb_alloc_base(size, size,
+		pt = __va(memblock_alloc_base(size, size,
 					 __pa(MAX_DMA_ADDRESS)));
 	memset(pt, 0, size);
 
diff --git a/arch/powerpc/mm/ppc_mmu_32.c b/arch/powerpc/mm/ppc_mmu_32.c
index f11c2cd..f8a0182 100644
--- a/arch/powerpc/mm/ppc_mmu_32.c
+++ b/arch/powerpc/mm/ppc_mmu_32.c
@@ -26,7 +26,7 @@
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/highmem.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 
 #include <asm/prom.h>
 #include <asm/mmu.h>
@@ -223,7 +223,7 @@ void __init MMU_init_hw(void)
 	 * Find some memory for the hash table.
 	 */
 	if ( ppc_md.progress ) ppc_md.progress("hash:find piece", 0x322);
-	Hash = __va(lmb_alloc_base(Hash_size, Hash_size,
+	Hash = __va(memblock_alloc_base(Hash_size, Hash_size,
 				   __initial_memory_limit_addr));
 	cacheable_memzero(Hash, Hash_size);
 	_SDR1 = __pa(Hash) | SDR1_LOW_BITS;
diff --git a/arch/powerpc/mm/stab.c b/arch/powerpc/mm/stab.c
index 687fdda..446a018 100644
--- a/arch/powerpc/mm/stab.c
+++ b/arch/powerpc/mm/stab.c
@@ -12,7 +12,7 @@
  *      2 of the License, or (at your option) any later version.
  */
 
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 
 #include <asm/pgtable.h>
 #include <asm/mmu.h>
@@ -252,7 +252,7 @@ void __init stabs_alloc(void)
 		if (cpu == 0)
 			continue; /* stab for CPU 0 is statically allocated */
 
-		newstab = lmb_alloc_base(HW_PAGE_SIZE, HW_PAGE_SIZE,
+		newstab = memblock_alloc_base(HW_PAGE_SIZE, HW_PAGE_SIZE,
 					 1<<SID_SHIFT);
 		newstab = (unsigned long)__va(newstab);
 
diff --git a/arch/powerpc/mm/tlb_nohash.c b/arch/powerpc/mm/tlb_nohash.c
index e81d5d6..d8695b0 100644
--- a/arch/powerpc/mm/tlb_nohash.c
+++ b/arch/powerpc/mm/tlb_nohash.c
@@ -34,7 +34,7 @@
 #include <linux/pagemap.h>
 #include <linux/preempt.h>
 #include <linux/spinlock.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 
 #include <asm/tlbflush.h>
 #include <asm/tlb.h>
@@ -426,7 +426,7 @@ static void __early_init_mmu(int boot_cpu)
 	/* Set the global containing the top of the linear mapping
 	 * for use by the TLB miss code
 	 */
-	linear_map_top = lmb_end_of_DRAM();
+	linear_map_top = memblock_end_of_DRAM();
 
 	/* A sync won't hurt us after mucking around with
 	 * the MMU configuration
diff --git a/arch/powerpc/platforms/85xx/corenet_ds.c b/arch/powerpc/platforms/85xx/corenet_ds.c
index 534c2ec..2ab338c 100644
--- a/arch/powerpc/platforms/85xx/corenet_ds.c
+++ b/arch/powerpc/platforms/85xx/corenet_ds.c
@@ -16,7 +16,7 @@
 #include <linux/kdev_t.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 
 #include <asm/system.h>
 #include <asm/time.h>
@@ -100,7 +100,7 @@ void __init corenet_ds_setup_arch(void)
 #endif
 
 #ifdef CONFIG_SWIOTLB
-	if (lmb_end_of_DRAM() > max) {
+	if (memblock_end_of_DRAM() > max) {
 		ppc_swiotlb_enable = 1;
 		set_pci_dma_ops(&swiotlb_dma_ops);
 		ppc_md.pci_dma_dev_setup = pci_dma_dev_setup_swiotlb;
diff --git a/arch/powerpc/platforms/85xx/mpc8536_ds.c b/arch/powerpc/platforms/85xx/mpc8536_ds.c
index 004b7d3..f79f2f1 100644
--- a/arch/powerpc/platforms/85xx/mpc8536_ds.c
+++ b/arch/powerpc/platforms/85xx/mpc8536_ds.c
@@ -17,7 +17,7 @@
 #include <linux/seq_file.h>
 #include <linux/interrupt.h>
 #include <linux/of_platform.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 
 #include <asm/system.h>
 #include <asm/time.h>
@@ -94,7 +94,7 @@ static void __init mpc8536_ds_setup_arch(void)
 #endif
 
 #ifdef CONFIG_SWIOTLB
-	if (lmb_end_of_DRAM() > max) {
+	if (memblock_end_of_DRAM() > max) {
 		ppc_swiotlb_enable = 1;
 		set_pci_dma_ops(&swiotlb_dma_ops);
 		ppc_md.pci_dma_dev_setup = pci_dma_dev_setup_swiotlb;
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_ds.c b/arch/powerpc/platforms/85xx/mpc85xx_ds.c
index 544011a..8190bc2 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_ds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_ds.c
@@ -20,7 +20,7 @@
 #include <linux/seq_file.h>
 #include <linux/interrupt.h>
 #include <linux/of_platform.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 
 #include <asm/system.h>
 #include <asm/time.h>
@@ -190,7 +190,7 @@ static void __init mpc85xx_ds_setup_arch(void)
 #endif
 
 #ifdef CONFIG_SWIOTLB
-	if (lmb_end_of_DRAM() > max) {
+	if (memblock_end_of_DRAM() > max) {
 		ppc_swiotlb_enable = 1;
 		set_pci_dma_ops(&swiotlb_dma_ops);
 		ppc_md.pci_dma_dev_setup = pci_dma_dev_setup_swiotlb;
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_mds.c b/arch/powerpc/platforms/85xx/mpc85xx_mds.c
index 8fe87fc..4945136 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_mds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_mds.c
@@ -33,7 +33,7 @@
 #include <linux/of_platform.h>
 #include <linux/of_device.h>
 #include <linux/phy.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 
 #include <asm/system.h>
 #include <asm/atomic.h>
@@ -325,7 +325,7 @@ static void __init mpc85xx_mds_setup_arch(void)
 #endif	/* CONFIG_QUICC_ENGINE */
 
 #ifdef CONFIG_SWIOTLB
-	if (lmb_end_of_DRAM() > max) {
+	if (memblock_end_of_DRAM() > max) {
 		ppc_swiotlb_enable = 1;
 		set_pci_dma_ops(&swiotlb_dma_ops);
 		ppc_md.pci_dma_dev_setup = pci_dma_dev_setup_swiotlb;
diff --git a/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c b/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c
index 2aa69a6..b11c353 100644
--- a/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c
+++ b/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c
@@ -19,7 +19,7 @@
 #include <linux/delay.h>
 #include <linux/seq_file.h>
 #include <linux/of_platform.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 
 #include <asm/system.h>
 #include <asm/time.h>
@@ -103,7 +103,7 @@ mpc86xx_hpcn_setup_arch(void)
 #endif
 
 #ifdef CONFIG_SWIOTLB
-	if (lmb_end_of_DRAM() > max) {
+	if (memblock_end_of_DRAM() > max) {
 		ppc_swiotlb_enable = 1;
 		set_pci_dma_ops(&swiotlb_dma_ops);
 		ppc_md.pci_dma_dev_setup = pci_dma_dev_setup_swiotlb;
diff --git a/arch/powerpc/platforms/cell/iommu.c b/arch/powerpc/platforms/cell/iommu.c
index 4326b73..3712900 100644
--- a/arch/powerpc/platforms/cell/iommu.c
+++ b/arch/powerpc/platforms/cell/iommu.c
@@ -29,7 +29,7 @@
 #include <linux/of.h>
 #include <linux/of_platform.h>
 #include <linux/slab.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 
 #include <asm/prom.h>
 #include <asm/iommu.h>
@@ -845,10 +845,10 @@ static int __init cell_iommu_init_disabled(void)
 	/* If we found a DMA window, we check if it's big enough to enclose
 	 * all of physical memory. If not, we force enable IOMMU
 	 */
-	if (np && size < lmb_end_of_DRAM()) {
+	if (np && size < memblock_end_of_DRAM()) {
 		printk(KERN_WARNING "iommu: force-enabled, dma window"
 		       " (%ldMB) smaller than total memory (%lldMB)\n",
-		       size >> 20, lmb_end_of_DRAM() >> 20);
+		       size >> 20, memblock_end_of_DRAM() >> 20);
 		return -ENODEV;
 	}
 
@@ -1064,7 +1064,7 @@ static int __init cell_iommu_fixed_mapping_init(void)
 	}
 
 	fbase = _ALIGN_UP(fbase, 1 << IO_SEGMENT_SHIFT);
-	fsize = lmb_phys_mem_size();
+	fsize = memblock_phys_mem_size();
 
 	if ((fbase + fsize) <= 0x800000000ul)
 		hbase = 0; /* use the device tree window */
@@ -1169,7 +1169,7 @@ static int __init cell_iommu_init(void)
 	 * Note: should we make sure we have the IOMMU actually disabled ?
 	 */
 	if (iommu_is_off ||
-	    (!iommu_force_on && lmb_end_of_DRAM() <= 0x80000000ull))
+	    (!iommu_force_on && memblock_end_of_DRAM() <= 0x80000000ull))
 		if (cell_iommu_init_disabled() == 0)
 			goto bail;
 
diff --git a/arch/powerpc/platforms/embedded6xx/wii.c b/arch/powerpc/platforms/embedded6xx/wii.c
index 174a04a..5cdcc7c 100644
--- a/arch/powerpc/platforms/embedded6xx/wii.c
+++ b/arch/powerpc/platforms/embedded6xx/wii.c
@@ -20,7 +20,7 @@
 #include <linux/seq_file.h>
 #include <linux/kexec.h>
 #include <linux/of_platform.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 #include <mm/mmu_decl.h>
 
 #include <asm/io.h>
@@ -65,7 +65,7 @@ static int __init page_aligned(unsigned long x)
 
 void __init wii_memory_fixups(void)
 {
-	struct lmb_property *p = lmb.memory.region;
+	struct memblock_property *p = memblock.memory.region;
 
 	/*
 	 * This is part of a workaround to allow the use of two
@@ -77,7 +77,7 @@ void __init wii_memory_fixups(void)
 	 * between both ranges.
 	 */
 
-	BUG_ON(lmb.memory.cnt != 2);
+	BUG_ON(memblock.memory.cnt != 2);
 	BUG_ON(!page_aligned(p[0].base) || !page_aligned(p[1].base));
 
 	p[0].size = _ALIGN_DOWN(p[0].size, PAGE_SIZE);
@@ -92,11 +92,11 @@ void __init wii_memory_fixups(void)
 
 	p[0].size += wii_hole_size + p[1].size;
 
-	lmb.memory.cnt = 1;
-	lmb_analyze();
+	memblock.memory.cnt = 1;
+	memblock_analyze();
 
 	/* reserve the hole */
-	lmb_reserve(wii_hole_start, wii_hole_size);
+	memblock_reserve(wii_hole_start, wii_hole_size);
 
 	/* allow ioremapping the address space in the hole */
 	__allow_ioremap_reserved = 1;
diff --git a/arch/powerpc/platforms/maple/setup.c b/arch/powerpc/platforms/maple/setup.c
index 39df705..3fff8d9 100644
--- a/arch/powerpc/platforms/maple/setup.c
+++ b/arch/powerpc/platforms/maple/setup.c
@@ -41,7 +41,7 @@
 #include <linux/smp.h>
 #include <linux/bitops.h>
 #include <linux/of_device.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 
 #include <asm/processor.h>
 #include <asm/sections.h>
diff --git a/arch/powerpc/platforms/pasemi/iommu.c b/arch/powerpc/platforms/pasemi/iommu.c
index 7b1d608..1f9fb2c 100644
--- a/arch/powerpc/platforms/pasemi/iommu.c
+++ b/arch/powerpc/platforms/pasemi/iommu.c
@@ -204,7 +204,7 @@ int __init iob_init(struct device_node *dn)
 	pr_debug(" -> %s\n", __func__);
 
 	/* Allocate a spare page to map all invalid IOTLB pages. */
-	tmp = lmb_alloc(IOBMAP_PAGE_SIZE, IOBMAP_PAGE_SIZE);
+	tmp = memblock_alloc(IOBMAP_PAGE_SIZE, IOBMAP_PAGE_SIZE);
 	if (!tmp)
 		panic("IOBMAP: Cannot allocate spare page!");
 	/* Empty l1 is marked invalid */
@@ -275,7 +275,7 @@ void __init alloc_iobmap_l2(void)
 	return;
 #endif
 	/* For 2G space, 8x64 pages (2^21 bytes) is max total l2 size */
-	iob_l2_base = (u32 *)abs_to_virt(lmb_alloc_base(1UL<<21, 1UL<<21, 0x80000000));
+	iob_l2_base = (u32 *)abs_to_virt(memblock_alloc_base(1UL<<21, 1UL<<21, 0x80000000));
 
 	printk(KERN_INFO "IOBMAP L2 allocated at: %p\n", iob_l2_base);
 }
diff --git a/arch/powerpc/platforms/powermac/setup.c b/arch/powerpc/platforms/powermac/setup.c
index f1d0132..9deb274 100644
--- a/arch/powerpc/platforms/powermac/setup.c
+++ b/arch/powerpc/platforms/powermac/setup.c
@@ -51,7 +51,7 @@
 #include <linux/suspend.h>
 #include <linux/of_device.h>
 #include <linux/of_platform.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 
 #include <asm/reg.h>
 #include <asm/sections.h>
@@ -619,7 +619,7 @@ static int __init pmac_probe(void)
 	 * driver needs that. We have to allocate it now. We allocate 4k
 	 * (1 small page) for now.
 	 */
-	smu_cmdbuf_abs = lmb_alloc_base(4096, 4096, 0x80000000UL);
+	smu_cmdbuf_abs = memblock_alloc_base(4096, 4096, 0x80000000UL);
 #endif /* CONFIG_PMAC_SMU */
 
 	return 1;
diff --git a/arch/powerpc/platforms/ps3/htab.c b/arch/powerpc/platforms/ps3/htab.c
index 1e8a1e3..2c0ed87 100644
--- a/arch/powerpc/platforms/ps3/htab.c
+++ b/arch/powerpc/platforms/ps3/htab.c
@@ -19,7 +19,7 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 
 #include <asm/machdep.h>
 #include <asm/prom.h>
diff --git a/arch/powerpc/platforms/ps3/mm.c b/arch/powerpc/platforms/ps3/mm.c
index 7925751..c204588 100644
--- a/arch/powerpc/platforms/ps3/mm.c
+++ b/arch/powerpc/platforms/ps3/mm.c
@@ -21,7 +21,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/memory_hotplug.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 #include <linux/slab.h>
 
 #include <asm/cell-regs.h>
@@ -318,8 +318,8 @@ static int __init ps3_mm_add_memory(void)
 		return result;
 	}
 
-	lmb_add(start_addr, map.r1.size);
-	lmb_analyze();
+	memblock_add(start_addr, map.r1.size);
+	memblock_analyze();
 
 	result = online_pages(start_pfn, nr_pages);
 
diff --git a/arch/powerpc/platforms/ps3/os-area.c b/arch/powerpc/platforms/ps3/os-area.c
index dd521a1..5b759b6 100644
--- a/arch/powerpc/platforms/ps3/os-area.c
+++ b/arch/powerpc/platforms/ps3/os-area.c
@@ -24,7 +24,7 @@
 #include <linux/fs.h>
 #include <linux/syscalls.h>
 #include <linux/ctype.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 #include <linux/of.h>
 #include <linux/slab.h>
 
@@ -723,7 +723,7 @@ static void os_area_queue_work(void)
  * flash to a high address in the boot memory region and then puts that RAM
  * address and the byte count into the repository for retrieval by the guest.
  * We copy the data we want into a static variable and allow the memory setup
- * by the HV to be claimed by the lmb manager.
+ * by the HV to be claimed by the memblock manager.
  *
  * The os area mirror will not be available to a second stage kernel, and
  * the header verify will fail.  In this case, the saved_params values will
diff --git a/arch/powerpc/platforms/pseries/hotplug-memory.c b/arch/powerpc/platforms/pseries/hotplug-memory.c
index 01e7b5b..deab5f9 100644
--- a/arch/powerpc/platforms/pseries/hotplug-memory.c
+++ b/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -10,14 +10,14 @@
  */
 
 #include <linux/of.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 #include <linux/vmalloc.h>
 #include <asm/firmware.h>
 #include <asm/machdep.h>
 #include <asm/pSeries_reconfig.h>
 #include <asm/sparsemem.h>
 
-static int pseries_remove_lmb(unsigned long base, unsigned int lmb_size)
+static int pseries_remove_memblock(unsigned long base, unsigned int memblock_size)
 {
 	unsigned long start, start_pfn;
 	struct zone *zone;
@@ -26,7 +26,7 @@ static int pseries_remove_lmb(unsigned long base, unsigned int lmb_size)
 	start_pfn = base >> PAGE_SHIFT;
 
 	if (!pfn_valid(start_pfn)) {
-		lmb_remove(base, lmb_size);
+		memblock_remove(base, memblock_size);
 		return 0;
 	}
 
@@ -41,20 +41,20 @@ static int pseries_remove_lmb(unsigned long base, unsigned int lmb_size)
 	 * to sysfs "state" file and we can't remove sysfs entries
 	 * while writing to it. So we have to defer it to here.
 	 */
-	ret = __remove_pages(zone, start_pfn, lmb_size >> PAGE_SHIFT);
+	ret = __remove_pages(zone, start_pfn, memblock_size >> PAGE_SHIFT);
 	if (ret)
 		return ret;
 
 	/*
 	 * Update memory regions for memory remove
 	 */
-	lmb_remove(base, lmb_size);
+	memblock_remove(base, memblock_size);
 
 	/*
 	 * Remove htab bolted mappings for this section of memory
 	 */
 	start = (unsigned long)__va(base);
-	ret = remove_section_mapping(start, start + lmb_size);
+	ret = remove_section_mapping(start, start + memblock_size);
 
 	/* Ensure all vmalloc mappings are flushed in case they also
 	 * hit that section of memory
@@ -69,7 +69,7 @@ static int pseries_remove_memory(struct device_node *np)
 	const char *type;
 	const unsigned int *regs;
 	unsigned long base;
-	unsigned int lmb_size;
+	unsigned int memblock_size;
 	int ret = -EINVAL;
 
 	/*
@@ -80,16 +80,16 @@ static int pseries_remove_memory(struct device_node *np)
 		return 0;
 
 	/*
-	 * Find the bae address and size of the lmb
+	 * Find the bae address and size of the memblock
 	 */
 	regs = of_get_property(np, "reg", NULL);
 	if (!regs)
 		return ret;
 
 	base = *(unsigned long *)regs;
-	lmb_size = regs[3];
+	memblock_size = regs[3];
 
-	ret = pseries_remove_lmb(base, lmb_size);
+	ret = pseries_remove_memblock(base, memblock_size);
 	return ret;
 }
 
@@ -98,7 +98,7 @@ static int pseries_add_memory(struct device_node *np)
 	const char *type;
 	const unsigned int *regs;
 	unsigned long base;
-	unsigned int lmb_size;
+	unsigned int memblock_size;
 	int ret = -EINVAL;
 
 	/*
@@ -109,43 +109,43 @@ static int pseries_add_memory(struct device_node *np)
 		return 0;
 
 	/*
-	 * Find the base and size of the lmb
+	 * Find the base and size of the memblock
 	 */
 	regs = of_get_property(np, "reg", NULL);
 	if (!regs)
 		return ret;
 
 	base = *(unsigned long *)regs;
-	lmb_size = regs[3];
+	memblock_size = regs[3];
 
 	/*
 	 * Update memory region to represent the memory add
 	 */
-	ret = lmb_add(base, lmb_size);
+	ret = memblock_add(base, memblock_size);
 	return (ret < 0) ? -EINVAL : 0;
 }
 
 static int pseries_drconf_memory(unsigned long *base, unsigned int action)
 {
 	struct device_node *np;
-	const unsigned long *lmb_size;
+	const unsigned long *memblock_size;
 	int rc;
 
 	np = of_find_node_by_path("/ibm,dynamic-reconfiguration-memory");
 	if (!np)
 		return -EINVAL;
 
-	lmb_size = of_get_property(np, "ibm,lmb-size", NULL);
-	if (!lmb_size) {
+	memblock_size = of_get_property(np, "ibm,memblock-size", NULL);
+	if (!memblock_size) {
 		of_node_put(np);
 		return -EINVAL;
 	}
 
 	if (action == PSERIES_DRCONF_MEM_ADD) {
-		rc = lmb_add(*base, *lmb_size);
+		rc = memblock_add(*base, *memblock_size);
 		rc = (rc < 0) ? -EINVAL : 0;
 	} else if (action == PSERIES_DRCONF_MEM_REMOVE) {
-		rc = pseries_remove_lmb(*base, *lmb_size);
+		rc = pseries_remove_memblock(*base, *memblock_size);
 	} else {
 		rc = -EINVAL;
 	}
diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index d26182d..395848e 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -66,7 +66,7 @@ static int tce_build_pSeries(struct iommu_table *tbl, long index,
 	tcep = ((u64 *)tbl->it_base) + index;
 
 	while (npages--) {
-		/* can't move this out since we might cross LMB boundary */
+		/* can't move this out since we might cross MEMBLOCK boundary */
 		rpn = (virt_to_abs(uaddr)) >> TCE_SHIFT;
 		*tcep = proto_tce | (rpn & TCE_RPN_MASK) << TCE_RPN_SHIFT;
 
diff --git a/arch/powerpc/platforms/pseries/phyp_dump.c b/arch/powerpc/platforms/pseries/phyp_dump.c
index 7ebd9e8..6e7742d 100644
--- a/arch/powerpc/platforms/pseries/phyp_dump.c
+++ b/arch/powerpc/platforms/pseries/phyp_dump.c
@@ -255,12 +255,12 @@ void invalidate_last_dump(struct phyp_dump_header *ph, unsigned long addr)
 
 /* ------------------------------------------------- */
 /**
- * release_memory_range -- release memory previously lmb_reserved
+ * release_memory_range -- release memory previously memblock_reserved
  * @start_pfn: starting physical frame number
  * @nr_pages: number of pages to free.
  *
  * This routine will release memory that had been previously
- * lmb_reserved in early boot. The released memory becomes
+ * memblock_reserved in early boot. The released memory becomes
  * available for genreal use.
  */
 static void release_memory_range(unsigned long start_pfn,
diff --git a/arch/powerpc/sysdev/dart_iommu.c b/arch/powerpc/sysdev/dart_iommu.c
index c8b96ed..559db2b 100644
--- a/arch/powerpc/sysdev/dart_iommu.c
+++ b/arch/powerpc/sysdev/dart_iommu.c
@@ -36,7 +36,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/vmalloc.h>
 #include <linux/suspend.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 #include <linux/gfp.h>
 #include <asm/io.h>
 #include <asm/prom.h>
@@ -232,7 +232,7 @@ static int __init dart_init(struct device_node *dart_node)
 	 * that to work around what looks like a problem with the HT bridge
 	 * prefetching into invalid pages and corrupting data
 	 */
-	tmp = lmb_alloc(DART_PAGE_SIZE, DART_PAGE_SIZE);
+	tmp = memblock_alloc(DART_PAGE_SIZE, DART_PAGE_SIZE);
 	dart_emptyval = DARTMAP_VALID | ((tmp >> DART_PAGE_SHIFT) &
 					 DARTMAP_RPNMASK);
 
@@ -407,7 +407,7 @@ void __init alloc_dart_table(void)
 	if (iommu_is_off)
 		return;
 
-	if (!iommu_force_on && lmb_end_of_DRAM() <= 0x40000000ull)
+	if (!iommu_force_on && memblock_end_of_DRAM() <= 0x40000000ull)
 		return;
 
 	/* 512 pages (2MB) is max DART tablesize. */
@@ -416,7 +416,7 @@ void __init alloc_dart_table(void)
 	 * will blow up an entire large page anyway in the kernel mapping
 	 */
 	dart_tablebase = (unsigned long)
-		abs_to_virt(lmb_alloc_base(1UL<<24, 1UL<<24, 0x80000000L));
+		abs_to_virt(memblock_alloc_base(1UL<<24, 1UL<<24, 0x80000000L));
 
 	printk(KERN_INFO "DART table allocated at: %lx\n", dart_tablebase);
 }
diff --git a/arch/powerpc/sysdev/fsl_pci.c b/arch/powerpc/sysdev/fsl_pci.c
index a14760f..356c6a0 100644
--- a/arch/powerpc/sysdev/fsl_pci.c
+++ b/arch/powerpc/sysdev/fsl_pci.c
@@ -23,7 +23,7 @@
 #include <linux/string.h>
 #include <linux/init.h>
 #include <linux/bootmem.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 #include <linux/log2.h>
 #include <linux/slab.h>
 
@@ -190,7 +190,7 @@ static void __init setup_pci_atmu(struct pci_controller *hose,
 	pr_info("%s: PCICSRBAR @ 0x%x\n", name, pcicsrbar);
 
 	/* Setup inbound mem window */
-	mem = lmb_end_of_DRAM();
+	mem = memblock_end_of_DRAM();
 	sz = min(mem, paddr_lo);
 	mem_log = __ilog2_u64(sz);
 
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 573fca1..82868fe 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -10,7 +10,7 @@ config SUPERH
 	select EMBEDDED
 	select HAVE_CLK
 	select HAVE_IDE if HAS_IOPORT
-	select HAVE_LMB
+	select HAVE_MEMBLOCK
 	select HAVE_OPROFILE
 	select HAVE_GENERIC_DMA_COHERENT
 	select HAVE_ARCH_TRACEHOOK
diff --git a/arch/sh/include/asm/lmb.h b/arch/sh/include/asm/lmb.h
deleted file mode 100644
index 9b437f6..0000000
--- a/arch/sh/include/asm/lmb.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ASM_SH_LMB_H
-#define __ASM_SH_LMB_H
-
-#define LMB_REAL_LIMIT	0
-
-#endif /* __ASM_SH_LMB_H */
diff --git a/arch/sh/include/asm/memblock.h b/arch/sh/include/asm/memblock.h
new file mode 100644
index 0000000..dfe683b
--- /dev/null
+++ b/arch/sh/include/asm/memblock.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_SH_MEMBLOCK_H
+#define __ASM_SH_MEMBLOCK_H
+
+#define MEMBLOCK_REAL_LIMIT	0
+
+#endif /* __ASM_SH_MEMBLOCK_H */
diff --git a/arch/sh/kernel/machine_kexec.c b/arch/sh/kernel/machine_kexec.c
index 5a559e6..e2a3af3 100644
--- a/arch/sh/kernel/machine_kexec.c
+++ b/arch/sh/kernel/machine_kexec.c
@@ -15,7 +15,7 @@
 #include <linux/numa.h>
 #include <linux/ftrace.h>
 #include <linux/suspend.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/mmu_context.h>
@@ -157,10 +157,10 @@ void __init reserve_crashkernel(void)
 	unsigned long long crash_size, crash_base;
 	int ret;
 
-	/* this is necessary because of lmb_phys_mem_size() */
-	lmb_analyze();
+	/* this is necessary because of memblock_phys_mem_size() */
+	memblock_analyze();
 
-	ret = parse_crashkernel(boot_command_line, lmb_phys_mem_size(),
+	ret = parse_crashkernel(boot_command_line, memblock_phys_mem_size(),
 			&crash_size, &crash_base);
 	if (ret == 0 && crash_size > 0) {
 		crashk_res.start = crash_base;
@@ -172,14 +172,14 @@ void __init reserve_crashkernel(void)
 
 	crash_size = PAGE_ALIGN(crashk_res.end - crashk_res.start + 1);
 	if (!crashk_res.start) {
-		unsigned long max = lmb_end_of_DRAM() - memory_limit;
-		crashk_res.start = __lmb_alloc_base(crash_size, PAGE_SIZE, max);
+		unsigned long max = memblock_end_of_DRAM() - memory_limit;
+		crashk_res.start = __memblock_alloc_base(crash_size, PAGE_SIZE, max);
 		if (!crashk_res.start) {
 			pr_err("crashkernel allocation failed\n");
 			goto disable;
 		}
 	} else {
-		ret = lmb_reserve(crashk_res.start, crash_size);
+		ret = memblock_reserve(crashk_res.start, crash_size);
 		if (unlikely(ret < 0)) {
 			pr_err("crashkernel reservation failed - "
 			       "memory is in use\n");
@@ -192,7 +192,7 @@ void __init reserve_crashkernel(void)
 	/*
 	 * Crash kernel trumps memory limit
 	 */
-	if ((lmb_end_of_DRAM() - memory_limit) <= crashk_res.end) {
+	if ((memblock_end_of_DRAM() - memory_limit) <= crashk_res.end) {
 		memory_limit = 0;
 		pr_info("Disabled memory limit for crashkernel\n");
 	}
@@ -201,7 +201,7 @@ void __init reserve_crashkernel(void)
 		"for crashkernel (System RAM: %ldMB)\n",
 		(unsigned long)(crash_size >> 20),
 		(unsigned long)(crashk_res.start),
-		(unsigned long)(lmb_phys_mem_size() >> 20));
+		(unsigned long)(memblock_phys_mem_size() >> 20));
 
 	return;
 
diff --git a/arch/sh/kernel/setup.c b/arch/sh/kernel/setup.c
index 2727346..e769401 100644
--- a/arch/sh/kernel/setup.c
+++ b/arch/sh/kernel/setup.c
@@ -30,7 +30,7 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/platform_device.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <asm/page.h>
@@ -141,10 +141,10 @@ void __init check_for_initrd(void)
 		goto disable;
 	}
 
-	if (unlikely(end > lmb_end_of_DRAM())) {
+	if (unlikely(end > memblock_end_of_DRAM())) {
 		pr_err("initrd extends beyond end of memory "
 		       "(0x%08lx > 0x%08lx)\ndisabling initrd\n",
-		       end, (unsigned long)lmb_end_of_DRAM());
+		       end, (unsigned long)memblock_end_of_DRAM());
 		goto disable;
 	}
 
@@ -161,7 +161,7 @@ void __init check_for_initrd(void)
 	initrd_start = (unsigned long)__va(__pa(start));
 	initrd_end = initrd_start + INITRD_SIZE;
 
-	lmb_reserve(__pa(initrd_start), INITRD_SIZE);
+	memblock_reserve(__pa(initrd_start), INITRD_SIZE);
 
 	return;
 
diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
index 46f84de..d0e2491 100644
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -16,7 +16,7 @@
 #include <linux/pagemap.h>
 #include <linux/percpu.h>
 #include <linux/io.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 #include <linux/dma-mapping.h>
 #include <asm/mmu_context.h>
 #include <asm/mmzone.h>
@@ -33,7 +33,7 @@ pgd_t swapper_pg_dir[PTRS_PER_PGD];
 
 void __init generic_mem_init(void)
 {
-	lmb_add(__MEMORY_START, __MEMORY_SIZE);
+	memblock_add(__MEMORY_START, __MEMORY_SIZE);
 }
 
 void __init __weak plat_mem_setup(void)
@@ -176,12 +176,12 @@ void __init allocate_pgdat(unsigned int nid)
 	get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
 
 #ifdef CONFIG_NEED_MULTIPLE_NODES
-	phys = __lmb_alloc_base(sizeof(struct pglist_data),
+	phys = __memblock_alloc_base(sizeof(struct pglist_data),
 				SMP_CACHE_BYTES, end_pfn << PAGE_SHIFT);
 	/* Retry with all of system memory */
 	if (!phys)
-		phys = __lmb_alloc_base(sizeof(struct pglist_data),
-					SMP_CACHE_BYTES, lmb_end_of_DRAM());
+		phys = __memblock_alloc_base(sizeof(struct pglist_data),
+					SMP_CACHE_BYTES, memblock_end_of_DRAM());
 	if (!phys)
 		panic("Can't allocate pgdat for node %d\n", nid);
 
@@ -212,7 +212,7 @@ static void __init bootmem_init_one_node(unsigned int nid)
 
 	total_pages = bootmem_bootmap_pages(p->node_spanned_pages);
 
-	paddr = lmb_alloc(total_pages << PAGE_SHIFT, PAGE_SIZE);
+	paddr = memblock_alloc(total_pages << PAGE_SHIFT, PAGE_SIZE);
 	if (!paddr)
 		panic("Can't allocate bootmap for nid[%d]\n", nid);
 
@@ -227,9 +227,9 @@ static void __init bootmem_init_one_node(unsigned int nid)
 	 */
 	if (nid == 0) {
 		/* Reserve the sections we're already using. */
-		for (i = 0; i < lmb.reserved.cnt; i++)
-			reserve_bootmem(lmb.reserved.region[i].base,
-					lmb_size_bytes(&lmb.reserved, i),
+		for (i = 0; i < memblock.reserved.cnt; i++)
+			reserve_bootmem(memblock.reserved.region[i].base,
+					memblock_size_bytes(&memblock.reserved, i),
 					BOOTMEM_DEFAULT);
 	}
 
@@ -241,10 +241,10 @@ static void __init do_init_bootmem(void)
 	int i;
 
 	/* Add active regions with valid PFNs. */
-	for (i = 0; i < lmb.memory.cnt; i++) {
+	for (i = 0; i < memblock.memory.cnt; i++) {
 		unsigned long start_pfn, end_pfn;
-		start_pfn = lmb.memory.region[i].base >> PAGE_SHIFT;
-		end_pfn = start_pfn + lmb_size_pages(&lmb.memory, i);
+		start_pfn = memblock.memory.region[i].base >> PAGE_SHIFT;
+		end_pfn = start_pfn + memblock_size_pages(&memblock.memory, i);
 		__add_active_range(0, start_pfn, end_pfn);
 	}
 
@@ -276,7 +276,7 @@ static void __init early_reserve_mem(void)
 	 * this catches the (definitely buggy) case of us accidentally
 	 * initializing the bootmem allocator with an invalid RAM area.
 	 */
-	lmb_reserve(__MEMORY_START + CONFIG_ZERO_PAGE_OFFSET,
+	memblock_reserve(__MEMORY_START + CONFIG_ZERO_PAGE_OFFSET,
 		    (PFN_PHYS(start_pfn) + PAGE_SIZE - 1) -
 		    (__MEMORY_START + CONFIG_ZERO_PAGE_OFFSET));
 
@@ -284,7 +284,7 @@ static void __init early_reserve_mem(void)
 	 * Reserve physical pages below CONFIG_ZERO_PAGE_OFFSET.
 	 */
 	if (CONFIG_ZERO_PAGE_OFFSET != 0)
-		lmb_reserve(__MEMORY_START, CONFIG_ZERO_PAGE_OFFSET);
+		memblock_reserve(__MEMORY_START, CONFIG_ZERO_PAGE_OFFSET);
 
 	/*
 	 * Handle additional early reservations
@@ -299,27 +299,27 @@ void __init paging_init(void)
 	unsigned long vaddr, end;
 	int nid;
 
-	lmb_init();
+	memblock_init();
 
 	sh_mv.mv_mem_init();
 
 	early_reserve_mem();
 
-	lmb_enforce_memory_limit(memory_limit);
-	lmb_analyze();
+	memblock_enforce_memory_limit(memory_limit);
+	memblock_analyze();
 
-	lmb_dump_all();
+	memblock_dump_all();
 
 	/*
 	 * Determine low and high memory ranges:
 	 */
-	max_low_pfn = max_pfn = lmb_end_of_DRAM() >> PAGE_SHIFT;
+	max_low_pfn = max_pfn = memblock_end_of_DRAM() >> PAGE_SHIFT;
 	min_low_pfn = __MEMORY_START >> PAGE_SHIFT;
 
 	nodes_clear(node_online_map);
 
 	memory_start = (unsigned long)__va(__MEMORY_START);
-	memory_end = memory_start + (memory_limit ?: lmb_phys_mem_size());
+	memory_end = memory_start + (memory_limit ?: memblock_phys_mem_size());
 
 	uncached_init();
 	pmb_init();
diff --git a/arch/sh/mm/numa.c b/arch/sh/mm/numa.c
index a2e645f..3d85225 100644
--- a/arch/sh/mm/numa.c
+++ b/arch/sh/mm/numa.c
@@ -9,7 +9,7 @@
  */
 #include <linux/module.h>
 #include <linux/bootmem.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 #include <linux/mm.h>
 #include <linux/numa.h>
 #include <linux/pfn.h>
@@ -39,12 +39,12 @@ void __init setup_bootmem_node(int nid, unsigned long start, unsigned long end)
 	pmb_bolt_mapping((unsigned long)__va(start), start, end - start,
 			 PAGE_KERNEL);
 
-	lmb_add(start, end - start);
+	memblock_add(start, end - start);
 
 	__add_active_range(nid, start_pfn, end_pfn);
 
 	/* Node-local pgdat */
-	NODE_DATA(nid) = __va(lmb_alloc_base(sizeof(struct pglist_data),
+	NODE_DATA(nid) = __va(memblock_alloc_base(sizeof(struct pglist_data),
 					     SMP_CACHE_BYTES, end));
 	memset(NODE_DATA(nid), 0, sizeof(struct pglist_data));
 
@@ -54,7 +54,7 @@ void __init setup_bootmem_node(int nid, unsigned long start, unsigned long end)
 
 	/* Node-local bootmap */
 	bootmap_pages = bootmem_bootmap_pages(end_pfn - start_pfn);
-	bootmem_paddr = lmb_alloc_base(bootmap_pages << PAGE_SHIFT,
+	bootmem_paddr = memblock_alloc_base(bootmap_pages << PAGE_SHIFT,
 				       PAGE_SIZE, end);
 	init_bootmem_node(NODE_DATA(nid), bootmem_paddr >> PAGE_SHIFT,
 			  start_pfn, end_pfn);
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 6f1470b..c0015db 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -42,7 +42,7 @@ config SPARC64
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_KRETPROBES
 	select HAVE_KPROBES
-	select HAVE_LMB
+	select HAVE_MEMBLOCK
 	select HAVE_SYSCALL_WRAPPERS
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE_MCOUNT_RECORD
diff --git a/arch/sparc/include/asm/lmb.h b/arch/sparc/include/asm/lmb.h
deleted file mode 100644
index 6a352cb..0000000
--- a/arch/sparc/include/asm/lmb.h
+++ /dev/null
@@ -1,10 +0,0 @@
-#ifndef _SPARC64_LMB_H
-#define _SPARC64_LMB_H
-
-#include <asm/oplib.h>
-
-#define LMB_DBG(fmt...) prom_printf(fmt)
-
-#define LMB_REAL_LIMIT	0
-
-#endif /* !(_SPARC64_LMB_H) */
diff --git a/arch/sparc/include/asm/memblock.h b/arch/sparc/include/asm/memblock.h
new file mode 100644
index 0000000..f12af88
--- /dev/null
+++ b/arch/sparc/include/asm/memblock.h
@@ -0,0 +1,10 @@
+#ifndef _SPARC64_MEMBLOCK_H
+#define _SPARC64_MEMBLOCK_H
+
+#include <asm/oplib.h>
+
+#define MEMBLOCK_DBG(fmt...) prom_printf(fmt)
+
+#define MEMBLOCK_REAL_LIMIT	0
+
+#endif /* !(_SPARC64_MEMBLOCK_H) */
diff --git a/arch/sparc/kernel/mdesc.c b/arch/sparc/kernel/mdesc.c
index cdc91d9..83e85c2 100644
--- a/arch/sparc/kernel/mdesc.c
+++ b/arch/sparc/kernel/mdesc.c
@@ -4,7 +4,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/types.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 #include <linux/log2.h>
 #include <linux/list.h>
 #include <linux/slab.h>
@@ -86,7 +86,7 @@ static void mdesc_handle_init(struct mdesc_handle *hp,
 	hp->handle_size = handle_size;
 }
 
-static struct mdesc_handle * __init mdesc_lmb_alloc(unsigned int mdesc_size)
+static struct mdesc_handle * __init mdesc_memblock_alloc(unsigned int mdesc_size)
 {
 	unsigned int handle_size, alloc_size;
 	struct mdesc_handle *hp;
@@ -97,7 +97,7 @@ static struct mdesc_handle * __init mdesc_lmb_alloc(unsigned int mdesc_size)
 		       mdesc_size);
 	alloc_size = PAGE_ALIGN(handle_size);
 
-	paddr = lmb_alloc(alloc_size, PAGE_SIZE);
+	paddr = memblock_alloc(alloc_size, PAGE_SIZE);
 
 	hp = NULL;
 	if (paddr) {
@@ -107,7 +107,7 @@ static struct mdesc_handle * __init mdesc_lmb_alloc(unsigned int mdesc_size)
 	return hp;
 }
 
-static void mdesc_lmb_free(struct mdesc_handle *hp)
+static void mdesc_memblock_free(struct mdesc_handle *hp)
 {
 	unsigned int alloc_size;
 	unsigned long start;
@@ -120,9 +120,9 @@ static void mdesc_lmb_free(struct mdesc_handle *hp)
 	free_bootmem_late(start, alloc_size);
 }
 
-static struct mdesc_mem_ops lmb_mdesc_ops = {
-	.alloc = mdesc_lmb_alloc,
-	.free  = mdesc_lmb_free,
+static struct mdesc_mem_ops memblock_mdesc_ops = {
+	.alloc = mdesc_memblock_alloc,
+	.free  = mdesc_memblock_free,
 };
 
 static struct mdesc_handle *mdesc_kmalloc(unsigned int mdesc_size)
@@ -914,7 +914,7 @@ void __init sun4v_mdesc_init(void)
 
 	printk("MDESC: Size is %lu bytes.\n", len);
 
-	hp = mdesc_alloc(len, &lmb_mdesc_ops);
+	hp = mdesc_alloc(len, &memblock_mdesc_ops);
 	if (hp == NULL) {
 		prom_printf("MDESC: alloc of %lu bytes failed.\n", len);
 		prom_halt();
diff --git a/arch/sparc/kernel/prom_64.c b/arch/sparc/kernel/prom_64.c
index fb06ac2..466a327 100644
--- a/arch/sparc/kernel/prom_64.c
+++ b/arch/sparc/kernel/prom_64.c
@@ -20,7 +20,7 @@
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/module.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 #include <linux/of_device.h>
 
 #include <asm/prom.h>
@@ -34,7 +34,7 @@
 
 void * __init prom_early_alloc(unsigned long size)
 {
-	unsigned long paddr = lmb_alloc(size, SMP_CACHE_BYTES);
+	unsigned long paddr = memblock_alloc(size, SMP_CACHE_BYTES);
 	void *ret;
 
 	if (!paddr) {
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index b2831dc..f043451 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -23,7 +23,7 @@
 #include <linux/cache.h>
 #include <linux/sort.h>
 #include <linux/percpu.h>
-#include <linux/lmb.h>
+#include <linux/memblock.h>
 #include <linux/mmzone.h>
 #include <linux/gfp.h>
 
@@ -726,7 +726,7 @@ static void __init find_ramdisk(unsigned long phys_base)
 		initrd_start = ramdisk_image;
 		initrd_end = ramdisk_image + sparc_ramdisk_size;
 
-		lmb_reserve(initrd_start, sparc_ramdisk_size);
+		memblock_reserve(initrd_start, sparc_ramdisk_size);
 
 		initrd_start += PAGE_OFFSET;
 		initrd_end += PAGE_OFFSET;
@@ -822,7 +822,7 @@ static void __init allocate_node_data(int nid)
 	struct pglist_data *p;
 
 #ifdef CONFIG_NEED_MULTIPLE_NODES
-	paddr = lmb_alloc_nid(sizeof(struct pglist_data),
+	paddr = memblock_alloc_nid(sizeof(struct pglist_data),
 			      SMP_CACHE_BYTES, nid, nid_range);
 	if (!paddr) {
 		prom_printf("Cannot allocate pglist_data for nid[%d]\n", nid);
@@ -843,7 +843,7 @@ static void __init allocate_node_data(int nid)
 	if (p->node_spanned_pages) {
 		num_pages = bootmem_bootmap_pages(p->node_spanned_pages);
 
-		paddr = lmb_alloc_nid(num_pages << PAGE_SHIFT, PAGE_SIZE, nid,
+		paddr = memblock_alloc_nid(num_pages << PAGE_SHIFT, PAGE_SIZE, nid,
 				      nid_range);
 		if (!paddr) {
 			prom_printf("Cannot allocate bootmap for nid[%d]\n",
@@ -974,11 +974,11 @@ static void __init add_node_ranges(void)
 {
 	int i;
 
-	for (i = 0; i < lmb.memory.cnt; i++) {
-		unsigned long size = lmb_size_bytes(&lmb.memory, i);
+	for (i = 0; i < memblock.memory.cnt; i++) {
+		unsigned long size = memblock_size_bytes(&memblock.memory, i);
 		unsigned long start, end;
 
-		start = lmb.memory.region[i].base;
+		start = memblock.memory.region[i].base;
 		end = start + size;
 		while (start < end) {
 			unsigned long this_end;
@@ -1010,7 +1010,7 @@ static int __init grab_mlgroups(struct mdesc_handle *md)
 	if (!count)
 		return -ENOENT;
 
-	paddr = lmb_alloc(count * sizeof(struct mdesc_mlgroup),
+	paddr = memblock_alloc(count * sizeof(struct mdesc_mlgroup),
 			  SMP_CACHE_BYTES);
 	if (!paddr)
 		return -ENOMEM;
@@ -1051,7 +1051,7 @@ static int __init grab_mblocks(struct mdesc_handle *md)
 	if (!count)
 		return -ENOENT;
 
-	paddr = lmb_alloc(count * sizeof(struct mdesc_mblock),
+	paddr = memblock_alloc(count * sizeof(struct mdesc_mblock),
 			  SMP_CACHE_BYTES);
 	if (!paddr)
 		return -ENOMEM;
@@ -1279,8 +1279,8 @@ static int bootmem_init_numa(void)
 
 static void __init bootmem_init_nonnuma(void)
 {
-	unsigned long top_of_ram = lmb_end_of_DRAM();
-	unsigned long total_ram = lmb_phys_mem_size();
+	unsigned long top_of_ram = memblock_end_of_DRAM();
+	unsigned long total_ram = memblock_phys_mem_size();
 	unsigned int i;
 
 	numadbg("bootmem_init_nonnuma()\n");
@@ -1292,15 +1292,15 @@ static void __init bootmem_init_nonnuma(void)
 
 	init_node_masks_nonnuma();
 
-	for (i = 0; i < lmb.memory.cnt; i++) {
-		unsigned long size = lmb_size_bytes(&lmb.memory, i);
+	for (i = 0; i < memblock.memory.cnt; i++) {
+		unsigned long size = memblock_size_bytes(&memblock.memory, i);
 		unsigned long start_pfn, end_pfn;
 
 		if (!size)
 			continue;
 
-		start_pfn = lmb.memory.region[i].base >> PAGE_SHIFT;
-		end_pfn = start_pfn + lmb_size_pages(&lmb.memory, i);
+		start_pfn = memblock.memory.region[i].base >> PAGE_SHIFT;
+		end_pfn = start_pfn + memblock_size_pages(&memblock.memory, i);
 		add_active_range(0, start_pfn, end_pfn);
 	}
 
@@ -1338,9 +1338,9 @@ static void __init trim_reserved_in_node(int nid)
 
 	numadbg("  trim_reserved_in_node(%d)\n", nid);
 
-	for (i = 0; i < lmb.reserved.cnt; i++) {
-		unsigned long start = lmb.reserved.region[i].base;
-		unsigned long size = lmb_size_bytes(&lmb.reserved, i);
+	for (i = 0; i < memblock.reserved.cnt; i++) {
+		unsigned long start = memblock.reserved.region[i].base;
+		unsigned long size = memblock_size_bytes(&memblock.reserved, i);
 		unsigned long end = start + size;
 
 		reserve_range_in_node(nid, start, end);
@@ -1384,7 +1384,7 @@ static unsigned long __init bootmem_init(unsigned long phys_base)
 	unsigned long end_pfn;
 	int nid;
 
-	end_pfn = lmb_end_of_DRAM() >> PAGE_SHIFT;
+	end_pfn = memblock_end_of_DRAM() >> PAGE_SHIFT;
 	max_pfn = max_low_pfn = end_pfn;
 	min_low_pfn = (phys_base >> PAGE_SHIFT);
 
@@ -1734,7 +1734,7 @@ void __init paging_init(void)
 		sun4v_ktsb_init();
 	}
 
-	lmb_init();
+	memblock_init();
 
 	/* Find available physical memory...
 	 *
@@ -1752,17 +1752,17 @@ void __init paging_init(void)
 	phys_base = 0xffffffffffffffffUL;
 	for (i = 0; i < pavail_ents; i++) {
 		phys_base = min(phys_base, pavail[i].phys_addr);
-		lmb_add(pavail[i].phys_addr, pavail[i].reg_size);
+		memblock_add(pavail[i].phys_addr, pavail[i].reg_size);
 	}
 
-	lmb_reserve(kern_base, kern_size);
+	memblock_reserve(kern_base, kern_size);
 
 	find_ramdisk(phys_base);
 
-	lmb_enforce_memory_limit(cmdline_memory_size);
+	memblock_enforce_memory_limit(cmdline_memory_size);
 
-	lmb_analyze();
-	lmb_dump_all();
+	memblock_analyze();
+	memblock_dump_all();
 
 	set_bit(0, mmu_context_bmap);
 
@@ -1816,8 +1816,8 @@ void __init paging_init(void)
 	 */
 	for_each_possible_cpu(i) {
 		/* XXX Use node local allocations... XXX */
-		softirq_stack[i] = __va(lmb_alloc(THREAD_SIZE, THREAD_SIZE));
-		hardirq_stack[i] = __va(lmb_alloc(THREAD_SIZE, THREAD_SIZE));
+		softirq_stack[i] = __va(memblock_alloc(THREAD_SIZE, THREAD_SIZE));
+		hardirq_stack[i] = __va(memblock_alloc(THREAD_SIZE, THREAD_SIZE));
 	}
 
 	/* Setup bootmem... */
diff --git a/include/linux/lmb.h b/include/linux/lmb.h
deleted file mode 100644
index f3d1433..0000000
--- a/include/linux/lmb.h
+++ /dev/null
@@ -1,89 +0,0 @@
-#ifndef _LINUX_LMB_H
-#define _LINUX_LMB_H
-#ifdef __KERNEL__
-
-/*
- * Logical memory blocks.
- *
- * Copyright (C) 2001 Peter Bergner, IBM Corp.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#include <linux/init.h>
-#include <linux/mm.h>
-
-#define MAX_LMB_REGIONS 128
-
-struct lmb_property {
-	u64 base;
-	u64 size;
-};
-
-struct lmb_region {
-	unsigned long cnt;
-	u64 size;
-	struct lmb_property region[MAX_LMB_REGIONS+1];
-};
-
-struct lmb {
-	unsigned long debug;
-	u64 rmo_size;
-	struct lmb_region memory;
-	struct lmb_region reserved;
-};
-
-extern struct lmb lmb;
-
-extern void __init lmb_init(void);
-extern void __init lmb_analyze(void);
-extern long lmb_add(u64 base, u64 size);
-extern long lmb_remove(u64 base, u64 size);
-extern long __init lmb_free(u64 base, u64 size);
-extern long __init lmb_reserve(u64 base, u64 size);
-extern u64 __init lmb_alloc_nid(u64 size, u64 align, int nid,
-				u64 (*nid_range)(u64, u64, int *));
-extern u64 __init lmb_alloc(u64 size, u64 align);
-extern u64 __init lmb_alloc_base(u64 size,
-		u64, u64 max_addr);
-extern u64 __init __lmb_alloc_base(u64 size,
-		u64 align, u64 max_addr);
-extern u64 __init lmb_phys_mem_size(void);
-extern u64 lmb_end_of_DRAM(void);
-extern void __init lmb_enforce_memory_limit(u64 memory_limit);
-extern int __init lmb_is_reserved(u64 addr);
-extern int lmb_is_region_reserved(u64 base, u64 size);
-extern int lmb_find(struct lmb_property *res);
-
-extern void lmb_dump_all(void);
-
-static inline u64
-lmb_size_bytes(struct lmb_region *type, unsigned long region_nr)
-{
-	return type->region[region_nr].size;
-}
-static inline u64
-lmb_size_pages(struct lmb_region *type, unsigned long region_nr)
-{
-	return lmb_size_bytes(type, region_nr) >> PAGE_SHIFT;
-}
-static inline u64
-lmb_start_pfn(struct lmb_region *type, unsigned long region_nr)
-{
-	return type->region[region_nr].base >> PAGE_SHIFT;
-}
-static inline u64
-lmb_end_pfn(struct lmb_region *type, unsigned long region_nr)
-{
-	return lmb_start_pfn(type, region_nr) +
-	       lmb_size_pages(type, region_nr);
-}
-
-#include <asm/lmb.h>
-
-#endif /* __KERNEL__ */
-
-#endif /* _LINUX_LMB_H */
diff --git a/include/linux/memblock.h b/include/linux/memblock.h
new file mode 100644
index 0000000..a59faf2
--- /dev/null
+++ b/include/linux/memblock.h
@@ -0,0 +1,89 @@
+#ifndef _LINUX_MEMBLOCK_H
+#define _LINUX_MEMBLOCK_H
+#ifdef __KERNEL__
+
+/*
+ * Logical memory blocks.
+ *
+ * Copyright (C) 2001 Peter Bergner, IBM Corp.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/init.h>
+#include <linux/mm.h>
+
+#define MAX_MEMBLOCK_REGIONS 128
+
+struct memblock_property {
+	u64 base;
+	u64 size;
+};
+
+struct memblock_region {
+	unsigned long cnt;
+	u64 size;
+	struct memblock_property region[MAX_MEMBLOCK_REGIONS+1];
+};
+
+struct memblock {
+	unsigned long debug;
+	u64 rmo_size;
+	struct memblock_region memory;
+	struct memblock_region reserved;
+};
+
+extern struct memblock memblock;
+
+extern void __init memblock_init(void);
+extern void __init memblock_analyze(void);
+extern long memblock_add(u64 base, u64 size);
+extern long memblock_remove(u64 base, u64 size);
+extern long __init memblock_free(u64 base, u64 size);
+extern long __init memblock_reserve(u64 base, u64 size);
+extern u64 __init memblock_alloc_nid(u64 size, u64 align, int nid,
+				u64 (*nid_range)(u64, u64, int *));
+extern u64 __init memblock_alloc(u64 size, u64 align);
+extern u64 __init memblock_alloc_base(u64 size,
+		u64, u64 max_addr);
+extern u64 __init __memblock_alloc_base(u64 size,
+		u64 align, u64 max_addr);
+extern u64 __init memblock_phys_mem_size(void);
+extern u64 memblock_end_of_DRAM(void);
+extern void __init memblock_enforce_memory_limit(u64 memory_limit);
+extern int __init memblock_is_reserved(u64 addr);
+extern int memblock_is_region_reserved(u64 base, u64 size);
+extern int memblock_find(struct memblock_property *res);
+
+extern void memblock_dump_all(void);
+
+static inline u64
+memblock_size_bytes(struct memblock_region *type, unsigned long region_nr)
+{
+	return type->region[region_nr].size;
+}
+static inline u64
+memblock_size_pages(struct memblock_region *type, unsigned long region_nr)
+{
+	return memblock_size_bytes(type, region_nr) >> PAGE_SHIFT;
+}
+static inline u64
+memblock_start_pfn(struct memblock_region *type, unsigned long region_nr)
+{
+	return type->region[region_nr].base >> PAGE_SHIFT;
+}
+static inline u64
+memblock_end_pfn(struct memblock_region *type, unsigned long region_nr)
+{
+	return memblock_start_pfn(type, region_nr) +
+	       memblock_size_pages(type, region_nr);
+}
+
+#include <asm/memblock.h>
+
+#endif /* __KERNEL__ */
+
+#endif /* _LINUX_MEMBLOCK_H */
diff --git a/lib/Kconfig b/lib/Kconfig
index 170d8ca..5b916bc 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -181,9 +181,6 @@ config HAS_DMA
 config CHECK_SIGNATURE
 	bool
 
-config HAVE_LMB
-	boolean
-
 config CPUMASK_OFFSTACK
 	bool "Force CPU masks off stack" if DEBUG_PER_CPU_MAPS
 	help
diff --git a/lib/Makefile b/lib/Makefile
index 3f1062c..0bfabba 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -89,8 +89,6 @@ obj-$(CONFIG_CPU_NOTIFIER_ERROR_INJECT) += cpu-notifier-error-inject.o
 
 lib-$(CONFIG_GENERIC_BUG) += bug.o
 
-obj-$(CONFIG_HAVE_LMB) += lmb.o
-
 obj-$(CONFIG_HAVE_ARCH_TRACEHOOK) += syscall.o
 
 obj-$(CONFIG_DYNAMIC_DEBUG) += dynamic_debug.o
diff --git a/lib/lmb.c b/lib/lmb.c
deleted file mode 100644
index b1fc526..0000000
--- a/lib/lmb.c
+++ /dev/null
@@ -1,541 +0,0 @@
-/*
- * Procedures for maintaining information about logical memory blocks.
- *
- * Peter Bergner, IBM Corp.	June 2001.
- * Copyright (C) 2001 Peter Bergner.
- *
- *      This program is free software; you can redistribute it and/or
- *      modify it under the terms of the GNU General Public License
- *      as published by the Free Software Foundation; either version
- *      2 of the License, or (at your option) any later version.
- */
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/bitops.h>
-#include <linux/lmb.h>
-
-#define LMB_ALLOC_ANYWHERE	0
-
-struct lmb lmb;
-
-static int lmb_debug;
-
-static int __init early_lmb(char *p)
-{
-	if (p && strstr(p, "debug"))
-		lmb_debug = 1;
-	return 0;
-}
-early_param("lmb", early_lmb);
-
-static void lmb_dump(struct lmb_region *region, char *name)
-{
-	unsigned long long base, size;
-	int i;
-
-	pr_info(" %s.cnt  = 0x%lx\n", name, region->cnt);
-
-	for (i = 0; i < region->cnt; i++) {
-		base = region->region[i].base;
-		size = region->region[i].size;
-
-		pr_info(" %s[0x%x]\t0x%016llx - 0x%016llx, 0x%llx bytes\n",
-		    name, i, base, base + size - 1, size);
-	}
-}
-
-void lmb_dump_all(void)
-{
-	if (!lmb_debug)
-		return;
-
-	pr_info("LMB configuration:\n");
-	pr_info(" rmo_size    = 0x%llx\n", (unsigned long long)lmb.rmo_size);
-	pr_info(" memory.size = 0x%llx\n", (unsigned long long)lmb.memory.size);
-
-	lmb_dump(&lmb.memory, "memory");
-	lmb_dump(&lmb.reserved, "reserved");
-}
-
-static unsigned long lmb_addrs_overlap(u64 base1, u64 size1, u64 base2,
-					u64 size2)
-{
-	return ((base1 < (base2 + size2)) && (base2 < (base1 + size1)));
-}
-
-static long lmb_addrs_adjacent(u64 base1, u64 size1, u64 base2, u64 size2)
-{
-	if (base2 == base1 + size1)
-		return 1;
-	else if (base1 == base2 + size2)
-		return -1;
-
-	return 0;
-}
-
-static long lmb_regions_adjacent(struct lmb_region *rgn,
-		unsigned long r1, unsigned long r2)
-{
-	u64 base1 = rgn->region[r1].base;
-	u64 size1 = rgn->region[r1].size;
-	u64 base2 = rgn->region[r2].base;
-	u64 size2 = rgn->region[r2].size;
-
-	return lmb_addrs_adjacent(base1, size1, base2, size2);
-}
-
-static void lmb_remove_region(struct lmb_region *rgn, unsigned long r)
-{
-	unsigned long i;
-
-	for (i = r; i < rgn->cnt - 1; i++) {
-		rgn->region[i].base = rgn->region[i + 1].base;
-		rgn->region[i].size = rgn->region[i + 1].size;
-	}
-	rgn->cnt--;
-}
-
-/* Assumption: base addr of region 1 < base addr of region 2 */
-static void lmb_coalesce_regions(struct lmb_region *rgn,
-		unsigned long r1, unsigned long r2)
-{
-	rgn->region[r1].size += rgn->region[r2].size;
-	lmb_remove_region(rgn, r2);
-}
-
-void __init lmb_init(void)
-{
-	/* Create a dummy zero size LMB which will get coalesced away later.
-	 * This simplifies the lmb_add() code below...
-	 */
-	lmb.memory.region[0].base = 0;
-	lmb.memory.region[0].size = 0;
-	lmb.memory.cnt = 1;
-
-	/* Ditto. */
-	lmb.reserved.region[0].base = 0;
-	lmb.reserved.region[0].size = 0;
-	lmb.reserved.cnt = 1;
-}
-
-void __init lmb_analyze(void)
-{
-	int i;
-
-	lmb.memory.size = 0;
-
-	for (i = 0; i < lmb.memory.cnt; i++)
-		lmb.memory.size += lmb.memory.region[i].size;
-}
-
-static long lmb_add_region(struct lmb_region *rgn, u64 base, u64 size)
-{
-	unsigned long coalesced = 0;
-	long adjacent, i;
-
-	if ((rgn->cnt == 1) && (rgn->region[0].size == 0)) {
-		rgn->region[0].base = base;
-		rgn->region[0].size = size;
-		return 0;
-	}
-
-	/* First try and coalesce this LMB with another. */
-	for (i = 0; i < rgn->cnt; i++) {
-		u64 rgnbase = rgn->region[i].base;
-		u64 rgnsize = rgn->region[i].size;
-
-		if ((rgnbase == base) && (rgnsize == size))
-			/* Already have this region, so we're done */
-			return 0;
-
-		adjacent = lmb_addrs_adjacent(base, size, rgnbase, rgnsize);
-		if (adjacent > 0) {
-			rgn->region[i].base -= size;
-			rgn->region[i].size += size;
-			coalesced++;
-			break;
-		} else if (adjacent < 0) {
-			rgn->region[i].size += size;
-			coalesced++;
-			break;
-		}
-	}
-
-	if ((i < rgn->cnt - 1) && lmb_regions_adjacent(rgn, i, i+1)) {
-		lmb_coalesce_regions(rgn, i, i+1);
-		coalesced++;
-	}
-
-	if (coalesced)
-		return coalesced;
-	if (rgn->cnt >= MAX_LMB_REGIONS)
-		return -1;
-
-	/* Couldn't coalesce the LMB, so add it to the sorted table. */
-	for (i = rgn->cnt - 1; i >= 0; i--) {
-		if (base < rgn->region[i].base) {
-			rgn->region[i+1].base = rgn->region[i].base;
-			rgn->region[i+1].size = rgn->region[i].size;
-		} else {
-			rgn->region[i+1].base = base;
-			rgn->region[i+1].size = size;
-			break;
-		}
-	}
-
-	if (base < rgn->region[0].base) {
-		rgn->region[0].base = base;
-		rgn->region[0].size = size;
-	}
-	rgn->cnt++;
-
-	return 0;
-}
-
-long lmb_add(u64 base, u64 size)
-{
-	struct lmb_region *_rgn = &lmb.memory;
-
-	/* On pSeries LPAR systems, the first LMB is our RMO region. */
-	if (base == 0)
-		lmb.rmo_size = size;
-
-	return lmb_add_region(_rgn, base, size);
-
-}
-
-static long __lmb_remove(struct lmb_region *rgn, u64 base, u64 size)
-{
-	u64 rgnbegin, rgnend;
-	u64 end = base + size;
-	int i;
-
-	rgnbegin = rgnend = 0; /* supress gcc warnings */
-
-	/* Find the region where (base, size) belongs to */
-	for (i=0; i < rgn->cnt; i++) {
-		rgnbegin = rgn->region[i].base;
-		rgnend = rgnbegin + rgn->region[i].size;
-
-		if ((rgnbegin <= base) && (end <= rgnend))
-			break;
-	}
-
-	/* Didn't find the region */
-	if (i == rgn->cnt)
-		return -1;
-
-	/* Check to see if we are removing entire region */
-	if ((rgnbegin == base) && (rgnend == end)) {
-		lmb_remove_region(rgn, i);
-		return 0;
-	}
-
-	/* Check to see if region is matching at the front */
-	if (rgnbegin == base) {
-		rgn->region[i].base = end;
-		rgn->region[i].size -= size;
-		return 0;
-	}
-
-	/* Check to see if the region is matching at the end */
-	if (rgnend == end) {
-		rgn->region[i].size -= size;
-		return 0;
-	}
-
-	/*
-	 * We need to split the entry -  adjust the current one to the
-	 * beginging of the hole and add the region after hole.
-	 */
-	rgn->region[i].size = base - rgn->region[i].base;
-	return lmb_add_region(rgn, end, rgnend - end);
-}
-
-long lmb_remove(u64 base, u64 size)
-{
-	return __lmb_remove(&lmb.memory, base, size);
-}
-
-long __init lmb_free(u64 base, u64 size)
-{
-	return __lmb_remove(&lmb.reserved, base, size);
-}
-
-long __init lmb_reserve(u64 base, u64 size)
-{
-	struct lmb_region *_rgn = &lmb.reserved;
-
-	BUG_ON(0 == size);
-
-	return lmb_add_region(_rgn, base, size);
-}
-
-long lmb_overlaps_region(struct lmb_region *rgn, u64 base, u64 size)
-{
-	unsigned long i;
-
-	for (i = 0; i < rgn->cnt; i++) {
-		u64 rgnbase = rgn->region[i].base;
-		u64 rgnsize = rgn->region[i].size;
-		if (lmb_addrs_overlap(base, size, rgnbase, rgnsize))
-			break;
-	}
-
-	return (i < rgn->cnt) ? i : -1;
-}
-
-static u64 lmb_align_down(u64 addr, u64 size)
-{
-	return addr & ~(size - 1);
-}
-
-static u64 lmb_align_up(u64 addr, u64 size)
-{
-	return (addr + (size - 1)) & ~(size - 1);
-}
-
-static u64 __init lmb_alloc_nid_unreserved(u64 start, u64 end,
-					   u64 size, u64 align)
-{
-	u64 base, res_base;
-	long j;
-
-	base = lmb_align_down((end - size), align);
-	while (start <= base) {
-		j = lmb_overlaps_region(&lmb.reserved, base, size);
-		if (j < 0) {
-			/* this area isn't reserved, take it */
-			if (lmb_add_region(&lmb.reserved, base, size) < 0)
-				base = ~(u64)0;
-			return base;
-		}
-		res_base = lmb.reserved.region[j].base;
-		if (res_base < size)
-			break;
-		base = lmb_align_down(res_base - size, align);
-	}
-
-	return ~(u64)0;
-}
-
-static u64 __init lmb_alloc_nid_region(struct lmb_property *mp,
-				       u64 (*nid_range)(u64, u64, int *),
-				       u64 size, u64 align, int nid)
-{
-	u64 start, end;
-
-	start = mp->base;
-	end = start + mp->size;
-
-	start = lmb_align_up(start, align);
-	while (start < end) {
-		u64 this_end;
-		int this_nid;
-
-		this_end = nid_range(start, end, &this_nid);
-		if (this_nid == nid) {
-			u64 ret = lmb_alloc_nid_unreserved(start, this_end,
-							   size, align);
-			if (ret != ~(u64)0)
-				return ret;
-		}
-		start = this_end;
-	}
-
-	return ~(u64)0;
-}
-
-u64 __init lmb_alloc_nid(u64 size, u64 align, int nid,
-			 u64 (*nid_range)(u64 start, u64 end, int *nid))
-{
-	struct lmb_region *mem = &lmb.memory;
-	int i;
-
-	BUG_ON(0 == size);
-
-	size = lmb_align_up(size, align);
-
-	for (i = 0; i < mem->cnt; i++) {
-		u64 ret = lmb_alloc_nid_region(&mem->region[i],
-					       nid_range,
-					       size, align, nid);
-		if (ret != ~(u64)0)
-			return ret;
-	}
-
-	return lmb_alloc(size, align);
-}
-
-u64 __init lmb_alloc(u64 size, u64 align)
-{
-	return lmb_alloc_base(size, align, LMB_ALLOC_ANYWHERE);
-}
-
-u64 __init lmb_alloc_base(u64 size, u64 align, u64 max_addr)
-{
-	u64 alloc;
-
-	alloc = __lmb_alloc_base(size, align, max_addr);
-
-	if (alloc == 0)
-		panic("ERROR: Failed to allocate 0x%llx bytes below 0x%llx.\n",
-		      (unsigned long long) size, (unsigned long long) max_addr);
-
-	return alloc;
-}
-
-u64 __init __lmb_alloc_base(u64 size, u64 align, u64 max_addr)
-{
-	long i, j;
-	u64 base = 0;
-	u64 res_base;
-
-	BUG_ON(0 == size);
-
-	size = lmb_align_up(size, align);
-
-	/* On some platforms, make sure we allocate lowmem */
-	/* Note that LMB_REAL_LIMIT may be LMB_ALLOC_ANYWHERE */
-	if (max_addr == LMB_ALLOC_ANYWHERE)
-		max_addr = LMB_REAL_LIMIT;
-
-	for (i = lmb.memory.cnt - 1; i >= 0; i--) {
-		u64 lmbbase = lmb.memory.region[i].base;
-		u64 lmbsize = lmb.memory.region[i].size;
-
-		if (lmbsize < size)
-			continue;
-		if (max_addr == LMB_ALLOC_ANYWHERE)
-			base = lmb_align_down(lmbbase + lmbsize - size, align);
-		else if (lmbbase < max_addr) {
-			base = min(lmbbase + lmbsize, max_addr);
-			base = lmb_align_down(base - size, align);
-		} else
-			continue;
-
-		while (base && lmbbase <= base) {
-			j = lmb_overlaps_region(&lmb.reserved, base, size);
-			if (j < 0) {
-				/* this area isn't reserved, take it */
-				if (lmb_add_region(&lmb.reserved, base, size) < 0)
-					return 0;
-				return base;
-			}
-			res_base = lmb.reserved.region[j].base;
-			if (res_base < size)
-				break;
-			base = lmb_align_down(res_base - size, align);
-		}
-	}
-	return 0;
-}
-
-/* You must call lmb_analyze() before this. */
-u64 __init lmb_phys_mem_size(void)
-{
-	return lmb.memory.size;
-}
-
-u64 lmb_end_of_DRAM(void)
-{
-	int idx = lmb.memory.cnt - 1;
-
-	return (lmb.memory.region[idx].base + lmb.memory.region[idx].size);
-}
-
-/* You must call lmb_analyze() after this. */
-void __init lmb_enforce_memory_limit(u64 memory_limit)
-{
-	unsigned long i;
-	u64 limit;
-	struct lmb_property *p;
-
-	if (!memory_limit)
-		return;
-
-	/* Truncate the lmb regions to satisfy the memory limit. */
-	limit = memory_limit;
-	for (i = 0; i < lmb.memory.cnt; i++) {
-		if (limit > lmb.memory.region[i].size) {
-			limit -= lmb.memory.region[i].size;
-			continue;
-		}
-
-		lmb.memory.region[i].size = limit;
-		lmb.memory.cnt = i + 1;
-		break;
-	}
-
-	if (lmb.memory.region[0].size < lmb.rmo_size)
-		lmb.rmo_size = lmb.memory.region[0].size;
-
-	memory_limit = lmb_end_of_DRAM();
-
-	/* And truncate any reserves above the limit also. */
-	for (i = 0; i < lmb.reserved.cnt; i++) {
-		p = &lmb.reserved.region[i];
-
-		if (p->base > memory_limit)
-			p->size = 0;
-		else if ((p->base + p->size) > memory_limit)
-			p->size = memory_limit - p->base;
-
-		if (p->size == 0) {
-			lmb_remove_region(&lmb.reserved, i);
-			i--;
-		}
-	}
-}
-
-int __init lmb_is_reserved(u64 addr)
-{
-	int i;
-
-	for (i = 0; i < lmb.reserved.cnt; i++) {
-		u64 upper = lmb.reserved.region[i].base +
-			lmb.reserved.region[i].size - 1;
-		if ((addr >= lmb.reserved.region[i].base) && (addr <= upper))
-			return 1;
-	}
-	return 0;
-}
-
-int lmb_is_region_reserved(u64 base, u64 size)
-{
-	return lmb_overlaps_region(&lmb.reserved, base, size);
-}
-
-/*
- * Given a <base, len>, find which memory regions belong to this range.
- * Adjust the request and return a contiguous chunk.
- */
-int lmb_find(struct lmb_property *res)
-{
-	int i;
-	u64 rstart, rend;
-
-	rstart = res->base;
-	rend = rstart + res->size - 1;
-
-	for (i = 0; i < lmb.memory.cnt; i++) {
-		u64 start = lmb.memory.region[i].base;
-		u64 end = start + lmb.memory.region[i].size - 1;
-
-		if (start > rend)
-			return -1;
-
-		if ((end >= rstart) && (start < rend)) {
-			/* adjust the request */
-			if (rstart < start)
-				rstart = start;
-			if (rend > end)
-				rend = end;
-			res->base = rstart;
-			res->size = rend - rstart + 1;
-			return 0;
-		}
-	}
-	return -1;
-}
diff --git a/mm/Kconfig b/mm/Kconfig
index 0119a2f..e1a84fb 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -128,6 +128,9 @@ config SPARSEMEM_VMEMMAP
 	 pfn_to_page and page_to_pfn operations.  This is the most
 	 efficient option when sufficient kernel resources are available.
 
+config HAVE_MEMBLOCK
+	boolean
+
 # eventually, we can have this option just 'select SPARSEMEM'
 config MEMORY_HOTPLUG
 	bool "Allow for memory hot-add"
diff --git a/mm/Makefile b/mm/Makefile
index 8982504..34b2546 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -15,6 +15,8 @@ obj-y			:= bootmem.o filemap.o mempool.o oom_kill.o fadvise.o \
 			   $(mmu-y)
 obj-y += init-mm.o
 
+obj-$(CONFIG_HAVE_MEMBLOCK) += memblock.o
+
 obj-$(CONFIG_BOUNCE)	+= bounce.o
 obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o thrash.o
 obj-$(CONFIG_HAS_DMA)	+= dmapool.o
diff --git a/mm/memblock.c b/mm/memblock.c
new file mode 100644
index 0000000..3024eb3
--- /dev/null
+++ b/mm/memblock.c
@@ -0,0 +1,541 @@
+/*
+ * Procedures for maintaining information about logical memory blocks.
+ *
+ * Peter Bergner, IBM Corp.	June 2001.
+ * Copyright (C) 2001 Peter Bergner.
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/bitops.h>
+#include <linux/memblock.h>
+
+#define MEMBLOCK_ALLOC_ANYWHERE	0
+
+struct memblock memblock;
+
+static int memblock_debug;
+
+static int __init early_memblock(char *p)
+{
+	if (p && strstr(p, "debug"))
+		memblock_debug = 1;
+	return 0;
+}
+early_param("memblock", early_memblock);
+
+static void memblock_dump(struct memblock_region *region, char *name)
+{
+	unsigned long long base, size;
+	int i;
+
+	pr_info(" %s.cnt  = 0x%lx\n", name, region->cnt);
+
+	for (i = 0; i < region->cnt; i++) {
+		base = region->region[i].base;
+		size = region->region[i].size;
+
+		pr_info(" %s[0x%x]\t0x%016llx - 0x%016llx, 0x%llx bytes\n",
+		    name, i, base, base + size - 1, size);
+	}
+}
+
+void memblock_dump_all(void)
+{
+	if (!memblock_debug)
+		return;
+
+	pr_info("MEMBLOCK configuration:\n");
+	pr_info(" rmo_size    = 0x%llx\n", (unsigned long long)memblock.rmo_size);
+	pr_info(" memory.size = 0x%llx\n", (unsigned long long)memblock.memory.size);
+
+	memblock_dump(&memblock.memory, "memory");
+	memblock_dump(&memblock.reserved, "reserved");
+}
+
+static unsigned long memblock_addrs_overlap(u64 base1, u64 size1, u64 base2,
+					u64 size2)
+{
+	return ((base1 < (base2 + size2)) && (base2 < (base1 + size1)));
+}
+
+static long memblock_addrs_adjacent(u64 base1, u64 size1, u64 base2, u64 size2)
+{
+	if (base2 == base1 + size1)
+		return 1;
+	else if (base1 == base2 + size2)
+		return -1;
+
+	return 0;
+}
+
+static long memblock_regions_adjacent(struct memblock_region *rgn,
+		unsigned long r1, unsigned long r2)
+{
+	u64 base1 = rgn->region[r1].base;
+	u64 size1 = rgn->region[r1].size;
+	u64 base2 = rgn->region[r2].base;
+	u64 size2 = rgn->region[r2].size;
+
+	return memblock_addrs_adjacent(base1, size1, base2, size2);
+}
+
+static void memblock_remove_region(struct memblock_region *rgn, unsigned long r)
+{
+	unsigned long i;
+
+	for (i = r; i < rgn->cnt - 1; i++) {
+		rgn->region[i].base = rgn->region[i + 1].base;
+		rgn->region[i].size = rgn->region[i + 1].size;
+	}
+	rgn->cnt--;
+}
+
+/* Assumption: base addr of region 1 < base addr of region 2 */
+static void memblock_coalesce_regions(struct memblock_region *rgn,
+		unsigned long r1, unsigned long r2)
+{
+	rgn->region[r1].size += rgn->region[r2].size;
+	memblock_remove_region(rgn, r2);
+}
+
+void __init memblock_init(void)
+{
+	/* Create a dummy zero size MEMBLOCK which will get coalesced away later.
+	 * This simplifies the memblock_add() code below...
+	 */
+	memblock.memory.region[0].base = 0;
+	memblock.memory.region[0].size = 0;
+	memblock.memory.cnt = 1;
+
+	/* Ditto. */
+	memblock.reserved.region[0].base = 0;
+	memblock.reserved.region[0].size = 0;
+	memblock.reserved.cnt = 1;
+}
+
+void __init memblock_analyze(void)
+{
+	int i;
+
+	memblock.memory.size = 0;
+
+	for (i = 0; i < memblock.memory.cnt; i++)
+		memblock.memory.size += memblock.memory.region[i].size;
+}
+
+static long memblock_add_region(struct memblock_region *rgn, u64 base, u64 size)
+{
+	unsigned long coalesced = 0;
+	long adjacent, i;
+
+	if ((rgn->cnt == 1) && (rgn->region[0].size == 0)) {
+		rgn->region[0].base = base;
+		rgn->region[0].size = size;
+		return 0;
+	}
+
+	/* First try and coalesce this MEMBLOCK with another. */
+	for (i = 0; i < rgn->cnt; i++) {
+		u64 rgnbase = rgn->region[i].base;
+		u64 rgnsize = rgn->region[i].size;
+
+		if ((rgnbase == base) && (rgnsize == size))
+			/* Already have this region, so we're done */
+			return 0;
+
+		adjacent = memblock_addrs_adjacent(base, size, rgnbase, rgnsize);
+		if (adjacent > 0) {
+			rgn->region[i].base -= size;
+			rgn->region[i].size += size;
+			coalesced++;
+			break;
+		} else if (adjacent < 0) {
+			rgn->region[i].size += size;
+			coalesced++;
+			break;
+		}
+	}
+
+	if ((i < rgn->cnt - 1) && memblock_regions_adjacent(rgn, i, i+1)) {
+		memblock_coalesce_regions(rgn, i, i+1);
+		coalesced++;
+	}
+
+	if (coalesced)
+		return coalesced;
+	if (rgn->cnt >= MAX_MEMBLOCK_REGIONS)
+		return -1;
+
+	/* Couldn't coalesce the MEMBLOCK, so add it to the sorted table. */
+	for (i = rgn->cnt - 1; i >= 0; i--) {
+		if (base < rgn->region[i].base) {
+			rgn->region[i+1].base = rgn->region[i].base;
+			rgn->region[i+1].size = rgn->region[i].size;
+		} else {
+			rgn->region[i+1].base = base;
+			rgn->region[i+1].size = size;
+			break;
+		}
+	}
+
+	if (base < rgn->region[0].base) {
+		rgn->region[0].base = base;
+		rgn->region[0].size = size;
+	}
+	rgn->cnt++;
+
+	return 0;
+}
+
+long memblock_add(u64 base, u64 size)
+{
+	struct memblock_region *_rgn = &memblock.memory;
+
+	/* On pSeries LPAR systems, the first MEMBLOCK is our RMO region. */
+	if (base == 0)
+		memblock.rmo_size = size;
+
+	return memblock_add_region(_rgn, base, size);
+
+}
+
+static long __memblock_remove(struct memblock_region *rgn, u64 base, u64 size)
+{
+	u64 rgnbegin, rgnend;
+	u64 end = base + size;
+	int i;
+
+	rgnbegin = rgnend = 0; /* supress gcc warnings */
+
+	/* Find the region where (base, size) belongs to */
+	for (i=0; i < rgn->cnt; i++) {
+		rgnbegin = rgn->region[i].base;
+		rgnend = rgnbegin + rgn->region[i].size;
+
+		if ((rgnbegin <= base) && (end <= rgnend))
+			break;
+	}
+
+	/* Didn't find the region */
+	if (i == rgn->cnt)
+		return -1;
+
+	/* Check to see if we are removing entire region */
+	if ((rgnbegin == base) && (rgnend == end)) {
+		memblock_remove_region(rgn, i);
+		return 0;
+	}
+
+	/* Check to see if region is matching at the front */
+	if (rgnbegin == base) {
+		rgn->region[i].base = end;
+		rgn->region[i].size -= size;
+		return 0;
+	}
+
+	/* Check to see if the region is matching at the end */
+	if (rgnend == end) {
+		rgn->region[i].size -= size;
+		return 0;
+	}
+
+	/*
+	 * We need to split the entry -  adjust the current one to the
+	 * beginging of the hole and add the region after hole.
+	 */
+	rgn->region[i].size = base - rgn->region[i].base;
+	return memblock_add_region(rgn, end, rgnend - end);
+}
+
+long memblock_remove(u64 base, u64 size)
+{
+	return __memblock_remove(&memblock.memory, base, size);
+}
+
+long __init memblock_free(u64 base, u64 size)
+{
+	return __memblock_remove(&memblock.reserved, base, size);
+}
+
+long __init memblock_reserve(u64 base, u64 size)
+{
+	struct memblock_region *_rgn = &memblock.reserved;
+
+	BUG_ON(0 == size);
+
+	return memblock_add_region(_rgn, base, size);
+}
+
+long memblock_overlaps_region(struct memblock_region *rgn, u64 base, u64 size)
+{
+	unsigned long i;
+
+	for (i = 0; i < rgn->cnt; i++) {
+		u64 rgnbase = rgn->region[i].base;
+		u64 rgnsize = rgn->region[i].size;
+		if (memblock_addrs_overlap(base, size, rgnbase, rgnsize))
+			break;
+	}
+
+	return (i < rgn->cnt) ? i : -1;
+}
+
+static u64 memblock_align_down(u64 addr, u64 size)
+{
+	return addr & ~(size - 1);
+}
+
+static u64 memblock_align_up(u64 addr, u64 size)
+{
+	return (addr + (size - 1)) & ~(size - 1);
+}
+
+static u64 __init memblock_alloc_nid_unreserved(u64 start, u64 end,
+					   u64 size, u64 align)
+{
+	u64 base, res_base;
+	long j;
+
+	base = memblock_align_down((end - size), align);
+	while (start <= base) {
+		j = memblock_overlaps_region(&memblock.reserved, base, size);
+		if (j < 0) {
+			/* this area isn't reserved, take it */
+			if (memblock_add_region(&memblock.reserved, base, size) < 0)
+				base = ~(u64)0;
+			return base;
+		}
+		res_base = memblock.reserved.region[j].base;
+		if (res_base < size)
+			break;
+		base = memblock_align_down(res_base - size, align);
+	}
+
+	return ~(u64)0;
+}
+
+static u64 __init memblock_alloc_nid_region(struct memblock_property *mp,
+				       u64 (*nid_range)(u64, u64, int *),
+				       u64 size, u64 align, int nid)
+{
+	u64 start, end;
+
+	start = mp->base;
+	end = start + mp->size;
+
+	start = memblock_align_up(start, align);
+	while (start < end) {
+		u64 this_end;
+		int this_nid;
+
+		this_end = nid_range(start, end, &this_nid);
+		if (this_nid == nid) {
+			u64 ret = memblock_alloc_nid_unreserved(start, this_end,
+							   size, align);
+			if (ret != ~(u64)0)
+				return ret;
+		}
+		start = this_end;
+	}
+
+	return ~(u64)0;
+}
+
+u64 __init memblock_alloc_nid(u64 size, u64 align, int nid,
+			 u64 (*nid_range)(u64 start, u64 end, int *nid))
+{
+	struct memblock_region *mem = &memblock.memory;
+	int i;
+
+	BUG_ON(0 == size);
+
+	size = memblock_align_up(size, align);
+
+	for (i = 0; i < mem->cnt; i++) {
+		u64 ret = memblock_alloc_nid_region(&mem->region[i],
+					       nid_range,
+					       size, align, nid);
+		if (ret != ~(u64)0)
+			return ret;
+	}
+
+	return memblock_alloc(size, align);
+}
+
+u64 __init memblock_alloc(u64 size, u64 align)
+{
+	return memblock_alloc_base(size, align, MEMBLOCK_ALLOC_ANYWHERE);
+}
+
+u64 __init memblock_alloc_base(u64 size, u64 align, u64 max_addr)
+{
+	u64 alloc;
+
+	alloc = __memblock_alloc_base(size, align, max_addr);
+
+	if (alloc == 0)
+		panic("ERROR: Failed to allocate 0x%llx bytes below 0x%llx.\n",
+		      (unsigned long long) size, (unsigned long long) max_addr);
+
+	return alloc;
+}
+
+u64 __init __memblock_alloc_base(u64 size, u64 align, u64 max_addr)
+{
+	long i, j;
+	u64 base = 0;
+	u64 res_base;
+
+	BUG_ON(0 == size);
+
+	size = memblock_align_up(size, align);
+
+	/* On some platforms, make sure we allocate lowmem */
+	/* Note that MEMBLOCK_REAL_LIMIT may be MEMBLOCK_ALLOC_ANYWHERE */
+	if (max_addr == MEMBLOCK_ALLOC_ANYWHERE)
+		max_addr = MEMBLOCK_REAL_LIMIT;
+
+	for (i = memblock.memory.cnt - 1; i >= 0; i--) {
+		u64 memblockbase = memblock.memory.region[i].base;
+		u64 memblocksize = memblock.memory.region[i].size;
+
+		if (memblocksize < size)
+			continue;
+		if (max_addr == MEMBLOCK_ALLOC_ANYWHERE)
+			base = memblock_align_down(memblockbase + memblocksize - size, align);
+		else if (memblockbase < max_addr) {
+			base = min(memblockbase + memblocksize, max_addr);
+			base = memblock_align_down(base - size, align);
+		} else
+			continue;
+
+		while (base && memblockbase <= base) {
+			j = memblock_overlaps_region(&memblock.reserved, base, size);
+			if (j < 0) {
+				/* this area isn't reserved, take it */
+				if (memblock_add_region(&memblock.reserved, base, size) < 0)
+					return 0;
+				return base;
+			}
+			res_base = memblock.reserved.region[j].base;
+			if (res_base < size)
+				break;
+			base = memblock_align_down(res_base - size, align);
+		}
+	}
+	return 0;
+}
+
+/* You must call memblock_analyze() before this. */
+u64 __init memblock_phys_mem_size(void)
+{
+	return memblock.memory.size;
+}
+
+u64 memblock_end_of_DRAM(void)
+{
+	int idx = memblock.memory.cnt - 1;
+
+	return (memblock.memory.region[idx].base + memblock.memory.region[idx].size);
+}
+
+/* You must call memblock_analyze() after this. */
+void __init memblock_enforce_memory_limit(u64 memory_limit)
+{
+	unsigned long i;
+	u64 limit;
+	struct memblock_property *p;
+
+	if (!memory_limit)
+		return;
+
+	/* Truncate the memblock regions to satisfy the memory limit. */
+	limit = memory_limit;
+	for (i = 0; i < memblock.memory.cnt; i++) {
+		if (limit > memblock.memory.region[i].size) {
+			limit -= memblock.memory.region[i].size;
+			continue;
+		}
+
+		memblock.memory.region[i].size = limit;
+		memblock.memory.cnt = i + 1;
+		break;
+	}
+
+	if (memblock.memory.region[0].size < memblock.rmo_size)
+		memblock.rmo_size = memblock.memory.region[0].size;
+
+	memory_limit = memblock_end_of_DRAM();
+
+	/* And truncate any reserves above the limit also. */
+	for (i = 0; i < memblock.reserved.cnt; i++) {
+		p = &memblock.reserved.region[i];
+
+		if (p->base > memory_limit)
+			p->size = 0;
+		else if ((p->base + p->size) > memory_limit)
+			p->size = memory_limit - p->base;
+
+		if (p->size == 0) {
+			memblock_remove_region(&memblock.reserved, i);
+			i--;
+		}
+	}
+}
+
+int __init memblock_is_reserved(u64 addr)
+{
+	int i;
+
+	for (i = 0; i < memblock.reserved.cnt; i++) {
+		u64 upper = memblock.reserved.region[i].base +
+			memblock.reserved.region[i].size - 1;
+		if ((addr >= memblock.reserved.region[i].base) && (addr <= upper))
+			return 1;
+	}
+	return 0;
+}
+
+int memblock_is_region_reserved(u64 base, u64 size)
+{
+	return memblock_overlaps_region(&memblock.reserved, base, size);
+}
+
+/*
+ * Given a <base, len>, find which memory regions belong to this range.
+ * Adjust the request and return a contiguous chunk.
+ */
+int memblock_find(struct memblock_property *res)
+{
+	int i;
+	u64 rstart, rend;
+
+	rstart = res->base;
+	rend = rstart + res->size - 1;
+
+	for (i = 0; i < memblock.memory.cnt; i++) {
+		u64 start = memblock.memory.region[i].base;
+		u64 end = start + memblock.memory.region[i].size - 1;
+
+		if (start > rend)
+			return -1;
+
+		if ((end >= rstart) && (start < rend)) {
+			/* adjust the request */
+			if (rstart < start)
+				rstart = start;
+			if (rend > end)
+				rend = end;
+			res->base = rstart;
+			res->size = rend - rstart + 1;
+			return 0;
+		}
+	}
+	return -1;
+}
-- 
1.6.4.2
