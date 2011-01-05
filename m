Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab1AEVYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 16:24:25 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:42350 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab1AEVYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 16:24:24 -0500
Message-ID: <4D24E170.4050708@kernel.org>
Date: Wed, 05 Jan 2011 13:24:00 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [boot crash] Re: [PATCH -v2 3/6] x86, 64bit, numa: Put pgtable
 to local node memory
References: <AANLkTikknHfA4TQw+SMH-EyJBHoNHXk8Rheq4=K4jNWA@mail.gmail.com> <alpine.DEB.2.00.1012291637270.6040@chino.kir.corp.google.com> <4D1BD928.50701@zytor.com> <alpine.DEB.2.00.1012291702180.7374@chino.kir.corp.google.com> <4D1BE615.4000700@zytor.com> <20101230090648.GB7306@elte.hu> <20101230102815.GA29822@elte.hu> <20101230103002.GA30020@elte.hu> <AANLkTimeqrLzDuqBoSvmkSJWMc7u3PeRf37vjzBca2Lh@mail.gmail.com> <AANLkTimpyRXS9dNFATh4GqtA46uynutAvK7Qb5S7WPFO@mail.gmail.com> <20110105134434.GA22816@elte.hu>
In-Reply-To: <20110105134434.GA22816@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2011 05:44 AM, Ingo Molnar wrote:
> 
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>>>> i'm excluding them from tip:master for now.
>>>
>>> caused by
>>> 4645b6af9427: x86: Use early pre-allocated page table buffer top-down
>>>
>>> 32 bit fixmap will use the pre-allocated range too. it needs range to
>>> be continuous...
>>>
>>> please drop
>>> 4645b6af9427: x86: Use early pre-allocated page table buffer top-down
>>> 3c417751e4f0: x86: Rename e820_table_* to pgt_buf_*
>>>
>>> and will send out new version of
>>>
>>>  x86: Rename e820_table_* to pgt_buf_*
>>
>> Please drop
>>  4645b6af9427: x86: Use early pre-allocated page table buffer top-down
>>  3c417751e4f0: x86: Rename e820_table_* to pgt_buf_*
>>
>> from tip/x86/bootmem
> 
> It still crashes on a testbox with:
> 
>  This costs you 64 MB of RAM
>  Cannot allocate aperture memory hole (0,65536K)
>  Kernel panic - not syncing: Not enough memory for aperture
>  Rebooting in 1 seconds..Press any key to enter the menu
> 
> full bootlog attached further below. Config attached.
> 
> Thanks,
> 
> 	Ingo
> 
> ----------->
> Linux version 2.6.37-tip-01872-gcdb5c00-dirty (mingo@sirius) (gcc version 4.5.1 20100924 (Red Hat 4.5.1-4) (GCC) ) #80266 SMP PREEMPT Wed Jan 5 15:49:23 CET 2011
> Command line: root=/dev/sda6 earlyprintk=ttyS0,115200 console=ttyS0,115200 debug initcall_debug sysrq_always_enabled ignore_loglevel selinux=0 nmi_watchdog=0 panic=1 3
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
>  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
>  BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
>  BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
>  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
>  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
> bootconsole [earlyser0] enabled
> debug: ignoring loglevel setting.
> NX (Execute Disable) protection: active
> DMI 2.3 present.
> DMI: A8N-E/System Product Name, BIOS ASUS A8N-E ACPI BIOS Revision 1008 08/22/2005
> e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
> e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
> No AGP bridge found
> last_pfn = 0x3fff0 max_arch_pfn = 0x400000000
> MTRR default type: uncachable
> MTRR fixed ranges enabled:
>   00000-9FFFF write-back
>   A0000-BFFFF uncachable
>   C0000-C7FFF write-protect
>   C8000-FFFFF uncachable
> MTRR variable ranges enabled:
>   0 base 0000000000 mask FFC0000000 write-back
>   1 disabled
>   2 disabled
>   3 disabled
>   4 disabled
>   5 disabled
>   6 disabled
>   7 disabled
> found SMP MP-table at [ffff8800000f5680] f5680
> initial memory mapped : 0 - 20000000
> init_memory_mapping: 0000000000000000-000000003fff0000
>  0000000000 - 003fe00000 page 2M
>  003fe00000 - 003fff0000 page 4k
> kernel direct mapping tables up to 3fff0000 @ 3ffed000-3fff0000
> Scanning NUMA topology in Northbridge 24
> No NUMA configuration found
> Faking a node at 0000000000000000-000000003fff0000
> Initmem setup node 0 0000000000000000-000000003fff0000
>   NODE_DATA [000000003ffde000 - 000000003ffecfff]
>  [ffffea0000000000-ffffea0000dfffff] PMD -> [ffff88003e600000-ffff88003f3fffff] on node 0
> Zone PFN ranges:
>   DMA      0x00000010 -> 0x00001000
>   DMA32    0x00001000 -> 0x00100000
>   Normal   empty
> Movable zone start PFN for each node
> early_node_map[2] active PFN ranges
>     0: 0x00000010 -> 0x0000009f
>     0: 0x00000100 -> 0x0003fff0
> On node 0 totalpages: 262015
>   DMA zone: 56 pages used for memmap
>   DMA zone: 2 pages reserved
>   DMA zone: 3925 pages, LIFO batch:0
>   DMA32 zone: 3528 pages used for memmap
>   DMA32 zone: 254504 pages, LIFO batch:31
> Intel MultiProcessor Specification v1.4
> MPTABLE: OEM ID: OEM00000
> MPTABLE: Product ID: PROD00000000
> MPTABLE: APIC at: 0xFEE00000
> Processor #0 (Bootup-CPU)
> Processor #1
> IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
> Processors: 2
> SMP: Allowing 2 CPUs, 0 hotplug CPUs
> nr_irqs_gsi: 40
> Allocating PCI resources starting at 40000000 (gap: 40000000:a0000000)
> Booting paravirtualized kernel on bare hardware
> setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
> PERCPU: Embedded 474 pages/cpu @ffff88003fa00000 s1918808 r0 d22696 u2097152
> pcpu-alloc: s1918808 r0 d22696 u2097152 alloc=1*2097152
> pcpu-alloc: [0] 0 [0] 1 
> Built 1 zonelists in Node order, mobility grouping on.  Total pages: 258429
> Policy zone: DMA32
> Kernel command line: root=/dev/sda6 earlyprintk=ttyS0,115200 console=ttyS0,115200 debug initcall_debug sysrq_always_enabled ignore_loglevel selinux=0 nmi_watchdog=0 panic=1 3
> sysrq: sysrq always enabled.
> PID hash table entries: 4096 (order: 3, 32768 bytes)
> Checking aperture...
> No AGP bridge found
> Node 0: aperture @ 38000000 size 32 MB
> Aperture pointing to e820 RAM. Ignoring.
> Your BIOS doesn't leave a aperture memory hole
> Please enable the IOMMU option in the BIOS setup
> This costs you 64 MB of RAM
> Cannot allocate aperture memory hole (0,65536K)
> Kernel panic - not syncing: Not enough memory for aperture
> Rebooting in 1 seconds..Press any key to enter the menu
> 

