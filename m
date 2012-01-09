Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932773Ab2AIWN4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 17:13:56 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:50194 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932512Ab2AIWNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 17:13:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL 03/11] Device tree conversions for samsung and tegra
Date: Mon,  9 Jan 2012 22:12:43 +0000
Message-Id: <1326147171-13752-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1326147171-13752-1-git-send-email-arnd@arndb.de>
References: <1326147171-13752-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:gM6n0IfdnTi4CLQF+evOaUoeApFX++bAUilenWw1v5c
 0BaSgw1EAAeZx30rct0G04zZZpNizBsKrGHsgB+rZoZ/XT0lmS
 nefsEKw/faMsFZcrx5LTwn4dzcQ9NLORLFfrHj+XPUlXXbblAq
 ib7aDrnNopn4Wgs1j/v8T3X8yfBBpgfa6z4z0Ig4Z2mrNnxNrI
 piYgaCtRHya2VlMg74vO2T8ahSRiYmptSQC98Qi8zP0jCaMkKD
 zcW27Qxp81/fjIhX2nuPwwe7sI8/iF21M++Xz7QglRzDn92YOD
 EgXgstjlWODdaHEQG3LTZqhTSnLt+l7iH/xLK5eZBfTEekEnaD
 t8HxTWiuIaCYfdh+daCwhvEV6S3jJ7zcGLuPt7btFmoqLmELGS
 ATOSKPhbhjprw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both platforms had some initial device tree support, but this adds
much more to actually make it usable.

This is where the really nasty conflicts in the samsung platform
start, due to some files getting moved around and combined in the
'restart' branch that has already gone into mainline through
Russell's tree.

