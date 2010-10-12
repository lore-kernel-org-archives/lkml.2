Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137Ab0JLSqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 14:46:37 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:55867 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757362Ab0JLSqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 14:46:35 -0400
Message-ID: <4CB4ACB1.3080402@kernel.org>
Date: Tue, 12 Oct 2010 11:45:05 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100914 SUSE/3.0.8 Thunderbird/3.0.8
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 0/4] memblock related fixes for -tip
References: <4CAA4DC1.6000104@kernel.org> <4CB4ABE2.3010300@goop.org>
In-Reply-To: <4CB4ABE2.3010300@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2010 11:41 AM, Jeremy Fitzhardinge wrote:
>  On 10/04/2010 02:57 PM, Yinghai Lu wrote:
>> Please check memblock related patches
>>
>> [PATCH 1/4] memblock: Fix big size with find_region()
>> [PATCH -v5 2/4] x86, memblock: Fix crashkernel allocation
>> [PATCH 3/4] x86, memblock: Remove __memblock_x86_find_in_range_size()
>> [PATCH 4/4] x86, mm, memblock, 32bit: Make add_highpages honor early reserved ranges
>>
>> first one should get into core/memblock branch, and others should be in x86/mm/memeblock branch
> 
> 
> BTW, the memblock changes prevent the kernel from booting under Xen; it
> crashes while setting up the linear maps.  I haven't worked out what's
> failing yet, aside from bisecting it down to one of a9ce6bc151000 or
> 72d7c3b33c9808 (they don't compile in isolation so I had to skip them,
> but both are likely looking, but unfortunately large, complex and hard
> to further subdivide).
> 
> I'll look further into this, but just a heads-up for the upcoming merge
> window.
> 

rebase memblock to today's linus tree. it should make your bisecting smoother.

please check

git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-2.6-yinghai.git memblock

all fallout fix patches get merged into original commit.

Thanks

Yinghai


