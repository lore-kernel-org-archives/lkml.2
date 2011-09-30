Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab1I3Ccx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 22:32:53 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:61586 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab1I3Ccw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 22:32:52 -0400
Subject: [PATCH 2/2] ASoC: Remove unused "control_data" field of struct
 aic3x_priv
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Vladimir Barinov <vova.barinov@gmail.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org
In-Reply-To: <1317349870.4193.1.camel@phoenix>
References: <1317349870.4193.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Sep 2011 10:32:37 +0800
Message-ID: <1317349957.4193.3.camel@phoenix>
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
 sound/soc/codecs/tlv320aic3x.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/tlv320aic3x.c b/sound/soc/codecs/tlv320aic3x.c
index 0963c4c..4c5eab5 100644
--- a/sound/soc/codecs/tlv320aic3x.c
+++ b/sound/soc/codecs/tlv320aic3x.c
@@ -76,7 +76,6 @@ struct aic3x_priv {
 	struct aic3x_disable_nb disable_nb[AIC3X_NUM_SUPPLIES];
 	enum snd_soc_control_type control_type;
 	struct aic3x_setup_data *setup;
-	void *control_data;
 	unsigned int sysclk;
 	struct list_head list;
 	int master;
@@ -1383,7 +1382,6 @@ static int aic3x_probe(struct snd_soc_codec *codec)
 	int ret, i;
 
 	INIT_LIST_HEAD(&aic3x->list);
-	codec->control_data = aic3x->control_data;
 	aic3x->codec = codec;
 	codec->dapm.idle_bias_off = 1;
 
@@ -1520,7 +1518,6 @@ static int aic3x_i2c_probe(struct i2c_client *i2c,
 		return -ENOMEM;
 	}
 
-	aic3x->control_data = i2c;
 	aic3x->control_type = SND_SOC_I2C;
 
 	i2c_set_clientdata(i2c, aic3x);
-- 
1.7.4.1



