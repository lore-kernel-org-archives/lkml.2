Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401Ab2JARcO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 13:32:14 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57810 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab2JARcN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 13:32:13 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
User-Agent: alot/0.3.2+
To: torvalds@linux-foundation.org
Message-ID: <20121001173158.12878.37886@nucleus>
Subject: [GIT PULL] clk: changes for 3.7
Date: Mon, 01 Oct 2012 10:31:58 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit fea7a08acb13524b47711625eebea40a0ede69a0:

  Linux 3.6-rc3 (2012-08-22 13:29:06 -0700)

are available in the git repository at:

  git://git.linaro.org/people/mturquette/linux.git tags/clk-for-linus

for you to fetch changes up to 494bfec99922d54054d2d0873f1017680cfc3f13:

  clk: add of_clk_src_onecell_get() support (2012-09-07 18:30:19 -0700)

----------------------------------------------------------------
The common clk framework changes for 3.7 are dominated by ARM platform
ports to the framework along with one MIPS port, one MFD port, one minor
framework enhancement and one helper function for platforms expressing
their clock data through device tree.

----------------------------------------------------------------
Barry Song (1):
      clk: prima2: move from arch/arm/mach to drivers/clk

Binghua Duan (1):
      ARM: PRIMA2: convert to common clk and finish full clk tree

Chao Xie (5):
      clk: mmp: add mmp specific clocks
      clk: mmp: add clock definition for pxa168
      clk: mmp: add clock definition for pxa910
      clk: mmp: add clock definition for mmp2
      arm: mmp: make all SOCs use common clock by default

Jonghwa Lee (1):
      clock: max77686: Add driver for Maxim 77686 32Khz crystal oscillator.

Kelvin Cheung (1):
      clk: add Loongson1B clock support

Linus Walleij (2):
      clk: convert ARM RealView to common clk
      clk: versatile: make config option boolean

Michel Jaouen (1):
      mfd: dbx500: Provide a more accurate smp_twd clock

Shawn Guo (1):
      clk: add of_clk_src_onecell_get() support

Ulf Hansson (7):
      clk: ux500: Adapt PRCMU and PRCC clocks for common clk
      clk: ux500: First version of clock definitions for ux500
      clk: ux500: Clock definitions for u8500
      ARM: ux500: Switch to use common clock framework
      clk: Provide option for clk_get_rate to issue hw for new rate
      clk: ux500: Support for prmcu_rate clock
      clk: ux500: Define smp_twd clock for u8500

 arch/arm/Kconfig                             |    9 +-
 arch/arm/mach-mmp/Kconfig                    |    3 +
 arch/arm/mach-prima2/Makefile                |    1 -
 arch/arm/mach-prima2/clock.c                 |  510 -----------
 arch/arm/mach-prima2/prima2.c                |    1 -
 arch/arm/mach-prima2/timer.c                 |    8 +-
 arch/arm/mach-realview/core.c                |  106 ---
 arch/arm/mach-realview/include/mach/clkdev.h |   16 -
 arch/arm/mach-realview/realview_eb.c         |    2 +
 arch/arm/mach-realview/realview_pb1176.c     |    2 +
 arch/arm/mach-realview/realview_pb11mp.c     |    2 +
 arch/arm/mach-realview/realview_pba8.c       |    2 +
 arch/arm/mach-realview/realview_pbx.c        |    2 +
 arch/arm/mach-ux500/Kconfig                  |    1 +
 arch/arm/mach-ux500/Makefile                 |    2 +-
 arch/arm/mach-ux500/clock.c                  |  715 ----------------
 arch/arm/mach-ux500/clock.h                  |  164 ----
 arch/arm/mach-ux500/cpu.c                    |   14 +-
 drivers/clk/Kconfig                          |   13 +
 drivers/clk/Makefile                         |    9 +-
 drivers/clk/clk-ls1x.c                       |  111 +++
 drivers/clk/clk-max77686.c                   |  244 ++++++
 drivers/clk/clk-prima2.c                     | 1171 ++++++++++++++++++++++++++
 drivers/clk/clk.c                            |   57 +-
 drivers/clk/mmp/Makefile                     |    9 +
 drivers/clk/mmp/clk-apbc.c                   |  152 ++++
 drivers/clk/mmp/clk-apmu.c                   |   97 +++
 drivers/clk/mmp/clk-frac.c                   |  153 ++++
 drivers/clk/mmp/clk-mmp2.c                   |  449 ++++++++++
 drivers/clk/mmp/clk-pxa168.c                 |  346 ++++++++
 drivers/clk/mmp/clk-pxa910.c                 |  320 +++++++
 drivers/clk/mmp/clk.h                        |   35 +
 drivers/clk/ux500/Makefile                   |   12 +
 drivers/clk/ux500/clk-prcc.c                 |  164 ++++
 drivers/clk/ux500/clk-prcmu.c                |  252 ++++++
 drivers/clk/ux500/clk.h                      |   48 ++
 drivers/clk/ux500/u8500_clk.c                |  477 +++++++++++
 drivers/clk/ux500/u8540_clk.c                |   21 +
 drivers/clk/ux500/u9540_clk.c                |   21 +
 drivers/clk/versatile/Makefile               |    1 +
 drivers/clk/versatile/clk-realview.c         |  114 +++
 drivers/mfd/db8500-prcmu.c                   |   42 +
 drivers/mfd/dbx500-prcmu-regs.h              |    4 +-
 include/linux/clk-provider.h                 |    6 +
 include/linux/mfd/dbx500-prcmu.h             |    1 +
 include/linux/platform_data/clk-realview.h   |    1 +
 include/linux/platform_data/clk-ux500.h      |   17 +
 47 files changed, 4360 insertions(+), 1547 deletions(-)
 delete mode 100644 arch/arm/mach-prima2/clock.c
 delete mode 100644 arch/arm/mach-realview/include/mach/clkdev.h
 delete mode 100644 arch/arm/mach-ux500/clock.c
 delete mode 100644 arch/arm/mach-ux500/clock.h
 create mode 100644 drivers/clk/clk-ls1x.c
 create mode 100644 drivers/clk/clk-max77686.c
 create mode 100644 drivers/clk/clk-prima2.c
 create mode 100644 drivers/clk/mmp/Makefile
 create mode 100644 drivers/clk/mmp/clk-apbc.c
 create mode 100644 drivers/clk/mmp/clk-apmu.c
 create mode 100644 drivers/clk/mmp/clk-frac.c
 create mode 100644 drivers/clk/mmp/clk-mmp2.c
 create mode 100644 drivers/clk/mmp/clk-pxa168.c
 create mode 100644 drivers/clk/mmp/clk-pxa910.c
 create mode 100644 drivers/clk/mmp/clk.h
 create mode 100644 drivers/clk/ux500/Makefile
 create mode 100644 drivers/clk/ux500/clk-prcc.c
 create mode 100644 drivers/clk/ux500/clk-prcmu.c
 create mode 100644 drivers/clk/ux500/clk.h
 create mode 100644 drivers/clk/ux500/u8500_clk.c
 create mode 100644 drivers/clk/ux500/u8540_clk.c
 create mode 100644 drivers/clk/ux500/u9540_clk.c
 create mode 100644 drivers/clk/versatile/clk-realview.c
 create mode 100644 include/linux/platform_data/clk-realview.h
 create mode 100644 include/linux/platform_data/clk-ux500.h
