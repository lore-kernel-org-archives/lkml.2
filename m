Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab1LKUMy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 15:12:54 -0500
Received: from d1.icnet.pl ([212.160.220.21]:48075 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223Ab1LKUMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 15:12:52 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        linux-input@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-fbdev@vger.kernel.org, alsa-devel@alsa-project.org,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 00/10] ARM: OMAP1: ams-delta: replace custom I/O with GPIO
Date: Sun, 11 Dec 2011 21:11:58 +0100
Message-Id: <1323634328-856-1-git-send-email-jkrzyszt@tis.icnet.pl>
X-Mailer: git-send-email 1.7.3.4
To: Grant Likely <grant.likely@secretlab.ca>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Amstrad Delta board has two extra output ports used for driving
input lines of different on-board devices. Those ports are now
controlled with custom functions, provided by the board arch code and
used by several device drivers.

The idea behind the series is to replace those custom I/O functions
with gpiolib API. This way, existing drivers can be made less platform
dependent, and some of them perhaps even superseded with generic GPIO
based drivers after the board platform device descriptions are
converted. Moreover, should a new driver for the on-board Smart Card
controller ever be created, it could be designed as a generic GPIO
based driver, not a custom one.

Janusz Krzysztofik (10):
  GPIO: gpio-generic: Move initialization up to postcore
  ARM: OMAP1: ams-delta: convert latches to basic_mmio_gpio
  ARM: OMAP1: ams-delta: supersede custom led device by leds-gpio
  LED: drop leds-ams-delta driver
  MTD: NAND: ams-delta: use GPIO instead of custom I/O
  ARM: OMAP1: ams-delta: Use GPIO API in modem setup
  ASoC: OMAP: ams-delta: Drive modem/codec pins over GPIO API
  omapfb: lcd_ams_delta: Drive control lines over GPIO
  input: serio: ams-delta: toggle keyboard power over GPIO
  ARM: OMAP1: ams-delta: drop custom I/O functions

 arch/arm/mach-omap1/Kconfig                       |    2 +
 arch/arm/mach-omap1/board-ams-delta.c             |  220 +++++++++++++++++----
 arch/arm/plat-omap/include/plat/board-ams-delta.h |   50 ++---
 drivers/gpio/gpio-generic.c                       |    2 +-
 drivers/input/serio/ams_delta_serio.c             |   45 +++--
 drivers/leds/Kconfig                              |    7 -
 drivers/leds/Makefile                             |    1 -
 drivers/leds/leds-ams-delta.c                     |  137 -------------
 drivers/mtd/nand/ams-delta.c                      |   74 +++++--
 drivers/video/omap/lcd_ams_delta.c                |   27 ++-
 sound/soc/omap/ams-delta.c                        |   21 ++-
 11 files changed, 309 insertions(+), 277 deletions(-)
 delete mode 100644 drivers/leds/leds-ams-delta.c

-- 
1.7.3.4

