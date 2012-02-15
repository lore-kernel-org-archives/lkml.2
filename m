Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777Ab2BOGf1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 01:35:27 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:52941 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756368Ab2BOGf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 01:35:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] arm-soc fixes for 3.3-rc4
Date: Wed, 15 Feb 2012 06:32:40 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202150632.40316.arnd@arndb.de>
X-Provags-ID: V02:K0:sNAfVNro1B3p9xtKNdIgCkt5/lnq6I7pntv6o/EP2gd
 P/fF3Il3P7aDPacX6dTObPraAfhbkkv1ZjwdIzYngiEx0rdLYI
 ti93F6WiN4X10/k/GFZRB2HMorJ26JA+QZMOn9nxRKfSkBnRTK
 64GGEo0ETCc3A1CgoBOweLj5lKfgCp0Lt/axVDHLWOwJwTWWxI
 8UCS7BIwrCZeIH7JgCPNTGOIdWFGylkbermP9znQrDBgyEvKBn
 7P7aNAWOsBp169b5L4DQUPtzoUGPV0mQGyt9w5FnrpbV27zHK2
 SJ3nWgQjMEFIz7DYdKXwqZttHgHPQH90u7UH4EpZ6Y/lMZCiT8
 AGFruZxwqCmCHuImsmc0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

We've got a number of new patches queued up for 3.3. The majority of these
are regression fixes for stuff that broke during the merge window.

The notable ones are:

* The at91 ata drivers both broke because of an earlier cleanup patch that
  some other patches were based on. Jean-Christophe decided to remove
  the legacy at91_ide driver and fix the new-style at91-pata driver while
  keeping the cleanup patch. I almost rejected the patches for being too
  late and too big but in the end decided to accept them because they
  fix a regression.

* A patch fixing build breakage from the sysdev-to-device conversion
  colliding with other changes touches a number of mach-s3c files.

* b0654037 "ARM: orion: Fix Orion5x GPIO regression from MPP cleanup"
  is a mechanical change that unfortunately touches a lot of lines
  that should up in the diffstat.

	Arnd

