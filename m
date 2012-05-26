Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489Ab2EZHX3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 03:23:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37603 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab2EZHXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 03:23:15 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 8/8] arm-soc: sweeping late_initcall cleanup
Date: Sat, 26 May 2012 00:22:38 -0700
Message-Id: <1338016958-7887-9-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.1.488.g05fbf7a
In-Reply-To: <1338016958-7887-1-git-send-email-olof@lixom.net>
References: <1338016958-7887-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch series from Shawn Guo that moves from individual
late_initcalls() to using a member in the machine structure to invoke
a platform's late initcalls.

This cleanup is a step in the move towards multiplatform kernels since
it would reduce the need to check for compatible platforms in each and
every initcall.

----------------------------------------------------------------

The following changes since commit 7ff2e2e928102ba1bd0d375a649dec5980c3a130:

  Merge tag 'soc2' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/cleanup-initcall

for you to fetch changes up to 80b9abf973462499c1a0110df47f62cc90361e2c:

  Merge branch 'clean/late_initcall_v2' of git://git.linaro.org/people/shawnguo/linux-2.6 into staging/cleanup

----------------------------------------------------------------

Olof Johansson (1):
      Merge branch 'clean/late_initcall_v2' of git://git.linaro.org/people/shawnguo/linux-2.6 into staging/cleanup

