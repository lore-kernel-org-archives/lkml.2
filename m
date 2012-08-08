Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030338Ab2HHJnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 05:43:24 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:56491 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964926Ab2HHJmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 05:42:06 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Dmitry Torokhov <dtor@mail.ru>
Cc: alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Benoit Cousson <b-cousson@ti.com>
Subject: [PATCH 08/11] ASoC/MFD: twl4030: Remove set_hs_extmute callback from platform data
Date: Wed,  8 Aug 2012 12:41:24 +0300
Message-Id: <1344418887-5262-9-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1344418887-5262-1-git-send-email-peter.ujfalusi@ti.com>
References: <1344418887-5262-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We no longer have users for the set_hs_extmute callback which has been
replaced by hs_extmute_gpio/hs_extmute_disable_level parameters so the
codec driver can handle the external mute if it is needed by the board.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 include/linux/i2c/twl.h    |    2 --
 sound/soc/codecs/twl4030.c |    6 ------
 2 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index 75ce6d1..c9c1fd2 100644
--- a/include/linux/i2c/twl.h
+++ b/include/linux/i2c/twl.h
@@ -666,8 +666,6 @@ struct twl4030_codec_data {
 	unsigned int check_defaults:1;
 	unsigned int reset_registers:1;
 	unsigned int hs_extmute:1;
-	void (*set_hs_extmute)(int mute); /* Deprecated, use hs_extmute_gpio and
-					     hs_extmute_disable_level */
 	int hs_extmute_gpio;
 	unsigned int hs_extmute_disable_level:1; /* the GPIO state to disable
 						    the extmute */
diff --git a/sound/soc/codecs/twl4030.c b/sound/soc/codecs/twl4030.c
index 0630040..1247c4a 100644
--- a/sound/soc/codecs/twl4030.c
+++ b/sound/soc/codecs/twl4030.c
@@ -770,9 +770,6 @@ static void headset_ramp(struct snd_soc_codec *codec, int ramp)
 		if (gpio_is_valid(pdata->hs_extmute_gpio)) {
 			gpio_set_value(pdata->hs_extmute_gpio,
 				       !pdata->hs_extmute_disable_level);
-		} else if (pdata->set_hs_extmute) {
-			dev_warn(codec->dev, "set_hs_extmute is deprecated\n");
-			pdata->set_hs_extmute(1);
 		} else {
 			hs_pop |= TWL4030_EXTMUTE;
 			twl4030_write(codec, TWL4030_REG_HS_POPN_SET, hs_pop);
@@ -812,9 +809,6 @@ static void headset_ramp(struct snd_soc_codec *codec, int ramp)
 		if (gpio_is_valid(pdata->hs_extmute_gpio)) {
 			gpio_set_value(pdata->hs_extmute_gpio,
 				       pdata->hs_extmute_disable_level);
-		} else if (pdata->set_hs_extmute) {
-			dev_warn(codec->dev, "set_hs_extmute is deprecated\n");
-			pdata->set_hs_extmute(0);
 		} else {
 			hs_pop &= ~TWL4030_EXTMUTE;
 			twl4030_write(codec, TWL4030_REG_HS_POPN_SET, hs_pop);
-- 
1.7.8.6

