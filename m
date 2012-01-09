Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933407Ab2AIWOG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 17:14:06 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:63111 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932756Ab2AIWN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 17:13:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL 02/11] Cleanups on various subarchitectures
Date: Mon,  9 Jan 2012 22:12:42 +0000
Message-Id: <1326147171-13752-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1326147171-13752-1-git-send-email-arnd@arndb.de>
References: <1326147171-13752-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:QZys+bEpHmqi2U10a68fQTKwJuduFSTH0hYZayS8MYm
 4J1avGW2IHDSHwuV53f8qGN44ZTuFxhZwsRx9v+eyjdU/yKEve
 +ZZT9qO5prpy0VvnKY1iYdQbQuXOJVehW2e0CKIwQGBDOOm9UJ
 F3brw16xCEdO6QSy42vVX+iNh7ESTZ1OFSJb/EPIpCICHZY5wf
 j8nh42B77+SyTMn9NMgZkeJ0oeZu50dsIbvQz3bkg/FVdM7oLj
 6lLxw0OBCssp9gwrTQnb4z93tAkL0qNv33yVBURm4HI1NAXpjp
 Z/a/2ChOGfE8yeSVwgqCXqFbSl9oVU1Mqmp8Y5Jat2KJSuW5Dw
 aQBE2i0IFI2zZKYAu5i+DJp96QdvqB5EvR9Y8LvIFdfGdlyyhh
 e89bnbnf8TxzQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup patches for various ARM platforms and some of their associated
drivers, the bulk of these is for mach-91.

I ended up pulling in the restart branch from Russell in order to
fix up some simple but annoying merge conflicts.

