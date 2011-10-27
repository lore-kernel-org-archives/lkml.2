Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab1J0Iiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 04:38:50 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52708 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789Ab1J0Iit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 04:38:49 -0400
Message-ID: <1319704722.2673.5.camel@phoenix>
Subject: [PATCH 2/2] ASoC: tlv320aic3x: Clear BIT_CLK_MASTER and
 WORD_CLK_MASTER bits for for slave mode
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Vladimir Barinov <vbarinov@embeddedalley.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, alsa-devel@alsa-project.org
Date: Thu, 27 Oct 2011 16:38:42 +0800
In-Reply-To: <1319704549.2673.2.camel@phoenix>
References: <1319704549.2673.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the datasheet:

Page0 / Register8: Audio Serial Data interface Control Register A
BIT 7: Bit Clock Directional Control
        0: Bit clock is an input (slave mode)
        1: Bit clock is an output (master mode)

BIT 6: Word Clock Directional Control
        0: Word clock is an input (slave mode)
        1: Word clock is an output (master mode)

Current code sets BIT_CLK_MASTER and WORD_CLK_MASTER bits for master mode,
but does not clear these bits for slave mode.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/tlv320aic3x.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/tlv320aic3x.c b/sound/soc/codecs/tlv320aic3x.c
index a77f6ea..14cb553 100644
--- a/sound/soc/codecs/tlv320aic3x.c
+++ b/sound/soc/codecs/tlv320aic3x.c
@@ -1021,6 +1021,7 @@ static int aic3x_set_dai_fmt(struct snd_soc_dai *codec_dai,
 		break;
 	case SND_SOC_DAIFMT_CBS_CFS:
 		aic3x->master = 0;
+		iface_areg &= ~(BIT_CLK_MASTER | WORD_CLK_MASTER);
 		break;
 	default:
 		return -EINVAL;
-- 
1.7.5.4



