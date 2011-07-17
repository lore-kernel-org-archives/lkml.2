Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab1GQPJd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 11:09:33 -0400
Received: from mail.southpole.se ([193.12.106.18]:34883 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304Ab1GQPJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 11:09:30 -0400
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Jonas Bonn <jonas@southpole.se>
Subject: [PATCH v3 00/19] OpenRISC Architecture
Date: Sun, 17 Jul 2011 17:08:10 +0200
Message-Id: <cover.1310913472.git.jonas@southpole.se>
X-Mailer: git-send-email 1.7.4.1
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here's v3 of the OpenRISC architecture patch series.

The major changes since version 2 are:

i)  cleanup of the ptrace code

I've removed the single stepping code for now as I want to clean that up
separately.  Will resubmit that in 3.2.

Have implemented exporting of thread state to userspace via the GETREGSET
mechanism.  This allows us to keep the pt_regs structure opaque and allows
us to freely change the layout of the registers on the stack, which is
something that we will want to do in order to get better cache behaviour.

ii) rewrite of dma_alloc_consistent

iii) clean up device tree code in response to feedback for the v2 patch set

We only have a single example DTS file in the tree now, for the simulator,
that goes along with the defconfig file.


Aside from those three things, there are mostly cleanups coming from code
review and from checkpatch.

This tree should now be ready for inclusion in 3.1, but any feedback that
lets us be that much better is of course appreciated.

The code is available in the 'for-upstream' branch of the git repo at:

git://openrisc.net/jonas/linux

Note that there are 4 patches at the base of the branch changing asm-generic
behaviour and reviewed separately.  Note also, that the code in the branch
depends on the devicetree/next branch and one patch from Rusty's patch set
for 3.1.

Thanks,
Jonas

Jonas Bonn (19):
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
 arch/openrisc/Kconfig                    |  207 ++++
 arch/openrisc/Makefile                   |   66 ++
 arch/openrisc/README.openrisc            |  102 ++
 arch/openrisc/TODO.openrisc              |   18 +
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
 arch/openrisc/include/asm/dma-mapping.h  |   62 ++
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
 arch/openrisc/kernel/dma.c               |  132 +++
 arch/openrisc/kernel/entry.S             | 1128 +++++++++++++++++++++
 arch/openrisc/kernel/head.S              | 1607 ++++++++++++++++++++++++++++++
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
 arch/openrisc/or1ksim.cfg                |  888 +++++++++++++++++
 83 files changed, 11687 insertions(+), 0 deletions(-)
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
 create mode 100644 arch/openrisc/or1ksim.cfg

-- 
1.7.4.1

