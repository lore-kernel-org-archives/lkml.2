Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276Ab1KSAI7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 19:08:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38368 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758187Ab1KSAI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 19:08:56 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Nov 18 16:00:04 2011
Message-Id: <20111119000004.219682139@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Fri, 18 Nov 2011 15:58:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [03/26] ASoC: Dont use wm8994->control_data in wm8994_readable_register()
In-Reply-To: <20111119000026.GA6679@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 8eeea521d9d0fa6afd62df8c6e6566ee946117fa upstream.

The field is no longer initialised so this will crash if running on
wm8958.

Reported-by: Thomas Abraham <thomas.abraham@linaro.org>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm8994.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -56,7 +56,7 @@ static int wm8994_retune_mobile_base[] =
 static int wm8994_readable(struct snd_soc_codec *codec, unsigned int reg)
 {
 	struct wm8994_priv *wm8994 = snd_soc_codec_get_drvdata(codec);
-	struct wm8994 *control = wm8994->control_data;
+	struct wm8994 *control = codec->control_data;
 
 	switch (reg) {
 	case WM8994_GPIO_1:


