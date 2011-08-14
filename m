Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab1HNDbO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 23:31:14 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57938 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab1HNDbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 23:31:13 -0400
Subject: [PATCH] ASoC: sta32x: shortcut the for loop to get ir and mcs
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Johannes Stezenbach <js@sig21.net>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Aug 2011 11:31:04 +0800
Message-ID: <1313292664.6074.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is exactly one match or no match at all during the for loop iteration,
thus we can break from the for loop once a match is found.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/sta32x.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/sta32x.c b/sound/soc/codecs/sta32x.c
index fbd7eb9..3d155f5 100644
--- a/sound/soc/codecs/sta32x.c
+++ b/sound/soc/codecs/sta32x.c
@@ -524,13 +524,17 @@ static int sta32x_hw_params(struct snd_pcm_substream *substream,
 	rate = params_rate(params);
 	pr_debug("rate: %u\n", rate);
 	for (i = 0; i < ARRAY_SIZE(interpolation_ratios); i++)
-		if (interpolation_ratios[i].fs == rate)
+		if (interpolation_ratios[i].fs == rate) {
 			ir = interpolation_ratios[i].ir;
+			break;
+		}
 	if (ir < 0)
 		return -EINVAL;
 	for (i = 0; mclk_ratios[ir][i].ratio; i++)
-		if (mclk_ratios[ir][i].ratio * rate == sta32x->mclk)
+		if (mclk_ratios[ir][i].ratio * rate == sta32x->mclk) {
 			mcs = mclk_ratios[ir][i].mcs;
+			break;
+		}
 	if (mcs < 0)
 		return -EINVAL;
 
-- 
1.7.4.1



