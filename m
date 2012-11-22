Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398Ab2KVTvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:51:24 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59089 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab2KVTvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:51:19 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com
Cc: broonie@opensource.wolfsonmicro.com, patches@linaro.org
Subject: [PATCH 06/10] ASoC: wm8753: Convert to use devm_regmap_init_{spi,i2c}()
Date: Thu, 22 Nov 2012 09:38:38 +0530
Message-Id: <1353557322-25353-7-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353557322-25353-1-git-send-email-tushar.behera@linaro.org>
References: <1353557322-25353-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 sound/soc/codecs/wm8753.c |   32 ++++++--------------------------
 1 files changed, 6 insertions(+), 26 deletions(-)

diff --git a/sound/soc/codecs/wm8753.c b/sound/soc/codecs/wm8753.c
index 9914215..50a5dc7 100644
--- a/sound/soc/codecs/wm8753.c
+++ b/sound/soc/codecs/wm8753.c
@@ -1562,35 +1562,25 @@ static int __devinit wm8753_spi_probe(struct spi_device *spi)
 
 	spi_set_drvdata(spi, wm8753);
 
-	wm8753->regmap = regmap_init_spi(spi, &wm8753_regmap);
+	wm8753->regmap = devm_regmap_init_spi(spi, &wm8753_regmap);
 	if (IS_ERR(wm8753->regmap)) {
 		ret = PTR_ERR(wm8753->regmap);
 		dev_err(&spi->dev, "Failed to allocate register map: %d\n",
 			ret);
-		goto err;
+		return ret;
 	}
 
 	ret = snd_soc_register_codec(&spi->dev, &soc_codec_dev_wm8753,
 				     wm8753_dai, ARRAY_SIZE(wm8753_dai));
-	if (ret != 0) {
+	if (ret != 0)
 		dev_err(&spi->dev, "Failed to register CODEC: %d\n", ret);
-		goto err_regmap;
-	}
 
-	return 0;
-
-err_regmap:
-	regmap_exit(wm8753->regmap);
-err:
 	return ret;
 }
 
 static int __devexit wm8753_spi_remove(struct spi_device *spi)
 {
-	struct wm8753_priv *wm8753 = spi_get_drvdata(spi);
-
 	snd_soc_unregister_codec(&spi->dev);
-	regmap_exit(wm8753->regmap);
 	return 0;
 }
 
@@ -1619,35 +1609,25 @@ static __devinit int wm8753_i2c_probe(struct i2c_client *i2c,
 
 	i2c_set_clientdata(i2c, wm8753);
 
-	wm8753->regmap = regmap_init_i2c(i2c, &wm8753_regmap);
+	wm8753->regmap = devm_regmap_init_i2c(i2c, &wm8753_regmap);
 	if (IS_ERR(wm8753->regmap)) {
 		ret = PTR_ERR(wm8753->regmap);
 		dev_err(&i2c->dev, "Failed to allocate register map: %d\n",
 			ret);
-		goto err;
+		return ret;
 	}
 
 	ret = snd_soc_register_codec(&i2c->dev, &soc_codec_dev_wm8753,
 				     wm8753_dai, ARRAY_SIZE(wm8753_dai));
-	if (ret != 0) {
+	if (ret != 0)
 		dev_err(&i2c->dev, "Failed to register CODEC: %d\n", ret);
-		goto err_regmap;
-	}
 
-	return 0;
-
-err_regmap:
-	regmap_exit(wm8753->regmap);
-err:
 	return ret;
 }
 
 static __devexit int wm8753_i2c_remove(struct i2c_client *client)
 {
-	struct wm8753_priv *wm8753 = i2c_get_clientdata(client);
-
 	snd_soc_unregister_codec(&client->dev);
-	regmap_exit(wm8753->regmap);
 	return 0;
 }
 
-- 
1.7.4.1

