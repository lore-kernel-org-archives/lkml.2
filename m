Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab0J0ROW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 13:14:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881Ab0J0ROT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 13:14:19 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: torvalds@osdl.org
cc: dhowells@redhat.com, linux-am33-list@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] MN10300: Add AM34 and SMP support
Date: Wed, 27 Oct 2010 18:13:59 +0100
Message-ID: <2147.1288199639@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


These patches support for the AM34 CPU core variant of the MN10300 arch.  This
is an SMP capable core, so SMP support is added also.

Further, support for the MN2WS0060 processor (which is AM34 based), and the
ASB2364 evaluation board are added to make use of that.


There are three patches here that touch code outside of the arch:

 (#1) A patch to revert parenthesisation of numbers in asm-offset.h which
      breaks the MN10300 assembly code.

 (#6) A patch to typedef the smpcall function pointer as it's used in many
      places.

(#36) Some changes to the SMSC 911x driver to provide it with hooks by which it
      can initialise the ASB2364 board FPGA and find the MAC address in an
      alternate location.

David
---
The following changes since commit 12ba8d1e9262ce81a695795410bd9ee5c9407ba1:

  fix braino in fs: do not assign default i_ino in new_inode (2010-10-26 20:25:45 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-2.6-mn10300.git master

Akira Takeuchi (26):
      MN10300: Don't cast away the volatile in test_bit()
      MN10300: Add reads[bwl]() and writes[bwl]()
      MN10300: Provide the functions to fully disable maskable interrupts
      MN10300: Differentiate AM33_2 and AM33_3 in config
      MN10300: Move DMA engine control reg defs to MN103E010 processor directory
      MN10300: Don't hard code the cacheline size in register defs
      MN10300: Add CPU register bits for AM34
      MN10300: Remove monitor/JTAG functions
      MN10300: Cacheflush functions should take unsigned long addresses
      MN10300: SMP: Differentiate local cache flushing
      MN10300: AM34: Add cacheflushing by using the AM34 purge registers
      MN10300: Cache: Implement SMP global cache flushing
      MN10300: Make the boot wrapper able to use writeback caching
      MN10300: AM34 erratum requires MMUCTR read and write on exception entry
      MN10300: Make the use of PIDR to mark TLB entries controllable
      MN10300: Use the [ID]PTEL2 registers rather than [ID]PTEL for TLB control
      MN10300: SMP TLB flushing
      MN10300: Make the FPU operate in non-lazy mode under SMP
      MN10300: Optimise do_csum()
      MN10300: Make various interrupt priority settings configurable
      MN10300: Delete idle_timestamp from irq_cpustat_t
      MN10300: And Panasonic AM34 subarch and implement SMP
      MN10300: ASB2364: Add support for SMSC911X and SMC911X
      MN10300: Update the ASB2303 defconfig
      MN10300: Create a defconfig for the ASB2364 board
      MN10300: Change "Matsushita" to "Panasonic".

David Howells (12):
      Partially revert patch that encloses asm-offset.h numbers in brackets
      mn10300: Use pci_claim_resource
      MN10300: Prevent cnt32_to_63() from being preempted in sched_clock()
      Typedef SMP call function pointer
      MN10300: Cache: Split cache bits out of arch Kconfig
      MN10300: Provide a MN10300_CACHE_ENABLED config option
      MN10300: Reorder asm/cacheflush.h to put primitives first
      MN10300: AM34: The current cacheflush routines operate by controlling tag regs
      MN10300: Allow some cacheflushes to be avoided if cache snooping is available
      MN10300: Rename __flush_tlb*() to local_flush_tlb*()
      MN10300: ASB2364: Handle the IRQ multiplexer in the FPGA
      MN10300: Save frame pointer in thread_info struct rather than global var

Justin Chen (1):
      bitops: Change the bitmap index from int to unsigned long [mn10300]

Mark Salter (4):
      MN10300: Implement atomic ops using atomic ops unit
      MN10300: Map userspace atomic op regs as a vmalloc page
      MN10300: Specify an ELF HWCAP flag for MN10300 Atomic Operations Unit support
      MN10300: Generic time support

Stoyan Gaydarov (1):
      MN10300: BUG to BUG_ON changes

 Kbuild                                             |    2 +-
 MAINTAINERS                                        |    2 +-
 arch/mn10300/Kconfig                               |  279 ++++-
 arch/mn10300/Makefile                              |    6 +
 arch/mn10300/boot/compressed/head.S                |   69 ++-
 arch/mn10300/configs/asb2303_defconfig             |    2 +
 arch/mn10300/configs/asb2364_defconfig             |   98 ++
 arch/mn10300/include/asm/atomic.h                  |  350 ++++++
 arch/mn10300/include/asm/bitops.h                  |   14 +-
 arch/mn10300/include/asm/cache.h                   |   14 +-
 arch/mn10300/include/asm/cacheflush.h              |  164 ++-
 arch/mn10300/include/asm/cpu-regs.h                |   91 ++-
 arch/mn10300/include/asm/dmactl-regs.h             |   87 +--
 arch/mn10300/include/asm/elf.h                     |   12 +-
 arch/mn10300/include/asm/exceptions.h              |    8 +-
 arch/mn10300/include/asm/fpu.h                     |  157 ++-
 arch/mn10300/include/asm/frame.inc                 |   20 +-
 arch/mn10300/include/asm/gdb-stub.h                |    2 +-
 arch/mn10300/include/asm/hardirq.h                 |    3 +-
 arch/mn10300/include/asm/highmem.h                 |    4 +-
 arch/mn10300/include/asm/intctl-regs.h             |   37 +-
 arch/mn10300/include/asm/io.h                      |   13 +
 arch/mn10300/include/asm/irq.h                     |   12 +-
 arch/mn10300/include/asm/irq_regs.h                |    6 +-
 arch/mn10300/include/asm/irqflags.h                |  111 ++-
 arch/mn10300/include/asm/mmu_context.h             |   73 +-
 arch/mn10300/include/asm/pgalloc.h                 |    1 -
 arch/mn10300/include/asm/pgtable.h                 |   88 +-
 arch/mn10300/include/asm/processor.h               |   66 +-
 arch/mn10300/include/asm/ptrace.h                  |   13 +-
 arch/mn10300/include/asm/reset-regs.h              |    2 +-
 arch/mn10300/include/asm/rtc.h                     |   11 -
 arch/mn10300/include/asm/rwlock.h                  |  125 +++
 arch/mn10300/include/asm/serial-regs.h             |   51 +-
 arch/mn10300/include/asm/serial.h                  |    8 +-
 arch/mn10300/include/asm/smp.h                     |   91 ++-
 arch/mn10300/include/asm/smsc911x.h                |    1 +
 arch/mn10300/include/asm/spinlock.h                |  179 +++-
 arch/mn10300/include/asm/spinlock_types.h          |   20 +
 arch/mn10300/include/asm/system.h                  |   73 +-
 arch/mn10300/include/asm/thread_info.h             |   18 +-
 arch/mn10300/include/asm/timer-regs.h              |  191 +++-
 arch/mn10300/include/asm/timex.h                   |   20 +-
 arch/mn10300/include/asm/tlbflush.h                |  174 +++-
 arch/mn10300/include/asm/uaccess.h                 |    6 +-
 arch/mn10300/kernel/Makefile                       |   15 +-
 arch/mn10300/kernel/asm-offsets.c                  |   11 +-
 arch/mn10300/kernel/cevt-mn10300.c                 |  131 +++
 arch/mn10300/kernel/csrc-mn10300.c                 |   35 +
 arch/mn10300/kernel/entry.S                        |  146 ++-
 arch/mn10300/kernel/fpu-low.S                      |  265 +++--
 arch/mn10300/kernel/fpu-nofpu-low.S                |   39 +
 arch/mn10300/kernel/fpu-nofpu.c                    |   30 +
 arch/mn10300/kernel/fpu.c                          |  141 +--
 arch/mn10300/kernel/gdb-io-serial-low.S            |    5 +-
 arch/mn10300/kernel/gdb-io-serial.c                |   37 +-
 arch/mn10300/kernel/gdb-io-ttysm.c                 |   24 +-
 arch/mn10300/kernel/gdb-stub.c                     |   17 +-
 arch/mn10300/kernel/head.S                         |  202 ++++-
 arch/mn10300/kernel/internal.h                     |   25 +
 arch/mn10300/kernel/irq.c                          |  276 +++++-
 arch/mn10300/kernel/kprobes.c                      |    4 +
 arch/mn10300/kernel/mn10300-serial-low.S           |    6 +-
 arch/mn10300/kernel/mn10300-serial.c               |  210 +++-
 arch/mn10300/kernel/mn10300-watchdog-low.S         |    9 +-
 arch/mn10300/kernel/mn10300-watchdog.c             |  100 +-
 arch/mn10300/kernel/process.c                      |   61 +-
 arch/mn10300/kernel/profile.c                      |    2 +-
 arch/mn10300/kernel/rtc.c                          |   41 +-
 arch/mn10300/kernel/setup.c                        |   79 +-
 arch/mn10300/kernel/signal.c                       |   20 +-
 arch/mn10300/kernel/smp-low.S                      |   97 ++
 arch/mn10300/kernel/smp.c                          | 1152 ++++++++++++++++++++
 arch/mn10300/kernel/switch_to.S                    |    7 +-
 arch/mn10300/kernel/time.c                         |  112 ++-
 arch/mn10300/kernel/traps.c                        |   42 +-
 arch/mn10300/lib/bitops.c                          |    4 +-
 arch/mn10300/lib/delay.c                           |    8 +-
 arch/mn10300/lib/do_csum.S                         |   49 +-
 arch/mn10300/mm/Kconfig.cache                      |  101 ++
 arch/mn10300/mm/Makefile                           |   14 +-
 arch/mn10300/mm/cache-flush-by-reg.S               |  308 ++++++
 arch/mn10300/mm/cache-flush-by-tag.S               |  251 +++++
 arch/mn10300/mm/cache-flush-icache.c               |  155 +++
 arch/mn10300/mm/cache-flush-mn10300.S              |  192 ----
 arch/mn10300/mm/cache-inv-by-reg.S                 |  356 ++++++
 arch/mn10300/mm/cache-inv-by-tag.S                 |  348 ++++++
 arch/mn10300/mm/cache-inv-icache.c                 |  129 +++
 arch/mn10300/mm/cache-mn10300.S                    |  289 -----
 arch/mn10300/mm/cache-smp-flush.c                  |  156 +++
 arch/mn10300/mm/cache-smp-inv.c                    |  153 +++
 arch/mn10300/mm/cache-smp.c                        |  105 ++
 arch/mn10300/mm/cache-smp.h                        |   69 ++
 arch/mn10300/mm/cache.c                            |   95 +--
 arch/mn10300/mm/fault.c                            |   17 +-
 arch/mn10300/mm/init.c                             |   26 +-
 arch/mn10300/mm/misalignment.c                     |    3 +-
 arch/mn10300/mm/mmu-context.c                      |   41 +-
 arch/mn10300/mm/pgtable.c                          |    2 +-
 arch/mn10300/mm/tlb-mn10300.S                      |   59 +-
 arch/mn10300/mm/tlb-smp.c                          |  214 ++++
 arch/mn10300/proc-mn103e010/include/proc/cache.h   |    9 +
 arch/mn10300/proc-mn103e010/include/proc/clock.h   |    2 -
 .../proc-mn103e010/include/proc/dmactl-regs.h      |  102 ++
 .../proc-mn103e010/include/proc/intctl-regs.h      |   29 +
 arch/mn10300/proc-mn103e010/include/proc/proc.h    |    2 +-
 arch/mn10300/proc-mn103e010/proc-init.c            |   37 +
 arch/mn10300/proc-mn2ws0050/Makefile               |    5 +
 arch/mn10300/proc-mn2ws0050/include/proc/cache.h   |   48 +
 arch/mn10300/proc-mn2ws0050/include/proc/clock.h   |   20 +
 .../proc-mn2ws0050/include/proc/dmactl-regs.h      |  103 ++
 .../proc-mn2ws0050/include/proc/intctl-regs.h      |   29 +
 arch/mn10300/proc-mn2ws0050/include/proc/irq.h     |   49 +
 .../proc-mn2ws0050/include/proc/nand-regs.h        |  120 ++
 arch/mn10300/proc-mn2ws0050/include/proc/proc.h    |   18 +
 .../mn10300/proc-mn2ws0050/include/proc/smp-regs.h |   51 +
 arch/mn10300/proc-mn2ws0050/proc-init.c            |  134 +++
 arch/mn10300/unit-asb2303/include/unit/clock.h     |   25 +-
 arch/mn10300/unit-asb2303/include/unit/serial.h    |    5 +
 arch/mn10300/unit-asb2303/include/unit/timex.h     |  109 ++-
 arch/mn10300/unit-asb2303/unit-init.c              |   10 +-
 arch/mn10300/unit-asb2305/include/unit/clock.h     |   25 +-
 arch/mn10300/unit-asb2305/include/unit/serial.h    |    5 +
 arch/mn10300/unit-asb2305/include/unit/timex.h     |  109 ++-
 arch/mn10300/unit-asb2305/pci-asb2305.c            |   16 +-
 arch/mn10300/unit-asb2305/pci.c                    |    2 +-
 arch/mn10300/unit-asb2305/unit-init.c              |    6 +-
 arch/mn10300/unit-asb2364/Makefile                 |   12 +
 arch/mn10300/unit-asb2364/include/unit/clock.h     |   29 +
 arch/mn10300/unit-asb2364/include/unit/fpga-regs.h |   52 +
 arch/mn10300/unit-asb2364/include/unit/irq.h       |   35 +
 arch/mn10300/unit-asb2364/include/unit/leds.h      |   54 +
 arch/mn10300/unit-asb2364/include/unit/serial.h    |  151 +++
 arch/mn10300/unit-asb2364/include/unit/smsc911x.h  |  171 +++
 arch/mn10300/unit-asb2364/include/unit/timex.h     |  159 +++
 arch/mn10300/unit-asb2364/irq-fpga.c               |   96 ++
 arch/mn10300/unit-asb2364/leds.c                   |   98 ++
 arch/mn10300/unit-asb2364/smsc911x.c               |   58 +
 arch/mn10300/unit-asb2364/unit-init.c              |   88 ++
 drivers/net/Kconfig                                |   12 +-
 drivers/net/smsc911x.c                             |    3 +-
 drivers/net/smsc911x.h                             |   11 +
 include/linux/smp.h                                |   19 +-
 kernel/smp.c                                       |    8 +-
 mm/maccess.c                                       |    2 +-
 145 files changed, 9424 insertions(+), 1963 deletions(-)
 create mode 100644 arch/mn10300/configs/asb2364_defconfig
 create mode 100644 arch/mn10300/include/asm/rwlock.h
 create mode 100644 arch/mn10300/include/asm/smsc911x.h
 create mode 100644 arch/mn10300/include/asm/spinlock_types.h
 create mode 100644 arch/mn10300/kernel/cevt-mn10300.c
 create mode 100644 arch/mn10300/kernel/csrc-mn10300.c
 create mode 100644 arch/mn10300/kernel/fpu-nofpu-low.S
 create mode 100644 arch/mn10300/kernel/fpu-nofpu.c
 create mode 100644 arch/mn10300/kernel/smp-low.S
 create mode 100644 arch/mn10300/kernel/smp.c
 create mode 100644 arch/mn10300/mm/Kconfig.cache
 create mode 100644 arch/mn10300/mm/cache-flush-by-reg.S
 create mode 100644 arch/mn10300/mm/cache-flush-by-tag.S
 create mode 100644 arch/mn10300/mm/cache-flush-icache.c
 delete mode 100644 arch/mn10300/mm/cache-flush-mn10300.S
 create mode 100644 arch/mn10300/mm/cache-inv-by-reg.S
 create mode 100644 arch/mn10300/mm/cache-inv-by-tag.S
 create mode 100644 arch/mn10300/mm/cache-inv-icache.c
 delete mode 100644 arch/mn10300/mm/cache-mn10300.S
 create mode 100644 arch/mn10300/mm/cache-smp-flush.c
 create mode 100644 arch/mn10300/mm/cache-smp-inv.c
 create mode 100644 arch/mn10300/mm/cache-smp.c
 create mode 100644 arch/mn10300/mm/cache-smp.h
 create mode 100644 arch/mn10300/mm/tlb-smp.c
 create mode 100644 arch/mn10300/proc-mn103e010/include/proc/dmactl-regs.h
 create mode 100644 arch/mn10300/proc-mn103e010/include/proc/intctl-regs.h
 create mode 100644 arch/mn10300/proc-mn2ws0050/Makefile
 create mode 100644 arch/mn10300/proc-mn2ws0050/include/proc/cache.h
 create mode 100644 arch/mn10300/proc-mn2ws0050/include/proc/clock.h
 create mode 100644 arch/mn10300/proc-mn2ws0050/include/proc/dmactl-regs.h
 create mode 100644 arch/mn10300/proc-mn2ws0050/include/proc/intctl-regs.h
 create mode 100644 arch/mn10300/proc-mn2ws0050/include/proc/irq.h
 create mode 100644 arch/mn10300/proc-mn2ws0050/include/proc/nand-regs.h
 create mode 100644 arch/mn10300/proc-mn2ws0050/include/proc/proc.h
 create mode 100644 arch/mn10300/proc-mn2ws0050/include/proc/smp-regs.h
 create mode 100644 arch/mn10300/proc-mn2ws0050/proc-init.c
 create mode 100644 arch/mn10300/unit-asb2364/Makefile
 create mode 100644 arch/mn10300/unit-asb2364/include/unit/clock.h
 create mode 100644 arch/mn10300/unit-asb2364/include/unit/fpga-regs.h
 create mode 100644 arch/mn10300/unit-asb2364/include/unit/irq.h
 create mode 100644 arch/mn10300/unit-asb2364/include/unit/leds.h
 create mode 100644 arch/mn10300/unit-asb2364/include/unit/serial.h
 create mode 100644 arch/mn10300/unit-asb2364/include/unit/smsc911x.h
 create mode 100644 arch/mn10300/unit-asb2364/include/unit/timex.h
 create mode 100644 arch/mn10300/unit-asb2364/irq-fpga.c
 create mode 100644 arch/mn10300/unit-asb2364/leds.c
 create mode 100644 arch/mn10300/unit-asb2364/smsc911x.c
 create mode 100644 arch/mn10300/unit-asb2364/unit-init.c
