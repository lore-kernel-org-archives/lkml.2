Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420Ab2KVT63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:58:29 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45283 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757176Ab2KVT6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:58:06 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com
Cc: broonie@opensource.wolfsonmicro.com, patches@linaro.org
Subject: [PATCH 10/10] ASoC: wm8995: Convert to use devm_regmap_init_{spi,i2c}()
Date: Thu, 22 Nov 2012 09:38:42 +0530
Message-Id: <1353557322-25353-11-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353557322-25353-1-git-send-email-tushar.behera@linaro.org>
References: <1353557322-25353-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 sound/soc/codecs/wm8995.c |   26 +++-----------------------
 1 files changed, 3 insertions(+), 23 deletions(-)

diff --git a/sound/soc/codecs/wm8995.c b/sound/soc/codecs/wm8995.c
index 2eb68c1..f1a7cf1 100644
--- a/sound/soc/codecs/wm8995.c
+++ b/sound/soc/codecs/wm8995.c
@@ -2267,7 +2267,7 @@ static int __devinit wm8995_spi_probe(struct spi_device *spi)
 
 	spi_set_drvdata(spi, wm8995);
 
-	wm8995->regmap = regmap_init_spi(spi, &wm8995_regmap);
+	wm8995->regmap = devm_regmap_init_spi(spi, &wm8995_regmap);
 	if (IS_ERR(wm8995->regmap)) {
 		ret = PTR_ERR(wm8995->regmap);
 		dev_err(&spi->dev, "Failed to register regmap: %d\n", ret);
@@ -2277,22 +2277,12 @@ static int __devinit wm8995_spi_probe(struct spi_device *spi)
 	ret = snd_soc_register_codec(&spi->dev,
 				     &soc_codec_dev_wm8995, wm8995_dai,
 				     ARRAY_SIZE(wm8995_dai));
-	if (ret < 0)
-		goto err_regmap;
-
-	return ret;
-
-err_regmap:
-	regmap_exit(wm8995->regmap);
-
 	return ret;
 }
 
 static int __devexit wm8995_spi_remove(struct spi_device *spi)
 {
-	struct wm8995_priv *wm8995 = spi_get_drvdata(spi);
 	snd_soc_unregister_codec(&spi->dev);
-	regmap_exit(wm8995->regmap);
 	return 0;
 }
 
@@ -2319,7 +2309,7 @@ static __devinit int wm8995_i2c_probe(struct i2c_client *i2c,
 
 	i2c_set_clientdata(i2c, wm8995);
 
-	wm8995->regmap = regmap_init_i2c(i2c, &wm8995_regmap);
+	wm8995->regmap = devm_regmap_init_i2c(i2c, &wm8995_regmap);
 	if (IS_ERR(wm8995->regmap)) {
 		ret = PTR_ERR(wm8995->regmap);
 		dev_err(&i2c->dev, "Failed to register regmap: %d\n", ret);
@@ -2329,25 +2319,15 @@ static __devinit int wm8995_i2c_probe(struct i2c_client *i2c,
 	ret = snd_soc_register_codec(&i2c->dev,
 				     &soc_codec_dev_wm8995, wm8995_dai,
 				     ARRAY_SIZE(wm8995_dai));
-	if (ret < 0) {
+	if (ret < 0)
 		dev_err(&i2c->dev, "Failed to register CODEC: %d\n", ret);
-		goto err_regmap;
-	}
-
-	return ret;
-
-err_regmap:
-	regmap_exit(wm8995->regmap);
 
 	return ret;
 }
 
 static __devexit int wm8995_i2c_remove(struct i2c_client *client)
 {
-	struct wm8995_priv *wm8995 = i2c_get_clientdata(client);
-
 	snd_soc_unregister_codec(&client->dev);
-	regmap_exit(wm8995->regmap);
 	return 0;
 }
 
-- 
1.7.4.1

