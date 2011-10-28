Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab1J1DMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 23:12:15 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38776 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094Ab1J1DMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 23:12:14 -0400
Message-ID: <1319771527.3944.4.camel@phoenix>
Subject: [PATCH 2/2] ASoC: wm8711: Add proper mask for wm8711_set_dai_fmt
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Date: Fri, 28 Oct 2011 11:12:07 +0800
In-Reply-To: <1319771281.3944.1.camel@phoenix>
References: <1319771281.3944.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add mask for BIT[3:2] (the Input Audio Data Bit Length Select)
of WM8711_IFACE(07h) register.
Otherwise, BIT[3:2] will be always set to 0b00 here.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8711.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/wm8711.c b/sound/soc/codecs/wm8711.c
index 8ba49d8..076bdb9 100644
--- a/sound/soc/codecs/wm8711.c
+++ b/sound/soc/codecs/wm8711.c
@@ -232,7 +232,7 @@ static int wm8711_set_dai_fmt(struct snd_soc_dai *codec_dai,
 		unsigned int fmt)
 {
 	struct snd_soc_codec *codec = codec_dai->codec;
-	u16 iface = 0;
+	u16 iface = snd_soc_read(codec, WM8711_IFACE) & 0x000c;
 
 	/* set master/slave audio interface */
 	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
-- 
1.7.5.4



