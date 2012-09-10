Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347Ab2IJKqy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 06:46:54 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:51800 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757302Ab2IJKqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 06:46:46 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Tero Kristo <t-kristo@ti.com>, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, Benoit Cousson <b-cousson@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 11/14] ASoC/MFD: twl4030: Remove set_hs_extmute callback from platform data
Date: Mon, 10 Sep 2012 13:46:29 +0300
Message-Id: <1347273992-9107-12-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347273992-9107-1-git-send-email-peter.ujfalusi@ti.com>
References: <1347273992-9107-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We no longer have users for the set_hs_extmute callback which has been
replaced by hs_extmute_gpio so the codec driver can handle the external
mute if it is needed by the board.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 include/linux/i2c/twl.h    | 2 --
 sound/soc/codecs/twl4030.c | 6 ------
 2 files changed, 8 deletions(-)

diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index 2040309..a4885a6 100644
--- a/include/linux/i2c/twl.h
+++ b/include/linux/i2c/twl.h
@@ -667,8 +667,6 @@ struct twl4030_codec_data {
 	unsigned int check_defaults:1;
 	unsigned int reset_registers:1;
 	unsigned int hs_extmute:1;
-	void (*set_hs_extmute)(int mute); /* Deprecated, use hs_extmute_gpio and
-					     hs_extmute_disable_level */
 	int hs_extmute_gpio;
 };
 
diff --git a/sound/soc/codecs/twl4030.c b/sound/soc/codecs/twl4030.c
index 5fc271a..27ccea4 100644
--- a/sound/soc/codecs/twl4030.c
+++ b/sound/soc/codecs/twl4030.c
@@ -767,9 +767,6 @@ static void headset_ramp(struct snd_soc_codec *codec, int ramp)
 	if (pdata && pdata->hs_extmute) {
 		if (gpio_is_valid(pdata->hs_extmute_gpio)) {
 			gpio_set_value(pdata->hs_extmute_gpio, 1);
-		} else if (pdata->set_hs_extmute) {
-			dev_warn(codec->dev, "set_hs_extmute is deprecated\n");
-			pdata->set_hs_extmute(1);
 		} else {
 			hs_pop |= TWL4030_EXTMUTE;
 			twl4030_write(codec, TWL4030_REG_HS_POPN_SET, hs_pop);
@@ -808,9 +805,6 @@ static void headset_ramp(struct snd_soc_codec *codec, int ramp)
 	if (pdata && pdata->hs_extmute) {
 		if (gpio_is_valid(pdata->hs_extmute_gpio)) {
 			gpio_set_value(pdata->hs_extmute_gpio, 0);
-		} else if (pdata->set_hs_extmute) {
-			dev_warn(codec->dev, "set_hs_extmute is deprecated\n");
-			pdata->set_hs_extmute(0);
 		} else {
 			hs_pop &= ~TWL4030_EXTMUTE;
 			twl4030_write(codec, TWL4030_REG_HS_POPN_SET, hs_pop);
-- 
1.7.12