The following changes since commit 62efb06002328a599da7aabe0fca61e9d1bdb8e1:

  Merge branch 'next/fixes-non-critical' into for-next3 (2012-01-09 16:47:27 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git next/cleanup

Arnd Bergmann (5):
      Merge branch 'drivers/macb-gem-cleanup' into at91/gpio
      Merge branches 'at91/gpio', 'at91/ioremap', 'drivers/macb-gem-cleanup' and 'msm/misc' into next/cleanup
      Merge branch 'davinci/cleanup' into next/cleanup
      Merge branch 'tegra/cleanup' into next/cleanup
      Merge branch 'depends/rmk/restart' into next/cleanup

Jamie Iles (8):
      at91: provide macb clks with "pclk" and "hclk" name
      macb: remove conditional clk handling
      macb: unify at91 and avr32 platform data
      macb: convert printk to netdev_ and friends
      ARM: picoxcell: remove mach/memory.h
      ARM: picoxcell: don't reserve irq_descs
      ARM: picoxcell: move io mappings to common.c
      MAINTAINERS: add maintainer entry for Picochip picoxcell

Jean-Christophe PLAGNIOL-VILLARD (26):
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

Linus Walleij (1):
      ARM: u300: delete memory.h

Manjunath Hadli (1):
      ARM: davinci: vpif: move code to driver core header from platform

Olof Johansson (6):
      arm/tegra: fix variable formatting in makefile
      Merge branch 'for-arnd-3.3-defconfig' of git://github.com/at91linux/linux-at91 into at91/defconfig
      Merge branch 'at91/defconfig' into next/cleanup
      Merge branch 'picoxcell/cleanup' into next/cleanup
      Merge branch 'u300/cleanup' into next/cleanup
      arm/at91: fix build of stamp9g20

Paul Gortmaker (1):
      ARM: at91: delete the pcontrol_g20_defconfig

Stephen Boyd (3):
      ARM: msm: Consolidate and move DEBUG_LL to DEBUG_LL choice
      msm: Support DEBUG_LL on MSM8660 and MSM8960
      msm: platsmp: Mark ioremapped memory as __iomem

Stephen Warren (1):
      arm/tegra: Remove code that's ifndef CONFIG_ARM_GIC

pdeschrijver@nvidia.com (1):
      arm/tegra: remove unused defines

 MAINTAINERS                                     |    9 +
 arch/arm/Kconfig                                |    2 +-
 arch/arm/Kconfig.debug                          |   45 +++
 arch/arm/configs/pcontrol_g20_defconfig         |  175 ------------
 arch/arm/mach-at91/Kconfig                      |   24 ++-
 arch/arm/mach-at91/at91cap9.c                   |   40 ++--
 arch/arm/mach-at91/at91cap9_devices.c           |   49 ++--
 arch/arm/mach-at91/at91rm9200.c                 |   24 +-
 arch/arm/mach-at91/at91rm9200_devices.c         |   48 ++--
 arch/arm/mach-at91/at91rm9200_time.c            |    8 +-
 arch/arm/mach-at91/at91sam9260.c                |   36 ++--
 arch/arm/mach-at91/at91sam9260_devices.c        |   55 +++--
 arch/arm/mach-at91/at91sam9261.c                |   32 +-
 arch/arm/mach-at91/at91sam9261_devices.c        |   33 ++-
 arch/arm/mach-at91/at91sam9263.c                |   45 ++--
 arch/arm/mach-at91/at91sam9263_devices.c        |   59 +++--
 arch/arm/mach-at91/at91sam926x_time.c           |   38 ++-
 arch/arm/mach-at91/at91sam9g45.c                |   44 ++--
 arch/arm/mach-at91/at91sam9g45_devices.c        |   69 +++--
 arch/arm/mach-at91/at91sam9rl.c                 |   36 ++--
 arch/arm/mach-at91/at91sam9rl_devices.c         |   43 ++--
 arch/arm/mach-at91/board-1arm.c                 |    4 +-
 arch/arm/mach-at91/board-afeb-9260v1.c          |   10 +-
 arch/arm/mach-at91/board-cam60.c                |    8 +-
 arch/arm/mach-at91/board-cap9adk.c              |   21 +-
 arch/arm/mach-at91/board-carmeva.c              |    9 +-
 arch/arm/mach-at91/board-cpu9krea.c             |   14 +-
 arch/arm/mach-at91/board-cpuat91.c              |    7 +-
 arch/arm/mach-at91/board-csb337.c               |    7 +-
 arch/arm/mach-at91/board-csb637.c               |    4 +-
 arch/arm/mach-at91/board-dt.c                   |    3 +-
 arch/arm/mach-at91/board-eb9200.c               |   11 +-
 arch/arm/mach-at91/board-ecbat91.c              |    7 +-
 arch/arm/mach-at91/board-eco920.c               |    7 +-
 arch/arm/mach-at91/board-flexibity.c            |    5 +-
 arch/arm/mach-at91/board-foxg20.c               |    9 +-
 arch/arm/mach-at91/board-gsia18s.c              |    7 +-
 arch/arm/mach-at91/board-kafa.c                 |    4 +-
 arch/arm/mach-at91/board-kb9202.c               |    8 +-
 arch/arm/mach-at91/board-neocore926.c           |    9 +-
 arch/arm/mach-at91/board-pcontrol-g20.c         |    8 +-
 arch/arm/mach-at91/board-picotux200.c           |    5 +-
 arch/arm/mach-at91/board-qil-a9260.c            |   18 +-
 arch/arm/mach-at91/board-rm9200dk.c             |   13 +-
 arch/arm/mach-at91/board-rm9200ek.c             |    5 +-
 arch/arm/mach-at91/board-rsi-ews.c              |    4 +-
 arch/arm/mach-at91/board-sam9-l9260.c           |   12 +-
 arch/arm/mach-at91/board-sam9260ek.c            |   16 +-
 arch/arm/mach-at91/board-sam9261ek.c            |   13 +-
 arch/arm/mach-at91/board-sam9263ek.c            |   12 +-
 arch/arm/mach-at91/board-sam9g20ek.c            |   13 +-
 arch/arm/mach-at91/board-sam9m10g45ek.c         |    8 +-
 arch/arm/mach-at91/board-sam9rlek.c             |    9 +-
 arch/arm/mach-at91/board-snapper9260.c          |   10 +-
 arch/arm/mach-at91/board-stamp9g20.c            |   16 +-
 arch/arm/mach-at91/board-usb-a926x.c            |   14 +-
 arch/arm/mach-at91/board-yl-9200.c              |    9 +-
 arch/arm/mach-at91/generic.h                    |    7 +-
 arch/arm/mach-at91/gpio.c                       |   85 ++++---
 arch/arm/mach-at91/include/mach/at91_aic.h      |   48 ++--
 arch/arm/mach-at91/include/mach/at91_dbgu.h     |    2 +-
 arch/arm/mach-at91/include/mach/at91_pit.h      |    8 +-
 arch/arm/mach-at91/include/mach/at91_rtc.h      |   24 +-
 arch/arm/mach-at91/include/mach/at91_shdwc.h    |   16 +-
 arch/arm/mach-at91/include/mach/at91cap9.h      |   27 +-
 arch/arm/mach-at91/include/mach/at91rm9200.h    |   14 +-
 arch/arm/mach-at91/include/mach/at91sam9260.h   |   23 +-
 arch/arm/mach-at91/include/mach/at91sam9261.h   |   20 +-
 arch/arm/mach-at91/include/mach/at91sam9263.h   |   33 +--
 arch/arm/mach-at91/include/mach/at91sam9_smc.h  |   17 +-
 arch/arm/mach-at91/include/mach/at91sam9g45.h   |   30 +-
 arch/arm/mach-at91/include/mach/at91sam9rl.h    |   29 +-
 arch/arm/mach-at91/include/mach/at91x40.h       |    1 -
 arch/arm/mach-at91/include/mach/board.h         |   42 +--
 arch/arm/mach-at91/include/mach/debug-macro.S   |   10 +-
 arch/arm/mach-at91/include/mach/entry-macro.S   |   11 +-
 arch/arm/mach-at91/include/mach/gpio.h          |  336 +++++++++++------------
 arch/arm/mach-at91/include/mach/hardware.h      |   12 +
 arch/arm/mach-at91/include/mach/irqs.h          |    2 +-
 arch/arm/mach-at91/include/mach/timex.h         |   65 +----
 arch/arm/mach-at91/include/mach/uncompress.h    |    6 +-
 arch/arm/mach-at91/irq.c                        |   38 ++-
 arch/arm/mach-at91/pm.c                         |   11 +-
 arch/arm/mach-at91/sam9_smc.c                   |   62 +++--
 arch/arm/mach-at91/sam9_smc.h                   |    3 +-
 arch/arm/mach-at91/setup.c                      |   26 ++-
 arch/arm/mach-at91/soc.h                        |    1 +
 arch/arm/mach-davinci/include/mach/dm646x.h     |   53 +----
 arch/arm/mach-exynos/common.c                   |   20 +--
 arch/arm/mach-msm/Kconfig                       |   35 +---
 arch/arm/mach-msm/include/mach/debug-macro.S    |   51 +++--
 arch/arm/mach-msm/include/mach/msm_iomap-7x00.h |   12 -
 arch/arm/mach-msm/include/mach/msm_iomap-7x30.h |   12 -
 arch/arm/mach-msm/include/mach/msm_iomap-8960.h |    5 +
 arch/arm/mach-msm/include/mach/msm_iomap-8x50.h |   12 -
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h |    5 +
 arch/arm/mach-msm/include/mach/msm_iomap.h      |   12 +
 arch/arm/mach-msm/include/mach/uncompress.h     |   39 ++-
 arch/arm/mach-msm/io.c                          |   15 +-
 arch/arm/mach-msm/platsmp.c                     |    2 +-
 arch/arm/mach-picoxcell/Makefile                |    1 -
 arch/arm/mach-picoxcell/common.c                |   15 +-
 arch/arm/mach-picoxcell/common.h                |    1 -
 arch/arm/mach-picoxcell/include/mach/irqs.h     |    9 +-
 arch/arm/mach-picoxcell/include/mach/memory.h   |    1 -
 arch/arm/mach-picoxcell/io.c                    |   32 ---
 arch/arm/mach-tegra/Makefile                    |   26 +-
 arch/arm/mach-tegra/include/mach/entry-macro.S  |   18 --
 arch/arm/mach-tegra/irq.c                       |    4 -
 arch/arm/mach-u300/include/mach/memory.h        |   19 --
 arch/arm/mach-u300/u300.c                       |    2 +-
 arch/avr32/boards/atngw100/setup.c              |    2 +-
 arch/avr32/boards/atstk1000/atstk1002.c         |    2 +-
 arch/avr32/boards/favr-32/setup.c               |    2 +-
 arch/avr32/boards/hammerhead/setup.c            |    2 +-
 arch/avr32/boards/merisc/setup.c                |    2 +-
 arch/avr32/boards/mimc200/setup.c               |    2 +-
 arch/avr32/mach-at32ap/at32ap700x.c             |    8 +-
 arch/avr32/mach-at32ap/include/mach/board.h     |    7 +-
 drivers/ata/pata_at91.c                         |    6 +-
 drivers/ide/at91_ide.c                          |    2 +-
 drivers/media/video/davinci/vpif.h              |    1 +
 drivers/media/video/davinci/vpif_capture.h      |    2 +-
 drivers/media/video/davinci/vpif_display.h      |    1 +
 drivers/mmc/host/at91_mci.c                     |   30 +-
 drivers/mtd/nand/atmel_nand.c                   |    8 +-
 drivers/net/ethernet/cadence/at91_ether.c       |    3 +-
 drivers/net/ethernet/cadence/at91_ether.h       |    4 +-
 drivers/net/ethernet/cadence/macb.c             |  153 +++++------
 drivers/rtc/rtc-at91rm9200.c                    |  101 +++++---
 drivers/usb/gadget/at91_udc.c                   |   14 +-
 drivers/usb/host/ohci-at91.c                    |   12 +-
 drivers/watchdog/at91sam9_wdt.c                 |   22 ++-
 drivers/watchdog/at91sam9_wdt.h                 |    6 +-
 include/linux/platform_data/macb.h              |   17 ++
 include/media/davinci/vpif_types.h              |   71 +++++
 136 files changed, 1643 insertions(+), 1500 deletions(-)
