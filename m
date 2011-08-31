Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab1HaV2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 17:28:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755884Ab1HaV2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 17:28:00 -0400
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, ming.lei@canonical.com,
        stern@rowland.harvard.edu, Mark Salter <msalter@redhat.com>
Subject: [PATCH v2 00/24] C6X: New architecture patch set
Date: Wed, 31 Aug 2011 17:26:35 -0400
Message-Id: <1314826019-22330-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is v2 of the C6X architecture patch series.

Changes from the previous patchset are:

 * Replaced 64-by-64 divides (two places) with do_div

 * Parse device tree for base address of some miscellaneous SoC registers.
   The clkdev code still has a hard-coded address but that will go away when
   device tree clock bindings are settled.

 * Tweaked the DTS files to more closely match the actual hardware.

 * Removed all board-specific files by making better use of device tree.

 * Removed CONFIG_NR_IRQS and replaced with hard-coded number which is large
   enough for all supported SoCs with room to spare.

 * Removed GENERIC_FIND_* references.

 * Cleaned up Makefiles and Kconfig files.

 * Removed VMLINUX_SYMBOL usage in linker script (not needed for C6X).

 * Cleaned up show_cpuinfo.

 * Added __HEAD to head.S

 * Use generic asm/dma.h

 * Added cpu_relax() to busy wait loops in cache code.

 * Dropped unneeded module support routines (handled in generic code)

 * Cleaned up DMA support.

 * Removed deprecated syscalls.

 * Removed PTRACE_PEEKUSR and PTRACE_POKEUSR.

 * Cleaned up sparse warnings.

This latest patchset is available in the 'upstream-v2' branch of the git repo
at:

       git@linux-c6x.org:/git/projects/linux-c6x-upstreaming