ok, config has

CONFIG_IOMMU_DEBUG=y

so will have force_iommu on, then i will try to allocate 64M RAM under 4G for aper.

somehow
+	addr = memblock_find_in_range(0, 1ULL<<32, aper_size, 512ULL<<20);
+	if (addr == MEMBLOCK_ERROR || addr + aper_size > 0xffffffff) {
+		printk(KERN_ERR
+			"Cannot allocate aperture memory hole (%lx,%uK)\n",
+				addr, aper_size>>10);
+		return 0;
+	}
+	memblock_x86_reserve_range(addr, addr + aper_size, "aperture64");

memblock_find_in_range can not find under 4G...

and there is something wrong with memblock code....

please apply following patch before tip/x86/bootmem...

Thanks

Yinghai


[PATCH] memblock: Don't adjust size in memblock_find_base()

While applying patch to use memblock to find aperture for 64bit x86.
Ingo found system with 1g + force_iommu

> No AGP bridge found
> Node 0: aperture @ 38000000 size 32 MB
> Aperture pointing to e820 RAM. Ignoring.
> Your BIOS doesn't leave a aperture memory hole
> Please enable the IOMMU option in the BIOS setup
> This costs you 64 MB of RAM
> Cannot allocate aperture memory hole (0,65536K)

the corresponding code:
	addr = memblock_find_in_range(0, 1ULL<<32, aper_size, 512ULL<<20);
	if (addr == MEMBLOCK_ERROR || addr + aper_size > 0xffffffff) {
		printk(KERN_ERR
			"Cannot allocate aperture memory hole (%lx,%uK)\n",
				addr, aper_size>>10);
		return 0;
	}
	memblock_x86_reserve_range(addr, addr + aper_size, "aperture64")

it failes because memblock core code align the size with 512M. that could make
size way too big.

So don't align the size in that case.

acctually __memblock_alloc_base, the another caller already align that before calling that function.

BTW. x86 does not use __memblock_alloc_base...

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 mm/memblock.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-2.6/mm/memblock.c
===================================================================
--- linux-2.6.orig/mm/memblock.c
+++ linux-2.6/mm/memblock.c
@@ -137,8 +137,6 @@ static phys_addr_t __init_memblock membl
 
 	BUG_ON(0 == size);
 
-	size = memblock_align_up(size, align);
-
 	/* Pump up max_addr */
 	if (end == MEMBLOCK_ALLOC_ACCESSIBLE)
 		end = memblock.current_limit;
