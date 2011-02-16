Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470Ab1BPAqv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:46:51 -0500
Received: from kroah.org ([198.145.64.141]:49187 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757455Ab1BPAWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:22:34 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:40 2011
Message-Id: <20110216001440.689754285@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:13:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [156/272] ASoC: correct link specifications for corgi, poodle and spitz
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>

commit a3adfa00e8089aa72826c6ba04bcb18cfceaf0a9 upstream.

ASoC DAI link descriptions for Corgi, Poodle and Spitz platforms
contained incorrect names for cpu_dai and codec, which effectievly disabled sound
on theese platforms. Fix that errors.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/pxa/corgi.c  |    4 ++--
 sound/soc/pxa/poodle.c |    2 +-
 sound/soc/pxa/spitz.c  |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

--- a/sound/soc/pxa/corgi.c
+++ b/sound/soc/pxa/corgi.c
@@ -305,10 +305,10 @@ static int corgi_wm8731_init(struct snd_
 static struct snd_soc_dai_link corgi_dai = {
 	.name = "WM8731",
 	.stream_name = "WM8731",
-	.cpu_dai_name = "pxa-is2-dai",
+	.cpu_dai_name = "pxa2xx-i2s",
 	.codec_dai_name = "wm8731-hifi",
 	.platform_name = "pxa-pcm-audio",
-	.codec_name = "wm8731-codec-0.001a",
+	.codec_name = "wm8731-codec-0.001b",
 	.init = corgi_wm8731_init,
 	.ops = &corgi_ops,
 };
--- a/sound/soc/pxa/poodle.c
+++ b/sound/soc/pxa/poodle.c
@@ -274,7 +274,7 @@ static struct snd_soc_dai_link poodle_da
 	.cpu_dai_name = "pxa2xx-i2s",
 	.codec_dai_name = "wm8731-hifi",
 	.platform_name = "pxa-pcm-audio",
-	.codec_name = "wm8731-codec.0-001a",
+	.codec_name = "wm8731-codec.0-001b",
 	.init = poodle_wm8731_init,
 	.ops = &poodle_ops,
 };
--- a/sound/soc/pxa/spitz.c
+++ b/sound/soc/pxa/spitz.c
@@ -313,10 +313,10 @@ static int spitz_wm8750_init(struct snd_
 static struct snd_soc_dai_link spitz_dai = {
 	.name = "wm8750",
 	.stream_name = "WM8750",
-	.cpu_dai_name = "pxa-is2",
+	.cpu_dai_name = "pxa2xx-i2s",
 	.codec_dai_name = "wm8750-hifi",
 	.platform_name = "pxa-pcm-audio",
-	.codec_name = "wm8750-codec.0-001a",
+	.codec_name = "wm8750-codec.0-001b",
 	.init = spitz_wm8750_init,
 	.ops = &spitz_ops,
 };