Mark Salter (24):
  fix default __strnlen_user macro
  fixed generic page.h for non-zero PAGE_OFFSET
  add ELF machine define for TI C6X DSPs
  C6X: build infrastructure
  C6X: early boot code
  C6X: devicetree
  C6X: memory management and DMA support
  C6X: process management
  C6X: signal management
  C6X: time management
  C6X: interrupt handling
  C6X: syscalls
  C6X: traps
  C6X: clocks
  C6X: cache control
  C6X: loadable module support
  C6X: ptrace support
  C6X: headers
  C6X: library code
  C6X: general SoC support
  C6X: specific SoC support
  C6X: EMIF - External Memory Interface
  C6X: Power and Sleep Controller
  C6X: MAINTAINERS

 MAINTAINERS                         |    8 +
 arch/c6x/Kconfig                    |  179 ++++++++
 arch/c6x/Makefile                   |   56 +++
 arch/c6x/boot/Makefile              |   22 +
 arch/c6x/boot/dts/dsk6455.dts       |  128 ++++++
 arch/c6x/boot/dts/evmc6457.dts      |  106 +++++
 arch/c6x/boot/dts/evmc6472.dts      |  176 ++++++++
 arch/c6x/boot/dts/evmc6474.dts      |  133 ++++++
 arch/c6x/boot/install-dtb.c         |  333 +++++++++++++++
 arch/c6x/configs/dsk6455_defconfig  |   43 ++
 arch/c6x/configs/evmc6457_defconfig |   40 ++
 arch/c6x/configs/evmc6472_defconfig |   41 ++
 arch/c6x/configs/evmc6474_defconfig |   41 ++
 arch/c6x/include/asm/Kbuild         |   55 +++
 arch/c6x/include/asm/asm-offsets.h  |    1 +
 arch/c6x/include/asm/bitops.h       |  105 +++++
 arch/c6x/include/asm/byteorder.h    |   12 +
 arch/c6x/include/asm/cache.h        |   90 ++++
 arch/c6x/include/asm/cacheflush.h   |   65 +++
 arch/c6x/include/asm/checksum.h     |  115 +++++
 arch/c6x/include/asm/clkdev.h       |   22 +
 arch/c6x/include/asm/clock.h        |  148 +++++++
 arch/c6x/include/asm/delay.h        |   67 +++
 arch/c6x/include/asm/dma-mapping.h  |   91 ++++
 arch/c6x/include/asm/elf.h          |  113 +++++
 arch/c6x/include/asm/ftrace.h       |    6 +
 arch/c6x/include/asm/hardirq.h      |   20 +
 arch/c6x/include/asm/irq.h          |  302 +++++++++++++
 arch/c6x/include/asm/irqflags.h     |   72 ++++
 arch/c6x/include/asm/linkage.h      |   30 ++
 arch/c6x/include/asm/memblock.h     |    4 +
 arch/c6x/include/asm/mmu.h          |   18 +
 arch/c6x/include/asm/module.h       |   33 ++
 arch/c6x/include/asm/mutex.h        |    6 +
 arch/c6x/include/asm/page.h         |   11 +
 arch/c6x/include/asm/pgtable.h      |   81 ++++
 arch/c6x/include/asm/processor.h    |  132 ++++++
 arch/c6x/include/asm/procinfo.h     |   28 ++
 arch/c6x/include/asm/prom.h         |    1 +
 arch/c6x/include/asm/ptrace.h       |  181 ++++++++
 arch/c6x/include/asm/sections.h     |   12 +
 arch/c6x/include/asm/setup.h        |   29 ++
 arch/c6x/include/asm/sigcontext.h   |   80 ++++
 arch/c6x/include/asm/signal.h       |   17 +
 arch/c6x/include/asm/soc.h          |  126 ++++++
 arch/c6x/include/asm/string.h       |   21 +
 arch/c6x/include/asm/syscalls.h     |   55 +++
 arch/c6x/include/asm/system.h       |  197 +++++++++
 arch/c6x/include/asm/thread_info.h  |  121 ++++++
 arch/c6x/include/asm/timex.h        |   41 ++
 arch/c6x/include/asm/tlb.h          |    8 +
 arch/c6x/include/asm/traps.h        |   39 ++
 arch/c6x/include/asm/uaccess.h      |  107 +++++
 arch/c6x/include/asm/unaligned.h    |  288 +++++++++++++
 arch/c6x/include/asm/unistd.h       |   26 ++
 arch/c6x/kernel/Makefile            |   12 +
 arch/c6x/kernel/asm-offsets.c       |  123 ++++++
 arch/c6x/kernel/c6x_ksyms.c         |   68 +++
 arch/c6x/kernel/devicetree.c        |   53 +++
 arch/c6x/kernel/dma.c               |  168 ++++++++
 arch/c6x/kernel/entry.S             |  803 +++++++++++++++++++++++++++++++++++
 arch/c6x/kernel/head.S              |   84 ++++
 arch/c6x/kernel/irq.c               |  732 +++++++++++++++++++++++++++++++
 arch/c6x/kernel/module.c            |  196 +++++++++
 arch/c6x/kernel/process.c           |  260 +++++++++++
 arch/c6x/kernel/ptrace.c            |  207 +++++++++
 arch/c6x/kernel/setup.c             |  488 +++++++++++++++++++++
 arch/c6x/kernel/signal.c            |  377 ++++++++++++++++
 arch/c6x/kernel/soc.c               |  168 ++++++++
 arch/c6x/kernel/switch_to.S         |   74 ++++
 arch/c6x/kernel/sys_c6x.c           |   82 ++++
 arch/c6x/kernel/time.c              |   64 +++
 arch/c6x/kernel/traps.c             |  423 ++++++++++++++++++
 arch/c6x/kernel/vectors.S           |   81 ++++
 arch/c6x/kernel/vmlinux.lds.S       |  170 ++++++++
 arch/c6x/lib/Makefile               |    8 +
 arch/c6x/lib/csum_64plus.S          |  404 ++++++++++++++++++
 arch/c6x/lib/divi.S                 |   53 +++
 arch/c6x/lib/divremi.S              |   46 ++
 arch/c6x/lib/divremu.S              |   87 ++++
 arch/c6x/lib/divu.S                 |   98 +++++
 arch/c6x/lib/llshl.S                |   37 ++
 arch/c6x/lib/llshr.S                |   38 ++
 arch/c6x/lib/llshru.S               |   38 ++
 arch/c6x/lib/memcpy_64plus.S        |   46 ++
 arch/c6x/lib/mpyll.S                |   49 +++
 arch/c6x/lib/negll.S                |   31 ++
 arch/c6x/lib/pop_rts.S              |   32 ++
 arch/c6x/lib/push_rts.S             |   31 ++
 arch/c6x/lib/remi.S                 |   64 +++
 arch/c6x/lib/remu.S                 |   82 ++++
 arch/c6x/lib/strasgi.S              |   89 ++++
 arch/c6x/lib/strasgi_64plus.S       |   39 ++
 arch/c6x/mm/Makefile                |    5 +
 arch/c6x/mm/dma-coherent.c          |  142 ++++++
 arch/c6x/mm/init.c                  |  112 +++++
 arch/c6x/platforms/Kconfig          |   45 ++
 arch/c6x/platforms/Makefile         |   13 +
 arch/c6x/platforms/cache.c          |  445 +++++++++++++++++++
 arch/c6x/platforms/emif.c           |   77 ++++
 arch/c6x/platforms/megamod-pic.c    |  336 +++++++++++++++
 arch/c6x/platforms/megamod-pic.h    |    9 +
 arch/c6x/platforms/platform.c       |   23 +
 arch/c6x/platforms/pll.c            |  471 ++++++++++++++++++++
 arch/c6x/platforms/plldata.c        |  151 +++++++
 arch/c6x/platforms/psc.c            |  181 ++++++++
 arch/c6x/platforms/psc.h            |   25 ++
 arch/c6x/platforms/soc-6455.c       |  389 +++++++++++++++++
 arch/c6x/platforms/soc-6457.c       |  187 ++++++++
 arch/c6x/platforms/soc-6472.c       |  428 +++++++++++++++++++
 arch/c6x/platforms/soc-6474.c       |  244 +++++++++++
 arch/c6x/platforms/timer64.c        |  191 +++++++++
 arch/c6x/platforms/timer64.h        |    6 +
 include/asm-generic/page.h          |   10 +-
 include/asm-generic/uaccess.h       |    2 +-
 include/linux/elf-em.h              |    1 +
 116 files changed, 13676 insertions(+), 4 deletions(-)
 create mode 100644 arch/c6x/Kconfig
 create mode 100644 arch/c6x/Makefile
 create mode 100644 arch/c6x/boot/Makefile
 create mode 100644 arch/c6x/boot/dts/dsk6455.dts
 create mode 100644 arch/c6x/boot/dts/evmc6457.dts
 create mode 100644 arch/c6x/boot/dts/evmc6472.dts
 create mode 100644 arch/c6x/boot/dts/evmc6474.dts
 create mode 100644 arch/c6x/boot/install-dtb.c
 create mode 100644 arch/c6x/configs/dsk6455_defconfig
 create mode 100644 arch/c6x/configs/evmc6457_defconfig
 create mode 100644 arch/c6x/configs/evmc6472_defconfig
 create mode 100644 arch/c6x/configs/evmc6474_defconfig
 create mode 100644 arch/c6x/include/asm/Kbuild
 create mode 100644 arch/c6x/include/asm/asm-offsets.h
 create mode 100644 arch/c6x/include/asm/bitops.h
 create mode 100644 arch/c6x/include/asm/byteorder.h
 create mode 100644 arch/c6x/include/asm/cache.h
 create mode 100644 arch/c6x/include/asm/cacheflush.h
 create mode 100644 arch/c6x/include/asm/checksum.h
 create mode 100644 arch/c6x/include/asm/clkdev.h
 create mode 100644 arch/c6x/include/asm/clock.h
 create mode 100644 arch/c6x/include/asm/delay.h
 create mode 100644 arch/c6x/include/asm/dma-mapping.h
 create mode 100644 arch/c6x/include/asm/elf.h
 create mode 100644 arch/c6x/include/asm/ftrace.h
 create mode 100644 arch/c6x/include/asm/hardirq.h
 create mode 100644 arch/c6x/include/asm/irq.h
 create mode 100644 arch/c6x/include/asm/irqflags.h
 create mode 100644 arch/c6x/include/asm/linkage.h
 create mode 100644 arch/c6x/include/asm/memblock.h
 create mode 100644 arch/c6x/include/asm/mmu.h
 create mode 100644 arch/c6x/include/asm/module.h
 create mode 100644 arch/c6x/include/asm/mutex.h
 create mode 100644 arch/c6x/include/asm/page.h
 create mode 100644 arch/c6x/include/asm/pgtable.h
 create mode 100644 arch/c6x/include/asm/processor.h
 create mode 100644 arch/c6x/include/asm/procinfo.h
 create mode 100644 arch/c6x/include/asm/prom.h
 create mode 100644 arch/c6x/include/asm/ptrace.h
 create mode 100644 arch/c6x/include/asm/sections.h
 create mode 100644 arch/c6x/include/asm/setup.h
 create mode 100644 arch/c6x/include/asm/sigcontext.h
 create mode 100644 arch/c6x/include/asm/signal.h
 create mode 100644 arch/c6x/include/asm/soc.h
 create mode 100644 arch/c6x/include/asm/string.h
 create mode 100644 arch/c6x/include/asm/syscalls.h
 create mode 100644 arch/c6x/include/asm/system.h
 create mode 100644 arch/c6x/include/asm/thread_info.h
 create mode 100644 arch/c6x/include/asm/timex.h
 create mode 100644 arch/c6x/include/asm/tlb.h
 create mode 100644 arch/c6x/include/asm/traps.h
 create mode 100644 arch/c6x/include/asm/uaccess.h
 create mode 100644 arch/c6x/include/asm/unaligned.h
 create mode 100644 arch/c6x/include/asm/unistd.h
 create mode 100644 arch/c6x/kernel/Makefile
 create mode 100644 arch/c6x/kernel/asm-offsets.c
 create mode 100644 arch/c6x/kernel/c6x_ksyms.c
 create mode 100644 arch/c6x/kernel/devicetree.c
 create mode 100644 arch/c6x/kernel/dma.c
 create mode 100644 arch/c6x/kernel/entry.S
 create mode 100644 arch/c6x/kernel/head.S
 create mode 100644 arch/c6x/kernel/irq.c
 create mode 100644 arch/c6x/kernel/module.c
 create mode 100644 arch/c6x/kernel/process.c
 create mode 100644 arch/c6x/kernel/ptrace.c
 create mode 100644 arch/c6x/kernel/setup.c
 create mode 100644 arch/c6x/kernel/signal.c
 create mode 100644 arch/c6x/kernel/soc.c
 create mode 100644 arch/c6x/kernel/switch_to.S
 create mode 100644 arch/c6x/kernel/sys_c6x.c
 create mode 100644 arch/c6x/kernel/time.c
 create mode 100644 arch/c6x/kernel/traps.c
 create mode 100644 arch/c6x/kernel/vectors.S
 create mode 100644 arch/c6x/kernel/vmlinux.lds.S
 create mode 100644 arch/c6x/lib/Makefile
 create mode 100644 arch/c6x/lib/csum_64plus.S
 create mode 100644 arch/c6x/lib/divi.S
 create mode 100644 arch/c6x/lib/divremi.S
 create mode 100644 arch/c6x/lib/divremu.S
 create mode 100644 arch/c6x/lib/divu.S
 create mode 100644 arch/c6x/lib/llshl.S
 create mode 100644 arch/c6x/lib/llshr.S
 create mode 100644 arch/c6x/lib/llshru.S
 create mode 100644 arch/c6x/lib/memcpy_64plus.S
 create mode 100644 arch/c6x/lib/mpyll.S
 create mode 100644 arch/c6x/lib/negll.S
 create mode 100644 arch/c6x/lib/pop_rts.S
 create mode 100644 arch/c6x/lib/push_rts.S
 create mode 100644 arch/c6x/lib/remi.S
 create mode 100644 arch/c6x/lib/remu.S
 create mode 100644 arch/c6x/lib/strasgi.S
 create mode 100644 arch/c6x/lib/strasgi_64plus.S
 create mode 100644 arch/c6x/mm/Makefile
 create mode 100644 arch/c6x/mm/dma-coherent.c
 create mode 100644 arch/c6x/mm/init.c
 create mode 100644 arch/c6x/platforms/Kconfig
 create mode 100644 arch/c6x/platforms/Makefile
 create mode 100644 arch/c6x/platforms/cache.c
 create mode 100644 arch/c6x/platforms/emif.c
 create mode 100644 arch/c6x/platforms/megamod-pic.c
 create mode 100644 arch/c6x/platforms/megamod-pic.h
 create mode 100644 arch/c6x/platforms/platform.c
 create mode 100644 arch/c6x/platforms/pll.c
 create mode 100644 arch/c6x/platforms/plldata.c
 create mode 100644 arch/c6x/platforms/psc.c
 create mode 100644 arch/c6x/platforms/psc.h
 create mode 100644 arch/c6x/platforms/soc-6455.c
 create mode 100644 arch/c6x/platforms/soc-6457.c
 create mode 100644 arch/c6x/platforms/soc-6472.c
 create mode 100644 arch/c6x/platforms/soc-6474.c
 create mode 100644 arch/c6x/platforms/timer64.c
 create mode 100644 arch/c6x/platforms/timer64.h

-- 
1.7.6

