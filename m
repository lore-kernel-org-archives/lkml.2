Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935644Ab1KJDdq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:33:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43194 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935616Ab1KJDdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:33:39 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:22 2011
Message-Id: <20111109212722.714851872@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:29:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Axel Lin <axel.lin@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [220/262] ASoC: Leave input audio data bit length settings untouched in wm8711_set_dai_fmt
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@gmail.com>

commit d558cfc30064a97c2c65dbd2b3a4f5a1dea7ec1b upstream.

Current implementation in wm8711_set_dai_fmt always clear BIT[3:2]
(the Input Audio Data Bit Length Select) of WM8711_IFACE(07h) register.
Input Audio Data Bit Length Select bits are set by wm8711_hw_params,
we should leave BIT[3:2] untouched in wm8711_set_dai_fmt.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm8711.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/wm8711.c
+++ b/sound/soc/codecs/wm8711.c
@@ -231,7 +231,7 @@ static int wm8711_set_dai_fmt(struct snd
 		unsigned int fmt)
 {
 	struct snd_soc_codec *codec = codec_dai->codec;
-	u16 iface = 0;
+	u16 iface = snd_soc_read(codec, WM8711_IFACE) & 0x000c;
 
 	/* set master/slave audio interface */
 	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {


