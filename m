Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933250Ab1BPBEq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:04:46 -0500
Received: from kroah.org ([198.145.64.141]:45887 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933199Ab1BPAuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:50:12 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:10 2011
Message-Id: <20110216002109.984913782@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:21:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [patch 109/176] ASoC: Create an AIF1ADCDAT signal widget to match AIF2
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 7f94de483f4e37e14d646ad6e85a3c82f66fb487 upstream.

Due to the different routing for AIF1 and AIF2 we weren't using a
single widget to represent the ADCDAT signal. For consistency add
one.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm8994.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -2519,18 +2519,18 @@ SND_SOC_DAPM_SUPPLY("DSPINTCLK", WM8994_
 SND_SOC_DAPM_SUPPLY("AIF1CLK", WM8994_AIF1_CLOCKING_1, 0, 0, NULL, 0),
 SND_SOC_DAPM_SUPPLY("AIF2CLK", WM8994_AIF2_CLOCKING_1, 0, 0, NULL, 0),
 
-SND_SOC_DAPM_AIF_OUT("AIF1ADC1L", "AIF1 Capture",
+SND_SOC_DAPM_AIF_OUT("AIF1ADC1L", NULL,
 		     0, WM8994_POWER_MANAGEMENT_4, 9, 0),
-SND_SOC_DAPM_AIF_OUT("AIF1ADC1R", "AIF1 Capture",
+SND_SOC_DAPM_AIF_OUT("AIF1ADC1R", NULL,
 		     0, WM8994_POWER_MANAGEMENT_4, 8, 0),
 SND_SOC_DAPM_AIF_IN("AIF1DAC1L", NULL, 0,
 		    WM8994_POWER_MANAGEMENT_5, 9, 0),
 SND_SOC_DAPM_AIF_IN("AIF1DAC1R", NULL, 0,
 		    WM8994_POWER_MANAGEMENT_5, 8, 0),
 
-SND_SOC_DAPM_AIF_OUT("AIF1ADC2L", "AIF1 Capture",
+SND_SOC_DAPM_AIF_OUT("AIF1ADC2L", NULL,
 		     0, WM8994_POWER_MANAGEMENT_4, 11, 0),
-SND_SOC_DAPM_AIF_OUT("AIF1ADC2R", "AIF1 Capture",
+SND_SOC_DAPM_AIF_OUT("AIF1ADC2R", NULL,
 		     0, WM8994_POWER_MANAGEMENT_4, 10, 0),
 SND_SOC_DAPM_AIF_IN("AIF1DAC2L", NULL, 0,
 		    WM8994_POWER_MANAGEMENT_5, 11, 0),
@@ -2571,6 +2571,7 @@ SND_SOC_DAPM_AIF_IN("AIF2DACR", NULL, 0,
 
 SND_SOC_DAPM_AIF_IN("AIF1DACDAT", "AIF1 Playback", 0, SND_SOC_NOPM, 0, 0),
 SND_SOC_DAPM_AIF_IN("AIF2DACDAT", "AIF2 Playback", 0, SND_SOC_NOPM, 0, 0),
+SND_SOC_DAPM_AIF_OUT("AIF1ADCDAT", "AIF1 Capture", 0, SND_SOC_NOPM, 0, 0),
 SND_SOC_DAPM_AIF_OUT("AIF2ADCDAT", "AIF2 Capture", 0, SND_SOC_NOPM, 0, 0),
 
 SND_SOC_DAPM_MUX("AIF1DAC Mux", SND_SOC_NOPM, 0, 0, &aif1dac_mux),
@@ -2766,6 +2767,11 @@ static const struct snd_soc_dapm_route i
 	{ "AIF2DAC2R Mixer", "Left Sidetone Switch", "Left Sidetone" },
 	{ "AIF2DAC2R Mixer", "Right Sidetone Switch", "Right Sidetone" },
 
+	{ "AIF1ADCDAT", NULL, "AIF1ADC1L" },
+	{ "AIF1ADCDAT", NULL, "AIF1ADC1R" },
+	{ "AIF1ADCDAT", NULL, "AIF1ADC2L" },
+	{ "AIF1ADCDAT", NULL, "AIF1ADC2R" },
+
 	{ "AIF2ADCDAT", NULL, "AIF2ADC Mux" },
 
 	/* AIF3 output */


