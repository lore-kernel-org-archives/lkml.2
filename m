Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017Ab0GMHYK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 03:24:10 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:24401 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab0GMHO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 03:14:29 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v24 00/50] Use memblock with x86
Date: Tue, 13 Jul 2010 00:09:54 -0700
Message-Id: <1279005044-24777-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4C3C123F.01C5,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New memblock could be used to replace early_res in x86.

Suggested by: David, Ben, and Thomas

-v18: change memblock_find_area to memblock_find_in_range
      kill __memblock_find_area and use memblock_find_area directly
      remove memblock_add_memory
      change memblock_reserve_area to memblock_reserve_range
      change memblock_free_area to memblock_free_range
      don't clear memblock.reserved after converting
      use for_each_memblock to replace for cycle
      rebase to 06/15/2010 powerpc/memblock

-v19: make the patchset only focus on memblock related.
      will submit patches about bootmem/nobootmem seperating and other e820
	 related later after this one.

-v20: put ben change together...
      add memblock_dbg() according to Ingo

-v21: debug print add # for 0x
      removed old bootmem support for x86 according to Ingo, Thomas and HPA
      change MEMBLOCK_ERROR to 0 according to Linus

-v22: change x86 related memblock to memblock_x86_ instead of according to Ingo

-v23: rename lmb to memblock before Ben's cleanup patcheset, and x86 using patches.

-v24: fold memblock_find_base() return change to orig patch (patch 20)
      change to -1 display

patch 46: has to be done in one shoot to switch from early_res to memblock.
First two patches are needed for 2.6.35. need to be applied at first.

todo:
     replace range handling (subtracting) with memblock.

Thanks

Yinghai Lu

