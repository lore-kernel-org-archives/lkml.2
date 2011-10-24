Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab1JXDeD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 23:34:03 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33716 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab1JXDeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 23:34:02 -0400
Message-ID: <1319427235.5773.4.camel@phoenix>
Subject: [PATCH 2/3] ASoC: wm8940: Fix a typo for the mask of setting
 WM8940_BCLKDIV
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Date: Mon, 24 Oct 2011 11:33:55 +0800
In-Reply-To: <1319427161.5773.3.camel@phoenix>
References: <1319427161.5773.3.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The registers are 16 bits, thus remove an extra F for the mask.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8940.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/wm8940.c b/sound/soc/codecs/wm8940.c
index 3cc3bce..fec3892 100644
--- a/sound/soc/codecs/wm8940.c
+++ b/sound/soc/codecs/wm8940.c
@@ -619,7 +619,7 @@ static int wm8940_set_dai_clkdiv(struct snd_soc_dai *codec_dai,
 
 	switch (div_id) {
 	case WM8940_BCLKDIV:
-		reg = snd_soc_read(codec, WM8940_CLOCK) & 0xFFEF3;
+		reg = snd_soc_read(codec, WM8940_CLOCK) & 0xFEF3;
 		ret = snd_soc_write(codec, WM8940_CLOCK, reg | (div << 2));
 		break;
 	case WM8940_MCLKDIV:
-- 
1.7.5.4



