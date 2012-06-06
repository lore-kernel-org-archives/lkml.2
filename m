Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598Ab2FFVTk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 17:19:40 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38091 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab2FFVTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 17:19:38 -0400
From: Leed Aguilar <leed.aguilar@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <leed.aguilar@ti.com>,
        <linux-iio@vger.kernel.org>
Subject: [PATCH 2/3] staging:iio:magnetometer:ak8975: use gpio_request_one api
Date: Wed, 6 Jun 2012 16:15:40 -0400
Message-ID: <1339013740-15465-1-git-send-email-leed.aguilar@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use gpio_request_one api, it looks cleaner.

Signed-off-by: Leed Aguilar <leed.aguilar@ti.com>
Acked-by: Jonathan Cameron <jic23@kernel.org>
---
 drivers/staging/iio/magnetometer/Kconfig  |    2 +-
 drivers/staging/iio/magnetometer/ak8975.c |   10 +---------
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/iio/magnetometer/Kconfig b/drivers/staging/iio/magnetometer/Kconfig
index b9d9325..df5e0d4 100644
--- a/drivers/staging/iio/magnetometer/Kconfig
+++ b/drivers/staging/iio/magnetometer/Kconfig
@@ -6,7 +6,7 @@ menu "Magnetometer sensors"
 config SENSORS_AK8975
 	tristate "Asahi Kasei AK8975 3-Axis Magnetometer"
 	depends on I2C
-	depends on GENERIC_GPIO
+	depends on GPIOLIB
 	help
 	  Say yes here to build support for Asahi Kasei AK8975 3-Axis
 	  Magnetometer.
diff --git a/drivers/staging/iio/magnetometer/ak8975.c b/drivers/staging/iio/magnetometer/ak8975.c
index 001b3bf..11bde3f 100644
--- a/drivers/staging/iio/magnetometer/ak8975.c
+++ b/drivers/staging/iio/magnetometer/ak8975.c
@@ -499,21 +499,13 @@ static int __devinit ak8975_probe(struct i2c_client *client,
 	/* We may not have a GPIO based IRQ to scan, that is fine, we will
 	   poll if so */
 	if (gpio_is_valid(eoc_gpio)) {
-		err = gpio_request(eoc_gpio, "ak_8975");
+		err = gpio_request_one(eoc_gpio, GPIOF_IN, "ak_8975");
 		if (err < 0) {
 			dev_err(&client->dev,
 				"failed to request GPIO %d, error %d\n",
 							eoc_gpio, err);
 			goto exit;
 		}
-
-		err = gpio_direction_input(eoc_gpio);
-		if (err < 0) {
-			dev_err(&client->dev,
-				"Failed to configure input direction for GPIO %d, error %d\n",
-						eoc_gpio, err);
-			goto exit_gpio;
-		}
 	}
 
 	/* Register with IIO */
-- 
1.7.1

