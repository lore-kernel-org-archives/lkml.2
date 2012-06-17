Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758960Ab2FQS0r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:26:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50384 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758436Ab2FQSXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:23:00 -0400
Message-Id: <20120617175945.438702061@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 19:00:10 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 29/69] ASoC: wm8994: Ensure all AIFnCLK events are run from the _late
 variants
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit c8fdc1b56611faa7b38eab6b99da5e20113661ff upstream.

Ensure that all the actions get taken at appropriate times by calling the
_PRE and _POST events for the aifNclk_ev functions explicitly.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/soc/codecs/wm8994.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 993639d..6d3a865 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -1190,17 +1190,19 @@ static int late_enable_ev(struct snd_soc_dapm_widget *w,
 	switch (event) {
 	case SND_SOC_DAPM_PRE_PMU:
 		if (wm8994->aif1clk_enable) {
-			aif1clk_ev(w, kcontrol, event);
+			aif1clk_ev(w, kcontrol, SND_SOC_DAPM_PRE_PMU);
 			snd_soc_update_bits(codec, WM8994_AIF1_CLOCKING_1,
 					    WM8994_AIF1CLK_ENA_MASK,
 					    WM8994_AIF1CLK_ENA);
+			aif1clk_ev(w, kcontrol, SND_SOC_DAPM_POST_PMU);
 			wm8994->aif1clk_enable = 0;
 		}
 		if (wm8994->aif2clk_enable) {
-			aif2clk_ev(w, kcontrol, event);
+			aif2clk_ev(w, kcontrol, SND_SOC_DAPM_PRE_PMU);
 			snd_soc_update_bits(codec, WM8994_AIF2_CLOCKING_1,
 					    WM8994_AIF2CLK_ENA_MASK,
 					    WM8994_AIF2CLK_ENA);
+			aif2clk_ev(w, kcontrol, SND_SOC_DAPM_POST_PMU);
 			wm8994->aif2clk_enable = 0;
 		}
 		break;
@@ -1221,15 +1223,17 @@ static int late_disable_ev(struct snd_soc_dapm_widget *w,
 	switch (event) {
 	case SND_SOC_DAPM_POST_PMD:
 		if (wm8994->aif1clk_disable) {
+			aif1clk_ev(w, kcontrol, SND_SOC_DAPM_PRE_PMD);
 			snd_soc_update_bits(codec, WM8994_AIF1_CLOCKING_1,
 					    WM8994_AIF1CLK_ENA_MASK, 0);
-			aif1clk_ev(w, kcontrol, event);
+			aif1clk_ev(w, kcontrol, SND_SOC_DAPM_POST_PMD);
 			wm8994->aif1clk_disable = 0;
 		}
 		if (wm8994->aif2clk_disable) {
+			aif2clk_ev(w, kcontrol, SND_SOC_DAPM_PRE_PMD);
 			snd_soc_update_bits(codec, WM8994_AIF2_CLOCKING_1,
 					    WM8994_AIF2CLK_ENA_MASK, 0);
-			aif2clk_ev(w, kcontrol, event);
+			aif2clk_ev(w, kcontrol, SND_SOC_DAPM_POST_PMD);
 			wm8994->aif2clk_disable = 0;
 		}
 		break;


