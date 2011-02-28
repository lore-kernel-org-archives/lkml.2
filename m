Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab1B1LoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 06:44:20 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:38307 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689Ab1B1LoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 06:44:18 -0500
From: shubhrajyoti@ti.com
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH] bh1780gli : Convert to dev pm ops
Date: Mon, 28 Feb 2011 17:14:07 +0530
Message-Id: <1298893447-27745-1-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shubhrajyoti D <shubhrajyoti@ti.com>


Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/misc/bh1780gli.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/misc/bh1780gli.c b/drivers/misc/bh1780gli.c
index d5f3a3f..d07cd67 100644
--- a/drivers/misc/bh1780gli.c
+++ b/drivers/misc/bh1780gli.c
@@ -196,10 +196,11 @@ static int __devexit bh1780_remove(struct i2c_client *client)
 }
 
 #ifdef CONFIG_PM
-static int bh1780_suspend(struct i2c_client *client, pm_message_t mesg)
+static int bh1780_suspend(struct device *dev)
 {
 	struct bh1780_data *ddata;
 	int state, ret;
+	struct i2c_client *client = to_i2c_client(dev);
 
 	ddata = i2c_get_clientdata(client);
 	state = bh1780_read(ddata, BH1780_REG_CONTROL, "CONTROL");
@@ -217,14 +218,14 @@ static int bh1780_suspend(struct i2c_client *client, pm_message_t mesg)
 	return 0;
 }
 
-static int bh1780_resume(struct i2c_client *client)
+static int bh1780_resume(struct device *dev)
 {
 	struct bh1780_data *ddata;
 	int state, ret;
+	struct i2c_client *client = to_i2c_client(dev);
 
 	ddata = i2c_get_clientdata(client);
 	state = ddata->power_state;
-
 	ret = bh1780_write(ddata, BH1780_REG_CONTROL, state,
 				"CONTROL");
 
@@ -233,9 +234,10 @@ static int bh1780_resume(struct i2c_client *client)
 
 	return 0;
 }
+static SIMPLE_DEV_PM_OPS(bh1780_pm, bh1780_suspend, bh1780_resume);
+#define BH1780_PMOPS (&bh1780_pm)
 #else
-#define bh1780_suspend NULL
-#define bh1780_resume NULL
+#define BH1780_PMOPS NULL
 #endif /* CONFIG_PM */
 
 static const struct i2c_device_id bh1780_id[] = {
@@ -247,11 +249,10 @@ static struct i2c_driver bh1780_driver = {
 	.probe		= bh1780_probe,
 	.remove		= bh1780_remove,
 	.id_table	= bh1780_id,
-	.suspend	= bh1780_suspend,
-	.resume		= bh1780_resume,
 	.driver = {
-		.name = "bh1780"
-	},
+		.name = "bh1780",
+		.pm	= BH1780_PMOPS,
+},
 };
 
 static int __init bh1780_init(void)
-- 
1.7.1

