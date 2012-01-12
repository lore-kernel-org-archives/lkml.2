Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab2ALGvy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 01:51:54 -0500
Received: from linux-sh.org ([111.68.239.195]:55028 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756Ab2ALGvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 01:51:51 -0500
Date: Thu, 12 Jan 2012 15:51:48 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] rmobile updates for 3.3-rc1
Message-ID: <20120112065147.GA1876@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The diffstat here is a bit misleading since it also includes some changes
that were pulled in from one of the sh topic branches which will have
already made their way upstream via the sh merge. This mostly applies to
clock framework and pfc changes that were needed in both trees. Thus,
most of the arch/sh and drivers/sh stuff can just be factored out when
looking at the net impact.

I could have simply made the pull request based on top of the last change
from the sh topic branch in question, but that seemed to be misleading
too, so I've just done it this way instead.

The following changes since commit a0e86bd4252519321b0d102dc4ed90557aa7bee9:

  audit: always follow va_copy() with va_end() (2012-01-08 14:15:21 -0800)

are available in the git repository at:

  git://github.com/pmundt/linux-sh rmobile-for-linus

for you to fetch changes up to e64e1b11b14d363ac70fd13ab809969a6d7e42a8:

  Merge branch 'rmobile/smp' into rmobile-latest (2012-01-12 12:20:18 +0900)

----------------------------------------------------------------

SH/R-Mobile updates for 3.3 merge window.

----------------------------------------------------------------
Kuninori Morimoto (16):
      ARM: mach-shmobile: R-Mobile A1 support.
      ARM: mach-shmobile: r8a7740: add PFC support.
      ARM: mach-shmobile: r8a7740: add i2c support
      ARM: mach-shmobile: r8a7740: add INTC support
      ARM: mach-shmobile: add bonito board support.
      ARM: mach-shmobile: bonito: Add dip-switch selector
      ARM: mach-shmobile: bonito: add PMIC settings
      ARM: mach-shmobile: bonito: Add LCDC0 support
      ARM: mach-shmobile: bonito: add FPGA irq demux
      ARM: mach-shmobile: bonito: add SMSC9221 support
      sh: clkfwk: setup clock parent from current register value
      sh: clock-sh7723: add CLKDEV_ICK_ID for cleanup
      sh: clkfwk: clock-sh7724: all div6_clks use SH_CLK_DIV6_EXT()
      sh: clkfwk: clock-sh73a0: all div6_clks use SH_CLK_DIV6_EXT()
      ARM: mach-shmobile: clock-r8a7779: add DIV4 clock support
      ARM: mach-shmobile: clock-r8a7779: clkz/clkzs support

Magnus Damm (20):
      sh: extend clock struct with mapped_reg member
      sh: use ioread32/iowrite32 and mapped_reg for mstp32
      sh: use ioread32/iowrite32 and mapped_reg for div4
      sh: use ioread32/iowrite32 and mapped_reg for div6
      sh: pfc: ioremap() support
      sh: pfc: Add gpio_read_bit() for data register access
      sh: pfc: Convert index to field and value pair
      sh: pfc: Add config_reg_helper() function
      sh: pfc: Variable bitfield width config register support
      sh: pfc: Unlock register support
      ARM: mach-shmobile: r8a7779 and Marzen base support V2
      ARM: mach-shmobile: r8a7779 PFC GPIO-only support V2
      ARM: mach-shmobile: Marzen SCIF2/SCIF4 support
      ARM: mach-shmobile: Marzen LAN89218 support
      ARM: mach-shmobile: Fix headsmp.S code to use CPUINIT
      ARM: mach-shmobile: Allow SoC specific CPU kill code
      ARM: mach-shmobile: Flush caches in platform_cpu_die()
      ARM: mach-shmobile: r8a7779 PFC function support
      ARM: mach-shmobile: r8a7779 power domain support V2
      ARM: mach-shmobile: r8a7779 SMP support V3

Paul Mundt (12):
      ARM: mach-shmobile: Unset initramfs source in bonito defconfig.
      Merge branch 'rmobile/a1' into rmobile-latest
      Merge branch 'rmobile-fixes-for-linus' into rmobile-latest
      Merge branch 'master' of git://git.kernel.org/.../torvalds/linux into rmobile-latest
      Merge branches 'common/pfc' and 'common/clkfwk' into rmobile/marzen
      Merge branch 'rmobile/core' into rmobile/marzen
      ARM: mach-shmobile: Fix up marzen build for recent GIC changes.
      Merge branch 'rmobile/bonito' into rmobile-latest
      ARM: mach-shmobile: Add marzen defconfig.
      ARM: mach-shmobile: Add kota2 defconfig.
      Merge branches 'rmobile/kota2' and 'rmobile/marzen' into rmobile-latest
      Merge branch 'rmobile/smp' into rmobile-latest

