Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab1EXDCL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 23:02:11 -0400
Received: from linux-sh.org ([111.68.239.195]:59083 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125Ab1EXDCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 23:02:08 -0400
Date: Tue, 24 May 2011 12:01:47 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.40-rc1
Message-ID: <20110524030134.GB11986@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git sh-latest

Which contains:

Guennadi Liakhovetski (8):
      sh: fix SD / MMC configuration dependencies on ecovec
      sh: update SDHI configuration symbols in defconfigs
      ALSA: add a module alias to the FSI driver
      i2c: add a module alias to the sh-mobile driver
      sh: cosmetic improvement: use an existing pointer
      dmaengine: shdma: fix locking
      dmaengine: shdma: add runtime- and system-level power management
      dmaengine: shdma: synchronize RCU before freeing, simplify spinlock

Kuninori Morimoto (2):
      sh: clkfwk: fixup clk_rate_table_build parameter in div6 clock
      sh: fixup fpu.o compile order

Magnus Damm (7):
      serial: sh-sci: Runtime PM support
      serial: sh-sci: suspend/resume wakeup support V2
      sh: sh-sci: sh7377 and sh73a0 build fixes
      clocksource: sh_cmt: __clocksource_updatefreq_hz() update
      clocksource: sh_cmt: Runtime PM support
      clocksource: sh_tmu: __clocksource_updatefreq_hz() update
      clocksource: sh_tmu: Runtime PM support

Paul Mundt (4):
      sh: intc: Set virtual IRQs as nothread.
      sh: select IRQ_FORCED_THREADING.
      sh: wire up sys_sendmmsg.
      sh: Ignore R_SH_NONE module relocations.

Ralf Baechle (1):
      SH: SE7751: Fix pcibios_map_platform_irq prototype.

Richard Weinberger (1):
      sh: remove warning and warning_symbol from struct stacktrace_ops

 arch/sh/Kconfig                          |    1 +
 arch/sh/boards/mach-ecovec24/setup.c     |   18 ++--
 arch/sh/configs/ecovec24_defconfig       |    2 +-
 arch/sh/configs/sh7757lcr_defconfig      |    2 +-
 arch/sh/drivers/pci/fixups-se7751.c      |    2 +-
 arch/sh/include/asm/stacktrace.h         |    3 -
 arch/sh/include/asm/unistd_32.h          |    3 +-
 arch/sh/include/asm/unistd_64.h          |    3 +-
 arch/sh/kernel/cpu/Makefile              |    4 +-
 arch/sh/kernel/cpu/shmobile/pm_runtime.c |    6 +-
 arch/sh/kernel/dumpstack.c               |   15 ---
 arch/sh/kernel/module.c                  |    2 +
 arch/sh/kernel/perf_callchain.c          |   12 --
 arch/sh/kernel/stacktrace.c              |   13 --
 arch/sh/kernel/syscalls_32.S             |    1 +
 arch/sh/kernel/syscalls_64.S             |    1 +
 arch/sh/oprofile/backtrace.c             |   13 --
 drivers/clocksource/sh_cmt.c             |   31 +++---
 drivers/clocksource/sh_tmu.c             |   31 +++--
 drivers/dma/shdma.c                      |  188 +++++++++++++++++++++++-------
 drivers/dma/shdma.h                      |    1 +
 drivers/i2c/busses/i2c-sh_mobile.c       |    1 +
 drivers/sh/clk/cpg.c                     |    2 +-
 drivers/sh/intc/virq.c                   |    5 +
 drivers/tty/serial/sh-sci.c              |   16 +++-
 drivers/tty/serial/sh-sci.h              |   16 ++--
 26 files changed, 235 insertions(+), 157 deletions(-)
