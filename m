Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab1J1DIO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 23:08:14 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51261 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab1J1DIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 23:08:13 -0400
Message-ID: <1319771281.3944.1.camel@phoenix>
Subject: [PATCH 1/2] ASoC: wm8711: Fix wrong mask for setting input audio
 data bit length select
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Date: Fri, 28 Oct 2011 11:08:01 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Input Audio Data Bit Length Select is controlled by BIT[3:2] of
WM8711_IFACE(07h) register.
Current code incorrectly masks BIT[1:0] which is for Audio Data Format Select.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8711.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/wm8711.c b/sound/soc/codecs/wm8711.c
index 8d0347c..8ba49d8 100644
--- a/sound/soc/codecs/wm8711.c
+++ b/sound/soc/codecs/wm8711.c
@@ -151,7 +151,7 @@ static int wm8711_hw_params(struct snd_pcm_substream *substream,
 {
 	struct snd_soc_codec *codec = dai->codec;
 	struct wm8711_priv *wm8711 =  snd_soc_codec_get_drvdata(codec);
-	u16 iface = snd_soc_read(codec, WM8711_IFACE) & 0xfffc;
+	u16 iface = snd_soc_read(codec, WM8711_IFACE) & 0xfff3;
 	int i = get_coeff(wm8711->sysclk, params_rate(params));
 	u16 srate = (coeff_div[i].sr << 2) |
 		(coeff_div[i].bosr << 1) | coeff_div[i].usb;
-- 
1.7.5.4



