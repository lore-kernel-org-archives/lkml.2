Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab1CUXx5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:53:57 -0400
Received: from kroah.org ([198.145.64.141]:49234 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755212Ab1CUXPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:15:04 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:07:09 2011
Message-Id: <20110321230709.887686478@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:06:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [07/87] ASoC: Fix broken bitfield definitions in WM8978
In-Reply-To: <20110321230732.GA26510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 823dba5191220fc94b83dc0b3f2178ff0842e294 upstream.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm8978.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/sound/soc/codecs/wm8978.c
+++ b/sound/soc/codecs/wm8978.c
@@ -147,18 +147,18 @@ static const struct snd_kcontrol_new wm8
 	SOC_SINGLE("DAC Playback Limiter Threshold",
 		WM8978_DAC_LIMITER_2, 4, 7, 0),
 	SOC_SINGLE("DAC Playback Limiter Boost",
-		WM8978_DAC_LIMITER_2, 0, 15, 0),
+		WM8978_DAC_LIMITER_2, 0, 12, 0),
 
 	SOC_ENUM("ALC Enable Switch", alc1),
 	SOC_SINGLE("ALC Capture Min Gain", WM8978_ALC_CONTROL_1, 0, 7, 0),
 	SOC_SINGLE("ALC Capture Max Gain", WM8978_ALC_CONTROL_1, 3, 7, 0),
 
-	SOC_SINGLE("ALC Capture Hold", WM8978_ALC_CONTROL_2, 4, 7, 0),
+	SOC_SINGLE("ALC Capture Hold", WM8978_ALC_CONTROL_2, 4, 10, 0),
 	SOC_SINGLE("ALC Capture Target", WM8978_ALC_CONTROL_2, 0, 15, 0),
 
 	SOC_ENUM("ALC Capture Mode", alc3),
-	SOC_SINGLE("ALC Capture Decay", WM8978_ALC_CONTROL_3, 4, 15, 0),
-	SOC_SINGLE("ALC Capture Attack", WM8978_ALC_CONTROL_3, 0, 15, 0),
+	SOC_SINGLE("ALC Capture Decay", WM8978_ALC_CONTROL_3, 4, 10, 0),
+	SOC_SINGLE("ALC Capture Attack", WM8978_ALC_CONTROL_3, 0, 10, 0),
 
 	SOC_SINGLE("ALC Capture Noise Gate Switch", WM8978_NOISE_GATE, 3, 1, 0),
 	SOC_SINGLE("ALC Capture Noise Gate Threshold",
@@ -213,8 +213,10 @@ static const struct snd_kcontrol_new wm8
 		WM8978_LOUT2_SPK_CONTROL, WM8978_ROUT2_SPK_CONTROL, 6, 1, 1),
 
 	/* DAC / ADC oversampling */
-	SOC_SINGLE("DAC 128x Oversampling Switch", WM8978_DAC_CONTROL, 8, 1, 0),
-	SOC_SINGLE("ADC 128x Oversampling Switch", WM8978_ADC_CONTROL, 8, 1, 0),
+	SOC_SINGLE("DAC 128x Oversampling Switch", WM8978_DAC_CONTROL,
+		   5, 1, 0),
+	SOC_SINGLE("ADC 128x Oversampling Switch", WM8978_ADC_CONTROL,
+		   5, 1, 0),
 };
 
 /* Mixer #1: Output (OUT1, OUT2) Mixer: mix AUX, Input mixer output and DAC */


