Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab0KHBNs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 20:13:48 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:58164 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab0KHBNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 20:13:46 -0500
Date: Mon, 8 Nov 2010 10:13:25 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.37-rc2
Message-ID: <20101108011325.GD15243@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is mostly a grouping of nommu fixes and the addition of a clock
framework helper that the R-Mobile stuff will be using going forward.

With things settled down a bit I've also opted to do a sweep and kill off
some dead PIO wrappers and abandoned/bitrotted boards that weren't worth
keeping around. This forms the groundwork for more extensive I/O routine
refactoring that will be aimed at 2.6.38.

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git sh-fixes-for-linus

Which contains:

Guennadi Liakhovetski (2):
      sh: add clk_round_parent() to optimize parent clock rate
      sh: make some needlessly global sh7724 clocks static

Paul Mundt (16):
      sh: mach-microdev: SuperIO-relative ioport mapping.
      sh: mach-snapgear: Rip out superfluous PIO routines.
      sh: mach-snapgear: Kill off machtype, consolidate board def.
      sh: mach-systemh: Kill off dead board.
      sh: mach-se: Rip out superfluous 7206 PIO routines.
      sh: mach-edosk7705: update for this century, kill off PIO trapping.
      sh: mach-edosk7705: Kill off machtype, consolidate board def.
      sh: mach-se: Rip out superfluous 770x PIO routines.
      sh: mach-se: Rip out superfluous 7751 PIO routines.
      sh: clkfwk: Fix up rate rounding error handling.
      sh: intc: Update for single IRQ reservation helper.
      sh: mach-se: Fix up SE7206 no ioport build.
      sh: nommu: use 32-bit phys mode.
      sh: nommu: Support building without an uncached mapping.
      sh: Simplify phys_addr_mask()/PTE_PHYS_MASK for 29/32-bit.
      sh: clkfwk: Fix up checkpatch warnings.

 arch/sh/Kconfig                                    |    1 +
 arch/sh/Makefile                                   |    3 -
 arch/sh/boards/Kconfig                             |    7 -
 arch/sh/boards/Makefile                            |    2 +
 arch/sh/boards/board-edosk7705.c                   |   78 ++++++
 .../setup.c => board-secureedge5410.c}             |   38 +---
 arch/sh/boards/mach-edosk7705/Makefile             |    5 -
 arch/sh/boards/mach-edosk7705/io.c                 |   71 ------
 arch/sh/boards/mach-edosk7705/setup.c              |   36 ---
 arch/sh/boards/mach-microdev/io.c                  |  246 +-------------------
 arch/sh/boards/mach-microdev/setup.c               |   23 +--
 arch/sh/boards/mach-se/7206/Makefile               |    2 +-
 arch/sh/boards/mach-se/7206/io.c                   |  104 --------
 arch/sh/boards/mach-se/7206/irq.c                  |    4 +-
 arch/sh/boards/mach-se/7206/setup.c                |   15 --
 arch/sh/boards/mach-se/770x/Makefile               |    2 +-
 arch/sh/boards/mach-se/770x/io.c                   |  156 -------------
 arch/sh/boards/mach-se/770x/setup.c                |   22 --
 arch/sh/boards/mach-se/7751/Makefile               |    2 +-
 arch/sh/boards/mach-se/7751/io.c                   |  119 ----------
 arch/sh/boards/mach-se/7751/setup.c                |   18 --
 arch/sh/boards/mach-snapgear/Makefile              |    5 -
 arch/sh/boards/mach-snapgear/io.c                  |  121 ----------
 arch/sh/boards/mach-systemh/Makefile               |   13 -
 arch/sh/boards/mach-systemh/io.c                   |  158 -------------
 arch/sh/boards/mach-systemh/irq.c                  |   61 -----
 arch/sh/boards/mach-systemh/setup.c                |   57 -----
 ...snapgear_defconfig => secureedge5410_defconfig} |    0
 arch/sh/configs/systemh_defconfig                  |   28 ---
 arch/sh/include/asm/addrspace.h                    |    8 +-
 arch/sh/include/asm/pgtable.h                      |   12 -
 arch/sh/include/asm/system.h                       |    4 +-
 arch/sh/include/asm/system_32.h                    |   36 ---
 arch/sh/include/asm/system_64.h                    |    3 -
 arch/sh/include/asm/uncached.h                     |   40 ++++
 arch/sh/include/mach-common/mach/edosk7705.h       |    7 -
 arch/sh/include/mach-common/mach/microdev.h        |    9 -
 .../mach/{snapgear.h => secureedge5410.h}          |   22 --
 arch/sh/include/mach-common/mach/systemh7751.h     |   71 ------
 arch/sh/kernel/cpu/sh4a/clock-sh7724.c             |    6 +-
 arch/sh/mm/Kconfig                                 |    2 +-
 arch/sh/mm/consistent.c                            |   15 +-
 arch/sh/mm/uncached.c                              |    2 +-
 arch/sh/tools/mach-types                           |    1 -
 drivers/rtc/rtc-ds1302.c                           |    2 +-
 drivers/sh/clk/core.c                              |   96 ++++++++-
 drivers/sh/intc/core.c                             |    2 +-
 drivers/sh/intc/dynamic.c                          |    2 +-
 include/linux/sh_clk.h                             |    4 +
 49 files changed, 259 insertions(+), 1482 deletions(-)
 create mode 100644 arch/sh/boards/board-edosk7705.c
 rename arch/sh/boards/{mach-snapgear/setup.c => board-secureedge5410.c} (70%)
 delete mode 100644 arch/sh/boards/mach-edosk7705/Makefile
 delete mode 100644 arch/sh/boards/mach-edosk7705/io.c
 delete mode 100644 arch/sh/boards/mach-edosk7705/setup.c
 delete mode 100644 arch/sh/boards/mach-se/7206/io.c
 delete mode 100644 arch/sh/boards/mach-se/770x/io.c
 delete mode 100644 arch/sh/boards/mach-se/7751/io.c
 delete mode 100644 arch/sh/boards/mach-snapgear/Makefile
 delete mode 100644 arch/sh/boards/mach-snapgear/io.c
 delete mode 100644 arch/sh/boards/mach-systemh/Makefile
 delete mode 100644 arch/sh/boards/mach-systemh/io.c
 delete mode 100644 arch/sh/boards/mach-systemh/irq.c
 delete mode 100644 arch/sh/boards/mach-systemh/setup.c
 rename arch/sh/configs/{snapgear_defconfig => secureedge5410_defconfig} (100%)
 delete mode 100644 arch/sh/configs/systemh_defconfig
 delete mode 100644 arch/sh/include/mach-common/mach/edosk7705.h
 rename arch/sh/include/mach-common/mach/{snapgear.h => secureedge5410.h} (79%)
 delete mode 100644 arch/sh/include/mach-common/mach/systemh7751.h
