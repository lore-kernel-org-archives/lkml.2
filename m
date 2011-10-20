Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab1JTKdP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 06:33:15 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35200 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540Ab1JTKdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 06:33:14 -0400
Message-ID: <1319106779.8866.1.camel@phoenix>
Subject: [PATCH] ASoC: Set sgtl5000->ldo in ldo_regulator_register
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Zeng Zhaoming <zhaoming.zeng@freescale.com>,
        Wolfram Sang <w.sang@pengutronix.de>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Date: Thu, 20 Oct 2011 18:32:59 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise calling ldo_regulator_remove() does not unregister regulator
and free memories.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/sgtl5000.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index 3637a62..8395002 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -806,6 +806,7 @@ static int ldo_regulator_register(struct snd_soc_codec *codec,
 				int voltage)
 {
 	struct ldo_regulator *ldo;
+	struct sgtl5000_priv *sgtl5000 = snd_soc_codec_get_drvdata(codec);
 
 	ldo = kzalloc(sizeof(struct ldo_regulator), GFP_KERNEL);
 
@@ -840,6 +841,7 @@ static int ldo_regulator_register(struct snd_soc_codec *codec,
 
 		return ret;
 	}
+	sgtl5000->ldo = ldo;
 
 	return 0;
 }
-- 
1.7.5.4



