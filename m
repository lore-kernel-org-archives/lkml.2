Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab1I1HPJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 03:15:09 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53793 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab1I1HPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 03:15:07 -0400
Subject: [PATCH] ASoC: Fix setting adau1373_dai->master for
 SND_SOC_DAIFMT_CBS_CFS
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lars-Peter Clausen <lars@metafoo.de>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Sep 2011 15:14:56 +0800
Message-ID: <1317194096.2498.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case of SND_SOC_DAIFMT_CBS_CFS, adau1373_dai->master should be false.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/adau1373.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/adau1373.c b/sound/soc/codecs/adau1373.c
index 2aa40c3..1ccf8dd 100644
--- a/sound/soc/codecs/adau1373.c
+++ b/sound/soc/codecs/adau1373.c
@@ -974,7 +974,7 @@ static int adau1373_set_dai_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 		break;
 	case SND_SOC_DAIFMT_CBS_CFS:
 		ctrl = 0;
-		adau1373_dai->master = true;
+		adau1373_dai->master = false;
 		break;
 	default:
 		return -EINVAL;
-- 
1.7.4.1



