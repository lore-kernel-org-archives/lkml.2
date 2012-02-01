Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932670Ab2BAVa4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:30:56 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:34998 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932612Ab2BAVTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:19:16 -0500
X-Sasl-enc: CygjT+se8fp/xbUiFpguXIRacrzpCeiNw+uF4X2infMO 1328131155
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:45 2012
Message-Id: <20120201210045.211143182@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:59:39 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [15/89] ASoC: Dont go through cache when applying WM5100 rev A updates
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 495174a8ffbaa0d15153d855cf206cdc46d51cf4 upstream.

These are all to either uncached registers or fixes to register defaults,
in the former case the cache won't do anything and in the latter case
we're fixing things so the cache sync will do the right thing.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm5100.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/soc/codecs/wm5100.c
+++ b/sound/soc/codecs/wm5100.c
@@ -1379,6 +1379,7 @@ static int wm5100_set_bias_level(struct
 
 			switch (wm5100->rev) {
 			case 0:
+				regcache_cache_bypass(wm5100->regmap, true);
 				snd_soc_write(codec, 0x11, 0x3);
 				snd_soc_write(codec, 0x203, 0xc);
 				snd_soc_write(codec, 0x206, 0);
@@ -1394,6 +1395,7 @@ static int wm5100_set_bias_level(struct
 					snd_soc_write(codec,
 						      wm5100_reva_patches[i].reg,
 						      wm5100_reva_patches[i].val);
+				regcache_cache_bypass(wm5100->regmap, false);
 				break;
 			default:
 				break;


