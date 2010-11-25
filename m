Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab0KYIpr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 03:45:47 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55262 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab0KYIpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 03:45:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=sTfwTgfP3jdvFshfMOCuawFVgKvLQtlxIRdT3EMA2QtHmTqD6+srmJyS8NOcX516KZ
         cYpnjUzR7VleCQyG/etIVd/M9aq9KlNZ0GTtiaEVvTpEAlJTdW6UopQBUy4h7TS48tfx
         Jq7U7GEtf+BrHWStBqRSDUbi5i2VFdeMYH4yc=
Subject: [PATCH] ASoC: neo1973_gta02_wm8753: fix wrong parameter for
	snd_soc_register_dai and snd_soc_unregister_dai
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Graeme Gregory <graeme@openmoko.org>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain
Date: Thu, 25 Nov 2010 16:50:56 +0800
Message-Id: <1290675056.1928.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/samsung/neo1973_gta02_wm8753.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/samsung/neo1973_gta02_wm8753.c b/sound/soc/samsung/neo1973_gta02_wm8753.c
index 920e8d1..8c65b63 100644
--- a/sound/soc/samsung/neo1973_gta02_wm8753.c
+++ b/sound/soc/samsung/neo1973_gta02_wm8753.c
@@ -438,7 +438,7 @@ static int __init neo1973_gta02_init(void)
 		return -ENOMEM;
 
 	/* register bluetooth DAI here */
-	ret = snd_soc_register_dai(&neo1973_gta02_snd_device->dev, -1, &bt_dai);
+	ret = snd_soc_register_dai(&neo1973_gta02_snd_device->dev, &bt_dai);
 	if (ret) {
 		platform_device_put(neo1973_gta02_snd_device);
 		return ret;
@@ -491,7 +491,7 @@ module_init(neo1973_gta02_init);
 
 static void __exit neo1973_gta02_exit(void)
 {
-	snd_soc_unregister_dai(&neo1973_gta02_snd_device->dev, -1);
+	snd_soc_unregister_dai(&neo1973_gta02_snd_device->dev);
 	platform_device_unregister(neo1973_gta02_snd_device);
 	gpio_free(GTA02_GPIO_HP_IN);
 	gpio_free(GTA02_GPIO_AMP_SHUT);
-- 
1.7.2



