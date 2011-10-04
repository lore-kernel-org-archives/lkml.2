Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab1JDBz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 21:55:57 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40512 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab1JDBzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 21:55:55 -0400
Subject: [PATCH 1/4] ASoC: wm8711: Use snd_soc_update_bits for
 read-modify-write
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Arthur <linux@wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Oct 2011 09:55:45 +0800
Message-ID: <1317693345.2688.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use snd_soc_update_bits for read-modify-write register access instead of
open-coding it using snd_soc_read and snd_soc_write

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8711.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/wm8711.c b/sound/soc/codecs/wm8711.c
index 8457d3c..6ecf1ab 100644
--- a/sound/soc/codecs/wm8711.c
+++ b/sound/soc/codecs/wm8711.c
@@ -381,10 +381,8 @@ static int wm8711_probe(struct snd_soc_codec *codec)
 	wm8711_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
 
 	/* Latch the update bits */
-	reg = snd_soc_read(codec, WM8711_LOUT1V);
-	snd_soc_write(codec, WM8711_LOUT1V, reg | 0x0100);
-	reg = snd_soc_read(codec, WM8711_ROUT1V);
-	snd_soc_write(codec, WM8711_ROUT1V, reg | 0x0100);
+	snd_soc_update_bits(codec, WM8711_LOUT1V, 0x0100, 0x0100);
+	snd_soc_update_bits(codec, WM8711_ROUT1V, 0x0100, 0x0100);
 
 	snd_soc_add_controls(codec, wm8711_snd_controls,
 			     ARRAY_SIZE(wm8711_snd_controls));
-- 
1.7.4.1



