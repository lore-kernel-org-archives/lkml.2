Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab2LNWF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 17:05:26 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:49008 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755621Ab2LNWFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 17:05:21 -0500
Date: Fri, 14 Dec 2012 14:05:20 -0800
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL 1/3] ARM: arm-soc: SoC updates, take 2
Message-ID: <20121214220520.GB11363@quad.lixom.net>
References: <20121214220441.GA11363@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121214220441.GA11363@quad.lixom.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the second batch of SoC updates for the 3.8 merge window,
containing parts that had dependencies on earlier branches such that we
couldn't include them with the first branch.

These are general updates for Samsung Exynos, Renesas/shmobile and a
topic branch that adds SMP support to Altera's socfpga platform.


Conflicts seen with this merge:

arch/arm/boot/dts/exynos5250.dtsi:
First is add/add. Keep both sides.
For the i2c node, keep the one with the label in front from the branch.

arch/arm/mach-exynos/include/mach/regs-pmu.h:
Add/remove. Keep the SYS_I2C_CFG one, drop USB_CFG.

arch/arm/mach-exynos/mach-exynos5-dt.c:
Include conflict: Keep and of_fdt.h and io.h
Second conflict: Keep contents from branch, but replace last
of_platform_populate with the chunk from HEAD.

----------------------------------------------------------------

The following changes since commit d42b3a2906a10b732ea7d7f849d49be79d242ef0:

  Merge branch 'core-efi-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/soc2

for you to fetch changes up to c91321e8ff338a88a9272dcd938f085955cd5846:

  ARM: arm-soc: Merge branch 'next/smp' into next/soc2

----------------------------------------------------------------

Abhilash Kesavan (4):
      ARM: EXYNOS: Setup legacy i2c controller interrupts
      ARM: EXYNOS: Add aliases for i2c controller
      ARM: EXYNOS: Fix i2c suspend/resume for legacy controller
      ARM: EXYNOS: Add ARM down clock support

Arnd Bergmann (7):
      Merge branch 'socfpga/smp' into next/smp
      Merge branch 'vexpress-clk-soc' of git://git.linaro.org/people/pawelmoll/linux into next/soc2
      ARM: socfpga: mark secondary_trampoline as cpuinit
      Merge branch 'next/boards2' into next/soc2
      Merge branch 'soc2' of git://git.kernel.org/.../horms/renesas into next/soc2
      Merge branches 'devel/debug_ll_init' and 'calxeda/ecx-2000' into next/soc2
      Merge branch 'soc4' of git://git.kernel.org/.../horms/renesas into next/soc2

Colin Cross (2):
      ARM: SAMSUNG: add clock_tree debugfs file in clock
      ARM: SAMSUNG: call clk_get_rate for debugfs rate files

Dinh Nguyen (1):
      ARM: socfpga: Enable SMP for socfpga

Jingoo Han (1):
      ARM: EXYNOS: Add dp clock support for EXYNOS5

Kukjin Kim (1):
      Merge branch 'next/hdmi-samsung' into next/devel-samsung

Kuninori Morimoto (3):
      ARM: shmobile: sh7372: remove fsidivx clock
      ARM: shmobile: sh7372: sh7372_fsiXck_clk become non-global
      sh: clkfwk: fixup unsed variable warning

Olof Johansson (2):
      Merge branch 'next/devel-samsung' of git://git.kernel.org/.../kgene/linux-samsung into next/soc2
      ARM: arm-soc: Merge branch 'next/smp' into next/soc2

Pavel Machek (2):
      ARM: socfpga: fix build break for allyesconfig
      socfpga: map uart into virtual address space so that early_printk() works

Rob Herring (1):
      ARM: highbank: use common debug_ll_io_init

Simon Horman (3):
      Revert "ARM: shmobile: emev2: Replace modify_scu_cpu_psr with scu_power_mode"
      Revert "ARM: shmobile: sh73a0: Replace modify_scu_cpu_psr with scu_power_mode"
      Revert "ARM: shmobile: r8a7779: Replace modify_scu_cpu_psr with scu_power_mode"

Vasanth Ananthan (1):
      ARM: EXYNOS: Clock settings for SATA and SATA PHY


 .../bindings/arm/altera/socfpga-reset.txt       |  11 ++
 .../bindings/arm/altera/socfpga-system.txt      |  11 ++
 arch/arm/boot/dts/exynos5250.dtsi               |  27 +++--
 arch/arm/boot/dts/socfpga.dtsi                  |  10 ++
 arch/arm/configs/socfpga_defconfig              |   3 +-
 arch/arm/mach-exynos/clock-exynos5.c            |  28 ++++-
 arch/arm/mach-exynos/cpuidle.c                  |  36 ++++++
 arch/arm/mach-exynos/include/mach/regs-clock.h  |  19 +++
 arch/arm/mach-exynos/include/mach/regs-pmu.h    |   3 +
 arch/arm/mach-exynos/mach-exynos5-dt.c          |  25 +++-
 arch/arm/mach-exynos/pm.c                       |   9 ++
 arch/arm/mach-shmobile/clock-sh7372.c           |  20 ++--
 arch/arm/mach-shmobile/include/mach/sh7372.h    |   2 -
 arch/arm/mach-shmobile/smp-emev2.c              |  22 +++-
 arch/arm/mach-shmobile/smp-r8a7779.c            |  25 +++-
 arch/arm/mach-shmobile/smp-sh73a0.c             |  23 +++-
 arch/arm/mach-socfpga/Kconfig                   |   1 +
 arch/arm/mach-socfpga/Makefile                  |   1 +
 arch/arm/mach-socfpga/core.h                    |  34 ++++++
 arch/arm/mach-socfpga/headsmp.S                 |  25 ++++
 arch/arm/mach-socfpga/platsmp.c                 | 116 +++++++++++++++++++
 arch/arm/mach-socfpga/socfpga.c                 |  54 ++++++++-
 arch/arm/plat-samsung/clock.c                   |  75 +++++++++++-
 drivers/sh/clk/cpg.c                            |   1 -
 24 files changed, 544 insertions(+), 37 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-reset.txt
 create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-system.txt
 create mode 100644 arch/arm/mach-socfpga/core.h
 create mode 100644 arch/arm/mach-socfpga/headsmp.S
 create mode 100644 arch/arm/mach-socfpga/platsmp.c
