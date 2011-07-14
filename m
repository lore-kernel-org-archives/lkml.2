Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab1GNKO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 06:14:57 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55972 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194Ab1GNKO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 06:14:56 -0400
Subject: [PATCH] ASoC: wm8900: fix a memory leak if wm8900_set_fll fails
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jul 2011 18:14:46 +0800
Message-ID: <1310638486.5186.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8900.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/wm8900.c b/sound/soc/codecs/wm8900.c
index 449ea09..082040e 100644
--- a/sound/soc/codecs/wm8900.c
+++ b/sound/soc/codecs/wm8900.c
@@ -1167,6 +1167,7 @@ static int wm8900_resume(struct snd_soc_codec *codec)
 		ret = wm8900_set_fll(codec, 0, fll_in, fll_out);
 		if (ret != 0) {
 			dev_err(codec->dev, "Failed to restart FLL\n");
+			kfree(cache);
 			return ret;
 		}
 	}
-- 
1.7.4.1



