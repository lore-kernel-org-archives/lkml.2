Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab1AJMSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 07:18:22 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:56633 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361Ab1AJMSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 07:18:20 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: uclinux-dist-devel@blackfin.uclinux.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/52] Blackfin updates for 2.6.38
Date: Mon, 10 Jan 2011 07:26:05 -0500
Message-Id: <1294662365-25109-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.4.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've got a bunch of SMP updates, processor header clean ups, and more
work in pushing down global defines into more peripheral-specific headers.
There's some asm-generic improvements, some serial port overhauls, and
a new board port.  Not to mention the standard sprinkling of bug fixes.

Andreas Schallenberg (1):
  Blackfin: DNP5370: new board port

Bob Liu (1):
  Blackfin: musb-boards: push clkin value to platform resources

Graf Yang (7):
  Blackfin: SMP: fix hotplug building after irq header shuffle
  Blackfin: SMP: rename the arch_xxx lock funcs to __raw_xxx
  Blackfin: SMP: fix cpumask misbehavior
  Blackfin: SMP: tweak platform_request_ipi() usage
  Blackfin: bf561: fix mem_map.h SMP overrides
  Blackfin: SMP: add missing arch_{read,write}_lock_flags helpers
  Blackfin: SMP: relocate blackfin_core_id() definition

Michael Hennerich (1):
  MAINTAINERS: update Analog Devices support info

Mike Frysinger (29):
  net/irda: bfin_sir: pull in serial headers for defines
  Blackfin: bfin_serial.h: unify heavily duplicated serial code
  net/irda: bfin_sir: back out transitional defines
  asm-generic/io.h: add reads[bwl]/writes[bwl] helpers
  Blackfin: switch to asm-generic/io.h
  Blackfin: bfin_dma.h: start a header for DMA MMR layout
  Blackfin: standardize DMAC traffic control MMRs & MDMA MMRs
  Blackfin: dma: constify MMR pointer array
  Blackfin: bf54x: drop unused legacy MMR names
  Blackfin: push gpio (port) defines into common headers
  Blackfin: bf533: convert boards to gpio framework
  Blackfin: bf561-ezkit: add SMP defconfig
  Blackfin: bf533: merge fio_flag back into normal mach headers
  Blackfin: clean up mach header includes
  Blackfin: bf51x/bf52x: drop redundant "base" def/cdef header
  Blackfin: drop asm/irq.h include from mach headers
  Blackfin: bf561: update a few more SIC_SYSCR locations
  Blackfin: SMP: fix asm/bitops.h errors
  Blackfin: SMP: fix build breakage in cache.h
  Blackfin: unify pll.h headers
  Blackfin: bf561: SMP: add multicore pll handlers
  Blackfin: bf54x: add MMR layout for PINT
  Blackfin: dpmc.h: pull in new pll.h
  Blackfin: fix building IPIPE code when XIP is enabled
  Blackfin: move "-m elf32bfin" to general LDFLAGS
  Blackfin: boards: add missing "static" to peripheral lists
  Blackfin: sram_free_with_lsl: do not ignore return value of sram_free
  Blackfin: bf54x: don't ack GPIO ints when unmasking them
  Blackfin: encode cpu-rev into uImage name

Sonic Zhang (9):
  serial: bfin_5xx: move resources into board files
  Blackfin: no-mpu: fix masking of small uncached dma region
  Blackfin: bf527-ezkit: add adau1373 chip address
  Blackfin: sport_uart resources: remove unused secondary RX/TX pins
  Blackfin: SMP: kgdb: flush core internal write buffer before flushinv
  Blackfin: SMP: kgdb: apply anomaly 257 work around
  Blackfin: kgdb: disable interrupt when single stepping in ADEOS
  Blackfin: kgdb: disable preempt schedule when running single step in
    kgdb
  Blackfin: bf518f-ezbrd: fix dsa resources

Stefan Weil (1):
  Blackfin: tll6527m: fix spelling in unused code (struct name)

