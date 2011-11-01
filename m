Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805Ab1KBCXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 22:23:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64523 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932715Ab1KBCXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 22:23:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL 7/13] arm-soc board dsupport
Date: Tue, 1 Nov 2011 04:45:53 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <201111010348.13214.arnd@arndb.de>
In-Reply-To: <201111010348.13214.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111010445.54154.arnd@arndb.de>
X-Provags-ID: V02:K0:yaVksRGls97XiPFtdC0hFoQB1Qpku6ZC39YsyMLQnz8
 FmyzibWu0u0sysjeRelERZ9cDpO9UDhFLVYR0FDD4Cv8enPANt
 L3XXEWedERqkxSszUoQUjgt/x5wlUF9rLfizCYtSDS0KmNoMjc
 zWWXfxYSSiz3HjuDND2ph1aXVLMqmWm3po29DICvZRN2IZS0ze
 ChVm7EbR22CDMA83gWyAton293ALwpLc9JIsiZbj2UjcU20Pkk
 YvgtuEInxx+C/a9HmR0KQ+m3nKwJ6YNhpJnHCI9Ac30Prxa4cG
 Bsk7RgYrcopiybo+VMBhC79R/uQciOc6Yk9YzwYiEYPK5mVTkh
 0DbfKWnJfvCdXXj8tX1k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for new boards in the arm platform. While I really wish we
could already do without this and only add device tree source files, I'm
making two exceptions that have been agreed on during the ARM subarch
maintainer summit:

1. Legacy platforms that see almost no active development can add /occasional/
board files. They will never be converted to device tree based probing, and there
is no reason to destabilize the platform or hold up support for machines that
have clean support out of tree. In this series, those are mxs, ixp4xx and ep93xx.

2. Any platform that sees active development towards becoming fully discoverable
using the device tree can still add board files as a transitionary step. These
files will get removed again once the platform is fully converted.

The tegra and samsung platforms also contain a few updates that make support in
the existing board files more complete. These fall under category 2.

	Arnd

The following changes since commit 543e61c98dbf862182ee6d6f0b8bd79386e02a7d:

  Merge branch 'next/deletion' into for-next (2011-11-01 00:38:14 +0100)

are available in the git repository at:

  git://git.linaro.org/people/arnd/arm-soc.git next/board

Ajay Kumar (1):
      ARM: SAMSUNG: Fix mask value for S5P64X0 CPU IDs

Arnd Bergmann (8):
      Merge branches 'tegra/board' and 'at91/board' into next/board
      Merge branch 'samsung/board' into next/board
      Merge branch 'ixp/board' into next/board
      Merge branch 'samsung/board' into next/board
      Merge branch 'ep93xx/board' into next/board
      Merge branch 'imx/board' into next/board
      Merge branch 'depends/rmk/gpio' into next/board
      Merge branch 'depends/rmk/devel-stable' into next/board

Changhwan Youn (7):
      ARM: EXYNOS4: Add support PPI in external GIC
      ARM: EXYNOS4: Add support MCT PPI for EXYNOS4212
      ARM: EXYNOS4: Add support new EXYNOS4412 SoC
      ARM: EXYNOS4: Add support clock for EXYNOS4412
      ARM: EXYNOS4: Add functions for gic interrupt handling
      ARM: EXYNOS4: Add MCT support for EXYNOS4412
      ARM: EXYNOS4: Add support SMDK4412 Board

Hartley Sweeten (1):
      ep93xx: add support Vision EP9307 SoM

Jean-Christophe PLAGNIOL-VILLARD (1):
      at91: USB-A9G20 C01 & C11 board support

JeongHyeon Kim (1):
      ARM: EXYNOS4: Add support for ORIGEN board

Jonghwan Choi (1):
      ARM: EXYNOS4: Add support PM for EXYNOS4212

Josef Holzmayr (1):
      at91: add support for RSIs EWS board

Kukjin Kim (10):
      ARM: SAMSUNG: Add support for detecting CPU at runtime
      ARM: S5P64X0: Use soc_is_s5p64x0() to distinguish cpu at runtime
      ARM: SAMSUNG: Add support for handling of cpu revision
      ARM: EXYNOS4: Use samsung_rev() to distinguish silicon revision
      Merge branch 'next/topic-cpuid-rev' into next/topic-add-exynos4212
      Merge branch 'next/topic-cleanup-smdkv310' into next/topic-add-exynos4212
      ARM: EXYNOS4: Add support new EXYNOS4212 SoC
      ARM: EXYNOS4: Add support clock for EXYNOS4212
      ARM: EXYNOS4: Add support SMDK4212 Board
      Merge branch 'next-samsung-board-v3.1' into next-samsung-board

Marc Dietrich (5):
      ARM: tegra: paz00: add support serial port on JP1
      ARM: tegra: paz00: enable rfkill for internal wifi card
      ARM: tegra: paz00: enable wifi led
      ARM: tegra: paz00: reorder the SDHCI channel init
      ARM: tegra: paz00: add clocks required for usb operation

Mark Brown (1):
      ARM: SAMSUNG: Fix mask for S3C64xx CPU IDs

Nico Erfurth (1):
      at91: merge board USB-A9260 and USB-A9263 together

Richard Cochran (1):
      ixp4xx: support omicron ixp425 based boards

