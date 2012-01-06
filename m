Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab2AFBf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 20:35:26 -0500
Received: from sncsmrelay2.nai.com ([67.97.80.206]:49217 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab2AFBfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 20:35:23 -0500
Date: Fri, 6 Jan 2012 11:32:49 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-ID: <201201060132.q061WnGO030499@goober.corp.nai.org>
CC: <gerg@uclinux.org>, <linux-kernel@vger.kernel.org>,
        <linux-m68k@vger.kernel.org>, <uclinux-dev@uclinux.org>,
        <geert@linux-m68k.org>
Subject: [git pull] m68knommu arch updates for 3.3
To: <torvalds@linux-foundation.org>
X-Mailer: mail (GNU Mailutils 2.1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Can you please pull the m68knommu git tree, for-next branch:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-next

The biggest change is the addition of MMU support for some of the ColdFire
CPU types. The older ColdFire CPUs had no MMU hardware, but some of the
newer v4 variants do. There is also quite a few clean up, dead code removal
and merge patches to gradually get the classic m68k and the m68knommu code
better integrated.

Regards
Greg




The following changes since commit 5f0a6e2d503896062f641639dacfe5055c2f593b:
  Linus Torvalds (1):
        Linux 3.2-rc7

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-next

Geert Uytterhoeven (1):
      m68k/Kconfig: Separate classic m68k and coldfire early

Greg Ungerer (53):
      m68knommu: remove unused fasthandler declaration
      m68k: merge the init_task code for mmu and non-mmu targets
      m68k: remove duplicate asm offset for task thread.info
      m68k: remove thread_info struct from thread struct
      m68k: selection of GENERIC_ATOMIC64 is not MMU specific
      m68knommu: move definition of mach_gettod to where it is used
      m68k: print memory layout info in boot log
      m68k: support configure time command line for MMU m68k
      m68knommu: no need to set register marker on traps
      m68k: make fp register stores consistent for m68k and ColdFire
      m68k: simpler m68k and ColdFire CPU's can use generic csum code
      m68k: handle presence of 64bit mul/div instructions cleanly
      m68knommu: disable cache early in startup for ColdFire
      m68knommu: fix broken ColdFire slice timer read_clk() code
      m68knommu: remove unused anchor.h include file
      m68k: consolidate the vmlinux.lds linker scripts
      m68knommu: fix broken boot logo inclusion
      m68knommu: remove no longer used rom_length from Palm/Pilot start up code
      m68k: add machine and CPU definitions for ColdFire cores
      m68k: show ColdFire CPU/FPU/MMU type
      m68k: definitions for the ColdFire V4e MMU hardware
      m68k: make interrupt definitions conditional on correct CPU types
      m68k: add TASK definitions for ColdFires running with MMU
      m68k: modify user space access functions to support ColdFire CPUs
      m68k: use addr_limit checking for m68k CPUs that do no support address spaces
      m68k: init the MMU hardware for the 54xx ColdFire
      m68k: add ColdFire 54xx CPU MMU memory init code
      m68k: set register a2 to current if MMU enabled on ColdFire
      m68k: page table support definitions and code for ColdFire MMU
      m68k: add page table size definitions for ColdFire V4e MMU
      m68k: add ColdFire paging exception handling code
      m68k: add cache support for V4e ColdFire cores running with MMU enabled
      m68k: modify ColdFire 54xx cache support for MMU enabled
      m68k: add TLB flush support for the ColdFire V4e MMU hardware
      m68k: define PAGE_OFFSET_RAW for ColdFire CPU with MMU enabled
      m68k: set ColdFire MMU page size
      m68k: MMU enabled ColdFire needs 8k ELF alignment
      m68k: ColdFire V4e MMU context support code
      m68k: use tracehook_report_syscall_entry/exit for ColdFire MMU ptrace path
      m68k: modify cache push and clear code for ColdFire with MMU enable
      m68k: use ColdFire MMU read/write bit flags when ioremapping
      m68k: ColdFire V4e MMU paging init code and miss handler
      m68k: compile appropriate mm arch files for ColdFire MMU support
      m68k: create ColdFire MMU pgalloc code
      m68k: use non-MMU entry.S code when compiling for ColdFire CPU
      m68k: add code to setup a ColdFire 54xx platform when MMU enabled
      m68k: ColdFire with MMU enabled uses same clocking code as non-MMU
      m68k: use non-MMU linker script for ColdFire MMU builds
      m68k: adjustments to stack frame for ColdFire with MMU enabled
      m68k: add ColdFire FPU support for the V4e ColdFire CPUs
      m68k: do not use m68k startup or interrupt code for ColdFire CPUs
      m68k: add ColdFire with MMU enabled support to the m68k mem init code
      m68k: allow ColdFire 547x and 548x CPUs to be built with MMU enabled

John Stultz (1):
      clocksource: m86k: Convert to clocksource_register_hz/khz

Mark Brown (1):
      m68k: Fall back to __gpio_to_irq() for non-arch GPIOs

 arch/m68k/Kconfig                                  |   17 +-
 arch/m68k/Kconfig.cpu                              |   78 +++--
 arch/m68k/Kconfig.debug                            |   16 +-
 arch/m68k/Kconfig.machine                          |    4 +
 arch/m68k/include/asm/anchor.h                     |  112 -----
 arch/m68k/include/asm/atomic.h                     |   10 +
 arch/m68k/include/asm/cacheflush_mm.h              |   88 ++++-
 arch/m68k/include/asm/checksum.h                   |   31 +--
 arch/m68k/include/asm/div64.h                      |    8 +-
 arch/m68k/include/asm/elf.h                        |    6 +-
 arch/m68k/include/asm/entry.h                      |   10 +-
 arch/m68k/include/asm/fpu.h                        |    2 +
 arch/m68k/include/asm/gpio.h                       |    3 +-
 arch/m68k/include/asm/irq.h                        |    5 +-
 arch/m68k/include/asm/m54xxacr.h                   |   32 ++-
 arch/m68k/include/asm/mcf_pgalloc.h                |  102 +++++
 arch/m68k/include/asm/mcf_pgtable.h                |  425 ++++++++++++++++++++
 arch/m68k/include/asm/mcfmmu.h                     |  112 +++++
 arch/m68k/include/asm/mmu_context.h                |  250 +++++++++---
 arch/m68k/include/asm/motorola_pgtable.h           |    1 +
 arch/m68k/include/asm/page.h                       |   10 +-
 arch/m68k/include/asm/page_no.h                    |    3 -
 arch/m68k/include/asm/page_offset.h                |   10 +-
 arch/m68k/include/asm/pgalloc.h                    |    4 +-
 arch/m68k/include/asm/pgtable_mm.h                 |   30 ++-
 arch/m68k/include/asm/processor.h                  |   18 +-
 arch/m68k/include/asm/segment.h                    |   30 +-
 arch/m68k/include/asm/setup.h                      |   14 +
 arch/m68k/include/asm/sigcontext.h                 |    4 -
 arch/m68k/include/asm/thread_info.h                |   33 +--
 arch/m68k/include/asm/tlbflush.h                   |   23 +-
 arch/m68k/include/asm/traps.h                      |    1 +
 arch/m68k/include/asm/uaccess_mm.h                 |   42 ++-
 arch/m68k/include/asm/ucontext.h                   |    4 -
 arch/m68k/kernel/Makefile                          |   21 +-
 arch/m68k/kernel/asm-offsets.c                     |    3 +-
 arch/m68k/kernel/entry.S                           |    2 +-
 arch/m68k/kernel/entry_mm.S                        |   31 +-
 arch/m68k/kernel/entry_no.S                        |    9 +-
 arch/m68k/kernel/init_task.c                       |    3 +-
 arch/m68k/kernel/m68k_ksyms.c                      |    2 +-
 arch/m68k/kernel/process_mm.c                      |   75 ++--
 arch/m68k/kernel/ptrace_mm.c                       |   18 +
 arch/m68k/kernel/setup_mm.c                        |   22 +-
 arch/m68k/kernel/setup_no.c                        |    1 -
 arch/m68k/kernel/signal_mm.c                       |  204 +++++++---
 arch/m68k/kernel/time.c                            |    2 +-
 arch/m68k/kernel/time_no.c                         |    3 +
 arch/m68k/kernel/traps.c                           |  104 +++++
 .../kernel/{vmlinux.lds_no.S => vmlinux-nommu.lds} |    8 +
 arch/m68k/kernel/vmlinux-std.lds                   |    2 +
 arch/m68k/kernel/vmlinux-sun3.lds                  |    2 +
 arch/m68k/kernel/vmlinux.lds.S                     |   15 +-
 arch/m68k/kernel/vmlinux.lds_mm.S                  |   10 -
 arch/m68k/lib/Makefile                             |   10 +-
 arch/m68k/lib/{checksum_mm.c => checksum.c}        |    0
 arch/m68k/lib/checksum_no.c                        |  156 -------
 arch/m68k/lib/uaccess.c                            |   22 +-
 arch/m68k/mm/Makefile                              |    8 +-
 arch/m68k/mm/cache.c                               |   24 +-
 arch/m68k/mm/init_mm.c                             |   36 ++-
 arch/m68k/mm/kmap.c                                |    3 +-
 arch/m68k/mm/mcfmmu.c                              |  198 +++++++++
 arch/m68k/mm/memory.c                              |    8 +-
 arch/m68k/platform/54xx/config.c                   |   47 +++
 arch/m68k/platform/68328/Makefile                  |    6 +-
 arch/m68k/platform/68328/bootlogo.h                |    2 +-
 arch/m68k/platform/68328/bootlogo.pl               |   10 -
 arch/m68k/platform/68328/config.c                  |    3 +
 arch/m68k/platform/68328/head-pilot.S              |   19 +-
 arch/m68k/platform/68328/head-rom.S                |    9 +-
 arch/m68k/platform/68328/timers.c                  |    4 +-
 arch/m68k/platform/coldfire/dma_timer.c            |    5 +-
 arch/m68k/platform/coldfire/entry.S                |    7 +-
 arch/m68k/platform/coldfire/head.S                 |   53 +++-
 arch/m68k/platform/coldfire/pit.c                  |    4 +-
 arch/m68k/platform/coldfire/sltimers.c             |   13 +-
 arch/m68k/platform/coldfire/timers.c               |    4 +-
 78 files changed, 2009 insertions(+), 717 deletions(-)
 delete mode 100644 arch/m68k/include/asm/anchor.h
 create mode 100644 arch/m68k/include/asm/mcf_pgalloc.h
 create mode 100644 arch/m68k/include/asm/mcf_pgtable.h
 create mode 100644 arch/m68k/include/asm/mcfmmu.h
 rename arch/m68k/kernel/{vmlinux.lds_no.S => vmlinux-nommu.lds} (97%)
 delete mode 100644 arch/m68k/kernel/vmlinux.lds_mm.S
 rename arch/m68k/lib/{checksum_mm.c => checksum.c} (100%)
 delete mode 100644 arch/m68k/lib/checksum_no.c
 create mode 100644 arch/m68k/mm/mcfmmu.c
 delete mode 100644 arch/m68k/platform/68328/bootlogo.pl