Steven Miao (1):
  Blackfin: pm: drop irq save/restore in standby and suspend to mem
    callback

Vivi Li (1):
  Blackfin: kgdb_test: make sure to initialize num2

Yi Li (1):
  Blackfin: SMP: rewrite IPI handling to avoid memory allocation

 MAINTAINERS                                        |   82 +-
 arch/blackfin/Makefile                             |    9 +-
 arch/blackfin/boot/Makefile                        |    2 +-
 arch/blackfin/configs/BF561-EZKIT-SMP_defconfig    |  113 ++
 arch/blackfin/configs/DNP5370_defconfig            |  121 ++
 arch/blackfin/include/asm/bfin_dma.h               |   91 +
 arch/blackfin/include/asm/bfin_serial.h            |  275 +++
 arch/blackfin/include/asm/bitops.h                 |    2 +
 arch/blackfin/include/asm/cache.h                  |    2 +
 arch/blackfin/include/asm/cacheflush.h             |    3 +
 arch/blackfin/include/asm/dma.h                    |   37 +-
 arch/blackfin/include/asm/dpmc.h                   |    2 +
 arch/blackfin/include/asm/io.h                     |  268 +---
 arch/blackfin/include/asm/irqflags.h               |    3 -
 arch/blackfin/include/asm/processor.h              |    4 +-
 arch/blackfin/include/asm/spinlock.h               |   28 +-
 arch/blackfin/include/mach-common/pll.h            |   86 +
 arch/blackfin/include/mach-common/ports-a.h        |   25 +
 arch/blackfin/include/mach-common/ports-b.h        |   25 +
 arch/blackfin/include/mach-common/ports-c.h        |   25 +
 arch/blackfin/include/mach-common/ports-d.h        |   25 +
 arch/blackfin/include/mach-common/ports-e.h        |   25 +
 arch/blackfin/include/mach-common/ports-f.h        |   25 +
 arch/blackfin/include/mach-common/ports-g.h        |   25 +
 arch/blackfin/include/mach-common/ports-h.h        |   25 +
 arch/blackfin/include/mach-common/ports-i.h        |   25 +
 arch/blackfin/include/mach-common/ports-j.h        |   25 +
 arch/blackfin/kernel/cplb-nompu/cplbinit.c         |    2 +-
 arch/blackfin/kernel/kgdb.c                        |   26 +
 arch/blackfin/kernel/kgdb_test.c                   |    4 +
 arch/blackfin/mach-bf518/boards/ezbrd.c            |   29 +-
 arch/blackfin/mach-bf518/boards/tcm-bf518.c        |   12 +-
 arch/blackfin/mach-bf518/dma.c                     |    2 +-
 .../blackfin/mach-bf518/include/mach/bfin_serial.h |   14 +
 .../mach-bf518/include/mach/bfin_serial_5xx.h      |   73 +-
 arch/blackfin/mach-bf518/include/mach/blackfin.h   |   68 +-
 arch/blackfin/mach-bf518/include/mach/cdefBF512.h  | 1038 ++++++++++-
 arch/blackfin/mach-bf518/include/mach/cdefBF514.h  |    5 +-
 arch/blackfin/mach-bf518/include/mach/cdefBF516.h  |    5 +-
 arch/blackfin/mach-bf518/include/mach/cdefBF518.h  |    5 +-
 .../mach-bf518/include/mach/cdefBF51x_base.h       | 1061 ----------
 arch/blackfin/mach-bf518/include/mach/defBF512.h   | 1388 +++++++++++++-
 .../mach-bf518/include/mach/defBF51x_base.h        | 1495 --------------
 arch/blackfin/mach-bf518/include/mach/gpio.h       |    4 +
 arch/blackfin/mach-bf518/include/mach/pll.h        |   64 +-
 arch/blackfin/mach-bf527/boards/ad7160eval.c       |   13 +-
 arch/blackfin/mach-bf527/boards/cm_bf527.c         |   13 +-
 arch/blackfin/mach-bf527/boards/ezbrd.c            |   13 +-
 arch/blackfin/mach-bf527/boards/ezkit.c            |   18 +-
 arch/blackfin/mach-bf527/boards/tll6527m.c         |   14 +-
 arch/blackfin/mach-bf527/dma.c                     |    2 +-
 .../blackfin/mach-bf527/include/mach/bfin_serial.h |   14 +
 .../mach-bf527/include/mach/bfin_serial_5xx.h      |   73 +-
 arch/blackfin/mach-bf527/include/mach/blackfin.h   |   48 +-
 arch/blackfin/mach-bf527/include/mach/cdefBF522.h  | 1092 ++++++++++-
 arch/blackfin/mach-bf527/include/mach/cdefBF525.h  |    7 +-
 arch/blackfin/mach-bf527/include/mach/cdefBF527.h  |    7 +-
 .../mach-bf527/include/mach/cdefBF52x_base.h       | 1113 -----------
 arch/blackfin/mach-bf527/include/mach/defBF522.h   | 1393 +++++++++++++-
 arch/blackfin/mach-bf527/include/mach/defBF525.h   |    2 +-
 arch/blackfin/mach-bf527/include/mach/defBF527.h   |    2 +-
 .../mach-bf527/include/mach/defBF52x_base.h        | 1506 --------------
 arch/blackfin/mach-bf527/include/mach/gpio.h       |    4 +
 arch/blackfin/mach-bf527/include/mach/pll.h        |   64 +-
 arch/blackfin/mach-bf533/boards/H8606.c            |    2 +-
 arch/blackfin/mach-bf533/boards/blackstamp.c       |   25 +-
 arch/blackfin/mach-bf533/boards/cm_bf533.c         |   10 +-
 arch/blackfin/mach-bf533/boards/ezkit.c            |    2 +-
 arch/blackfin/mach-bf533/boards/ip0x.c             |   11 +-
 arch/blackfin/mach-bf533/boards/stamp.c            |   30 +-
 arch/blackfin/mach-bf533/dma.c                     |    2 +-
 .../blackfin/mach-bf533/include/mach/bfin_serial.h |   14 +
 .../mach-bf533/include/mach/bfin_serial_5xx.h      |   74 +-
 arch/blackfin/mach-bf533/include/mach/blackfin.h   |   30 +-
 arch/blackfin/mach-bf533/include/mach/cdefBF532.h  |   63 +-
 arch/blackfin/mach-bf533/include/mach/defBF532.h   |  128 +--
 arch/blackfin/mach-bf533/include/mach/fio_flag.h   |   55 -
 arch/blackfin/mach-bf533/include/mach/gpio.h       |    2 +
 arch/blackfin/mach-bf533/include/mach/pll.h        |   58 +-
 arch/blackfin/mach-bf537/boards/Kconfig            |    6 +
 arch/blackfin/mach-bf537/boards/Makefile           |    1 +
 arch/blackfin/mach-bf537/boards/cm_bf537e.c        |   12 +-
 arch/blackfin/mach-bf537/boards/cm_bf537u.c        |   12 +-
 arch/blackfin/mach-bf537/boards/dnp5370.c          |  418 ++++
 arch/blackfin/mach-bf537/boards/minotaur.c         |   12 +-
 arch/blackfin/mach-bf537/boards/pnav10.c           |    4 +-
 arch/blackfin/mach-bf537/boards/stamp.c            |   18 +-
 arch/blackfin/mach-bf537/boards/tcm_bf537.c        |   12 +-
 arch/blackfin/mach-bf537/dma.c                     |    2 +-
 .../blackfin/mach-bf537/include/mach/bfin_serial.h |   14 +
 .../mach-bf537/include/mach/bfin_serial_5xx.h      |   72 +-
 arch/blackfin/mach-bf537/include/mach/blackfin.h   |   38 +-
 arch/blackfin/mach-bf537/include/mach/cdefBF534.h  |   27 +-
 arch/blackfin/mach-bf537/include/mach/cdefBF537.h  |    5 +-
 arch/blackfin/mach-bf537/include/mach/defBF534.h   |  111 +-
 arch/blackfin/mach-bf537/include/mach/defBF537.h   |    5 +-
 arch/blackfin/mach-bf537/include/mach/gpio.h       |    4 +
 arch/blackfin/mach-bf537/include/mach/pll.h        |   58 +-
 arch/blackfin/mach-bf538/boards/ezkit.c            |   20 +-
 arch/blackfin/mach-bf538/dma.c                     |   18 +-
 .../blackfin/mach-bf538/include/mach/bfin_serial.h |   14 +
 .../mach-bf538/include/mach/bfin_serial_5xx.h      |   73 +-
 arch/blackfin/mach-bf538/include/mach/blackfin.h   |   37 +-
 arch/blackfin/mach-bf538/include/mach/cdefBF538.h  |  504 ++---
 arch/blackfin/mach-bf538/include/mach/cdefBF539.h  |    8 +-
 arch/blackfin/mach-bf538/include/mach/defBF538.h   | 1825 +++++++++++++++++
 arch/blackfin/mach-bf538/include/mach/defBF539.h   | 2095 +-------------------
 arch/blackfin/mach-bf538/include/mach/gpio.h       |    5 +
 arch/blackfin/mach-bf538/include/mach/pll.h        |   64 +-
 arch/blackfin/mach-bf548/boards/cm_bf548.c         |   23 +-
 arch/blackfin/mach-bf548/boards/ezkit.c            |   23 +-
 arch/blackfin/mach-bf548/dma.c                     |    2 +-
 .../blackfin/mach-bf548/include/mach/bfin_serial.h |   16 +
 .../mach-bf548/include/mach/bfin_serial_5xx.h      |   60 +-
 arch/blackfin/mach-bf548/include/mach/blackfin.h   |   70 +-
 arch/blackfin/mach-bf548/include/mach/cdefBF542.h  |   10 +-
 arch/blackfin/mach-bf548/include/mach/cdefBF544.h  |   10 +-
 arch/blackfin/mach-bf548/include/mach/cdefBF547.h  |   10 +-
 arch/blackfin/mach-bf548/include/mach/cdefBF548.h  |   10 +-
 arch/blackfin/mach-bf548/include/mach/cdefBF549.h  |   10 +-
 .../mach-bf548/include/mach/cdefBF54x_base.h       |   23 +-
 arch/blackfin/mach-bf548/include/mach/defBF542.h   |    7 +-
 arch/blackfin/mach-bf548/include/mach/defBF544.h   |    7 +-
 arch/blackfin/mach-bf548/include/mach/defBF547.h   |    7 +-
 arch/blackfin/mach-bf548/include/mach/defBF548.h   |    7 +-
 arch/blackfin/mach-bf548/include/mach/defBF549.h   |    7 +-
 .../mach-bf548/include/mach/defBF54x_base.h        |  321 +---
 arch/blackfin/mach-bf548/include/mach/gpio.h       |   11 +
 arch/blackfin/mach-bf548/include/mach/irq.h        |   22 +
 arch/blackfin/mach-bf548/include/mach/pll.h        |   70 +-
 arch/blackfin/mach-bf561/atomic.S                  |    5 +
 arch/blackfin/mach-bf561/boards/acvilon.c          |    2 +-
 arch/blackfin/mach-bf561/boards/cm_bf561.c         |    2 +-
 arch/blackfin/mach-bf561/boards/ezkit.c            |    2 +-
 arch/blackfin/mach-bf561/boards/tepla.c            |    2 +-
 arch/blackfin/mach-bf561/dma.c                     |   18 +-
 arch/blackfin/mach-bf561/hotplug.c                 |    2 +
 arch/blackfin/mach-bf561/include/mach/anomaly.h    |    6 +-
 .../blackfin/mach-bf561/include/mach/bfin_serial.h |   14 +
 .../mach-bf561/include/mach/bfin_serial_5xx.h      |   74 +-
 arch/blackfin/mach-bf561/include/mach/blackfin.h   |   26 +-
 arch/blackfin/mach-bf561/include/mach/cdefBF561.h  |  503 ++---
 arch/blackfin/mach-bf561/include/mach/defBF561.h   |  408 ++---
 arch/blackfin/mach-bf561/include/mach/gpio.h       |    2 +
 arch/blackfin/mach-bf561/include/mach/mem_map.h    |   16 +-
 arch/blackfin/mach-bf561/include/mach/pll.h        |   83 +-
 arch/blackfin/mach-bf561/include/mach/smp.h        |   10 +-
 arch/blackfin/mach-bf561/smp.c                     |   29 +-
 arch/blackfin/mach-common/entry.S                  |    4 +-
 arch/blackfin/mach-common/ints-priority.c          |    1 -
 arch/blackfin/mach-common/pm.c                     |   10 -
 arch/blackfin/mach-common/smp.c                    |  204 +--
 arch/blackfin/mm/sram-alloc.c                      |   18 +-
 drivers/net/irda/bfin_sir.h                        |    2 +
 drivers/serial/Kconfig                             |   70 +-
 drivers/serial/bfin_5xx.c                          |  638 ++++---
 include/asm-generic/io.h                           |   30 +
 157 files changed, 9963 insertions(+), 11015 deletions(-)
 create mode 100644 arch/blackfin/configs/BF561-EZKIT-SMP_defconfig
 create mode 100644 arch/blackfin/configs/DNP5370_defconfig
 create mode 100644 arch/blackfin/include/asm/bfin_dma.h
 create mode 100644 arch/blackfin/include/asm/bfin_serial.h
 create mode 100644 arch/blackfin/include/mach-common/pll.h
 create mode 100644 arch/blackfin/include/mach-common/ports-a.h
 create mode 100644 arch/blackfin/include/mach-common/ports-b.h
 create mode 100644 arch/blackfin/include/mach-common/ports-c.h
 create mode 100644 arch/blackfin/include/mach-common/ports-d.h
 create mode 100644 arch/blackfin/include/mach-common/ports-e.h
 create mode 100644 arch/blackfin/include/mach-common/ports-f.h
 create mode 100644 arch/blackfin/include/mach-common/ports-g.h
 create mode 100644 arch/blackfin/include/mach-common/ports-h.h
 create mode 100644 arch/blackfin/include/mach-common/ports-i.h
 create mode 100644 arch/blackfin/include/mach-common/ports-j.h
 create mode 100644 arch/blackfin/mach-bf518/include/mach/bfin_serial.h
 delete mode 100644 arch/blackfin/mach-bf518/include/mach/cdefBF51x_base.h
 delete mode 100644 arch/blackfin/mach-bf518/include/mach/defBF51x_base.h
 create mode 100644 arch/blackfin/mach-bf527/include/mach/bfin_serial.h
 delete mode 100644 arch/blackfin/mach-bf527/include/mach/cdefBF52x_base.h
 delete mode 100644 arch/blackfin/mach-bf527/include/mach/defBF52x_base.h
 create mode 100644 arch/blackfin/mach-bf533/include/mach/bfin_serial.h
 delete mode 100644 arch/blackfin/mach-bf533/include/mach/fio_flag.h
 create mode 100644 arch/blackfin/mach-bf537/boards/dnp5370.c
 create mode 100644 arch/blackfin/mach-bf537/include/mach/bfin_serial.h
 create mode 100644 arch/blackfin/mach-bf538/include/mach/bfin_serial.h
 create mode 100644 arch/blackfin/mach-bf538/include/mach/defBF538.h
 create mode 100644 arch/blackfin/mach-bf548/include/mach/bfin_serial.h
 create mode 100644 arch/blackfin/mach-bf561/include/mach/bfin_serial.h

-- 
1.7.4.rc1

