Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236Ab1HUXAZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 19:00:25 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:53134 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932077Ab1HUXAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 19:00:20 -0400
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Brian Johnson <brijohn@gmail.com>,
        Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 12/14] [media] sn9c20x: Use current logging styles
Date: Sun, 21 Aug 2011 15:56:55 -0700
Message-Id: <62b98305a16ffb76696945c05732d16f68a9c68f.1313966090.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1313966088.git.joe@perches.com>
References: <cover.1313966088.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pr_fmt.
Convert usb style logging macros to pr_<level>.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/video/gspca/sn9c20x.c |   74 ++++++++++++++++++-----------------
 1 files changed, 38 insertions(+), 36 deletions(-)

diff --git a/drivers/media/video/gspca/sn9c20x.c b/drivers/media/video/gspca/sn9c20x.c
index c431900..9b3a052 100644
--- a/drivers/media/video/gspca/sn9c20x.c
+++ b/drivers/media/video/gspca/sn9c20x.c
@@ -18,6 +18,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/input.h>
 
 #include "gspca.h"
@@ -1123,7 +1125,7 @@ static int reg_r(struct gspca_dev *gspca_dev, u16 reg, u16 length)
 			length,
 			500);
 	if (unlikely(result < 0 || result != length)) {
-		err("Read register failed 0x%02X", reg);
+		pr_err("Read register failed 0x%02X\n", reg);
 		return -EIO;
 	}
 	return 0;
@@ -1144,7 +1146,7 @@ static int reg_w(struct gspca_dev *gspca_dev, u16 reg,
 			length,
 			500);
 	if (unlikely(result < 0 || result != length)) {
-		err("Write register failed index 0x%02X", reg);
+		pr_err("Write register failed index 0x%02X\n", reg);
 		return -EIO;
 	}
 	return 0;
@@ -1275,14 +1277,14 @@ static int ov9650_init_sensor(struct gspca_dev *gspca_dev)
 		return -EINVAL;
 
 	if (id != 0x7fa2) {
-		err("sensor id for ov9650 doesn't match (0x%04x)", id);
+		pr_err("sensor id for ov9650 doesn't match (0x%04x)\n", id);
 		return -ENODEV;
 	}
 
 	for (i = 0; i < ARRAY_SIZE(ov9650_init); i++) {
 		if (i2c_w1(gspca_dev, ov9650_init[i].reg,
 				ov9650_init[i].val) < 0) {
-			err("OV9650 sensor initialization failed");
+			pr_err("OV9650 sensor initialization failed\n");
 			return -ENODEV;
 		}
 	}
@@ -1299,7 +1301,7 @@ static int ov9655_init_sensor(struct gspca_dev *gspca_dev)
 	for (i = 0; i < ARRAY_SIZE(ov9655_init); i++) {
 		if (i2c_w1(gspca_dev, ov9655_init[i].reg,
 				ov9655_init[i].val) < 0) {
-			err("OV9655 sensor initialization failed");
+			pr_err("OV9655 sensor initialization failed\n");
 			return -ENODEV;
 		}
 	}
@@ -1318,7 +1320,7 @@ static int soi968_init_sensor(struct gspca_dev *gspca_dev)
 	for (i = 0; i < ARRAY_SIZE(soi968_init); i++) {
 		if (i2c_w1(gspca_dev, soi968_init[i].reg,
 				soi968_init[i].val) < 0) {
-			err("SOI968 sensor initialization failed");
+			pr_err("SOI968 sensor initialization failed\n");
 			return -ENODEV;
 		}
 	}
@@ -1338,7 +1340,7 @@ static int ov7660_init_sensor(struct gspca_dev *gspca_dev)
 	for (i = 0; i < ARRAY_SIZE(ov7660_init); i++) {
 		if (i2c_w1(gspca_dev, ov7660_init[i].reg,
 				ov7660_init[i].val) < 0) {
-			err("OV7660 sensor initialization failed");
+			pr_err("OV7660 sensor initialization failed\n");
 			return -ENODEV;
 		}
 	}
@@ -1355,7 +1357,7 @@ static int ov7670_init_sensor(struct gspca_dev *gspca_dev)
 	for (i = 0; i < ARRAY_SIZE(ov7670_init); i++) {
 		if (i2c_w1(gspca_dev, ov7670_init[i].reg,
 				ov7670_init[i].val) < 0) {
-			err("OV7670 sensor initialization failed");
+			pr_err("OV7670 sensor initialization failed\n");
 			return -ENODEV;
 		}
 	}