Shawn Guo (15):
      ARM: provide a late_initcall hook for platform initialization
      ARM: davinci: use machine specific hook for late init
      ARM: ep93xx: use machine specific hook for late init
      ARM: exynos: use machine specific hook for late init
      ARM: imx: use machine specific hook for late init
      ARM: msm: use machine specific hook for late init
      ARM: omap1: use machine specific hook for late init
      ARM: omap2: use machine specific hook for late init
      ARM: pnx4008: use machine specific hook for late init
      ARM: prima2: use machine specific hook for late init
      ARM: s3c64xx: use machine specific hook for late init
      ARM: sa1100: use machine specific hook for late init
      ARM: shmobile: use machine specific hook for late init
      ARM: tegra: use machine specific hook for late init
      ARM: ux500: use machine specific hook for late init


 arch/arm/include/asm/mach/arch.h             |  1 +
 arch/arm/kernel/setup.c                      |  8 +++
 arch/arm/mach-davinci/board-da830-evm.c      |  1 +
 arch/arm/mach-davinci/board-da850-evm.c      |  1 +
 arch/arm/mach-davinci/board-dm355-evm.c      |  1 +
 arch/arm/mach-davinci/board-dm355-leopard.c  |  1 +
 arch/arm/mach-davinci/board-dm365-evm.c      |  1 +
 arch/arm/mach-davinci/board-dm644x-evm.c     |  1 +
 arch/arm/mach-davinci/board-dm646x-evm.c     |  2 +
 arch/arm/mach-davinci/board-mityomapl138.c   |  1 +
 arch/arm/mach-davinci/board-neuros-osd2.c    |  1 +
 arch/arm/mach-davinci/board-omapl138-hawk.c  |  1 +
 arch/arm/mach-davinci/board-sffsdr.c         |  1 +
 arch/arm/mach-davinci/board-tnetv107x-evm.c  |  1 +
 arch/arm/mach-davinci/clock.c                |  3 +-
 arch/arm/mach-davinci/common.c               |  7 +++
 arch/arm/mach-davinci/cpufreq.c              |  3 +-
 arch/arm/mach-davinci/include/mach/common.h  | 19 +++++++
 arch/arm/mach-davinci/pm.c                   |  3 +-
 arch/arm/mach-ep93xx/adssphere.c             |  1 +
 arch/arm/mach-ep93xx/core.c                  |  5 ++
 arch/arm/mach-ep93xx/crunch.c                |  4 +-
 arch/arm/mach-ep93xx/edb93xx.c               |  8 +++
 arch/arm/mach-ep93xx/gesbc9312.c             |  1 +
 arch/arm/mach-ep93xx/include/mach/platform.h |  7 +++
 arch/arm/mach-ep93xx/micro9.c                |  4 ++
 arch/arm/mach-ep93xx/simone.c                |  1 +
 arch/arm/mach-ep93xx/snappercl15.c           |  1 +
 arch/arm/mach-ep93xx/ts72xx.c                |  1 +
 arch/arm/mach-ep93xx/vision_ep9307.c         |  1 +
 arch/arm/mach-exynos/common.c                |  5 ++
 arch/arm/mach-exynos/common.h                |  7 +++
 arch/arm/mach-exynos/mach-armlex4210.c       |  1 +
 arch/arm/mach-exynos/mach-exynos4-dt.c       |  1 +
 arch/arm/mach-exynos/mach-exynos5-dt.c       |  1 +
 arch/arm/mach-exynos/mach-nuri.c             |  1 +
 arch/arm/mach-exynos/mach-origen.c           |  1 +
 arch/arm/mach-exynos/mach-smdk4x12.c         |  1 +
 arch/arm/mach-exynos/mach-smdkv310.c         |  1 +
 arch/arm/mach-exynos/mach-universal_c210.c   |  1 +
 arch/arm/mach-exynos/pm_domains.c            |  3 +-
 arch/arm/mach-imx/cpu-imx5.c                 |  6 +--
 arch/arm/mach-imx/imx51-dt.c                 |  1 +
 arch/arm/mach-imx/mach-cpuimx51sd.c          |  1 +
 arch/arm/mach-imx/mach-mx51_3ds.c            |  1 +
 arch/arm/mach-imx/mach-mx51_babbage.c        |  1 +
 arch/arm/mach-imx/mach-mx51_efikamx.c        | 42 ++++++++-------
 arch/arm/mach-imx/mach-mx51_efikasb.c        | 28 +++++-----
 arch/arm/mach-imx/mach-pcm037.c              |  6 +++
 arch/arm/mach-imx/mach-pcm037_eet.c          |  5 +-
 arch/arm/mach-imx/mm-imx5.c                  |  5 ++
 arch/arm/mach-imx/pcm037.h                   |  6 +++
 arch/arm/mach-msm/board-halibut.c            |  6 +++
 arch/arm/mach-msm/board-mahimahi.c           |  6 +++
 arch/arm/mach-msm/board-msm7x27.c            |  9 ++++
 arch/arm/mach-msm/board-msm7x30.c            |  8 +++
 arch/arm/mach-msm/board-msm8960.c            |  7 +++
 arch/arm/mach-msm/board-msm8x60.c            | 10 ++++
 arch/arm/mach-msm/board-qsd8x50.c            |  7 +++
 arch/arm/mach-msm/board-sapphire.c           |  6 +++
 arch/arm/mach-msm/board-trout.c              |  6 +++
 arch/arm/mach-msm/include/mach/board.h       |  6 +++
 arch/arm/mach-msm/smd_debug.c                |  3 +-
 arch/arm/mach-omap1/board-ams-delta.c        |  8 ++-
 arch/arm/mach-omap1/board-fsample.c          |  1 +
 arch/arm/mach-omap1/board-generic.c          |  1 +
 arch/arm/mach-omap1/board-h2.c               |  1 +
 arch/arm/mach-omap1/board-h3.c               |  1 +
 arch/arm/mach-omap1/board-htcherald.c        |  1 +
 arch/arm/mach-omap1/board-innovator.c        |  1 +
 arch/arm/mach-omap1/board-nokia770.c         |  1 +
 arch/arm/mach-omap1/board-osk.c              |  1 +
 arch/arm/mach-omap1/board-palmte.c           |  1 +
 arch/arm/mach-omap1/board-palmtt.c           |  1 +
 arch/arm/mach-omap1/board-palmz71.c          |  1 +
 arch/arm/mach-omap1/board-perseus2.c         |  1 +
 arch/arm/mach-omap1/board-sx1.c              |  1 +
 arch/arm/mach-omap1/board-voiceblue.c        |  1 +
 arch/arm/mach-omap1/common.h                 | 10 ++++
 arch/arm/mach-omap1/io.c                     |  5 ++
 arch/arm/mach-omap1/serial.c                 |  3 +-
 arch/arm/mach-omap2/board-2430sdp.c          |  1 +
 arch/arm/mach-omap2/board-3430sdp.c          |  1 +
 arch/arm/mach-omap2/board-3630sdp.c          |  1 +
 arch/arm/mach-omap2/board-4430sdp.c          |  1 +
 arch/arm/mach-omap2/board-am3517crane.c      |  1 +
 arch/arm/mach-omap2/board-am3517evm.c        |  1 +
 arch/arm/mach-omap2/board-apollon.c          |  1 +
 arch/arm/mach-omap2/board-cm-t35.c           |  2 +
 arch/arm/mach-omap2/board-cm-t3517.c         |  1 +
 arch/arm/mach-omap2/board-devkit8000.c       |  1 +
 arch/arm/mach-omap2/board-generic.c          |  1 +
 arch/arm/mach-omap2/board-h4.c               |  1 +
 arch/arm/mach-omap2/board-igep0020.c         |  2 +
 arch/arm/mach-omap2/board-ldp.c              |  1 +
 arch/arm/mach-omap2/board-n8x0.c             |  3 ++
 arch/arm/mach-omap2/board-omap3beagle.c      |  1 +
 arch/arm/mach-omap2/board-omap3evm.c         |  1 +
 arch/arm/mach-omap2/board-omap3logic.c       |  2 +
 arch/arm/mach-omap2/board-omap3pandora.c     |  1 +
 arch/arm/mach-omap2/board-omap3stalker.c     |  1 +
 arch/arm/mach-omap2/board-omap3touchbook.c   |  1 +
 arch/arm/mach-omap2/board-omap4panda.c       |  1 +
 arch/arm/mach-omap2/board-overo.c            |  1 +
 arch/arm/mach-omap2/board-rm680.c            |  2 +
 arch/arm/mach-omap2/board-rx51.c             |  1 +
 arch/arm/mach-omap2/board-ti8168evm.c        |  2 +
 arch/arm/mach-omap2/board-zoom.c             |  2 +
 arch/arm/mach-omap2/common.h                 | 47 +++++++++++++++++
 arch/arm/mach-omap2/io.c                     | 63 +++++++++++++++++++++++
 arch/arm/mach-omap2/mux.c                    |  3 +-
 arch/arm/mach-omap2/pm.c                     |  3 +-
 arch/arm/mach-omap2/pm24xx.c                 | 17 ++----
 arch/arm/mach-omap2/pm34xx.c                 |  7 +--
 arch/arm/mach-omap2/pm44xx.c                 |  6 +--
 arch/arm/mach-pnx4008/core.c                 | 12 +++++
 arch/arm/mach-pnx4008/pm.c                   |  4 +-
 arch/arm/mach-prima2/common.h                |  6 +++
 arch/arm/mach-prima2/pm.c                    |  3 +-
 arch/arm/mach-prima2/prima2.c                |  6 +++
 arch/arm/mach-s3c64xx/common.c               |  5 ++
 arch/arm/mach-s3c64xx/common.h               |  7 +++
 arch/arm/mach-s3c64xx/mach-anw6410.c         |  1 +
 arch/arm/mach-s3c64xx/mach-crag6410.c        |  1 +
 arch/arm/mach-s3c64xx/mach-hmt.c             |  1 +
 arch/arm/mach-s3c64xx/mach-mini6410.c        |  1 +
 arch/arm/mach-s3c64xx/mach-ncp.c             |  1 +
 arch/arm/mach-s3c64xx/mach-real6410.c        |  1 +
 arch/arm/mach-s3c64xx/mach-smartq5.c         |  1 +
 arch/arm/mach-s3c64xx/mach-smartq7.c         |  1 +
 arch/arm/mach-s3c64xx/mach-smdk6400.c        |  1 +
 arch/arm/mach-s3c64xx/mach-smdk6410.c        |  1 +
 arch/arm/mach-s3c64xx/pm.c                   |  3 +-
 arch/arm/mach-sa1100/assabet.c               |  1 +
 arch/arm/mach-sa1100/badge4.c                |  1 +
 arch/arm/mach-sa1100/cerf.c                  |  1 +
 arch/arm/mach-sa1100/collie.c                |  1 +
 arch/arm/mach-sa1100/generic.c               |  4 ++
 arch/arm/mach-sa1100/generic.h               |  7 +++
 arch/arm/mach-sa1100/h3100.c                 |  1 +
 arch/arm/mach-sa1100/h3600.c                 |  1 +
 arch/arm/mach-sa1100/hackkit.c               |  1 +
 arch/arm/mach-sa1100/jornada720.c            |  1 +
 arch/arm/mach-sa1100/lart.c                  |  1 +
 arch/arm/mach-sa1100/nanoengine.c            |  1 +
 arch/arm/mach-sa1100/pleb.c                  |  1 +
 arch/arm/mach-sa1100/pm.c                    |  4 +-
 arch/arm/mach-sa1100/shannon.c               |  1 +
 arch/arm/mach-sa1100/simpad.c                |  1 +
 arch/arm/mach-shmobile/Makefile              |  2 +-
 arch/arm/mach-shmobile/board-ag5evm.c        |  1 +
 arch/arm/mach-shmobile/board-ap4evb.c        |  1 +
 arch/arm/mach-shmobile/board-bonito.c        |  1 +
 arch/arm/mach-shmobile/board-g3evm.c         |  1 +
 arch/arm/mach-shmobile/board-g4evm.c         |  1 +
 arch/arm/mach-shmobile/board-kota2.c         |  1 +
 arch/arm/mach-shmobile/board-mackerel.c      |  1 +
 arch/arm/mach-shmobile/board-marzen.c        |  1 +
 arch/arm/mach-shmobile/common.c              | 24 +++++++++
 arch/arm/mach-shmobile/cpuidle.c             |  3 +-
 arch/arm/mach-shmobile/include/mach/common.h | 14 +++++
 arch/arm/mach-shmobile/suspend.c             |  3 +-
 arch/arm/mach-tegra/board-dt-tegra20.c       |  1 +
 arch/arm/mach-tegra/board-dt-tegra30.c       |  1 +
 arch/arm/mach-tegra/board-harmony.c          |  1 +
 arch/arm/mach-tegra/board-paz00.c            |  1 +
 arch/arm/mach-tegra/board-seaboard.c         |  3 ++
 arch/arm/mach-tegra/board-trimslice.c        |  1 +
 arch/arm/mach-tegra/board.h                  | 14 +++++
 arch/arm/mach-tegra/clock.c                  |  3 +-
 arch/arm/mach-tegra/common.c                 |  6 +++
 arch/arm/mach-tegra/powergate.c              |  4 +-
 arch/arm/mach-ux500/board-mop500.c           |  4 ++
 arch/arm/mach-ux500/clock.c                  |  6 +--
 arch/arm/mach-ux500/clock.h                  | 12 +++++
 arch/arm/mach-ux500/cpu.c                    |  6 +++
 arch/arm/mach-ux500/include/mach/setup.h     |  1 +
 arch/arm/plat-mxc/include/mach/common.h      |  7 +++
 178 files changed, 614 insertions(+), 106 deletions(-)
 create mode 100644 arch/arm/mach-shmobile/common.c
