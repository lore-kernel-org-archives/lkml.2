Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab2J0Os4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 10:48:56 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:34212 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab2J0Osw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 10:48:52 -0400
Message-ID: <1351349317.10004.1.camel@phoenix>
Subject: [PATCH] iio: hid-sensor: Use __devexit annotation for remove()
From: Axel Lin <axel.lin@ingics.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: srinivas pandruvada <srinivas.pandruvada@intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 27 Oct 2012 22:48:37 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use __devexit rather than __devinit annotation for remove().
Also adds __devexit_p around remove callback.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/iio/accel/hid-sensor-accel-3d.c       |    4 ++--
 drivers/iio/gyro/hid-sensor-gyro-3d.c         |    4 ++--
 drivers/iio/light/hid-sensor-als.c            |    4 ++--
 drivers/iio/magnetometer/hid-sensor-magn-3d.c |    4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/iio/accel/hid-sensor-accel-3d.c b/drivers/iio/accel/hid-sensor-accel-3d.c
index 314a405..1b49931 100644
--- a/drivers/iio/accel/hid-sensor-accel-3d.c
+++ b/drivers/iio/accel/hid-sensor-accel-3d.c
@@ -388,7 +388,7 @@ error_ret:
 }
 
 /* Function to deinitialize the processing for usage id */
-static int __devinit hid_accel_3d_remove(struct platform_device *pdev)
+static int __devexit hid_accel_3d_remove(struct platform_device *pdev)
 {
 	struct hid_sensor_hub_device *hsdev = pdev->dev.platform_data;
 	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
@@ -409,7 +409,7 @@ static struct platform_driver hid_accel_3d_platform_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe		= hid_accel_3d_probe,
-	.remove		= hid_accel_3d_remove,
+	.remove		= __devexit_p(hid_accel_3d_remove),
 };
 module_platform_driver(hid_accel_3d_platform_driver);
 
diff --git a/drivers/iio/gyro/hid-sensor-gyro-3d.c b/drivers/iio/gyro/hid-sensor-gyro-3d.c
index 4c56ada..705dc49 100644
--- a/drivers/iio/gyro/hid-sensor-gyro-3d.c
+++ b/drivers/iio/gyro/hid-sensor-gyro-3d.c
@@ -388,7 +388,7 @@ error_ret:
 }
 
 /* Function to deinitialize the processing for usage id */
-static int __devinit hid_gyro_3d_remove(struct platform_device *pdev)
+static int __devexit hid_gyro_3d_remove(struct platform_device *pdev)
 {
 	struct hid_sensor_hub_device *hsdev = pdev->dev.platform_data;
 	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
@@ -409,7 +409,7 @@ static struct platform_driver hid_gyro_3d_platform_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe		= hid_gyro_3d_probe,
-	.remove		= hid_gyro_3d_remove,
+	.remove		= __devexit_p(hid_gyro_3d_remove),
 };
 module_platform_driver(hid_gyro_3d_platform_driver);
 
diff --git a/drivers/iio/light/hid-sensor-als.c b/drivers/iio/light/hid-sensor-als.c
index 96e3691..4c35ac7 100644
--- a/drivers/iio/light/hid-sensor-als.c
+++ b/drivers/iio/light/hid-sensor-als.c
@@ -355,7 +355,7 @@ error_ret:
 }
 
 /* Function to deinitialize the processing for usage id */
-static int __devinit hid_als_remove(struct platform_device *pdev)
+static int __devexit hid_als_remove(struct platform_device *pdev)
 {
 	struct hid_sensor_hub_device *hsdev = pdev->dev.platform_data;
 	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
@@ -376,7 +376,7 @@ static struct platform_driver hid_als_platform_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe		= hid_als_probe,
-	.remove		= hid_als_remove,
+	.remove		= __devexit_p(hid_als_remove),
 };
 module_platform_driver(hid_als_platform_driver);
 
diff --git a/drivers/iio/magnetometer/hid-sensor-magn-3d.c b/drivers/iio/magnetometer/hid-sensor-magn-3d.c
index c4f0d27..a02dc98 100644
--- a/drivers/iio/magnetometer/hid-sensor-magn-3d.c
+++ b/drivers/iio/magnetometer/hid-sensor-magn-3d.c
@@ -389,7 +389,7 @@ error_ret:
 }
 
 /* Function to deinitialize the processing for usage id */
-static int __devinit hid_magn_3d_remove(struct platform_device *pdev)
+static int __devexit hid_magn_3d_remove(struct platform_device *pdev)
 {
 	struct hid_sensor_hub_device *hsdev = pdev->dev.platform_data;
 	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
@@ -410,7 +410,7 @@ static struct platform_driver hid_magn_3d_platform_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe		= hid_magn_3d_probe,
-	.remove		= hid_magn_3d_remove,
+	.remove		= __devexit_p(hid_magn_3d_remove),
 };
 module_platform_driver(hid_magn_3d_platform_driver);
 
-- 
1.7.9.5



