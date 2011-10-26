Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab1JZBzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 21:55:47 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43981 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535Ab1JZBzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 21:55:46 -0400
Message-ID: <1319594139.2517.2.camel@phoenix>
Subject: [PATCH 2/2] ASoC: wm8940: Fix mask for setting BCLKDIV
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Chris Paulson-Ellis <chris@edesix.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Date: Wed, 26 Oct 2011 09:55:39 +0800
In-Reply-To: <1319594021.2517.0.camel@phoenix>
References: <1319594021.2517.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the datasheet:
BCLK is controlled by BIT[4:2] of WM8940_CLOCK(06h) register.

Signed-off-by: Chris Paulson-Ellis <chris@edesix.com>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
I got the patch from Chris, thus add his signed-off-by here.

 sound/soc/codecs/wm8940.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/wm8940.c b/sound/soc/codecs/wm8940.c
index e8a4ca3..1b5856b 100644
--- a/sound/soc/codecs/wm8940.c
+++ b/sound/soc/codecs/wm8940.c
@@ -621,7 +621,7 @@ static int wm8940_set_dai_clkdiv(struct snd_soc_dai *codec_dai,
 
 	switch (div_id) {
 	case WM8940_BCLKDIV:
-		reg = snd_soc_read(codec, WM8940_CLOCK) & 0xFEF3;
+		reg = snd_soc_read(codec, WM8940_CLOCK) & 0xFFE3;
 		ret = snd_soc_write(codec, WM8940_CLOCK, reg | (div << 2));
 		break;
 	case WM8940_MCLKDIV:
-- 
1.7.5.4



