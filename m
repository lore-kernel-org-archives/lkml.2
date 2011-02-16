Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763Ab1BPIv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 03:51:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:53788 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757799Ab1BPIvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 03:51:24 -0500
Date: Wed, 16 Feb 2011 08:51:08 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <4D1933D1.9020609@kernel.org>
References: <4D1933D1.9020609@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86-64, numa: Put pgtable to local node memory
Message-ID: <tip-1411e0ec3123ae4c4ead6bfc9fe3ee5a3ae5c327@git.kernel.org>
Git-Commit-ID: 1411e0ec3123ae4c4ead6bfc9fe3ee5a3ae5c327
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Feb 2011 08:51:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1411e0ec3123ae4c4ead6bfc9fe3ee5a3ae5c327
Gitweb:     http://git.kernel.org/tip/1411e0ec3123ae4c4ead6bfc9fe3ee5a3ae5c327
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Mon, 27 Dec 2010 16:48:17 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 29 Dec 2010 15:48:08 -0800

x86-64, numa: Put pgtable to local node memory

Introduce init_memory_mapping_high(), and use it with 64bit.

It will go with every memory segment above 4g to create page table to the
memory range itself.

before this patch all page tables was on one node.

with this patch, one RED-PEN is killed

debug out for 8 sockets system after patch
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: [0x00000000000000-0x0000007f74ffff]
[    0.000000]  0000000000 - 007f600000 page 2M
[    0.000000]  007f600000 - 007f750000 page 4k
[    0.000000] kernel direct mapping tables up to 7f750000 @ [0x7f74c000-0x7f74ffff]
[    0.000000] RAMDISK: 7bc84000 - 7f745000
....
[    0.000000] Adding active range (0, 0x10, 0x95) 0 entries of 3200 used
[    0.000000] Adding active range (0, 0x100, 0x7f750) 1 entries of 3200 used
[    0.000000] Adding active range (0, 0x100000, 0x1080000) 2 entries of 3200 used
[    0.000000] Adding active range (1, 0x1080000, 0x2080000) 3 entries of 3200 used
[    0.000000] Adding active range (2, 0x2080000, 0x3080000) 4 entries of 3200 used
[    0.000000] Adding active range (3, 0x3080000, 0x4080000) 5 entries of 3200 used
[    0.000000] Adding active range (4, 0x4080000, 0x5080000) 6 entries of 3200 used
[    0.000000] Adding active range (5, 0x5080000, 0x6080000) 7 entries of 3200 used
[    0.000000] Adding active range (6, 0x6080000, 0x7080000) 8 entries of 3200 used
[    0.000000] Adding active range (7, 0x7080000, 0x8080000) 9 entries of 3200 used
[    0.000000] init_memory_mapping: [0x00000100000000-0x0000107fffffff]
[    0.000000]  0100000000 - 1080000000 page 2M
[    0.000000] kernel direct mapping tables up to 1080000000 @ [0x107ffbd000-0x107fffffff]
[    0.000000]     memblock_x86_reserve_range: [0x107ffc2000-0x107fffffff]          PGTABLE
[    0.000000] init_memory_mapping: [0x00001080000000-0x0000207fffffff]
[    0.000000]  1080000000 - 2080000000 page 2M
[    0.000000] kernel direct mapping tables up to 2080000000 @ [0x207ff7d000-0x207fffffff]
[    0.000000]     memblock_x86_reserve_range: [0x207ffc0000-0x207fffffff]          PGTABLE
[    0.000000] init_memory_mapping: [0x00002080000000-0x0000307fffffff]
[    0.000000]  2080000000 - 3080000000 page 2M
[    0.000000] kernel direct mapping tables up to 3080000000 @ [0x307ff3d000-0x307fffffff]
[    0.000000]     memblock_x86_reserve_range: [0x307ffc0000-0x307fffffff]          PGTABLE
[    0.000000] init_memory_mapping: [0x00003080000000-0x0000407fffffff]
[    0.000000]  3080000000 - 4080000000 page 2M
[    0.000000] kernel direct mapping tables up to 4080000000 @ [0x407fefd000-0x407fffffff]
[    0.000000]     memblock_x86_reserve_range: [0x407ffc0000-0x407fffffff]          PGTABLE
[    0.000000] init_memory_mapping: [0x00004080000000-0x0000507fffffff]
[    0.000000]  4080000000 - 5080000000 page 2M
[    0.000000] kernel direct mapping tables up to 5080000000 @ [0x507febd000-0x507fffffff]
[    0.000000]     memblock_x86_reserve_range: [0x507ffc0000-0x507fffffff]          PGTABLE
[    0.000000] init_memory_mapping: [0x00005080000000-0x0000607fffffff]
[    0.000000]  5080000000 - 6080000000 page 2M
[    0.000000] kernel direct mapping tables up to 6080000000 @ [0x607fe7d000-0x607fffffff]
[    0.000000]     memblock_x86_reserve_range: [0x607ffc0000-0x607fffffff]          PGTABLE
[    0.000000] init_memory_mapping: [0x00006080000000-0x0000707fffffff]
[    0.000000]  6080000000 - 7080000000 page 2M
[    0.000000] kernel direct mapping tables up to 7080000000 @ [0x707fe3d000-0x707fffffff]
[    0.000000]     memblock_x86_reserve_range: [0x707ffc0000-0x707fffffff]          PGTABLE
[    0.000000] init_memory_mapping: [0x00007080000000-0x0000807fffffff]
[    0.000000]  7080000000 - 8080000000 page 2M
[    0.000000] kernel direct mapping tables up to 8080000000 @ [0x807fdfc000-0x807fffffff]
[    0.000000]     memblock_x86_reserve_range: [0x807ffbf000-0x807fffffff]          PGTABLE
[    0.000000] Initmem setup node 0 [0000000000000000-000000107fffffff]
[    0.000000]   NODE_DATA [0x0000107ffbd000-0x0000107ffc1fff]
[    0.000000] Initmem setup node 1 [0000001080000000-000000207fffffff]
[    0.000000]   NODE_DATA [0x0000207ffbb000-0x0000207ffbffff]
[    0.000000] Initmem setup node 2 [0000002080000000-000000307fffffff]
[    0.000000]   NODE_DATA [0x0000307ffbb000-0x0000307ffbffff]
[    0.000000] Initmem setup node 3 [0000003080000000-000000407fffffff]
[    0.000000]   NODE_DATA [0x0000407ffbb000-0x0000407ffbffff]
[    0.000000] Initmem setup node 4 [0000004080000000-000000507fffffff]
[    0.000000]   NODE_DATA [0x0000507ffbb000-0x0000507ffbffff]
[    0.000000] Initmem setup node 5 [0000005080000000-000000607fffffff]
[    0.000000]   NODE_DATA [0x0000607ffbb000-0x0000607ffbffff]
[    0.000000] Initmem setup node 6 [0000006080000000-000000707fffffff]
[    0.000000]   NODE_DATA [0x0000707ffbb000-0x0000707ffbffff]
[    0.000000] Initmem setup node 7 [0000007080000000-000000807fffffff]
[    0.000000]   NODE_DATA [0x0000807ffba000-0x0000807ffbefff]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4D1933D1.9020609@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/page_types.h |    2 +
 arch/x86/kernel/setup.c           |    8 -----
 arch/x86/mm/amdtopology_64.c      |    8 +++--
 arch/x86/mm/init.c                |    8 +-----
 arch/x86/mm/init_64.c             |   54 +++++++++++++++++++++++++++++++++++++
 arch/x86/mm/numa_64.c             |    6 +++-
 arch/x86/mm/srat_64.c             |    2 +
 7 files changed, 68 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