The following changes since commit e88e1cdb55595657f6aac915042f998165f97877:

  Merge branch 'next/cleanup' into for-next3 (2012-01-09 16:47:32 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git next/dt

Arnd Bergmann (8):
      Merge branch 'for-3.3/dt' of git://git.kernel.org/.../olof/tegra into tegra/dt
      Merge branch 'next-samsung-devel-dt1' of git://git.kernel.org/.../kgene/linux-samsung into samsung/dt
      Merge branch 'tegra/cleanup' into next/dt
      Merge branch 'tegra/dt' into next/dt
      Merge branch 'samsung/dt' into next/dt
      Merge branch 'depends/rmk/for-linus' into samsung/dt
      Merge branch 'next/cleanup' into samsung/dt
      Merge branch 'samsung/dt' into next/dt

Marc Dietrich (1):
      arm/dt: tegra: add dts file for paz00

Mark Brown (1):
      serial: samsung: Fix build for non-Exynos4210 devices

Olof Johansson (3):
      arm/tegra: fix variable formatting in makefile
      arm/dt: add basic usb nodes to tegra device trees
      USB: ehci-tegra: add probing through device tree

Peter De Schrijver (1):
      arm/tegra: initial device tree for tegra30

Stephen Warren (12):
      arm/dt: tegra: Clean up I2S and DAS nodes
      arm/tegra: Add device-tree support for TrimSlice board
      arm/tegra: board-dt: Fix AUXDATA typo
      arm/tegra: board-dt: Enable audio-related clocks
      arm/dt: tegra: Remove /memreserve/ from device-tree files
      arm/dt: tegra: Remove /chosen node
      arm/dt: tegra: Fix I2C nodes to match board files
      arm/dt: tegra: Fix serial nodes to match board files
      arm/dt: tegra: Fix SDHCI nodes to match board files
      arm/dt: tegra: Use new compatible value for DVC I2C controller
      arm/dt: Add ADT7461 to Seaboard
      arm/tegra: Seaboard: Add GPIO key device tree nodes

Thomas Abraham (26):
      ARM: SAMSUNG: Move timer irq numbers to end of linux irq space
      ARM: EXYNOS: Enable conversion of GIC dt irq specifier to linux virq
      gpio/samsung: Add device tree support for EXYNOS4
      serial: samsung: Keep a copy of the location of platform data in driver's private data
      ARM: S3C2440: move handling of fclk/n clock to platform code
      serial: samsung: switch to clkdev based clock lookup
      ARM: SAMSUNG: remove struct 's3c24xx_uart_clksrc' and all uses of it
      serial: samsung: remove all uses of get_clksrc and set_clksrc
      ARM: SAMSUNG: register uart clocks to clock lookup list
      serial: samsung: merge all SoC specific port reset functions
      serial: samsung: merge probe() function from all SoC specific extensions
      serial: samsung: add device tree support
      DMA: PL330: move filter function into driver
      DMA: PL330: Infer transfer direction from transfer request instead of platform data
      ARM: EXYNOS: Modify platform data for pl330 driver
      DMA: PL330: Add device tree support
      ARM: SAMSUNG: Add device tree support for pl330 dma engine wrappers
      ARM: EXYNOS: Limit usage of pl330 device instance to non-dt build
      ARM: EXYNOS: Add a alias for pdma clocks
      ARM: S5P64x0: Modify platform data for pl330 driver
      ARM: S5PC100: Modify platform data for pl330 driver
      ARM: S5PV210: Modify platform data for pl330 driver
      input: samsung-keypad: Add device tree support
      rtc: rtc-s3c: Add device tree support
      ARM: EXYNOS: Add Exynos4 device tree enabled board file
      ARM: dts: Add intial dts file for EXYNOS4210 SoC, SMDKV310 and ORIGEN

pdeschrijver@nvidia.com (1):
      arm/tegra: convert tegra20 to GIC devicetree binding

 .../devicetree/bindings/arm/insignal-boards.txt    |    8 +
 .../devicetree/bindings/arm/samsung-boards.txt     |    8 +
 Documentation/devicetree/bindings/arm/tegra.txt    |   14 +
 .../devicetree/bindings/dma/arm-pl330.txt          |   30 +
 .../devicetree/bindings/gpio/gpio-samsung.txt      |   40 ++
 .../devicetree/bindings/input/samsung-keypad.txt   |   88 +++
 Documentation/devicetree/bindings/rtc/s3c-rtc.txt  |   20 +
 .../devicetree/bindings/serial/samsung_uart.txt    |   14 +
 .../devicetree/bindings/usb/tegra-usb.txt          |   13 +
 arch/arm/boot/dts/exynos4210-origen.dts            |  137 +++++
 arch/arm/boot/dts/exynos4210-smdkv310.dts          |  182 ++++++
 arch/arm/boot/dts/exynos4210.dtsi                  |  397 ++++++++++++
 arch/arm/boot/dts/tegra-harmony.dts                |   29 +-
 arch/arm/boot/dts/tegra-paz00.dts                  |   77 +++
 arch/arm/boot/dts/tegra-seaboard.dts               |   74 +++-
 arch/arm/boot/dts/tegra-trimslice.dts              |   65 ++
 arch/arm/boot/dts/tegra-ventana.dts                |   45 ++-
 arch/arm/boot/dts/tegra20.dtsi                     |   71 ++-
 arch/arm/boot/dts/tegra30.dtsi                     |  127 ++++
 arch/arm/mach-exynos/Kconfig                       |   24 +
 arch/arm/mach-exynos/Makefile                      |    5 +-
 arch/arm/mach-exynos/clock.c                       |  141 +++--
 arch/arm/mach-exynos/common.c                      |   37 +-
 arch/arm/mach-exynos/dma.c                         |  229 ++-----
 arch/arm/mach-exynos/include/mach/irqs.h           |    8 +-
 arch/arm/mach-exynos/mach-exynos4-dt.c             |   85 +++
 arch/arm/mach-s3c2410/mach-bast.c                  |   22 -
 arch/arm/mach-s3c2410/mach-vr1000.c                |   24 -
 arch/arm/mach-s3c2410/s3c2410.c                    |    6 +
 arch/arm/mach-s3c2412/clock.c                      |    7 +
 arch/arm/mach-s3c2440/clock.c                      |   44 ++
 arch/arm/mach-s3c2440/mach-anubis.c                |   22 +-
 arch/arm/mach-s3c2440/mach-at2440evb.c             |   22 +-
 arch/arm/mach-s3c2440/mach-osiris.c                |   24 +-
 arch/arm/mach-s3c2440/mach-rx1950.c                |   18 +-
 arch/arm/mach-s3c2440/mach-rx3715.c                |   19 +-
 arch/arm/mach-s3c64xx/clock.c                      |   37 +-
 arch/arm/mach-s5p64x0/clock-s5p6440.c              |   32 +-
 arch/arm/mach-s5p64x0/clock-s5p6450.c              |   32 +-
 arch/arm/mach-s5p64x0/common.c                     |   31 -
 arch/arm/mach-s5p64x0/dma.c                        |  227 ++-----
 arch/arm/mach-s5p64x0/include/mach/irqs.h          |    2 +
 arch/arm/mach-s5pc100/clock.c                      |   33 +-
 arch/arm/mach-s5pc100/dma.c                        |  247 +++------
 arch/arm/mach-s5pc100/include/mach/irqs.h          |    2 +
 arch/arm/mach-s5pv210/clock.c                      |  107 ++--
 arch/arm/mach-s5pv210/common.c                     |   19 -
 arch/arm/mach-s5pv210/dma.c                        |  241 +++------
 arch/arm/mach-s5pv210/include/mach/irqs.h          |    2 +
 arch/arm/mach-tegra/Makefile                       |    2 +
 arch/arm/mach-tegra/Makefile.boot                  |    2 +
 arch/arm/mach-tegra/board-dt.c                     |   49 ++-
 arch/arm/mach-tegra/irq.c                          |   10 +-
 arch/arm/plat-s3c24xx/s3c2443-clock.c              |   23 +-
 arch/arm/plat-samsung/dma-ops.c                    |   15 +-
 arch/arm/plat-samsung/include/plat/dma-ops.h       |    1 +
 arch/arm/plat-samsung/include/plat/dma-pl330.h     |    3 +-
 arch/arm/plat-samsung/include/plat/irqs.h          |    3 +-
 arch/arm/plat-samsung/include/plat/regs-serial.h   |   45 +-
 drivers/dma/pl330.c                                |   99 ++--
 drivers/gpio/gpio-samsung.c                        |   72 +++
 drivers/input/keyboard/samsung-keypad.c            |  174 +++++-
 drivers/rtc/rtc-s3c.c                              |   21 +-
 drivers/tty/serial/Kconfig                         |   45 +--
 drivers/tty/serial/Makefile                        |    5 -
 drivers/tty/serial/s3c2410.c                       |  115 ----
 drivers/tty/serial/s3c2412.c                       |  149 -----
 drivers/tty/serial/s3c2440.c                       |  178 ------
 drivers/tty/serial/s3c6400.c                       |  149 -----
 drivers/tty/serial/s5pv210.c                       |  158 -----
 drivers/tty/serial/samsung.c                       |  639 ++++++++++++--------
 drivers/tty/serial/samsung.h                       |   32 +-
 drivers/usb/host/ehci-tegra.c                      |   71 +++
 include/linux/amba/pl330.h                         |   15 +-
 74 files changed, 3015 insertions(+), 2248 deletions(-)
