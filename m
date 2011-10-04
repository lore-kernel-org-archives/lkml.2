Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab1JDB6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 21:58:36 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56553 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab1JDB6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 21:58:35 -0400
Subject: [PATCH 3/4] ASoC: wm8971: Use snd_soc_update_bits for
 read-modify-write
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kenneth Kiraly <kiraly@lab126.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
In-Reply-To: <1317693345.2688.1.camel@phoenix>
References: <1317693345.2688.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Oct 2011 09:58:28 +0800
Message-ID: <1317693508.2688.5.camel@phoenix>
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
 sound/soc/codecs/wm8971.c |   27 ++++++++-------------------
 1 files changed, 8 insertions(+), 19 deletions(-)

diff --git a/sound/soc/codecs/wm8971.c b/sound/soc/codecs/wm8971.c
index 7ec4165..08ea6f8 100644
--- a/sound/soc/codecs/wm8971.c
+++ b/sound/soc/codecs/wm8971.c
@@ -660,25 +660,14 @@ static int wm8971_probe(struct snd_soc_codec *codec)
 		msecs_to_jiffies(1000));
 
 	/* set the update bits */
-	reg = snd_soc_read(codec, WM8971_LDAC);
-	snd_soc_write(codec, WM8971_LDAC, reg | 0x0100);
-	reg = snd_soc_read(codec, WM8971_RDAC);
-	snd_soc_write(codec, WM8971_RDAC, reg | 0x0100);
-
-	reg = snd_soc_read(codec, WM8971_LOUT1V);
-	snd_soc_write(codec, WM8971_LOUT1V, reg | 0x0100);
-	reg = snd_soc_read(codec, WM8971_ROUT1V);
-	snd_soc_write(codec, WM8971_ROUT1V, reg | 0x0100);
-
-	reg = snd_soc_read(codec, WM8971_LOUT2V);
-	snd_soc_write(codec, WM8971_LOUT2V, reg | 0x0100);
-	reg = snd_soc_read(codec, WM8971_ROUT2V);
-	snd_soc_write(codec, WM8971_ROUT2V, reg | 0x0100);
-
-	reg = snd_soc_read(codec, WM8971_LINVOL);
-	snd_soc_write(codec, WM8971_LINVOL, reg | 0x0100);
-	reg = snd_soc_read(codec, WM8971_RINVOL);
-	snd_soc_write(codec, WM8971_RINVOL, reg | 0x0100);
+	snd_soc_update_bits(codec, WM8971_LDAC, 0x0100, 0x0100);
+	snd_soc_update_bits(codec, WM8971_RDAC, 0x0100, 0x0100);
+	snd_soc_update_bits(codec, WM8971_LOUT1V, 0x0100, 0x0100);
+	snd_soc_update_bits(codec, WM8971_ROUT1V, 0x0100, 0x0100);
+	snd_soc_update_bits(codec, WM8971_LOUT2V, 0x0100, 0x0100);
+	snd_soc_update_bits(codec, WM8971_ROUT2V, 0x0100, 0x0100);
+	snd_soc_update_bits(codec, WM8971_LINVOL, 0x0100, 0x0100);
+	snd_soc_update_bits(codec, WM8971_RINVOL, 0x0100, 0x0100);
 
 	snd_soc_add_controls(codec, wm8971_snd_controls,
 				ARRAY_SIZE(wm8971_snd_controls));
-- 
1.7.4.1



