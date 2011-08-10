Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab1HJMQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 08:16:33 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:60080 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753875Ab1HJMQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 08:16:31 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 00/19] GPIO exodus and cleanup
Date: Wed, 10 Aug 2011 14:16:04 +0200
Message-ID: <1312978564-18069-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

The following patch set is rebased on top of Russell's
13 cleanup patches and can be finalized as soon as there
is a branch in RMKs tree that can accumulate this work.

Ideas:

- Move all GPIO drivers to drivers/gpio/gpio-<foo> so the
  GPIO maintainer can deal with consolidating them

- Break <[mach|plat]/gpio.h> apart - <mach/gpio.h> is for
  generic GPIO and gpiolib *only*, whereas <mach/gpio-foo.h>
  is for the platform and driver to use.

- For ixp200 and pnx4008 the <mach/gpio.h> was only really
  a custom header without any generic GPIO or gpiolib, so just
  rename it and get rid of it.

- Delete irq_to_gpio where not used

For the movement patches it'd great to have the GPIO
maintainers ACK.

Linus Walleij (19):
  plat-nomadik: break out GPIO driver specifics
  mach-u300: break out GPIO driver specifics
  mach-u300: delete irq_to_gpio() function
  mach-ks8695: move GPIO driver to GPIO subsystem
  mach-ks8695: break out GPIO driver specifics
  mach-ks8695: fix GPIO LEDs
  mach-davinci: move GPIO driver to GPIO subsystem
  mach-davinci: move DaVinci TNET GPIO driver to GPIO subsystem
  mach-davinci: break out GPIO driver specifics
  mach-ep93xx: break out GPIO driver specifics
  mach-ixp2000: rename GPIO header
  mach-lpc32xx: move LPC32XX GPIO driver to GPIO subsystem
  mach-lpc32xx: break out GPIO driver specifics
  plat-pxa: move PXA GPIO driver to GPIO subsystem
  plat-pxa: break out GPIO driver specifics
  mach-pnx4008: move PNX4008 GPIO driver to GPIO subsystem
  mach-pnx4008: rename GPIO header
  mach-sa1100: move SA1100 GPIO driver to GPIO subsystem
  mach-sa1100: delete irq_to_gpio() function

 arch/arm/mach-davinci/Makefile                    |    3 +-
 arch/arm/mach-davinci/da830.c                     |    1 +
 arch/arm/mach-davinci/da850.c                     |    1 +
 arch/arm/mach-davinci/dm355.c                     |    2 +-
 arch/arm/mach-davinci/dm365.c                     |    3 +-
 arch/arm/mach-davinci/dm644x.c                    |    2 +-
 arch/arm/mach-davinci/dm646x.c                    |    2 +-
 arch/arm/mach-davinci/gpio-tnetv107x.c            |  205 ---------
 arch/arm/mach-davinci/gpio.c                      |  458 ---------------------
 arch/arm/mach-davinci/include/mach/gpio-davinci.h |   91 ++++
 arch/arm/mach-davinci/include/mach/gpio.h         |   76 +----
 arch/arm/mach-davinci/tnetv107x.c                 |    1 +
 arch/arm/mach-ep93xx/core.c                       |    1 +
 arch/arm/mach-ep93xx/edb93xx.c                    |    1 +
 arch/arm/mach-ep93xx/include/mach/gpio-ep93xx.h   |  100 +++++
 arch/arm/mach-ep93xx/include/mach/gpio.h          |   97 +----
 arch/arm/mach-ep93xx/simone.c                     |    2 +-
 arch/arm/mach-ep93xx/snappercl15.c                |    2 +-
 arch/arm/mach-ixp2000/core.c                      |    2 +
 arch/arm/mach-ixp2000/include/mach/gpio-ixp2000.h |   48 +++
 arch/arm/mach-ixp2000/include/mach/gpio.h         |   48 ---
 arch/arm/mach-ixp2000/ixdp2x00.c                  |    1 +
 arch/arm/mach-ks8695/Makefile                     |    2 +-
 arch/arm/mach-ks8695/board-acs5k.c                |    1 +
 arch/arm/mach-ks8695/board-dsm320.c               |    1 +
 arch/arm/mach-ks8695/board-micrel.c               |    1 +
 arch/arm/mach-ks8695/devices.c                    |    1 +
 arch/arm/mach-ks8695/gpio.c                       |  318 --------------
 arch/arm/mach-ks8695/include/mach/gpio-ks8695.h   |   39 ++
 arch/arm/mach-ks8695/include/mach/gpio.h          |   27 --
 arch/arm/mach-ks8695/leds.c                       |    1 +
 arch/arm/mach-lpc32xx/Makefile                    |    2 +-
 arch/arm/mach-lpc32xx/gpiolib.c                   |  446 --------------------
 arch/arm/mach-lpc32xx/include/mach/gpio-lpc32xx.h |   50 +++
 arch/arm/mach-lpc32xx/include/mach/gpio.h         |   52 ---
 arch/arm/mach-lpc32xx/phy3250.c                   |    1 +
 arch/arm/mach-mmp/aspenite.c                      |    1 +
 arch/arm/mach-mmp/brownstone.c                    |    1 -
 arch/arm/mach-mmp/gplugd.c                        |    2 +-
 arch/arm/mach-mmp/include/mach/gpio-pxa.h         |   30 ++
 arch/arm/mach-mmp/include/mach/gpio.h             |   23 -
 arch/arm/mach-mmp/jasper.c                        |    1 -
 arch/arm/mach-mmp/mmp2.c                          |    2 +-
 arch/arm/mach-mmp/pxa168.c                        |    2 +-
 arch/arm/mach-mmp/pxa910.c                        |    2 +-
 arch/arm/mach-mmp/tavorevb.c                      |    1 +
 arch/arm/mach-nomadik/board-nhk8815.c             |    1 +
 arch/arm/mach-nomadik/cpu-8815.c                  |    2 +-
 arch/arm/mach-nomadik/i2c-8815nhk.c               |    2 +-
 arch/arm/mach-pnx4008/Makefile                    |    2 +-
 arch/arm/mach-pnx4008/gpio.c                      |  328 ---------------
 arch/arm/mach-pnx4008/include/mach/gpio-pnx4008.h |  241 +++++++++++
 arch/arm/mach-pnx4008/include/mach/gpio.h         |  241 -----------
 arch/arm/mach-pnx4008/serial.c                    |    2 +-
 arch/arm/mach-pxa/cm-x255.c                       |    1 -
 arch/arm/mach-pxa/include/mach/gpio-pxa.h         |  133 ++++++
 arch/arm/mach-pxa/include/mach/gpio.h             |  110 +-----
 arch/arm/mach-pxa/include/mach/littleton.h        |    2 +-
 arch/arm/mach-pxa/irq.c                           |    2 +-
 arch/arm/mach-pxa/mfp-pxa2xx.c                    |    1 +
 arch/arm/mach-pxa/pxa25x.c                        |    1 +
 arch/arm/mach-pxa/pxa27x.c                        |    1 +
 arch/arm/mach-pxa/pxa3xx.c                        |    2 +-
 arch/arm/mach-pxa/pxa95x.c                        |    2 +-
 arch/arm/mach-pxa/saarb.c                         |    1 +
 arch/arm/mach-sa1100/Makefile                     |    2 +-
 arch/arm/mach-sa1100/gpio.c                       |   64 ---
 arch/arm/mach-sa1100/include/mach/gpio.h          |    2 -
 arch/arm/mach-u300/include/mach/gpio-u300.h       |  253 ++++++++++++
 arch/arm/mach-u300/include/mach/gpio.h            |  258 +------------
 arch/arm/mach-u300/mmc.c                          |    2 +-
 arch/arm/mach-ux500/board-mop500-pins.c           |    2 +-
 arch/arm/mach-ux500/board-mop500.c                |    1 +
 arch/arm/mach-ux500/board-u5500-sdi.c             |    2 +-
 arch/arm/mach-ux500/board-u5500.c                 |    2 +-
 arch/arm/mach-ux500/cpu-db5500.c                  |    2 +-
 arch/arm/mach-ux500/cpu-db8500.c                  |    2 +-
 arch/arm/mach-ux500/devices-common.c              |    2 +-
 arch/arm/plat-nomadik/include/plat/gpio-nomadik.h |   85 ++++
 arch/arm/plat-nomadik/include/plat/gpio.h         |   69 ---
 arch/arm/plat-pxa/Makefile                        |    1 -
 arch/arm/plat-pxa/gpio.c                          |  336 ---------------
 arch/arm/plat-pxa/include/plat/gpio-pxa.h         |   44 ++
 arch/arm/plat-pxa/include/plat/gpio.h             |   40 +--
 drivers/gpio/Makefile                             |    8 +-
 drivers/gpio/gpio-davinci.c                       |  458 +++++++++++++++++++++
 drivers/gpio/gpio-ks8695.c                        |  319 ++++++++++++++
 drivers/gpio/gpio-lpc32xx.c                       |  446 ++++++++++++++++++++
 drivers/gpio/gpio-nomadik.c                       |    1 +
 drivers/gpio/gpio-pnx4008.c                       |  328 +++++++++++++++
 drivers/gpio/gpio-pxa.c                           |  338 +++++++++++++++
 drivers/gpio/gpio-sa1100.c                        |   63 +++
 drivers/gpio/gpio-tnetv107x.c                     |  205 +++++++++
 drivers/gpio/gpio-u300.c                          |    1 +
 drivers/i2c/busses/i2c-ixp2000.c                  |    2 +-
 95 files changed, 3348 insertions(+), 3219 deletions(-)
 delete mode 100644 arch/arm/mach-davinci/gpio-tnetv107x.c
 delete mode 100644 arch/arm/mach-davinci/gpio.c
 create mode 100644 arch/arm/mach-davinci/include/mach/gpio-davinci.h
 create mode 100644 arch/arm/mach-ep93xx/include/mach/gpio-ep93xx.h
 create mode 100644 arch/arm/mach-ixp2000/include/mach/gpio-ixp2000.h
 delete mode 100644 arch/arm/mach-ixp2000/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-ks8695/gpio.c
 create mode 100644 arch/arm/mach-ks8695/include/mach/gpio-ks8695.h
 delete mode 100644 arch/arm/mach-lpc32xx/gpiolib.c
 create mode 100644 arch/arm/mach-lpc32xx/include/mach/gpio-lpc32xx.h
 create mode 100644 arch/arm/mach-mmp/include/mach/gpio-pxa.h
 delete mode 100644 arch/arm/mach-pnx4008/gpio.c
 create mode 100644 arch/arm/mach-pnx4008/include/mach/gpio-pnx4008.h
 delete mode 100644 arch/arm/mach-pnx4008/include/mach/gpio.h
 create mode 100644 arch/arm/mach-pxa/include/mach/gpio-pxa.h
 delete mode 100644 arch/arm/mach-sa1100/gpio.c
 create mode 100644 arch/arm/mach-u300/include/mach/gpio-u300.h
 create mode 100644 arch/arm/plat-nomadik/include/plat/gpio-nomadik.h
 delete mode 100644 arch/arm/plat-pxa/gpio.c
 create mode 100644 arch/arm/plat-pxa/include/plat/gpio-pxa.h
 create mode 100644 drivers/gpio/gpio-davinci.c
 create mode 100644 drivers/gpio/gpio-ks8695.c
 create mode 100644 drivers/gpio/gpio-lpc32xx.c
 create mode 100644 drivers/gpio/gpio-pnx4008.c
 create mode 100644 drivers/gpio/gpio-pxa.c
 create mode 100644 drivers/gpio/gpio-sa1100.c
 create mode 100644 drivers/gpio/gpio-tnetv107x.c

-- 
1.7.3.2

