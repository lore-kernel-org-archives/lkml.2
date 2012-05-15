Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757747Ab2EORqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 13:46:15 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:51189 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751705Ab2EORqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 13:46:13 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH] mfd: Fix double free in wm8350 error path
Date: Tue, 15 May 2012 19:45:40 +0200
Message-Id: <1337103940-31899-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix double free in probe error path introduced by the recent conversion
of wm8350 to use regmap.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/mfd/wm8350-i2c.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/wm8350-i2c.c b/drivers/mfd/wm8350-i2c.c
index 271589f..a68aceb 100644
--- a/drivers/mfd/wm8350-i2c.c
+++ b/drivers/mfd/wm8350-i2c.c
@@ -49,15 +49,7 @@ static int wm8350_i2c_probe(struct i2c_client *i2c,
 	i2c_set_clientdata(i2c, wm8350);
 	wm8350->dev = &i2c->dev;
 
-	ret = wm8350_device_init(wm8350, i2c->irq, i2c->dev.platform_data);
-	if (ret < 0)
-		goto err;
-
-	return ret;
-
-err:
-	regmap_exit(wm8350->regmap);
-	return ret;
+	return wm8350_device_init(wm8350, i2c->irq, i2c->dev.platform_data);
 }
 
 static int wm8350_i2c_remove(struct i2c_client *i2c)
-- 
1.7.8.5

