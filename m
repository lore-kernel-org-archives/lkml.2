Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933450Ab2AIWOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 17:14:21 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:53171 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932440Ab2AIWOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 17:14:18 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL 00/11] arm-soc changes
Date: Mon,  9 Jan 2012 22:12:40 +0000
Message-Id: <1326147171-13752-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:096JIFitZ/RlS4YKkCxID0U3gUVdbOLceAdVjMNIZsT
 plsqL8KP6WeJpokdsg+VT+TUI7uaba1e82IjpDw5E0YI/yO9xD
 w1XOJq6dSlHYd17rbouVC6umQVB9gF0iCUEmQ6GYwj3xuO4fMj
 oHGmuxHzfV3Dq20XrrrMMZB5uB779rqGhF018PlysrX4iiwt5s
 cjjMJXfk5MvsndWYl28CLaIIW6XeSZorIymd2Gq9A62qflyWn7
 NQJyei6liRknSqG8YsPq5/1ULbaq5rCju6tQfWW/pirPHmnMEq
 brz4X4Sxo6kWxE6JhR8KOmYqTWtOg0YoBVKZlGKkUHPk4d5+jp
 4lAPzrdYGt1lYW8q8SpBd35X8FbSor6ULZn9e9pPFVw+QR+g3d
 Eq3CF5P5uBnvA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

It took me a while to sort everything out this time, but here are the
majority of the arm-soc changes for this merge window. The total number
of changes has dropped slightly since last time, but there were a
significant number of complex merge conflicts, so I ended up pulling
all of Russell's commits into almost all of these series in order to
resolve them.

As you probably have noticed already, I'm maintaining the arm-soc tree
together with Olof Johansson, and he did a lot of the work, especially
while I was away on vacation. As part of sharing the maintainership,
we have enforced stricter rules about how stuff gets into the arm-soc
tree, and you will notice that for each pull request that we got, there
are actually two changesets in the history: one where we pull into
a fresh topic branch of arm-soc using --no-ff, and another one where
this gets pulled into one of the larger series branches (each of which
becomes one pull request to you), using --no-ff --log. If you think
this is excessive, we can stop using --no-ff, but I like the way
this gives us a clear history.

