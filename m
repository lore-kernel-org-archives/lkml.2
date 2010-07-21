Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119Ab0GUNX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 09:23:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41304 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756066Ab0GUNX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 09:23:27 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Add WM8321 support
Date: Wed, 21 Jul 2010 14:23:37 +0100
Message-Id: <1279718617-13453-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM8321 is a PMIC for low power, high performance applications. From a
software point of view the device is identical to the WM8320, all the
differences between the two devices are visible only in hardware.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-core.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index 1a968f3..cb94e7e 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -95,6 +95,7 @@ enum wm831x_parent {
 	WM8311 = 0x8311,
 	WM8312 = 0x8312,
 	WM8320 = 0x8320,
+	WM8321 = 0x8321,
 };
 
 static int wm831x_reg_locked(struct wm831x *wm831x, unsigned short reg)
@@ -1533,6 +1534,12 @@ static int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 		dev_info(wm831x->dev, "WM8320 revision %c\n", 'A' + rev);
 		break;
 
+	case WM8321:
+		parent = WM8321;
+		wm831x->num_gpio = 12;
+		dev_info(wm831x->dev, "WM8321 revision %c\n", 'A' + rev);
+		break;
+
 	default:
 		dev_err(wm831x->dev, "Unknown WM831x device %04x\n", ret);
 		ret = -EINVAL;
@@ -1607,6 +1614,12 @@ static int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 				      NULL, 0);
 		break;
 
+	case WM8321:
+		ret = mfd_add_devices(wm831x->dev, -1,
+				      wm8320_devs, ARRAY_SIZE(wm8320_devs),
+				      NULL, 0);
+		break;
+
 	default:
 		/* If this happens the bus probe function is buggy */
 		BUG();
@@ -1779,6 +1792,7 @@ static const struct i2c_device_id wm831x_i2c_id[] = {
 	{ "wm8311", WM8311 },
 	{ "wm8312", WM8312 },
 	{ "wm8320", WM8320 },
+	{ "wm8321", WM8321 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, wm831x_i2c_id);
-- 
1.7.1

