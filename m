Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab1J0If6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 04:35:58 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34238 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab1J0If4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 04:35:56 -0400
Message-ID: <1319704549.2673.2.camel@phoenix>
Subject: [PATCH 1/2] ASoC: tlv320aic23: Clear TLV320AIC23_MS_MASTER bit for
 slave mode
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, alsa-devel@alsa-project.org
Date: Thu, 27 Oct 2011 16:35:49 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the datasheet:

Digital Audio Interface Format (07h) register:
BIT6:	Master/slave mode
	0: Slave
	1: Master

Current code sets TLV320AIC23_MS_MASTER bit for master mode,
but does not clear it for slave mode.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/tlv320aic23.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/tlv320aic23.c b/sound/soc/codecs/tlv320aic23.c
index ab27dbc..336de8f 100644
--- a/sound/soc/codecs/tlv320aic23.c
+++ b/sound/soc/codecs/tlv320aic23.c
@@ -430,6 +430,7 @@ static int tlv320aic23_set_dai_fmt(struct snd_soc_dai *codec_dai,
 		iface_reg |= TLV320AIC23_MS_MASTER;
 		break;
 	case SND_SOC_DAIFMT_CBS_CFS:
+		iface_reg &= ~TLV320AIC23_MS_MASTER;
 		break;
 	default:
 		return -EINVAL;
-- 
1.7.5.4



