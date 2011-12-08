Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582Ab1LHDQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 22:16:20 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52506 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757195Ab1LHDQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 22:16:16 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] mfd: Convert WM8350 to devm_kzalloc()
Date: Thu,  8 Dec 2011 10:55:22 +0800
Message-Id: <1323312922-29813-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323312922-29813-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1323312922-29813-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8350-i2c.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/wm8350-i2c.c b/drivers/mfd/wm8350-i2c.c
index 5fe5de1..d955faa 100644
--- a/drivers/mfd/wm8350-i2c.c
+++ b/drivers/mfd/wm8350-i2c.c
@@ -63,7 +63,7 @@ static int wm8350_i2c_probe(struct i2c_client *i2c,
 	struct wm8350 *wm8350;
 	int ret = 0;
 
-	wm8350 = kzalloc(sizeof(struct wm8350), GFP_KERNEL);
+	wm8350 = devm_kzalloc(&i2c->dev, sizeof(struct wm8350), GFP_KERNEL);
 	if (wm8350 == NULL)
 		return -ENOMEM;
 
@@ -80,7 +80,6 @@ static int wm8350_i2c_probe(struct i2c_client *i2c,
 	return ret;
 
 err:
-	kfree(wm8350);
 	return ret;
 }
 
@@ -89,7 +88,6 @@ static int wm8350_i2c_remove(struct i2c_client *i2c)
 	struct wm8350 *wm8350 = i2c_get_clientdata(i2c);
 
 	wm8350_device_exit(wm8350);
-	kfree(wm8350);
 
 	return 0;
 }
-- 
1.7.7.3