index 93626e6..731d211 100644
--- a/arch/x86/include/asm/page_types.h
+++ b/arch/x86/include/asm/page_types.h
@@ -54,6 +54,8 @@ static inline phys_addr_t get_max_mapped(void)
 extern unsigned long init_memory_mapping(unsigned long start,
 					 unsigned long end);
 
+void init_memory_mapping_high(void);
+
 extern void initmem_init(unsigned long start_pfn, unsigned long end_pfn,
 				int acpi, int k8);
 extern void free_initmem(void);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 3def8c9..fc0fe74 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -931,14 +931,6 @@ void __init setup_arch(char **cmdline_p)
 	max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
 	max_pfn_mapped = max_low_pfn_mapped;
 
-#ifdef CONFIG_X86_64
-	if (max_pfn > max_low_pfn) {
-		max_pfn_mapped = init_memory_mapping(1UL<<32,
-						     max_pfn<<PAGE_SHIFT);
-		/* can we preseve max_low_pfn ?*/
-		max_low_pfn = max_pfn;
-	}
-#endif
 	memblock.current_limit = get_max_mapped();
 
 	/*
diff --git a/arch/x86/mm/amdtopology_64.c b/arch/x86/mm/amdtopology_64.c
index 51fae9c..ae6ad69 100644
--- a/arch/x86/mm/amdtopology_64.c
+++ b/arch/x86/mm/amdtopology_64.c
@@ -221,12 +221,14 @@ int __init amd_scan_nodes(void)
 		apicid_base = boot_cpu_physical_apicid;
 	}
 
-	for_each_node_mask(i, node_possible_map) {
-		int j;
-
+	for_each_node_mask(i, node_possible_map)
 		memblock_x86_register_active_regions(i,
 				nodes[i].start >> PAGE_SHIFT,
 				nodes[i].end >> PAGE_SHIFT);
+	init_memory_mapping_high();
+	for_each_node_mask(i, node_possible_map) {
+		int j;
+
 		for (j = apicid_base; j < cores + apicid_base; j++)
 			apicid_to_node[(i << bits) + j] = i;
 		setup_node_bootmem(i, nodes[i].start, nodes[i].end);
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 5863950..fa6fe75 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -65,16 +65,10 @@ static void __init find_early_table_space(unsigned long end, int use_pse,
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
 	good_end = max_pfn_mapped << PAGE_SHIFT;
 #endif
+
 	base = memblock_find_in_range(start, good_end, tables, PAGE_SIZE);
 	if (base == MEMBLOCK_ERROR)
 		panic("Cannot find space for the kernel page tables");
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 024847d..194f273 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -607,9 +607,63 @@ void __init initmem_init(unsigned long start_pfn, unsigned long end_pfn,
 				int acpi, int k8)
 {
 	memblock_x86_register_active_regions(0, start_pfn, end_pfn);
+	init_memory_mapping_high();
 }
 #endif
 
+struct mapping_work_data {
+	unsigned long start;
+	unsigned long end;
+	unsigned long pfn_mapped;
+};
+
+static int __init_refok
+mapping_work_fn(unsigned long start_pfn, unsigned long end_pfn, void *datax)
+{
+	struct mapping_work_data *data = datax;
+	unsigned long pfn_mapped;
+	unsigned long final_start, final_end;
+
+	final_start = max_t(unsigned long, start_pfn<<PAGE_SHIFT, data->start);
+	final_end = min_t(unsigned long, end_pfn<<PAGE_SHIFT, data->end);
+
+	if (final_end <= final_start)
+		return 0;
+
+	pfn_mapped = init_memory_mapping(final_start, final_end);
+
+	if (pfn_mapped > data->pfn_mapped)
+		data->pfn_mapped = pfn_mapped;
+
+	return 0;
+}
+
+static unsigned long __init_refok
+init_memory_mapping_active_regions(unsigned long start, unsigned long end)
+{
+	struct mapping_work_data data;
+
+	data.start = start;
+	data.end = end;
+	data.pfn_mapped = 0;
+
+	work_with_active_regions(MAX_NUMNODES, mapping_work_fn, &data);
+
+	return data.pfn_mapped;
+}
+
+void __init_refok init_memory_mapping_high(void)
+{
+	if (max_pfn > max_low_pfn) {
+		max_pfn_mapped = init_memory_mapping_active_regions(1UL<<32,
+							 max_pfn<<PAGE_SHIFT);
+		/* can we preserve max_low_pfn ? */
+		max_low_pfn = max_pfn;
+
+		memblock.current_limit = get_max_mapped();
+	}
+}
+
 void __init paging_init(void)
 {
 	unsigned long max_zone_pfns[MAX_NR_ZONES];
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 02d36ff..7cc26ae 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -590,11 +590,12 @@ static int __init numa_emulation(unsigned long start_pfn,
 	 * the e820 memory map.
 	 */
 	remove_all_active_ranges();
-	for_each_node_mask(i, node_possible_map) {
+	for_each_node_mask(i, node_possible_map)
 		memblock_x86_register_active_regions(i, nodes[i].start >> PAGE_SHIFT,
 						nodes[i].end >> PAGE_SHIFT);
+	init_memory_mapping_high();
+	for_each_node_mask(i, node_possible_map)
 		setup_node_bootmem(i, nodes[i].start, nodes[i].end);
-	}
 	acpi_fake_nodes(nodes, num_nodes);
 	numa_init_array();
 	return 0;
@@ -645,6 +646,7 @@ void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn,
 	for (i = 0; i < nr_cpu_ids; i++)
 		numa_set_node(i, 0);
 	memblock_x86_register_active_regions(0, start_pfn, last_pfn);
+	init_memory_mapping_high();
 	setup_node_bootmem(0, start_pfn << PAGE_SHIFT, last_pfn << PAGE_SHIFT);
 }
 
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index a35cb9d..0b961c8 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -433,6 +433,8 @@ int __init acpi_scan_nodes(unsigned long start, unsigned long end)
 		return -1;
 	}
 
+	init_memory_mapping_high();
+
 	/* Account for nodes with cpus and no memory */
 	nodes_or(node_possible_map, nodes_parsed, cpu_nodes_parsed);
 