1e0e426: x86, numa: fix boot without RAM on node0 again
2f2ce7e: x86,mm: fix 32bit numa sparsemem
59245fa: lmb: rename to memblock
8cfaf11: memblock: Rename memblock_region to memblock_type and memblock_property to memblock_region
47f2a51: memblock: No reason to include asm/memblock.h late
2d34839: memblock: Introduce for_each_memblock() and new accessors, and use it
b090def: memblock: Remove nid_range argument, arch provides memblock_nid_range() instead
22183f3: memblock: Factor the lowest level alloc function
c8de2bc: memblock: Expose MEMBLOCK_ALLOC_ANYWHERE
884620f: memblock: Introduce default allocation limit and use it to replace explicit ones
095c662: memblock: Remove rmo_size, burry it in arch/powerpc where it belongs
1e424c8: memblock: Change u64 to phys_addr_t
c8b7e36: memblock: Remove unused memblock.debug struct member
980d97a: memblock: Remove memblock_type.size and add memblock.memory_size instead
5096a97: memblock: Move memblock arrays to static storage in memblock.c and make their size a variable
5b25099: memblock: Add debug markers at the end of the array
c2e266a: memblock: Make memblock_find_region() out of memblock_alloc_region()
a982b7d: memblock: Define MEMBLOCK_ERROR internally instead of using ~(phys_addr_t)0
80a5f51: memblock: Move memblock_init() to the bottom of the file
78439ec: memblock: split memblock_find_base() out of __memblock_alloc_base()
065abd0: memblock: Move functions around into a more sensible order
8a83f93: memblock: Add array resizing support
87e1c95: memblock: Add arch function to control coalescing of memblock memory regions
384a83e: memblock: Add "start" argument to memblock_find_base()
b5e35f2: memblock: NUMA allocate can now use early_pfn_map
7d8061c: memblock: Separate memblock_alloc_nid() and memblock_alloc_try_nid()
f74547c: memblock: Make memblock_alloc_try_nid() fallback to MEMBLOCK_ALLOC_ANYWHERE
656c52a: memblock: Add debugfs files to dump the arrays content
4c18442: memblock: Prepare x86 to use memblock to replace early_res
ae37574: memblock: Print new doubled array location info
afce580: memblock: Export MEMBLOCK_ERROR again
3dd38a4: memblock: Prepare to include linux/memblock.h in core file
5ef74ee: memblock: Add ARCH_DISCARD_MEMBLOCK to put memblock code to .init
0863989: memblock: Add memblock_find_in_range()
c7c4d1a: x86, memblock: Add memblock_x86_find_in_range_size()
d3c8180: bootmem, x86: Add weak version of reserve_bootmem_generic
22059ed: x86, memblock: Add memblock_x86_to_bootmem()
d45a815: x86,memblock: Add memblock_x86_reserve_range/memblock_x86_free_range
94aac0a: x86, memblock: Add get_free_all_memory_range()
f5c84f7: x86, memblock: Add memblock_x86_register_active_regions() and memblock_x86_hole_size()
f20deee: memblock: Add find_memory_core_early()
d032e25: x86, memblock: Add memblock_x86_find_in_range_node()
2d5f07f: x86, memblock: Add memblock_x86_free_memory_in_range()
2b755bc: x86, memblock: Add memblock_x86_memory_in_range()
c5b59e0: x86, memblock: Use memblock_debug to control debug message print out
a33966d: x86: Use memblock to replace early_res
383fd99: x86: Replace e820_/_early string with memblock_
053b86d: x86: Remove not used early_res code
2111e11: x86, memblock: Use memblock_memory_size()/memblock_free_memory_size() to get correct dma_reserve
39ba82d: x86: remove old bootmem code


 Documentation/kernel-parameters.txt               |    2 +-
 arch/microblaze/Kconfig                           |    2 +-
 arch/microblaze/include/asm/{lmb.h => memblock.h} |    9 +-
 arch/microblaze/kernel/prom.c                     |   14 +-
 arch/microblaze/mm/init.c                         |   40 +-
 arch/powerpc/Kconfig                              |    2 +-
 arch/powerpc/include/asm/abs_addr.h               |    2 +-
 arch/powerpc/include/asm/lmb.h                    |   15 -
 arch/powerpc/include/asm/memblock.h               |    8 +
 arch/powerpc/include/asm/mmu.h                    |   12 +
 arch/powerpc/kernel/btext.c                       |    2 +-
 arch/powerpc/kernel/crash.c                       |    2 +-
 arch/powerpc/kernel/crash_dump.c                  |    4 +-
 arch/powerpc/kernel/dma-swiotlb.c                 |    2 +-
 arch/powerpc/kernel/dma.c                         |    4 +-
 arch/powerpc/kernel/head_40x.S                    |    6 +-
 arch/powerpc/kernel/machine_kexec.c               |   12 +-
 arch/powerpc/kernel/paca.c                        |    8 +-
 arch/powerpc/kernel/prom.c                        |   73 +-
 arch/powerpc/kernel/rtas.c                        |    6 +-
 arch/powerpc/kernel/setup-common.c                |    2 +-
 arch/powerpc/kernel/setup_32.c                    |   16 +-
 arch/powerpc/kernel/setup_64.c                    |   20 +-
 arch/powerpc/kernel/vdso.c                        |    4 +-
 arch/powerpc/mm/40x_mmu.c                         |   19 +-
 arch/powerpc/mm/44x_mmu.c                         |   14 +
 arch/powerpc/mm/fsl_booke_mmu.c                   |   12 +-
 arch/powerpc/mm/hash_utils_64.c                   |   53 +-
 arch/powerpc/mm/init_32.c                         |   57 +-
 arch/powerpc/mm/init_64.c                         |    3 +-
 arch/powerpc/mm/mem.c                             |  110 ++--
 arch/powerpc/mm/numa.c                            |   89 ++--
 arch/powerpc/mm/pgtable_32.c                      |    6 +-
 arch/powerpc/mm/pgtable_64.c                      |    4 +-
 arch/powerpc/mm/ppc_mmu_32.c                      |   20 +-
 arch/powerpc/mm/stab.c                            |    4 +-
 arch/powerpc/mm/tlb_nohash.c                      |   20 +-
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
 arch/sh/include/asm/memblock.h                    |    4 +
 arch/sh/kernel/machine_kexec.c                    |   18 +-
 arch/sh/kernel/setup.c                            |    8 +-
 arch/sh/mm/init.c                                 |   44 +-
 arch/sh/mm/numa.c                                 |    8 +-
 arch/sparc/Kconfig                                |    2 +-
 arch/sparc/include/asm/lmb.h                      |   10 -
 arch/sparc/include/asm/memblock.h                 |    8 +
 arch/sparc/kernel/mdesc.c                         |   16 +-
 arch/sparc/kernel/prom_64.c                       |    4 +-
 arch/sparc/mm/init_64.c                           |   76 +--
 arch/x86/Kconfig                                  |   15 +-
 arch/x86/include/asm/e820.h                       |   20 +-
 arch/x86/include/asm/efi.h                        |    2 +-
 arch/x86/include/asm/memblock.h                   |   21 +
 arch/x86/kernel/acpi/sleep.c                      |    7 +-
 arch/x86/kernel/apic/numaq_32.c                   |    3 +-
 arch/x86/kernel/check.c                           |   16 +-
 arch/x86/kernel/e820.c                            |  192 ++----
 arch/x86/kernel/efi.c                             |    5 +-
 arch/x86/kernel/head.c                            |    3 +-
 arch/x86/kernel/head32.c                          |   10 +-
 arch/x86/kernel/head64.c                          |    7 +-
 arch/x86/kernel/mpparse.c                         |    5 +-
 arch/x86/kernel/setup.c                           |   78 ++-
 arch/x86/kernel/setup_percpu.c                    |   23 +-
 arch/x86/kernel/trampoline.c                      |    8 +-
 arch/x86/mm/Makefile                              |    2 +
 arch/x86/mm/init.c                                |    7 +-
 arch/x86/mm/init_32.c                             |   66 +--
 arch/x86/mm/init_64.c                             |   67 +--
 arch/x86/mm/k8topology_64.c                       |    4 +-
 arch/x86/mm/memblock.c                            |  359 ++++++++++
 arch/x86/mm/memtest.c                             |    7 +-
 arch/x86/mm/numa_32.c                             |   28 +-
 arch/x86/mm/numa_64.c                             |   84 +--
 arch/x86/mm/srat_32.c                             |    3 +-
 arch/x86/mm/srat_64.c                             |   11 +-
 arch/x86/xen/mmu.c                                |    5 +-
 arch/x86/xen/setup.c                              |    3 +-
 include/linux/early_res.h                         |   23 -
 include/linux/lmb.h                               |   89 ---
 include/linux/memblock.h                          |  165 +++++
 include/linux/mm.h                                |    2 +
 kernel/Makefile                                   |    1 -
 kernel/early_res.c                                |  584 ----------------
 lib/Kconfig                                       |    3 -
 lib/Makefile                                      |    2 -
 lib/lmb.c                                         |  541 --------------
 mm/Kconfig                                        |    3 +
 mm/Makefile                                       |    2 +
 mm/bootmem.c                                      |   35 +-
 mm/memblock.c                                     |  775 +++++++++++++++++++++
 mm/page_alloc.c                                   |   73 ++-
 mm/sparse-vmemmap.c                               |   11 -
 112 files changed, 2146 insertions(+), 2228 deletions(-)
 rename arch/microblaze/include/asm/{lmb.h => memblock.h} (61%)
 delete mode 100644 arch/powerpc/include/asm/lmb.h
 create mode 100644 arch/powerpc/include/asm/memblock.h
 delete mode 100644 arch/sh/include/asm/lmb.h
 create mode 100644 arch/sh/include/asm/memblock.h
 delete mode 100644 arch/sparc/include/asm/lmb.h
 create mode 100644 arch/sparc/include/asm/memblock.h
 create mode 100644 arch/x86/include/asm/memblock.h
 create mode 100644 arch/x86/mm/memblock.c
 delete mode 100644 include/linux/early_res.h
 delete mode 100644 include/linux/lmb.h
 create mode 100644 include/linux/memblock.h
 delete mode 100644 kernel/early_res.c
 delete mode 100644 lib/lmb.c
 create mode 100644 mm/memblock.c
