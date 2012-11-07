Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab2KGJsO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 04:48:14 -0500
Received: from us02smtp1.synopsys.com ([198.182.60.75]:52580 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab2KGJsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 04:48:11 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, arnd@arndb.de,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC Patch v1 00/31] Synopsys ARC Linux kernel Port
Date: Wed,  7 Nov 2012 10:47:23 +0100
Message-Id: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset based off-of 3.7-rc3, introduces the Linux kernel port to
ARC700 processor family (750D and 770D) from Synopsys.

ARC700 is highly configurable and power efficient 32-bit RISC core with MMU.
It is embedded in SoCs deployed in TV Set Top boxes, Digital Media Players,
all the way to Network-on-Chips.

More information is available @
    http://www.synopsys.com/IP/ProcessorIP/ARCProcessors/Pages/default.aspx

This series is part #1 of the entire port - just enough to build the kernel
and bring up a Busybox shell on console (on ARCAngel4 FPGA ref platform)
The console driver has already been accepted/merged into tty-next tree for 3.8

The part #2 series containing additional features ptrace/SMP/perf/OProfile..
will follow as we move along the review cycle. It has been withheld just to
make it easier for reviewers.

The entire series however is available at
    git://github.com/foss-for-synopsys-dwc-arc-processors/linux.git arc-3.7-rc3

The GNU tool-chain, based off of gcc 4.4  + uClibc 0.9.30.3 is also available
from github. Please refer to Readme.md in "toolchain" repository also in same
hierarchy as kernel above.

We are already working on a buildroot based distro, to be made available soon.

More info about the kernel port can also be found in the ELCE-Barclone '12
talk on same topic.

    https://raw.github.com/vineetgarc/publish/master/ELCE-2012-ARC-Linux.pdf

All comments/criticisms are welcome !

P.S. Despite 3.7 based, we are still short of the UAPI split for arch headers.
That is also being worked upon with help from David. That will show up in v2
of the patchseries.

Thx,
-Vineet

