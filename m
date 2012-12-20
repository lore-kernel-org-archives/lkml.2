Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab2LTXEG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 18:04:06 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:49456 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab2LTXD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 18:03:59 -0500
Date: Thu, 20 Dec 2012 15:04:00 -0800
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org, tony@atomide.com
Subject: [GIT PULL] ARM: arm-soc fixes for 3.8, part 2
Message-ID: <20121220230400.GA16877@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here is the incremental pull request of fixes from earlier today,
based on the portions you pulled in this morning.


Thanks,

-Olof

The following changes since commit 1800098549fc310cffffefdcb3722adaad0edda8:

  ARM: OMAP: Fix build breakage due to missing include in i2c.c (2012-12-20 08:43:25 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes2

for you to fetch changes up to 2727da8595d6a134502ce576b812f0bb0e3c14ed:

  ARM: OMAP2+: Fix compillation error in mach-omap2/timer.c (2012-12-20 09:45:03 -0800)

----------------------------------------------------------------
Axel Lin (1):
      pinctrl: exynos5440/samsung: Staticize pcfgs

Dongjin Kim (1):
      ARM: EXYNOS: Fix MSHC clocks instance names

Kukjin Kim (3):
      ARM: EXYNOS: fix build error when MFC is not selected
      ARM: EXYNOS: fix GIC using for EXYNOS5440
      ARM: EXYNOS: fix skip scu_enable() for EXYNOS5440

Michael Spang (1):
      ARM: SAMSUNG: Add missing include guard to gpio-core.h

Olof Johansson (3):
      ARM: sunxi: rename device tree source files
      Merge branch 'v3.8-samsung-fixes-1' of git://git.kernel.org/.../kgene/linux-samsung into fixes
      Merge branch 'v3.8-samsung-fixes-audio' of git://git.kernel.org/.../kgene/linux-samsung into fixes

Padmavathi Venna (5):
      ARM: S3C64XX: Add I2S clkdev support
      ARM: S5PC100: Add I2S clkdev support
      ARM: S5P64X0: Add I2S clkdev support
      ARM: S5PV210: Avoid passing the clks through platform data
      ARM: EXYNOS: Avoid passing the clks through platform data

Peter Ujfalusi (1):
      ARM: OMAP2+: Fix compillation error in mach-omap2/timer.c

Sachin Kamat (4):
      pinctrl: samsung: Fix a typo in pinctrl-samsung.h
      ARM: EXYNOS: Fix NULL pointer dereference bug in Origen
      ARM: EXYNOS: Fix NULL pointer dereference bug in SMDK4X12
      ARM: EXYNOS: Fix NULL pointer dereference bug in SMDKV310

 ...n4i-cubieboard.dts => sun4i-a10-cubieboard.dts} |   0
 arch/arm/boot/dts/{sun4i.dtsi => sun4i-a10.dtsi}   |   0
 ...sun5i-olinuxino.dts => sun5i-a13-olinuxino.dts} |   0
 arch/arm/boot/dts/{sun5i.dtsi => sun5i-a13.dtsi}   |   0
 arch/arm/mach-exynos/clock-exynos4.c               |   4 +-
 arch/arm/mach-exynos/common.c                      |   3 +-
 arch/arm/mach-exynos/dev-audio.c                   |  12 --
 arch/arm/mach-exynos/mach-exynos5-dt.c             |   2 +
 arch/arm/mach-exynos/mach-origen.c                 |   4 +-
 arch/arm/mach-exynos/mach-smdk4x12.c               |   4 +-
 arch/arm/mach-exynos/mach-smdkv310.c               |   4 +-
 arch/arm/mach-exynos/platsmp.c                     |   2 +-
 arch/arm/mach-omap2/timer.c                        |   2 +-
 arch/arm/mach-s3c64xx/clock.c                      | 126 +++++++++++++--------
 arch/arm/mach-s3c64xx/dev-audio.c                  |  11 --
 arch/arm/mach-s5p64x0/clock-s5p6440.c              |  49 +++++---
 arch/arm/mach-s5p64x0/clock-s5p6450.c              |  61 ++++++----
 arch/arm/mach-s5p64x0/dev-audio.c                  |  12 --
 arch/arm/mach-s5pc100/clock.c                      |  48 +++++---
 arch/arm/mach-s5pc100/dev-audio.c                  |  16 ---
 arch/arm/mach-s5pv210/dev-audio.c                  |  16 ---
 arch/arm/plat-samsung/include/plat/gpio-core.h     |   5 +
 drivers/pinctrl/pinctrl-exynos5440.c               |   2 +-
 drivers/pinctrl/pinctrl-samsung.c                  |   2 +-
 drivers/pinctrl/pinctrl-samsung.h                  |   2 +-
 25 files changed, 204 insertions(+), 183 deletions(-)
 rename arch/arm/boot/dts/{sun4i-cubieboard.dts => sun4i-a10-cubieboard.dts} (100%)
 rename arch/arm/boot/dts/{sun4i.dtsi => sun4i-a10.dtsi} (100%)
 rename arch/arm/boot/dts/{sun5i-olinuxino.dts => sun5i-a13-olinuxino.dts} (100%)
 rename arch/arm/boot/dts/{sun5i.dtsi => sun5i-a13.dtsi} (100%)
