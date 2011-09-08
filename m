Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933025Ab1IHOBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 10:01:15 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:50797 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932874Ab1IHOBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 10:01:13 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org, Michael.Hennerich@analog.com,
        linux-iio@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [RFC PATCH 0/2 V2] Using regmap with ADIS devices.
Date: Thu,  8 Sep 2011 15:09:22 +0100
Message-Id: <1315490964-25718-1-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

I've tried your suggestion of doing things at the marshalling level
and would be interested to hear what you think of the result.

Note these patches are not clean yet hence no sign offs.

The tricky bit was triggering the two separate writes per register
and the result is somewhat hacky.

An alternative there would be to add some configuration options to
the spi_write (or allow a couple of varients) so as to break the
long transfer that would generate up and hence bounce the cs line
in the right place.  Gah. SPI can be so uggly sometimes.

If this approach isn't acceptable in principle I'll give up and
conclude that these parts will never play well! (which is fine
by me if true).

Jonathan

Jonathan Cameron (2):
  regmap: Support half writes and padding between register and value.
  staging:iio:imu:adis16400 regmap introduction.

 drivers/base/regmap/internal.h           |    1 +
 drivers/base/regmap/regmap.c             |   42 ++++-
 drivers/staging/iio/imu/Kconfig          |    1 +
 drivers/staging/iio/imu/adis16400.h      |    2 +
 drivers/staging/iio/imu/adis16400_core.c |  301 +++++++++++++++++++-----------
 include/linux/regmap.h                   |    6 +
 6 files changed, 234 insertions(+), 119 deletions(-)

-- 
1.7.3.4

