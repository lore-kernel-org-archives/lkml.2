Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933574Ab1IOMoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 08:44:15 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:44966 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756079Ab1IOMkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 08:40:42 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>
Subject: [PATCH 13/17] ASoC: twl6040: Use consistent names for Headset path
Date: Thu, 15 Sep 2011 15:39:35 +0300
Message-Id: <1316090379-30760-14-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
References: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use "Headset XYZ" for user visible controls, while the internal DAPM
widgets can use "HS XYZ".
In this way we can group the Headset related controls in UI
(alsamixer for example).

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/codecs/twl6040.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/sound/soc/codecs/twl6040.c b/sound/soc/codecs/twl6040.c
index 858bfd4..035803c 100644
--- a/sound/soc/codecs/twl6040.c
+++ b/sound/soc/codecs/twl6040.c
@@ -1159,9 +1159,9 @@ static const struct snd_soc_dapm_widget twl6040_dapm_widgets[] = {
 	SND_SOC_DAPM_MUX("Handsfree Right Playback",
 			SND_SOC_NOPM, 0, 0, &hfr_mux_controls),
 	/* Analog playback Muxes */
-	SND_SOC_DAPM_MUX("HS Left Playback",
+	SND_SOC_DAPM_MUX("Headset Left Playback",
 			SND_SOC_NOPM, 0, 0, &hsl_mux_controls),
-	SND_SOC_DAPM_MUX("HS Right Playback",
+	SND_SOC_DAPM_MUX("Headset Right Playback",
 			SND_SOC_NOPM, 0, 0, &hsr_mux_controls),
 
 	SND_SOC_DAPM_SWITCH("Earphone Playback", SND_SOC_NOPM, 0, 0,
@@ -1176,11 +1176,11 @@ static const struct snd_soc_dapm_widget twl6040_dapm_widgets[] = {
 			TWL6040_REG_HFRCTL, 4, 0, NULL, 0,
 			pga_event,
 			SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_PRE_PMD),
-	SND_SOC_DAPM_OUT_DRV_E("Headset Left Driver",
+	SND_SOC_DAPM_OUT_DRV_E("HS Left Driver",
 			TWL6040_REG_HSLCTL, 2, 0, NULL, 0,
 			pga_event,
 			SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_PRE_PMD),
-	SND_SOC_DAPM_OUT_DRV_E("Headset Right Driver",
+	SND_SOC_DAPM_OUT_DRV_E("HS Right Driver",
 			TWL6040_REG_HSRCTL, 2, 0, NULL, 0,
 			pga_event,
 			SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_PRE_PMD),
@@ -1217,17 +1217,17 @@ static const struct snd_soc_dapm_route intercon[] = {
 	{"AFMAmpL", NULL, "AFML"},
 	{"AFMAmpR", NULL, "AFMR"},
 
-	{"HS Left Playback", "HS DAC", "HSDAC Left"},
-	{"HS Left Playback", "Line-In amp", "AFMAmpL"},
+	{"Headset Left Playback", "HS DAC", "HSDAC Left"},
+	{"Headset Left Playback", "Line-In amp", "AFMAmpL"},
 
-	{"HS Right Playback", "HS DAC", "HSDAC Right"},
-	{"HS Right Playback", "Line-In amp", "AFMAmpR"},
+	{"Headset Right Playback", "HS DAC", "HSDAC Right"},
+	{"Headset Right Playback", "Line-In amp", "AFMAmpR"},
 
-	{"Headset Left Driver", NULL, "HS Left Playback"},
-	{"Headset Right Driver", NULL, "HS Right Playback"},
+	{"HS Left Driver", NULL, "Headset Left Playback"},
+	{"HS Right Driver", NULL, "Headset Right Playback"},
 
-	{"HSOL", NULL, "Headset Left Driver"},
-	{"HSOR", NULL, "Headset Right Driver"},
+	{"HSOL", NULL, "HS Left Driver"},
+	{"HSOR", NULL, "HS Right Driver"},
 
 	/* Earphone playback path */
 	{"Earphone Playback", "Switch", "HSDAC Left"},
-- 
1.7.6.1

