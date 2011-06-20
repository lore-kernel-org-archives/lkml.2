Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab1FTSzm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 14:55:42 -0400
Received: from smtp-out.google.com ([74.125.121.67]:52575 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422Ab1FTSzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 14:55:41 -0400
From: Taylor Hutt <thutt@chromium.org>
To: thutt@chromium.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Peter Hsiang <Peter.Hsiang@maxim-ic.com>,
        Olof Johansson <olofj@chromium.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ASoC: codecs: Max98095: Fix logging of hardware revision.
Date: Mon, 20 Jun 2011 11:54:32 -0700
Message-Id: <1308596072-17158-1-git-send-email-thutt@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The base hardware revision of the Maxim 98095 part is 0x40; the code
which outputs the revision of the hardware has been updated to
properly use uppercase alphabetic values for the revision numbers.

Also, the use of a constant for the length 'max98095_dai' has been
replaced with ARRAY_SIZE().

Signed-off-by: Taylor Hutt <thutt@chromium.org>
---
 sound/soc/codecs/max98095.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/max98095.c b/sound/soc/codecs/max98095.c
index e1d282d..9a793b3 100644
--- a/sound/soc/codecs/max98095.c
+++ b/sound/soc/codecs/max98095.c
@@ -2261,11 +2261,11 @@ static int max98095_probe(struct snd_soc_codec *codec)
 
 	ret = snd_soc_read(codec, M98095_0FF_REV_ID);
 	if (ret < 0) {
-		dev_err(codec->dev, "Failed to read device revision: %d\n",
+		dev_err(codec->dev, "Failure reading hardware revision: %d\n",
 			ret);
 		goto err_access;
 	}
-	dev_info(codec->dev, "revision %c\n", ret + 'A');
+	dev_info(codec->dev, "Hardware revision: %c\n", ret - 0x40 + 'A');
 
 	snd_soc_write(codec, M98095_097_PWR_SYS, M98095_PWRSV);
 
@@ -2342,8 +2342,8 @@ static int max98095_i2c_probe(struct i2c_client *i2c,
 	max98095->control_data = i2c;
 	max98095->pdata = i2c->dev.platform_data;
 
-	ret = snd_soc_register_codec(&i2c->dev,
-			&soc_codec_dev_max98095, &max98095_dai[0], 3);
+	ret = snd_soc_register_codec(&i2c->dev, &soc_codec_dev_max98095,
+				     max98095_dai, ARRAY_SIZE(max98095_dai));
 	if (ret < 0)
 		kfree(max98095);
 	return ret;
-- 
1.7.3.1

