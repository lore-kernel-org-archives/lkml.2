Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932594Ab1KBCXF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 22:23:05 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57487 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261Ab1KBCW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 22:22:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL 2/13] arm-soc cleanups
Date: Tue, 1 Nov 2011 04:13:03 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <201111010348.13214.arnd@arndb.de>
In-Reply-To: <201111010348.13214.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201111010413.03324.arnd@arndb.de>
X-Provags-ID: V02:K0:WdpTT3ps+NIeStaDo7JQvnmle1wvW1tDdZBpJrqK6aZ
 MwFegio636x4Ds3HclTOMjo/k05ZJAmiRZYJ11Ja26Qxoq5sVN
 5OoB/WaWfRxHOxWVM4AxXYJcux77fUHc1nNY7GODFC9xCOxI+n
 eyCm5P4+6q+tO9I8kyerhoty4YS1gmUAKxdGt7RA1quj5jlIQy
 vqO3h25uwlMxmQ/avsxWvM8OpBE53H4iyfWNivAsaxE+bAG237
 apasOvr4US3QTueuCgPMBeR2SihwJZxcecPP1X+WX5rleH333M
 SmqrjsS1S3uFn4X0GJfHtqYONm7MX4a7HDDpqLV2e/VWsSg2tD
 PMa8/wxH0Z+BoGWrSKXg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Basic cleanups for a number of platforms: omap, samsung, imx, tegra, ux500.
Most of these result in noticeable code size reduction by consolidating
duplicate code. Other bits are more about making the code more readable
and avoiding sparse warnings.

More cleanup in coming in series 10/13, which contains large-scale
reorganization that depends on patches in the other series.

	Arnd

The following changes since commit fad5f0579c1446d20ab30d54f578fcac3b5d3c12:

  Merge branch 'next/fixes' into for-next (2011-11-01 00:36:27 +0100)

are available in the git repository at:

  git://git.linaro.org/people/arnd/arm-soc.git next/cleanup

Abhilash Kesavan (1):
      ARM: S5PV210: Remove unnecessary symbol for PM

Arnd Bergmann (16):
      Merge branches 'imx/cleanup' and 'stericsson/cleanup' of git+ssh://master.kernel.org/.../arm/linux-arm-soc into next/cleanup
      Merge branch 'omap/cleanup' into next/cleanup
      Merge branch 'samsung/cleanup' into next/cleanup
      Merge branch 'stericsson/cleanup' into next/cleanup
      Merge branch 'davinci/cleanup' into next/cleanup
      Merge branch 'omap/cleanup' into next/cleanup
      Merge branch 'imx/cleanup' into next/cleanup
      Merge branch 'sirf/cleanup' into next/cleanup
      Merge branch 'depends/rmk/devel-stable' into next/cleanup
      Merge branch 'stericsson/fixes' into next/cleanup
      Merge branch 'tegra/cleanup' into next/cleanup
      Merge branch 'imx-cleanups-for-arnd' of git://git.pengutronix.de/git/imx/linux-2.6 into imx/cleanup
      Merge branch 'imx/cleanup' into next/cleanup
      Merge branch 'depends/rmk/memory_h' into next/fixes
      Merge branch 'depends/omap2_dss' into next/cleanup
      Merge branch 'next/fixes' into next/cleanup

Banajit Goswami (1):
      ARM: SAMSUNG: Consolidate common function to set SDHCI plat data

Barry Song (5):
      ARM: mach-ux500: add explicit cpu_relax() for busy wait loop
      ARM: CSR: timer: do not initialise statics to 0 or NULL
      ARM: CSR: timer: space required before the open parenthesis '('
      ARM: CSR: prima2: fix trailing whitespace
      ARM: CSR: clock: Fix indentation

Benoit Cousson (1):
      ARM: OMAP2+: Add SoC specific map_io functions

