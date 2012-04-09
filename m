Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207Ab2DIUwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 16:52:22 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21363 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab2DIUwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 16:52:20 -0400
Date: Mon, 9 Apr 2012 22:52:19 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, alsa-devel@alsa-project.org,
        Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        Liam Girdwood <lrg@ti.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 24/26] ASoC: wm8994: Don't test for NULL before
 release_firmware()
In-Reply-To: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1204092243450.14420@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

release_firmware() does its own NULL ptr testing, it's redundant to
also test before calling it.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 sound/soc/codecs/wm8994.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 7c49642..cf7e5d2 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -3972,7 +3972,7 @@ err_irq:
 	return ret;
 }
 
-static int  wm8994_codec_remove(struct snd_soc_codec *codec)
+static int wm8994_codec_remove(struct snd_soc_codec *codec)
 {
 	struct wm8994_priv *wm8994 = snd_soc_codec_get_drvdata(codec);
 	struct wm8994 *control = wm8994->wm8994;
@@ -4013,14 +4013,10 @@ static int  wm8994_codec_remove(struct snd_soc_codec *codec)
 			free_irq(wm8994->micdet_irq, wm8994);
 		break;
 	}
-	if (wm8994->mbc)
-		release_firmware(wm8994->mbc);
-	if (wm8994->mbc_vss)
-		release_firmware(wm8994->mbc_vss);
-	if (wm8994->enh_eq)
-		release_firmware(wm8994->enh_eq);
+	release_firmware(wm8994->mbc);
+	release_firmware(wm8994->mbc_vss);
+	release_firmware(wm8994->enh_eq);
 	kfree(wm8994->retune_mobile_texts);
-
 	return 0;
 }
 
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

