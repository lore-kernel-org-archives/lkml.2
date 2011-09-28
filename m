Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab1I1CKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 22:10:47 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56376 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab1I1CKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 22:10:46 -0400
Subject: [PATCH 3/6] ASoC: Remove unused "control_data" field of struct
 cs4270_private
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org, Timur Tabi <timur@freescale.com>
In-Reply-To: <1317175218.14102.1.camel@phoenix>
References: <1317175218.14102.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Sep 2011 10:10:38 +0800
Message-ID: <1317175838.14102.4.camel@phoenix>
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
 sound/soc/codecs/cs4270.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/sound/soc/codecs/cs4270.c b/sound/soc/codecs/cs4270.c
index 6cc8678..5830c93 100644
--- a/sound/soc/codecs/cs4270.c
+++ b/sound/soc/codecs/cs4270.c
@@ -128,7 +128,6 @@ static const char *supply_names[] = {
 /* Private data for the CS4270 */
 struct cs4270_private {
 	enum snd_soc_control_type control_type;
-	void *control_data;
 	unsigned int mclk; /* Input frequency of the MCLK pin */
 	unsigned int mode; /* The mode (I2S or left-justified) */
 	unsigned int slave_mode;
@@ -490,8 +489,6 @@ static int cs4270_probe(struct snd_soc_codec *codec)
 	struct cs4270_private *cs4270 = snd_soc_codec_get_drvdata(codec);
 	int i, ret;
 
-	codec->control_data = cs4270->control_data;
-
 	/* Tell ASoC what kind of I/O to use to read the registers.  ASoC will
 	 * then do the I2C transactions itself.
 	 */
@@ -604,7 +601,7 @@ static int cs4270_soc_suspend(struct snd_soc_codec *codec, pm_message_t mesg)
 static int cs4270_soc_resume(struct snd_soc_codec *codec)
 {
 	struct cs4270_private *cs4270 = snd_soc_codec_get_drvdata(codec);
-	struct i2c_client *i2c_client = codec->control_data;
+	struct i2c_client *i2c_client = to_i2c_client(codec->dev);
 	int reg;
 
 	regulator_bulk_enable(ARRAY_SIZE(cs4270->supplies),
@@ -690,7 +687,6 @@ static int cs4270_i2c_probe(struct i2c_client *i2c_client,
 	}
 
 	i2c_set_clientdata(i2c_client, cs4270);
-	cs4270->control_data = i2c_client;
 	cs4270->control_type = SND_SOC_I2C;
 
 	ret = snd_soc_register_codec(&i2c_client->dev,
-- 
1.7.4.1



