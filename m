Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab2HNOZy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 10:25:54 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:54834 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756166Ab2HNOXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 10:23:19 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Tero Kristo <t-kristo@ti.com>, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, Benoit Cousson <b-cousson@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 12/14] ASoC: twl4030: Convert to use devm_kzalloc
Date: Tue, 14 Aug 2012 17:22:40 +0300
Message-Id: <1344954162-7985-13-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1344954162-7985-1-git-send-email-peter.ujfalusi@ti.com>
References: <1344954162-7985-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allocate the private data with devm_kzalloc.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/codecs/twl4030.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/twl4030.c b/sound/soc/codecs/twl4030.c
index 27ccea4..413e698 100644
--- a/sound/soc/codecs/twl4030.c
+++ b/sound/soc/codecs/twl4030.c
@@ -2231,7 +2231,8 @@ static int twl4030_soc_probe(struct snd_soc_codec *codec)
 {
 	struct twl4030_priv *twl4030;
 
-	twl4030 = kzalloc(sizeof(struct twl4030_priv), GFP_KERNEL);
+	twl4030 = devm_kzalloc(codec->dev, sizeof(struct twl4030_priv),
+			       GFP_KERNEL);
 	if (twl4030 == NULL) {
 		dev_err(codec->dev, "Can not allocate memory\n");
 		return -ENOMEM;
@@ -2253,7 +2254,6 @@ static int twl4030_soc_remove(struct snd_soc_codec *codec)
 	/* Reset registers to their chip default before leaving */
 	twl4030_reset_registers(codec);
 	twl4030_set_bias_level(codec, SND_SOC_BIAS_OFF);
-	kfree(twl4030);
 
 	if (pdata && pdata->hs_extmute && gpio_is_valid(pdata->hs_extmute_gpio))
 		gpio_free(pdata->hs_extmute_gpio);
-- 
1.7.8.6

