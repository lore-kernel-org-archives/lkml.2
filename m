Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614Ab2J0PDn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 11:03:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37370 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128Ab2J0PDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 11:03:39 -0400
Message-ID: <1351350210.10004.3.camel@phoenix>
Subject: [PATCH] iio: hid-sensor: Return proper error if kmemdup fails
From: Axel Lin <axel.lin@ingics.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: srinivas pandruvada <srinivas.pandruvada@intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 27 Oct 2012 23:03:30 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return -ENOMEM instead of 0 if kmemdup fails.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/iio/accel/hid-sensor-accel-3d.c       |    6 +++---
 drivers/iio/gyro/hid-sensor-gyro-3d.c         |    6 +++---
 drivers/iio/light/hid-sensor-als.c            |    5 ++---
 drivers/iio/magnetometer/hid-sensor-magn-3d.c |    6 +++---
 4 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/iio/accel/hid-sensor-accel-3d.c b/drivers/iio/accel/hid-sensor-accel-3d.c
index 1b49931..2046208 100644
--- a/drivers/iio/accel/hid-sensor-accel-3d.c
+++ b/drivers/iio/accel/hid-sensor-accel-3d.c
@@ -319,10 +319,10 @@ static int __devinit hid_accel_3d_probe(struct platform_device *pdev)
 		goto error_free_dev;
 	}
 
-	channels = kmemdup(accel_3d_channels,
-					sizeof(accel_3d_channels),
-					GFP_KERNEL);
+	channels = kmemdup(accel_3d_channels, sizeof(accel_3d_channels),
+			   GFP_KERNEL);
 	if (!channels) {
+		ret = -ENOMEM;
 		dev_err(&pdev->dev, "failed to duplicate channels\n");
 		goto error_free_dev;
 	}
diff --git a/drivers/iio/gyro/hid-sensor-gyro-3d.c b/drivers/iio/gyro/hid-sensor-gyro-3d.c
index 705dc49..c93dd59 100644
--- a/drivers/iio/gyro/hid-sensor-gyro-3d.c
+++ b/drivers/iio/gyro/hid-sensor-gyro-3d.c
@@ -319,10 +319,10 @@ static int __devinit hid_gyro_3d_probe(struct platform_device *pdev)
 		goto error_free_dev;
 	}
 
-	channels = kmemdup(gyro_3d_channels,
-					sizeof(gyro_3d_channels),
-					GFP_KERNEL);
+	channels = kmemdup(gyro_3d_channels, sizeof(gyro_3d_channels),
+			   GFP_KERNEL);
 	if (!channels) {
+		ret = -ENOMEM;
 		dev_err(&pdev->dev, "failed to duplicate channels\n");
 		goto error_free_dev;
 	}
diff --git a/drivers/iio/light/hid-sensor-als.c b/drivers/iio/light/hid-sensor-als.c
index 4c35ac7..ea59daa 100644
--- a/drivers/iio/light/hid-sensor-als.c
+++ b/drivers/iio/light/hid-sensor-als.c
@@ -285,10 +285,9 @@ static int __devinit hid_als_probe(struct platform_device *pdev)
 		goto error_free_dev;
 	}
 
-	channels = kmemdup(als_channels,
-					sizeof(als_channels),
-					GFP_KERNEL);
+	channels = kmemdup(als_channels, sizeof(als_channels), GFP_KERNEL);
 	if (!channels) {
+		ret = -ENOMEM;
 		dev_err(&pdev->dev, "failed to duplicate channels\n");
 		goto error_free_dev;
 	}
diff --git a/drivers/iio/magnetometer/hid-sensor-magn-3d.c b/drivers/iio/magnetometer/hid-sensor-magn-3d.c
index a02dc98..63d0a38 100644
--- a/drivers/iio/magnetometer/hid-sensor-magn-3d.c
+++ b/drivers/iio/magnetometer/hid-sensor-magn-3d.c
@@ -320,10 +320,10 @@ static int __devinit hid_magn_3d_probe(struct platform_device *pdev)
 		goto error_free_dev;
 	}
 
-	channels = kmemdup(magn_3d_channels,
-					sizeof(magn_3d_channels),
-					GFP_KERNEL);
+	channels = kmemdup(magn_3d_channels, sizeof(magn_3d_channels),
+			   GFP_KERNEL);
 	if (!channels) {
+		ret = -ENOMEM;
 		dev_err(&pdev->dev, "failed to duplicate channels\n");
 		goto error_free_dev;
 	}
-- 
1.7.9.5



