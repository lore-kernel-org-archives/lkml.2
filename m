Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545Ab1AEPOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 10:14:17 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33389 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751256Ab1AEPOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 10:14:16 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Convert WM831x away from legacy I2C PM operations
Date: Wed,  5 Jan 2011 15:12:39 +0000
Message-Id: <1294240359-22264-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the legacy bus PM operations are deprecated move the suspend
method over to dev_pm_ops.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-i2c.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/wm831x-i2c.c b/drivers/mfd/wm831x-i2c.c
index 38be520..3853fa8 100644
--- a/drivers/mfd/wm831x-i2c.c
+++ b/drivers/mfd/wm831x-i2c.c
@@ -94,9 +94,9 @@ static int wm831x_i2c_remove(struct i2c_client *i2c)
 	return 0;
 }
 
-static int wm831x_i2c_suspend(struct i2c_client *i2c, pm_message_t mesg)
+static int wm831x_i2c_suspend(struct device *dev)
 {
-	struct wm831x *wm831x = i2c_get_clientdata(i2c);
+	struct wm831x *wm831x = dev_get_drvdata(dev);
 
 	return wm831x_device_suspend(wm831x);
 }
@@ -113,15 +113,18 @@ static const struct i2c_device_id wm831x_i2c_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, wm831x_i2c_id);
 
+static const struct dev_pm_ops wm831x_pm_ops = {
+	.suspend = wm831x_i2c_suspend,
+};
 
 static struct i2c_driver wm831x_i2c_driver = {
 	.driver = {
-		   .name = "wm831x",
-		   .owner = THIS_MODULE,
+		.name = "wm831x",
+		.owner = THIS_MODULE,
+		.pm = &wm831x_pm_ops,
 	},
 	.probe = wm831x_i2c_probe,
 	.remove = wm831x_i2c_remove,
-	.suspend = wm831x_i2c_suspend,
 	.id_table = wm831x_i2c_id,
 };
 
-- 
1.7.2.3

