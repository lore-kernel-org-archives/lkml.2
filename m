Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748Ab2D1F2t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 01:28:49 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34382 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab2D1F2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 01:28:46 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
Date: Fri, 27 Apr 2012 22:28:45 -0700
Message-ID: <CAOesGMhTCF5g2bKxxMbT_0sbBEmHZqqqQ+7ZxTt2T-+bQPAWhQ@mail.gmail.com>
Subject: [GIT PULL] ARM: SoC fixes for 3.4-rc
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 66f75a5d028beaf67c931435fdc3e7823125730c:

  Linux 3.4-rc4 (2012-04-21 14:47:52 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git
tags/fixes-for-linus

for you to fetch changes up to 6e76538b9ef2b2a14ad9b57d65dc35d151765917:

  Merge branch 'v3.4-samsung-fixes-3' of
git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung into
fixes (2012-04-27 09:40:06 -0700)

----------------------------------------------------------------

ARM: SoC fixes for 3.4-rc

Nothing controversial, just another batch of fixes:

- Samsung/exynos fixes for more merge window fallout: build errors and
  warnings mostly, but also some clock/device setup issues on exynos4/5
- PXA bug and warning fixes related to gpio and pinmux
- IRQ domain conversion bugfixes for U300 and MSM
- A regulator setup fix for U300

----------------------------------------------------------------
Arnd Bergmann (1):
      ARM: mini2440_defconfig: Fix build error

David Brown (1):
      ARM: msm: Fix gic irqdomain support

Dmitry Artamonow (1):
      arm/sa1100: fix sa1100-rtc memory resource

Igor Grinberg (2):
      ARM: PXA2xx: MFP: fix bug with MFP_LPM_KEEP_OUTPUT
      ARM: PXA2xx: MFP: fix potential direction bug

Kukjin Kim (2):
      ARM: S3C24XX: Fix build warning for S3C2410_PM
      ARM: EXYNOS: Fix resource on dev-dwmci.c

Linus Walleij (1):
      ARM: u300: bump all IRQ numbers by one

Marek Szyprowski (1):
      ARM: SAMSUNG: add missing MMC_CAP2_BROKEN_VOLTAGE capability

Mark Brown (1):
      ARM: ux300: Fix unimplementable regulation constraints

Olof Johansson (4):
      Merge branch 'msm-fix' of
git://git.kernel.org/.../davidb/linux-msm into fixes
      Merge branch 'u300-fixes-for-arm-soc' of
git://git.kernel.org/.../linusw/linux-stericsson into fixes
      Merge branch 'fixes' of git://github.com/hzhuang1/linux into fixes
      Merge branch 'v3.4-samsung-fixes-3' of
git://git.kernel.org/.../kgene/linux-samsung into fixes

Robert Jarzmik (1):
      ARM: pxa: fix gpio wakeup setting

Thomas Abraham (2):
      ARM: EXYNOS: use 'exynos4-sdhci' as device name for sdhci controllers
      ARM: EXYNOS: Fix incorrect initialization of GIC

Tushar Behera (1):
      ARM: EXYNOS: Fix compilation error when CONFIG_OF is not defined

 arch/arm/boot/dts/msm8660-surf.dts          |    4 +-
 arch/arm/configs/mini2440_defconfig         |    2 +
 arch/arm/mach-exynos/clock-exynos4.c        |   24 ++---
 arch/arm/mach-exynos/clock-exynos5.c        |   24 ++---
 arch/arm/mach-exynos/common.c               |   14 ++-
 arch/arm/mach-exynos/dev-dwmci.c            |   13 +--
 arch/arm/mach-exynos/mach-nuri.c            |    1 +
 arch/arm/mach-exynos/mach-universal_c210.c  |    1 +
 arch/arm/mach-msm/board-msm8x60.c           |   25 +++--
 arch/arm/mach-pxa/include/mach/mfp-pxa2xx.h |    7 ++
 arch/arm/mach-pxa/mfp-pxa2xx.c              |   21 +++-
 arch/arm/mach-pxa/pxa27x.c                  |    6 +-
 arch/arm/mach-s3c24xx/Kconfig               |    8 +-
 arch/arm/mach-s5pv210/mach-goni.c           |    2 +
 arch/arm/mach-sa1100/generic.c              |    2 +-
 arch/arm/mach-u300/core.c                   |    6 +-
 arch/arm/mach-u300/i2c.c                    |    9 +-
 arch/arm/mach-u300/include/mach/irqs.h      |  150 +++++++++++++--------------
 arch/arm/plat-samsung/include/plat/sdhci.h  |   28 +++++
 drivers/gpio/gpio-pxa.c                     |   21 +++-
 include/linux/gpio-pxa.h                    |    4 +
 21 files changed, 230 insertions(+), 142 deletions(-)