@@ -1379,14 +1381,14 @@ static int mt9v_init_sensor(struct gspca_dev *gspca_dev)
 		for (i = 0; i < ARRAY_SIZE(mt9v011_init); i++) {
 			if (i2c_w2(gspca_dev, mt9v011_init[i].reg,
 					mt9v011_init[i].val) < 0) {
-				err("MT9V011 sensor initialization failed");
+				pr_err("MT9V011 sensor initialization failed\n");
 				return -ENODEV;
 			}
 		}
 		sd->hstart = 2;
 		sd->vstart = 2;
 		sd->sensor = SENSOR_MT9V011;
-		info("MT9V011 sensor detected");
+		pr_info("MT9V011 sensor detected\n");
 		return 0;
 	}
 
@@ -1397,7 +1399,7 @@ static int mt9v_init_sensor(struct gspca_dev *gspca_dev)
 		for (i = 0; i < ARRAY_SIZE(mt9v111_init); i++) {
 			if (i2c_w2(gspca_dev, mt9v111_init[i].reg,
 					mt9v111_init[i].val) < 0) {
-				err("MT9V111 sensor initialization failed");
+				pr_err("MT9V111 sensor initialization failed\n");
 				return -ENODEV;
 			}
 		}
@@ -1407,7 +1409,7 @@ static int mt9v_init_sensor(struct gspca_dev *gspca_dev)
 		sd->hstart = 2;
 		sd->vstart = 2;
 		sd->sensor = SENSOR_MT9V111;
-		info("MT9V111 sensor detected");
+		pr_info("MT9V111 sensor detected\n");
 		return 0;
 	}
 
@@ -1422,14 +1424,14 @@ static int mt9v_init_sensor(struct gspca_dev *gspca_dev)
 		for (i = 0; i < ARRAY_SIZE(mt9v112_init); i++) {
 			if (i2c_w2(gspca_dev, mt9v112_init[i].reg,
 					mt9v112_init[i].val) < 0) {
-				err("MT9V112 sensor initialization failed");
+				pr_err("MT9V112 sensor initialization failed\n");
 				return -ENODEV;
 			}
 		}
 		sd->hstart = 6;
 		sd->vstart = 2;
 		sd->sensor = SENSOR_MT9V112;
-		info("MT9V112 sensor detected");
+		pr_info("MT9V112 sensor detected\n");
 		return 0;
 	}
 
@@ -1443,7 +1445,7 @@ static int mt9m112_init_sensor(struct gspca_dev *gspca_dev)
 	for (i = 0; i < ARRAY_SIZE(mt9m112_init); i++) {
 		if (i2c_w2(gspca_dev, mt9m112_init[i].reg,
 				mt9m112_init[i].val) < 0) {
-			err("MT9M112 sensor initialization failed");
+			pr_err("MT9M112 sensor initialization failed\n");
 			return -ENODEV;
 		}
 	}
@@ -1461,7 +1463,7 @@ static int mt9m111_init_sensor(struct gspca_dev *gspca_dev)
 	for (i = 0; i < ARRAY_SIZE(mt9m111_init); i++) {
 		if (i2c_w2(gspca_dev, mt9m111_init[i].reg,
 				mt9m111_init[i].val) < 0) {
-			err("MT9M111 sensor initialization failed");
+			pr_err("MT9M111 sensor initialization failed\n");
 			return -ENODEV;
 		}
 	}
@@ -1485,20 +1487,20 @@ static int mt9m001_init_sensor(struct gspca_dev *gspca_dev)
 	switch (id) {
 	case 0x8411:
 	case 0x8421:
-		info("MT9M001 color sensor detected");
+		pr_info("MT9M001 color sensor detected\n");
 		break;
 	case 0x8431:
-		info("MT9M001 mono sensor detected");
+		pr_info("MT9M001 mono sensor detected\n");
 		break;
 	default:
-		err("No MT9M001 chip detected, ID = %x\n", id);
+		pr_err("No MT9M001 chip detected, ID = %x\n\n", id);
 		return -ENODEV;
 	}
 
 	for (i = 0; i < ARRAY_SIZE(mt9m001_init); i++) {
 		if (i2c_w2(gspca_dev, mt9m001_init[i].reg,
 				mt9m001_init[i].val) < 0) {
-			err("MT9M001 sensor initialization failed");
+			pr_err("MT9M001 sensor initialization failed\n");
 			return -ENODEV;
 		}
 	}
