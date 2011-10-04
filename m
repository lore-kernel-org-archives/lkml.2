Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab1JDB7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 21:59:33 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50924 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab1JDB7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 21:59:32 -0400
Subject: [PATCH 4/4] ASoC: wm8988: Use snd_soc_update_bits for
 read-modify-write
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
In-Reply-To: <1317693345.2688.1.camel@phoenix>
References: <1317693345.2688.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Oct 2011 09:59:26 +0800
Message-ID: <1317693566.2688.6.camel@phoenix>
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
 sound/soc/codecs/wm8988.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/sound/soc/codecs/wm8988.c b/sound/soc/codecs/wm8988.c
index d7170f1..5099e62 100644
--- a/sound/soc/codecs/wm8988.c
+++ b/sound/soc/codecs/wm8988.c
@@ -774,16 +774,11 @@ static int wm8988_probe(struct snd_soc_codec *codec)
 	}
 
 	/* set the update bits (we always update left then right) */
-	reg = snd_soc_read(codec, WM8988_RADC);
-	snd_soc_write(codec, WM8988_RADC, reg | 0x100);
-	reg = snd_soc_read(codec, WM8988_RDAC);
-	snd_soc_write(codec, WM8988_RDAC, reg | 0x0100);
-	reg = snd_soc_read(codec, WM8988_ROUT1V);
-	snd_soc_write(codec, WM8988_ROUT1V, reg | 0x0100);
-	reg = snd_soc_read(codec, WM8988_ROUT2V);
-	snd_soc_write(codec, WM8988_ROUT2V, reg | 0x0100);
-	reg = snd_soc_read(codec, WM8988_RINVOL);
-	snd_soc_write(codec, WM8988_RINVOL, reg | 0x0100);
+	snd_soc_update_bits(codec, WM8988_RADC, 0x0100, 0x0100);
+	snd_soc_update_bits(codec, WM8988_RDAC, 0x0100, 0x0100);
+	snd_soc_update_bits(codec, WM8988_ROUT1V, 0x0100, 0x0100);
+	snd_soc_update_bits(codec, WM8988_ROUT2V, 0x0100, 0x0100);
+	snd_soc_update_bits(codec, WM8988_RINVOL, 0x0100, 0x0100);
 
 	wm8988_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
 
-- 
1.7.4.1