The extra merge changesets from pulling in the rmk/for-linus branch
through all the samsung/* branches to resolve the conflicts however
are something we will try to avoid in the future, sorry about those.

There are two or three more pull requests coming after this:

1. A next/drivers2 branch that depends on the v4l and the dmaengine
   trees. I will send the request as soon as the dependencies are
   merged

2. A short series moving arch/arm/mach-mx5 into mach-imx
   I want to keep this coming last to avoid merge conflicts with
   other patches to mx5. The patch itself is trivial (all the
   interesting parts are in today's series), so I will recreate
   it end the end of the merge window.

3. A series for stuff that was submitted to arm-soc after the start
   of the merge window. While the patches were in linux-next
   already, I'm currently leaning towards queuing them for 3.4 instead
   of 3.3 because they were never in arm-soc and I have not yet
   looked at them.

I expect you to see four trivial conflicts that you will have to
resolve, unless other new patches have been merged in the meantime:
- arch/arm/mach-tegra/board-dt-tegra20.c, a function has been removed
  and the patch conflicted with a merge between two other conflicting
  patches.
- drivers/net/ethernet/freescale/fec.c, a clk cleanup conflicted with
  the netdev tree.
- arch/arm/mach-s3c2440/clock.c, addition conflicts with the sys_device
  removal.
- drivers/tty/serial/Kconfig, some Kconfig symbols were removed, and
  the context changed.


For each branch "next/foo", there is also a signed tag "foo" on the
arm-soc git. Please pull whichever of these you prefer.

Thanks,

	Arnd

---
The following changes since commit 7b9dd47136c07ffd883aff6926c7b281e4c1eea4:

  Merge branch 'restart' into for-linus (2012-01-05 13:25:27 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git for-linus-combined

Aaro Koskinen (2):
      ARM: OMAP3: rx51: enable tsc2005 touchscreen
      ARM: OMAP: hwmod data: fix the panic on Nokia RM-680 during boot

Abhilash K V (1):
      ARM: OMAP: hsmmc: Support for AM3517 MMC1 voltages

Afzal Mohammed (2):
      ARM: OMAP: am33xx: Update common omap platform files
      ARM: OMAP: am33xx: Update common OMAP machine specific sources

Ajay Kumar Gupta (1):
      ARM: OMAP: musb: Add ti81xx phy power function

Andrew Lunn (4):
      ARM: Orion: Consolidate the address map setup
      ARM: Orion: mbus_dram_info consolidation
      ARM: Orion: Get address map from plat-orion instead of via platform_data
      ARM: Orion: Remove address map info from all platform data structures

Arnaud Patard (1):
      ARM: Kirkwood: Add configuration for MPP12 as GPIO

Arnd Bergmann (68):
      Merge branches 'drivers/macb-gem' and 'drivers/pxa-gpio' into next/drivers
      Merge branch 'drivers/macb-gem-cleanup' into at91/gpio
      Merge branches 'at91/gpio', 'at91/ioremap', 'drivers/macb-gem-cleanup' and 'msm/misc' into next/cleanup
      Merge branch 'mxs/saif' into next/drivers
      Merge branch 'drivers/pxa-gpio' into next/drivers
      Merge branch 'davinci/cleanup' into next/cleanup
      Merge branch 'at91/macb' into next/drivers
      Merge branch 'ehci' of git://git.kernel.org/.../tmlind/linux-omap into omap/ehci
      Merge branch 'hwmod' of git://git.kernel.org/.../tmlind/linux-omap into omap/hwmod
      Merge branch 'omap/hwmod' into next/devel
      Merge branch 'omap/hwmod' into next/drivers
      Merge branch 'omap/ehci' into next/drivers
      Merge branch 'tegra/cleanup' into next/cleanup
      Merge branch 'for-3.3/dt' of git://git.kernel.org/.../olof/tegra into tegra/dt
      Merge branch 'for-3.3/soc' of git://git.kernel.org/.../olof/tegra into tegra/soc
      Merge branches 'depends/rmk/devel-stable' and 'tegra/dt' into next/soc
      Merge branch 'tegra/soc' into next/soc
      Merge branch 'for-3.3/boards' of git://git.kernel.org/.../olof/tegra into tegra/boards
      Merge branch 'tegra/boards' into next/boards
      Merge branch 'for-3.3/drivers' of git://git.kernel.org/.../olof/tegra into tegra/drivers
      Merge branch 'tegra/drivers' into next/drivers
      Merge branch 'next-samsung-devel-dt1' of git://git.kernel.org/.../kgene/linux-samsung into samsung/dt
      Merge branch 'tegra/cleanup' into next/dt
      Merge branch 'tegra/dt' into next/dt
      Merge branch 'samsung/dt' into next/dt
      Merge branch 'next-samsung-devel-ohci' of git://git.kernel.org/.../kgene/linux-samsung into samsung/ohci
      Merge branch 'v3.2-rc6' into next/drivers
      Merge branch 'samsung/ohci' into next/drivers
      Merge branch 'next-samsung-cleanup-mmc2' of git://git.kernel.org/.../kgene/linux-samsung into samsung/cleanup
      Merge branch 'next-samsung-devel-spi3' of git://git.kernel.org/.../kgene/linux-samsung into samsung/cleanup
      Merge branch 'next-samsung-cleanup-spi4' of git://git.kernel.org/.../kgene/linux-samsung into samsung/cleanup
      Merge branch 'samsung/cleanup' into next/cleanup2
      Merge branch 'next-samsung-devel-mmc-spi5' of git://git.kernel.org/.../kgene/linux-samsung into samsung/driver
      Merge branch 'samsung/cleanup' into next/drivers
      Merge branch 'samsung/driver' into next/drivers
      Merge branch 'drivers/pxa-gpio' into next/drivers
      Merge branch 'drivers/rtc-sa1100' into next/drivers
      Merge branch 'pxa/board' into next/boards
      Merge branch 'pxa/fixes-non-critical' into next/fixes-non-critical
      Merge branch 'imx/pm' of git://git.linaro.org/people/shawnguo/linux-2.6 into imx6/pm
      Merge branch 'v3.2-rc7' into next/pm
      Merge branch 'imx6/pm' into next/pm
      Merge branch 'mxs/clk-prepare' of git://git.linaro.org/people/shawnguo/linux-2.6 into imx/clk
      Merge branch 'imx/clk' into next/clk
      Merge branch 'imx-features-assorted' of git://git.pengutronix.de/git/imx/linux-2.6 into imx/board
      Merge branch 'imx/board' into next/boards
      Merge branch 'tegra/soc' into next/boards
      Merge branch 'depends/rmk/restart' into next/cleanup
      Merge branch 'depends/rmk/for-linus' into samsung/dt
      Merge branch 'next/cleanup' into samsung/dt
      Merge branch 'samsung/dt' into next/dt
      Merge branch 'depends/rmk/for-linus' into next/soc
      Merge branch 'samsung/dt' into samsung/cleanup
      Merge branch 'samsung/cleanup' into next/cleanup2
      Merge branch 'samsung/cleanup' into samsung/driver
      Merge branch 'samsung/driver' into next/drivers
      Merge branch 'next/fixes-non-critical' into for-next3
      Merge branch 'next/cleanup' into for-next3
      Merge branch 'next/dt' into for-next3
      Merge branch 'next/cleanup2' into for-next3
      Merge branch 'next/soc' into for-next2
      Merge branch 'samsung/cleanup' into next/boards
      Merge branch 'next/boards' into for-next3
      Merge branch 'next/devel' into for-next3
      Merge branch 'next/drivers' into for-next3
      Merge branch 'next/pm' into for-next3
      Merge branch 'next/timer' into for-next3
      Merge branch 'next/clk' into for-next3

Axel Lin (3):
      pcmcia: pxa: replace IRQ_GPIO() with gpio_to_irq()
      Input: zylonite-wm97xx - replace IRQ_GPIO() with gpio_to_irq()
      ARM: pxa: Include linux/export.h in balloon3.c

Benoit Cousson (2):
      ARM: OMAP: USB: EHCI and OHCI hwmod structures for OMAP4
      ARM: OMAP4: hwmod: Don't wait for the idle status if modulemode is not supported

David Anders (1):
      ARM: OMAP: id: add chip id recognition for omap4430 es2.3

Deepak K (1):
      ARM: OMAP2+: UART: Allow UART parameters to be configured from board file.

Denis Kuzmenko (1):
      ARM: S3C2440: Add new LCD (W35i) support for Mini2440 board

Dirk Behme (1):
      arm/imx6q: Rename Sabreauto to Armadillo2

Dong Aisheng (4):
      ASoC: mxs-saif: remove function in platform_data
      ARM: mxs: add saif clkmux functions
      ARM: mx28evk: add platform data for saif
      ARM: mx28evk: set a initial clock rate for saif

Eliad Peller (3):
      omap_hsmmc: consider MMC_PM_KEEP_POWER on suspend/resume
      ARM: OMAP: hsmmc: add pm_caps field
      ARM: OMAP: hsmmc: board-sdp4430: declare support for MMC_PM_KEEP_POWER

Eric Miao (3):
      ARM: imx6q: generate imx6q dtb files
      ARM: imx6q: build pm code only when CONFIG_PM selected
      ARM: imx6q: resume PL310 only when CACHE_L2X0 defined

Fabio Estevam (1):
      ARM: mx31pdk: Add MC13783 RTC support

Govindraj R (1):
      ARM: OMAP2+: hwmod: Add API to enable IO ring wakeup

Govindraj.R (19):
      ARM: OMAP2+: UART: cleanup + remove uart pm specific API
      ARM: OMAP2+: UART: cleanup 8250 console driver support
      ARM: OMAP2+: UART: Cleanup part of clock gating mechanism for uart
      ARM: OMAP2+: UART: Add default mux for all uarts.
      ARM: OMAP2+: UART: Remove mapbase/membase fields from pdata.
      ARM: OMAP2+: UART: Add runtime pm support for omap-serial driver
      ARM: OMAP2+: UART: Remove context_save and move context restore to driver
      ARM: OMAP2+: UART: Ensure all reg values configured are available from port structure
      ARM: OMAP2+: UART: Remove uart reset function.
      ARM: OMAP2+: UART: Get context loss count to context restore
      ARM: OMAP2+: UART: Move errata handling from serial.c to omap-serial
      ARM: OMAP2+: UART: Add wakeup mechanism for omap-uarts
      ARM: OMAP2+: UART: Remove old and unused clocks handling funcs
      ARM: OMAP2+: UART: remove temporary variable used to count uart instance
      ARM: OMAP2+: UART: Avoid console uart idling during bootup
      ARM: OMAP2+: UART: Avoid uart idling on suspend for no_console_suspend usecase
      ARM: OMAP2+: UART: Do not gate uart clocks if used for debug_prints
      ARM: OMAP2+: UART: Remove omap_uart_can_sleep and add pm_qos
      ARM: OMAP2+: UART: Fix compilation/sparse warnings

Gwenhael Goavec-Merou (1):
      MX1:apf9328: Add i2c support

Haojian Zhuang (14):
      ARM: pxa: rename IRQ_GPIO to PXA_GPIO_TO_IRQ
      ARM: pxa: use chained interrupt for GPIO0 and GPIO1
      ARM: pxa: rename gpio_to_irq and irq_to_gpio
      ARM: pxa: recognize gpio number and type
      ARM: pxa: rename NR_BUILTIN_GPIO
      ARM: pxa: use little endian read write in gpio driver
      ARM: pxa: use generic gpio operation instead of gpio register
      ARM: pxa: change gpio to platform device
      ARM: mmp: clear gpio edge detect
      ARM: pxa: add clk support in gpio driver
      driver: pcmcia: replace IRQ_GPIO() with gpio_to_irq()
      ARM: pxa: fix the build error because of missing gpio-pxa.h
      ARM: pxa: fix build error for GPIO_bit()
      MAINTAINERS: update pxa and mmp

Hemant Pedanekar (3):
      ARM: OMAP: TI81XX: Prepare for addition of TI814X support
      ARM: OMAP: TI814X: Add cpu type macros and detection support
      ARM: OMAP: TI814X: Create board support and enable build for TI8148 EVM

Hui Wang (1):
      ARM: mx5: use generic irq chip pm interface for pm functions on

Igor Dmitriev (1):
      ARM: OMAP3: sdram-nokia: add 200 MHz memory timings info

Igor Grinberg (6):
      ARM: OMAP: hsmmc: Add support for MMC 2 setup for AM35x
      ARM: OMAP3: cm-t35: Add regulator for ads7846 touchscreen
      ARM: OMAP3: cm-t35: Use correct DSS regulator supply
      ARM: OMAP3: cm-t35: enable audio
      ARM: OMAP3: cm-t35: Add reset for USB hub
      ARM: OMAP3: cm-t35: fix mux mode for DSS pins

Jaccon Bastiaansen (1):
      Enable 32 bit flash support for iMX21ADS board

Jamie Iles (14):
      at91: provide macb clks with "pclk" and "hclk" name
      macb: remove conditional clk handling
      macb: unify at91 and avr32 platform data
      macb: initial support for Cadence GEM
      macb: convert printk to netdev_ and friends
      macb: support higher rate GEM MDIO clock divisors
      macb: support statistics for GEM devices
      macb: support DMA bus widths > 32 bits
      macb: allow GEM to have configurable receive buffer size
      ARM: picoxcell: remove mach/memory.h
      ARM: picoxcell: don't reserve irq_descs
      ARM: picoxcell: move io mappings to common.c
      MAINTAINERS: add maintainer entry for Picochip picoxcell
      ARM: picoxcell: implement watchdog restart

Janusz Krzysztofik (3):
      ARM: OMAP1: Move dpll1 rates selection from config to runtime
      ARM: OMAP1: Update dpll1 default rate reprogramming method
      ARM: OMAP1: Always reprogram dpll1 rate at boot

Jean-Christophe PLAGNIOL-VILLARD (27):
      ARM: at91: define CLOCK_TICK_RATE to bogus value except A91X40
      ARM: at91: make gpio register base soc independant
      ARM: at91: make ecc register base soc independant
      ARM: at91: make dma register base soc independant
      ARM: at91: make rtt register base soc independant
      ARM: at91: add ioremap_registers entry point to soc setup
      ARM: at91: make pit register base soc independent
      ARM: at91: make smc register base soc independent
      ARM: at91: drop CCFG
      ARM: at91: make shutdown controler soc independent
      ARM: at91: make watchdog drivers soc independent
      ARM: at91: make DBGU soc independent
      ARM: at91: make aic soc independent
      ARM: at91: make rm9200 rtc drivers soc independent
      ARM: at91: switch gpio clock to clkdev
      ARM: at91: gpio make struct at91_gpio_bank an initdata
      ARM: at91/boards: use -EINVAL for invalid gpio
      ARM: at91/soc: use gpio_is_valid to check the gpio
      ARM: at91/pata: use gpio_is_valid to check the gpio
      ARM: at91/ide: use gpio_is_valid to check the gpio
      ARM: at91/mmc: use gpio_is_valid to check the gpio
      ARM: at91/nand: use gpio_is_valid to check the gpio
      ARM: at91/ohci: use gpio_is_valid to check the gpio
      ARM: at91/udc: use gpio_is_valid to check the gpio
      ARM: at91/gpio: drop PIN_BASE
      ARM: at91/gpio: fix display of number of irq setuped
      net/macb: add DT support for Cadence macb/gem driver

Jett.Zhou (5):
      RTC: sa1100: Clean out ost register
      RTC: sa1100: remove redundant code of setting alarm
      RTC: sa1100: support sa1100, pxa and mmp soc families
      ARM: pxa: add dummy clock for sa1100-rtc
      ARM: sa1100: clean up of the clock support

Jingoo Han (5):
      ARM: EXYNOS: Add USB OHCI device
      ARM: EXYNOS: Add USB OHCI support to SMDKV310 board
      USB: Add Samsung Exynos OHCI diver
      ARM: S5PV210: Use gpio_request_one
      ARM: EXYNOS: Use gpio_request_one

Jon Hunter (1):
      ARM: OMAP2+: UART: Make the RX_TIMEOUT for DMA configurable for each UART

Keshava Munegowda (5):
      ARM: OMAP: USB: EHCI and OHCI hwmod structures for OMAP3
      ARM: OMAP: USB: register hwmods of usbhs
      ARM: OMAP: USB: device name change for the clk names of usbhs
      ARM: OMAP: USBHOST: Replace usbhs core driver APIs by Runtime pm APIs
      MFD: OMAP: USB: Runtime PM support

Kyle Manna (1):
      ARM: OMAP: hwmod data: Add support for AM35xx UART4/ttyO3

Leon Romanovsky (1):
      ARM: tegra: paz00: Fix board pinmux table.

Leonid Iziumtsev (1):
      ARM: OMAP: ID: Chip detection for OMAP4470

Linus Walleij (7):
      ARM: ux500: update the MOP500 GPIO assignments
      ARM: ux500: update ASIC detection for U5500
      ARM: ux500: update register files
      ARM: ux500: remove support for early silicon revisions
      ARM: ux500: fix the smp_twd clock calculation
      ARM: u300: delete memory.h
      mfd/db8500-prcmu: remove support for early silicon revisions

Manjunath Hadli (1):
      ARM: davinci: vpif: move code to driver core header from platform

Marc Dietrich (2):
      arm/dt: tegra: add dts file for paz00
      ARM: tegra: paz00: add support for wakeup gpio key

Mark Brown (13):
      ARM: S3C64XX: Update for conversion to SAMSUNG_GPIO_EXTRA
      ARM: SAMSUNG: Fix GPIO space reservation for S3C64xx platforms
      ARM: S3C64XX: Correct reservation of GPIOs for CPU module on Cragganmore
      ARM: S3C64XX: Raise the frequency of the second I2C bus on Cragganmore
      ARM: S3C64XX: Use software initiated powerdown for Cragganmore
      ARM: S3C64XX: Configure WM1250 EV1 GPIOs on Cragganmore
      ARM: S3C64XX: Improve logging of unknown Cragganmore module types
      ARM: S3C64XX: Run Tobermory interrupts in the default mode
      ARM: S3C64XX: Hook up platform data for Kilchomin module on Cragganmore
      ARM: S3C64XX: Hook up Littlemill audio card on Cragganmore
      ARM: S3C64XX: Power gate unused domains
      ARM: S3C64XX: Hook up VDDINT on Cragganmore
      serial: samsung: Fix build for non-Exynos4210 devices

Martin Michlmayr (1):
      ARM: Kirkwood: Recognize A1 revision of 6282 chip

Murali Karicheri (1):
      ARM: davinci: add support for multiple power domains

Nicolas Ferre (2):
      ARM: at91/net: add macb ethernet controller in 9g45/9g20 DT
      net/at91_ether: use gpio_is_valid for phy IRQ line

Olof Johansson (48):
      arm/tegra: fix variable formatting in makefile
      arm/dt: add basic usb nodes to tegra device trees
      USB: ehci-tegra: add probing through device tree
      arm/tegra: fix variable formatting in makefile
      Merge branch 'omap4' of git://git.kernel.org/.../tmlind/linux-omap into omap/omap4
      Merge branch 'omap/omap4' into next/pm
      Merge branch 'omap/omap1' into next/devel
      Merge branch 'hsmmc' of git://git.kernel.org/.../tmlind/linux-omap into omap/hsmmc
      Merge branch 'fixes-non-critical' of git://git.kernel.org/.../tmlind/linux-omap into omap/fixes-non-critical
      Merge branch 'omap/hsmmc' into next/drivers
      Merge branch 'omap/fixes-non-critical' into next/fixes-non-critical
      Merge branch 'ux500/devel' into next/devel
      Merge branch 'for-3.3' of git://sources.calxeda.com/kernel/linux into highbank/devel
      Merge branch 'highbank/devel' into next/devel
      Merge branch 'orion/devel' into next/devel
      Merge branch 'v3.3/features' of git://gitorious.org/linux-davinci/linux-davinci into davinci/features
      Merge branch 'soc' of git://git.kernel.org/.../tmlind/linux-omap into omap/soc
      Merge branch 'board' of git://git.kernel.org/.../tmlind/linux-omap into omap/board
      Merge branch 'musb' of git://git.kernel.org/.../tmlind/linux-omap into omap/musb
      Merge branch 'imx6/boards' of git://git.linaro.org/people/shawnguo/linux-2.6 into imx6/boards
      Merge branch 'for-arnd-3.3-defconfig' of git://github.com/at91linux/linux-at91 into at91/defconfig
      Merge branch 'davinci/features' into next/devel
      Merge branch 'omap/soc' into next/soc
      Merge branch 'at91/defconfig' into next/cleanup
      Merge branch 'depends/rmk/devel-stable' into next/boards
      Merge branch 'omap/board' into next/boards
      Merge branch 'omap/musb' into next/boards
      Merge branch 'imx6/boards' into next/boards
      Merge branch 'samsung/board' into next/boards
      Merge remote-tracking branch 'rmk/devel-stable' into for-3.3/soc
      arm/tegra: refresh defconfig for tegra30
      Merge branch 'prcm' of git://git.kernel.org/.../tmlind/linux-omap into omap/prcm
      Merge branch 'omap/prcm' into next/pm
      Merge branch 'uart' of git://git.kernel.org/.../tmlind/linux-omap into omap/uart
      Merge branch 'omap/uart' into next/pm
      Merge branch 'picoxcell/devel' into next/devel
      Merge branch 'picoxcell/cleanup' into next/cleanup
      Merge branch 'ux500/devel' into next/devel
      Merge branch 'u300/cleanup' into next/cleanup
      arm/tegra: remove __initdata annotation from pinmux tables
      net: macb: fix build break with !CONFIG_OF
      arm/at91: fix build of stamp9g20
      Merge branch 'omap/fixes-hwmod' into next/fixes-non-critical
      Merge branch 'omap/fixes-non-critical-part2' into next/fixes-non-critical
      Merge branch 'next-samsung-cleanup-samsung' of git://git.kernel.org/.../kgene/linux-samsung into samsung/cleanup
      Merge branch 'samsung/cleanup' into next/cleanup2
      Merge branch 'imx/pm2' of git://git.linaro.org/people/shawnguo/linux-2.6 into imx6/pm
      Merge branch 'imx6/pm' into next/pm

Padmavathi Venna (13):
      spi/s3c64xx: Use bus clocks created using clkdev
      ARM: S3C64XX: Add SPI clkdev support
      ARM: S5PC100: Add SPI clkdev support
      ARM: S5P64X0: Add SPI clkdev support
      ARM: S5PV210: Add SPI clkdev support
      ARM: SAMSUNG: Remove SPI bus clocks from platform data
      ARM: SAMSUNG: Consolidation of SPI platform devices to plat-samsung
      ARM: S3C64XX: Modified files for SPI consolidation work
      ARM: S5PC100: Modified files for SPI consolidation work
      ARM: S5P64X0: Modified files for SPI consolidation work
      ARM: S5PV210: Modified files for SPI consolidation work
      ARM: S3C64XX: Modified according to SPI consolidation work
      ARM: EXYNOS: Modified files for SPI consolidation work

Paul Fertser (1):
      iomux-mx25: configuration to support CSPI3 on CSI pins

Paul Gortmaker (1):
      ARM: at91: delete the pcontrol_g20_defconfig

Paul Walmsley (4):
      ARM: OMAP3: hwmod data: disable multiblock reads on MMC1/2 on OMAP34xx/35xx <= ES2.1
      ARM: OMAP2+: mux: add wakeup-capable hwmod mux entries to dynamic list
      ARM: OMAP3/4: PRM: add functions to read pending IRQs, PRM barrier
      ARM: OMAP: AM3517/3505: fix crash on boot due to incorrect voltagedomain data

Peter De Schrijver (15):
      arm/tegra: initial device tree for tegra30
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

Peter Ujfalusi (4):
      ARM: OMAP2+: DMA: Workaround for invalid source position
      ARM: OMAP2+: DMA: Workaround for invalid destination position
      ARM: OMAP4: devices: Register OMAP4 DMIC platform device
      ARM: OMAP4: board-4430sdp: Register platform device for digimic codec

Rabin Vincent (2):
      ARM: ux500: support DB8520
      ARM: ux500: register DB5500 PMU dynamically

Rajendra Nayak (5):
      ARM: OMAP2+: hwmod: Add a new flag to handle hwmods left enabled at init
      omap-serial: Get rid of all pdev->id usage
      omap-serial: Use default clock speed (48Mhz) if not specified
      omap-serial: Add minimal device tree support
      ARM: omap: pass minimal SoC/board data for UART from dt

Rajeshwari Shinde (6):
      ARM: SAMSUNG: Remove SDHCI bus clocks from platform data
      ARM: SAMSUNG: Add lookup of sdhci-s3c clocks using generic names
      mmc: sdhci-s3c: Use generic clock names for sdhci bus clock options
      ARM: S5P64X0: Add HSMMC setup for host Controller
      ARM: S5P64X0: Add lookup of sdhci-s3c clocks using generic names
      ARM: S5P64X0: Enable SDHCI support

Ravi Babu (2):
      ARM: OMAP: musb: Adding support for ti81xx
      ARM: OMAP: musb: Add support for ti816evm

Richard Zhao (6):
      dts/imx: rename gpio labels to consistent with hw spec
      dts/imx: rename uart labels to consistent with hw spec
      arm/imx6: add imx6q sabrelite board support
      arm/imx6q-sabrelite: add enet phy ksz9021rn fixup
      clk: add helper functions clk_prepare_enable and clk_disable_unprepare
      net: fec: add clk_prepare/clk_unprepare

Rob Herring (1):
      ARM: highbank: add xgmac ethernet devices to dts

Robert Jarzmik (1):
      mioa701: add newly available DoC G3 chip

Santosh Shilimkar (25):
      ARM: OMAP4: Use WARN_ON() instead of BUG_ON() with graceful exit
      ARM: OMAP4: Export omap4_get_base*() rather than global address pointers
      ARM: OMAP4: PM: Add SAR RAM support
      ARM: OMAP4: PM: Keep static dep between MPUSS-EMIF and MPUSS-L3/L4 and DUCATI-L3
      ARM: OMAP4: PM: Avoid omap4_pm_init() on OMAP4430 ES1.0
      ARM: OMAP4: PM: Initialise all the clockdomains to supported states
      ARM: OMAP: Add Secure HAL and monitor mode API infrastructure.
      ARM: OMAP: PM: Add support to allocate the memory for secure RAM
      ARM: OMAP4: PM: Add WakeupGen module as OMAP gic_arch_extn
      ARM: OMAP4: PM: Add CPUX OFF mode support
      ARM: OMAP4: Remove __INIT from omap_secondary_startup() to re-use it for hotplug.
      ARM: OMAP4: PM: Program CPU1 to hit OFF when off-lined
      ARM: OMAP4: PM: CPU1 wakeup workaround from Low power modes
      ARM: OMAP4: PM: Use custom omap_do_wfi() for default idle.
      ARM: OMAP4: suspend: Add MPUSS power domain RETENTION support
      ARM: OMAP4: Remove un-used do_wfi() macro.
      ARM: OMAP4: PM: Add WakeupGen and secure GIC low power support
      ARM: OMAP4: PM: Add L2X0 cache lowpower support
      ARM: OMAP4: PM: Add MPUSS power domain OSWR support
      ARM: OMAP4: PM: Add power domain statistics support
      ARM: OMAP4: Fix errata i688 with MPU interconnect barriers.
      ARM: OMAP4: PM: Add CPUidle support
      ARM: OMAP4: cpuidle: Switch to gptimer from twd in deeper C-states.
      ARM: OMAP3: CPUidle: Make use of CPU PM notifiers
      ARM: OMAP4: clock: Add CPU local timer clock node

Shawn Guo (13):
      ARM: EXYNOS: remove exynos4_scu_enable()
      ARM: mxs: convert platform code to clk_prepare/clk_unprepare
      dma: mxs-dma: convert to clk_prepare/clk_unprepare
      mmc: mxs-mmc: convert to clk_prepare/clk_unprepare
      mtd: gpmi-lib: convert to clk_prepare/clk_unprepare
      net: flexcan: convert to clk_prepare/clk_unprepare
      serial: mxs-auart: convert to clk_prepare/clk_unprepare
      video: mxsfb: convert to clk_prepare/clk_unprepare
      ASoC: mxs-saif: convert to clk_prepare/clk_unprepare
      clk: add config option HAVE_CLK_PREPARE into Kconfig
      ARM: mxs: select HAVE_CLK_PREPARE for clock
      ARM: imx6: fix v7_invalidate_l1 by adding I-Cache invalidation
      ARM: imx6: remove __CPUINIT annotation from v7_invalidate_l1

Shubhrajyoti D (1):
      ARM: OMAP3+: hwmod data: Add the default clockactivity for I2C

Stefan Nilsson XK (2):
      ARM: ux500: support SD cards on HREFv60 boards
      ARM: ux500: add device sdi1 for SDIO

Stephen Boyd (11):
      ARM: msm: Consolidate and move DEBUG_LL to DEBUG_LL choice
      msm: Support DEBUG_LL on MSM8660 and MSM8960
      msm: timer: Tighten #ifdef for local timer support
      msm: timer: Cleanup #includes and #defines
      msm: timer: Use GPT for clockevents and DGT for clocksource
      msm: timer: Fix ONESHOT mode interrupts
      msm: timer: Remove msm_clocks[] and simplify code
      msm: timer: Remove SoC specific #ifdefs
      msm: timer: Setup interrupt after registering clockevent
      msm: timer: Use clockevents_config_and_register()
      msm: platsmp: Mark ioremapped memory as __iomem

Stephen Warren (29):
      arm/dt: tegra: Clean up I2S and DAS nodes
      arm/tegra: Add device-tree support for TrimSlice board
      arm/tegra: board-dt: Fix AUXDATA typo
      arm/tegra: board-dt: Enable audio-related clocks
      arm/dt: tegra: Remove /memreserve/ from device-tree files
      arm/dt: tegra: Remove /chosen node
      arm/dt: tegra: Fix I2C nodes to match board files
      arm/dt: tegra: Fix serial nodes to match board files
      arm/dt: tegra: Fix SDHCI nodes to match board files
      arm/tegra: Remove code that's ifndef CONFIG_ARM_GIC
      i2c: tegra: Add __devinit/exit to probe/remove
      i2c: tegra: Support DVC controller in device tree
      arm/dt: tegra: Use new compatible value for DVC I2C controller
      arm/dt: Add ADT7461 to Seaboard
      arm/tegra: Seaboard: Add GPIO key device tree nodes
      arm/tegra: Split Seaboard GPIO table to allow for Ventana
      arm/tegra: Add AUXDATA for tegra-pinmux and tegra-gpio
      arm/tegra: Harmony PCIe: Don't touch pinmux
      arm/tegra: PCIe: Remove include of mach/pinmux.h
      arm/tegra: Remove useless entries from ventana_pinmux[]
      arm/tegra: Rework Seaboard-vs-Ventana pinmux table
      arm/tegra: Fix mistake in Trimslice's pinmux
      arm/tegra: Refactor board-*-pinmux.c to share code
      arm/tegra: Use bus notifiers to trigger pinmux setup
      arm/tegra: Fix section mismatch errors in tegra20 pinmux
      arm/tegra: Fix section mismatch errors in tegra30 pinmux
      arm/tegra: Delete tegra_init_clock()
      arm/tegra: Make MACH_TEGRA_DT depend on ARCH_TEGRA_2x_SOC
      arm/tegra: Compile tegra_dt_init_irq only when CONFIG_OF

Tero Kristo (6):
      ARM: OMAP: PRCM: add support for chain interrupt handler
      ARM: OMAP: PRCM: add suspend prepare / finish support
      ARM: OMAP2+: mux: add support for PAD wakeup interrupts
      ARM: OMAP: hwmod: add support for selecting mpu_irq for each wakeup pad
      ARM: OMAP3: pm: use prcm chain handler
      ARM: OMAP4: PRM: use PRCM interrupt handler

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

Thomas Meyer (1):
      ARM: SAMSUNG: Use kmemdup rather than duplicating its implementation

Thomas Weber (1):
      ARM: OMAP: hsmmc: Add support for non-OMAP pins

Tony Lindgren (8):
      Merge branch 'for_3.3/pm/omap4-mpuss' of git://git.kernel.org/.../khilman/linux-omap-pm into omap4
      ARM: OMAP1: Set the omap1623 sram size to 16K
      Merge branch 'tk_prm_chain_handler_devel_3.3' of git://git.pwsan.com/linux-2.6 into prcm
      Merge branch 'for_3.3/uart/runtime-pm' of git://git.kernel.org/.../khilman/linux-omap-pm into uart
      arm/dts: Add minimal device tree support for omap2420 and omap2430
      Merge branch 'hwmod_data_fixes_3.2rc' of git://git.pwsan.com/linux-2.6 into fixes-hwmod
      Merge branch 'hwmod_data_devel_3.3' of git://git.pwsan.com/linux-2.6 into hwmod
      Merge branch 'usbhost_runtime_pm_14_devel_3.3' of git://git.pwsan.com/linux-2.6 into ehci

Tushar Behera (1):
      ARM: EXYNOS: Add USB OHCI support to ORIGEN board

Vaibhav Hiremath (1):
      ARM: OMAP: hsmmc: Add support for AM3517EVM base-board MMC slot

pdeschrijver@nvidia.com (2):
      arm/tegra: remove unused defines
      arm/tegra: convert tegra20 to GIC devicetree binding

 Documentation/devicetree/bindings/arm/fsl.txt      |    8 +-
 .../devicetree/bindings/arm/insignal-boards.txt    |    8 +
 .../devicetree/bindings/arm/samsung-boards.txt     |    8 +
 Documentation/devicetree/bindings/arm/tegra.txt    |   14 +
 .../devicetree/bindings/dma/arm-pl330.txt          |   30 +
 .../devicetree/bindings/gpio/gpio-samsung.txt      |   40 +
 .../devicetree/bindings/input/samsung-keypad.txt   |   88 ++
 Documentation/devicetree/bindings/net/macb.txt     |   25 +
 Documentation/devicetree/bindings/rtc/s3c-rtc.txt  |   20 +
 .../devicetree/bindings/serial/omap_serial.txt     |   10 +
 .../devicetree/bindings/serial/samsung_uart.txt    |   14 +
 .../devicetree/bindings/usb/tegra-usb.txt          |   13 +
 MAINTAINERS                                        |   31 +-
 arch/arm/Kconfig                                   |    7 +-
 arch/arm/Kconfig.debug                             |   45 +
 arch/arm/boot/dts/at91sam9g20.dtsi                 |    7 +
 arch/arm/boot/dts/at91sam9g45.dtsi                 |    7 +
 arch/arm/boot/dts/at91sam9m10g45ek.dts             |    5 +
 arch/arm/boot/dts/exynos4210-origen.dts            |  137 +++
 arch/arm/boot/dts/exynos4210-smdkv310.dts          |  182 ++++
 arch/arm/boot/dts/exynos4210.dtsi                  |  397 +++++++++
 arch/arm/boot/dts/highbank.dts                     |   12 +
 arch/arm/boot/dts/imx51-babbage.dts                |   17 +-
 arch/arm/boot/dts/imx51.dtsi                       |   20 +-
 arch/arm/boot/dts/imx53-ard.dts                    |   18 +-
 arch/arm/boot/dts/imx53-evk.dts                    |   17 +-
 arch/arm/boot/dts/imx53-qsb.dts                    |   18 +-
 arch/arm/boot/dts/imx53-smd.dts                    |   19 +-
 arch/arm/boot/dts/imx53.dtsi                       |   34 +-
 .../dts/{imx6q-sabreauto.dts => imx6q-arm2.dts}    |   12 +-
 arch/arm/boot/dts/imx6q-sabrelite.dts              |   49 ++
 arch/arm/boot/dts/imx6q.dtsi                       |   34 +-
 arch/arm/boot/dts/omap2.dtsi                       |   67 ++
 arch/arm/boot/dts/omap3.dtsi                       |   31 +
 arch/arm/boot/dts/omap4.dtsi                       |   28 +
 arch/arm/boot/dts/tegra-cardhu.dts                 |   36 +
 arch/arm/boot/dts/tegra-harmony.dts                |   29 +-
 arch/arm/boot/dts/tegra-paz00.dts                  |   77 ++
 arch/arm/boot/dts/tegra-seaboard.dts               |   74 ++-
 arch/arm/boot/dts/tegra-trimslice.dts              |   65 ++
 arch/arm/boot/dts/tegra-ventana.dts                |   45 +-
 arch/arm/boot/dts/tegra20.dtsi                     |   71 +-
 arch/arm/boot/dts/tegra30.dtsi                     |  127 +++
 arch/arm/boot/dts/usb_a9g20.dts                    |    5 +
 arch/arm/configs/imx_v4_v5_defconfig               |    1 -
 arch/arm/configs/omap1_defconfig                   |    1 -
 arch/arm/configs/pcontrol_g20_defconfig            |  175 ----
 arch/arm/configs/tegra_defconfig                   |    9 +-
 arch/arm/mach-at91/Kconfig                         |   24 +-
 arch/arm/mach-at91/at91cap9.c                      |   40 +-
 arch/arm/mach-at91/at91cap9_devices.c              |   49 +-
 arch/arm/mach-at91/at91rm9200.c                    |   24 +-
 arch/arm/mach-at91/at91rm9200_devices.c            |   48 +-
 arch/arm/mach-at91/at91rm9200_time.c               |    8 +-
 arch/arm/mach-at91/at91sam9260.c                   |   36 +-
 arch/arm/mach-at91/at91sam9260_devices.c           |   55 +-
 arch/arm/mach-at91/at91sam9261.c                   |   32 +-
 arch/arm/mach-at91/at91sam9261_devices.c           |   33 +-
 arch/arm/mach-at91/at91sam9263.c                   |   45 +-
 arch/arm/mach-at91/at91sam9263_devices.c           |   59 +-
 arch/arm/mach-at91/at91sam926x_time.c              |   38 +-
 arch/arm/mach-at91/at91sam9g45.c                   |   44 +-
 arch/arm/mach-at91/at91sam9g45_devices.c           |   69 +-
 arch/arm/mach-at91/at91sam9rl.c                    |   36 +-
 arch/arm/mach-at91/at91sam9rl_devices.c            |   43 +-
 arch/arm/mach-at91/board-1arm.c                    |    4 +-
 arch/arm/mach-at91/board-afeb-9260v1.c             |   10 +-
 arch/arm/mach-at91/board-cam60.c                   |    8 +-
 arch/arm/mach-at91/board-cap9adk.c                 |   21 +-
 arch/arm/mach-at91/board-carmeva.c                 |    9 +-
 arch/arm/mach-at91/board-cpu9krea.c                |   14 +-
 arch/arm/mach-at91/board-cpuat91.c                 |    7 +-
 arch/arm/mach-at91/board-csb337.c                  |    7 +-
 arch/arm/mach-at91/board-csb637.c                  |    4 +-
 arch/arm/mach-at91/board-dt.c                      |    3 +-
 arch/arm/mach-at91/board-eb9200.c                  |   11 +-
 arch/arm/mach-at91/board-ecbat91.c                 |    7 +-
 arch/arm/mach-at91/board-eco920.c                  |    7 +-
 arch/arm/mach-at91/board-flexibity.c               |    5 +-
 arch/arm/mach-at91/board-foxg20.c                  |    9 +-
 arch/arm/mach-at91/board-gsia18s.c                 |    7 +-
 arch/arm/mach-at91/board-kafa.c                    |    4 +-
 arch/arm/mach-at91/board-kb9202.c                  |    8 +-
 arch/arm/mach-at91/board-neocore926.c              |    9 +-
 arch/arm/mach-at91/board-pcontrol-g20.c            |    8 +-
 arch/arm/mach-at91/board-picotux200.c              |    5 +-
 arch/arm/mach-at91/board-qil-a9260.c               |   18 +-
 arch/arm/mach-at91/board-rm9200dk.c                |   13 +-
 arch/arm/mach-at91/board-rm9200ek.c                |    5 +-
 arch/arm/mach-at91/board-rsi-ews.c                 |    4 +-
 arch/arm/mach-at91/board-sam9-l9260.c              |   12 +-
 arch/arm/mach-at91/board-sam9260ek.c               |   16 +-
 arch/arm/mach-at91/board-sam9261ek.c               |   13 +-
 arch/arm/mach-at91/board-sam9263ek.c               |   12 +-
 arch/arm/mach-at91/board-sam9g20ek.c               |   13 +-
 arch/arm/mach-at91/board-sam9m10g45ek.c            |    8 +-
 arch/arm/mach-at91/board-sam9rlek.c                |    9 +-
 arch/arm/mach-at91/board-snapper9260.c             |   10 +-
 arch/arm/mach-at91/board-stamp9g20.c               |   16 +-
 arch/arm/mach-at91/board-usb-a926x.c               |   14 +-
 arch/arm/mach-at91/board-yl-9200.c                 |    9 +-
 arch/arm/mach-at91/generic.h                       |    7 +-
 arch/arm/mach-at91/gpio.c                          |   85 ++-
 arch/arm/mach-at91/include/mach/at91_aic.h         |   48 +-
 arch/arm/mach-at91/include/mach/at91_dbgu.h        |    2 +-
 arch/arm/mach-at91/include/mach/at91_pit.h         |    8 +-
 arch/arm/mach-at91/include/mach/at91_rtc.h         |   24 +-
 arch/arm/mach-at91/include/mach/at91_shdwc.h       |   16 +-
 arch/arm/mach-at91/include/mach/at91cap9.h         |   27 +-
 arch/arm/mach-at91/include/mach/at91rm9200.h       |   14 +-
 arch/arm/mach-at91/include/mach/at91sam9260.h      |   23 +-
 arch/arm/mach-at91/include/mach/at91sam9261.h      |   20 +-
 arch/arm/mach-at91/include/mach/at91sam9263.h      |   33 +-
 arch/arm/mach-at91/include/mach/at91sam9_smc.h     |   17 +-
 arch/arm/mach-at91/include/mach/at91sam9g45.h      |   30 +-
 arch/arm/mach-at91/include/mach/at91sam9rl.h       |   29 +-
 arch/arm/mach-at91/include/mach/at91x40.h          |    1 -
 arch/arm/mach-at91/include/mach/board.h            |   42 +-
 arch/arm/mach-at91/include/mach/debug-macro.S      |   10 +-
 arch/arm/mach-at91/include/mach/entry-macro.S      |   11 +-
 arch/arm/mach-at91/include/mach/gpio.h             |  336 ++++----
 arch/arm/mach-at91/include/mach/hardware.h         |   12 +
 arch/arm/mach-at91/include/mach/irqs.h             |    2 +-
 arch/arm/mach-at91/include/mach/timex.h            |   65 +--
 arch/arm/mach-at91/include/mach/uncompress.h       |    6 +-
 arch/arm/mach-at91/irq.c                           |   38 +-
 arch/arm/mach-at91/pm.c                            |   11 +-
 arch/arm/mach-at91/sam9_smc.c                      |   62 +-
 arch/arm/mach-at91/sam9_smc.h                      |    3 +-
 arch/arm/mach-at91/setup.c                         |   26 +-
 arch/arm/mach-at91/soc.h                           |    1 +
 arch/arm/mach-davinci/clock.c                      |   13 +-
 arch/arm/mach-davinci/clock.h                      |   10 +-
 arch/arm/mach-davinci/dm644x.c                     |    4 +-
 arch/arm/mach-davinci/include/mach/dm646x.h        |   53 +--
 arch/arm/mach-dove/addr-map.c                      |  121 +--
 arch/arm/mach-dove/common.c                        |   16 +-
 arch/arm/mach-dove/common.h                        |    1 -
 arch/arm/mach-dove/pcie.c                          |    4 +-
 arch/arm/mach-exynos/Kconfig                       |   36 +
 arch/arm/mach-exynos/Makefile                      |    8 +-
 arch/arm/mach-exynos/clock.c                       |  302 ++++---
 arch/arm/mach-exynos/common.c                      |   53 +-
 arch/arm/mach-exynos/dev-ohci.c                    |   52 ++
 arch/arm/mach-exynos/dma.c                         |  229 ++----
 arch/arm/mach-exynos/include/mach/irqs.h           |   11 +-
 arch/arm/mach-exynos/include/mach/map.h            |    8 +
 arch/arm/mach-exynos/include/mach/ohci.h           |   21 +
 arch/arm/mach-exynos/include/mach/spi-clocks.h     |   16 +
 arch/arm/mach-exynos/mach-exynos4-dt.c             |   85 ++
 arch/arm/mach-exynos/mach-nuri.c                   |    9 +-
 arch/arm/mach-exynos/mach-origen.c                 |   13 +
 arch/arm/mach-exynos/mach-smdkv310.c               |   17 +-
 arch/arm/mach-exynos/mach-universal_c210.c         |   10 +-
 arch/arm/mach-exynos/pm.c                          |   24 +-
 arch/arm/mach-exynos/setup-sdhci.c                 |   22 -
 arch/arm/mach-exynos/setup-spi.c                   |   72 ++
 arch/arm/mach-exynos/setup-usb-phy.c               |   15 +
 arch/arm/mach-imx/Kconfig                          |    2 +
 arch/arm/mach-imx/Makefile                         |    6 +-
 arch/arm/mach-imx/Makefile.boot                    |    3 +
 arch/arm/mach-imx/head-v7.S                        |   17 +-
 arch/arm/mach-imx/mach-apf9328.c                   |   10 +
 arch/arm/mach-imx/mach-imx6q.c                     |   24 +-
 arch/arm/mach-imx/mach-mx31_3ds.c                  |    2 +-
 arch/arm/mach-imx/pm-imx6q.c                       |    2 +
 arch/arm/mach-kirkwood/addr-map.c                  |  137 +---
 arch/arm/mach-kirkwood/common.c                    |   19 +-
 arch/arm/mach-kirkwood/common.h                    |    1 -
 arch/arm/mach-kirkwood/include/mach/kirkwood.h     |    1 +
 arch/arm/mach-kirkwood/mpp.c                       |    1 -
 arch/arm/mach-kirkwood/mpp.h                       |    1 +
 arch/arm/mach-kirkwood/pcie.c                      |    4 +-
 arch/arm/mach-mmp/aspenite.c                       |    5 +-
 arch/arm/mach-mmp/avengers_lite.c                  |    1 +
 arch/arm/mach-mmp/brownstone.c                     |    1 +
 arch/arm/mach-mmp/flint.c                          |    5 +-
 arch/arm/mach-mmp/gplugd.c                         |    1 +
 arch/arm/mach-mmp/include/mach/gpio-pxa.h          |    3 +-
 arch/arm/mach-mmp/include/mach/gpio.h              |    7 +-
 arch/arm/mach-mmp/include/mach/irqs.h              |    6 +-
 arch/arm/mach-mmp/include/mach/mmp2.h              |    2 +
 arch/arm/mach-mmp/include/mach/pxa168.h            |    2 +
 arch/arm/mach-mmp/include/mach/pxa910.h            |    2 +
 arch/arm/mach-mmp/mmp2.c                           |   39 +-
 arch/arm/mach-mmp/pxa168.c                         |   40 +-
 arch/arm/mach-mmp/pxa910.c                         |   40 +-
 arch/arm/mach-mmp/tavorevb.c                       |    6 +-
 arch/arm/mach-mmp/teton_bga.c                      |    3 +-
 arch/arm/mach-mmp/ttc_dkb.c                        |    8 +-
 arch/arm/mach-msm/Kconfig                          |   35 +-
 arch/arm/mach-msm/include/mach/debug-macro.S       |   51 +-
 arch/arm/mach-msm/include/mach/msm_iomap-7x00.h    |   12 -
 arch/arm/mach-msm/include/mach/msm_iomap-7x30.h    |   12 -
 arch/arm/mach-msm/include/mach/msm_iomap-8960.h    |    5 +
 arch/arm/mach-msm/include/mach/msm_iomap-8x50.h    |   12 -
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h    |    5 +
 arch/arm/mach-msm/include/mach/msm_iomap.h         |   12 +
 arch/arm/mach-msm/include/mach/uncompress.h        |   39 +-
 arch/arm/mach-msm/io.c                             |   15 +-
 arch/arm/mach-msm/platsmp.c                        |    2 +-
 arch/arm/mach-msm/timer.c                          |  347 +++-----
 arch/arm/mach-mv78xx0/addr-map.c                   |  102 +--
 arch/arm/mach-mv78xx0/common.c                     |   22 +-
 arch/arm/mach-mv78xx0/common.h                     |    1 -
 arch/arm/mach-mv78xx0/mpp.c                        |    1 -
 arch/arm/mach-mv78xx0/pcie.c                       |    4 +-
 arch/arm/mach-mx5/mm.c                             |   19 +-
 arch/arm/mach-mx5/system.c                         |    3 -
 arch/arm/mach-mxs/clock-mx23.c                     |   10 +-
 arch/arm/mach-mxs/clock-mx28.c                     |   48 +-
 arch/arm/mach-mxs/clock.c                          |   33 +-
 arch/arm/mach-mxs/devices-mx28.h                   |    3 +-
 arch/arm/mach-mxs/devices/platform-mxs-saif.c      |    5 +-
 arch/arm/mach-mxs/include/mach/common.h            |    1 +
 arch/arm/mach-mxs/include/mach/devices-common.h    |    4 +-
 arch/arm/mach-mxs/include/mach/digctl.h            |   21 +
 arch/arm/mach-mxs/mach-mx28evk.c                   |   20 +-
 arch/arm/mach-mxs/system.c                         |    2 +-
 arch/arm/mach-mxs/timer.c                          |    2 +-
 arch/arm/mach-omap1/Kconfig                        |   64 --
 arch/arm/mach-omap1/clock.c                        |   14 +-
 arch/arm/mach-omap1/clock.h                        |    3 +
 arch/arm/mach-omap1/clock_data.c                   |   19 +-
 arch/arm/mach-omap1/opp.h                          |    1 +
 arch/arm/mach-omap1/opp_data.c                     |   63 +-
 arch/arm/mach-omap2/Kconfig                        |   37 +-
 arch/arm/mach-omap2/Makefile                       |   20 +-
 arch/arm/mach-omap2/board-3430sdp.c                |  100 +---
 arch/arm/mach-omap2/board-4430sdp.c                |   75 +--
 arch/arm/mach-omap2/board-am3517evm.c              |   22 +
 arch/arm/mach-omap2/board-cm-t35.c                 |   82 ++-
 arch/arm/mach-omap2/board-generic.c                |    1 -
 arch/arm/mach-omap2/board-n8x0.c                   |    6 +-
 arch/arm/mach-omap2/board-omap4panda.c             |   68 +--
 arch/arm/mach-omap2/board-rx51-peripherals.c       |   46 +-
 arch/arm/mach-omap2/board-ti8168evm.c              |   43 +-
 arch/arm/mach-omap2/clock.c                        |    2 +-
 arch/arm/mach-omap2/clock.h                        |    2 +-
 arch/arm/mach-omap2/clock3xxx_data.c               |   43 +-
 arch/arm/mach-omap2/clock44xx_data.c               |   19 +-
 arch/arm/mach-omap2/common.c                       |   48 +-
 arch/arm/mach-omap2/common.h                       |   87 ++-
 arch/arm/mach-omap2/control.h                      |    8 +-
 arch/arm/mach-omap2/cpuidle34xx.c                  |   21 +-
 arch/arm/mach-omap2/cpuidle44xx.c                  |  245 ++++++
 arch/arm/mach-omap2/devices.c                      |   22 +
 arch/arm/mach-omap2/hsmmc.c                        |   59 +-
 arch/arm/mach-omap2/hsmmc.h                        |    1 +
 arch/arm/mach-omap2/id.c                           |   52 +-
 arch/arm/mach-omap2/include/mach/barriers.h        |   31 +
 arch/arm/mach-omap2/include/mach/debug-macro.S     |   12 +-
 arch/arm/mach-omap2/include/mach/omap-secure.h     |   57 ++
 arch/arm/mach-omap2/include/mach/omap-wakeupgen.h  |   39 +
 arch/arm/mach-omap2/io.c                           |   47 +-
 arch/arm/mach-omap2/irq.c                          |    2 +-
 arch/arm/mach-omap2/mux.c                          |   89 ++-
 arch/arm/mach-omap2/omap-headsmp.S                 |    5 -
 arch/arm/mach-omap2/omap-hotplug.c                 |   14 +-
 arch/arm/mach-omap2/omap-mpuss-lowpower.c          |  398 +++++++++
 arch/arm/mach-omap2/omap-secure.c                  |   81 ++
 arch/arm/mach-omap2/{omap44xx-smc.S => omap-smc.S} |   23 +
 arch/arm/mach-omap2/omap-smp.c                     |   45 +
 arch/arm/mach-omap2/omap-wakeupgen.c               |  389 +++++++++
 arch/arm/mach-omap2/omap4-common.c                 |   94 ++-
 arch/arm/mach-omap2/omap4-sar-layout.h             |   50 ++
 arch/arm/mach-omap2/omap_hwmod.c                   |  223 ++++--
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |  388 ++++++++-
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |  217 +++++-
 arch/arm/mach-omap2/omap_phy_internal.c            |   35 +
 arch/arm/mach-omap2/opp2xxx.h                      |    2 +-
 arch/arm/mach-omap2/pm.h                           |    1 +
 arch/arm/mach-omap2/pm24xx.c                       |   20 -
 arch/arm/mach-omap2/pm34xx.c                       |  158 +---
 arch/arm/mach-omap2/pm44xx.c                       |  153 ++++-
 arch/arm/mach-omap2/prcm-common.h                  |   77 ++-
 arch/arm/mach-omap2/prm2xxx_3xxx.c                 |   97 ++-
 arch/arm/mach-omap2/prm2xxx_3xxx.h                 |    9 +-
 arch/arm/mach-omap2/prm44xx.c                      |  116 +++
 arch/arm/mach-omap2/prm44xx.h                      |    8 +-
 arch/arm/mach-omap2/prm_common.c                   |  320 +++++++
 arch/arm/mach-omap2/sdram-nokia.c                  |   25 +-
 arch/arm/mach-omap2/serial.c                       |  907 ++++++--------------
 arch/arm/mach-omap2/sleep44xx.S                    |  379 ++++++++
 arch/arm/mach-omap2/usb-host.c                     |  100 +--
 arch/arm/mach-omap2/usb-musb.c                     |    3 +
 arch/arm/mach-omap2/voltagedomains3xxx_data.c      |   40 +-
 arch/arm/mach-orion5x/addr-map.c                   |  146 +---
 arch/arm/mach-orion5x/common.c                     |   23 +-
 arch/arm/mach-orion5x/common.h                     |    3 +-
 arch/arm/mach-orion5x/include/mach/orion5x.h       |    2 +-
 arch/arm/mach-orion5x/mpp.c                        |    1 -
 arch/arm/mach-orion5x/pci.c                        |    5 +-
 arch/arm/mach-picoxcell/Makefile                   |    1 -
 arch/arm/mach-picoxcell/common.c                   |   52 ++-
 arch/arm/mach-picoxcell/common.h                   |    1 -
 arch/arm/mach-picoxcell/include/mach/irqs.h        |    9 +-
 arch/arm/mach-picoxcell/include/mach/memory.h      |    1 -
 arch/arm/mach-picoxcell/io.c                       |   32 -
 arch/arm/mach-pxa/am200epd.c                       |    4 +-
 arch/arm/mach-pxa/am300epd.c                       |    4 +-
 arch/arm/mach-pxa/balloon3.c                       |    3 +-
 arch/arm/mach-pxa/capc7117.c                       |   12 +-
 arch/arm/mach-pxa/cm-x270.c                        |    4 +-
 arch/arm/mach-pxa/cm-x2xx.c                        |    4 +-
 arch/arm/mach-pxa/cm-x300.c                        |    6 +-
 arch/arm/mach-pxa/colibri-pxa270.c                 |    6 +-
 arch/arm/mach-pxa/colibri-pxa300.c                 |    4 +-
 arch/arm/mach-pxa/colibri-pxa320.c                 |    4 +-
 arch/arm/mach-pxa/corgi.c                          |    2 +-
 arch/arm/mach-pxa/corgi_pm.c                       |   21 +-
 arch/arm/mach-pxa/devices.c                        |   50 ++
 arch/arm/mach-pxa/devices.h                        |    1 +
 arch/arm/mach-pxa/em-x270.c                        |    6 +-
 arch/arm/mach-pxa/eseries.c                        |    4 +-
 arch/arm/mach-pxa/hx4700.c                         |   18 +-
 arch/arm/mach-pxa/icontrol.c                       |    8 +-
 arch/arm/mach-pxa/idp.c                            |    4 +-
 arch/arm/mach-pxa/include/mach/balloon3.h          |    6 +-
 arch/arm/mach-pxa/include/mach/corgi.h             |   26 +-
 arch/arm/mach-pxa/include/mach/csb726.h            |    4 +-
 arch/arm/mach-pxa/include/mach/gpio-pxa.h          |  133 ---
 arch/arm/mach-pxa/include/mach/gpio.h              |   20 +-
 arch/arm/mach-pxa/include/mach/gumstix.h           |   20 +-
 arch/arm/mach-pxa/include/mach/hx4700.h            |    2 +-
 arch/arm/mach-pxa/include/mach/idp.h               |   16 +-
 arch/arm/mach-pxa/include/mach/irqs.h              |    8 +-
 arch/arm/mach-pxa/include/mach/littleton.h         |    4 +-
 arch/arm/mach-pxa/include/mach/magician.h          |    2 +-
 arch/arm/mach-pxa/include/mach/palmld.h            |    8 +-
 arch/arm/mach-pxa/include/mach/palmt5.h            |    8 +-
 arch/arm/mach-pxa/include/mach/palmtc.h            |    4 +-
 arch/arm/mach-pxa/include/mach/palmtx.h            |    8 +-
 arch/arm/mach-pxa/include/mach/pcm027.h            |    8 +-
 arch/arm/mach-pxa/include/mach/pcm990_baseboard.h  |   14 +-
 arch/arm/mach-pxa/include/mach/poodle.h            |   26 +-
 arch/arm/mach-pxa/include/mach/spitz.h             |   40 +-
 arch/arm/mach-pxa/include/mach/tosa.h              |   52 +-
 arch/arm/mach-pxa/include/mach/trizeps4.h          |   16 +-
 arch/arm/mach-pxa/irq.c                            |   61 +--
 arch/arm/mach-pxa/littleton.c                      |    6 +-
 arch/arm/mach-pxa/lpd270.c                         |    4 +-
 arch/arm/mach-pxa/lubbock.c                        |    4 +-
 arch/arm/mach-pxa/magician.c                       |    8 +-
 arch/arm/mach-pxa/mainstone.c                      |    4 +-
 arch/arm/mach-pxa/mfp-pxa2xx.c                     |    6 +-
 arch/arm/mach-pxa/mioa701.c                        |   37 +-
 arch/arm/mach-pxa/mxm8x10.c                        |    4 +-
 arch/arm/mach-pxa/pcm990-baseboard.c               |    6 +-
 arch/arm/mach-pxa/poodle.c                         |    6 +-
 arch/arm/mach-pxa/pxa25x.c                         |    7 +-
 arch/arm/mach-pxa/pxa27x.c                         |    7 +-
 arch/arm/mach-pxa/pxa300.c                         |    1 +
 arch/arm/mach-pxa/pxa320.c                         |    1 +
 arch/arm/mach-pxa/pxa3xx.c                         |    9 +-
 arch/arm/mach-pxa/pxa95x.c                         |    6 +-
 arch/arm/mach-pxa/raumfeld.c                       |    8 +-
 arch/arm/mach-pxa/saar.c                           |    6 +-
 arch/arm/mach-pxa/saarb.c                          |    2 +-
 arch/arm/mach-pxa/sharpsl_pm.c                     |   24 +-
 arch/arm/mach-pxa/spitz.c                          |    2 +-
 arch/arm/mach-pxa/spitz_pm.c                       |   11 +-
 arch/arm/mach-pxa/stargate2.c                      |   26 +-
 arch/arm/mach-pxa/tavorevb.c                       |    4 +-
 arch/arm/mach-pxa/tavorevb3.c                      |    2 +-
 arch/arm/mach-pxa/tosa.c                           |    4 +-
 arch/arm/mach-pxa/viper.c                          |   12 +-
 arch/arm/mach-pxa/vpac270.c                        |   10 +-
 arch/arm/mach-pxa/z2.c                             |    2 +-
 arch/arm/mach-pxa/zeus.c                           |   20 +-
 arch/arm/mach-pxa/zylonite.c                       |    4 +-
 arch/arm/mach-pxa/zylonite_pxa300.c                |    4 +-
 arch/arm/mach-s3c2410/mach-bast.c                  |   22 -
 arch/arm/mach-s3c2410/mach-vr1000.c                |   24 -
 arch/arm/mach-s3c2410/s3c2410.c                    |    6 +
 arch/arm/mach-s3c2412/clock.c                      |    7 +
 arch/arm/mach-s3c2416/Makefile                     |    1 -
 arch/arm/mach-s3c2416/clock.c                      |   68 +-
 arch/arm/mach-s3c2416/setup-sdhci.c                |   24 -
 arch/arm/mach-s3c2440/clock.c                      |   44 +
 arch/arm/mach-s3c2440/mach-anubis.c                |   22 +-
 arch/arm/mach-s3c2440/mach-at2440evb.c             |   22 +-
 arch/arm/mach-s3c2440/mach-mini2440.c              |   18 +
 arch/arm/mach-s3c2440/mach-osiris.c                |   24 +-
 arch/arm/mach-s3c2440/mach-rx1950.c                |   18 +-
 arch/arm/mach-s3c2440/mach-rx3715.c                |   19 +-
 arch/arm/mach-s3c64xx/Kconfig                      |   14 +-
 arch/arm/mach-s3c64xx/Makefile                     |    2 +-
 arch/arm/mach-s3c64xx/clock.c                      |  243 ++++--
 arch/arm/mach-s3c64xx/dev-spi.c                    |  180 ----
 arch/arm/mach-s3c64xx/include/mach/crag6410.h      |    6 +-
 arch/arm/mach-s3c64xx/include/mach/gpio.h          |    2 +-
 arch/arm/mach-s3c64xx/include/mach/irqs.h          |    2 +-
 arch/arm/mach-s3c64xx/include/mach/map.h           |    2 +
 arch/arm/mach-s3c64xx/mach-crag6410-module.c       |   56 ++-
 arch/arm/mach-s3c64xx/mach-crag6410.c              |   39 +-
 arch/arm/mach-s3c64xx/pm.c                         |   15 +
 arch/arm/mach-s3c64xx/setup-sdhci.c                |   24 -
 arch/arm/mach-s3c64xx/setup-spi.c                  |   45 +
 arch/arm/mach-s5p64x0/Kconfig                      |   31 +-
 arch/arm/mach-s5p64x0/Makefile                     |    3 +-
 arch/arm/mach-s5p64x0/clock-s5p6440.c              |  165 ++--
 arch/arm/mach-s5p64x0/clock-s5p6450.c              |  153 ++--
 arch/arm/mach-s5p64x0/common.c                     |   40 +-
 arch/arm/mach-s5p64x0/dev-spi.c                    |  224 -----
 arch/arm/mach-s5p64x0/dma.c                        |  227 ++----
 arch/arm/mach-s5p64x0/include/mach/irqs.h          |    2 +
 arch/arm/mach-s5p64x0/include/mach/map.h           |    2 +
 arch/arm/mach-s5p64x0/mach-smdk6440.c              |   25 +
 arch/arm/mach-s5p64x0/mach-smdk6450.c              |   26 +-
 arch/arm/mach-s5p64x0/setup-sdhci-gpio.c           |  104 +++
 arch/arm/mach-s5p64x0/setup-spi.c                  |   55 ++
 arch/arm/mach-s5pc100/Kconfig                      |    5 +
 arch/arm/mach-s5pc100/Makefile                     |    3 +-
 arch/arm/mach-s5pc100/clock.c                      |  287 ++++---
 arch/arm/mach-s5pc100/dev-spi.c                    |  227 -----
 arch/arm/mach-s5pc100/dma.c                        |  247 ++----
 arch/arm/mach-s5pc100/include/mach/irqs.h          |    2 +
 arch/arm/mach-s5pc100/include/mach/map.h           |    3 +
 arch/arm/mach-s5pc100/setup-sdhci.c                |   23 -
 arch/arm/mach-s5pc100/setup-spi.c                  |   65 ++
 arch/arm/mach-s5pv210/Kconfig                      |    5 +
 arch/arm/mach-s5pv210/Makefile                     |    3 +-
 arch/arm/mach-s5pv210/clock.c                      |  324 +++++---
 arch/arm/mach-s5pv210/common.c                     |   19 -
 arch/arm/mach-s5pv210/dev-spi.c                    |  175 ----
 arch/arm/mach-s5pv210/dma.c                        |  241 ++----
 arch/arm/mach-s5pv210/include/mach/irqs.h          |    2 +
 arch/arm/mach-s5pv210/include/mach/map.h           |    2 +
 arch/arm/mach-s5pv210/mach-aquila.c                |    3 +-
 arch/arm/mach-s5pv210/mach-goni.c                  |    6 +-
 arch/arm/mach-s5pv210/mach-smdkv210.c              |   10 +-
 arch/arm/mach-s5pv210/setup-sdhci.c                |   22 -
 arch/arm/mach-s5pv210/setup-spi.c                  |   51 ++
 arch/arm/mach-sa1100/clock.c                       |   91 ++-
 arch/arm/mach-sa1100/generic.c                     |   20 +
 arch/arm/mach-tegra/Kconfig                        |   31 +-
 arch/arm/mach-tegra/Makefile                       |   36 +-
 arch/arm/mach-tegra/Makefile.boot                  |    3 +
 .../mach-tegra/{board-dt.c => board-dt-tegra20.c}  |   62 +-
 arch/arm/mach-tegra/board-dt-tegra30.c             |   63 ++
 arch/arm/mach-tegra/board-harmony-pcie.c           |    9 -
 arch/arm/mach-tegra/board-harmony-pinmux.c         |   23 +-
 arch/arm/mach-tegra/board-harmony.c                |    2 +-
 arch/arm/mach-tegra/board-paz00-pinmux.c           |   25 +-
 arch/arm/mach-tegra/board-paz00.c                  |   29 +-
 arch/arm/mach-tegra/board-paz00.h                  |    3 +
 arch/arm/mach-tegra/board-pinmux.c                 |  104 +++
 arch/arm/mach-tegra/board-pinmux.h                 |   38 +
 arch/arm/mach-tegra/board-seaboard-pinmux.c        |  122 ++--
 arch/arm/mach-tegra/board-seaboard.c               |    6 +-
 arch/arm/mach-tegra/board-trimslice-pinmux.c       |   27 +-
 arch/arm/mach-tegra/board-trimslice.c              |    2 +-
 arch/arm/mach-tegra/board.h                        |    5 +-
 arch/arm/mach-tegra/clock.c                        |   25 +-
 arch/arm/mach-tegra/clock.h                        |    4 -
 arch/arm/mach-tegra/common.c                       |   55 +-
 arch/arm/mach-tegra/include/mach/clk.h             |    2 +-
 arch/arm/mach-tegra/include/mach/entry-macro.S     |   18 -
 arch/arm/mach-tegra/include/mach/irqs.h            |    2 -
 .../include/mach/{pinmux-t2.h => pinmux-tegra20.h} |    6 +-
 arch/arm/mach-tegra/include/mach/pinmux-tegra30.h  |  320 +++++++
 arch/arm/mach-tegra/include/mach/pinmux.h          |   88 ++-
 arch/arm/mach-tegra/irq.c                          |   14 +-
 arch/arm/mach-tegra/pcie.c                         |    1 -
 ...{pinmux-t2-tables.c => pinmux-tegra20-tables.c} |   24 +-
 arch/arm/mach-tegra/pinmux-tegra30-tables.c        |  376 ++++++++
 arch/arm/mach-tegra/pinmux.c                       |  153 +++-
 arch/arm/mach-tegra/tegra2_clocks.c                |   19 +-
 arch/arm/mach-tegra/timer.c                        |   18 +-
 arch/arm/mach-u300/include/mach/memory.h           |   19 -
 arch/arm/mach-u300/u300.c                          |    2 +-
 arch/arm/mach-ux500/board-mop500-sdi.c             |   88 ++-
 arch/arm/mach-ux500/board-mop500.c                 |    2 +-
 arch/arm/mach-ux500/board-mop500.h                 |   63 ++-
 arch/arm/mach-ux500/clock.c                        |  207 ++----
 arch/arm/mach-ux500/cpu-db5500.c                   |   41 +-
 arch/arm/mach-ux500/cpu-db8500.c                   |   30 +-
 arch/arm/mach-ux500/devices-db8500.c               |   10 -
 arch/arm/mach-ux500/id.c                           |    6 +-
 arch/arm/mach-ux500/include/mach/db5500-regs.h     |    4 +
 arch/arm/mach-ux500/include/mach/db8500-regs.h     |   20 +-
 arch/arm/mach-ux500/include/mach/devices.h         |    2 -
 arch/arm/mach-ux500/include/mach/hardware.h        |   10 +-
 arch/arm/mach-ux500/include/mach/id.h              |   24 +
 arch/arm/plat-mxc/include/mach/common.h            |    8 +-
 arch/arm/plat-mxc/include/mach/iomux-mx25.h        |    4 +
 arch/arm/plat-mxc/include/mach/mxc.h               |    2 +-
 arch/arm/plat-mxc/tzic.c                           |   40 +-
 arch/arm/plat-omap/Makefile                        |    1 -
 arch/arm/plat-omap/common.c                        |    3 +
 arch/arm/plat-omap/dma.c                           |   22 +-
 arch/arm/plat-omap/include/plat/am33xx.h           |   25 +
 arch/arm/plat-omap/include/plat/clkdev_omap.h      |    1 +
 arch/arm/plat-omap/include/plat/clock.h            |    4 +-
 arch/arm/plat-omap/include/plat/cpu.h              |   56 ++
 arch/arm/plat-omap/include/plat/hardware.h         |    3 +-
 arch/arm/plat-omap/include/plat/io.h               |   12 +
 arch/arm/plat-omap/include/plat/irqs.h             |    2 +-
 arch/arm/plat-omap/include/plat/mmc.h              |    1 +
 arch/arm/plat-omap/include/plat/omap-secure.h      |   13 +
 arch/arm/plat-omap/include/plat/omap-serial.h      |   37 +-
 arch/arm/plat-omap/include/plat/omap34xx.h         |    2 +
 arch/arm/plat-omap/include/plat/omap44xx.h         |    1 +
 arch/arm/plat-omap/include/plat/omap_hwmod.h       |    6 +
 arch/arm/plat-omap/include/plat/serial.h           |   25 +-
 arch/arm/plat-omap/include/plat/sram.h             |    6 +-
 .../plat-omap/include/plat/{ti816x.h => ti81xx.h}  |   18 +-
 arch/arm/plat-omap/include/plat/uncompress.h       |   11 +-
 arch/arm/plat-omap/include/plat/usb.h              |   35 +-
 arch/arm/plat-omap/sram.c                          |   17 +-
 arch/arm/plat-orion/Makefile                       |    2 +-
 arch/arm/plat-orion/addr-map.c                     |  174 ++++
 arch/arm/plat-orion/common.c                       |   43 +-
 arch/arm/plat-orion/include/plat/addr-map.h        |   53 ++
 arch/arm/plat-orion/include/plat/audio.h           |    3 -
 arch/arm/plat-orion/include/plat/common.h          |   17 +-
 arch/arm/plat-orion/include/plat/ehci-orion.h      |    1 -
 arch/arm/plat-orion/include/plat/mv_xor.h          |    6 -
 arch/arm/plat-orion/include/plat/mvsdio.h          |    1 -
 arch/arm/plat-orion/include/plat/pcie.h            |    3 +-
 arch/arm/plat-orion/pcie.c                         |    6 +-
 arch/arm/plat-pxa/include/plat/gpio-pxa.h          |   44 -
 arch/arm/plat-pxa/include/plat/gpio.h              |   30 -
 arch/arm/plat-s3c24xx/dma.c                        |    3 +-
 arch/arm/plat-s3c24xx/s3c2443-clock.c              |   39 +-
 arch/arm/plat-samsung/Kconfig                      |   24 +-
 arch/arm/plat-samsung/devs.c                       |  127 +++
 arch/arm/plat-samsung/dma-ops.c                    |   15 +-
 arch/arm/plat-samsung/include/plat/devs.h          |    9 +-
 arch/arm/plat-samsung/include/plat/dma-ops.h       |    1 +
 arch/arm/plat-samsung/include/plat/dma-pl330.h     |    3 +-
 arch/arm/plat-samsung/include/plat/irqs.h          |    3 +-
 arch/arm/plat-samsung/include/plat/regs-serial.h   |   45 +-
 arch/arm/plat-samsung/include/plat/s3c64xx-spi.h   |   24 +-
 arch/arm/plat-samsung/include/plat/sdhci.h         |   75 +-
 arch/avr32/boards/atngw100/setup.c                 |    2 +-
 arch/avr32/boards/atstk1000/atstk1002.c            |    2 +-
 arch/avr32/boards/favr-32/setup.c                  |    2 +-
 arch/avr32/boards/hammerhead/setup.c               |    2 +-
 arch/avr32/boards/merisc/setup.c                   |    2 +-
 arch/avr32/boards/mimc200/setup.c                  |    2 +-
 arch/avr32/mach-at32ap/at32ap700x.c                |    8 +-
 arch/avr32/mach-at32ap/include/mach/board.h        |    7 +-
 drivers/ata/pata_at91.c                            |    6 +-
 drivers/ata/sata_mv.c                              |   19 +-
 drivers/clk/Kconfig                                |    3 +
 drivers/dma/mv_xor.c                               |   11 +-
 drivers/dma/mxs-dma.c                              |    8 +-
 drivers/dma/pl330.c                                |   99 ++-
 drivers/gpio/Kconfig                               |    6 +
 drivers/gpio/Makefile                              |    2 +-
 drivers/gpio/gpio-pxa.c                            |  377 +++++++--
 drivers/gpio/gpio-samsung.c                        |   72 ++
 drivers/i2c/busses/i2c-tegra.c                     |   10 +-
 drivers/ide/at91_ide.c                             |    2 +-
 drivers/input/keyboard/samsung-keypad.c            |  174 ++++-
 drivers/input/touchscreen/zylonite-wm97xx.c        |    5 +-
 drivers/media/video/davinci/vpif.h                 |    1 +
 drivers/media/video/davinci/vpif_capture.h         |    2 +-
 drivers/media/video/davinci/vpif_display.h         |    1 +
 drivers/mfd/db8500-prcmu.c                         |    7 +-
 drivers/mfd/omap-usb-host.c                        |  755 +++++++----------
 drivers/mmc/host/at91_mci.c                        |   30 +-
 drivers/mmc/host/mvsdio.c                          |   13 +-
 drivers/mmc/host/mxs-mmc.c                         |   10 +-
 drivers/mmc/host/omap_hsmmc.c                      |   26 +-
 drivers/mmc/host/sdhci-s3c.c                       |    7 +-
 drivers/mtd/nand/atmel_nand.c                      |    8 +-
 drivers/mtd/nand/gpmi-nand/gpmi-lib.c              |   12 +-
 drivers/net/can/flexcan.c                          |   10 +-
 drivers/net/ethernet/Makefile                      |    2 +-
 drivers/net/ethernet/cadence/Kconfig               |   16 +-
 drivers/net/ethernet/cadence/at91_ether.c          |   26 +-
 drivers/net/ethernet/cadence/at91_ether.h          |    4 +-
 drivers/net/ethernet/cadence/macb.c                |  416 ++++++---
 drivers/net/ethernet/cadence/macb.h                |  152 ++++-
 drivers/net/ethernet/freescale/fec.c               |   10 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c         |   10 +-
 drivers/pcmcia/pxa2xx_cm_x255.c                    |   16 +-
 drivers/pcmcia/pxa2xx_cm_x270.c                    |    9 +-
 drivers/pcmcia/pxa2xx_e740.c                       |   11 +-
 drivers/pcmcia/pxa2xx_palmld.c                     |    2 +-
 drivers/pcmcia/pxa2xx_palmtc.c                     |    2 +-
 drivers/pcmcia/pxa2xx_stargate2.c                  |    6 +-
 drivers/pcmcia/pxa2xx_trizeps4.c                   |    5 +-
 drivers/pcmcia/pxa2xx_vpac270.c                    |    4 +-
 drivers/rtc/Kconfig                                |    2 +-
 drivers/rtc/rtc-at91rm9200.c                       |  101 ++-
 drivers/rtc/rtc-s3c.c                              |   21 +-
 drivers/rtc/rtc-sa1100.c                           |  300 ++++---
 drivers/spi/spi-s3c64xx.c                          |   14 +-
 drivers/tty/serial/Kconfig                         |   45 +-
 drivers/tty/serial/Makefile                        |    5 -
 drivers/tty/serial/mxs-auart.c                     |    8 +-
 drivers/tty/serial/omap-serial.c                   |  428 ++++++++--
 drivers/tty/serial/s3c2410.c                       |  115 ---
 drivers/tty/serial/s3c2412.c                       |  149 ----
 drivers/tty/serial/s3c2440.c                       |  178 ----
 drivers/tty/serial/s3c6400.c                       |  149 ----
 drivers/tty/serial/s5pv210.c                       |  158 ----
 drivers/tty/serial/samsung.c                       |  639 ++++++++------
 drivers/tty/serial/samsung.h                       |   32 +-
 drivers/usb/Kconfig                                |    1 +
 drivers/usb/gadget/at91_udc.c                      |   14 +-
 drivers/usb/host/Kconfig                           |    6 +
 drivers/usb/host/ehci-omap.c                       |   17 +-
 drivers/usb/host/ehci-orion.c                      |   10 +-
 drivers/usb/host/ehci-tegra.c                      |   71 ++
 drivers/usb/host/ohci-at91.c                       |   12 +-
 drivers/usb/host/ohci-exynos.c                     |  274 ++++++
 drivers/usb/host/ohci-hcd.c                        |    5 +
 drivers/usb/host/ohci-omap3.c                      |   18 +-
 drivers/video/mxsfb.c                              |    8 +-
 drivers/watchdog/at91sam9_wdt.c                    |   22 +-
 drivers/watchdog/at91sam9_wdt.h                    |    6 +-
 include/linux/amba/pl330.h                         |   15 +-
 include/linux/ata_platform.h                       |    3 -
 include/linux/clk.h                                |   22 +
 include/linux/gpio-pxa.h                           |   16 +
 include/linux/mbus.h                               |   13 +-
 include/linux/platform_data/macb.h                 |   17 +
 include/media/davinci/vpif_types.h                 |   71 ++
 include/sound/saif.h                               |    4 +-
 sound/soc/kirkwood/kirkwood-dma.c                  |   15 +-
 sound/soc/mxs/mxs-saif.c                           |   24 +-
 626 files changed, 16575 insertions(+), 9821 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/insignal-boards.txt
 create mode 100644 Documentation/devicetree/bindings/arm/samsung-boards.txt
 create mode 100644 Documentation/devicetree/bindings/arm/tegra.txt
 create mode 100644 Documentation/devicetree/bindings/dma/arm-pl330.txt
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-samsung.txt
 create mode 100644 Documentation/devicetree/bindings/input/samsung-keypad.txt
 create mode 100644 Documentation/devicetree/bindings/net/macb.txt
 create mode 100644 Documentation/devicetree/bindings/rtc/s3c-rtc.txt
 create mode 100644 Documentation/devicetree/bindings/serial/omap_serial.txt
 create mode 100644 Documentation/devicetree/bindings/serial/samsung_uart.txt
 create mode 100644 Documentation/devicetree/bindings/usb/tegra-usb.txt
 create mode 100644 arch/arm/boot/dts/exynos4210-origen.dts
 create mode 100644 arch/arm/boot/dts/exynos4210-smdkv310.dts
 create mode 100644 arch/arm/boot/dts/exynos4210.dtsi
 rename arch/arm/boot/dts/{imx6q-sabreauto.dts => imx6q-arm2.dts} (78%)
 create mode 100644 arch/arm/boot/dts/imx6q-sabrelite.dts
 create mode 100644 arch/arm/boot/dts/omap2.dtsi
 create mode 100644 arch/arm/boot/dts/tegra-cardhu.dts
 create mode 100644 arch/arm/boot/dts/tegra-paz00.dts
 create mode 100644 arch/arm/boot/dts/tegra-trimslice.dts
 create mode 100644 arch/arm/boot/dts/tegra30.dtsi
 delete mode 100644 arch/arm/configs/pcontrol_g20_defconfig
 create mode 100644 arch/arm/mach-exynos/dev-ohci.c
 create mode 100644 arch/arm/mach-exynos/include/mach/ohci.h
 create mode 100644 arch/arm/mach-exynos/include/mach/spi-clocks.h
 create mode 100644 arch/arm/mach-exynos/mach-exynos4-dt.c
 delete mode 100644 arch/arm/mach-exynos/setup-sdhci.c
 create mode 100644 arch/arm/mach-exynos/setup-spi.c
 create mode 100644 arch/arm/mach-mxs/include/mach/digctl.h
 create mode 100644 arch/arm/mach-omap2/cpuidle44xx.c
 create mode 100644 arch/arm/mach-omap2/include/mach/barriers.h
 create mode 100644 arch/arm/mach-omap2/include/mach/omap-secure.h
 create mode 100644 arch/arm/mach-omap2/include/mach/omap-wakeupgen.h
 create mode 100644 arch/arm/mach-omap2/omap-mpuss-lowpower.c
 create mode 100644 arch/arm/mach-omap2/omap-secure.c
 rename arch/arm/mach-omap2/{omap44xx-smc.S => omap-smc.S} (70%)
 create mode 100644 arch/arm/mach-omap2/omap-wakeupgen.c
 create mode 100644 arch/arm/mach-omap2/omap4-sar-layout.h
 create mode 100644 arch/arm/mach-omap2/prm_common.c
 create mode 100644 arch/arm/mach-omap2/sleep44xx.S
 delete mode 100644 arch/arm/mach-picoxcell/include/mach/memory.h
 delete mode 100644 arch/arm/mach-picoxcell/io.c
 delete mode 100644 arch/arm/mach-pxa/include/mach/gpio-pxa.h
 delete mode 100644 arch/arm/mach-s3c2416/setup-sdhci.c
 delete mode 100644 arch/arm/mach-s3c64xx/dev-spi.c
 delete mode 100644 arch/arm/mach-s3c64xx/setup-sdhci.c
 create mode 100644 arch/arm/mach-s3c64xx/setup-spi.c
 delete mode 100644 arch/arm/mach-s5p64x0/dev-spi.c
 create mode 100644 arch/arm/mach-s5p64x0/setup-sdhci-gpio.c
 create mode 100644 arch/arm/mach-s5p64x0/setup-spi.c
 delete mode 100644 arch/arm/mach-s5pc100/dev-spi.c
 delete mode 100644 arch/arm/mach-s5pc100/setup-sdhci.c
 create mode 100644 arch/arm/mach-s5pc100/setup-spi.c
 delete mode 100644 arch/arm/mach-s5pv210/dev-spi.c
 delete mode 100644 arch/arm/mach-s5pv210/setup-sdhci.c
 create mode 100644 arch/arm/mach-s5pv210/setup-spi.c
 rename arch/arm/mach-tegra/{board-dt.c => board-dt-tegra20.c} (69%)
 create mode 100644 arch/arm/mach-tegra/board-dt-tegra30.c
 create mode 100644 arch/arm/mach-tegra/board-pinmux.c
 create mode 100644 arch/arm/mach-tegra/board-pinmux.h
 rename arch/arm/mach-tegra/include/mach/{pinmux-t2.h => pinmux-tegra20.h} (96%)
 create mode 100644 arch/arm/mach-tegra/include/mach/pinmux-tegra30.h
 rename arch/arm/mach-tegra/{pinmux-t2-tables.c => pinmux-tegra20-tables.c} (95%)
 create mode 100644 arch/arm/mach-tegra/pinmux-tegra30-tables.c
 delete mode 100644 arch/arm/mach-u300/include/mach/memory.h
 create mode 100644 arch/arm/plat-omap/include/plat/am33xx.h
 create mode 100644 arch/arm/plat-omap/include/plat/omap-secure.h
 rename arch/arm/plat-omap/include/plat/{ti816x.h => ti81xx.h} (60%)
 create mode 100644 arch/arm/plat-orion/addr-map.c
 create mode 100644 arch/arm/plat-orion/include/plat/addr-map.h
 delete mode 100644 arch/arm/plat-pxa/include/plat/gpio-pxa.h
 delete mode 100644 arch/arm/plat-pxa/include/plat/gpio.h
 delete mode 100644 drivers/tty/serial/s3c2410.c
 delete mode 100644 drivers/tty/serial/s3c2412.c
 delete mode 100644 drivers/tty/serial/s3c2440.c
 delete mode 100644 drivers/tty/serial/s3c6400.c
 delete mode 100644 drivers/tty/serial/s5pv210.c
 create mode 100644 drivers/usb/host/ohci-exynos.c
 create mode 100644 include/linux/gpio-pxa.h
 create mode 100644 include/linux/platform_data/macb.h
 create mode 100644 include/media/davinci/vpif_types.h
