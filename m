Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab1I0Mml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 08:42:41 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:49412 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab1I0Mmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 08:42:40 -0400
Subject: [PATCH 3/6] ASoC: Remove unused "control_data" field of struct
 wm8960_priv
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
In-Reply-To: <1317127128.7207.1.camel@phoenix>
References: <1317127128.7207.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Sep 2011 20:42:34 +0800
Message-ID: <1317127354.7207.5.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The control_data field is used to initialize the codec's control_data field,
but since this is also done by the snd-soc-cache core, the redundant
assignment can be removed and the field can be dropped.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8960.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/wm8960.c b/sound/soc/codecs/wm8960.c
index 4393394..831c20f 100644
--- a/sound/soc/codecs/wm8960.c
+++ b/sound/soc/codecs/wm8960.c
@@ -72,7 +72,6 @@ static const u16 wm8960_reg[WM8960_CACHEREGNUM] = {
 
 struct wm8960_priv {
 	enum snd_soc_control_type control_type;
-	void *control_data;
 	int (*set_bias_level)(struct snd_soc_codec *,
 			      enum snd_soc_bias_level level);
 	struct snd_soc_dapm_widget *lout1;
@@ -925,7 +924,6 @@ static int wm8960_probe(struct snd_soc_codec *codec)
 	u16 reg;
 
 	wm8960->set_bias_level = wm8960_set_bias_level_out3;
-	codec->control_data = wm8960->control_data;
 
 	if (!pdata) {
 		dev_warn(codec->dev, "No platform data supplied\n");
@@ -1015,7 +1013,6 @@ static __devinit int wm8960_i2c_probe(struct i2c_client *i2c,
 
 	i2c_set_clientdata(i2c, wm8960);
 	wm8960->control_type = SND_SOC_I2C;
-	wm8960->control_data = i2c;
 
 	ret = snd_soc_register_codec(&i2c->dev,
 			&soc_codec_dev_wm8960, &wm8960_dai, 1);
-- 
1.7.4.1



