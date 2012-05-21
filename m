Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582Ab2EUJUK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:20:10 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:57170 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757409Ab2EUJUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:20:03 -0400
X-AuditID: cbfee61b-b7faf6d000001f49-da-4fba08c1ed6c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Johan Hovold'" <jhovold@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 3/3] backlight: lm3533_bl: use devm_ functions
Date: Mon, 21 May 2012 18:20:01 +0900
Message-id: <002d01cd3732$e667d7b0$b3378710$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac03MuZFAb/avBI5R1CWbY6n/+4MYw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jQd2DHLv8DZaetrK4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZfy8uYi54xVPx6+cGxgbG61xdjJwcEgImErN2NDFB2GISF+6t
	ZwOxhQSmM0ocPWbaxcgFZM9mktjb1MUOkmATUJP48uUwmC0iECHRPGMWM4jNLFAkse7RVTBb
	WMBOYkLPY1YQm0VAVWLu9r1gcV4BW4kZ27+xQNiCEj8m32OB6NWSWL/zOBOELS+xec1boHoO
	oIPUJR791YVYpSdxcNNrqBIRiX0v3jFOYBSYhWTSLCSTZiGZNAtJywJGllWMoqkFyQXFSem5
	RnrFibnFpXnpesn5uZsYwWH5THoH46oGi0OMAhyMSjy8C97s9BdiTSwrrsw9xCjBwawkwnv3
	IVCINyWxsiq1KD++qDQntfgQozQHi5I475MlO/yFBNITS1KzU1MLUotgskwcnFINjKrrfjDY
	TBfsLj2/67mmX8ZSl5LvPwN5pPxbz5bfuzDx9f9De+Picl4HWkomn+vxCDwhH/bJoTVyW9y+
	pD3Gck+vxnuUr/dLnyZeGuyq26y9M4O76Krts5S3S+ZJ2SmxhF5Lyy05n5V/tTac90iZmkeZ
	2E6FmQsmnD+5mi9mv6f795nSTqLPlViKMxINtZiLihMBYEj1A0cCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The devm_ functions allocate memory that is released when a driver
detaches. This patch uses devm_kzalloc of these functions.

Cc: Johan Hovold <jhovold@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/lm3533_bl.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/video/backlight/lm3533_bl.c b/drivers/video/backlight/lm3533_bl.c
index 0148227..9f96a6b 100644
--- a/drivers/video/backlight/lm3533_bl.c
+++ b/drivers/video/backlight/lm3533_bl.c
@@ -295,7 +295,7 @@ static int __devinit lm3533_bl_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	bl = kzalloc(sizeof(*bl), GFP_KERNEL);
+	bl = devm_kzalloc(&pdev->dev, sizeof(*bl), GFP_KERNEL);
 	if (!bl) {
 		dev_err(&pdev->dev,
 				"failed to allocate memory for backlight\n");
@@ -318,7 +318,7 @@ static int __devinit lm3533_bl_probe(struct platform_device *pdev)
 	if (IS_ERR(bd)) {
 		dev_err(&pdev->dev, "failed to register backlight device\n");
 		ret = PTR_ERR(bd);
-		goto err_free;
+		goto err_return;
 	}
 
 	bl->bd = bd;
@@ -348,8 +348,7 @@ err_sysfs_remove:
 	sysfs_remove_group(&bd->dev.kobj, &lm3533_bl_attribute_group);
 err_unregister:
 	backlight_device_unregister(bd);
-err_free:
-	kfree(bl);
+err_return:
 
 	return ret;
 }
@@ -367,7 +366,6 @@ static int __devexit lm3533_bl_remove(struct platform_device *pdev)
 	lm3533_ctrlbank_disable(&bl->cb);
 	sysfs_remove_group(&bd->dev.kobj, &lm3533_bl_attribute_group);
 	backlight_device_unregister(bd);
-	kfree(bl);
 
 	return 0;
 }
-- 
1.7.1