The following changes since commit d65b4e98d7ea3038b767b70fe8be959b2913f16d:

  Linux 3.3-rc3 (2012-02-08 19:21:53 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git fixes (branch)
  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git fixes-3.3-rc4 (tag)

Andrew Lunn (2):
      ARM: orion: Fix Orion5x GPIO regression from MPP cleanup
      ARM: orion: Fix USB phy for orion5x.

Arnd Bergmann (4):
      Merge branch 'fixes' of git://git.kernel.org/.../olof/tegra into fixes
      Merge branch 'v3.3-samsung-fixes-3' of git://git.kernel.org/.../kgene/linux-samsung into fixes
      Merge branch 'fixes' of git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge branch 'at91-fixes' of git://github.com/at91linux/linux-at91 into fixes

Benoit Cousson (1):
      ARM: OMAP2+: board-generic: Add missing handle_irq callbacks

H Hartley Sweeten (1):
      ep93xx: fix build of vision_ep93xx.c

Heiko Stuebner (1):
      ARM: SAMSUNG: Fix missing api-change from subsys_interface change

Igor Grinberg (1):
      ARM: OMAP3: cm-t35: fix section mismatch warning

Jean-Christophe PLAGNIOL-VILLARD (4):
      ARM: at91:rtc/rtc-at91sam9: ioremap register bank
      ARM: at91: add accessor to manage SMC
      pata/at91: use newly introduced SMC accessors
      ARM: at91: drop ide driver in favor of the pata one

Jonghwan Choi (1):
      ARM: EXYNOS: Fix "warning: initialization from incompatible pointer type"

Karol Lewandowski (1):
      ARM: EXYNOS: Bring exynos4-dt up to date

Kukjin Kim (2):
      ARM: EXYNOS: Remove build warning without enabling PM
      ARM: S5PV210: Fix the name of exynos4_clk_hdmiphy_ctrl() for S5PV210

Marc Dietrich (2):
      ARM: tegra: paz00: fix wrong SD1 power gpio
      ARM: tegra: paz00: fix wrong UART port on mini-pcie plug

Marek Szyprowski (1):
      ARM: EXYNOS: fix non-SMP builds for EXYNOS4

Mark Brown (2):
      ARM: S3C64XX: Make s3c64xx_init_uarts() static
      ARM: S3C6410: Use device names for both I2C clocks

Nicolas Ferre (1):
      ARM: at91: USB AT91 gadget registration for module

Olof Johansson (2):
      ARM: tegra: dma: fix buildbreak for !CONFIG_TEGRA_SYSTEM_DMA
      Merge branch 'v3.3-samsung-fixes-2' of git://git.kernel.org/.../kgene/linux-samsung into fixes

Paul Walmsley (1):
      ARM: OMAP2xxx: PM: fix OMAP2xxx-specific UART idle bug in v3.3

Santosh Shilimkar (1):
      ARM: OMAP2: Fix the OMAP2 only build break seen with 2011+ ARM tool-chains

Shubhrajyoti Datta (1):
      i2c: tegra: Add devexit_p() for remove

Sylwester Nawrocki (3):
      ARM: SAMSUNG: Fix platform data setup for I2C adapter 0
      ARM: EXYNOS: Correct framebuffer window size on Nuri board
      ARM: EXYNOS: Correct M-5MOLS sensor clock frequency on Universal C210 board

Thomas Abraham (1):
      ARM: EXYNOS: Add cpu-offset property in gic device tree node

Tony Lindgren (1):
      Merge branch 'fixes-dt' into fixes

 arch/arm/boot/dts/exynos4210.dtsi              |    1 +
 arch/arm/boot/dts/tegra-paz00.dts              |    6 +-
 arch/arm/mach-at91/at91rm9200_devices.c        |    2 +-
 arch/arm/mach-at91/at91sam9260_devices.c       |    9 +-
 arch/arm/mach-at91/at91sam9261_devices.c       |    2 +-
 arch/arm/mach-at91/at91sam9263_devices.c       |    8 +-
 arch/arm/mach-at91/include/mach/at91sam9_smc.h |   29 ++
 arch/arm/mach-at91/sam9_smc.c                  |   76 +++++-
 arch/arm/mach-at91/sam9_smc.h                  |   23 --
 arch/arm/mach-dove/common.c                    |    3 +-
 arch/arm/mach-ep93xx/vision_ep9307.c           |    4 +-
 arch/arm/mach-exynos/clock-exynos4210.c        |    2 +
 arch/arm/mach-exynos/clock-exynos4212.c        |    2 +
 arch/arm/mach-exynos/clock.c                   |    2 +
 arch/arm/mach-exynos/mach-exynos4-dt.c         |    8 +-
 arch/arm/mach-exynos/mach-nuri.c               |    8 +-
 arch/arm/mach-exynos/mach-universal_c210.c     |    2 +-
 arch/arm/mach-exynos/pm.c                      |    4 +-
 arch/arm/mach-kirkwood/common.c                |    3 +-
 arch/arm/mach-kirkwood/mpp.h                   |  320 +++++++++++-----------
 arch/arm/mach-mv78xx0/common.c                 |    3 +-
 arch/arm/mach-mv78xx0/mpp.h                    |  226 ++++++++--------
 arch/arm/mach-omap2/Makefile                   |    4 +-
 arch/arm/mach-omap2/board-cm-t35.c             |    2 +-
 arch/arm/mach-omap2/board-generic.c            |    4 +
 arch/arm/mach-omap2/pm24xx.c                   |    8 +-
 arch/arm/mach-orion5x/common.c                 |    4 +-
 arch/arm/mach-s3c2410/cpu-freq.c               |    8 +-
 arch/arm/mach-s3c2410/dma.c                    |    5 +-
 arch/arm/mach-s3c2410/pll.c                    |    2 +-
 arch/arm/mach-s3c2410/pm.c                     |    2 +-
 arch/arm/mach-s3c2412/cpu-freq.c               |    3 +-
 arch/arm/mach-s3c2412/dma.c                    |    3 +-
 arch/arm/mach-s3c2412/irq.c                    |    2 +-
 arch/arm/mach-s3c2412/pm.c                     |    2 +-
 arch/arm/mach-s3c2416/irq.c                    |    3 +-
 arch/arm/mach-s3c2416/pm.c                     |    2 +-
 arch/arm/mach-s3c2440/clock.c                  |    2 +-
 arch/arm/mach-s3c2440/dma.c                    |    3 +-
 arch/arm/mach-s3c2440/irq.c                    |    2 +-
 arch/arm/mach-s3c2440/s3c2440-cpufreq.c        |    3 +-
 arch/arm/mach-s3c2440/s3c2440-pll-12000000.c   |    2 +-
 arch/arm/mach-s3c2440/s3c2440-pll-16934400.c   |    3 +-
 arch/arm/mach-s3c2440/s3c2442.c                |    2 +-
 arch/arm/mach-s3c2440/s3c244x-clock.c          |    2 +-
 arch/arm/mach-s3c2440/s3c244x-irq.c            |    2 +-
 arch/arm/mach-s3c2443/dma.c                    |    3 +-
 arch/arm/mach-s3c2443/irq.c                    |    3 +-
 arch/arm/mach-s3c64xx/clock.c                  |    5 +
 arch/arm/mach-s3c64xx/common.c                 |    2 +-
 arch/arm/mach-s5p64x0/pm.c                     |    2 +-
 arch/arm/mach-s5pv210/clock.c                  |    4 +-
 arch/arm/mach-s5pv210/pm.c                     |    2 +-
 arch/arm/mach-tegra/board-paz00.c              |    8 +-
 arch/arm/mach-tegra/board-paz00.h              |    2 +-
 arch/arm/mach-tegra/include/mach/dma.h         |   10 +-
 arch/arm/plat-omap/include/plat/omap-secure.h  |    2 +-
 arch/arm/plat-orion/common.c                   |    9 +-
 arch/arm/plat-orion/include/plat/common.h      |    3 +-
 arch/arm/plat-orion/mpp.c                      |    3 +-
 arch/arm/plat-samsung/devs.c                   |    4 +-
 drivers/ata/pata_at91.c                        |   48 ++--
 drivers/i2c/busses/i2c-tegra.c                 |    2 +-
 drivers/ide/Makefile                           |    1 -
 drivers/ide/at91_ide.c                         |  366 ------------------------
 drivers/rtc/rtc-at91sam9.c                     |   13 +-
 66 files changed, 524 insertions(+), 786 deletions(-)
 delete mode 100644 drivers/ide/at91_ide.c
