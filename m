Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965Ab1GWIEG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 04:04:06 -0400
Received: from mail.southpole.se ([193.12.106.18]:33016 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab1GWIDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 04:03:46 -0400
Subject: [GIT PULL] OpenRISC architecture
From: Jonas Bonn <jonas@southpole.se>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: South Pole Consulting AB
Date: Sat, 23 Jul 2011 10:03:43 +0200
Message-ID: <1311408223.3499.13.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull this port of Linux to the OpenRISC architecture, available
in the 'for-upstream' branch at:

git://openrisc.net/jonas/linux

The OpenRISC architecture was conceived with the idea of creating a CPU
with an open specification and freely licensed implementations thereof.
The OR1200 implementation of the OpenRISC 1000 architecture is LGPL
licensed, runs on FPGA's from a broad number of vendors, and is
currently being used in a number of successful industrial projects.

A product of OpenCores.org, development of the OpenRISC architecture has
unfortunately languished for a while buried amongst a multitude of other
projects.  Recently, however, a renewed effort to lift the CPU project
out of its doldrums was initiated by the OpenCores.org management and a
community of participants consisting of both commercial and independent
contributors has rapidly taken shape around this effort.  The project
now lives (at least temporarily) at http://openrisc.net where it can get
the attention it needs.  The active development community around this
architecture has grown from roughly 5 to 25 developers in the last year
and we are looking forward to seeing what may emerge as the community
grows and this CPU architecture is allowed to be developed truly in the
open.

We have been tracking upstream Linux with our port since 2.6.35.
Tracking upstream has been mostly painless as the changes that require
architecture modifications are pretty easy to spot with git.  That said,
we want to be "upstream!"

So here's our code.  The patches in this branch implement support for
the OpenRISC architecture on Linux.  The patch series is broken into
functional units that have been through several rounds of review on
LKML.

The implementation for the OpenRISC support isn't huge:

82 files changed, 10914 insertions(+), 0 deletions(-)

We've tried to do things following as modern an approach as we could.
That includes using device trees for platform descriptions and using as
many asm-generic headers as possible.  We even got a couple of cleanups
into asm-generic along the way to make things even tidier.

We are excited by the prospect of getting our work upstream and we are
excited by this opportunity to bring the OpenRISC architecture to the
attention of a larger audience.

/Jonas

--

NOTE:  This pull depends on a patch "modules: add default loader hook
implementations" in Rusty's tree... without that, the OpenRISC arch will
not build.  Note also that there are a couple of patches that touch
asm-generic bits at the base of the branch, including a patch from
Andrew that was moved to this branch to avoid a merge conflict.

The following changes since commit
b0af8dfdd67699e25083478c63eedef2e72ebd85:

  Linux 3.0-rc5 (2011-06-27 19:12:22 -0700)

are available in the git repository at:
  git://openrisc.net/jonas/linux for-upstream

Andrew Morton (1):
      asm-generic: delay.h fix udelay and ndelay for 8 bit args

Jonas Bonn (23):
      asm-generic: adapt delay.h to common implementation
      asm-generic: move archictures to common delay.h
      asm-generic: add MMU variants of io.h functions
      iomap: make IOPORT/PCI mapping functions conditional
      OpenRISC: Boot code
      OpenRISC: Device tree
      OpenRISC: Memory management
      OpenRISC: Signal handling
      OpenRISC: Build infrastructure
      OpenRISC: PTrace
      OpenRISC: DMA
      OpenRISC: Timekeeping
      OpenRISC: IRQ
      OpenRISC: System calls
      OpenRISC: Idle/Power management
      OpenRISC: Scheduling/Process management
      OpenRISC: GPIO
      OpenRISC: Module support
      OpenRISC: Traps
      OpenRISC: Headers
      OpenRISC: Library routines
      OpenRISC: Miscellaneous
      OpenRISC: Add MAINTAINERS entry

 MAINTAINERS                              |    8 +
 arch/avr32/include/asm/delay.h           |   27 +-
 arch/m32r/include/asm/delay.h            |   27 +-
 arch/openrisc/Kconfig                    |  207 ++++
 arch/openrisc/Makefile                   |   55 +
 arch/openrisc/README.openrisc            |   99 ++
 arch/openrisc/TODO.openrisc              |   16 +
 arch/openrisc/boot/Makefile              |   15 +
 arch/openrisc/boot/dts/or1ksim.dts       |   50 +
 arch/openrisc/configs/or1ksim_defconfig  |   65 ++
 arch/openrisc/include/asm/Kbuild         |   64 ++
 arch/openrisc/include/asm/asm-offsets.h  |    1 +
 arch/openrisc/include/asm/bitops.h       |   59 ++
 arch/openrisc/include/asm/bitops/__ffs.h |   33 +
 arch/openrisc/include/asm/bitops/__fls.h |   33 +
 arch/openrisc/include/asm/bitops/ffs.h   |   32 +
 arch/openrisc/include/asm/bitops/fls.h   |   33 +
 arch/openrisc/include/asm/byteorder.h    |    1 +
 arch/openrisc/include/asm/cache.h        |   29 +
 arch/openrisc/include/asm/cpuinfo.h      |   34 +
 arch/openrisc/include/asm/delay.h        |   24 +
 arch/openrisc/include/asm/dma-mapping.h  |  134 +++
 arch/openrisc/include/asm/elf.h          |  108 ++
 arch/openrisc/include/asm/fixmap.h       |   87 ++
 arch/openrisc/include/asm/gpio.h         |   65 ++
 arch/openrisc/include/asm/io.h           |   51 +
 arch/openrisc/include/asm/irq.h          |   27 +
 arch/openrisc/include/asm/irqflags.h     |   29 +
 arch/openrisc/include/asm/linkage.h      |   25 +
 arch/openrisc/include/asm/memblock.h     |   24 +
 arch/openrisc/include/asm/mmu.h          |   26 +
 arch/openrisc/include/asm/mmu_context.h  |   43 +
 arch/openrisc/include/asm/mutex.h        |   27 +
 arch/openrisc/include/asm/page.h         |  110 ++
 arch/openrisc/include/asm/param.h        |   26 +
 arch/openrisc/include/asm/pgalloc.h      |  102 ++
 arch/openrisc/include/asm/pgtable.h      |  463 +++++++++
 arch/openrisc/include/asm/processor.h    |  113 +++
 arch/openrisc/include/asm/prom.h         |   77 ++
 arch/openrisc/include/asm/ptrace.h       |  131 +++
 arch/openrisc/include/asm/serial.h       |   36 +
 arch/openrisc/include/asm/sigcontext.h   |   38 +
 arch/openrisc/include/asm/spinlock.h     |   24 +
 arch/openrisc/include/asm/spr.h          |   42 +
 arch/openrisc/include/asm/spr_defs.h     |  604 +++++++++++
 arch/openrisc/include/asm/syscall.h      |   77 ++
 arch/openrisc/include/asm/syscalls.h     |   27 +
 arch/openrisc/include/asm/system.h       |   35 +
 arch/openrisc/include/asm/thread_info.h  |  134 +++
 arch/openrisc/include/asm/timex.h        |   36 +
 arch/openrisc/include/asm/tlb.h          |   34 +
 arch/openrisc/include/asm/tlbflush.h     |   55 +
 arch/openrisc/include/asm/uaccess.h      |  355 +++++++
 arch/openrisc/include/asm/unaligned.h    |   51 +
 arch/openrisc/include/asm/unistd.h       |   31 +
 arch/openrisc/kernel/Makefile            |   14 +
 arch/openrisc/kernel/asm-offsets.c       |   70 ++
 arch/openrisc/kernel/dma.c               |  191 ++++
 arch/openrisc/kernel/entry.S             | 1128 +++++++++++++++++++++
 arch/openrisc/kernel/head.S              | 1607
++++++++++++++++++++++++++++++
 arch/openrisc/kernel/idle.c              |   77 ++
 arch/openrisc/kernel/init_task.c         |   41 +
 arch/openrisc/kernel/irq.c               |  172 ++++
 arch/openrisc/kernel/module.c            |   72 ++
 arch/openrisc/kernel/or32_ksyms.c        |   46 +
 arch/openrisc/kernel/process.c           |  311 ++++++
 arch/openrisc/kernel/prom.c              |  108 ++
 arch/openrisc/kernel/ptrace.c            |  211 ++++
 arch/openrisc/kernel/setup.c             |  381 +++++++
 arch/openrisc/kernel/signal.c            |  396 ++++++++
 arch/openrisc/kernel/sys_call_table.c    |   28 +
 arch/openrisc/kernel/sys_or32.c          |   57 ++
 arch/openrisc/kernel/time.c              |  181 ++++
 arch/openrisc/kernel/traps.c             |  366 +++++++
 arch/openrisc/kernel/vmlinux.h           |   12 +
 arch/openrisc/kernel/vmlinux.lds.S       |  115 +++
 arch/openrisc/lib/Makefile               |    5 +
 arch/openrisc/lib/delay.c                |   60 ++
 arch/openrisc/lib/string.S               |  204 ++++
 arch/openrisc/mm/Makefile                |    5 +
 arch/openrisc/mm/fault.c                 |  338 +++++++
 arch/openrisc/mm/init.c                  |  283 ++++++
 arch/openrisc/mm/ioremap.c               |  137 +++
 arch/openrisc/mm/tlb.c                   |  193 ++++
 arch/sh/include/asm/delay.h              |   27 +-
 arch/x86/include/asm/delay.h             |   25 +-
 include/asm-generic/delay.h              |   37 +-
 include/asm-generic/io.h                 |    9 +-
 include/asm-generic/iomap.h              |    4 +
 lib/iomap.c                              |    4 +
 90 files changed, 10970 insertions(+), 104 deletions(-)
 create mode 100644 arch/openrisc/Kconfig
 create mode 100644 arch/openrisc/Makefile
 create mode 100644 arch/openrisc/README.openrisc
 create mode 100644 arch/openrisc/TODO.openrisc
 create mode 100644 arch/openrisc/boot/Makefile
 create mode 100644 arch/openrisc/boot/dts/or1ksim.dts
 create mode 100644 arch/openrisc/configs/or1ksim_defconfig
 create mode 100644 arch/openrisc/include/asm/Kbuild
 create mode 100644 arch/openrisc/include/asm/asm-offsets.h
 create mode 100644 arch/openrisc/include/asm/bitops.h
 create mode 100644 arch/openrisc/include/asm/bitops/__ffs.h
 create mode 100644 arch/openrisc/include/asm/bitops/__fls.h
 create mode 100644 arch/openrisc/include/asm/bitops/ffs.h
 create mode 100644 arch/openrisc/include/asm/bitops/fls.h
 create mode 100644 arch/openrisc/include/asm/byteorder.h
 create mode 100644 arch/openrisc/include/asm/cache.h
 create mode 100644 arch/openrisc/include/asm/cpuinfo.h
 create mode 100644 arch/openrisc/include/asm/delay.h
 create mode 100644 arch/openrisc/include/asm/dma-mapping.h
 create mode 100644 arch/openrisc/include/asm/elf.h
 create mode 100644 arch/openrisc/include/asm/fixmap.h
 create mode 100644 arch/openrisc/include/asm/gpio.h
 create mode 100644 arch/openrisc/include/asm/io.h
 create mode 100644 arch/openrisc/include/asm/irq.h
 create mode 100644 arch/openrisc/include/asm/irqflags.h
 create mode 100644 arch/openrisc/include/asm/linkage.h
 create mode 100644 arch/openrisc/include/asm/memblock.h
 create mode 100644 arch/openrisc/include/asm/mmu.h
 create mode 100644 arch/openrisc/include/asm/mmu_context.h
 create mode 100644 arch/openrisc/include/asm/mutex.h
 create mode 100644 arch/openrisc/include/asm/page.h
 create mode 100644 arch/openrisc/include/asm/param.h
 create mode 100644 arch/openrisc/include/asm/pgalloc.h
 create mode 100644 arch/openrisc/include/asm/pgtable.h
 create mode 100644 arch/openrisc/include/asm/processor.h
 create mode 100644 arch/openrisc/include/asm/prom.h
 create mode 100644 arch/openrisc/include/asm/ptrace.h
 create mode 100644 arch/openrisc/include/asm/serial.h
 create mode 100644 arch/openrisc/include/asm/sigcontext.h
 create mode 100644 arch/openrisc/include/asm/spinlock.h
 create mode 100644 arch/openrisc/include/asm/spr.h
 create mode 100644 arch/openrisc/include/asm/spr_defs.h
 create mode 100644 arch/openrisc/include/asm/syscall.h
 create mode 100644 arch/openrisc/include/asm/syscalls.h
 create mode 100644 arch/openrisc/include/asm/system.h
 create mode 100644 arch/openrisc/include/asm/thread_info.h
 create mode 100644 arch/openrisc/include/asm/timex.h
 create mode 100644 arch/openrisc/include/asm/tlb.h
 create mode 100644 arch/openrisc/include/asm/tlbflush.h
 create mode 100644 arch/openrisc/include/asm/uaccess.h
 create mode 100644 arch/openrisc/include/asm/unaligned.h
 create mode 100644 arch/openrisc/include/asm/unistd.h
 create mode 100644 arch/openrisc/kernel/Makefile
 create mode 100644 arch/openrisc/kernel/asm-offsets.c
 create mode 100644 arch/openrisc/kernel/dma.c
 create mode 100644 arch/openrisc/kernel/entry.S
 create mode 100644 arch/openrisc/kernel/head.S
 create mode 100644 arch/openrisc/kernel/idle.c
 create mode 100644 arch/openrisc/kernel/init_task.c
 create mode 100644 arch/openrisc/kernel/irq.c
 create mode 100644 arch/openrisc/kernel/module.c
 create mode 100644 arch/openrisc/kernel/or32_ksyms.c
 create mode 100644 arch/openrisc/kernel/process.c
 create mode 100644 arch/openrisc/kernel/prom.c
 create mode 100644 arch/openrisc/kernel/ptrace.c
 create mode 100644 arch/openrisc/kernel/setup.c
 create mode 100644 arch/openrisc/kernel/signal.c
 create mode 100644 arch/openrisc/kernel/sys_call_table.c
 create mode 100644 arch/openrisc/kernel/sys_or32.c
 create mode 100644 arch/openrisc/kernel/time.c
 create mode 100644 arch/openrisc/kernel/traps.c
 create mode 100644 arch/openrisc/kernel/vmlinux.h
 create mode 100644 arch/openrisc/kernel/vmlinux.lds.S
 create mode 100644 arch/openrisc/lib/Makefile
 create mode 100644 arch/openrisc/lib/delay.c
 create mode 100644 arch/openrisc/lib/string.S
 create mode 100644 arch/openrisc/mm/Makefile
 create mode 100644 arch/openrisc/mm/fault.c
 create mode 100644 arch/openrisc/mm/init.c
 create mode 100644 arch/openrisc/mm/ioremap.c
 create mode 100644 arch/openrisc/mm/tlb.c

