Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab1I3Dy5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 23:54:57 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:35471 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503Ab1I3Dy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 23:54:56 -0400
Subject: [PATCH] ASoC: Add missed regulator_unregister_notifier and
 regulator_bulk_free in wm8995_remove
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Sep 2011 11:54:44 +0800
Message-ID: <1317354884.4437.0.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8995.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/wm8995.c b/sound/soc/codecs/wm8995.c
index 74ae599..e05ee79 100644
--- a/sound/soc/codecs/wm8995.c
+++ b/sound/soc/codecs/wm8995.c
@@ -1573,9 +1573,16 @@ static int wm8995_resume(struct snd_soc_codec *codec)
 static int wm8995_remove(struct snd_soc_codec *codec)
 {
 	struct wm8995_priv *wm8995;
+	int i;
 
 	wm8995 = snd_soc_codec_get_drvdata(codec);
 	wm8995_set_bias_level(codec, SND_SOC_BIAS_OFF);
+
+	for (i = 0; i < ARRAY_SIZE(wm8995->supplies); ++i)
+		regulator_unregister_notifier(wm8995->supplies[i].consumer,
+					      &wm8995->disable_nb[i]);
+
+	regulator_bulk_free(ARRAY_SIZE(wm8995->supplies), wm8995->supplies);
 	return 0;
 }
 
-- 
1.7.4.1



