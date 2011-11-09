Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966025Ab1KJDs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:48:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45127 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965985Ab1KJDsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:48:19 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:04 2011
Message-Id: <20111109213204.428064985@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:34:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Axel Lin <axel.lin@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [218/264] ASoC: wm8711: Fix wrong mask for setting input audio data bit length select
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@gmail.com>

commit 04c57163c8edfbc50e022737014069998ba4fc5f upstream.

The Input Audio Data Bit Length Select is controlled by BIT[3:2] of
WM8711_IFACE(07h) register.
Current code incorrectly masks BIT[1:0] which is for Audio Data Format Select.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm8711.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/wm8711.c
+++ b/sound/soc/codecs/wm8711.c
@@ -150,7 +150,7 @@ static int wm8711_hw_params(struct snd_p
 {
 	struct snd_soc_codec *codec = dai->codec;
 	struct wm8711_priv *wm8711 =  snd_soc_codec_get_drvdata(codec);
-	u16 iface = snd_soc_read(codec, WM8711_IFACE) & 0xfffc;
+	u16 iface = snd_soc_read(codec, WM8711_IFACE) & 0xfff3;
 	int i = get_coeff(wm8711->sysclk, params_rate(params));
 	u16 srate = (coeff_div[i].sr << 2) |
 		(coeff_div[i].bosr << 1) | coeff_div[i].usb;