Fabio Estevam (4):
      ARM: mx50: Select IMX_HAVE_PLATFORM_FEC as done on other i.MX devices
      ARM: mxs: Remove unused header file
      ARM: mach-mxs/mx28evk: Only register devices if their GPIO requests succeeded
      ARM: mxs: Consolidate mm-mx23.c and mm-mx28.c into a single file

Fredrik Svensson (1):
      mach-ux500: remove pull-pinconfig and add SPI2

Grazvydas Ignotas (1):
      OMAP: omap_device: make latency autoadjust messages debug

Heiko Stuebner (2):
      ARM: S3C24XX: Remove hw_addr from s3c24xx dma channel declarations
      ARM: S3C24XX: Remove s3c24xx_dma_addr definition

Ido Yariv (1):
      ARM: davinci: Explicitly set channel controllers' default queues

Jarkko Nikula (14):
      omap: mcbsp: Remove omap device API
      ARM: OMAP: mcbsp: Remove unused variables from platform data
      ARM: OMAP: mcbsp: Move out omap_mcbsp_register_board_cfg from plat-omap/devices.c
      ARM: OMAP: mcbsp: Implement generic register access
      ARM: OMAP: mcbsp: Make wakeup control generic
      ARM: OMAP: mcbsp: Make tranceiver configuration control register access generic
      ARM: OMAP: mcbsp: Make threshold based transfer code generic
      ARM: OMAP: mcbsp: Use per instance register cache size
      ARM: OMAP: mcbsp: Move sidetone clock management to mach-omap2/mcbsp.c
      ARM: OMAP: mcbsp: Cleanup sidetone control initialization and make it generic
      ARM: OMAP: mcbsp: Update mcbsp.h include dependencies
      ARM: OMAP: mcbsp: Move address definitions to arch/arm/mach-omap1/mcbsp.c
      ARM: OMAP: mcbsp: Start generalize omap2_mcbsp_set_clks_src
      ARM: OMAP: mcbsp: Start generalize signal muxing functions

Jason Liu (4):
      imx5: not include the unused head file
      ARM: mx5/mm: move i.MX50 mm stuff into mm.c
      ARM: mx5/mm: Remove MX51_DEBUG related mapping
      ARM: mx5/mm: consolidate TZIC map code

Johan Hovold (2):
      OMAP2+: PM: fix typos in misc. comment and error messages
      OMAP2+: PM: clean up error messages: replace printk with pr_err.

Jonghwan Choi (1):
      ARM: S5P: Remove duplicate kdiv calculation

Kevin Hilman (8):
      OMAP: omap_device: replace debug/warning/error prints with dev_* macros
      OMAP: omap_device: remove internal functions from omap_device.h
      OMAP: omap_device: when building return platform_device instead of omap_device
      OMAP: omap_device: device register functions now take platform_device pointer
      OMAP: omap_device: _disable_idle_on_suspend() takes platform_device pointer
      OMAP: omap_device: decouple platform_device from omap_device
      OMAP3: PM: fix UART handling when using no_console_suspend
      ARM: 7082/1: platform_device: pdev_archdata: add omap_device pointer

Kukjin Kim (6):
      ARM: EXYNOS4: Turn the mach-smdkc210.c into mach-smdv310.c
      Merge branch 'next/topic-cleanup-dma' into next-samsung-cleanup
      ARM: S3C24XX: remove unused gpio codes
      Merge branch 'next/topic-cleanup-smdkv310' into next-samsung-cleanup
      ARM: SAMSUNG: Move map header file into plat-samsung
      Merge branch 'next/topic-plat-samsung-1' into next-samsung-cleanup

Lauri Hintsala (1):
      ARM: mach-mxs: fix machines' initializers order

Lee Jones (1):
      mach-ux500: remove most of the ugly machine_is_*() calls

Linus Walleij (6):
      mach-u300: retire odd singlemem variant
      mach-u300: drop SEMI config option
      mach-u300: patch physoffset by default
      mach-u300: delete bogus memory mappings
      mach-u300: retire AVE device
      mach-ux500: factor out l2x0 handling code

Mark Brown (1):
      ARM: S3C64XX: Remove unused CPU devices for Cragganmore

Michael Jones (1):
      OMAP2: PM debug: remove leftover debug code

Naveen Krishna Chatradhi (1):
      ARM: SAMSUNG: Remove unnecessary duplication of plat_data on TSADC

Olof Johansson (15):
      ARM: tegra: annotate IO_*_VIRT pointers
      ARM: tegra: timer: don't cast __iomem pointers
      ARM: tegra: tegra2_clocks: don't cast __iomem pointers
      ARM: tegra: tegra2_clocks: 0 -> NULL changes
      ARM: tegra: pcie: don't cast __iomem pointers
      ARM: tegra: pcie: include board.h
      ARM: tegra: pcie: 0 -> NULL changes
      ARM: tegra: tegra_init_cache should be static
      ARM: tegra: tegra_rtc_read_ms should be static
      ARM: tegra: tegra_powergate_is_powered should be static
      ARM: tegra: tegra2_clocks: don't export some tables
      ARM: tegra: dma: staticify some tables and functions
      ARM: tegra: cpu-tegra: sparse type fix
      ARM: tegra: cpu-tegra: unexport two functions
      ARM: tegra: devices.c should include devices.h

Paul Walmsley (12):
      OMAP3: id: remove identification codes that only correspond to marketing names
      OMAP3: id: remove useless strcpy()s
      OMAP3: id: use explicit omap_revision codes for 3505/3517 ES levels
      OMAP3: id: add fallthrough warning; fix some CodingStyle issues
      OMAP3: id: remove duplicate code for testing SoC ES level
      OMAP2+: id: remove OMAP_REVBITS_* macros
      OMAP: clockdomain: split clkdm_init()
      OMAP: clockdomain code/data: remove omap_chip bitmask from struct clockdomain
      OMAP: powerdomain: split pwrdm_init() into two functions
      OMAP: powerdomain: remove omap_chip bitmasks
      OMAP2+: hwmod: remove OMAP_CHIP*
      OMAP: id: remove OMAP_CHIP declarations, code

Sascha Hauer (7):
      Merge branch 'imx-cleanup' of git://git.pengutronix.de/git/ukl/linux-2.6 into imx-cleanup
      ARM i.MX audmux v2: remove unnecessary ifdefs
      ARM i.MX: remove ARCH_MX* macros from Makefile
      Merge branches 'cleanups/assorted', 'cleanups/shawn-cleanup-mxc-gpio', 'cleanups/troy-cleanup-iomux-v3' and 'cleanups/ukl-mx5-dynamically-allocate-devices' into imx-cleanups-for-arnd
      Merge branches 'cleanups/assorted' and 'cleanups/mm-tzic' into imx-cleanup
      Merge branches 'cleanups/mx3-mm-v2' and 'cleanups/mxs' into imx-cleanup
      Merge branches 'cleanups/mxs', 'cleanups/mx3-defconfig' and 'cleanups/includes' into imx-cleanups-for-arnd

Shawn Guo (17):
      arm/mxc: do not use gpio_to_irq() for static initializers
      gpio/mxc: add .to_irq for gpio chip
      arm/mxc: use gpiolib helper for gpio_to_irq
      gpio/mxc: move irq_to_gpio() into gpio-mxc driver
      arm/mxc: move IMX_GPIO_NR into mach/hardware.h
      gpio/mxs: move irq_to_gpio() into gpio-mxs driver
      arm/mxs: move MXS_GPIO_NR into mach/mxs.h
      arm/imx: merge mm-imx35.c into mm-imx31.c
      arm/imx: rename mm-imx31.c to mm-imx3.c
      arm/imx: change mxc_init_l2x0() to an imx31/35 specific call
      arm/imx: remove cpu_is_xxx() from arch_idle()
      arm/imx: remove cpu_is_xxx() check from __imx_ioremap()
      arm/imx: remove mx31_setup_weimcs() from mx31.h
      arm/imx: explicitly includes mach/hardware.h in mach-kzm_arm11_01.c
      arm/imx: remove mx27_setup_weimcs() from mx27.h
      arm/imx: explicitly includes mach/hardware.h in pm-imx27.c
      mmc: mxcmmc: explicitly includes mach/hardware.h

Thomas Meyer (1):
      ARM: davinci: edma: use kzalloc()

Tony Lindgren (9):
      omap2+: Use Kconfig symbol in Makefile instead of obj-y
      ARM: OMAP: Move omap2_init_common_devices out of init_early
      ARM: OMAP: Introduce SoC specific early_init
      Merge branch 'omap_chip_remove_cleanup_3.2' of git://git.pwsan.com/linux-2.6 into cleanup
      ARM: OMAP2+: Fix missing inline functions for Makefile cleanup
      Merge branch 'for_3.2/omap_device' of git://gitorious.org/khilman/linux-omap-pm into cleanup
      Merge branch 'for_3.2/pm-cleanup' of git://gitorious.org/khilman/linux-omap-pm into cleanup
      ARM: OMAP2+: Use SoC specifc map_io
      ARM: OMAP2+: Remove custom init_irq for remaining boards

Troy Kisky (3):
      ARM: i.MX51: Remove _MX51_PAD_xxx references
      ARM: i.MX51: clean up iomux-mx51.h
      ARM: i.MX53: clean up iomux-mx53.h

Uwe Kleine-König (8):
      ARM: mx5: fix remaining inconsistent names for irqs
      ARM: mx5: remove unused #includes of devices.h
      ARM: mx5: dynamically allocate mxc-ehci devices
      ARM: mx5: dynamically allocate fsl-usb2-udc devices
      ARM: mx5: dynamically allocate high speed i2c (imx-i2c actually)
      ARM: imx/mx1ads: dynamically allocate physmap-flash device
      ARM: imx/armadillo5x0: dynamically allocate physmap-flash device
      ARM: mxc: drop now unused function mxc_register_device

