Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab1JBMlT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 08:41:19 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56269 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab1JBMlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 08:41:15 -0400
Subject: [PATCH] ASoC: Fix setting update bits for WM8753_LADC and
 WM8753_RADC
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 02 Oct 2011 20:41:04 +0800
Message-ID: <1317559264.21926.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code set update bits for WM8753_LDAC and WM8753_RDAC twice,
but missed setting update bits for WM8753_LADC and WM8753_RADC.

I think it is a copy-paste bug in commit 776065
"ASoC: codecs: wm8753: Fix register cache incoherency".

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8753.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wm8753.c b/sound/soc/codecs/wm8753.c
index fe04a10..a950471 100644
--- a/sound/soc/codecs/wm8753.c
+++ b/sound/soc/codecs/wm8753.c
@@ -1455,8 +1455,8 @@ static int wm8753_probe(struct snd_soc_codec *codec)
 	/* set the update bits */
 	snd_soc_update_bits(codec, WM8753_LDAC, 0x0100, 0x0100);
 	snd_soc_update_bits(codec, WM8753_RDAC, 0x0100, 0x0100);
-	snd_soc_update_bits(codec, WM8753_LDAC, 0x0100, 0x0100);
-	snd_soc_update_bits(codec, WM8753_RDAC, 0x0100, 0x0100);
+	snd_soc_update_bits(codec, WM8753_LADC, 0x0100, 0x0100);
+	snd_soc_update_bits(codec, WM8753_RADC, 0x0100, 0x0100);
 	snd_soc_update_bits(codec, WM8753_LOUT1V, 0x0100, 0x0100);
 	snd_soc_update_bits(codec, WM8753_ROUT1V, 0x0100, 0x0100);
 	snd_soc_update_bits(codec, WM8753_LOUT2V, 0x0100, 0x0100);
-- 
1.7.4.1



