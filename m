Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab1IGQLq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:11:46 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:48693 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab1IGQLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:11:43 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org, Michael.Hennerich@analog.com,
        linux-iio@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [RFC PATCH 0/6] Using regmap with ADIS devices.
Date: Wed,  7 Sep 2011 17:19:41 +0100
Message-Id: <1315412387-5765-1-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <4E679770.4090008@cam.ac.uk>
References: <4E679770.4090008@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aim - allow all the advantages of regmap to work with the 'unusual'
spi interfaces of Analog Devices ADIS parts.

Missing - means of feeding results of burst reads back into regmap.

The spi change clearly needs to be circulated much more widely.
I'll do that at a later date.

It 'might' be possible to make regmap understand the non symmetric
nature of these registers (reads are 16 bit, writes 8 ;) but I
couldn't really see how to do it cleanly - hence this proposal.

Anyhow, read and poke fun at it.  It's not even vaguely cleaned up.
I want to get suggestions on how to do it better before I waste time
on doing that.

To sumarise main trick.  Treat all registers as 16 bit and mess
with the register addresses in the write function to get it
to split them in two.

Note I've halved all register addresses in the driver as that will
work better for caching in regmap at a later date.

Jonathan



Jonathan Cameron (6):
  SPI: add ability to say we want a cs change after every transfer.
  regmap: Add a magic bus type to handle quirks of analog devices ADIS
    sensors.
  staging:iio:imu: adis16400 partial conversion to regmap.
  regmap-spi-adi + staging:iio:imu:adis16400 halve register addresses
  regmap-spi-adi generalize regmap_spi_read.
  staging:iio:imu:adis16400 make use of regmap bulk read capabilities

 drivers/base/regmap/Kconfig              |    5 +-
 drivers/base/regmap/Makefile             |    1 +
 drivers/base/regmap/regmap-spi-adi.c     |   93 +++++++++
 drivers/spi/spi.c                        |    8 +
 drivers/staging/iio/imu/Kconfig          |    1 +
 drivers/staging/iio/imu/adis16400.h      |  100 +++++-----
 drivers/staging/iio/imu/adis16400_core.c |  300 ++++++++++++++++++-----------
 drivers/staging/iio/imu/adis16400_ring.c |   69 ++------
 include/linux/regmap.h                   |    2 +
 include/linux/spi/spi.h                  |    2 +
 10 files changed, 360 insertions(+), 221 deletions(-)
 create mode 100644 drivers/base/regmap/regmap-spi-adi.c

-- 
1.7.3.4

