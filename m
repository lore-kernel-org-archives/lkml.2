Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933608Ab1IOMkx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 08:40:53 -0400
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:37005 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933530Ab1IOMkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 08:40:43 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>
Subject: [PATCH 14/17] ASoC: twl6040: Support for AUX L/R output
Date: Thu, 15 Sep 2011 15:39:36 +0300
Message-Id: <1316090379-30760-15-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
References: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AUX L/R outputs can be driver from the Handsfree PGA output.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/codecs/twl6040.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/twl6040.c b/sound/soc/codecs/twl6040.c
index 035803c..891b9ec 100644
--- a/sound/soc/codecs/twl6040.c
+++ b/sound/soc/codecs/twl6040.c
@@ -993,6 +993,12 @@ static const struct snd_kcontrol_new hfr_mux_controls =
 static const struct snd_kcontrol_new ep_path_enable_control =
 	SOC_DAPM_SINGLE("Switch", TWL6040_REG_SW_SHADOW, 0, 1, 0);
 
+static const struct snd_kcontrol_new auxl_switch_control =
+	SOC_DAPM_SINGLE("Switch", TWL6040_REG_HFLCTL, 6, 1, 0);
+
+static const struct snd_kcontrol_new auxr_switch_control =
+	SOC_DAPM_SINGLE("Switch", TWL6040_REG_HFRCTL, 6, 1, 0);
+
 /* Headset power mode */
 static const char *twl6040_power_mode_texts[] = {
 	"Low-Power", "High-Perfomance",
@@ -1101,6 +1107,8 @@ static const struct snd_soc_dapm_widget twl6040_dapm_widgets[] = {
 	SND_SOC_DAPM_OUTPUT("HFL"),
 	SND_SOC_DAPM_OUTPUT("HFR"),
 	SND_SOC_DAPM_OUTPUT("EP"),
+	SND_SOC_DAPM_OUTPUT("AUXL"),
+	SND_SOC_DAPM_OUTPUT("AUXR"),
 
 	/* Analog input muxes for the capture amplifiers */
 	SND_SOC_DAPM_MUX("Analog Left Capture Route",
@@ -1166,6 +1174,10 @@ static const struct snd_soc_dapm_widget twl6040_dapm_widgets[] = {
 
 	SND_SOC_DAPM_SWITCH("Earphone Playback", SND_SOC_NOPM, 0, 0,
 			&ep_path_enable_control),
+	SND_SOC_DAPM_SWITCH("AUXL Playback", SND_SOC_NOPM, 0, 0,
+			&auxl_switch_control),
+	SND_SOC_DAPM_SWITCH("AUXR Playback", SND_SOC_NOPM, 0, 0,
+			&auxr_switch_control),
 
 	/* Analog playback drivers */
 	SND_SOC_DAPM_OUT_DRV_E("HF Left Driver",
@@ -1248,6 +1260,12 @@ static const struct snd_soc_dapm_route intercon[] = {
 
 	{"HFL", NULL, "HF Left Driver"},
 	{"HFR", NULL, "HF Right Driver"},
+
+	{"AUXL Playback", "Switch", "HF Left PGA"},
+	{"AUXR Playback", "Switch", "HF Right PGA"},
+
+	{"AUXL", NULL, "AUXL Playback"},
+	{"AUXR", NULL, "AUXR Playback"},
 };
 
 static int twl6040_add_widgets(struct snd_soc_codec *codec)
-- 
1.7.6.1

