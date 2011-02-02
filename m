Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab1BBAnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:43:40 -0500
Received: from mga14.intel.com ([143.182.124.37]:48181 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404Ab1BBAnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="382960424"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: mad_soft@inbox.ru, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [23/139] ASoC: fix deemphasis control in wm8904/55/60 codecs
Message-Id: <20110202004337.DDA373E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:43:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 sound/soc/codecs/wm8904.c |    3 ++-
 sound/soc/codecs/wm8955.c |    3 ++-
 sound/soc/codecs/wm8960.c |    3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

Index: linux-2.6.35.y/sound/soc/codecs/wm8904.c
===================================================================
--- linux-2.6.35.y.orig/sound/soc/codecs/wm8904.c
+++ linux-2.6.35.y/sound/soc/codecs/wm8904.c
@@ -820,7 +820,8 @@ static int wm8904_get_deemph(struct snd_
 	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
 	struct wm8904_priv *wm8904 = snd_soc_codec_get_drvdata(codec);
 
-	return wm8904->deemph;
+	ucontrol->value.enumerated.item[0] = wm8904->deemph;
+	return 0;
 }
 
 static int wm8904_put_deemph(struct snd_kcontrol *kcontrol,
Index: linux-2.6.35.y/sound/soc/codecs/wm8955.c
===================================================================
--- linux-2.6.35.y.orig/sound/soc/codecs/wm8955.c
+++ linux-2.6.35.y/sound/soc/codecs/wm8955.c
@@ -384,7 +384,8 @@ static int wm8955_get_deemph(struct snd_
 	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
 	struct wm8955_priv *wm8955 = snd_soc_codec_get_drvdata(codec);
 
-	return wm8955->deemph;
+	ucontrol->value.enumerated.item[0] = wm8955->deemph;
+	return 0;
 }
 
 static int wm8955_put_deemph(struct snd_kcontrol *kcontrol,