Wolfram Sang (1):
      arm: mx3: update defconfig

 arch/arm/Kconfig                                  |    1 +
 arch/arm/configs/mx3_defconfig                    |   46 +-
 arch/arm/include/asm/device.h                     |    5 +
 arch/arm/mach-davinci/devices-da8xx.c             |    3 +
 arch/arm/mach-davinci/devices-tnetv107x.c         |    1 +
 arch/arm/mach-davinci/dm355.c                     |    1 +
 arch/arm/mach-davinci/dm644x.c                    |    1 +
 arch/arm/mach-davinci/dm646x.c                    |    1 +
 arch/arm/mach-davinci/dma.c                       |    5 +-
 arch/arm/mach-exynos4/Kconfig                     |   17 +-
 arch/arm/mach-exynos4/Makefile                    |    2 +-
 arch/arm/mach-exynos4/mach-smdkc210.c             |  309 --
 arch/arm/mach-exynos4/mach-smdkv310.c             |   78 +
 arch/arm/mach-imx/Makefile                        |   15 +-
 arch/arm/mach-imx/cache-l2x0.c                    |   56 -
 arch/arm/mach-imx/mach-armadillo5x0.c             |   18 +-
 arch/arm/mach-imx/mach-cpuimx35.c                 |    2 +-
 arch/arm/mach-imx/mach-kzm_arm11_01.c             |    1 +
 arch/arm/mach-imx/mach-mx1ads.c                   |   15 +-
 arch/arm/mach-imx/mach-mx27_3ds.c                 |    2 +-
 arch/arm/mach-imx/mach-pcm038.c                   |    4 +-
 arch/arm/mach-imx/mach-qong.c                     |    5 +-
 arch/arm/mach-imx/mach-vpr200.c                   |    2 +-
 arch/arm/mach-imx/mm-imx3.c                       |  256 ++
 arch/arm/mach-imx/mm-imx31.c                      |   91 -
 arch/arm/mach-imx/mm-imx35.c                      |  109 -
 arch/arm/mach-imx/pm-imx27.c                      |    2 +-
 arch/arm/mach-mx5/Kconfig                         |   10 +-
 arch/arm/mach-mx5/Makefile                        |    3 +-
 arch/arm/mach-mx5/board-cpuimx51.c                |   27 +-
 arch/arm/mach-mx5/board-cpuimx51sd.c              |   25 +-
 arch/arm/mach-mx5/board-mx51_3ds.c                |    1 -
 arch/arm/mach-mx5/board-mx51_babbage.c            |   26 +-
 arch/arm/mach-mx5/board-mx51_efikamx.c            |    2 -
 arch/arm/mach-mx5/board-mx51_efikasb.c            |    6 +-
 arch/arm/mach-mx5/board-mx53_ard.c                |    4 +-
 arch/arm/mach-mx5/clock-mx51-mx53.c               |    2 +-
 arch/arm/mach-mx5/devices-imx51.h                 |   13 +
 arch/arm/mach-mx5/devices.c                       |  120 -
 arch/arm/mach-mx5/devices.h                       |    5 -
 arch/arm/mach-mx5/ehci.c                          |    2 +-
 arch/arm/mach-mx5/eukrea_mbimx51-baseboard.c      |    3 +-
 arch/arm/mach-mx5/eukrea_mbimxsd-baseboard.c      |    6 +-
 arch/arm/mach-mx5/mm-mx50.c                       |   72 -
 arch/arm/mach-mx5/mm.c                            |   90 +-
 arch/arm/mach-mx5/mx51_efika.c                    |   17 +-
 arch/arm/mach-mx5/pm-imx5.c                       |    3 +-
 arch/arm/mach-mx5/system.c                        |    1 +
 arch/arm/mach-mxs/Makefile                        |    6 +-
 arch/arm/mach-mxs/include/mach/gpio.h             |   28 +-
 arch/arm/mach-mxs/include/mach/mxs.h              |    2 +
 arch/arm/mach-mxs/mach-mx23evk.c                  |    3 +-
 arch/arm/mach-mxs/mach-mx28evk.c                  |   26 +-
 arch/arm/mach-mxs/mach-stmp378x_devb.c            |    1 -
 arch/arm/mach-mxs/mach-tx28.c                     |    2 +-
 arch/arm/mach-mxs/mm-mx23.c                       |   44 -
 arch/arm/mach-mxs/mm-mx28.c                       |   44 -
 arch/arm/mach-mxs/mm.c                            |   63 +
 arch/arm/mach-omap1/mcbsp.c                       |   45 +
 arch/arm/mach-omap2/Makefile                      |   85 +-
 arch/arm/mach-omap2/board-2430sdp.c               |   17 +-
 arch/arm/mach-omap2/board-3430sdp.c               |    9 +-
 arch/arm/mach-omap2/board-3630sdp.c               |   11 +-
 arch/arm/mach-omap2/board-4430sdp.c               |   17 +-
 arch/arm/mach-omap2/board-am3517crane.c           |    9 +-
 arch/arm/mach-omap2/board-am3517evm.c             |    8 +-
 arch/arm/mach-omap2/board-apollon.c               |   18 +-
 arch/arm/mach-omap2/board-cm-t35.c                |   13 +-
 arch/arm/mach-omap2/board-cm-t3517.c              |    9 +-
 arch/arm/mach-omap2/board-devkit8000.c            |   19 +-
 arch/arm/mach-omap2/board-flash.c                 |    5 -
 arch/arm/mach-omap2/board-flash.h                 |   19 +
 arch/arm/mach-omap2/board-generic.c               |    2 +-
 arch/arm/mach-omap2/board-h4.c                    |   24 +-
 arch/arm/mach-omap2/board-igep0020.c              |   13 +-
 arch/arm/mach-omap2/board-ldp.c                   |    9 +-
 arch/arm/mach-omap2/board-n8x0.c                  |   25 +-
 arch/arm/mach-omap2/board-omap3beagle.c           |   11 +-
 arch/arm/mach-omap2/board-omap3evm.c              |    9 +-
 arch/arm/mach-omap2/board-omap3logic.c            |   11 +-
 arch/arm/mach-omap2/board-omap3pandora.c          |   11 +-
 arch/arm/mach-omap2/board-omap3stalker.c          |   16 +-
 arch/arm/mach-omap2/board-omap3touchbook.c        |   18 +-
 arch/arm/mach-omap2/board-omap4panda.c            |   17 +-
 arch/arm/mach-omap2/board-overo.c                 |   11 +-
 arch/arm/mach-omap2/board-rm680.c                 |   25 +-
 arch/arm/mach-omap2/board-rx51.c                  |   25 +-
 arch/arm/mach-omap2/board-ti8168evm.c             |    9 +-
 arch/arm/mach-omap2/board-zoom.c                  |   23 +-
 arch/arm/mach-omap2/clock3xxx_data.c              |   11 +-
 arch/arm/mach-omap2/clockdomain.c                 |  147 +-
 arch/arm/mach-omap2/clockdomain.h                 |   22 +-
 arch/arm/mach-omap2/clockdomain2xxx_3xxx.c        |    4 -
 arch/arm/mach-omap2/clockdomain44xx.c             |    2 -
 arch/arm/mach-omap2/clockdomains2420_data.c       |  154 +
 arch/arm/mach-omap2/clockdomains2430_data.c       |  181 ++
 arch/arm/mach-omap2/clockdomains2xxx_3xxx_data.c  |  803 +-----
 arch/arm/mach-omap2/clockdomains3xxx_data.c       |  398 +++
 arch/arm/mach-omap2/clockdomains44xx_data.c       |  409 +--
 arch/arm/mach-omap2/common.c                      |   18 +
 arch/arm/mach-omap2/devices.c                     |   44 +-
 arch/arm/mach-omap2/display.c                     |    6 +-
 arch/arm/mach-omap2/dma.c                         |   16 +-
 arch/arm/mach-omap2/gpio.c                        |   10 +-
 arch/arm/mach-omap2/hsmmc.c                       |    8 +-
 arch/arm/mach-omap2/hwspinlock.c                  |    8 +-
 arch/arm/mach-omap2/id.c                          |  191 +-
 arch/arm/mach-omap2/io.c                          |   52 +-
 arch/arm/mach-omap2/mcbsp.c                       |  111 +-
 arch/arm/mach-omap2/omap_hwmod.c                  |    3 -
 arch/arm/mach-omap2/omap_hwmod_2420_data.c        |   37 -
 arch/arm/mach-omap2/omap_hwmod_2430_data.c        |   45 -
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c        |  169 +-
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c        |   82 -
 arch/arm/mach-omap2/opp.c                         |    2 +-
 arch/arm/mach-omap2/pm.c                          |   30 +-
 arch/arm/mach-omap2/pm24xx.c                      |   27 -
 arch/arm/mach-omap2/pm34xx.c                      |    2 +-
 arch/arm/mach-omap2/powerdomain-common.c          |    7 +-
 arch/arm/mach-omap2/powerdomain.c                 |   87 +-
 arch/arm/mach-omap2/powerdomain.h                 |    9 +-
 arch/arm/mach-omap2/powerdomains2xxx_3xxx_data.c  |   19 +-
 arch/arm/mach-omap2/powerdomains2xxx_data.c       |   44 +-
 arch/arm/mach-omap2/powerdomains3xxx_data.c       |   81 +-
 arch/arm/mach-omap2/powerdomains44xx_data.c       |   20 +-
 arch/arm/mach-omap2/serial.c                      |   14 +-
 arch/arm/mach-omap2/sr_device.c                   |    6 +-
 arch/arm/mach-prima2/clock.c                      |    4 +-
 arch/arm/mach-prima2/prima2.c                     |    2 +-
 arch/arm/mach-prima2/timer.c                      |    4 +-
 arch/arm/mach-s3c2410/Kconfig                     |    6 -
 arch/arm/mach-s3c2410/Makefile                    |    1 -
 arch/arm/mach-s3c2410/dma.c                       |   14 -
 arch/arm/mach-s3c2410/gpio.c                      |   72 -
 arch/arm/mach-s3c2410/include/mach/map.h          |   52 +-
 arch/arm/mach-s3c2412/Kconfig                     |    1 -
 arch/arm/mach-s3c2412/Makefile                    |    1 -
 arch/arm/mach-s3c2412/dma.c                       |   18 -
 arch/arm/mach-s3c2412/gpio.c                      |   62 -
 arch/arm/mach-s3c2440/Kconfig                     |    2 -
 arch/arm/mach-s3c2440/dma.c                       |   17 -
 arch/arm/mach-s3c2443/dma.c                       |   27 -
 arch/arm/mach-s3c64xx/include/mach/map.h          |    9 +-
 arch/arm/mach-s3c64xx/mach-crag6410.c             |    3 -
 arch/arm/mach-s3c64xx/mach-mini6410.c             |    8 +-
 arch/arm/mach-s3c64xx/mach-real6410.c             |    8 +-
 arch/arm/mach-s3c64xx/mach-smdk6410.c             |    8 +-
 arch/arm/mach-s5p64x0/mach-smdk6440.c             |    8 +-
 arch/arm/mach-s5p64x0/mach-smdk6450.c             |    8 +-
 arch/arm/mach-s5pc100/mach-smdkc100.c             |    8 +-
 arch/arm/mach-s5pv210/Kconfig                     |    6 -
 arch/arm/mach-s5pv210/Makefile                    |    2 +-
 arch/arm/mach-s5pv210/mach-smdkv210.c             |    8 +-
 arch/arm/mach-tegra/common.c                      |    2 +-
 arch/arm/mach-tegra/cpu-tegra.c                   |    6 +-
 arch/arm/mach-tegra/devices.c                     |    2 +
 arch/arm/mach-tegra/dma.c                         |   14 +-
 arch/arm/mach-tegra/include/mach/io.h             |   18 +-
 arch/arm/mach-tegra/include/mach/powergate.h      |    1 -
 arch/arm/mach-tegra/io.c                          |    8 +-
 arch/arm/mach-tegra/pcie.c                        |    8 +-
 arch/arm/mach-tegra/powergate.c                   |    5 +-
 arch/arm/mach-tegra/tegra2_clocks.c               |   50 +-
 arch/arm/mach-tegra/timer.c                       |    6 +-
 arch/arm/mach-u300/Kconfig                        |   46 -
 arch/arm/mach-u300/Makefile.boot                  |   17 +-
 arch/arm/mach-u300/core.c                         |   81 +-
 arch/arm/mach-u300/include/mach/memory.h          |   22 +-
 arch/arm/mach-u300/u300.c                         |   16 -
 arch/arm/mach-ux500/Makefile                      |    1 +
 arch/arm/mach-ux500/board-mop500-pins.c           |   34 +-
 arch/arm/mach-ux500/board-mop500-sdi.c            |   52 +-
 arch/arm/mach-ux500/board-mop500.c                |   78 +-
 arch/arm/mach-ux500/board-mop500.h                |    3 +
 arch/arm/mach-ux500/cache-l2x0.c                  |   95 +
 arch/arm/mach-ux500/cpu.c                         |   92 -
 arch/arm/mach-ux500/include/mach/uncompress.h     |   10 +-
 arch/arm/mach-ux500/pins-db8500.h                 |  142 +-
 arch/arm/plat-mxc/audmux-v2.c                     |   18 +-
 arch/arm/plat-mxc/devices.c                       |   14 -
 arch/arm/plat-mxc/devices/Kconfig                 |    2 +-
 arch/arm/plat-mxc/devices/platform-fsl-usb2-udc.c |    5 +
 arch/arm/plat-mxc/devices/platform-imx-i2c.c      |    6 +
 arch/arm/plat-mxc/devices/platform-mxc-ehci.c     |    9 +
 arch/arm/plat-mxc/include/mach/common.h           |   12 +-
 arch/arm/plat-mxc/include/mach/gpio.h             |   34 +-
 arch/arm/plat-mxc/include/mach/hardware.h         |   13 +-
 arch/arm/plat-mxc/include/mach/io.h               |   22 +-
 arch/arm/plat-mxc/include/mach/iomux-mx51.h       | 2270 +++++---------
 arch/arm/plat-mxc/include/mach/iomux-mx53.h       | 3530 +++++++--------------
 arch/arm/plat-mxc/include/mach/iomux-v3.h         |    1 +
 arch/arm/plat-mxc/include/mach/mx27.h             |   14 -
 arch/arm/plat-mxc/include/mach/mx31.h             |   14 -
 arch/arm/plat-mxc/include/mach/mx51.h             |  183 +-
 arch/arm/plat-mxc/include/mach/mx53.h             |    1 +
 arch/arm/plat-mxc/include/mach/mxc.h              |    7 -
 arch/arm/plat-mxc/include/mach/system.h           |   35 +-
 arch/arm/plat-mxc/system.c                        |    3 +
 arch/arm/plat-nomadik/include/plat/pincfg.h       |    5 -
 arch/arm/plat-omap/devices.c                      |   44 -
 arch/arm/plat-omap/i2c.c                          |    8 +-
 arch/arm/plat-omap/include/plat/clock.h           |    2 -
 arch/arm/plat-omap/include/plat/common.h          |   13 +
 arch/arm/plat-omap/include/plat/cpu.h             |  108 +-
 arch/arm/plat-omap/include/plat/io.h              |    2 +-
 arch/arm/plat-omap/include/plat/mcbsp.h           |  208 +-
 arch/arm/plat-omap/include/plat/omap_device.h     |   30 +-
 arch/arm/plat-omap/include/plat/omap_hwmod.h      |    2 -
 arch/arm/plat-omap/mcbsp.c                        |  385 +--
 arch/arm/plat-omap/omap_device.c                  |  185 +-
 arch/arm/plat-s3c24xx/include/plat/map.h          |  100 -
 arch/arm/plat-s5p/include/plat/map-s5p.h          |   61 -
 arch/arm/plat-s5p/include/plat/pll.h              |    1 -
 arch/arm/plat-samsung/dev-hsmmc.c                 |   19 +-
 arch/arm/plat-samsung/dev-hsmmc1.c                |   19 +-
 arch/arm/plat-samsung/dev-hsmmc2.c                |   19 +-
 arch/arm/plat-samsung/dev-hsmmc3.c                |   19 +-
 arch/arm/plat-samsung/dev-ts.c                    |    9 +
 arch/arm/plat-samsung/include/plat/dma-s3c24xx.h  |    6 -
 arch/arm/plat-samsung/include/plat/map-s3c.h      |   84 +
 arch/arm/plat-samsung/include/plat/map-s5p.h      |   61 +
 arch/arm/plat-samsung/include/plat/sdhci.h        |    7 +
 arch/arm/plat-samsung/platformdata.c              |   22 +
 drivers/gpio/gpio-mxc.c                           |   12 +
 drivers/gpio/gpio-mxs.c                           |    2 +
 drivers/mmc/host/mxcmmc.c                         |    1 +
 226 files changed, 5368 insertions(+), 8954 deletions(-)

