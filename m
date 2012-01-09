Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933440Ab2AIWOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 17:14:08 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:62730 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933385Ab2AIWOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 17:14:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL 05/11] SoC-level changes for tegra and omap
Date: Mon,  9 Jan 2012 22:12:45 +0000
Message-Id: <1326147171-13752-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1326147171-13752-1-git-send-email-arnd@arndb.de>
References: <1326147171-13752-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:3i1USYGfHoDOkQNV6E/L+w+7BFu+YqwXvqjYEmJ/TyX
 5VGbFKX1Tewt/8GUw1ZhVLappc8q5ZjVspBn/8e3g4seiuf0IG
 49yyqcE/dsQBDTk2Tn6FS5FEFRKHc45uY8WJAYHMgtM7VKAiST
 yuu3BQw1sAdaFjfhzW+n01+i6Jxj5t8BP1fQ+7XVv0A0f6U3KI
 txlPkcijtkdaHU2TzxmWrv26pspCUWfWrWcNUb1SiU9q1s4Agq
 acOF4OyvDUsbw4PjAqczDyQLP1HAKzqGKfzohkg44uynEBgEzM
 mN1Zhuo9SPJjHrldFqeReh83zvfiqBZFAxDrzla9hXo8q6jtVK
 ISL1aLQ8sZr9O/ZYu0qiq2qj3A3y4KNtEC2w3+p6RIvnPKTN/M
 BIdgB9l7Os1Sw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for the new tegra30 SoC, as well as small
changes to support minor variations of existing omap SoCs.

