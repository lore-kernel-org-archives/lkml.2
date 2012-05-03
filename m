Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab2ECK1B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 06:27:01 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:44447 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755404Ab2ECK05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 06:26:57 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Rob Landley <rob@landley.net>, Richard Purdie <rpurdie@rpsys.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-fbdev@vger.kernel.org, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH v2 0/4] mfd: add LM3533 lighting-power chip driver
Date: Thu,  3 May 2012 12:26:35 +0200
Message-Id: <1336040799-18433-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.8.5
In-Reply-To: <1334935826-12527-1-git-send-email-jhovold@gmail.com>
References: <1334935826-12527-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches (against v3.4-rc5) add support for the National Semiconductor /
Texas Instruments LM3533 lighting-power chip.

This multi-function device has four LEDs, two backlights and an
ambient-light-sensor interface.

The LEDs and backlights can be controlled directly, through PWM input,
or by the ambient-light-sensor interface. Hardware-accelerated blinking is
provided for the LEDs.

ALS control is done through defining five light zones and three sets of
corresponding brightness target levels. The ALS iio-driver provides raw and
mean adc readings along with the current light zone through sysfs. A threshold
event can be generated on zone changes.

Further details and specifications are now available from:

        http://www.ti.com/product/lm3533

Changes since v1 includes a rewrite of the ambient-light-sensor driver against
iio, the addition of sysfs-ABI documentation, and a switch to regmap for
register io.

This work has been done on behalf of National Semiconductor / Texas
Instruments.

Thanks,
Johan


Johan Hovold (4):
  mfd: add LM3533 lighting-power core driver
  iio: add LM3533 ambient light sensor driver
  leds: add LM3533 LED driver
  backlight: add LM3533 backlight driver

 .../ABI/testing/sysfs-bus-i2c-devices-lm3533       |   38 +
 .../testing/sysfs-class-backlight-driver-lm3533    |   50 ++
 .../ABI/testing/sysfs-class-led-driver-lm3533      |   67 ++
 drivers/leds/Kconfig                               |   13 +
 drivers/leds/Makefile                              |    1 +
 drivers/leds/leds-lm3533.c                         |  741 ++++++++++++++++++++
 drivers/mfd/Kconfig                                |   13 +
 drivers/mfd/Makefile                               |    1 +
 drivers/mfd/lm3533-core.c                          |  717 +++++++++++++++++++
 drivers/mfd/lm3533-ctrlbank.c                      |  134 ++++
 .../Documentation/sysfs-bus-iio-light-lm3533-als   |   62 ++
 drivers/staging/iio/light/Kconfig                  |   16 +
 drivers/staging/iio/light/Makefile                 |    1 +
 drivers/staging/iio/light/lm3533-als.c             |  617 ++++++++++++++++
 drivers/video/backlight/Kconfig                    |   12 +
 drivers/video/backlight/Makefile                   |    1 +
 drivers/video/backlight/lm3533_bl.c                |  458 ++++++++++++
 include/linux/mfd/lm3533.h                         |   89 +++
 18 files changed, 3031 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-i2c-devices-lm3533
 create mode 100644 Documentation/ABI/testing/sysfs-class-backlight-driver-lm3533
 create mode 100644 Documentation/ABI/testing/sysfs-class-led-driver-lm3533
 create mode 100644 drivers/leds/leds-lm3533.c
 create mode 100644 drivers/mfd/lm3533-core.c
 create mode 100644 drivers/mfd/lm3533-ctrlbank.c
 create mode 100644 drivers/staging/iio/Documentation/sysfs-bus-iio-light-lm3533-als
 create mode 100644 drivers/staging/iio/light/lm3533-als.c
 create mode 100644 drivers/video/backlight/lm3533_bl.c
 create mode 100644 include/linux/mfd/lm3533.h

-- 
1.7.8.5

