Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab2IFMMW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 08:12:22 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:53586 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753115Ab2IFMMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 08:12:18 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Tero Kristo <t-kristo@ti.com>, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, Benoit Cousson <b-cousson@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 01/14] MFD: twl4030-audio: Clean up MODULE_* and platform_driver part
Date: Thu,  6 Sep 2012 15:12:08 +0300
Message-Id: <1346933541-21547-2-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346933541-21547-1-git-send-email-peter.ujfalusi@ti.com>
References: <1346933541-21547-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Place the MODULE_* lines in the same block and add MODULE_DESCRIPTION.
Rearange the platform_driver structure at the same time.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl4030-audio.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/twl4030-audio.c b/drivers/mfd/twl4030-audio.c
index 838ce4e..ac04b4f 100644
--- a/drivers/mfd/twl4030-audio.c
+++ b/drivers/mfd/twl4030-audio.c
@@ -250,18 +250,18 @@ static int __devexit twl4030_audio_remove(struct platform_device *pdev)
 	return 0;
 }
 
-MODULE_ALIAS("platform:twl4030-audio");
-
 static struct platform_driver twl4030_audio_driver = {
-	.probe		= twl4030_audio_probe,
-	.remove		= __devexit_p(twl4030_audio_remove),
 	.driver		= {
 		.owner	= THIS_MODULE,
 		.name	= "twl4030-audio",
 	},
+	.probe		= twl4030_audio_probe,
+	.remove		= __devexit_p(twl4030_audio_remove),
 };
 
 module_platform_driver(twl4030_audio_driver);
 
 MODULE_AUTHOR("Peter Ujfalusi <peter.ujfalusi@ti.com>");
+MODULE_DESCRIPTION("TWL4030 audio block MFD driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:twl4030-audio");
-- 
1.7.12

