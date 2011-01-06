Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab1AFA3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:29:16 -0500
Received: from kroah.org ([198.145.64.141]:35486 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972Ab1AFA3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:29:12 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:22:59 2011
Message-Id: <20110106002259.310875920@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dmitry Artamonow <mad_soft@inbox.ru>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [028/152] ASoC: fix deemphasis control in wm8904/55/60 codecs
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dmitry Artamonow <mad_soft@inbox.ru>

commit 3f343f8512c7882a3637d9aea4ec6b3801cbcdc5 upstream.

Deemphasis control's .get callback should update control's value instead
of returning it - return value of callback function is used for indicating
error or success of operation.

Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm8904.c |    3 ++-
 sound/soc/codecs/wm8955.c |    3 ++-
 sound/soc/codecs/wm8960.c |    3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

--- a/sound/soc/codecs/wm8904.c
+++ b/sound/soc/codecs/wm8904.c
@@ -820,7 +820,8 @@ static int wm8904_get_deemph(struct snd_
 	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
 	struct wm8904_priv *wm8904 = snd_soc_codec_get_drvdata(codec);
 
-	return wm8904->deemph;
+	ucontrol->value.enumerated.item[0] = wm8904->deemph;
+	return 0;
 }
 
 static int wm8904_put_deemph(struct snd_kcontrol *kcontrol,
--- a/sound/soc/codecs/wm8955.c
+++ b/sound/soc/codecs/wm8955.c
@@ -384,7 +384,8 @@ static int wm8955_get_deemph(struct snd_
 	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
 	struct wm8955_priv *wm8955 = snd_soc_codec_get_drvdata(codec);
 
-	return wm8955->deemph;
+	ucontrol->value.enumerated.item[0] = wm8955->deemph;
+	return 0;
 }
 
 static int wm8955_put_deemph(struct snd_kcontrol *kcontrol,
--- a/sound/soc/codecs/wm8960.c
+++ b/sound/soc/codecs/wm8960.c
@@ -137,7 +137,8 @@ static int wm8960_get_deemph(struct snd_
 	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
 	struct wm8960_priv *wm8960 = snd_soc_codec_get_drvdata(codec);
 
-	return wm8960->deemph;
+	ucontrol->value.enumerated.item[0] = wm8960->deemph;
+	return 0;
 }
 
 static int wm8960_put_deemph(struct snd_kcontrol *kcontrol,


