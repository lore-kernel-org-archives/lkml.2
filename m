Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab2KVUwe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:52:34 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:42687 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932565Ab2KVUwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:52:17 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com
Cc: broonie@opensource.wolfsonmicro.com, patches@linaro.org
Subject: [PATCH 03/10] ASoC: wm8995: Convert to use devm_kzalloc()
Date: Thu, 22 Nov 2012 09:38:35 +0530
Message-Id: <1353557322-25353-4-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353557322-25353-1-git-send-email-tushar.behera@linaro.org>
References: <1353557322-25353-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 sound/soc/codecs/wm8995.c |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/sound/soc/codecs/wm8995.c b/sound/soc/codecs/wm8995.c
index 28c89b0..2eb68c1 100644
--- a/sound/soc/codecs/wm8995.c
+++ b/sound/soc/codecs/wm8995.c
@@ -2261,7 +2261,7 @@ static int __devinit wm8995_spi_probe(struct spi_device *spi)
 	struct wm8995_priv *wm8995;
 	int ret;
 
-	wm8995 = kzalloc(sizeof *wm8995, GFP_KERNEL);
+	wm8995 = devm_kzalloc(&spi->dev, sizeof(*wm8995), GFP_KERNEL);
 	if (!wm8995)
 		return -ENOMEM;
 
@@ -2271,7 +2271,7 @@ static int __devinit wm8995_spi_probe(struct spi_device *spi)
 	if (IS_ERR(wm8995->regmap)) {
 		ret = PTR_ERR(wm8995->regmap);
 		dev_err(&spi->dev, "Failed to register regmap: %d\n", ret);
-		goto err_alloc;
+		return ret;
 	}
 
 	ret = snd_soc_register_codec(&spi->dev,
@@ -2284,8 +2284,6 @@ static int __devinit wm8995_spi_probe(struct spi_device *spi)
 
 err_regmap:
 	regmap_exit(wm8995->regmap);
-err_alloc:
-	kfree(wm8995);
 
 	return ret;
 }
@@ -2295,7 +2293,6 @@ static int __devexit wm8995_spi_remove(struct spi_device *spi)
 	struct wm8995_priv *wm8995 = spi_get_drvdata(spi);
 	snd_soc_unregister_codec(&spi->dev);
 	regmap_exit(wm8995->regmap);
-	kfree(wm8995);
 	return 0;
 }
 
@@ -2316,7 +2313,7 @@ static __devinit int wm8995_i2c_probe(struct i2c_client *i2c,
 	struct wm8995_priv *wm8995;
 	int ret;
 
-	wm8995 = kzalloc(sizeof *wm8995, GFP_KERNEL);
+	wm8995 = devm_kzalloc(&i2c->dev, sizeof(*wm8995), GFP_KERNEL);
 	if (!wm8995)
 		return -ENOMEM;
 
@@ -2326,7 +2323,7 @@ static __devinit int wm8995_i2c_probe(struct i2c_client *i2c,
 	if (IS_ERR(wm8995->regmap)) {
 		ret = PTR_ERR(wm8995->regmap);
 		dev_err(&i2c->dev, "Failed to register regmap: %d\n", ret);
-		goto err_alloc;
+		return ret;
 	}
 
 	ret = snd_soc_register_codec(&i2c->dev,
@@ -2341,8 +2338,6 @@ static __devinit int wm8995_i2c_probe(struct i2c_client *i2c,
 
 err_regmap:
 	regmap_exit(wm8995->regmap);
-err_alloc:
-	kfree(wm8995);
 
 	return ret;
 }
@@ -2353,7 +2348,6 @@ static __devexit int wm8995_i2c_remove(struct i2c_client *client)
 
 	snd_soc_unregister_codec(&client->dev);
 	regmap_exit(wm8995->regmap);
-	kfree(wm8995);
 	return 0;
 }
 
-- 
1.7.4.1

