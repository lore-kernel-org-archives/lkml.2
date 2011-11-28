Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab1K1Q1Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 11:27:24 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:18803
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753699Ab1K1Q1V (ORCPT
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
Subject: [PATCH 4/7] ASoC: ad193X: Remove non-functional DAPM route controls
Date: Mon, 28 Nov 2011 17:28:09 +0100
Message-ID: <1322497692-27868-4-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1322497692-27868-1-git-send-email-lars@metafoo.de>
References: <1322497692-27868-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DAPM route controls only take effect on paths where the sink is a mixer or a
mux, furthermore the control must be a control assigned to the mixer or mux.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 sound/soc/codecs/ad193x.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/ad193x.c b/sound/soc/codecs/ad193x.c
index 665af5c..c52ebd3 100644
--- a/sound/soc/codecs/ad193x.c
+++ b/sound/soc/codecs/ad193x.c
@@ -90,12 +90,12 @@ static const struct snd_soc_dapm_route audio_paths[] = {
 	{ "ADC", NULL, "PLL_PWR" },
 	{ "DAC", NULL, "ADC_PWR" },
 	{ "ADC", NULL, "ADC_PWR" },
-	{ "DAC1OUT", "DAC1 Switch", "DAC" },
-	{ "DAC2OUT", "DAC2 Switch", "DAC" },
-	{ "DAC3OUT", "DAC3 Switch", "DAC" },
-	{ "DAC4OUT", "DAC4 Switch", "DAC" },
-	{ "ADC", "ADC1 Switch", "ADC1IN" },
-	{ "ADC", "ADC2 Switch", "ADC2IN" },
+	{ "DAC1OUT", NULL, "DAC" },
+	{ "DAC2OUT", NULL, "DAC" },
+	{ "DAC3OUT", NULL, "DAC" },
+	{ "DAC4OUT", NULL, "DAC" },
+	{ "ADC", NULL, "ADC1IN" },
+	{ "ADC", NULL, "ADC2IN" },
 };
 
 /*
-- 
1.7.7.3


