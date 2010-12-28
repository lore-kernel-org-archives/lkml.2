Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744Ab0L1UJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 15:09:19 -0500
Received: from smtp-out-091.synserver.de ([212.40.180.91]:1048 "HELO
	smtp-out-089.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1751033Ab0L1UJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 15:09:18 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 10063
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] ASoC: codecs: Add missing control_type initialization
Date: Tue, 28 Dec 2010 21:08:57 +0100
Message-Id: <1293566937-7937-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some codec drivers do not initialize the control_type field in their private
device struct, but still use it when calling snd_soc_codec_set_cache_io.
This patch fixes the issue by properly initializing it in the drivers probe
functions.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

---
Compile tested only
---
 sound/soc/codecs/wm8940.c |    1 +
 sound/soc/codecs/wm8955.c |    1 +
 sound/soc/codecs/wm8960.c |    1 +
 sound/soc/codecs/wm8971.c |    1 +
 sound/soc/codecs/wm9081.c |    1 +
 5 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/wm8940.c b/sound/soc/codecs/wm8940.c
index f8c33b6..a2c788f 100644
--- a/sound/soc/codecs/wm8940.c
+++ b/sound/soc/codecs/wm8940.c
@@ -767,6 +767,7 @@ static __devinit int wm8940_i2c_probe(struct i2c_client *i2c,
 
 	i2c_set_clientdata(i2c, wm8940);
 	wm8940->control_data = i2c;
+	wm8940->control_type = SND_SOC_I2C;
 
 	ret = snd_soc_register_codec(&i2c->dev,
 			&soc_codec_dev_wm8940, &wm8940_dai, 1);
diff --git a/sound/soc/codecs/wm8955.c b/sound/soc/codecs/wm8955.c
index fdc7c8a..2ac35b0 100644
--- a/sound/soc/codecs/wm8955.c
+++ b/sound/soc/codecs/wm8955.c
@@ -1003,6 +1003,7 @@ static __devinit int wm8955_i2c_probe(struct i2c_client *i2c,
 		return -ENOMEM;
 
 	i2c_set_clientdata(i2c, wm8955);
+	wm8955->control_type = SND_SOC_I2C;
 
 	ret = snd_soc_register_codec(&i2c->dev,
 			&soc_codec_dev_wm8955, &wm8955_dai, 1);
diff --git a/sound/soc/codecs/wm8960.c b/sound/soc/codecs/wm8960.c
index 6983502..4a99b766 100644
--- a/sound/soc/codecs/wm8960.c
+++ b/sound/soc/codecs/wm8960.c
@@ -1012,6 +1012,7 @@ static __devinit int wm8960_i2c_probe(struct i2c_client *i2c,
 		return -ENOMEM;
 
 	i2c_set_clientdata(i2c, wm8960);
+	wm8960->control_type = SND_SOC_I2C;
 	wm8960->control_data = i2c;
 
 	ret = snd_soc_register_codec(&i2c->dev,
diff --git a/sound/soc/codecs/wm8971.c b/sound/soc/codecs/wm8971.c
index 63f6dbf..9f18db6 100644
--- a/sound/soc/codecs/wm8971.c
+++ b/sound/soc/codecs/wm8971.c
@@ -718,6 +718,7 @@ static __devinit int wm8971_i2c_probe(struct i2c_client *i2c,
 	if (wm8971 == NULL)
 		return -ENOMEM;
 
+	wm8971->control_type = SND_SOC_I2C;
 	i2c_set_clientdata(i2c, wm8971);
 
 	ret = snd_soc_register_codec(&i2c->dev,
diff --git a/sound/soc/codecs/wm9081.c b/sound/soc/codecs/wm9081.c
index 11018e2..badc8ee 100644
--- a/sound/soc/codecs/wm9081.c
+++ b/sound/soc/codecs/wm9081.c
@@ -1334,6 +1334,7 @@ static __devinit int wm9081_i2c_probe(struct i2c_client *i2c,
 		return -ENOMEM;
 
 	i2c_set_clientdata(i2c, wm9081);
+	wm9081->control_type = SND_SOC_I2C;
 	wm9081->control_data = i2c;
 
 	ret = snd_soc_register_codec(&i2c->dev,
-- 
1.7.2.3

