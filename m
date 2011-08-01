Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab1HAXeb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:34:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38607 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913Ab1HAX0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:26:20 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:55 2011
Message-Id: <20110801232055.247589239@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:19:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [46/70] ASoC: Correct WM8994 MICBIAS supply widget hookup
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit b793eb60a01d5b5e4aaeb2fbc2b036dec0d9f84d upstream.

The WM8994 and WM8958 series of devices have two MICBIAS supplies rather
than one, the current widget actually manages the microphone detection
control register bit (which is managed separately by the relevant API).

Fix this, hooking the relevant supplies up to the MICBIAS1 and MICBIAS2
widgets.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm8994.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -1446,7 +1446,6 @@ SND_SOC_DAPM_INPUT("DMIC1DAT"),
 SND_SOC_DAPM_INPUT("DMIC2DAT"),
 SND_SOC_DAPM_INPUT("Clock"),
 
-SND_SOC_DAPM_MICBIAS("MICBIAS", WM8994_MICBIAS, 2, 0),
 SND_SOC_DAPM_SUPPLY_S("MICBIAS Supply", 1, SND_SOC_NOPM, 0, 0, micbias_ev,
 		      SND_SOC_DAPM_PRE_PMU),
 
@@ -1765,8 +1764,10 @@ static const struct snd_soc_dapm_route w
 	{ "AIF2DACDAT", NULL, "AIF1DACDAT" },
 	{ "AIF1ADCDAT", NULL, "AIF2ADCDAT" },
 	{ "AIF2ADCDAT", NULL, "AIF1ADCDAT" },
-	{ "MICBIAS", NULL, "CLK_SYS" },
-	{ "MICBIAS", NULL, "MICBIAS Supply" },
+	{ "MICBIAS1", NULL, "CLK_SYS" },
+	{ "MICBIAS1", NULL, "MICBIAS Supply" },
+	{ "MICBIAS2", NULL, "CLK_SYS" },
+	{ "MICBIAS2", NULL, "MICBIAS Supply" },
 };
 
 static const struct snd_soc_dapm_route wm8994_intercon[] = {


