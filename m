Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab1I1CMD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 22:12:03 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64397 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab1I1CMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 22:12:01 -0400
Subject: [PATCH 4/6] ASoC: Remove unused "control_data" field of struct
 cs42l51_private
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org, Arnaud Patard <arnaud.patard@rtp-net.org>
In-Reply-To: <1317175218.14102.1.camel@phoenix>
References: <1317175218.14102.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Sep 2011 10:11:54 +0800
Message-ID: <1317175914.14102.6.camel@phoenix>
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
 sound/soc/codecs/cs42l51.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/sound/soc/codecs/cs42l51.c b/sound/soc/codecs/cs42l51.c
index 8fb7070..286878d 100644
--- a/sound/soc/codecs/cs42l51.c
+++ b/sound/soc/codecs/cs42l51.c
@@ -42,7 +42,6 @@ enum master_slave_mode {
 
 struct cs42l51_private {
 	enum snd_soc_control_type control_type;
-	void *control_data;
 	unsigned int mclk;
 	unsigned int audio_mode;	/* The mode (I2S or left-justified) */
 	enum master_slave_mode func;
@@ -57,7 +56,7 @@ struct cs42l51_private {
 static int cs42l51_fill_cache(struct snd_soc_codec *codec)
 {
 	u8 *cache = codec->reg_cache + 1;
-	struct i2c_client *i2c_client = codec->control_data;
+	struct i2c_client *i2c_client = to_i2c_client(codec->dev);
 	s32 length;
 
 	length = i2c_smbus_read_i2c_block_data(i2c_client,
@@ -520,8 +519,6 @@ static int cs42l51_probe(struct snd_soc_codec *codec)
 	struct snd_soc_dapm_context *dapm = &codec->dapm;
 	int ret, reg;
 
-	codec->control_data = cs42l51->control_data;
-
 	ret = cs42l51_fill_cache(codec);
 	if (ret < 0) {
 		dev_err(codec->dev, "failed to fill register cache\n");
@@ -593,7 +590,6 @@ static int cs42l51_i2c_probe(struct i2c_client *i2c_client,
 	}
 
 	i2c_set_clientdata(i2c_client, cs42l51);
-	cs42l51->control_data = i2c_client;
 	cs42l51->control_type = SND_SOC_I2C;
 
 	ret =  snd_soc_register_codec(&i2c_client->dev,
-- 
1.7.4.1



