Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538Ab2BNLDe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 06:03:34 -0500
Received: from skyrme.org ([193.175.80.135]:34709 "EHLO skyrme.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442Ab2BNLDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 06:03:31 -0500
X-Greylist: delayed 1734 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Feb 2012 06:03:31 EST
Date: 14 Feb 2012 10:34:25 +0000
Message-Id: <1329215672-15706-1-git-send-email-oskar@scara.com>
From: "Oskar Schirmer" <oskar@scara.com>
To: sameo@linux.intel.com
Cc: dmitry.torokhov@gmail.com, kernel@pengutronix.de,
        u.kleine-koenig@pengutronix.de, philippe.retornaz@epfl.ch,
        michael.thalmeier@hale.at, linux-kernel@vger.kernel.org,
        "Oskar Schirmer" <oskar@scara.com>
Subject: [PATCH 0/7] add support for mc13892 I2C based touch panel for mx35_3ds
X-Mailer: git-send-email 1.6.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mc13xxx touch panel support is limited to SPI based solutions
and to mc13783 based systems when it is about touch panel.

Add both I2C support to the mfd mc13xxx-core driver
and mc13892 specific support to the mc13xxx touch driver,
including calibration support for the latter.

Insert declarations needed for use with mx35_3ds development board.

Oskar Schirmer (7):
  mfd: move mc13xxx global declarations to header file
  mfd: split off mc13xxx SPI specifica from core
  mfd: add I2C handling to mc13xxx driver
  input/touchscreen: rename mc13783_ts.c
  input/touchscreen: add support for mc13892
  input/touchscreen: add calibration functionality with mc13xxx series
  arm/imx: add mc13892 I2C based touch panel support for mx35_3ds

 arch/arm/mach-imx/mach-mx35_3ds.c      |   27 ++
 drivers/input/touchscreen/Kconfig      |   11 +-
 drivers/input/touchscreen/Makefile     |    2 +-
 drivers/input/touchscreen/mc13783_ts.c |  259 -------------------
 drivers/input/touchscreen/mc13xxx_ts.c |  428 ++++++++++++++++++++++++++++++++
 drivers/mfd/Kconfig                    |   23 ++-
 drivers/mfd/Makefile                   |    2 +
 drivers/mfd/mc13xxx-core.c             |  183 ++------------
 drivers/mfd/mc13xxx-i2c.c              |  149 +++++++++++
 drivers/mfd/mc13xxx-spi.c              |  172 +++++++++++++
 include/linux/mfd/mc13xxx.h            |   77 ++++--
 11 files changed, 882 insertions(+), 451 deletions(-)
 delete mode 100644 drivers/input/touchscreen/mc13783_ts.c
 create mode 100644 drivers/input/touchscreen/mc13xxx_ts.c
 create mode 100644 drivers/mfd/mc13xxx-i2c.c
 create mode 100644 drivers/mfd/mc13xxx-spi.c

-- 
1.7.5.4

