Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab2EGJDm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 05:03:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60732 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755968Ab2EGJDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 05:03:37 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 7/7] mfd: wm8994: Convert to module_i2c_driver()
Date: Mon,  7 May 2012 10:03:23 +0100
Message-Id: <1336381403-7840-7-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1336381403-7840-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1336381403-7840-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8994-core.c |   18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index 60e61754..1e321d3 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -733,23 +733,7 @@ static struct i2c_driver wm8994_i2c_driver = {
 	.id_table = wm8994_i2c_id,
 };
 
-static int __init wm8994_i2c_init(void)
-{
-	int ret;
-
-	ret = i2c_add_driver(&wm8994_i2c_driver);
-	if (ret != 0)
-		pr_err("Failed to register wm8994 I2C driver: %d\n", ret);
-
-	return ret;
-}
-module_init(wm8994_i2c_init);
-
-static void __exit wm8994_i2c_exit(void)
-{
-	i2c_del_driver(&wm8994_i2c_driver);
-}
-module_exit(wm8994_i2c_exit);
+module_i2c_driver(wm8994_i2c_driver);
 
 MODULE_DESCRIPTION("Core support for the WM8994 audio CODEC");
 MODULE_LICENSE("GPL");
-- 
1.7.10

