Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab2FOAAH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 20:00:07 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45611 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756867Ab2FOAAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 20:00:01 -0400
Message-Id: <20120614235625.948416564@linuxfoundation.org>
User-Agent: quilt/0.60-20.1
Date: Thu, 14 Jun 2012 16:56:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 23/42] ASoC: wm8994: Ensure all AIFnCLK events are run from the _late variants
In-Reply-To: <20120614235636.GA5275@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit c8fdc1b56611faa7b38eab6b99da5e20113661ff upstream.

Ensure that all the actions get taken at appropriate times by calling the
_PRE and _POST events for the aifNclk_ev functions explicitly.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm8994.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -1207,17 +1207,19 @@ static int late_enable_ev(struct snd_soc
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
@@ -1238,15 +1240,17 @@ static int late_disable_ev(struct snd_so
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


