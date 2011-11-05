Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab1KEAFd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 20:05:33 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:57585 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747Ab1KEAFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 20:05:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] arm-soc features for samsung and pxa
Date: Sat, 5 Nov 2011 01:05:18 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Vinod Koul <vinod.koul@intel.com>, Kukjin Kim <kgene.kim@samsung.com>
References: <201111050054.33975.arnd@arndb.de>
In-Reply-To: <201111050054.33975.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111050105.18714.arnd@arndb.de>
X-Provags-ID: V02:K0:Zz8XrxZTUZCtx3XdtFC/bPgXSzpLQ+KZHtbnIEMik46
 GHw/GeMTza1VM60KfEpEDbJj7w1BDDt239BoEunrBOZ4GaYwWV
 rfbHaJ/iuTmDDaQVv+DotU+JIuyeueAQNrzsgCFLY/koVdbs7Y
 AnY4YHn5SBGRWtWinHJM6LE4mBauuQZt+GMpQUMZWDBVp8PCM3
 jwiX7AbKm0G9DWIEuHO93CsKAgw+Z7QKsM0aqzEX+BL1JJNn3J
 K8A1FjkDQkaDPNrIl6yUbhSJtUeUbE7hNGaN2ZvNfT2h1HOxJI
 Rd40OntaNFfTB1KwMdewfZqRwq6ZAs7vjfeoK/EQ5AucTFPsCL
 ZvRFmJXJBvqPqy9P9yhI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are patches for new development changes for the samsung and pxa platforms.
The samsung changes depend on the cleanup branch I just sent (including the
dma-slave series). The pxa patches were sent to me relatively late, so I
put them in this branch rather than the first next/devel branch you already
pulled. There should be no further conflicts if you pull this branch
after next/cleanup3.

	Arnd

The following changes since commit 8f7e34205f6ff50bfb30908af8aae5fd65a95d5f:

  Merge branch 'next/cleanup3' into for-next (2011-11-02 03:16:14 +0100)

are available in the git repository at:

  git://git.linaro.org/people/arnd/arm-soc.git next/devel2

Arnd Bergmann (4):
      Merge branch 'samsung/devel' of git+ssh://git.linaro.org/home/arndbergmann/public_git/arm-soc into next/devel2
      Merge branch 'samsung/devel' into next/devel2
      Merge branch 'pxa/devel' into next/devel2

Axel Lin (1):
      ARM: S3C2443: Remove redundant s3c_register_clocks call for init_clocks

Heiko St?bner (2):
      ARM: S3C2443: Move clk_arm and clk_armdiv to common code
      ARM: S3C2416: Add comment describing the armdiv/armclk

Heiko Stuebner (12):
      ARM: SAMSUNG: Add adc registers for S3C2443/S3C2416
      ARM: SAMSUNG: Fix mux bit modification in s3c_adc_select
      ARM: SAMSUNG: Allow overriding of adc device name for S3C24XX
      ARM: SAMSUNG: Add support s3c2443-adc for S3C2443
      ARM: SAMSUNG: Add support s3c2416-adc for S3C2416/S3C2450
      ARM: S3C2416: Add armdiv_mask constant
      ARM: S3C24XX: Add infrastructure to transmit armdiv to common code
      ARM: S3C2443: Add get_rate operation for clk_armdiv
      ARM: S3C2443: handle unset armdiv values gracefully
      ARM: S3C2443: Accommodate cpufreq frequency scheme in armdiv
      ARM: S3C24XX: use clk_get_rate to init fclk in common_setup_clocks
      ARM: S3C24XX: Add devname for hsmmc1 pclk

Kukjin Kim (1):
      ARM: EXYNOS4: Remove useless codes on NURI board

Leo Yan (3):
      ARM: mmp: add sram allocator
      ARM: mmp: register audio sram bank
      ARM: mmp: register internal sram bank

Mark Brown (3):
      ARM: S3C64XX: Enable TCM support
      ARM: S3C64XX: Fix SoC identification for S3C64xx devices
      gpio/samsung: Complain loudly if we don't know the SoC

Peter Korsgaard (2):
      ARM: S3C2410: fix S3C_GPIO_SPACE #error message to match reality
      gpio/samsung: only register available gpio banks

Sachin Kamat (3):
      ARM: EXYNOS4: Enable regulator support for HDMI on ORIGEN
      ARM: EXYNOS4: Register power domains on ORIGEN
      ARM: EXYNOS4: Enable MFC on ORIGEN

Sylwester Nawrocki (1):
      ARM: EXYNOS4: Add support for M-5MOLS camera on Nuri board

Thomas Abraham (1):
      gpio/samsung: Fix incorrect gpio pull up/down callback for EXYNOS4

Tushar Behera (1):
      gpio/samsung: Move SoC specific codes within macro

 arch/arm/Kconfig                                   |    2 +
 arch/arm/mach-exynos4/Kconfig                      |   12 ++-
 arch/arm/mach-exynos4/mach-nuri.c                  |  158 ++++++++++++++++++-
 arch/arm/mach-exynos4/mach-origen.c                |   21 +++
 arch/arm/mach-mmp/Makefile                         |    2 +-
 arch/arm/mach-mmp/brownstone.c                     |   11 ++
 arch/arm/mach-mmp/include/mach/mmp2.h              |   13 ++
 arch/arm/mach-mmp/include/mach/sram.h              |   35 ++++
 arch/arm/mach-mmp/mmp2.c                           |    3 +
 arch/arm/mach-mmp/sram.c                           |  168 ++++++++++++++++++++
 arch/arm/mach-s3c2410/include/mach/gpio-nrs.h      |    2 +-
 .../mach-s3c2410/include/mach/regs-s3c2443-clock.h |    1 +
 arch/arm/mach-s3c2416/clock.c                      |   21 ++-
 arch/arm/mach-s3c2416/s3c2416.c                    |    3 +
 arch/arm/mach-s3c2443/clock.c                      |  105 +------------
 arch/arm/mach-s3c2443/s3c2443.c                    |    3 +
 arch/arm/plat-s3c24xx/s3c2443-clock.c              |  135 +++++++++++++++-
 arch/arm/plat-samsung/adc.c                        |   43 ++++--
 arch/arm/plat-samsung/include/plat/adc-core.h      |    2 +-
 arch/arm/plat-samsung/include/plat/cpu.h           |    6 +-
 arch/arm/plat-samsung/include/plat/regs-adc.h      |    3 +
 arch/arm/plat-samsung/include/plat/s3c2443.h       |    7 +-
 drivers/gpio/gpio-samsung.c                        |   48 ++++--
 23 files changed, 651 insertions(+), 153 deletions(-)
 create mode 100644 arch/arm/mach-mmp/include/mach/sram.h
 create mode 100644 arch/arm/mach-mmp/sram.c
