Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab0HWEq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 00:46:58 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:20263 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab0HWEq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 00:46:57 -0400
Date: Mon, 23 Aug 2010 13:46:49 +0900
From: Kyungmin Park <kmpark@infradead.org>
Subject: [PATCH v2] MFD: LP3974 PMIC support
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, m.szyprowski@samsung.com,
        broonie@opensource.wolfsonmicro.com, jy0922.shim@samsung.com,
        kernel@jic23.retrosnub.co.uk, myungjoo.ham@samsung.com
Message-id: <20100823044649.GA5356@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 23 Aug 2010 04:46:54.0382 (UTC)
 FILETIME=[35A9BCE0:01CB427E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyungmin Park <kyungmin.park@samsung.com>

LP3974 PMIC support. It has same functionality with max8998.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Changelog v1:
	Only change the Kconfig and add the lp3974

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index db51ea1..fcab5f1 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -294,14 +294,15 @@ config MFD_MAX8925
 	  to use the functionality of the device.
 
 config MFD_MAX8998
-	bool "Maxim Semiconductor MAX8998 PMIC Support"
+	bool "Maxim Semiconductor MAX8998/National LP3974 PMIC Support"
 	depends on I2C=y
 	select MFD_CORE
 	help
-	  Say yes here to support for Maxim Semiconductor MAX8998. This is
-	  a Power Management IC. This driver provies common support for
-	  accessing the device, additional drivers must be enabled in order
-	  to use the functionality of the device.
+	  Say yes here to support for Maxim Semiconductor MAX8998 and
+	  National Semiconductor LP3974. This is a Power Management IC.
+	  This driver provies common support for accessing the device,
+	  additional drivers must be enabled in order to use the functionality
+	  of the device.
 
 config MFD_WM8400
 	tristate "Support Wolfson Microelectronics WM8400"
diff --git a/drivers/mfd/max8998.c b/drivers/mfd/max8998.c
index 73e6f5c..f1c9289 100644
--- a/drivers/mfd/max8998.c
+++ b/drivers/mfd/max8998.c
@@ -125,8 +125,9 @@ static int max8998_i2c_remove(struct i2c_client *i2c)
 }
 
 static const struct i2c_device_id max8998_i2c_id[] = {
-       { "max8998", 0 },
-       { }
+	{ "max8998", 0 },
+	{ "lp3974", 0 },
+	{ }
 };
 MODULE_DEVICE_TABLE(i2c, max8998_i2c_id);
 
