Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244Ab2EUJDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:03:08 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:36077 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084Ab2EUJDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:03:04 -0400
Date: Mon, 21 May 2012 05:03:00 -0400 (EDT)
Message-Id: <20120521.050300.1434374935904126254.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 21 May 2012 02:03:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1) Kill off support for sun4c and Cypress sun4m chips.

   And as a result we were able to also kill off that ugly
   btfixup thing that required multi-stage links of the final
   vmlinux image in the Kbuild system.  This should make the
   kbuild maintainers really happy.

   Thanks a lot to Sam Ravnborg for his tireless efforts to
   get this going.

2) Convert sparc64 to nobootmem.  I suspect now with sparc32
   being a lot cleaner, it should be able to fall in line and
   modernize in this area too.

3) Make sparc32 use generic clockevents, from Tkhai Kirill.

There is going to be a merge conflict between the commit in the
net-next tree that adds the Sparc BPF JIT, and the one in here which
adds arch/sparc/Kbuild.  It should be quite easy to resolve.

Please pull, thanks a lot!

The following changes since commit 82b769063598d01a8b24abf250a53f8b437e09f1:

  Merge branch 'stable' of git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile (2012-04-26 15:36:27 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc-next master

for you to fetch changes up to 1edc17832d8f49a0263d364c453ea35da0e4e2a6:

  sparc32: use flushi when run-time patching in per_cpu_patch (2012-05-20 13:33:36 -0700)

----------------------------------------------------------------
Danny Kukawka (1):
      arch/sparc/kernel/unaligned_64.c: included linux/bitops.h twice

David S. Miller (54):
      Merge git://git.kernel.org/.../davem/sparc
      sparc64: Remove trap return code which is now unnecessary.
      Merge git://git.kernel.org/.../torvalds/linux
      sparc64: Convert over to NO_BOOTMEM.
      sparc64: Use node local allocations for IRQ stacks.
      sparc64: Do not set max_mapnr.
      sparc32: Remove inline strncmp "optimization" for constant counts.
      sparc: Convert some assembler over to linakge.h's ENTRY/ENDPROC
      sparc: Clear out unused asm/machines.h values.
      sparc32: Kill SUN4C_LOCK_{VADDR,END} and associated comment.
      sparc32: Put back SPARC_BRANCH.
      sparc32: Remove sun4c floppy assembler.
      sparc32: Stop warning about sun4/sun4c in SMP Kconfig option.
      sparc32: Kill asm/vac-ops.h
      sparc32: Restore SMP build and rectify sun4m NMI when non-SMP.
      sparc32: Remove sparc_lvl15_nmi().
      sparc32: Remove sun4{,c} control reg definitions from contregs.h.
      sparc32: Remove ldXa and stXa defines, unused.
      sparc32: Remove sun4c tlb/vac insn patching from entry.S
      sparc32: Remove some more sun4c code from floppy glue.
      sparc32: Kill unused defines from asm/head_32.h
      sparc32: Remove sparc_cpu_model read from floppy interrupt handler.
      sparc32: Remove sun4 and sun4c from enum sparc_cpu.
      sparc32: Trivial removal of sun4c references in comments.
      sparc32: Add back early sun4/sun4c detection so we can warn properly.
      sparc32: Un-btfixup PGDIR_{SHIFT,SIZE,MASK} {USER_,}PTRS_PER_{PGD,PMD}
      sparc32: Un-btfixup {pte,pmd,pgd}_clear().
      sparc32: Un-btfixup pmd_page and pte_pfn.
      sparc32: Un-btfixup PAGE_{NONE,COPY,READONLY,SHARED,KERNEL}.
      sparc32: Un-btfixup pgd_{none,bad,present}.
      sparc32: Un-btfixup pmd_{bad,present}().
      sparc32: Un-btfixup set_pte, pte_present, mk_pte{_phys,_io}().
      sparc32: Un-btfixup pte_{write,dirty,young}i
      sparc32: Un-btfixup more PTE constants and PTE ops.
      sparc32: Pass -mcpu=v7 explicitly to gcc.
      sparc32: Kill btfixup for xchg()'s 'swap' instruction.
      sparc32: Un-btfixup update_mmu_cache().
      sparc: Kill mmu_{un,}lockarea().
      sparc32: Convert mmu_* interfaces from btfixup to method ops.
      sparc32: Remove unused declarations in srmmu.c
      sparc32: Move cache and TLB flushes over to method ops.
      sparc32: Implement hard_smp_processor_id() via instruction patching.
      sparc32: Kill unused hard_smp{4m,4d,leon}_processor_id() inlined.
      sparc64: Remove pointless assignment in floppy support.
      sparc32: Remove cypress cpu support.
      sparc32: Build kernel with -mcpu=v8
      sparc32: Kill off software 32-bit multiply/divide routines.
      sparc32: Add ucmpdi2.o to obj-y instead of lib-y.
      sparc32: Remove completely unused code from asm/cache.h
      sparc32: Move GET_PROCESSOR*_ID() out of asm/asmmacro.h
      sparc32: Kill boot_cpu_id4
      sparc32: Remove unused empty_bad_page{,_table} declarations.
      sparc32: Delete asm/smpprim.h
      sparc32: Remove asm/sysen.h header.

Joe Perches (1):
      sparc: Use vsprintf extention %pf with builtin_return_address

Paul Gortmaker (1):
      sparc: fix build fail in mm/init_64.c when NEED_MULTIPLE_NODES is off

Sam Ravnborg (54):
      sparc32: rename sparc_irq_config to sparc_config
      sparc32: fix build of pcic
      sparc32: drop sun4c support
      sparc32: remove calls to sun4c dummy mm inits functions
      sparc32: remove sun4c traps
      sparc32: drop sun4c specific ___xchg32 implementation
      sparc32: remove all uses of ARCH_SUN4C
      sparc32: delete pgtsun4c.h
      sparc32: drop sun4c specific stack validation
      sparc32: drop sun4c window overflow stack checking routine
      sparc32: drop sun4c stack checking routine
      sparc32: drop sun4c user stack checking routine
      sparc32: drop test for sun4c in signal_32
      sparc32: drop sun4c bits from head_32.S
      sparc32: drop btfixup for alloc_thread_info_node/free_thread_info
      sparc32: use inline versions of pgprot_noncached, pte_to_pgoff and pgoff_to_pte
      sparc32: remove sun4c specific variables from head_32.S
      sparc32: drop prom version check in head_32.S
      sparc32: drop extra getprop call during boot
      sparc32: simpler cputype check in head_32.S
      sparc32: fix warning in floopy glue
      sparc32: code cleanup in floppy glue
      sparc32: drop btfixup for switch_mm
      sparc32: drop btfixup for check_pgt_cache
      sparc32: drop unused type/extern
      sparc32: drop loadmmu
      sparc32: drop unused code in process_32
      sparc32: drop btfixup in pgalloc_32.h
      sparc32: drop btfixup in pgtable_32.h
      sparc32: drop btfixup in mmu_context_32.h
      sparc32: drop unused prototype from timer_32.h
      sparc32: drop btfixup in page_32.h
      sparc32: drop unused set_irq_udt
      sparc32: drop unused clear_cpu_int
      sparc32: move smp ipi to method ops
      sparc32: remove remaining users of btfixup
      sparc32: remove runtime btfix support
      sparc32: drop build time btfixup patching
      sparc32: cleanup mm/fault_32.c
      sparc32: delete muldiv.o from Makefile
      sparc: clean up Makefile
      sparc: remove obsolete documentation
      sparc: introduce arch/sparc/Kbuild
      sparc32: add ucmpdi2
      sparc64: renamed ttable.S to ttable_64.S
      sparc32: move trap table to a separate file
      sparc32,leon: move leon ASI definitions to asi.h
      sparc32,leon: remove duplicate UART register definitions
      sparc32,leon: remove duplicate definitions in leon.h
      sparc32,leon: move leon mmu functions to leon_mm.c
      sparc32: drop unused functions in pgtsrmmu.h
      sparc32: drop unused inline functions in srmmu.c
      sparc32: fix cpuid_patch run-time patching
      sparc32: use flushi when run-time patching in per_cpu_patch

Tkhai Kirill (1):
      sparc32: generic clockevent support

 Documentation/sparc/README-2.5              |   46 -
 arch/sparc/Kbuild                           |    7 +
 arch/sparc/Kconfig                          |   10 +-
 arch/sparc/Makefile                         |   47 +-
 arch/sparc/boot/Makefile                    |   61 +-
 arch/sparc/boot/btfixupprep.c               |  386 -----
 arch/sparc/include/asm/asi.h                |   14 +
 arch/sparc/include/asm/asmmacro.h           |   17 -
 arch/sparc/include/asm/btfixup.h            |  208 ---
 arch/sparc/include/asm/cache.h              |  114 --
 arch/sparc/include/asm/cacheflush.h         |    4 +
 arch/sparc/include/asm/cacheflush_32.h      |   73 +-
 arch/sparc/include/asm/cacheflush_64.h      |    3 -
 arch/sparc/include/asm/cachetlb_32.h        |   29 +
 arch/sparc/include/asm/cmpxchg_32.h         |   27 -
 arch/sparc/include/asm/contregs.h           |   22 -
 arch/sparc/include/asm/cpu_type.h           |   20 +-
 arch/sparc/include/asm/cpudata_32.h         |    1 -
 arch/sparc/include/asm/cypress.h            |   79 -
 arch/sparc/include/asm/dma.h                |   52 +-
 arch/sparc/include/asm/elf_32.h             |   13 +-
 arch/sparc/include/asm/floppy_32.h          |   45 +-
 arch/sparc/include/asm/floppy_64.h          |    6 +-
 arch/sparc/include/asm/head_32.h            |   21 +-
 arch/sparc/include/asm/leon.h               |   61 +-
 arch/sparc/include/asm/machines.h           |   23 +-
 arch/sparc/include/asm/mbus.h               |    4 -
 arch/sparc/include/asm/memreg.h             |   51 -
 arch/sparc/include/asm/mmu_context_32.h     |   11 +-
 arch/sparc/include/asm/obio.h               |   13 -
 arch/sparc/include/asm/oplib_32.h           |    8 -
 arch/sparc/include/asm/page_32.h            |   13 +-
 arch/sparc/include/asm/pgalloc_32.h         |   76 +-
 arch/sparc/include/asm/pgtable_32.h         |  387 ++---
 arch/sparc/include/asm/pgtable_64.h         |    4 -
 arch/sparc/include/asm/pgtsrmmu.h           |   50 -
 arch/sparc/include/asm/pgtsun4c.h           |  172 ---
 arch/sparc/include/asm/processor_32.h       |    1 -
 arch/sparc/include/asm/setup.h              |    3 -
 arch/sparc/include/asm/shmparam_32.h        |    4 +-
 arch/sparc/include/asm/smp_32.h             |  114 +-
 arch/sparc/include/asm/smpprim.h            |   54 -
 arch/sparc/include/asm/string_32.h          |   63 +-
 arch/sparc/include/asm/sysen.h              |   15 -
 arch/sparc/include/asm/thread_info_32.h     |    8 +-
 arch/sparc/include/asm/timer_32.h           |   33 +-
 arch/sparc/include/asm/timex_32.h           |    1 -
 arch/sparc/include/asm/tlbflush_32.h        |   56 +-
 arch/sparc/include/asm/uaccess_32.h         |    1 -
 arch/sparc/include/asm/vac-ops.h            |  127 --
 arch/sparc/include/asm/vaddrs.h             |   16 -
 arch/sparc/include/asm/winmacro.h           |   49 +-
 arch/sparc/kernel/Makefile                  |    3 +-
 arch/sparc/kernel/auxio_32.c                |   13 +-
 arch/sparc/kernel/devices.c                 |    4 -
 arch/sparc/kernel/ds.c                      |    2 +-
 arch/sparc/kernel/entry.S                   |  432 +-----
 arch/sparc/kernel/etrap_32.S                |   50 +-
 arch/sparc/kernel/head_32.S                 |  639 +-------
 arch/sparc/kernel/head_64.S                 |    2 +-
 arch/sparc/kernel/idprom.c                  |   19 +-
 arch/sparc/kernel/ioport.c                  |   23 +-
 arch/sparc/kernel/irq.h                     |   60 +-
 arch/sparc/kernel/irq_32.c                  |   19 +-
 arch/sparc/kernel/irq_64.c                  |    2 +-
 arch/sparc/kernel/kernel.h                  |   10 -
 arch/sparc/kernel/leon_kernel.c             |   98 +-
 arch/sparc/kernel/leon_smp.c                |  113 +-
 arch/sparc/kernel/module.c                  |   21 +-
 arch/sparc/kernel/muldiv.c                  |  238 ---
 arch/sparc/kernel/of_device_32.c            |    4 +-
 arch/sparc/kernel/pcic.c                    |   55 +-
 arch/sparc/kernel/process_32.c              |  116 --
 arch/sparc/kernel/rtrap_32.S                |   76 +-
 arch/sparc/kernel/rtrap_64.S                |   12 +-
 arch/sparc/kernel/setup_32.c                |   70 +-
 arch/sparc/kernel/signal_32.c               |    7 +-
 arch/sparc/kernel/smp_32.c                  |  175 +--
 arch/sparc/kernel/sparc_ksyms_32.c          |   14 -
 arch/sparc/kernel/sun4c_irq.c               |  264 ----
 arch/sparc/kernel/sun4d_irq.c               |   48 +-
 arch/sparc/kernel/sun4d_smp.c               |  119 +-
 arch/sparc/kernel/sun4m_irq.c               |   58 +-
 arch/sparc/kernel/sun4m_smp.c               |  117 +-
 arch/sparc/kernel/sys_sparc_32.c            |   11 -
 arch/sparc/kernel/time_32.c                 |  220 ++-
 arch/sparc/kernel/trampoline_32.S           |   22 +-
 arch/sparc/kernel/traps_32.c                |    2 -
 arch/sparc/kernel/ttable_32.S               |  417 ++++++
 arch/sparc/kernel/{ttable.S => ttable_64.S} |    0
 arch/sparc/kernel/unaligned_64.c            |    1 -
 arch/sparc/kernel/wof.S                     |   72 +-
 arch/sparc/kernel/wuf.S                     |   60 +-
 arch/sparc/lib/Makefile                     |    6 +-
 arch/sparc/lib/ashldi3.S                    |    7 +-
 arch/sparc/lib/ashrdi3.S                    |    7 +-
 arch/sparc/lib/atomic_32.S                  |   44 -
 arch/sparc/lib/atomic_64.S                  |   49 +-
 arch/sparc/lib/bitops.S                     |   37 +-
 arch/sparc/lib/blockops.S                   |   10 +-
 arch/sparc/lib/bzero.S                      |   20 +-
 arch/sparc/lib/divdi3.S                     |    4 +-
 arch/sparc/lib/ipcsum.S                     |    9 +-
 arch/sparc/lib/ksyms.c                      |   22 -
 arch/sparc/lib/lshrdi3.S                    |    5 +-
 arch/sparc/lib/memmove.S                    |    9 +-
 arch/sparc/lib/mul.S                        |  137 --
 arch/sparc/lib/muldi3.S                     |    4 +-
 arch/sparc/lib/rem.S                        |  384 -----
 arch/sparc/lib/sdiv.S                       |  381 -----
 arch/sparc/lib/strlen_user_64.S             |    8 +-
 arch/sparc/lib/strncmp_32.S                 |    8 +-
 arch/sparc/lib/strncmp_64.S                 |    8 +-
 arch/sparc/lib/strncpy_from_user_32.S       |    6 +-
 arch/sparc/lib/strncpy_from_user_64.S       |    8 +-
 arch/sparc/lib/ucmpdi2.c                    |   19 +
 arch/sparc/lib/udiv.S                       |  357 -----
 arch/sparc/lib/udivdi3.S                    |    3 +-
 arch/sparc/lib/umul.S                       |  171 ---
 arch/sparc/lib/urem.S                       |  357 -----
 arch/sparc/lib/xor.S                        |   50 +-
 arch/sparc/mm/Makefile                      |    9 +-
 arch/sparc/mm/btfixup.c                     |  328 ----
 arch/sparc/mm/fault_32.c                    |  207 +--
 arch/sparc/mm/init_32.c                     |   51 -
 arch/sparc/mm/init_64.c                     |  121 +-
 arch/sparc/mm/io-unit.c                     |   35 +-
 arch/sparc/mm/iommu.c                       |   71 +-
 arch/sparc/mm/leon_mm.c                     |   95 +-
 arch/sparc/mm/loadmmu.c                     |   43 -
 arch/sparc/mm/nosun4c.c                     |   77 -
 arch/sparc/mm/srmmu.c                       | 1232 ++++-----------
 arch/sparc/mm/srmmu.h                       |    4 +
 arch/sparc/mm/sun4c.c                       | 2166 ---------------------------
 arch/sparc/mm/viking.S                      |    1 -
 arch/sparc/prom/Makefile                    |    1 -
 arch/sparc/prom/segment.c                   |   28 -
 137 files changed, 2240 insertions(+), 10770 deletions(-)
 delete mode 100644 Documentation/sparc/README-2.5
 create mode 100644 arch/sparc/Kbuild
 delete mode 100644 arch/sparc/boot/btfixupprep.c
 delete mode 100644 arch/sparc/include/asm/btfixup.h
 create mode 100644 arch/sparc/include/asm/cachetlb_32.h
 delete mode 100644 arch/sparc/include/asm/cypress.h
 delete mode 100644 arch/sparc/include/asm/memreg.h
 delete mode 100644 arch/sparc/include/asm/pgtsun4c.h
 delete mode 100644 arch/sparc/include/asm/smpprim.h
 delete mode 100644 arch/sparc/include/asm/sysen.h
 delete mode 100644 arch/sparc/include/asm/vac-ops.h
 delete mode 100644 arch/sparc/kernel/muldiv.c
 delete mode 100644 arch/sparc/kernel/sun4c_irq.c
 create mode 100644 arch/sparc/kernel/ttable_32.S
 rename arch/sparc/kernel/{ttable.S => ttable_64.S} (100%)
 delete mode 100644 arch/sparc/lib/atomic_32.S
 delete mode 100644 arch/sparc/lib/mul.S
 delete mode 100644 arch/sparc/lib/rem.S
 delete mode 100644 arch/sparc/lib/sdiv.S
 create mode 100644 arch/sparc/lib/ucmpdi2.c
 delete mode 100644 arch/sparc/lib/udiv.S
 delete mode 100644 arch/sparc/lib/umul.S
 delete mode 100644 arch/sparc/lib/urem.S
 delete mode 100644 arch/sparc/mm/btfixup.c
 delete mode 100644 arch/sparc/mm/loadmmu.c
 delete mode 100644 arch/sparc/mm/nosun4c.c
 create mode 100644 arch/sparc/mm/srmmu.h
 delete mode 100644 arch/sparc/mm/sun4c.c
 delete mode 100644 arch/sparc/prom/segment.c
