Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516Ab1I2EKK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 00:10:10 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:55282 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab1I2EKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 00:10:09 -0400
Subject: [PATCH] ASoC: tlv320dac33: Add guarding parentheses to macros
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Sep 2011 12:09:57 +0800
Message-ID: <1317269397.4561.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Put parentheses around macro argument uses. This avoids pitfalls
for the programmer, where the argument expansion does not give the
expected result, for example:

SAMPLES_TO_US(substream->runtime->rate, dac33->uthr - DAC33_MODE7_MARGIN + 1);

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/tlv320dac33.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/tlv320dac33.c b/sound/soc/codecs/tlv320dac33.c
index 243d177..389b1c2 100644
--- a/sound/soc/codecs/tlv320dac33.c
+++ b/sound/soc/codecs/tlv320dac33.c
@@ -55,13 +55,13 @@
 #define BURST_BASEFREQ_HZ	49152000
 
 #define SAMPLES_TO_US(rate, samples) \
-	(1000000000 / ((rate * 1000) / samples))
+	(1000000000 / (((rate) * 1000) / (samples)))
 
 #define US_TO_SAMPLES(rate, us) \
-	(rate / (1000000 / (us < 1000000 ? us : 1000000)))
+	((rate) / (1000000 / ((us) < 1000000 ? (us) : 1000000)))
 
 #define UTHR_FROM_PERIOD_SIZE(samples, playrate, burstrate) \
-	((samples * 5000) / ((burstrate * 5000) / (burstrate - playrate)))
+	(((samples)*5000) / (((burstrate)*5000) / ((burstrate) - (playrate))))
 
 static void dac33_calculate_times(struct snd_pcm_substream *substream);
 static int dac33_prepare_chip(struct snd_pcm_substream *substream);
-- 
1.7.4.1



