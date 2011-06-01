Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161235Ab1FALSe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 07:18:34 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58250 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161174Ab1FALSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 07:18:31 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [PATCH 0/8] MFD/ASoC: TWL4030/TWL6040 changes
Date: Wed, 1 Jun 2011 14:17:23 +0300
Message-ID: <1306927051-8937-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.5.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The series will do three major things, and they are in one series, because they
pretty much depending on each other, so it is easier to handle them together.

1. Rename the twl4030-codec MFD driver to twl4030-audio
Since the ASoC multicomponent introduction (2.6.37) the twl4030-codec MFD dirver
had been using twl4030-audio to register (twl4030-codec is the ASoC codec
driver). The documentation refers to this part of twl as audio block, so it is
better to rename the driver as well to avoid confusion.

2. Introduction of MFD driver for twl6040.
The TWL6040 audio IC has codec and vibra functionality.
Convert the existing ASoC codec driver to use the new MFD driver's interface.

3. Vibrator driver for TWL6040 (Input/ForceFeedback driver)
The driver itself, and support for the vibrators in SDP4430 board.

The series has been tested on top of merged omap-next, asoc-next, and mfd-next.
It applies on top of linux-next as well.

Regards,
Peter

---
Misael Lopez Cruz (3):
  mfd: twl6040: Add initial support
  ASoC: twl6040: Convert into TWL6040 MFD child
  input: Add initial support for TWL6040 vibrator

Peter Ujfalusi (5):
  MFD: twl4030-codec: Rename internals from codec to audio
  MFD: twl4030-codec -> twl4030-audio: Rename the driver
  MFD: twl4030-audio: Rename platform data
  MFD: twl6040: Change platform data for soc codec driver
  OMAP4: SDP4430: Add twl6040 vibrator platform support

 arch/arm/mach-omap2/board-3430sdp.c          |    8 +-
 arch/arm/mach-omap2/board-4430sdp.c          |   50 +++-
 arch/arm/mach-omap2/board-devkit8000.c       |    8 +-
 arch/arm/mach-omap2/board-igep0020.c         |    8 +-
 arch/arm/mach-omap2/board-omap3beagle.c      |    8 +-
 arch/arm/mach-omap2/board-omap3evm.c         |    8 +-
 arch/arm/mach-omap2/board-omap3pandora.c     |    8 +-
 arch/arm/mach-omap2/board-omap3stalker.c     |    8 +-
 arch/arm/mach-omap2/board-omap3touchbook.c   |    8 +-
 arch/arm/mach-omap2/board-overo.c            |    8 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c |    6 +-
 arch/arm/mach-omap2/board-zoom-peripherals.c |   14 +-
 arch/arm/plat-omap/include/plat/irqs.h       |   12 +-
 drivers/input/misc/Kconfig                   |   13 +-
 drivers/input/misc/Makefile                  |    1 +
 drivers/input/misc/twl4030-vibra.c           |   12 +-
 drivers/input/misc/twl6040-vibra.c           |  428 +++++++++++++++++++
 drivers/mfd/Kconfig                          |    8 +-
 drivers/mfd/Makefile                         |    3 +-
 drivers/mfd/twl-core.c                       |   13 +-
 drivers/mfd/twl4030-audio.c                  |  278 ++++++++++++
 drivers/mfd/twl4030-codec.c                  |  277 ------------
 drivers/mfd/twl6040-core.c                   |  588 ++++++++++++++++++++++++++
 drivers/mfd/twl6040-irq.c                    |  205 +++++++++
 include/linux/i2c/twl.h                      |   21 +-
 include/linux/mfd/twl4030-audio.h            |  272 ++++++++++++
 include/linux/mfd/twl4030-codec.h            |  272 ------------
 include/linux/mfd/twl6040.h                  |  260 ++++++++++++
 sound/soc/codecs/Kconfig                     |    3 +-
 sound/soc/codecs/twl4030.c                   |   22 +-
 sound/soc/codecs/twl6040.c                   |  426 ++++---------------
 sound/soc/codecs/twl6040.h                   |  118 -----
 sound/soc/omap/sdp3430.c                     |    2 +-
 sound/soc/omap/sdp4430.c                     |    2 +
 sound/soc/omap/zoom2.c                       |    2 +-
 35 files changed, 2290 insertions(+), 1090 deletions(-)
 create mode 100644 drivers/input/misc/twl6040-vibra.c
 create mode 100644 drivers/mfd/twl4030-audio.c
 delete mode 100644 drivers/mfd/twl4030-codec.c
 create mode 100644 drivers/mfd/twl6040-core.c
 create mode 100644 drivers/mfd/twl6040-irq.c
 create mode 100644 include/linux/mfd/twl4030-audio.h
 delete mode 100644 include/linux/mfd/twl4030-codec.h
 create mode 100644 include/linux/mfd/twl6040.h

-- 
1.7.5.3

