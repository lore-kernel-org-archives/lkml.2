Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162Ab1JFG7P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 02:59:15 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:35663 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755720Ab1JFG7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 02:59:13 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [PATCH] ASoC: Replace remaining use of *_volsw_2r with *_volsw
Date: Thu,  6 Oct 2011 09:59:12 +0300
Message-Id: <1317884352-17067-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <20111006132204.29c84ed7349daf8c4aa39c3b@canb.auug.org.au>
References: <20111006132204.29c84ed7349daf8c4aa39c3b@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The snd_soc_*_volsw_2r functionality has been merged to
*volsw callbacks.
Few places still used the get, or put variant of volsw_2r,
replace those with the corresponding *_volsw.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---

Hello Stephen, Mark,

It would be better to take this patch instead of the previous
"ASoC: fix codec breakage caused by the volsw/volsw_2r merger"
patch, so we do not need to remove the defines in a coming patch.

Thank you, and again sorry about the breakage.

Regards,
Peter

 sound/soc/codecs/wm8350.c  |    4 ++--
 sound/soc/codecs/wm8580.c  |    8 ++++----
 sound/soc/codecs/wm_hubs.c |    4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/sound/soc/codecs/wm8350.c b/sound/soc/codecs/wm8350.c
index 50ea9d7..35f3ad8 100644
--- a/sound/soc/codecs/wm8350.c
+++ b/sound/soc/codecs/wm8350.c
@@ -355,7 +355,7 @@ static int wm8350_put_volsw_2r_vu(struct snd_kcontrol *kcontrol,
 			return 1;
 	}
 
-	ret = snd_soc_put_volsw_2r(kcontrol, ucontrol);
+	ret = snd_soc_put_volsw(kcontrol, ucontrol);
 	if (ret < 0)
 		return ret;
 
@@ -392,7 +392,7 @@ static int wm8350_get_volsw_2r(struct snd_kcontrol *kcontrol,
 		break;
 	}
 
-	return snd_soc_get_volsw_2r(kcontrol, ucontrol);
+	return snd_soc_get_volsw(kcontrol, ucontrol);
 }
 
 static const char *wm8350_deemp[] = { "None", "32kHz", "44.1kHz", "48kHz" };
diff --git a/sound/soc/codecs/wm8580.c b/sound/soc/codecs/wm8580.c
index 02cbf13..b256727 100644
--- a/sound/soc/codecs/wm8580.c
+++ b/sound/soc/codecs/wm8580.c
@@ -213,7 +213,7 @@ static int wm8580_out_vu(struct snd_kcontrol *kcontrol,
 	reg_cache[reg] = 0;
 	reg_cache[reg2] = 0;
 
-	ret = snd_soc_put_volsw_2r(kcontrol, ucontrol);
+	ret = snd_soc_put_volsw(kcontrol, ucontrol);
 	if (ret < 0)
 		return ret;
 
@@ -228,15 +228,15 @@ static const struct snd_kcontrol_new wm8580_snd_controls[] = {
 SOC_DOUBLE_R_EXT_TLV("DAC1 Playback Volume",
 		     WM8580_DIGITAL_ATTENUATION_DACL1,
 		     WM8580_DIGITAL_ATTENUATION_DACR1,
-		     0, 0xff, 0, snd_soc_get_volsw_2r, wm8580_out_vu, dac_tlv),
+		     0, 0xff, 0, snd_soc_get_volsw, wm8580_out_vu, dac_tlv),
 SOC_DOUBLE_R_EXT_TLV("DAC2 Playback Volume",
 		     WM8580_DIGITAL_ATTENUATION_DACL2,
 		     WM8580_DIGITAL_ATTENUATION_DACR2,
-		     0, 0xff, 0, snd_soc_get_volsw_2r, wm8580_out_vu, dac_tlv),
+		     0, 0xff, 0, snd_soc_get_volsw, wm8580_out_vu, dac_tlv),
 SOC_DOUBLE_R_EXT_TLV("DAC3 Playback Volume",
 		     WM8580_DIGITAL_ATTENUATION_DACL3,
 		     WM8580_DIGITAL_ATTENUATION_DACR3,
-		     0, 0xff, 0, snd_soc_get_volsw_2r, wm8580_out_vu, dac_tlv),
+		     0, 0xff, 0, snd_soc_get_volsw, wm8580_out_vu, dac_tlv),
 
 SOC_SINGLE("DAC1 Deemphasis Switch", WM8580_DAC_CONTROL3, 0, 1, 0),
 SOC_SINGLE("DAC2 Deemphasis Switch", WM8580_DAC_CONTROL3, 1, 1, 0),
diff --git a/sound/soc/codecs/wm_hubs.c b/sound/soc/codecs/wm_hubs.c
index f3583a5..84f33d4 100644
--- a/sound/soc/codecs/wm_hubs.c
+++ b/sound/soc/codecs/wm_hubs.c
@@ -222,7 +222,7 @@ static int wm8993_put_dc_servo(struct snd_kcontrol *kcontrol,
 	struct wm_hubs_data *hubs = snd_soc_codec_get_drvdata(codec);
 	int ret;
 
-	ret = snd_soc_put_volsw_2r(kcontrol, ucontrol);
+	ret = snd_soc_put_volsw(kcontrol, ucontrol);
 
 	/* Updating the analogue gains invalidates the DC servo cache */
 	hubs->class_w_dcs = 0;
@@ -364,7 +364,7 @@ SOC_ENUM("Speaker Mode", speaker_mode),
 
 SOC_DOUBLE_R_EXT_TLV("Headphone Volume",
 		     WM8993_LEFT_OUTPUT_VOLUME, WM8993_RIGHT_OUTPUT_VOLUME,
-		     0, 63, 0, snd_soc_get_volsw_2r, wm8993_put_dc_servo,
+		     0, 63, 0, snd_soc_get_volsw, wm8993_put_dc_servo,
 		     outpga_tlv),
 
 SOC_DOUBLE_R("Headphone Switch", WM8993_LEFT_OUTPUT_VOLUME,
-- 
1.7.7

