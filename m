Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab0I1QNf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 12:13:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45151 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753486Ab0I1QNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 12:13:34 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Add WM8325 support
Date: Tue, 28 Sep 2010 09:13:39 -0700
Message-Id: <1285690419-10854-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM8325 is a PMIC for low power, high performance applications.  From
a software point of view the device is identical to the WM8320, all the
differences are at the hardware level.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-core.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index 1e7aaaf..ad36579 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -96,6 +96,7 @@ enum wm831x_parent {
 	WM8312 = 0x8312,
 	WM8320 = 0x8320,
 	WM8321 = 0x8321,
+	WM8325 = 0x8325,
 };
 
 static int wm831x_reg_locked(struct wm831x *wm831x, unsigned short reg)
@@ -1540,6 +1541,12 @@ static int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 		dev_info(wm831x->dev, "WM8321 revision %c\n", 'A' + rev);
 		break;
 
+	case WM8325:
+		parent = WM8325;
+		wm831x->num_gpio = 12;
+		dev_info(wm831x->dev, "WM8325 revision %c\n", 'A' + rev);
+		break;
+
 	default:
 		dev_err(wm831x->dev, "Unknown WM831x device %04x\n", ret);
 		ret = -EINVAL;
@@ -1620,6 +1627,12 @@ static int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 				      NULL, 0);
 		break;
 
+	case WM8325:
+		ret = mfd_add_devices(wm831x->dev, -1,
+				      wm8320_devs, ARRAY_SIZE(wm8320_devs),
+				      NULL, 0);
+		break;
+
 	default:
 		/* If this happens the bus probe function is buggy */
 		BUG();
@@ -1791,6 +1804,7 @@ static const struct i2c_device_id wm831x_i2c_id[] = {
 	{ "wm8312", WM8312 },
 	{ "wm8320", WM8320 },
 	{ "wm8321", WM8321 },
+	{ "wm8325", WM8325 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, wm831x_i2c_id);
-- 
1.7.1

