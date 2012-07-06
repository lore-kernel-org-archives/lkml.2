Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471Ab2GFHcd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 03:32:33 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:57754 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab2GFHcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 03:32:31 -0400
Message-ID: <1341559940.15918.1.camel@phoenix>
Subject: [PATCH] mfd: max77686: Remove unused iolock mutex
From: Axel Lin <axel.lin@gmail.com>
To: SamuelOrtiz <sameo@linux.intel.com>
Cc: Chiwoong Byun <woong.byun@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 06 Jul 2012 15:32:20 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now this driver is using regmap API, the iolock mutex is not used and can be
removed.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/max77686.c               |    3 ---
 include/linux/mfd/max77686-private.h |    1 -
 2 files changed, 4 deletions(-)

diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
index 11e5601..9e7e1d3 100644
--- a/drivers/mfd/max77686.c
+++ b/drivers/mfd/max77686.c
@@ -27,7 +27,6 @@
 #include <linux/i2c.h>
 #include <linux/pm_runtime.h>
 #include <linux/module.h>
-#include <linux/mutex.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/max77686.h>
 #include <linux/mfd/max77686-private.h>
@@ -79,8 +78,6 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
 	max77686->wakeup = pdata->wakeup;
 	max77686->irq_gpio = pdata->irq_gpio;
 
-	mutex_init(&max77686->iolock);
-
 	if (regmap_read(max77686->regmap,
 			 MAX77686_REG_DEVICE_ID, &data) < 0) {
 		dev_err(max77686->dev,
diff --git a/include/linux/mfd/max77686-private.h b/include/linux/mfd/max77686-private.h
index 962f65e..d327d49 100644
--- a/include/linux/mfd/max77686-private.h
+++ b/include/linux/mfd/max77686-private.h
@@ -219,7 +219,6 @@ struct max77686_dev {
 	struct device *dev;
 	struct i2c_client *i2c; /* 0xcc / PMIC, Battery Control, and FLASH */
 	struct i2c_client *rtc; /* slave addr 0x0c */
-	struct mutex iolock;
 
 	int type;
 
-- 
1.7.9.5



