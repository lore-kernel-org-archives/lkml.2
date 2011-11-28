Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab1K1Q1X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 11:27:23 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:21513
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753689Ab1K1Q1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 11:27:21 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzzz2dh87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-SS: 13,
X-FB-DOMAIN-IP-MATCH: fail
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
CC: <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <drivers@analog.com>, <device-drivers-devel@blackfin.uclinux.org>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 5/7] ASOC: AD193X: Add sysclk DAPM supply
Date: Mon, 28 Nov 2011 17:28:10 +0100
Message-ID: <1322497692-27868-5-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1322497692-27868-1-git-send-email-lars@metafoo.de>
References: <1322497692-27868-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a DAPM supply widget for the internal sysclk, so it can be disabled
automatically when not needed.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 sound/soc/codecs/ad193x.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/ad193x.c b/sound/soc/codecs/ad193x.c
index c52ebd3..c19e223 100644
--- a/sound/soc/codecs/ad193x.c
+++ b/sound/soc/codecs/ad193x.c
@@ -77,6 +77,7 @@ static const struct snd_soc_dapm_widget ad193x_dapm_widgets[] = {
 	SND_SOC_DAPM_ADC("ADC", "Capture", SND_SOC_NOPM, 0, 0),
 	SND_SOC_DAPM_SUPPLY("PLL_PWR", AD193X_PLL_CLK_CTRL0, 0, 1, NULL, 0),
 	SND_SOC_DAPM_SUPPLY("ADC_PWR", AD193X_ADC_CTRL0, 0, 1, NULL, 0),
+	SND_SOC_DAPM_SUPPLY("SYSCLK", AD193X_PLL_CLK_CTRL0, 7, 0, NULL, 0),
 	SND_SOC_DAPM_OUTPUT("DAC1OUT"),
 	SND_SOC_DAPM_OUTPUT("DAC2OUT"),
 	SND_SOC_DAPM_OUTPUT("DAC3OUT"),
@@ -86,8 +87,8 @@ static const struct snd_soc_dapm_widget ad193x_dapm_widgets[] = {
 };
 
 static const struct snd_soc_dapm_route audio_paths[] = {
-	{ "DAC", NULL, "PLL_PWR" },
-	{ "ADC", NULL, "PLL_PWR" },
+	{ "DAC", NULL, "SYSCLK" },
+	{ "ADC", NULL, "SYSCLK" },
 	{ "DAC", NULL, "ADC_PWR" },
 	{ "ADC", NULL, "ADC_PWR" },
 	{ "DAC1OUT", NULL, "DAC" },
@@ -96,6 +97,7 @@ static const struct snd_soc_dapm_route audio_paths[] = {
 	{ "DAC4OUT", NULL, "DAC" },
 	{ "ADC", NULL, "ADC1IN" },
 	{ "ADC", NULL, "ADC2IN" },
+	{ "SYSCLK", NULL, "PLL_PWR" },
 };
 
 /*
-- 
1.7.7.3


