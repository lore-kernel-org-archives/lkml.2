Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab0EVRGK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 13:06:10 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:45350 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643Ab0EVRGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 13:06:05 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: uclinux-dist-devel@blackfin.uclinux.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/30] Blackfin updates for 2.6.35
Date: Sat, 22 May 2010 13:10:02 -0400
Message-Id: <1274548202-7869-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Largely bug fixes and extended debugging support here.  Extended simulator
support has led to optional pseudo insns in the Blackfin kernel.

Cliff Cai (1):
  Blackfin: mark MUSB VRSEL as active high for appropriate boards

FUJITA Tomonori (1):
  Blackfin: set ARCH_KMALLOC_MINALIGN

Graf Yang (2):
  Blackfin: SMP: add flush_tlb_kernel_range stub
  Blackfin: allow NMI watchdog to be used w/RETN as a scratch reg

Joe Perches (1):
  Blackfin: SMP: fix continuation lines

Michael Hennerich (2):
  Blackfin: punt Blackfin-specific GPIO wakeup API
  Blackfin: fix typo in BF537 IRQ comment

Mike Frysinger (10):
  Blackfin: drop unused bad_page pages and move zero_page to the bss
  Blackfin: cleanup style/comments/etc... in paging_init()
  Blackfin: punt duplicated CAN MMRs
  Blackfin: kgdb: pass up the CC register instead of a 0 stub
  Blackfin: bf537-minotaur: fix build errors due to header changes
  Blackfin: SIC: cut down on IAR MMR reads a bit
  Blackfin: isram: clean up ITEST_COMMAND macro and improve the
    selftests
  Blackfin: another year of changes (update copyright in boot log)
  Blackfin: use atomic kmalloc in L1 alloc so it too can be atomic
  Blackfin: unify duplicate MEM_MT48LC32M8A2_75 kconfig options

Robin Getz (12):
  Blackfin: split kernel/traps.c
  Blackfin: remove CONFIG_DEBUG_VERBOSE from trace.c
  Blackfin: print out the faulting insn in the trace output
  Blackfin: make hardware trace output a little more useful
  Blackfin: add support for the DBGA (debug assert) pseudo insn
  Blackfin: change the BUG opcode to an unused 16-bit opcode
  Blackfin: add support for the DBG (debug output) pseudo insn
  Blackfin: support all possible registers in the pseudo instructions
  Blackfin: show the whole accumulator in the pseudo DBG insn
  Blackfin: handle HW errors in the new "FAULT" printing code
  Blackfin: move string functions to normal lib/ assembly
  Blackfin: optimize strncpy a bit

Wolfram Sang (1):
  Blackfin: acvilon: fix timeout usage for I2C

 arch/blackfin/Kconfig                              |   61 +-
 arch/blackfin/Kconfig.debug                        |   11 +-
 arch/blackfin/include/asm/bfin-global.h            |    6 +
 arch/blackfin/include/asm/bug.h                    |    7 +-
 arch/blackfin/include/asm/cache.h                  |    2 +
 arch/blackfin/include/asm/gpio.h                   |   22 +-
 arch/blackfin/include/asm/pgtable.h                |    3 +-
 arch/blackfin/include/asm/pseudo_instructions.h    |   18 +
 arch/blackfin/include/asm/string.h                 |  113 +---
 arch/blackfin/include/asm/tlbflush.h               |    1 +
 arch/blackfin/include/asm/trace.h                  |    7 +
 arch/blackfin/kernel/Makefile                      |    5 +-
 arch/blackfin/kernel/bfin_gpio.c                   |  131 +---
 arch/blackfin/kernel/bfin_ksyms.c                  |   12 +
 arch/blackfin/kernel/dumpstack.c                   |  174 ++++
 arch/blackfin/kernel/exception.c                   |   45 +
 arch/blackfin/kernel/kgdb.c                        |    2 +-
 arch/blackfin/kernel/pseudodgb.c                   |  191 ++++
 arch/blackfin/kernel/setup.c                       |    4 +-
 arch/blackfin/kernel/sys_bfin.c                    |   23 +
 arch/blackfin/kernel/trace.c                       |  981 ++++++++++++++++++++
 arch/blackfin/kernel/traps.c                       |  900 ++-----------------
 arch/blackfin/lib/memset.S                         |    1 +
 arch/blackfin/lib/strcmp.S                         |   43 +
 arch/blackfin/lib/strcmp.c                         |   19 -
 arch/blackfin/lib/strcpy.S                         |   35 +
 arch/blackfin/lib/strcpy.c                         |   19 -
 arch/blackfin/lib/strncmp.S                        |   52 +
 arch/blackfin/lib/strncmp.c                        |   18 -
 arch/blackfin/lib/strncpy.S                        |   85 ++
 arch/blackfin/lib/strncpy.c                        |   19 -
 arch/blackfin/mach-bf527/boards/cm_bf527.c         |    4 +
 arch/blackfin/mach-bf527/boards/ezbrd.c            |    4 +
 arch/blackfin/mach-bf527/boards/ezkit.c            |    4 +
 arch/blackfin/mach-bf537/boards/minotaur.c         |    3 +-
 arch/blackfin/mach-bf537/include/mach/defBF534.h   |  622 -------------
 arch/blackfin/mach-bf537/include/mach/irq.h        |    2 +-
 arch/blackfin/mach-bf538/include/mach/defBF539.h   |  621 -------------
 arch/blackfin/mach-bf548/boards/cm_bf548.c         |    4 +
 arch/blackfin/mach-bf548/boards/ezkit.c            |    4 +
 .../mach-bf548/include/mach/defBF54x_base.h        |  671 -------------
 arch/blackfin/mach-bf561/boards/acvilon.c          |    3 +-
 arch/blackfin/mach-common/ints-priority.c          |   42 +-
 arch/blackfin/mach-common/pm.c                     |   24 -
 arch/blackfin/mach-common/smp.c                    |    4 +-
 arch/blackfin/mm/init.c                            |   60 +-
 arch/blackfin/mm/isram-driver.c                    |   94 +-
 arch/blackfin/mm/sram-alloc.c                      |    3 +-
 48 files changed, 1938 insertions(+), 3241 deletions(-)
 create mode 100644 arch/blackfin/include/asm/pseudo_instructions.h
 create mode 100644 arch/blackfin/kernel/dumpstack.c
 create mode 100644 arch/blackfin/kernel/exception.c
 create mode 100644 arch/blackfin/kernel/pseudodgb.c
 create mode 100644 arch/blackfin/kernel/trace.c
 create mode 100644 arch/blackfin/lib/strcmp.S
 delete mode 100644 arch/blackfin/lib/strcmp.c
 create mode 100644 arch/blackfin/lib/strcpy.S
 delete mode 100644 arch/blackfin/lib/strcpy.c
 create mode 100644 arch/blackfin/lib/strncmp.S
 delete mode 100644 arch/blackfin/lib/strncmp.c
 create mode 100644 arch/blackfin/lib/strncpy.S
 delete mode 100644 arch/blackfin/lib/strncpy.c

