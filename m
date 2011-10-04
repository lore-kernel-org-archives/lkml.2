Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab1JDB5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 21:57:15 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65180 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973Ab1JDB5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 21:57:14 -0400
Subject: [PATCH 2/4] ASoC: wm8750: Use snd_soc_update_bits for
 read-modify-write
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Richard Purdie <rchard.purdie@linuxfoundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
In-Reply-To: <1317693345.2688.1.camel@phoenix>
References: <1317693345.2688.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Oct 2011 09:57:07 +0800
Message-ID: <1317693427.2688.3.camel@phoenix>
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
 sound/soc/codecs/wm8750.c |   24 ++++++++----------------
 1 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/sound/soc/codecs/wm8750.c b/sound/soc/codecs/wm8750.c
index 15f0372..bad400d 100644
--- a/sound/soc/codecs/wm8750.c
+++ b/sound/soc/codecs/wm8750.c
@@ -712,22 +712,14 @@ static int wm8750_probe(struct snd_soc_codec *codec)
 	wm8750_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
 
 	/* set the update bits */
-	reg = snd_soc_read(codec, WM8750_LDAC);
-	snd_soc_write(codec, WM8750_LDAC, reg | 0x0100);
-	reg = snd_soc_read(codec, WM8750_RDAC);
-	snd_soc_write(codec, WM8750_RDAC, reg | 0x0100);
-	reg = snd_soc_read(codec, WM8750_LOUT1V);
-	snd_soc_write(codec, WM8750_LOUT1V, reg | 0x0100);
-	reg = snd_soc_read(codec, WM8750_ROUT1V);
-	snd_soc_write(codec, WM8750_ROUT1V, reg | 0x0100);
-	reg = snd_soc_read(codec, WM8750_LOUT2V);
-	snd_soc_write(codec, WM8750_LOUT2V, reg | 0x0100);
-	reg = snd_soc_read(codec, WM8750_ROUT2V);
-	snd_soc_write(codec, WM8750_ROUT2V, reg | 0x0100);
-	reg = snd_soc_read(codec, WM8750_LINVOL);
-	snd_soc_write(codec, WM8750_LINVOL, reg | 0x0100);
-	reg = snd_soc_read(codec, WM8750_RINVOL);
-	snd_soc_write(codec, WM8750_RINVOL, reg | 0x0100);
+	snd_soc_update_bits(codec, WM8750_LDAC, 0x0100, 0x0100);
+	snd_soc_update_bits(codec, WM8750_RDAC, 0x0100, 0x0100);
+	snd_soc_update_bits(codec, WM8750_LOUT1V, 0x0100, 0x0100);
+	snd_soc_update_bits(codec, WM8750_ROUT1V, 0x0100, 0x0100);
+	snd_soc_update_bits(codec, WM8750_LOUT2V, 0x0100, 0x0100);
+	snd_soc_update_bits(codec, WM8750_ROUT2V, 0x0100, 0x0100);
+	snd_soc_update_bits(codec, WM8750_LINVOL, 0x0100, 0x0100);
+	snd_soc_update_bits(codec, WM8750_RINVOL, 0x0100, 0x0100);
 
 	snd_soc_add_controls(codec, wm8750_snd_controls,
 				ARRAY_SIZE(wm8750_snd_controls));
-- 
1.7.4.1