@@ -1517,7 +1519,7 @@ static int hv7131r_init_sensor(struct gspca_dev *gspca_dev)
 	for (i = 0; i < ARRAY_SIZE(hv7131r_init); i++) {
 		if (i2c_w1(gspca_dev, hv7131r_init[i].reg,
 				hv7131r_init[i].val) < 0) {
-			err("HV7131R Sensor initialization failed");
+			pr_err("HV7131R Sensor initialization failed\n");
 			return -ENODEV;
 		}
 	}
@@ -2103,7 +2105,7 @@ static int sd_init(struct gspca_dev *gspca_dev)
 	for (i = 0; i < ARRAY_SIZE(bridge_init); i++) {
 		value = bridge_init[i][1];
 		if (reg_w(gspca_dev, bridge_init[i][0], &value, 1) < 0) {
-			err("Device initialization failed");
+			pr_err("Device initialization failed\n");
 			return -ENODEV;
 		}
 	}
@@ -2114,7 +2116,7 @@ static int sd_init(struct gspca_dev *gspca_dev)
 		reg_w1(gspca_dev, 0x1006, 0x20);
 
 	if (reg_w(gspca_dev, 0x10c0, i2c_init, 9) < 0) {
-		err("Device initialization failed");
+		pr_err("Device initialization failed\n");
 		return -ENODEV;
 	}
 
@@ -2122,27 +2124,27 @@ static int sd_init(struct gspca_dev *gspca_dev)
 	case SENSOR_OV9650:
 		if (ov9650_init_sensor(gspca_dev) < 0)
 			return -ENODEV;
-		info("OV9650 sensor detected");
+		pr_info("OV9650 sensor detected\n");
 		break;
 	case SENSOR_OV9655:
 		if (ov9655_init_sensor(gspca_dev) < 0)
 			return -ENODEV;
-		info("OV9655 sensor detected");
+		pr_info("OV9655 sensor detected\n");
 		break;
 	case SENSOR_SOI968:
 		if (soi968_init_sensor(gspca_dev) < 0)
 			return -ENODEV;
-		info("SOI968 sensor detected");
+		pr_info("SOI968 sensor detected\n");
 		break;
 	case SENSOR_OV7660:
 		if (ov7660_init_sensor(gspca_dev) < 0)
 			return -ENODEV;
-		info("OV7660 sensor detected");
+		pr_info("OV7660 sensor detected\n");
 		break;
 	case SENSOR_OV7670:
 		if (ov7670_init_sensor(gspca_dev) < 0)
 			return -ENODEV;
-		info("OV7670 sensor detected");
+		pr_info("OV7670 sensor detected\n");
 		break;
 	case SENSOR_MT9VPRB:
 		if (mt9v_init_sensor(gspca_dev) < 0)
@@ -2151,12 +2153,12 @@ static int sd_init(struct gspca_dev *gspca_dev)
 	case SENSOR_MT9M111:
 		if (mt9m111_init_sensor(gspca_dev) < 0)
 			return -ENODEV;
-		info("MT9M111 sensor detected");
+		pr_info("MT9M111 sensor detected\n");
 		break;
 	case SENSOR_MT9M112:
 		if (mt9m112_init_sensor(gspca_dev) < 0)
 			return -ENODEV;
-		info("MT9M112 sensor detected");
+		pr_info("MT9M112 sensor detected\n");
 		break;
 	case SENSOR_MT9M001:
 		if (mt9m001_init_sensor(gspca_dev) < 0)
@@ -2165,10 +2167,10 @@ static int sd_init(struct gspca_dev *gspca_dev)
 	case SENSOR_HV7131R:
 		if (hv7131r_init_sensor(gspca_dev) < 0)
 			return -ENODEV;
-		info("HV7131R sensor detected");
+		pr_info("HV7131R sensor detected\n");
 		break;
 	default:
-		info("Unsupported Sensor");
+		pr_info("Unsupported Sensor\n");
 		return -ENODEV;
 	}
 
@@ -2263,19 +2265,19 @@ static int sd_start(struct gspca_dev *gspca_dev)
 	switch (mode & SCALE_MASK) {
 	case SCALE_1280x1024:
 		scale = 0xc0;
-		info("Set 1280x1024");
+		pr_info("Set 1280x1024\n");
 		break;
 	case SCALE_640x480:
 		scale = 0x80;
-		info("Set 640x480");
+		pr_info("Set 640x480\n");
 		break;
 	case SCALE_320x240:
 		scale = 0x90;
-		info("Set 320x240");
+		pr_info("Set 320x240\n");
 		break;
 	case SCALE_160x120:
 		scale = 0xa0;
-		info("Set 160x120");
+		pr_info("Set 160x120\n");
 		break;
 	}
 
-- 
1.7.6.405.gc1be0

