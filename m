Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab1JXDfU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 23:35:20 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:65508 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab1JXDfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 23:35:19 -0400
Message-ID: <1319427312.5773.6.camel@phoenix>
Subject: [RFC][PATCH 3/3] ASoC: wm8940: Do not left shift the div parameter
 in wm8940_set_dai_clkdiv
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Date: Mon, 24 Oct 2011 11:35:12 +0800
In-Reply-To: <1319427161.5773.3.camel@phoenix>
References: <1319427161.5773.3.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just check with other codec drivers, we do left shit div for
the corresponding bits from the caller in all other drivers.
I don't find the caller calling wm8940_set_dai_clkdiv now,
just make the behavior consistent with other drivers.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8940.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/wm8940.c b/sound/soc/codecs/wm8940.c
index fec3892..72cec5b 100644
--- a/sound/soc/codecs/wm8940.c
+++ b/sound/soc/codecs/wm8940.c
@@ -620,15 +620,15 @@ static int wm8940_set_dai_clkdiv(struct snd_soc_dai *codec_dai,
 	switch (div_id) {
 	case WM8940_BCLKDIV:
 		reg = snd_soc_read(codec, WM8940_CLOCK) & 0xFEF3;
-		ret = snd_soc_write(codec, WM8940_CLOCK, reg | (div << 2));
+		ret = snd_soc_write(codec, WM8940_CLOCK, reg | div);
 		break;
 	case WM8940_MCLKDIV:
 		reg = snd_soc_read(codec, WM8940_CLOCK) & 0xFF1F;
-		ret = snd_soc_write(codec, WM8940_CLOCK, reg | (div << 5));
+		ret = snd_soc_write(codec, WM8940_CLOCK, reg | div);
 		break;
 	case WM8940_OPCLKDIV:
 		reg = snd_soc_read(codec, WM8940_GPIO) & 0xFFCF;
-		ret = snd_soc_write(codec, WM8940_GPIO, reg | (div << 4));
+		ret = snd_soc_write(codec, WM8940_GPIO, reg | div);
 		break;
 	}
 	return ret;
-- 
1.7.5.4