The following changes since commit d2e23116daa06376bf18408191042da416f94578:

  Merge branch 'next/cleanup2' into for-next3 (2012-01-09 16:47:52 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git next/soc

Afzal Mohammed (2):
      ARM: OMAP: am33xx: Update common omap platform files
      ARM: OMAP: am33xx: Update common OMAP machine specific sources

Arnd Bergmann (4):
      Merge branch 'for-3.3/soc' of git://git.kernel.org/.../olof/tegra into tegra/soc
      Merge branches 'depends/rmk/devel-stable' and 'tegra/dt' into next/soc
      Merge branch 'tegra/soc' into next/soc
      Merge branch 'depends/rmk/for-linus' into next/soc

David Anders (1):
      ARM: OMAP: id: add chip id recognition for omap4430 es2.3

Hemant Pedanekar (2):
      ARM: OMAP: TI81XX: Prepare for addition of TI814X support
      ARM: OMAP: TI814X: Add cpu type macros and detection support

Leonid Iziumtsev (1):
      ARM: OMAP: ID: Chip detection for OMAP4470

Olof Johansson (4):
      Merge branch 'soc' of git://git.kernel.org/.../tmlind/linux-omap into omap/soc
      Merge branch 'omap/soc' into next/soc
      Merge remote-tracking branch 'rmk/devel-stable' into for-3.3/soc
      arm/tegra: refresh defconfig for tegra30

Peter De Schrijver (14):
      arm/tegra: clk_get should not be fatal
      arm/tegra: cleanup tegra20 support
      arm/tegra: prepare clock code for multiple tegra variants
      arm/tegra: don't export clk_measure_input_freq
      arm/tegra: prepare early init for multiple tegra variants
      arm/tegra: rename board-dt.c to board-dt-tegra20.c
      arm/tegra: use PMC reset
      arm/tegra: generalize L2 cache initialization
      arm/tegra: rename tegra20 pinmux files
      arm/tegra: prepare pinmux code for multiple tegra variants
      arm/tegra: add new fields to struct tegra_pingroup_desc
      arm/tegra: pinmux tables and definitions for tegra30
      arm/tegra: implement support for tegra30
      arm/tegra: add support for tegra30 based board cardhu

Stephen Warren (5):
      arm/tegra: Fix section mismatch errors in tegra20 pinmux
      arm/tegra: Fix section mismatch errors in tegra30 pinmux
      arm/tegra: Delete tegra_init_clock()
      arm/tegra: Make MACH_TEGRA_DT depend on ARCH_TEGRA_2x_SOC
      arm/tegra: Compile tegra_dt_init_irq only when CONFIG_OF

 arch/arm/boot/dts/tegra-cardhu.dts                |   36 ++
 arch/arm/configs/tegra_defconfig                  |    9 +-
 arch/arm/mach-omap2/Kconfig                       |   11 +-
 arch/arm/mach-omap2/board-ti8168evm.c             |   11 +-
 arch/arm/mach-omap2/clock.c                       |    2 +-
 arch/arm/mach-omap2/clock.h                       |    2 +-
 arch/arm/mach-omap2/clock3xxx_data.c              |    6 +-
 arch/arm/mach-omap2/common.c                      |   48 ++-
 arch/arm/mach-omap2/common.h                      |   23 +-
 arch/arm/mach-omap2/control.h                     |    8 +-
 arch/arm/mach-omap2/id.c                          |   52 +++-
 arch/arm/mach-omap2/include/mach/debug-macro.S    |   12 +-
 arch/arm/mach-omap2/io.c                          |   38 ++-
 arch/arm/mach-omap2/irq.c                         |    2 +-
 arch/arm/mach-omap2/opp2xxx.h                     |    2 +-
 arch/arm/mach-omap2/serial.c                      |    6 +-
 arch/arm/mach-tegra/Kconfig                       |   31 ++-
 arch/arm/mach-tegra/Makefile                      |    9 +-
 arch/arm/mach-tegra/Makefile.boot                 |    1 +
 arch/arm/mach-tegra/board-dt-tegra20.c            |  149 ++++++++
 arch/arm/mach-tegra/board-dt-tegra30.c            |   63 ++++
 arch/arm/mach-tegra/board-dt.c                    |  160 ---------
 arch/arm/mach-tegra/board-harmony-pcie.c          |    1 +
 arch/arm/mach-tegra/board-harmony-pinmux.c        |    1 +
 arch/arm/mach-tegra/board-harmony.c               |    2 +-
 arch/arm/mach-tegra/board-paz00-pinmux.c          |    1 +
 arch/arm/mach-tegra/board-paz00.c                 |    2 +-
 arch/arm/mach-tegra/board-seaboard-pinmux.c       |    2 +-
 arch/arm/mach-tegra/board-seaboard.c              |    6 +-
 arch/arm/mach-tegra/board-trimslice-pinmux.c      |    1 +
 arch/arm/mach-tegra/board-trimslice.c             |    2 +-
 arch/arm/mach-tegra/board.h                       |    5 +-
 arch/arm/mach-tegra/clock.c                       |   25 +--
 arch/arm/mach-tegra/clock.h                       |    4 -
 arch/arm/mach-tegra/common.c                      |   55 +++-
 arch/arm/mach-tegra/include/mach/clk.h            |    2 +-
 arch/arm/mach-tegra/include/mach/irqs.h           |    2 -
 arch/arm/mach-tegra/include/mach/pinmux-t2.h      |  184 ----------
 arch/arm/mach-tegra/include/mach/pinmux-tegra20.h |  184 ++++++++++
 arch/arm/mach-tegra/include/mach/pinmux-tegra30.h |  320 ++++++++++++++++++
 arch/arm/mach-tegra/include/mach/pinmux.h         |   88 ++++-
 arch/arm/mach-tegra/pinmux-t2-tables.c            |  228 -------------
 arch/arm/mach-tegra/pinmux-tegra20-tables.c       |  244 +++++++++++++
 arch/arm/mach-tegra/pinmux-tegra30-tables.c       |  376 +++++++++++++++++++++
 arch/arm/mach-tegra/pinmux.c                      |  153 ++++++---
 arch/arm/mach-tegra/tegra2_clocks.c               |   19 +-
 arch/arm/mach-tegra/timer.c                       |   18 +-
 arch/arm/plat-omap/Makefile                       |    1 -
 arch/arm/plat-omap/include/plat/am33xx.h          |   25 ++
 arch/arm/plat-omap/include/plat/clock.h           |    4 +-
 arch/arm/plat-omap/include/plat/cpu.h             |   56 +++
 arch/arm/plat-omap/include/plat/hardware.h        |    3 +-
 arch/arm/plat-omap/include/plat/io.h              |   12 +
 arch/arm/plat-omap/include/plat/omap34xx.h        |    2 +
 arch/arm/plat-omap/include/plat/serial.h          |   14 +-
 arch/arm/plat-omap/include/plat/ti816x.h          |   27 --
 arch/arm/plat-omap/include/plat/ti81xx.h          |   27 ++
 arch/arm/plat-omap/include/plat/uncompress.h      |    8 +-
 58 files changed, 1967 insertions(+), 818 deletions(-)
