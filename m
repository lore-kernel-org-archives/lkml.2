Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933132Ab1IQAro (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 20:47:44 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62417 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933061Ab1IQArW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 20:47:22 -0400
Message-Id: <093448$3hsu0o@wolverine01.qualcomm.com>
X-IronPort-AV: E=McAfee;i="5400,1158,6471"; a="119437336"
From: Richard Kuo <rkuo@codeaurora.org>
Date: Fri, 16 Sep 2011 19:34:55 -0500
Subject: [PATCH v4 00/36] Hexagon: Add support for Qualcomm Hexagon architecture
To: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the fourth version of the patchset to the Linux kernel to support
the Qualcomm Hexagon architecture.  These patches have been organized like
previously in a somewhat logically grouped fashion.

A brief summary of changes from the last patchset:
* changes associated with removing pt_regs from user_context
* removal of arch-specific ptrace cases; use generic ptrace_request
* turn on CONFIG_ARCH_TRACEHOOKS
* removal of deprecated sigframe
* add magic values for libgcc signal stack unwinding
* add memory clobber to IO inlines
* use generic show_interrupts
* minor timer cleanup
* minor SMP IPI cleanup
* moved local_irq_enable in do_page_fault

These patches are available on Code Aurora:

https://www.codeaurora.org/patches/quic/hlk/hexagon-linux-20110916/

Once again, thanks to everyone for their feedback!

-Richard Kuo


Richard Kuo (36):
  Hexagon: Add generic headers
  Hexagon: Core arch-specific header files
  Hexagon: Add bitops support
  Hexagon: Add atomic ops support
  Hexagon: Add syscalls
  Hexagon: Add processor and system headers
  Hexagon: Add threadinfo
  Hexagon: Add delay functions
  Hexagon: Add checksum functions
  Hexagon: Add memcpy and memset accelerated functions
  Hexagon: Add hypervisor interface
  Hexagon: Export ksyms defined in assembly files.
  Hexagon: Support dynamic module loading.
  Hexagon: Add signal functions
  Hexagon: Add init_task and process functions
  Hexagon: Add startup code
  Hexagon: Add interrupts
  Hexagon: Add time and timer functions
  Hexagon: Add ptrace support
  Hexagon: Provide basic debugging and system trap support.
  Hexagon: Add SMP support
  Hexagon: Add locking types and functions
  Hexagon: Add user access functions
  Hexagon: Provide basic implementation and/or stubs for I/O routines.
  Hexagon: Implement basic cache-flush support
  Hexagon: Implement basic TLB management routines for Hexagon.
  Hexagon: Provide DMA implementation
  Hexagon: Add ioremap support
  Hexagon: Add page table header files & etc.
  Hexagon: Add page-fault support.
  Hexagon: kgdb support files
  Hexagon: Comet platform support
  Hexagon: Add configuration and makefiles for the Hexagon
    architecture.
  Hexagon: Add basic stacktrace functionality for Hexagon architecture.
  Hexagon: Add self to MAINTAINERS
  Add extra arch overrides to asm-generic/checksum.h

 MAINTAINERS                               |    6 +
 arch/hexagon/Kconfig                      |  220 ++++++++++++
 arch/hexagon/Makefile                     |   59 +++
 arch/hexagon/configs/comet_defconfig      |   85 +++++
 arch/hexagon/include/asm/Kbuild           |   60 ++++
 arch/hexagon/include/asm/asm-offsets.h    |    1 +
 arch/hexagon/include/asm/atomic.h         |  164 +++++++++
 arch/hexagon/include/asm/bitops.h         |  301 ++++++++++++++++
 arch/hexagon/include/asm/bitsperlong.h    |   26 ++
 arch/hexagon/include/asm/byteorder.h      |   28 ++
 arch/hexagon/include/asm/cache.h          |   34 ++
 arch/hexagon/include/asm/cacheflush.h     |   99 ++++++
 arch/hexagon/include/asm/checksum.h       |   50 +++
 arch/hexagon/include/asm/delay.h          |   28 ++
 arch/hexagon/include/asm/dma-mapping.h    |  101 ++++++
 arch/hexagon/include/asm/dma.h            |   29 ++
 arch/hexagon/include/asm/elf.h            |  229 ++++++++++++
 arch/hexagon/include/asm/fixmap.h         |   73 ++++
 arch/hexagon/include/asm/fpu.h            |    4 +
 arch/hexagon/include/asm/futex.h          |  137 ++++++++
 arch/hexagon/include/asm/hexagon_vm.h     |  281 +++++++++++++++
 arch/hexagon/include/asm/intrinsics.h     |   26 ++
 arch/hexagon/include/asm/io.h             |  326 +++++++++++++++++
 arch/hexagon/include/asm/irq.h            |   36 ++
 arch/hexagon/include/asm/irqflags.h       |   62 ++++
 arch/hexagon/include/asm/kgdb.h           |   43 +++
 arch/hexagon/include/asm/linkage.h        |   25 ++
 arch/hexagon/include/asm/mem-layout.h     |  112 ++++++
 arch/hexagon/include/asm/mmu.h            |   37 ++
 arch/hexagon/include/asm/mmu_context.h    |  100 ++++++
 arch/hexagon/include/asm/module.h         |   26 ++
 arch/hexagon/include/asm/mutex.h          |    8 +
 arch/hexagon/include/asm/page.h           |  157 +++++++++
 arch/hexagon/include/asm/param.h          |   26 ++
 arch/hexagon/include/asm/perf_event.h     |   24 ++
 arch/hexagon/include/asm/pgalloc.h        |  146 ++++++++
 arch/hexagon/include/asm/pgtable.h        |  518 +++++++++++++++++++++++++++
 arch/hexagon/include/asm/processor.h      |  123 +++++++
 arch/hexagon/include/asm/ptrace.h         |   48 +++
 arch/hexagon/include/asm/registers.h      |  236 +++++++++++++
 arch/hexagon/include/asm/setup.h          |   29 ++
 arch/hexagon/include/asm/sigcontext.h     |   33 ++
 arch/hexagon/include/asm/signal.h         |   26 ++
 arch/hexagon/include/asm/smp.h            |   44 +++
 arch/hexagon/include/asm/spinlock.h       |  186 ++++++++++
 arch/hexagon/include/asm/spinlock_types.h |   42 +++
 arch/hexagon/include/asm/string.h         |   32 ++
 arch/hexagon/include/asm/suspend.h        |   27 ++
 arch/hexagon/include/asm/swab.h           |   24 ++
 arch/hexagon/include/asm/syscall.h        |   54 +++
 arch/hexagon/include/asm/system.h         |  126 +++++++
 arch/hexagon/include/asm/thread_info.h    |  154 ++++++++
 arch/hexagon/include/asm/time.h           |   29 ++
 arch/hexagon/include/asm/timer-regs.h     |   39 ++
 arch/hexagon/include/asm/timex.h          |   37 ++
 arch/hexagon/include/asm/tlb.h            |   39 ++
 arch/hexagon/include/asm/tlbflush.h       |   58 +++
 arch/hexagon/include/asm/traps.h          |   29 ++
 arch/hexagon/include/asm/uaccess.h        |  116 ++++++
 arch/hexagon/include/asm/unistd.h         |   36 ++
 arch/hexagon/include/asm/user.h           |   83 +++++
 arch/hexagon/include/asm/vdso.h           |   31 ++
 arch/hexagon/include/asm/vm_fault.h       |   26 ++
 arch/hexagon/include/asm/vm_mmu.h         |  111 ++++++
 arch/hexagon/kernel/Makefile              |   19 +
 arch/hexagon/kernel/asm-offsets.c         |  104 ++++++
 arch/hexagon/kernel/dma.c                 |  220 ++++++++++++
 arch/hexagon/kernel/head.S                |  162 +++++++++
 arch/hexagon/kernel/hexagon_ksyms.c       |   42 +++
 arch/hexagon/kernel/init_task.c           |   54 +++
 arch/hexagon/kernel/irq_cpu.c             |   90 +++++
 arch/hexagon/kernel/kgdb.c                |  247 +++++++++++++
 arch/hexagon/kernel/module.c              |  162 +++++++++
 arch/hexagon/kernel/process.c             |  279 +++++++++++++++
 arch/hexagon/kernel/ptrace.c              |  178 ++++++++++
 arch/hexagon/kernel/reset.c               |   38 ++
 arch/hexagon/kernel/setup.c               |  145 ++++++++
 arch/hexagon/kernel/signal.c              |  345 ++++++++++++++++++
 arch/hexagon/kernel/smp.c                 |  280 +++++++++++++++
 arch/hexagon/kernel/stacktrace.c          |   66 ++++
 arch/hexagon/kernel/syscall.c             |   90 +++++
 arch/hexagon/kernel/syscalltab.c          |   32 ++
 arch/hexagon/kernel/time.c                |  258 ++++++++++++++
 arch/hexagon/kernel/topology.c            |   52 +++
 arch/hexagon/kernel/trampoline.S          |   35 ++
 arch/hexagon/kernel/traps.c               |  370 ++++++++++++++++++++
 arch/hexagon/kernel/vdso.c                |  101 ++++++
 arch/hexagon/kernel/vm_entry.S            |  269 ++++++++++++++
 arch/hexagon/kernel/vm_events.c           |  101 ++++++
 arch/hexagon/kernel/vm_init_segtable.S    |  442 +++++++++++++++++++++++
 arch/hexagon/kernel/vm_ops.S              |  102 ++++++
 arch/hexagon/kernel/vm_switch.S           |   95 +++++
 arch/hexagon/kernel/vm_vectors.S          |   50 +++
 arch/hexagon/kernel/vmlinux.lds.S         |   93 +++++
 arch/hexagon/lib/Makefile                 |    4 +
 arch/hexagon/lib/checksum.c               |  203 +++++++++++
 arch/hexagon/lib/io.c                     |   91 +++++
 arch/hexagon/lib/memcpy.S                 |  543 +++++++++++++++++++++++++++++
 arch/hexagon/lib/memset.S                 |  316 +++++++++++++++++
 arch/hexagon/mm/Makefile                  |    7 +
 arch/hexagon/mm/cache.c                   |  128 +++++++
 arch/hexagon/mm/copy_from_user.S          |  114 ++++++
 arch/hexagon/mm/copy_to_user.S            |   92 +++++
 arch/hexagon/mm/copy_user_template.S      |  185 ++++++++++
 arch/hexagon/mm/init.c                    |  276 +++++++++++++++
 arch/hexagon/mm/ioremap.c                 |   56 +++
 arch/hexagon/mm/pgalloc.c                 |   25 ++
 arch/hexagon/mm/strnlen_user.S            |  140 ++++++++
 arch/hexagon/mm/uaccess.c                 |   59 +++
 arch/hexagon/mm/vm_fault.c                |  187 ++++++++++
 arch/hexagon/mm/vm_tlb.c                  |   93 +++++
 include/asm-generic/checksum.h            |    4 +
 include/asm-generic/rwsem.h               |  132 +++++++
 113 files changed, 12681 insertions(+), 0 deletions(-)
 create mode 100644 arch/hexagon/Kconfig
 create mode 100644 arch/hexagon/Makefile
 create mode 100644 arch/hexagon/configs/comet_defconfig
 create mode 100644 arch/hexagon/include/asm/Kbuild
 create mode 100644 arch/hexagon/include/asm/asm-offsets.h
 create mode 100644 arch/hexagon/include/asm/atomic.h
 create mode 100644 arch/hexagon/include/asm/bitops.h
 create mode 100644 arch/hexagon/include/asm/bitsperlong.h
 create mode 100644 arch/hexagon/include/asm/byteorder.h
 create mode 100644 arch/hexagon/include/asm/cache.h
 create mode 100644 arch/hexagon/include/asm/cacheflush.h
 create mode 100644 arch/hexagon/include/asm/checksum.h
 create mode 100644 arch/hexagon/include/asm/delay.h
 create mode 100644 arch/hexagon/include/asm/dma-mapping.h
 create mode 100644 arch/hexagon/include/asm/dma.h
 create mode 100644 arch/hexagon/include/asm/elf.h
 create mode 100644 arch/hexagon/include/asm/fixmap.h
 create mode 100644 arch/hexagon/include/asm/fpu.h
 create mode 100644 arch/hexagon/include/asm/futex.h
 create mode 100644 arch/hexagon/include/asm/hexagon_vm.h
 create mode 100644 arch/hexagon/include/asm/intrinsics.h
 create mode 100644 arch/hexagon/include/asm/io.h
 create mode 100644 arch/hexagon/include/asm/irq.h
 create mode 100644 arch/hexagon/include/asm/irqflags.h
 create mode 100644 arch/hexagon/include/asm/kgdb.h
 create mode 100644 arch/hexagon/include/asm/linkage.h
 create mode 100644 arch/hexagon/include/asm/mem-layout.h
 create mode 100644 arch/hexagon/include/asm/mmu.h
 create mode 100644 arch/hexagon/include/asm/mmu_context.h
 create mode 100644 arch/hexagon/include/asm/module.h
 create mode 100644 arch/hexagon/include/asm/mutex.h
 create mode 100644 arch/hexagon/include/asm/page.h
 create mode 100644 arch/hexagon/include/asm/param.h
 create mode 100644 arch/hexagon/include/asm/perf_event.h
 create mode 100644 arch/hexagon/include/asm/pgalloc.h
 create mode 100644 arch/hexagon/include/asm/pgtable.h
 create mode 100644 arch/hexagon/include/asm/processor.h
 create mode 100644 arch/hexagon/include/asm/ptrace.h
 create mode 100644 arch/hexagon/include/asm/registers.h
 create mode 100644 arch/hexagon/include/asm/setup.h
 create mode 100644 arch/hexagon/include/asm/sigcontext.h
 create mode 100644 arch/hexagon/include/asm/signal.h
 create mode 100644 arch/hexagon/include/asm/smp.h
 create mode 100644 arch/hexagon/include/asm/spinlock.h
 create mode 100644 arch/hexagon/include/asm/spinlock_types.h
 create mode 100644 arch/hexagon/include/asm/string.h
 create mode 100644 arch/hexagon/include/asm/suspend.h
 create mode 100644 arch/hexagon/include/asm/swab.h
 create mode 100644 arch/hexagon/include/asm/syscall.h
 create mode 100644 arch/hexagon/include/asm/system.h
 create mode 100644 arch/hexagon/include/asm/thread_info.h
 create mode 100644 arch/hexagon/include/asm/time.h
 create mode 100644 arch/hexagon/include/asm/timer-regs.h
 create mode 100644 arch/hexagon/include/asm/timex.h
 create mode 100644 arch/hexagon/include/asm/tlb.h
 create mode 100644 arch/hexagon/include/asm/tlbflush.h
 create mode 100644 arch/hexagon/include/asm/traps.h
 create mode 100644 arch/hexagon/include/asm/uaccess.h
 create mode 100644 arch/hexagon/include/asm/unistd.h
 create mode 100644 arch/hexagon/include/asm/user.h
 create mode 100644 arch/hexagon/include/asm/vdso.h
 create mode 100644 arch/hexagon/include/asm/vm_fault.h
 create mode 100644 arch/hexagon/include/asm/vm_mmu.h
 create mode 100644 arch/hexagon/kernel/Makefile
 create mode 100644 arch/hexagon/kernel/asm-offsets.c
 create mode 100644 arch/hexagon/kernel/dma.c
 create mode 100644 arch/hexagon/kernel/head.S
 create mode 100644 arch/hexagon/kernel/hexagon_ksyms.c
 create mode 100644 arch/hexagon/kernel/init_task.c
 create mode 100644 arch/hexagon/kernel/irq_cpu.c
 create mode 100644 arch/hexagon/kernel/kgdb.c
 create mode 100644 arch/hexagon/kernel/module.c
 create mode 100644 arch/hexagon/kernel/process.c
 create mode 100644 arch/hexagon/kernel/ptrace.c
 create mode 100644 arch/hexagon/kernel/reset.c
 create mode 100644 arch/hexagon/kernel/setup.c
 create mode 100644 arch/hexagon/kernel/signal.c
 create mode 100644 arch/hexagon/kernel/smp.c
 create mode 100644 arch/hexagon/kernel/stacktrace.c
 create mode 100644 arch/hexagon/kernel/syscall.c
 create mode 100644 arch/hexagon/kernel/syscalltab.c
 create mode 100644 arch/hexagon/kernel/time.c
 create mode 100644 arch/hexagon/kernel/topology.c
 create mode 100644 arch/hexagon/kernel/trampoline.S
 create mode 100644 arch/hexagon/kernel/traps.c
 create mode 100644 arch/hexagon/kernel/vdso.c
 create mode 100644 arch/hexagon/kernel/vm_entry.S
 create mode 100644 arch/hexagon/kernel/vm_events.c
 create mode 100644 arch/hexagon/kernel/vm_init_segtable.S
 create mode 100644 arch/hexagon/kernel/vm_ops.S
 create mode 100644 arch/hexagon/kernel/vm_switch.S
 create mode 100644 arch/hexagon/kernel/vm_vectors.S
 create mode 100644 arch/hexagon/kernel/vmlinux.lds.S
 create mode 100644 arch/hexagon/lib/Makefile
 create mode 100644 arch/hexagon/lib/checksum.c
 create mode 100644 arch/hexagon/lib/io.c
 create mode 100644 arch/hexagon/lib/memcpy.S
 create mode 100644 arch/hexagon/lib/memset.S
 create mode 100644 arch/hexagon/mm/Makefile
 create mode 100644 arch/hexagon/mm/cache.c
 create mode 100644 arch/hexagon/mm/copy_from_user.S
 create mode 100644 arch/hexagon/mm/copy_to_user.S
 create mode 100644 arch/hexagon/mm/copy_user_template.S
 create mode 100644 arch/hexagon/mm/init.c
 create mode 100644 arch/hexagon/mm/ioremap.c
 create mode 100644 arch/hexagon/mm/pgalloc.c
 create mode 100644 arch/hexagon/mm/strnlen_user.S
 create mode 100644 arch/hexagon/mm/uaccess.c
 create mode 100644 arch/hexagon/mm/vm_fault.c
 create mode 100644 arch/hexagon/mm/vm_tlb.c
 create mode 100644 include/asm-generic/rwsem.h


--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
