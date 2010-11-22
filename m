Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab0KVA3P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 19:29:15 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:41123 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755371Ab0KVA3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 19:29:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=EysJMCDAi+6Q+18DkpfThbv1fYl/uiyPEGGAA65aZLMTeckf1SCAO2/5vRsQ3cKAEM
         QLkUw+uVsMjpikAJj27aPj2N4CbT43pVqc2y6BZxxLa8APyiS4hE8qiqeiK4fmZRF3mC
         7R52Jv7msS4lFLghOfKPZwIGzTvuKtADb4j/c=
Subject: [PATCH] ASoC: Fix a memory leak in alc5623_i2c_probe error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnaud Patard <arnaud.patard@rtp-net.org>
Content-Type: text/plain
Date: Mon, 22 Nov 2010 08:34:07 +0800
Message-Id: <1290386048.6941.6.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/alc5623.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/sound/soc/codecs/alc5623.c b/sound/soc/codecs/alc5623.c
index 5a45067..3315cdc 100644
--- a/sound/soc/codecs/alc5623.c
+++ b/sound/soc/codecs/alc5623.c
@@ -1023,10 +1023,8 @@ static int alc5623_i2c_probe(struct i2c_client *client,
 	dev_dbg(&client->dev, "Found codec id : alc56%02x\n", vid2);
 
 	alc5623 = kzalloc(sizeof(struct alc5623_priv), GFP_KERNEL);
-	if (alc5623 == NULL) {
-		ret = -ENOMEM;
-		goto err;
-	}
+	if (alc5623 == NULL)
+		return -ENOMEM;
 
 	pdata = client->dev.platform_data;
 	if (pdata) {
@@ -1057,12 +1055,9 @@ static int alc5623_i2c_probe(struct i2c_client *client,
 		&soc_codec_device_alc5623, &alc5623_dai, 1);
 	if (ret != 0) {
 		dev_err(&client->dev, "Failed to register codec: %d\n", ret);
-		goto err;
+		kfree(alc5623);
 	}
 
-	return 0;
-
-err:
 	return ret;
 }
 
-- 
1.7.0.4



