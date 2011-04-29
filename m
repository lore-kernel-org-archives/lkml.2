Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933724Ab1D2TF7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 15:05:59 -0400
Received: from kroah.org ([198.145.64.141]:50277 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933107Ab1D2S6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:58:25 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Apr 29 11:56:54 2011
Message-Id: <20110429185654.792343925@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 29 Apr 2011 11:55:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Lars-Peter Clausen <lars@metafoo.de>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [23/55] ASoC: codecs: JZ4740: Fix OOPS
In-Reply-To: <20110429185706.GA12824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit 1fdf9b49e9e7788d09bad4b08a6a821ac39798f3 upstream.

Commit ce6120cc(ASoC: Decouple DAPM from CODECs) changed the signature of
snd_soc_dapm_widgets_new to take an pointer to a snd_soc_dapm_context instead of
a snd_soc_codec. The call to snd_soc_dapm_widgets_new in jz4740_codec_dev_probe
was not updated to reflect this change, which results in a compiletime warning
and a runtime OOPS.

Since the core code calls snd_soc_dapm_widgets_new after the codec has been
registered it can be dropped here.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Liam Girdwood <lrg@ti.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/jz4740.c |    2 --
 1 file changed, 2 deletions(-)

--- a/sound/soc/codecs/jz4740.c
+++ b/sound/soc/codecs/jz4740.c
@@ -308,8 +308,6 @@ static int jz4740_codec_dev_probe(struct
 	snd_soc_dapm_add_routes(dapm, jz4740_codec_dapm_routes,
 		ARRAY_SIZE(jz4740_codec_dapm_routes));
 
-	snd_soc_dapm_new_widgets(codec);
-
 	jz4740_codec_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
 
 	return 0;


