Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab2LaFgK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 00:36:10 -0500
Received: from mga09.intel.com ([134.134.136.24]:21633 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011Ab2LaFgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 00:36:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,383,1355126400"; 
   d="scan'208";a="240502765"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org, Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] staging:iio:adis16260: select IIO_ADIS_LIB to fix build error
Date: Mon, 31 Dec 2012 13:36:35 +0800
Message-Id: <1356932195-31437-1-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9d5e9fdf turned the code to use adis library, so it depends on
adis lib. But it forgot to select it at Kconfig file. Thus if adis is
not enabled, it will produce following build errros(catched by Fengguang's
0-DAY kernel build testing system):
  ERROR: "adis_initial_startup" [drivers/staging/iio/gyro/adis16260.ko] undefined!
  ERROR: "adis_init" [drivers/staging/iio/gyro/adis16260.ko] undefined!
  ERROR: "adis_write_reg" [drivers/staging/iio/gyro/adis16260.ko] undefined!
  ERROR: "adis_read_reg" [drivers/staging/iio/gyro/adis16260.ko] undefined!
  ERROR: "adis_single_conversion" [drivers/staging/iio/gyro/adis16260.ko] undefined!

Selecting IIO_ADIS_LIB at Kconfig file fixes this issue.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 drivers/staging/iio/gyro/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/iio/gyro/Kconfig b/drivers/staging/iio/gyro/Kconfig
index ea295b2..476207a 100644
--- a/drivers/staging/iio/gyro/Kconfig
+++ b/drivers/staging/iio/gyro/Kconfig
@@ -27,6 +27,7 @@ config ADIS16130
 config ADIS16260
 	tristate "Analog Devices ADIS16260 Digital Gyroscope Sensor SPI driver"
 	depends on SPI
+	select IIO_ADIS_LIB
 	select IIO_TRIGGER if IIO_BUFFER
 	select IIO_SW_RING if IIO_BUFFER
 	help
-- 
1.7.7.6

