Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751177Ab2I3K2m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 06:28:42 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:33089 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab2I3K2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 06:28:41 -0400
Message-ID: <1349000906.28456.1.camel@phoenix>
Subject: [PATCH] backlight: tps65217_bl: Add missing platform_set_drvdata in
 tps65217_bl_probe
From: Axel Lin <axel.lin@ingics.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Matthias Kaehlcke <matthias@kaehlcke.net>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Sun, 30 Sep 2012 18:28:26 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise, we got NULL derefernce while calling backlight_device_unregister()
in tps65217_bl_remove().

Also convert to use module_platform_driver.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/video/backlight/tps65217_bl.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/video/backlight/tps65217_bl.c b/drivers/video/backlight/tps65217_bl.c
index 6ac2ef5..7088163 100644
--- a/drivers/video/backlight/tps65217_bl.c
+++ b/drivers/video/backlight/tps65217_bl.c
@@ -312,6 +312,7 @@ static int tps65217_bl_probe(struct platform_device *pdev)
 	}
 
 	tps65217_bl->bl->props.brightness = 0;
+	platform_set_drvdata(pdev, tps65217_bl);
 
 	return 0;
 }
@@ -334,18 +335,7 @@ static struct platform_driver tps65217_bl_driver = {
 	},
 };
 
-static int __init tps65217_bl_init(void)
-{
-	return platform_driver_register(&tps65217_bl_driver);
-}
-
-static void __exit tps65217_bl_exit(void)
-{
-	platform_driver_unregister(&tps65217_bl_driver);
-}
-
-module_init(tps65217_bl_init);
-module_exit(tps65217_bl_exit);
+module_platform_driver(tps65217_bl_driver);
 
 MODULE_DESCRIPTION("TPS65217 Backlight driver");
 MODULE_LICENSE("GPL v2");
-- 
1.7.9.5



