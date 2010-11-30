Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab0K3H2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 02:28:33 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43688 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab0K3H2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 02:28:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=lOpnfhGNG38jbB9wDRhMXlBiJS9TbZ/9+SApfR+8AQHVi3p6C1W778cGy8BZeeW1w9
         uAhT9bgcSOyQf2PACjrjs6pH4oIci3HeobpKuLMLgY8r/i7PgMKgEfQdvXa9UocL6yhr
         0jJxvNTwmadUDF22uTwcdesQRbAlSaHfQO110=
Subject: [PATCH] ASoC: Simplify pm860x_probe error handling
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain
Date: Tue, 30 Nov 2010 15:34:11 +0800
Message-Id: <1291102451.6929.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify pm860x_probe error handling and return actual error code we got.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/88pm860x-codec.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/sound/soc/codecs/88pm860x-codec.c b/sound/soc/codecs/88pm860x-codec.c
index 7e4d880..08e15de 100644
--- a/sound/soc/codecs/88pm860x-codec.c
+++ b/sound/soc/codecs/88pm860x-codec.c
@@ -1358,7 +1358,7 @@ static int pm860x_probe(struct snd_soc_codec *codec)
 					   pm860x->name[i], pm860x);
 		if (ret < 0) {
 			dev_err(codec->dev, "Failed to request IRQ!\n");
-			goto out_irq;
+			goto out;
 		}
 	}
 
@@ -1369,7 +1369,7 @@ static int pm860x_probe(struct snd_soc_codec *codec)
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to fill register cache: %d\n",
 			ret);
-		goto out_codec;
+		goto out;
 	}
 
 	snd_soc_add_controls(codec, pm860x_snd_controls,
@@ -1379,12 +1379,10 @@ static int pm860x_probe(struct snd_soc_codec *codec)
 	snd_soc_dapm_add_routes(dapm, audio_map, ARRAY_SIZE(audio_map));
 	return 0;
 
-out_codec:
-	i = 3;
-out_irq:
-	for (; i >= 0; i--)
+out:
+	while (--i >= 0)
 		free_irq(pm860x->irq[i], pm860x);
-	return -EINVAL;
+	return ret;
 }
 
 static int pm860x_remove(struct snd_soc_codec *codec)
-- 
1.7.2



