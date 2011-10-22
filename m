Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116Ab1JVOsl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 10:48:41 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:57992 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab1JVOsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 10:48:40 -0400
Message-ID: <1319294907.2678.2.camel@phoenix>
Subject: [PATCH] ASoC: wm8400: Fix setting Fout clock divider for FLL
 Control 4
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Date: Sat, 22 Oct 2011 22:48:27 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What we want here is to clear the WM8400_FLL_OUTDIV_MASK bits then
OR with factors.outdiv.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8400.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/wm8400.c b/sound/soc/codecs/wm8400.c
index dc13be2..f29bc26 100644
--- a/sound/soc/codecs/wm8400.c
+++ b/sound/soc/codecs/wm8400.c
@@ -1059,7 +1059,7 @@ static int wm8400_set_dai_pll(struct snd_soc_dai *codec_dai, int pll_id,
 	wm8400_write(codec, WM8400_FLL_CONTROL_3, factors.n);
 
 	reg = wm8400_read(codec, WM8400_FLL_CONTROL_4);
-	reg &= WM8400_FLL_OUTDIV_MASK;
+	reg &= ~WM8400_FLL_OUTDIV_MASK;
 	reg |= factors.outdiv;
 	wm8400_write(codec, WM8400_FLL_CONTROL_4, reg);
 
-- 
1.7.5.4



