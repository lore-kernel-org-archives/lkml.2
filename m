Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab1EILU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 07:20:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:22804 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525Ab1EILUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 07:20:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,340,1301900400"; 
   d="scan'208";a="919897486"
Date: Mon, 9 May 2011 13:20:21 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/19] mfd: mfd_data removal
Message-ID: <20110509112020.GB8071@sortiz-mobl>
References: <1304901131-7104-1-git-send-email-sameo@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1304901131-7104-1-git-send-email-sameo@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patchset is using the newly added platform_device mfd_cell pointer to get
rid of the mfd_data cell pointer.
Drivers willing to access their parent MFD cell will do so through the
mfd_get_cell accessor. Other drivers (and in particular the non MFD ones) will
get their platform data bits from the cell's platform_data pointer. This
allows for non MFD sub drivers to not depend on the MFD core APIs if they
don't need to.

Cc: Andres Salomon <dilinger@queued.net>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Florian Fainelli <florian@openwrt.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: Ian Molton <spyro@f2s.com>
Cc: Ira W. Snyder <iws@ovro.caltech.edu>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Matti Aaltonen <matti.j.aaltonen@nokia.com>
Cc: Matt Reimer <mreimer@vpop.net>
Cc: Miguel Aguilar <miguel.aguilar@ridgerun.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Peter Ujfalusi <peter.ujfalusi@nokia.com>
Cc: Philipp Zabel <philipp.zabel@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Richard Röjfors <richard.rojfors@pelagicore.com>
Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Wolfgang Grandegger <wg@grandegger.com>

---
Samuel Ortiz (19):
  mfd: Add platform data pointer back
  mfd: Use mfd cell platform_data for ab3550 cells platform bits
  mfd: Use mfd cell platform_data for ab3100 cells platform bits
  mmc: Use device platform_data to retrieve tmio_mmc platform bits
  w1: Use device platform_data to retrieve ds1wm platform bits
  mfd: Pass htc-pasic3 led platform data through the cell platform_data
  mfd: Use mfd cell platform_data for wl1273 cells platform bits
  fb: Use platform_data to retrieve tmiofb platform bits
  mtd: Use platform_data to retrieve tmio_nand platform bits
  mfd: Use mfd cell platform_data for timberdale cells platform bits
  mfd: Use mfd cell platform_data for rdc321x cells platform bits
  mfd: Use mfd cell platform_data for wm8400 cells platform bits
  mfd: Use mfd cell platform_data for mc13xxx cells platform bits
  mfd: Use mfd cell platform_data for janz cells platform bits
  mfd: Use mfd cell platform_data for twl4030 codec cells platform bits
  mfd: Use mfd cell platform_data for tps6105x cells platform bits
  mfd: Use mfd cell platform_data for 88pm860x cells platform bits
  mfd: Use mfd cell platform_data for davinci cells platform bits
  mfd: Remove mfd_data

 drivers/dma/timb_dma.c                 |    3 +-
 drivers/gpio/janz-ttl.c                |    3 +-
 drivers/gpio/rdc321x-gpio.c            |    3 +-
 drivers/gpio/timbgpio.c                |    6 +-
 drivers/i2c/busses/i2c-ocores.c        |    3 +-
 drivers/i2c/busses/i2c-xiic.c          |    3 +-
 drivers/input/misc/twl4030-vibra.c     |    3 +-
 drivers/leds/leds-88pm860x.c           |    7 +--
 drivers/leds/leds-mc13783.c            |    7 +--
 drivers/media/radio/radio-timb.c       |    3 +-
 drivers/media/radio/radio-wl1273.c     |    2 +-
 drivers/media/video/timblogiw.c        |    3 +-
 drivers/mfd/88pm860x-core.c            |   18 +++++--
 drivers/mfd/ab3100-core.c              |    6 ++-
 drivers/mfd/ab3550-core.c              |    6 ++-
 drivers/mfd/asic3.c                    |    6 ++-
 drivers/mfd/davinci_voicecodec.c       |    6 ++-
 drivers/mfd/htc-pasic3.c               |    5 ++-
 drivers/mfd/janz-cmodio.c              |    3 +-
 drivers/mfd/mc13xxx-core.c             |   12 +++--
 drivers/mfd/mfd-core.c                 |    7 +++
 drivers/mfd/rdc321x-southbridge.c      |    6 ++-
 drivers/mfd/t7l66xb.c                  |    6 ++-
 drivers/mfd/tc6387xb.c                 |    3 +-
 drivers/mfd/tc6393xb.c                 |   10 +++-
 drivers/mfd/timberdale.c               |   81 +++++++++++++++++++++-----------
 drivers/mfd/tps6105x.c                 |    3 +-
 drivers/mfd/twl4030-codec.c            |    6 ++-
 drivers/mfd/wl1273-core.c              |    6 ++-
 drivers/mfd/wm8400-core.c              |    3 +-
 drivers/mmc/host/tmio_mmc.c            |    2 +-
 drivers/mtd/nand/tmio_nand.c           |    2 +-
 drivers/net/can/janz-ican3.c           |    3 +-
 drivers/net/ks8842.c                   |    3 +-
 drivers/regulator/88pm8607.c           |    7 +--
 drivers/regulator/ab3100.c             |    3 +-
 drivers/regulator/mc13783-regulator.c  |    7 ++-
 drivers/regulator/mc13892-regulator.c  |    7 ++-
 drivers/regulator/tps6105x-regulator.c |    4 +-
 drivers/spi/xilinx_spi.c               |    3 +-
 drivers/video/backlight/88pm860x_bl.c  |    7 +--
 drivers/video/tmiofb.c                 |   12 ++---
 drivers/w1/masters/ds1wm.c             |   12 ++++-
 drivers/watchdog/rdc321x_wdt.c         |    3 +-
 include/linux/mfd/abx500.h             |    1 +
 include/linux/mfd/core.h               |   23 +--------
 sound/soc/codecs/cq93vc.c              |    3 +-
 sound/soc/codecs/twl4030.c             |    6 +--
 sound/soc/codecs/wl1273.c              |    3 +-
 sound/soc/codecs/wm8400.c              |    2 +-
 sound/soc/davinci/davinci-vcif.c       |    2 +-
 51 files changed, 191 insertions(+), 163 deletions(-)

-- 
1.7.2.3

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
