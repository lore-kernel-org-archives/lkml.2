Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370Ab2DTPa7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 11:30:59 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:38768 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756383Ab2DTPa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 11:30:57 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Richard Purdie <rpurdie@rpsys.net>, Samuel Ortiz <sameo@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 0/4] mfd: add LM3533 lighting-power chip driver
Date: Fri, 20 Apr 2012 17:30:22 +0200
Message-Id: <1334935826-12527-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.8.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches (against v3.4-rc3) add support for the National Semiconductor /
Texas Instruments LM3533 lighting-power chip.

This multi-function device has four LEDs, two backlights and an ambient-light
sensor.

The LEDs and backlights can be controlled directly, through PWM input,
or by the on-chip ambient light sensor. Hardware-accelerated blinking is
provided for the LEDs.

ALS control is done through defining five light zones and three sets of
corresponding brightness target levels. The ALS driver presents a character
device (/dev/lm3533-als) which can be used to retrieve the current light zone
or to poll for zone changes.

Further details and specifications will soon be available from

	http://www.ti.com/product/lm3533

This work has been done on behalf of National Semiconductor / Texas
Instruments.

Thanks,
Johan


Johan Hovold (4):
  mfd: add LM3533 lighting-power core driver
  misc: add LM3533 ambient light sensor driver
  leds: add LM3533 LED driver
  backlight: add LM3533 backlight driver

 drivers/leds/Kconfig                |   13 +
 drivers/leds/Makefile               |    1 +
 drivers/leds/leds-lm3533.c          |  713 +++++++++++++++++++++++++++++++++
 drivers/mfd/Kconfig                 |   12 +
 drivers/mfd/Makefile                |    3 +
 drivers/mfd/lm3533-core.c           |  738 +++++++++++++++++++++++++++++++++++
 drivers/mfd/lm3533-ctrlbank.c       |  134 +++++++
 drivers/mfd/lm3533-i2c.c            |  115 ++++++
 drivers/misc/Kconfig                |   13 +
 drivers/misc/Makefile               |    1 +
 drivers/misc/lm3533-als.c           |  662 +++++++++++++++++++++++++++++++
 drivers/video/backlight/Kconfig     |   12 +
 drivers/video/backlight/Makefile    |    1 +
 drivers/video/backlight/lm3533_bl.c |  432 ++++++++++++++++++++
 include/linux/mfd/lm3533.h          |  106 +++++
 15 files changed, 2956 insertions(+), 0 deletions(-)
 create mode 100644 drivers/leds/leds-lm3533.c
 create mode 100644 drivers/mfd/lm3533-core.c
 create mode 100644 drivers/mfd/lm3533-ctrlbank.c
 create mode 100644 drivers/mfd/lm3533-i2c.c
 create mode 100644 drivers/misc/lm3533-als.c
 create mode 100644 drivers/video/backlight/lm3533_bl.c
 create mode 100644 include/linux/mfd/lm3533.h

-- 
1.7.8.5

