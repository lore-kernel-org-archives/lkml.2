Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab1I1WiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:38:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53533 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754779Ab1I1WiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:38:20 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:26 2011
Message-Id: <20110928220125.997085041@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 14:59:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Scott Jiang <scott.jiang.linux@gmail.com>,
        Barry Song <21cnbao@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [007/244] ASoC: ad193x: fix dac word len setting
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Scott Jiang <scott.jiang.linux@gmail.com>

commit 95c93d8525ebce1024bda7316f602ae45c36cd6f upstream.

dac word len value should left shift before setting

Signed-off-by: Scott Jiang <scott.jiang.linux@gmail.com>
Acked-by: Barry Song <21cnbao@gmail.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/ad193x.c |    3 ++-
 sound/soc/codecs/ad193x.h |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/sound/soc/codecs/ad193x.c
+++ b/sound/soc/codecs/ad193x.c
@@ -307,7 +307,8 @@ static int ad193x_hw_params(struct snd_p
 	snd_soc_write(codec, AD193X_PLL_CLK_CTRL0, reg);
 
 	reg = snd_soc_read(codec, AD193X_DAC_CTRL2);
-	reg = (reg & (~AD193X_DAC_WORD_LEN_MASK)) | word_len;
+	reg = (reg & (~AD193X_DAC_WORD_LEN_MASK))
+		| (word_len << AD193X_DAC_WORD_LEN_SHFT);
 	snd_soc_write(codec, AD193X_DAC_CTRL2, reg);
 
 	reg = snd_soc_read(codec, AD193X_ADC_CTRL1);
--- a/sound/soc/codecs/ad193x.h
+++ b/sound/soc/codecs/ad193x.h
@@ -34,6 +34,7 @@
 #define AD193X_DAC_LEFT_HIGH    (1 << 3)
 #define AD193X_DAC_BCLK_INV     (1 << 7)
 #define AD193X_DAC_CTRL2        0x804
+#define AD193X_DAC_WORD_LEN_SHFT        3
 #define AD193X_DAC_WORD_LEN_MASK        0x18
 #define AD193X_DAC_MASTER_MUTE  1
 #define AD193X_DAC_CHNL_MUTE    0x805


