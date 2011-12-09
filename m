Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab1LICOQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 21:14:16 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39028 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab1LICOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 21:14:14 -0500
Message-ID: <1323396846.3740.10.camel@phoenix>
Subject: [PATCH] Input: mc13783-pwrbutton - convert to use
 module_platform_driver()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-input@vger.kernel.org
Date: Fri, 09 Dec 2011 10:14:06 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts mc13783-pwrbutton to use the module_platform_driver()
macro which makes the code smaller and a bit simpler.

Also staticise mc13783_pwrbutton_driver which is not used outside
this driver so no need to make the symbol global.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/misc/mc13783-pwrbutton.c |   14 ++------------
 1 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/input/misc/mc13783-pwrbutton.c b/drivers/input/misc/mc13783-pwrbutton.c
index 09b0522..8428f1e 100644
--- a/drivers/input/misc/mc13783-pwrbutton.c
+++ b/drivers/input/misc/mc13783-pwrbutton.c
@@ -255,7 +255,7 @@ static int __devexit mc13783_pwrbutton_remove(struct platform_device *pdev)
 	return 0;
 }
 
-struct platform_driver mc13783_pwrbutton_driver = {
+static struct platform_driver mc13783_pwrbutton_driver = {
 	.probe		= mc13783_pwrbutton_probe,
 	.remove		= __devexit_p(mc13783_pwrbutton_remove),
 	.driver		= {
@@ -264,17 +264,7 @@ struct platform_driver mc13783_pwrbutton_driver = {
 	},
 };
 
-static int __init mc13783_pwrbutton_init(void)
-{
-	return platform_driver_register(&mc13783_pwrbutton_driver);
-}
-module_init(mc13783_pwrbutton_init);
-
-static void __exit mc13783_pwrbutton_exit(void)
-{
-	platform_driver_unregister(&mc13783_pwrbutton_driver);
-}
-module_exit(mc13783_pwrbutton_exit);
+module_platform_driver(mc13783_pwrbutton_driver);
 
 MODULE_ALIAS("platform:mc13783-pwrbutton");
 MODULE_DESCRIPTION("MC13783 Power Button");
-- 
1.7.5.4



