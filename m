Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab1I0MpZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 08:45:25 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47289 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976Ab1I0MpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 08:45:23 -0400
Subject: [PATCH 6/6] ASoC: Remove unused "control_data" field of struct
 wm9090_priv
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
In-Reply-To: <1317127128.7207.1.camel@phoenix>
References: <1317127128.7207.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Sep 2011 20:45:17 +0800
Message-ID: <1317127517.7207.8.camel@phoenix>
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
 sound/soc/codecs/wm9090.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/wm9090.c b/sound/soc/codecs/wm9090.c
index f2f3077..5f4786c 100644
--- a/sound/soc/codecs/wm9090.c
+++ b/sound/soc/codecs/wm9090.c
@@ -140,7 +140,6 @@ static const u16 wm9090_reg_defaults[] = {
 /* This struct is used to save the context */
 struct wm9090_priv {
 	struct wm9090_platform_data pdata;
-	void *control_data;
 };
 
 static int wm9090_volatile(struct snd_soc_codec *codec, unsigned int reg)
@@ -552,7 +551,6 @@ static int wm9090_probe(struct snd_soc_codec *codec)
 	struct wm9090_priv *wm9090 = snd_soc_codec_get_drvdata(codec);
 	int ret;
 
-	codec->control_data = wm9090->control_data;
 	ret = snd_soc_codec_set_cache_io(codec, 8, 16, SND_SOC_I2C);
 	if (ret != 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
@@ -661,7 +659,6 @@ static int wm9090_i2c_probe(struct i2c_client *i2c,
 		       sizeof(wm9090->pdata));
 
 	i2c_set_clientdata(i2c, wm9090);
-	wm9090->control_data = i2c;
 
 	ret =  snd_soc_register_codec(&i2c->dev,
 			&soc_codec_dev_wm9090,  NULL, 0);
-- 
1.7.4.1



