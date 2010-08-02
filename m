Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab0HBDya (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 23:54:30 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13460 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068Ab0HBDy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 23:54:29 -0400
Date: Mon, 02 Aug 2010 12:54:22 +0900
From: Kyungmin Park <kmpark@infradead.org>
Subject: [PATCH] MFD: LP3974 PMIC support
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, m.szyprowski@samsung.com,
        broonie@opensource.wolfsonmicro.com, jy0922.shim@samsung.com
Message-id: <20100802035422.GA2883@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-OriginalArrivalTime: 02 Aug 2010 03:54:27.0175 (UTC)
 FILETIME=[671B4F70:01CB31F6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyungmin Park <kyungmin.park@samsung.com>

LP3974 PMIC support. It has same functionality with max8998.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index db63d40..50383b1 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -303,6 +303,18 @@ config MFD_MAX8998
 	  accessing the device, additional drivers must be enabled in order
 	  to use the functionality of the device.
 
+config MFD_LP3974
+	bool "National Semiconductor LP3974 PMIC Support"
+	depends on I2C=y
+	select MFD_CORE
+	select MFD_MAX8998
+	help
+	  Say yes here to support for National Semiconductor LP3974. This is
+	  a Power Management IC. This driver provies common support for
+	  accessing the device, additional drivers must be enabled in order
+	  to use the functionality of the device.
+	  Note that it has same functionality with max8998.
+
 config MFD_WM8400
 	tristate "Support Wolfson Microelectronics WM8400"
 	select MFD_CORE
diff --git a/drivers/mfd/max8998.c b/drivers/mfd/max8998.c
index 0d68de2..cea9f48 100644
--- a/drivers/mfd/max8998.c
+++ b/drivers/mfd/max8998.c
@@ -30,6 +30,11 @@
 #include <linux/mfd/max8998.h>
 #include <linux/mfd/max8998-private.h>
 
+enum max8998_type {
+	TYPE_MAX8998,
+	TYPE_LP3974,
+};
+
 static struct mfd_cell max8998_devs[] = {
 	{
 		.name = "max8998-pmic",
@@ -127,8 +132,8 @@ static int max8998_i2c_remove(struct i2c_client *i2c)
 }
 
 static const struct i2c_device_id max8998_i2c_id[] = {
-       { "max8998", 0 },
-       { }
+       { "max8998", TYPE_MAX8998 },
+       { "lp3974", TYPE_LP3974 },
 };
 MODULE_DEVICE_TABLE(i2c, max8998_i2c_id);
 