Vineet Gupta (31):
  ARC: Generic Headers
  ARC: irqflags
  ARC: atomic/bitops/cmpxchg/barriers
  asm-generic headers: uaccess.h to conditionally define segment_eq()
  ARC: uaccess friends
  asm-generic headers: Allow yet more arch overrides in checksum.h
  ARC: checksum/byteorder/swab routines
  ARC: Fundamental ARCH data-types/defines
  ARC: spinlock/rwlock/mutex primitives
  ARC: string library
  ARC: Low level IRQ/Trap/Exception(non-MMU) Handling
  ARC: Interrupt Handling
  ARC: Non-MMU Exception Handling
  ARC: syscall support
  ARC: Process/scheduling/clock/Timers/Delay Management
  ARC: Signal handling
  ARC: Cache Flush Management
  ARC: Page Table Management
  ARC: MMU Context Management
  ARC: MMU Exception Handling
  ARC: TLB flush Handling
  ARC: Page Fault handling (incl uaccess fixup)
  ARC: I/O and DMA Mappings
  ARC: startup #1: low-level, setup_arch(), /proc/cpuinfo, mem init
  ARC: [plat-arcfpga] Hooking up platform to ARC UART
  ARC: Build system: Makefiles, Kconfig, Linker script
  ARC: Last bits (stubs) to get to a running kernel with UART
  ARC: split ret_from_fork, simplify kernel_thread()
  ARC: switch to generic kernel_thread()
  ARC: switch to generic kernel_execve() and sys_execve()
  ARC: [plat-arcfpga] defconfig

 arch/arc/Kbuild                               |    2 +
 arch/arc/Kconfig                              |  338 ++++++++++
 arch/arc/Kconfig.debug                        |   34 +
 arch/arc/Makefile                             |  115 ++++
 arch/arc/boot/Makefile                        |   27 +
 arch/arc/configs/fpga_defconfig               |  607 ++++++++++++++++++
 arch/arc/include/asm/Kbuild                   |   58 ++
 arch/arc/include/asm/arcregs.h                |  330 ++++++++++
 arch/arc/include/asm/asm-offsets.h            |    9 +
 arch/arc/include/asm/atomic.h                 |  232 +++++++
 arch/arc/include/asm/barrier.h                |   42 ++
 arch/arc/include/asm/bitops.h                 |  507 +++++++++++++++
 arch/arc/include/asm/bug.h                    |   37 ++
 arch/arc/include/asm/byteorder.h              |   18 +
 arch/arc/include/asm/cache.h                  |   75 +++
 arch/arc/include/asm/cachectl.h               |   30 +
 arch/arc/include/asm/cacheflush.h             |   67 ++
 arch/arc/include/asm/checksum.h               |  101 +++
 arch/arc/include/asm/cmpxchg.h                |  143 +++++
 arch/arc/include/asm/delay.h                  |   68 ++
 arch/arc/include/asm/dma-mapping.h            |  176 ++++++
 arch/arc/include/asm/dma.h                    |   14 +
 arch/arc/include/asm/elf.h                    |   97 +++
 arch/arc/include/asm/entry.h                  |  495 +++++++++++++++
 arch/arc/include/asm/exec.h                   |   15 +
 arch/arc/include/asm/io.h                     |   26 +
 arch/arc/include/asm/irq.h                    |   26 +
 arch/arc/include/asm/irqflags.h               |  143 +++++
 arch/arc/include/asm/kdebug.h                 |   19 +
 arch/arc/include/asm/linkage.h                |   30 +
 arch/arc/include/asm/mmu.h                    |   23 +
 arch/arc/include/asm/mmu_context.h            |  209 ++++++
 arch/arc/include/asm/module.h                 |   17 +
 arch/arc/include/asm/mutex.h                  |    9 +
 arch/arc/include/asm/page.h                   |  134 ++++
 arch/arc/include/asm/pgalloc.h                |  134 ++++
 arch/arc/include/asm/pgtable.h                |  401 ++++++++++++
 arch/arc/include/asm/processor.h              |  146 +++++
 arch/arc/include/asm/ptrace.h                 |  133 ++++
 arch/arc/include/asm/sections.h               |   17 +
 arch/arc/include/asm/segment.h                |   24 +
 arch/arc/include/asm/setup.h                  |   22 +
 arch/arc/include/asm/sigcontext.h             |   23 +
 arch/arc/include/asm/signal.h                 |   27 +
 arch/arc/include/asm/smp.h                    |   34 +
 arch/arc/include/asm/spinlock.h               |  144 +++++
 arch/arc/include/asm/spinlock_types.h         |   35 +
 arch/arc/include/asm/string.h                 |   40 ++
 arch/arc/include/asm/swab.h                   |   99 +++
 arch/arc/include/asm/switch_to.h              |   41 ++
 arch/arc/include/asm/syscall.h                |   72 +++
 arch/arc/include/asm/syscalls.h               |   30 +
 arch/arc/include/asm/thread_info.h            |  120 ++++
 arch/arc/include/asm/timex.h                  |   18 +
 arch/arc/include/asm/tlb-mmu1.h               |  104 +++
 arch/arc/include/asm/tlb.h                    |   58 ++
 arch/arc/include/asm/tlbflush.h               |   28 +
 arch/arc/include/asm/uaccess.h                |  605 ++++++++++++++++++
 arch/arc/include/asm/unistd.h                 |   46 ++
 arch/arc/include/asm/vmlinux.lds.h            |   12 +
 arch/arc/kernel/Makefile                      |   16 +
 arch/arc/kernel/arcksyms.c                    |   56 ++
 arch/arc/kernel/asm-offsets.c                 |   46 ++
 arch/arc/kernel/ctx_sw.c                      |   91 +++
 arch/arc/kernel/ctx_sw_asm.S                  |   58 ++
 arch/arc/kernel/entry.S                       |  635 +++++++++++++++++++
 arch/arc/kernel/fpu.c                         |   55 ++
 arch/arc/kernel/head.S                        |   78 +++
 arch/arc/kernel/irq.c                         |  107 ++++
 arch/arc/kernel/process.c                     |  259 ++++++++
 arch/arc/kernel/ptrace.c                      |   26 +
 arch/arc/kernel/reset.c                       |   33 +
 arch/arc/kernel/setup.c                       |  166 +++++
 arch/arc/kernel/signal.c                      |  360 +++++++++++
 arch/arc/kernel/stacktrace.c                  |   43 ++
 arch/arc/kernel/sys.c                         |   18 +
 arch/arc/kernel/time.c                        |  237 +++++++
 arch/arc/kernel/traps.c                       |  125 ++++
 arch/arc/kernel/troubleshoot.c                |   17 +
 arch/arc/kernel/vmlinux.lds.S                 |  117 ++++
 arch/arc/lib/Makefile                         |    9 +
 arch/arc/lib/memcmp.S                         |  124 ++++
 arch/arc/lib/memcpy-700.S                     |   66 ++
 arch/arc/lib/memset.S                         |   59 ++
 arch/arc/lib/strchr-700.S                     |  123 ++++
 arch/arc/lib/strcmp.S                         |   96 +++
 arch/arc/lib/strcpy-700.S                     |   70 ++
 arch/arc/lib/strlen.S                         |   83 +++
 arch/arc/mm/Makefile                          |   10 +
 arch/arc/mm/cache_arc700.c                    |  838 +++++++++++++++++++++++++
 arch/arc/mm/dma.c                             |   91 +++
 arch/arc/mm/extable.c                         |   26 +
 arch/arc/mm/fault.c                           |  228 +++++++
 arch/arc/mm/init.c                            |  185 ++++++
 arch/arc/mm/ioremap.c                         |   62 ++
 arch/arc/mm/mmap.c                            |   21 +
 arch/arc/mm/tlb.c                             |  586 +++++++++++++++++
 arch/arc/mm/tlbex.S                           |  351 +++++++++++
 arch/arc/plat-arcfpga/Kconfig                 |   33 +
 arch/arc/plat-arcfpga/Makefile                |    9 +
 arch/arc/plat-arcfpga/include/plat/dma_addr.h |   45 ++
 arch/arc/plat-arcfpga/include/plat/irq.h      |   27 +
 arch/arc/plat-arcfpga/include/plat/memmap.h   |   31 +
 arch/arc/plat-arcfpga/irq.c                   |   41 ++
 arch/arc/plat-arcfpga/platform.c              |  134 ++++
 include/asm-generic/checksum.h                |    4 +
 include/asm-generic/uaccess.h                 |    3 +-
 lib/checksum.c                                |    2 +
 108 files changed, 12585 insertions(+), 1 deletions(-)
 create mode 100644 arch/arc/Kbuild
 create mode 100644 arch/arc/Kconfig
 create mode 100644 arch/arc/Kconfig.debug
 create mode 100644 arch/arc/Makefile
 create mode 100644 arch/arc/boot/Makefile
 create mode 100644 arch/arc/configs/fpga_defconfig
 create mode 100644 arch/arc/include/asm/Kbuild
 create mode 100644 arch/arc/include/asm/arcregs.h
 create mode 100644 arch/arc/include/asm/asm-offsets.h
 create mode 100644 arch/arc/include/asm/atomic.h
 create mode 100644 arch/arc/include/asm/barrier.h
 create mode 100644 arch/arc/include/asm/bitops.h
 create mode 100644 arch/arc/include/asm/bug.h
 create mode 100644 arch/arc/include/asm/byteorder.h
 create mode 100644 arch/arc/include/asm/cache.h
 create mode 100644 arch/arc/include/asm/cachectl.h
 create mode 100644 arch/arc/include/asm/cacheflush.h
 create mode 100644 arch/arc/include/asm/checksum.h
 create mode 100644 arch/arc/include/asm/cmpxchg.h
 create mode 100644 arch/arc/include/asm/delay.h
 create mode 100644 arch/arc/include/asm/dma-mapping.h
 create mode 100644 arch/arc/include/asm/dma.h
 create mode 100644 arch/arc/include/asm/elf.h
 create mode 100644 arch/arc/include/asm/entry.h
 create mode 100644 arch/arc/include/asm/exec.h
 create mode 100644 arch/arc/include/asm/io.h
 create mode 100644 arch/arc/include/asm/irq.h
 create mode 100644 arch/arc/include/asm/irqflags.h
 create mode 100644 arch/arc/include/asm/kdebug.h
 create mode 100644 arch/arc/include/asm/linkage.h
 create mode 100644 arch/arc/include/asm/mmu.h
 create mode 100644 arch/arc/include/asm/mmu_context.h
 create mode 100644 arch/arc/include/asm/module.h
 create mode 100644 arch/arc/include/asm/mutex.h
 create mode 100644 arch/arc/include/asm/page.h
 create mode 100644 arch/arc/include/asm/pgalloc.h
 create mode 100644 arch/arc/include/asm/pgtable.h
 create mode 100644 arch/arc/include/asm/processor.h
 create mode 100644 arch/arc/include/asm/ptrace.h
 create mode 100644 arch/arc/include/asm/sections.h
 create mode 100644 arch/arc/include/asm/segment.h
 create mode 100644 arch/arc/include/asm/setup.h
 create mode 100644 arch/arc/include/asm/sigcontext.h
 create mode 100644 arch/arc/include/asm/signal.h
 create mode 100644 arch/arc/include/asm/smp.h
 create mode 100644 arch/arc/include/asm/spinlock.h
 create mode 100644 arch/arc/include/asm/spinlock_types.h
 create mode 100644 arch/arc/include/asm/string.h
 create mode 100644 arch/arc/include/asm/swab.h
 create mode 100644 arch/arc/include/asm/switch_to.h
 create mode 100644 arch/arc/include/asm/syscall.h
 create mode 100644 arch/arc/include/asm/syscalls.h
 create mode 100644 arch/arc/include/asm/thread_info.h
 create mode 100644 arch/arc/include/asm/timex.h
 create mode 100644 arch/arc/include/asm/tlb-mmu1.h
 create mode 100644 arch/arc/include/asm/tlb.h
 create mode 100644 arch/arc/include/asm/tlbflush.h
 create mode 100644 arch/arc/include/asm/uaccess.h
 create mode 100644 arch/arc/include/asm/unistd.h
 create mode 100644 arch/arc/include/asm/vmlinux.lds.h
 create mode 100644 arch/arc/kernel/Makefile
 create mode 100644 arch/arc/kernel/arcksyms.c
 create mode 100644 arch/arc/kernel/asm-offsets.c
 create mode 100644 arch/arc/kernel/ctx_sw.c
 create mode 100644 arch/arc/kernel/ctx_sw_asm.S
 create mode 100644 arch/arc/kernel/entry.S
 create mode 100644 arch/arc/kernel/fpu.c
 create mode 100644 arch/arc/kernel/head.S
 create mode 100644 arch/arc/kernel/irq.c
 create mode 100644 arch/arc/kernel/process.c
 create mode 100644 arch/arc/kernel/ptrace.c
 create mode 100644 arch/arc/kernel/reset.c
 create mode 100644 arch/arc/kernel/setup.c
 create mode 100644 arch/arc/kernel/signal.c
 create mode 100644 arch/arc/kernel/stacktrace.c
 create mode 100644 arch/arc/kernel/sys.c
 create mode 100644 arch/arc/kernel/time.c
 create mode 100644 arch/arc/kernel/traps.c
 create mode 100644 arch/arc/kernel/troubleshoot.c
 create mode 100644 arch/arc/kernel/vmlinux.lds.S
 create mode 100644 arch/arc/lib/Makefile
 create mode 100644 arch/arc/lib/memcmp.S
 create mode 100644 arch/arc/lib/memcpy-700.S
 create mode 100644 arch/arc/lib/memset.S
 create mode 100644 arch/arc/lib/strchr-700.S
 create mode 100644 arch/arc/lib/strcmp.S
 create mode 100644 arch/arc/lib/strcpy-700.S
 create mode 100644 arch/arc/lib/strlen.S
 create mode 100644 arch/arc/mm/Makefile
 create mode 100644 arch/arc/mm/cache_arc700.c
 create mode 100644 arch/arc/mm/dma.c
 create mode 100644 arch/arc/mm/extable.c
 create mode 100644 arch/arc/mm/fault.c
 create mode 100644 arch/arc/mm/init.c
 create mode 100644 arch/arc/mm/ioremap.c
 create mode 100644 arch/arc/mm/mmap.c
 create mode 100644 arch/arc/mm/tlb.c
 create mode 100644 arch/arc/mm/tlbex.S
 create mode 100644 arch/arc/plat-arcfpga/Kconfig
 create mode 100644 arch/arc/plat-arcfpga/Makefile
 create mode 100644 arch/arc/plat-arcfpga/include/plat/dma_addr.h
 create mode 100644 arch/arc/plat-arcfpga/include/plat/irq.h
 create mode 100644 arch/arc/plat-arcfpga/include/plat/memmap.h
 create mode 100644 arch/arc/plat-arcfpga/irq.c
 create mode 100644 arch/arc/plat-arcfpga/platform.c

-- 
1.7.4.1

