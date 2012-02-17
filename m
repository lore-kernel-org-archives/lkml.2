Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab2BQX6N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 18:58:13 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59842 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752306Ab2BQX6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 18:58:12 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: wm8994: Add __devinit and __devexit annotations for probe and remove
Date: Fri, 17 Feb 2012 15:58:03 -0800
Message-Id: <1329523083-31644-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes warnings and needed for correctness.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8994-core.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index b2de65b..3c01b99 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -670,8 +670,8 @@ static const struct of_device_id wm8994_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, wm8994_of_match);
 
-static int wm8994_i2c_probe(struct i2c_client *i2c,
-			    const struct i2c_device_id *id)
+static __devinit int wm8994_i2c_probe(struct i2c_client *i2c,
+				      const struct i2c_device_id *id)
 {
 	struct wm8994 *wm8994;
 	int ret;
@@ -696,7 +696,7 @@ static int wm8994_i2c_probe(struct i2c_client *i2c,
 	return wm8994_device_init(wm8994, i2c->irq);
 }
 
-static int wm8994_i2c_remove(struct i2c_client *i2c)
+static __devexit int wm8994_i2c_remove(struct i2c_client *i2c)
 {
 	struct wm8994 *wm8994 = i2c_get_clientdata(i2c);
 
@@ -725,7 +725,7 @@ static struct i2c_driver wm8994_i2c_driver = {
 		.of_match_table = wm8994_of_match,
 	},
 	.probe = wm8994_i2c_probe,
-	.remove = wm8994_i2c_remove,
+	.remove = __devexit_p(wm8994_i2c_remove),
 	.id_table = wm8994_i2c_id,
 };
 
-- 
1.7.9

