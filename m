Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751023Ab0I1Kf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 06:35:56 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:33443 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750814Ab0I1Kfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 06:35:55 -0400
From: Arun Murthy <arun.murthy@stericsson.com>
To: <lars@metafoo.de>, <akpm@linux-foundation.org>, <kernel@pengutronix.de>,
        <philipp.zabel@gmail.com>, <robert.jarzmik@free.fr>,
        <marek.vasut@gmail.com>, <eric.y.miao@gmail.com>, <rpurdie@rpsys.net>,
        <sameo@linux.intel.com>, <kgene.kim@samsung.com>,
        <linux-omap@vger.kernel.org>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-mips@linux-mips.org>, <arun.murthy@stericsson.com>,
        <STEricsson_nomadik_linux@list.st.com>
Subject: [PATCH 0/7] PWM core driver for pwm based led and backlight driver
Date: Tue, 28 Sep 2010 16:05:27 +0530
Message-ID: <1285670134-18063-1-git-send-email-arun.murthy@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The series of patch add a new pwm core driver.
Align the existing pwm drivers to make use of the pwm core driver.

Arun Murthy (7):
  pwm: Add pwm core driver
  backlight:pwm: add an element 'name' to platform data
  leds: pwm: add a new element 'name' to platform data
  pwm: Align existing pwm drivers with pwm-core driver
  platform: Update the pwm based led and backlight platform data
  pwm: move existing pwm driver to drivers/pwm
  pwm: Modify backlight and led Kconfig aligning to pwm core

 arch/arm/mach-pxa/cm-x300.c               |    1 +
 arch/arm/mach-pxa/colibri-pxa270-income.c |    1 +
 arch/arm/mach-pxa/ezx.c                   |    1 +
 arch/arm/mach-pxa/hx4700.c                |    1 +
 arch/arm/mach-pxa/lpd270.c                |    1 +
 arch/arm/mach-pxa/magician.c              |    1 +
 arch/arm/mach-pxa/mainstone.c             |    1 +
 arch/arm/mach-pxa/mioa701.c               |    1 +
 arch/arm/mach-pxa/palm27x.c               |    1 +
 arch/arm/mach-pxa/palmtc.c                |    1 +
 arch/arm/mach-pxa/palmte2.c               |    1 +
 arch/arm/mach-pxa/pcm990-baseboard.c      |    1 +
 arch/arm/mach-pxa/raumfeld.c              |    1 +
 arch/arm/mach-pxa/tavorevb.c              |    2 +
 arch/arm/mach-pxa/viper.c                 |    1 +
 arch/arm/mach-pxa/z2.c                    |    2 +
 arch/arm/mach-pxa/zylonite.c              |    1 +
 arch/arm/mach-s3c2410/mach-h1940.c        |    1 +
 arch/arm/mach-s3c2440/mach-rx1950.c       |    1 +
 arch/arm/mach-s3c64xx/mach-hmt.c          |    1 +
 arch/arm/mach-s3c64xx/mach-smartq.c       |    1 +
 arch/arm/plat-mxc/pwm.c                   |  166 +++++++++------------
 arch/arm/plat-pxa/pwm.c                   |  210 ++++++++++++--------------
 arch/arm/plat-samsung/pwm.c               |  235 +++++++++++++----------------
 arch/mips/jz4740/pwm.c                    |    2 +-
 drivers/Kconfig                           |    2 +
 drivers/Makefile                          |    1 +
 drivers/leds/Kconfig                      |    2 +-
 drivers/leds/leds-pwm.c                   |    4 +-
 drivers/mfd/Kconfig                       |    9 -
 drivers/mfd/Makefile                      |    1 -
 drivers/mfd/twl-core.c                    |   13 ++
 drivers/mfd/twl6030-pwm.c                 |  163 --------------------
 drivers/misc/Kconfig                      |    9 -
 drivers/misc/Makefile                     |    1 -
 drivers/misc/ab8500-pwm.c                 |  168 --------------------
 drivers/pwm/Kconfig                       |   33 ++++
 drivers/pwm/Makefile                      |    4 +
 drivers/pwm/pwm-ab8500.c                  |  157 +++++++++++++++++++
 drivers/pwm/pwm-core.c                    |  124 +++++++++++++++
 drivers/pwm/pwm-twl6040.c                 |  196 ++++++++++++++++++++++++
 drivers/video/backlight/Kconfig           |    2 +-
 drivers/video/backlight/pwm_bl.c          |    4 +-
 include/linux/leds_pwm.h                  |    1 +
 include/linux/pwm.h                       |   29 ++++-
 include/linux/pwm_backlight.h             |    1 +
 46 files changed, 864 insertions(+), 696 deletions(-)
 delete mode 100644 drivers/mfd/twl6030-pwm.c
 delete mode 100644 drivers/misc/ab8500-pwm.c
 create mode 100644 drivers/pwm/Kconfig
 create mode 100644 drivers/pwm/Makefile
 create mode 100644 drivers/pwm/pwm-ab8500.c
 create mode 100644 drivers/pwm/pwm-core.c
 create mode 100644 drivers/pwm/pwm-twl6040.c

-- 
1.7.2.dirty

