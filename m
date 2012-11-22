Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316Ab2KVUUK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:20:10 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50541 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963Ab2KVUUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:20:05 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com
Cc: broonie@opensource.wolfsonmicro.com, patches@linaro.org
Subject: [PATCH 05/10] ASoC: wm8741: Convert to use devm_regmap_init_{spi,i2c}()
Date: Thu, 22 Nov 2012 09:38:37 +0530
Message-Id: <1353557322-25353-6-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353557322-25353-1-git-send-email-tushar.behera@linaro.org>
References: <1353557322-25353-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 sound/soc/codecs/wm8741.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wm8741.c b/sound/soc/codecs/wm8741.c
index 4281a08..99b8ebe 100644
--- a/sound/soc/codecs/wm8741.c
+++ b/sound/soc/codecs/wm8741.c
@@ -522,7 +522,7 @@ static int wm8741_i2c_probe(struct i2c_client *i2c,
 		return ret;
 	}
 
-	wm8741->regmap = regmap_init_i2c(i2c, &wm8741_regmap);
+	wm8741->regmap = devm_regmap_init_i2c(i2c, &wm8741_regmap);
 	if (IS_ERR(wm8741->regmap)) {
 		ret = PTR_ERR(wm8741->regmap);
 		dev_err(&i2c->dev, "Failed to init regmap: %d\n", ret);
@@ -582,7 +582,7 @@ static int __devinit wm8741_spi_probe(struct spi_device *spi)
 		return ret;
 	}
 
-	wm8741->regmap = regmap_init_spi(spi, &wm8741_regmap);
+	wm8741->regmap = devm_regmap_init_spi(spi, &wm8741_regmap);
 	if (IS_ERR(wm8741->regmap)) {
 		ret = PTR_ERR(wm8741->regmap);
 		dev_err(&spi->dev, "Failed to init regmap: %d\n", ret);
-- 
1.7.4.1

