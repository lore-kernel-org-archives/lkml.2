Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758362Ab2BIWaR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 17:30:17 -0500
Received: from mail132.messagelabs.com ([216.82.242.115]:59373 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab2BIWaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 17:30:15 -0500
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-132.messagelabs.com!1328826610!1695983!15
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.5; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] rtc: convert rtc-ep93xx to use module_platform_driver()
Date: Thu, 9 Feb 2012 15:29:45 -0700
User-Agent: KMail/1.9.9
CC: <rtc-linux@googlegroups.com>, <a.zummo@towertech.it>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201202091529.45783.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use module_platform_driver() to remove the boilerplate code.

Also, change the probe and remove functions to __devinit/__devexit.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>

---

diff --git a/drivers/rtc/rtc-ep93xx.c b/drivers/rtc/rtc-ep93xx.c
index 14a42a1..9602278 100644
--- a/drivers/rtc/rtc-ep93xx.c
+++ b/drivers/rtc/rtc-ep93xx.c
@@ -127,7 +127,7 @@ static const struct attribute_group ep93xx_rtc_sysfs_files = {
 	.attrs	= ep93xx_rtc_attrs,
 };
 
-static int __init ep93xx_rtc_probe(struct platform_device *pdev)
+static int __devinit ep93xx_rtc_probe(struct platform_device *pdev)
 {
 	struct ep93xx_rtc *ep93xx_rtc;
 	struct resource *res;
@@ -174,7 +174,7 @@ exit:
 	return err;
 }
 
-static int __exit ep93xx_rtc_remove(struct platform_device *pdev)
+static int __devexit ep93xx_rtc_remove(struct platform_device *pdev)
 {
 	struct ep93xx_rtc *ep93xx_rtc = platform_get_drvdata(pdev);
 
@@ -186,31 +186,19 @@ static int __exit ep93xx_rtc_remove(struct platform_device *pdev)
 	return 0;
 }
 
-/* work with hotplug and coldplug */
-MODULE_ALIAS("platform:ep93xx-rtc");
-
 static struct platform_driver ep93xx_rtc_driver = {
 	.driver		= {
 		.name	= "ep93xx-rtc",
 		.owner	= THIS_MODULE,
 	},
-	.remove		= __exit_p(ep93xx_rtc_remove),
+	.probe		= ep93xx_rtc_probe,
+	.remove		= __devexit_p(ep93xx_rtc_remove),
 };
 
-static int __init ep93xx_rtc_init(void)
-{
-        return platform_driver_probe(&ep93xx_rtc_driver, ep93xx_rtc_probe);
-}
-
-static void __exit ep93xx_rtc_exit(void)
-{
-	platform_driver_unregister(&ep93xx_rtc_driver);
-}
+module_platform_driver(ep93xx_rtc_driver);
 
 MODULE_AUTHOR("Alessandro Zummo <a.zummo@towertech.it>");
 MODULE_DESCRIPTION("EP93XX RTC driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
-
-module_init(ep93xx_rtc_init);
-module_exit(ep93xx_rtc_exit);
+MODULE_ALIAS("platform:ep93xx-rtc");
