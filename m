Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952Ab2DILsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 07:48:51 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:47661 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab2DILst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 07:48:49 -0400
Message-ID: <1333972124.2569.3.camel@phoenix>
Subject: [PATCH RESEND] ASoC: Fix setting aif_val in lm49453_set_dai_fmt
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: M R Swami Reddy <mr.swami.reddy@ti.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Date: Mon, 09 Apr 2012 19:48:44 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CBS/CBM/CFS/CFM settings are controlled by BIT[3:4] of 0x60h

for example, for SND_SOC_DAIFMT_CBS_CFS: what we want is to clear both BIT[3:4].

aif_val = ~LM49453_AUDIO_PORT1_BASIC_CLK_MS | ~LM49453_AUDIO_PORT1_BASIC_SYNC_MS;
actually set both bits.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
Seems the my mail failed to reach alsa mailing list.
I resend to LKML instead.

Axel
 sound/soc/codecs/lm49453.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/lm49453.c b/sound/soc/codecs/lm49453.c
index 744063d..a25e80a 100644
--- a/sound/soc/codecs/lm49453.c
+++ b/sound/soc/codecs/lm49453.c
@@ -1185,16 +1185,12 @@ static int lm49453_set_dai_fmt(struct snd_soc_dai *codec_dai, unsigned int fmt)
 
 	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
 	case SND_SOC_DAIFMT_CBS_CFS:
-		aif_val = ~LM49453_AUDIO_PORT1_BASIC_CLK_MS |
-			~LM49453_AUDIO_PORT1_BASIC_SYNC_MS;
 		break;
 	case SND_SOC_DAIFMT_CBS_CFM:
-		aif_val = ~LM49453_AUDIO_PORT1_BASIC_CLK_MS |
-			LM49453_AUDIO_PORT1_BASIC_SYNC_MS;
+		aif_val = LM49453_AUDIO_PORT1_BASIC_SYNC_MS;
 		break;
 	case SND_SOC_DAIFMT_CBM_CFS:
-		aif_val = LM49453_AUDIO_PORT1_BASIC_CLK_MS |
-			~LM49453_AUDIO_PORT1_BASIC_SYNC_MS;
+		aif_val = LM49453_AUDIO_PORT1_BASIC_CLK_MS;
 		break;
 	case SND_SOC_DAIFMT_CBM_CFM:
 		aif_val = LM49453_AUDIO_PORT1_BASIC_CLK_MS |
-- 
1.7.5.4



