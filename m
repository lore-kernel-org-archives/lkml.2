Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab1I0Mlo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 08:41:44 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34221 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab1I0Mln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 08:41:43 -0400
Subject: [PATCH 2/6] ASoC: Remove unused "control_data" field of struct
 wm8940_priv
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jonathan Cameron <jic23@cam.ac.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
In-Reply-To: <1317127128.7207.1.camel@phoenix>
References: <1317127128.7207.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Sep 2011 20:41:36 +0800
Message-ID: <1317127296.7207.4.camel@phoenix>
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
 sound/soc/codecs/wm8940.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/wm8940.c b/sound/soc/codecs/wm8940.c
index 056daa0..7e0f54c 100644
--- a/sound/soc/codecs/wm8940.c
+++ b/sound/soc/codecs/wm8940.c
@@ -43,7 +43,6 @@
 struct wm8940_priv {
 	unsigned int sysclk;
 	enum snd_soc_control_type control_type;
-	void *control_data;
 };
 
 static u16 wm8940_reg_defaults[] = {
@@ -693,7 +692,6 @@ static int wm8940_probe(struct snd_soc_codec *codec)
 	int ret;
 	u16 reg;
 
-	codec->control_data = wm8940->control_data;
 	ret = snd_soc_codec_set_cache_io(codec, 8, 16, wm8940->control_type);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
@@ -758,7 +756,6 @@ static __devinit int wm8940_i2c_probe(struct i2c_client *i2c,
 		return -ENOMEM;
 
 	i2c_set_clientdata(i2c, wm8940);
-	wm8940->control_data = i2c;
 	wm8940->control_type = SND_SOC_I2C;
 
 	ret = snd_soc_register_codec(&i2c->dev,
-- 
1.7.4.1



