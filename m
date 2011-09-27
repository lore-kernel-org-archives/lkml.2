Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab1I0MoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 08:44:20 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50794 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab1I0MoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 08:44:19 -0400
Subject: [PATCH 5/6] ASoC: Remove unused "control_data" field of struct
 wm9081_priv
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
In-Reply-To: <1317127128.7207.1.camel@phoenix>
References: <1317127128.7207.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Sep 2011 20:44:13 +0800
Message-ID: <1317127453.7207.7.camel@phoenix>
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
 sound/soc/codecs/wm9081.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/wm9081.c b/sound/soc/codecs/wm9081.c
index f32ab1e..b2d3448 100644
--- a/sound/soc/codecs/wm9081.c
+++ b/sound/soc/codecs/wm9081.c
@@ -157,7 +157,6 @@ static struct {
 
 struct wm9081_priv {
 	enum snd_soc_control_type control_type;
-	void *control_data;
 	int sysclk_source;
 	int mclk_rate;
 	int sysclk_rate;
@@ -1213,7 +1212,6 @@ static int wm9081_probe(struct snd_soc_codec *codec)
 	int ret;
 	u16 reg;
 
-	codec->control_data = wm9081->control_data;
 	ret = snd_soc_codec_set_cache_io(codec, 8, 16, wm9081->control_type);
 	if (ret != 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
@@ -1330,7 +1328,6 @@ static __devinit int wm9081_i2c_probe(struct i2c_client *i2c,
 
 	i2c_set_clientdata(i2c, wm9081);
 	wm9081->control_type = SND_SOC_I2C;
-	wm9081->control_data = i2c;
 
 	if (dev_get_platdata(&i2c->dev))
 		memcpy(&wm9081->pdata, dev_get_platdata(&i2c->dev),
-- 
1.7.4.1



