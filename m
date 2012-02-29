Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab2B2UFD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 15:05:03 -0500
Received: from csmtp3.one.com ([91.198.169.23]:19010 "EHLO csmtp3.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553Ab2B2UFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 15:05:00 -0500
From: Eric Andersson <eric.andersson@unixphere.com>
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, gregkh@linuxfoundation.org, christoph.mair@gmail.com,
        stefan.nilsson@unixphere.com, zhengguang.guo@bosch-sensortec.com,
        peter.moeller@cn.bosch.com,
        Eric Andersson <eric.andersson@unixphere.com>
Subject: [PATCH 0/3] Replace bmp085 with bmp18x
Date: Wed, 29 Feb 2012 20:58:06 +0100
Message-Id: <1330545489-31169-1-git-send-email-eric.andersson@unixphere.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch-set replaces the BMP085 driver with a driver for Bosch Sensortec's new
generation of pressure sensors called BMP18x. These pressure sensors can be
connected on I2C but also on SPI as a variant, so the driver implements both.
Register-wise they are fully compatible with the older BMP085, so the driver will
support those chips as well.

The driver is based on bmp085.c by Christoph Mair.

--
Best regards,
 Eric
  
  http://www.unixphere.com

Eric Andersson (3):
  drivers/misc: add support for BMP18x pressure sensors
  Documentation: add sysfs ABI documentation for bmp18x
  drivers/misc: remove bmp085 driver

 Documentation/ABI/testing/sysfs-i2c-bmp085 |   31 --
 Documentation/ABI/testing/sysfs-i2c-bmp18x |   31 ++
 Documentation/ABI/testing/sysfs-spi-bmp18x |   31 ++
 drivers/misc/Kconfig                       |   40 ++-
 drivers/misc/Makefile                      |    4 +-
 drivers/misc/bmp085.c                      |  483 ---------------------------
 drivers/misc/bmp18x-core.c                 |  500 ++++++++++++++++++++++++++++
 drivers/misc/bmp18x-i2c.c                  |  121 +++++++
 drivers/misc/bmp18x-spi.c                  |  143 ++++++++
 include/linux/i2c/bmp18x.h                 |   65 ++++
 10 files changed, 924 insertions(+), 525 deletions(-)
 delete mode 100644 Documentation/ABI/testing/sysfs-i2c-bmp085
 create mode 100644 Documentation/ABI/testing/sysfs-i2c-bmp18x
 create mode 100644 Documentation/ABI/testing/sysfs-spi-bmp18x
 delete mode 100644 drivers/misc/bmp085.c
 create mode 100644 drivers/misc/bmp18x-core.c
 create mode 100644 drivers/misc/bmp18x-i2c.c
 create mode 100644 drivers/misc/bmp18x-spi.c
 create mode 100644 include/linux/i2c/bmp18x.h

-- 
1.7.3.4