504fabf: memblock: Annotate memblock functions with __init_memblock
80c21ff: memblock: Allow memblock_init to be called early
9a319dd: x86, memblock: Remove __memblock_x86_find_in_range_size()
1be11b9: memblock: Fix wraparound in find_region()
11b9e2b: x86-32, memblock: Make add_highpages honor early reserved ranges
0bb390a: memblock: Fix section mismatch warnings
a982d98: x86: Remove old bootmem code
0a75ad2: x86, memblock: Use memblock_memory_size()/memblock_free_memory_size() to get correct dma_reserve
b1df2e5: x86: Remove not used early_res code
c074c30: x86, memblock: Replace e820_/_early string with memblock_
574489b: x86: Use memblock to replace early_res
b5eab27: x86, memblock: Use memblock_debug to control debug message print out
356c9ba: x86, memblock: Add memblock_x86_memory_in_range()
3f14258: x86, memblock: Add memblock_x86_free_memory_in_range()
cbddb3e: x86, memblock: Add memblock_x86_find_in_range_node()
5a28d45: memblock: Add find_memory_core_early()
ebfa1cb: x86, memblock: Add memblock_x86_register_active_regions() and memblock_x86_hole_size()
406d0e5: x86, memblock: Add get_free_all_memory_range()
192950e: x86, memblock: Add memblock_x86_reserve_range/memblock_x86_free_range
71b3bc5: x86, memblock: Add memblock_x86_to_bootmem()
c8bc172: bootmem, x86: Add weak version of reserve_bootmem_generic
2d05b56: x86, memblock: Add memblock_x86_find_in_range_size()
f3a812f: memblock: Add memblock_free/reserve_reserved_regions()
50d999b: memblock: Add memblock_find_in_range()
4e77e4b: memblock: Option for the architecture to put memblock into the .init section
0d54dbd: memblock: Protect memblock.h with CONFIG_HAVE_MEMBLOCK
3459158: memblock: Make MEMBLOCK_ERROR be 0
0b9d3f0: memblock: Export MEMBLOCK_ERROR
07df680: memblock: Improve debug output when resizing the reserve array
fbd2705: memblock: Expose some memblock bits for use by x86
76be0745: memblock: Add debugfs files to dump the arrays content
f48294e: memblock: Make memblock_alloc_try_nid() fallback to MEMBLOCK_ALLOC_ANYWHERE
52561a7: memblock: Separate memblock_alloc_nid() and memblock_alloc_try_nid()
73fcc82: memblock: NUMA allocate can now use early_pfn_map
b047c4b: memblock: Add "start" argument to memblock_find_base()
0dda32f: memblock: Add arch function to control coalescing of memblock memory regions
7cab753: memblock: Add array resizing support
f3a1d96: memblock: Move functions around into a more sensible order
9bc8683: memblock: split memblock_find_base() out of __memblock_alloc_base()
85676a1: memblock: Move memblock_init() to the bottom of the file
92876e4: memblock: Define MEMBLOCK_ERROR internally instead of using ~(phys_addr_t)0
f6f333e: memblock: Make memblock_find_region() out of memblock_alloc_region()
588a69a: memblock: Add debug markers at the end of the array
9638337: memblock: Move memblock arrays to static storage in memblock.c and make their size a variable
06d2939: memblock: Remove memblock_type.size and add memblock.memory_size instead
779bde3: memblock: Remove unused memblock.debug struct member
e8d828c: memblock: Change u64 to phys_addr_t
fa06948: memblock: Remove rmo_size, burry it in arch/powerpc where it belongs
615a990: memblock: Introduce default allocation limit and use it to replace explicit ones
666f73a: memblock: Expose MEMBLOCK_ALLOC_ANYWHERE
3d62472: memblock: Factor the lowest level alloc function
87de4bd: memblock: Remove nid_range argument, arch provides memblock_nid_range() instead
bc3f694: memblock: Remove memblock_find()
1741db7: memblock: Remove obsolete accessors
4193336: memblock/arm: Use new accessors
8a9f9fb: memblock/powerpc: Use new accessors
840def8: memblock/sparc: Use new accessors
3c77156: memblock/sh: Use new accessors
5f91db7: memblock/microblaze: Use new accessors
988660a: memblock: Introduce for_each_memblock() and new accessors
ca8a80d: memblock/arm: Use memblock_region_is_memory() for omap fb
92e9c55: memblock/arm: pfn_valid uses memblock_is_memory()
9d39b1a: memblock: Implement memblock_is_memory and memblock_is_region_memory
c7987d0: memblock: No reason to include asm/memblock.h late
c188b44: memblock: Rename memblock_region to memblock_type and memblock_property to memblock_region


 arch/arm/mm/init.c                       |   37 +-
 arch/arm/plat-omap/fb.c                  |    6 +-
 arch/microblaze/include/asm/memblock.h   |    3 -
 arch/microblaze/mm/init.c                |   30 +-
 arch/powerpc/include/asm/memblock.h      |    7 -
 arch/powerpc/include/asm/mmu.h           |   12 +
 arch/powerpc/kernel/head_40x.S           |    6 +-
 arch/powerpc/kernel/paca.c               |    2 +-
 arch/powerpc/kernel/prom.c               |   15 +-
 arch/powerpc/kernel/rtas.c               |    2 +-
 arch/powerpc/kernel/setup_32.c           |    2 +-
 arch/powerpc/kernel/setup_64.c           |    2 +-
 arch/powerpc/mm/40x_mmu.c                |   17 +-
 arch/powerpc/mm/44x_mmu.c                |   14 +
 arch/powerpc/mm/fsl_booke_mmu.c          |   12 +-
 arch/powerpc/mm/hash_utils_64.c          |   35 +-
 arch/powerpc/mm/init_32.c                |   43 +-
 arch/powerpc/mm/init_64.c                |    1 +
 arch/powerpc/mm/mem.c                    |   94 ++---
 arch/powerpc/mm/numa.c                   |   17 +-
 arch/powerpc/mm/ppc_mmu_32.c             |   18 +-
 arch/powerpc/mm/tlb_nohash.c             |   16 +
 arch/powerpc/platforms/embedded6xx/wii.c |    2 +-
 arch/sh/include/asm/memblock.h           |    2 -
 arch/sh/mm/init.c                        |   17 +-
 arch/sparc/include/asm/memblock.h        |    2 -
 arch/sparc/mm/init_64.c                  |   46 +-
 arch/x86/Kconfig                         |   15 +-
 arch/x86/include/asm/e820.h              |   20 +-
 arch/x86/include/asm/efi.h               |    2 +-
 arch/x86/include/asm/memblock.h          |   23 +
 arch/x86/kernel/acpi/sleep.c             |    9 +-
 arch/x86/kernel/apic/numaq_32.c          |    3 +-
 arch/x86/kernel/check.c                  |   16 +-
 arch/x86/kernel/e820.c                   |  191 ++-----
 arch/x86/kernel/efi.c                    |    5 +-
 arch/x86/kernel/head.c                   |    3 +-
 arch/x86/kernel/head32.c                 |   10 +-
 arch/x86/kernel/head64.c                 |    7 +-
 arch/x86/kernel/mpparse.c                |    5 +-
 arch/x86/kernel/setup.c                  |   87 ++--
 arch/x86/kernel/setup_percpu.c           |    6 -
 arch/x86/kernel/trampoline.c             |   10 +-
 arch/x86/mm/Makefile                     |    2 +
 arch/x86/mm/init.c                       |   10 +-
 arch/x86/mm/init_32.c                    |  119 +----
 arch/x86/mm/init_64.c                    |   67 +---
 arch/x86/mm/k8topology_64.c              |    4 +-
 arch/x86/mm/memblock.c                   |  348 +++++++++++++
 arch/x86/mm/memtest.c                    |    7 +-
 arch/x86/mm/numa_32.c                    |   30 +-
 arch/x86/mm/numa_64.c                    |   84 +---
 arch/x86/mm/srat_32.c                    |    3 +-
 arch/x86/mm/srat_64.c                    |   11 +-
 arch/x86/xen/enlighten.c                 |    3 +
 arch/x86/xen/mmu.c                       |    5 +-
 arch/x86/xen/setup.c                     |    3 +-
 drivers/video/omap2/vram.c               |    8 +-
 include/linux/early_res.h                |   23 -
 include/linux/memblock.h                 |  168 +++++--
 include/linux/mm.h                       |    2 +
 kernel/Makefile                          |    1 -
 kernel/early_res.c                       |  590 ---------------------
 mm/bootmem.c                             |   13 +-
 mm/memblock.c                            |  837 ++++++++++++++++++++----------
 mm/page_alloc.c                          |   86 ++--
 mm/sparse-vmemmap.c                      |   11 -
 67 files changed, 1613 insertions(+), 1694 deletions(-)
 create mode 100644 arch/x86/include/asm/memblock.h
 create mode 100644 arch/x86/mm/memblock.c
 delete mode 100644 include/linux/early_res.h
 delete mode 100644 kernel/early_res.c