Stefano Babic (1):
      ARM: mxs: Add initial support for DENX MX28

Stephen Warren (4):
      ARM: Tegra: Harmony: Add USB device
      ARM: Tegra: Seaboard board updates for audio
      ARM: Tegra: Seaboard: Add USB devices
      ARM: Tegra: Force PORT_TEGRA as the UART type

Tushar Behera (1):
      ARM: EXYNOS4: convert boot_params to atag_offset

 arch/arm/configs/exynos4_defconfig                 |    1 +
 arch/arm/configs/mxs_defconfig                     |    1 +
 arch/arm/mach-at91/Kconfig                         |   13 +
 arch/arm/mach-at91/Makefile                        |    6 +-
 arch/arm/mach-at91/board-rsi-ews.c                 |  233 ++++++++++++
 arch/arm/mach-at91/board-usb-a9260.c               |  230 ------------
 arch/arm/mach-at91/board-usb-a9263.c               |  246 -------------
 arch/arm/mach-at91/board-usb-a926x.c               |  383 ++++++++++++++++++++
 arch/arm/mach-at91/include/mach/timex.h            |    5 +
 arch/arm/mach-ep93xx/Kconfig                       |    7 +
 arch/arm/mach-ep93xx/Makefile                      |    1 +
 arch/arm/mach-ep93xx/vision_ep9307.c               |  364 +++++++++++++++++++
 arch/arm/mach-exynos4/Kconfig                      |   54 +++
 arch/arm/mach-exynos4/Makefile                     |   10 +-
 arch/arm/mach-exynos4/clock-exynos4210.c           |  139 +++++++
 arch/arm/mach-exynos4/clock-exynos4212.c           |  118 ++++++
 arch/arm/mach-exynos4/clock.c                      |  218 ++++++++----
 arch/arm/mach-exynos4/cpu.c                        |   57 +++-
 arch/arm/mach-exynos4/include/mach/entry-macro.S   |   23 +-
 arch/arm/mach-exynos4/include/mach/exynos4-clock.h |   43 +++
 arch/arm/mach-exynos4/include/mach/irqs.h          |    2 +
 arch/arm/mach-exynos4/include/mach/map.h           |    4 +-
 arch/arm/mach-exynos4/include/mach/regs-clock.h    |   54 ++-
 arch/arm/mach-exynos4/include/mach/regs-mct.h      |    5 +-
 arch/arm/mach-exynos4/mach-origen.c                |  108 ++++++
 arch/arm/mach-exynos4/mach-smdk4x12.c              |  302 +++++++++++++++
 arch/arm/mach-exynos4/mct.c                        |  165 +++++----
 arch/arm/mach-exynos4/platsmp.c                    |   13 +-
 arch/arm/mach-exynos4/pm.c                         |   79 +----
 arch/arm/mach-ixp4xx/Kconfig                       |   19 +
 arch/arm/mach-ixp4xx/Makefile                      |    4 +
 arch/arm/mach-ixp4xx/include/mach/uncompress.h     |    3 +-
 arch/arm/mach-ixp4xx/miccpt-pci.c                  |   78 ++++
 arch/arm/mach-ixp4xx/omixp-setup.c                 |  273 ++++++++++++++
 arch/arm/mach-mxs/Kconfig                          |   17 +
 arch/arm/mach-mxs/Makefile                         |    1 +
 arch/arm/mach-mxs/clock-mx28.c                     |   16 +-
 arch/arm/mach-mxs/include/mach/mxs.h               |    1 +
 arch/arm/mach-mxs/include/mach/uncompress.h        |    1 +
 arch/arm/mach-mxs/mach-m28evk.c                    |  366 +++++++++++++++++++
 arch/arm/mach-s3c64xx/cpu.c                        |   22 +-
 arch/arm/mach-s5p64x0/dev-spi.c                    |    8 +-
 arch/arm/mach-s5p64x0/dma.c                        |    7 +-
 arch/arm/mach-s5p64x0/gpiolib.c                    |    7 +-
 arch/arm/mach-s5p64x0/irq-eint.c                   |    3 +-
 arch/arm/mach-tegra/board-harmony.c                |    5 +-
 arch/arm/mach-tegra/board-paz00-pinmux.c           |    3 +
 arch/arm/mach-tegra/board-paz00.c                  |   64 +++-
 arch/arm/mach-tegra/board-paz00.h                  |    8 +
 arch/arm/mach-tegra/board-seaboard-pinmux.c        |    6 +-
 arch/arm/mach-tegra/board-seaboard.c               |   81 ++++-
 arch/arm/mach-tegra/board-seaboard.h               |   12 +-
 arch/arm/mach-tegra/board-trimslice.c              |    4 +-
 arch/arm/plat-s3c24xx/cpu.c                        |    9 +-
 arch/arm/plat-s5p/cpu.c                            |   46 ++-
 arch/arm/plat-s5p/include/plat/exynos4.h           |    5 +-
 arch/arm/plat-s5p/include/plat/pll.h               |   55 +++-
 arch/arm/plat-samsung/Makefile                     |    2 +-
 arch/arm/plat-samsung/cpu.c                        |   58 +++
 arch/arm/plat-samsung/include/plat/cpu.h           |  113 ++++++-
 60 files changed, 3371 insertions(+), 810 deletions(-)

