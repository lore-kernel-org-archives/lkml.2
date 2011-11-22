Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758402Ab1KVLdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 06:33:07 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39635 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab1KVLdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 06:33:04 -0500
From: Dave Martin <dave.martin@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: patches@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Alan Cox <alan@linux.intel.com>,
        Alessandro Rubini <rubini@unipv.it>,
        Alessandro Zummo <a.zummo@towertech.it>, alsa-devel@alsa-project.org,
        Chris Ball <cjb@laptop.org>, Dan Williams <dan.j.williams@intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Jaroslav Kysela <perex@perex.cz>,
        Jassi Brar <jassisinghbrar@gmail.com>, Julia Lawall <julia@diku.dk>,
        Linus Walleij <linus.walleij@linaro.org>, linux-fbdev@vger.kernel.org,
        linux-input@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>,
        =?UTF-8?q?Pawe=C5=82=20Moll?= <Pawel.Moll@arm.com>,
        rtc-linux@googlegroups.com, spi-devel-general@lists.sourceforge.net,
        Takashi Iwai <tiwai@suse.de>, Vinod Koul <vinod.koul@intel.com>,
        Wim Van Sebroeck <wim@iguana.be>
Subject: [GIT PULL] ARM: amba: Enable module alias autogeneration for AMBA drivers
Date: Tue, 22 Nov 2011 11:32:53 +0000
Message-Id: <1321961573-4562-1-git-send-email-dave.martin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

This series enables the general infrastructure for modalias
generation to work for AMBA devices, and enables it in the affected
drivers.

Since there are several patches here, I though it better to send a
pull request.

The first two patches (subject lines "ARM: amba: ...") are the core
patches; the remainder of the patches are the driver changes --
each is trivial and simply adds a MODULE_DEVICE_ALIAS() entry.

I have Acks on some of the driver patches and no comments on the
rest.  I've been circulating these for some time, so if you're
happy to pull those driver patches via your tree, please go ahead.

Otherwise, let me know and I can continue trying to push the driver
patches via other routes.

Cheers
---Dave

The following changes since commit cfcfc9eca2bcbd26a8e206baeb005b055dbf8e37:

  Linux 3.2-rc2 (2011-11-15 15:02:59 -0200)

are available in the git repository at:
  git://git.linaro.org/people/dmart/linux-2.6-arm.git arm/amba-modalias+for-rmk

Dave Martin (16):
      ARM: amba: Move definition of struct amba_id to mod_devicetable.h
      ARM: amba: Auto-generate AMBA driver module aliases during modpost
      hwrng: nomadik: Enable module alias autogeneration for AMBA drivers
      dmaengine: pl08x: Enable module alias autogeneration for AMBA drivers
      dmaengine: pl330: Enable module alias autogeneration for AMBA drivers
      gpio: pl061: Enable module alias autogeneration for AMBA drivers
      input: ambakmi: Enable module alias autogeneration for AMBA drivers
      mmc: mmci: Enable module alias autogeneration for AMBA drivers
      rtc: pl030: Enable module alias autogeneration for AMBA drivers
      rtc: pl031: Enable module alias autogeneration for AMBA drivers
      spi: pl022: Enable module alias autogeneration for AMBA drivers
      serial: pl010: Enable module alias autogeneration for AMBA drivers
      serial: pl011: Enable module alias autogeneration for AMBA drivers
      fbdev: amba: Enable module alias autogeneration for AMBA drivers
      watchdog: sp805: Enable module alias autogeneration for AMBA drivers
      sound: aaci: Enable module alias autogeneration for AMBA drivers

 drivers/amba/bus.c                   |    4 ++
 drivers/char/hw_random/nomadik-rng.c |    2 +
 drivers/dma/amba-pl08x.c             |    2 +
 drivers/dma/pl330.c                  |    2 +
 drivers/gpio/gpio-pl061.c            |    2 +
 drivers/input/serio/ambakmi.c        |    2 +
 drivers/mmc/host/mmci.c              |    2 +
 drivers/rtc/rtc-pl030.c              |    2 +
 drivers/rtc/rtc-pl031.c              |    2 +
 drivers/spi/spi-pl022.c              |    2 +
 drivers/tty/serial/amba-pl010.c      |    2 +
 drivers/tty/serial/amba-pl011.c      |    2 +
 drivers/video/amba-clcd.c            |    2 +
 drivers/watchdog/sp805_wdt.c         |    2 +
 include/linux/amba/bus.h             |    7 +---
 include/linux/mod_devicetable.h      |   18 ++++++++
 scripts/mod/file2alias.c             |   72 ++++++++++++++++++++++++++++++++++
 sound/arm/aaci.c                     |    2 +
 18 files changed, 123 insertions(+), 6 deletions(-)




