Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab1EFGa7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 02:30:59 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:58883 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab1EFGa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 02:30:58 -0400
Message-ID: <4DC3958F.1090800@kernel.org>
Date: Thu, 05 May 2011 23:30:39 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Stefan Hellermann <stefan@the2masters.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: early crash on ancient tablet related to no-bootmem
References: <4DC30251.9040902@the2masters.de> <4DC31D5F.8070209@the2masters.de> <4DC31F72.5050206@kernel.org> <4DC328AC.1060906@the2masters.de>
In-Reply-To: <4DC328AC.1060906@the2masters.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4DC3959E.0020,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2011 03:46 PM, Stefan Hellermann wrote:
> Am 06.05.2011 00:06, schrieb Yinghai Lu:
>>
>> can you please boot with "ignore_loglevel debug memblock=debug"?
>>
> 
> Here we are:
> 
> early console in setup code
> early console in decompress_kernel
> 
> Decompressing Linux... Parsing ELF... done.
> Booting the kernel.
> Linux version 2.6.39-rc6+ (stefan@hel-stefan.lan) (gcc version 4.6.0
> 20110428 (Red Hat 4.6.0-6) (GCC) ) #1 Thu May 5 19:21:50 CEST 2011
> BIOS-provided physical RAM map:
>  BIOS-88: 0000000000000000 - 000000000009f000 (usable)
>  BIOS-88: 0000000000100000 - 0000000000840000 (usable)
> bootconsole [earlyser0] enabled
> debug: ignoring loglevel setting.
> Notice: NX (Execute Disable) protection missing in CPU!
> DMI not present or invalid.
> e820 update range: 0000000000000000 - 0000000000010000 (usable) ==>
> (reserved)
> e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
> last_pfn = 0x840 max_arch_pfn = 0x100000
>     memblock_x86_reserve_range: [0x003a5000-0x003a6fff]              BRK
> MEMBLOCK configuration:
>  memory size = 0x7cf000
>  memory.cnt  = 0x2
>  memory[0x0]	[0x00000000010000-0x0000000009efff], 0x8f000 bytes
>  memory[0x1]	[0x00000000100000-0x0000000083ffff], 0x740000 bytes
>  reserved.cnt  = 0x1
>  reserved[0x0]	[0x0000000009f000-0x000000003a6fff], 0x308000 bytes
> initial memory mapped : 0 - 00800000
>     memblock_x86_reserve_range: [0x0009e000-0x0009efff]       TRAMPOLINE
> Base memory trampoline at [c009e000] 9e000 size 4096
> init_memory_mapping: 0000000000000000-0000000000840000
>  0000000000 - 0000840000 page 4k
> kernel direct mapping tables up to 840000 @ 7fa000-800000
>     memblock_x86_reserve_range: [0x007fa000-0x007fafff]          PGTABLE
> 8MB LOWMEM available.
>   mapped low ram: 0 - 00840000
>   low ram: 0 - 00840000
> Zone PFN ranges:
>   DMA      0x00000010 -> 0x00001000
>   Normal   empty
> Movable zone start PFN for each node
> early_node_map[2] active PFN ranges
>     0: 0x00000010 -> 0x0000009f
>     0: 0x00000100 -> 0x00000840
> On node 0 totalpages: 1999
> free_area_init_node: node 0, pgdat c03555a0, node_mem_map 00000200
>   DMA zone: 17 pages used for memmap
>   DMA zone: 0 pages reserved
>   DMA zone: 1982 pages, LIFO batch:0
> BUG: Int 6: CR2   (null)
>      EDI c0355868  ESI   (null)  EBP 00000830  ESP c0339f10
>      EBX c03555a0  EDX 00000006  ECX 01000000  EAX fffffff4
>      err   (null)  EIP c0361b85   CS 00000060  flg 00010082
> Stack:   (null) c031d2f2 000007be   (null) c031d2f2 00000003   (null)
> (null)
>        00000010 00000018 00000002   (null) 00000002 c0361ea8   (null)
> (null)
>        00000100 00000840 00000001   (null)   (null) c0339f8c c0339fb8
> c035e41b
> Pid: 0, comm: swapper Not tainted 2.6.39-rc6+ #1
> Call Trace:
>  [<c036edb5>] ? 0xc036edb5
>  [<c0361b85>] ? 0xc0361b85
>  [<c0361ea8>] ? 0xc0361ea8
>  [<c035e41b>] ? 0xc035e41b
>  [<c035986d>] ? 0xc035986d
>  [<c0358401>] ? 0xc0358401


please check

[PATCH] mm: Use alloc_bootmem_node_nopanic on really needed path

Stefan found nobootmem does not work on his system that only have 8M ram.

It turns out we should ignore the low limit the 16M.

Use alloc_bootmem_node_nopanic in those calling.

Reported-by: Stefan Hellermann <stefan@the2masters.de>
Signed-off-by: Yinghai LU <yinghai@kernel.org>

---
 include/linux/bootmem.h |    2 ++
 mm/page_alloc.c         |    6 +++---
 2 files changed, 5 insertions(+), 3 deletions(-)

Index: linux-2.6/include/linux/bootmem.h
===================================================================
--- linux-2.6.orig/include/linux/bootmem.h
+++ linux-2.6/include/linux/bootmem.h
@@ -111,6 +111,8 @@ extern void *__alloc_bootmem_low_node(pg
 	__alloc_bootmem_nopanic(x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
 #define alloc_bootmem_node(pgdat, x) \
 	__alloc_bootmem_node(pgdat, x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
+#define alloc_bootmem_node_nopanic(pgdat, x) \
+	__alloc_bootmem_node_nopanic(pgdat, x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
 #define alloc_bootmem_pages_node(pgdat, x) \
 	__alloc_bootmem_node(pgdat, x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
 #define alloc_bootmem_pages_node_nopanic(pgdat, x) \
Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c
+++ linux-2.6/mm/page_alloc.c
@@ -3564,7 +3564,7 @@ int zone_wait_table_init(struct zone *zo
 
 	if (!slab_is_available()) {
 		zone->wait_table = (wait_queue_head_t *)
-			alloc_bootmem_node(pgdat, alloc_size);
+			alloc_bootmem_node_nopanic(pgdat, alloc_size);
 	} else {
 		/*
 		 * This case means that a zone whose size was 0 gets new memory
@@ -4141,7 +4141,7 @@ static void __init setup_usemap(struct p
 	unsigned long usemapsize = usemap_size(zonesize);
 	zone->pageblock_flags = NULL;
 	if (usemapsize)
-		zone->pageblock_flags = alloc_bootmem_node(pgdat, usemapsize);
+		zone->pageblock_flags = alloc_bootmem_node_nopanic(pgdat, usemapsize);
 }
 #else
 static inline void setup_usemap(struct pglist_data *pgdat,
@@ -4307,7 +4307,7 @@ static void __init_refok alloc_node_mem_
 		size =  (end - start) * sizeof(struct page);
 		map = alloc_remap(pgdat->node_id, size);
 		if (!map)
-			map = alloc_bootmem_node(pgdat, size);
+			map = alloc_bootmem_node_nopanic(pgdat, size);
 		pgdat->node_mem_map = map + (pgdat->node_start_pfn - start);
 	}
 #ifndef CONFIG_NEED_MULTIPLE_NODES