Shimoda, Yoshihiro (1):
      arm: mach-shmobile: add a resource name for shdma

 arch/arm/configs/bonito_defconfig             |   72 +
 arch/arm/configs/kota2_defconfig              |  122 ++
 arch/arm/configs/marzen_defconfig             |   87 +
 arch/arm/mach-shmobile/Kconfig                |   27 +-
 arch/arm/mach-shmobile/Makefile               |    9 +
 arch/arm/mach-shmobile/board-bonito.c         |  522 +++++
 arch/arm/mach-shmobile/board-marzen.c         |  157 ++
 arch/arm/mach-shmobile/clock-r8a7740.c        |  382 ++++
 arch/arm/mach-shmobile/clock-r8a7779.c        |  176 ++
 arch/arm/mach-shmobile/clock-sh7372.c         |    6 +-
 arch/arm/mach-shmobile/clock-sh73a0.c         |  140 ++-
 arch/arm/mach-shmobile/headsmp.S              |    2 +-
 arch/arm/mach-shmobile/hotplug.c              |   32 +-
 arch/arm/mach-shmobile/include/mach/common.h  |   22 +
 arch/arm/mach-shmobile/include/mach/r8a7740.h |  584 ++++++
 arch/arm/mach-shmobile/include/mach/r8a7779.h |  363 ++++
 arch/arm/mach-shmobile/intc-r8a7740.c         |  631 ++++++
 arch/arm/mach-shmobile/intc-r8a7779.c         |   58 +
 arch/arm/mach-shmobile/pfc-r8a7740.c          | 2562 ++++++++++++++++++++++++
 arch/arm/mach-shmobile/pfc-r8a7779.c          | 2645 +++++++++++++++++++++++++
 arch/arm/mach-shmobile/platsmp.c              |   21 +
 arch/arm/mach-shmobile/pm-r8a7779.c           |  249 +++
 arch/arm/mach-shmobile/setup-r8a7740.c        |  352 ++++
 arch/arm/mach-shmobile/setup-r8a7779.c        |  239 +++
 arch/arm/mach-shmobile/setup-sh7372.c         |    6 +-
 arch/arm/mach-shmobile/setup-sh73a0.c         |    2 +-
 arch/arm/mach-shmobile/smp-r8a7779.c          |  153 ++
 arch/sh/include/cpu-sh4/cpu/sh7724.h          |    1 +
 arch/sh/kernel/cpu/sh4a/clock-sh7723.c        |   76 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7724.c        |   44 +-
 drivers/sh/clk/core.c                         |    9 +-
 drivers/sh/clk/cpg.c                          |   77 +-
 drivers/sh/pfc.c                              |  273 ++-
 drivers/tty/serial/sh-sci.h                   |    4 +-
 include/linux/sh_clk.h                        |   10 +-
 include/linux/sh_pfc.h                        |   22 +-
 36 files changed, 9910 insertions(+), 227 deletions(-)
 create mode 100644 arch/arm/configs/bonito_defconfig
 create mode 100644 arch/arm/configs/kota2_defconfig
 create mode 100644 arch/arm/configs/marzen_defconfig
 create mode 100644 arch/arm/mach-shmobile/board-bonito.c
 create mode 100644 arch/arm/mach-shmobile/board-marzen.c
 create mode 100644 arch/arm/mach-shmobile/clock-r8a7740.c
 create mode 100644 arch/arm/mach-shmobile/clock-r8a7779.c
 create mode 100644 arch/arm/mach-shmobile/include/mach/r8a7740.h
 create mode 100644 arch/arm/mach-shmobile/include/mach/r8a7779.h
 create mode 100644 arch/arm/mach-shmobile/intc-r8a7740.c
 create mode 100644 arch/arm/mach-shmobile/intc-r8a7779.c
 create mode 100644 arch/arm/mach-shmobile/pfc-r8a7740.c
 create mode 100644 arch/arm/mach-shmobile/pfc-r8a7779.c
 create mode 100644 arch/arm/mach-shmobile/pm-r8a7779.c
 create mode 100644 arch/arm/mach-shmobile/setup-r8a7740.c
 create mode 100644 arch/arm/mach-shmobile/setup-r8a7779.c
 create mode 100644 arch/arm/mach-shmobile/smp-r8a7779.c
