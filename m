Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab2C1HPu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 03:15:50 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52614 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab2C1HOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 03:14:41 -0400
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 2/5] ARM: More SoC driver updates
Date: Wed, 28 Mar 2012 00:13:59 -0700
Message-Id: <1332918842-13521-3-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.9.2.359.gebfc2
In-Reply-To: <1332918842-13521-1-git-send-email-olof@lixom.net>
References: <1332918842-13521-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This branch contains a handful of driver updates, mostly to
the LPC32xx platform but also for Samsung EXYNOS and Davinci.



It had a few context conflicts against patches already merged through
fixes-non-critical. We should have resolved this early during the
development cycle by pulling them in as a dependency, instead I did it
after the fact this time.


-Olof

----------------------------------------------------------------

The following changes since commit 7700a7305fe11c06900bc813df4e49381d429b89:

  Merge tag 'cleanup2' into for-next

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/drivers2

for you to fetch changes up to 1f5b7dcfdad3840d4bce27ab0b3cc8f376b81544:

  Merge branch 'fixes-non-critical' into next/drivers2

----------------------------------------------------------------

Arnd Bergmann (4):
      Merge branches 'lpc32xx/mach-lpc32xx-eth' and 'lpc32xx/mach-lpc32xx-usb' of git://git.antcom.de/linux-2.6 into lpc32xx/drivers
      Merge branch 'lpc32xx/drivers' into next/drivers
      Merge branch 'v3.4/features' of git://gitorious.org/linux-davinci/linux-davinci into next/drivers
      Merge branch 'next/soc-exynos5250-gpio' of git://git.kernel.org/.../kgene/linux-samsung into next/drivers

Manjunath Hadli (2):
      ARM: davinci: dm644x: add support for v4l2 video display
      ARM: davinci: dm644x evm: add support for VPBE display

Olof Johansson (2):
      Merge branch 'next/devel-samsung-pd' of git://git.kernel.org/.../kgene/linux-samsung into next/drivers
      Merge branch 'fixes-non-critical' into next/drivers2

Roland Stigge (12):
      ARM: LPC32xx: Added lpc32xx_defconfig
      ARM: LPC32xx: clock.c: warning fix
      ARM: LPC32xx: clock.c: Fix mutex lock issues
      ARM: LPC32XX: Remove broken non-static declaration
      ARM: LPC32xx: clock.c: Missing header file
      ARM: LPC32xx: clock.c: jiffies wrapping
      ARM: LPC32xx: clock.c: Clock registration fixes
      Merge branch 'lpc32xx/fixup' of git://git.kernel.org/.../arm/arm-soc into lpc32xx/tmp
      Merge branch 'lpc32xx/fixup2' of git://git.kernel.org/.../arm/arm-soc into lpc32xx/tmp
      Merge branch 'lpc32xx/drivers' of git://git.kernel.org/.../arm/arm-soc into lpc32xx/tmp
      ARM: LPC32xx: USB Support
      ARM: LPC32xx: Ethernet support

Sachin Kamat (2):
      ARM: EXYNOS: Hook up G2D PD to generic PD infrastructure
      ARM: EXYNOS: Hook up JPEG PD to generic PD infrastructure

Sangsu Park (3):
      ARM: EXYNOS: add support GPIO for EXYNOS5250
      gpio/samsung: add support GPIOlib for EXYNOS5250
      gpio/samsung: use ioremap() for EXYNOS4 GPIOlib

Wolfram Sang (1):
      arm: lpc32xx: phy3250: add rtc & touch device


 arch/arm/mach-davinci/board-dm644x-evm.c   |  109 ++++-
 arch/arm/mach-davinci/davinci.h            |    8 +-
 arch/arm/mach-davinci/dm644x.c             |  166 +++++++-
 arch/arm/mach-exynos/common.c              |   15 -
 arch/arm/mach-exynos/include/mach/gpio.h   |  239 ++++++++---
 arch/arm/mach-exynos/include/mach/map.h    |    4 +
 arch/arm/mach-exynos/pm_domains.c          |    6 +
 arch/arm/mach-lpc32xx/Kconfig              |   25 ++
 arch/arm/mach-lpc32xx/clock.c              |   87 ++--
 arch/arm/mach-lpc32xx/common.c             |   47 +++
 arch/arm/mach-lpc32xx/common.h             |    4 +-
 arch/arm/mach-lpc32xx/include/mach/board.h |   24 ++
 arch/arm/mach-lpc32xx/irq.c                |    4 +
 arch/arm/mach-lpc32xx/phy3250.c            |    3 +
 drivers/gpio/gpio-samsung.c                |  487 +++++++++++++++++++++--
 15 files changed, 1080 insertions(+), 148 deletions(-)
 create mode 100644 arch/arm/mach-lpc32xx/include/mach/board.h
