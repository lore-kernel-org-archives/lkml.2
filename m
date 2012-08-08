Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030201Ab2HHJo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 05:44:58 -0400
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:39799 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030197Ab2HHJlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 05:41:46 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Dmitry Torokhov <dtor@mail.ru>
Cc: alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Benoit Cousson <b-cousson@ti.com>
Subject: [PATCH 02/11] MFD: twl4030-audio: Convert to use devm_kzalloc
Date: Wed,  8 Aug 2012 12:41:18 +0300
Message-Id: <1344418887-5262-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1344418887-5262-1-git-send-email-peter.ujfalusi@ti.com>
References: <1344418887-5262-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl4030-audio.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/twl4030-audio.c b/drivers/mfd/twl4030-audio.c
index ac04b4f..efa2d42 100644
--- a/drivers/mfd/twl4030-audio.c
+++ b/drivers/mfd/twl4030-audio.c
@@ -188,7 +188,8 @@ static int __devinit twl4030_audio_probe(struct platform_device *pdev)
 	twl_i2c_write_u8(TWL4030_MODULE_AUDIO_VOICE,
 					val, TWL4030_REG_APLL_CTL);
 
-	audio = kzalloc(sizeof(struct twl4030_audio), GFP_KERNEL);
+	audio = devm_kzalloc(&pdev->dev, sizeof(struct twl4030_audio),
+			     GFP_KERNEL);
 	if (!audio)
 		return -ENOMEM;
 
@@ -229,22 +230,18 @@ static int __devinit twl4030_audio_probe(struct platform_device *pdev)
 		ret = -ENODEV;
 	}
 
-	if (!ret)
-		return 0;
+	if (ret) {
+		platform_set_drvdata(pdev, NULL);
+		twl4030_audio_dev = NULL;
+	}
 
-	platform_set_drvdata(pdev, NULL);
-	kfree(audio);
-	twl4030_audio_dev = NULL;
 	return ret;
 }
 
 static int __devexit twl4030_audio_remove(struct platform_device *pdev)
 {
-	struct twl4030_audio *audio = platform_get_drvdata(pdev);
-
 	mfd_remove_devices(&pdev->dev);
 	platform_set_drvdata(pdev, NULL);
-	kfree(audio);
 	twl4030_audio_dev = NULL;
 
 	return 0;
-- 
1.7.8.6

