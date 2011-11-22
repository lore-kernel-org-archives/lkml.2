Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222Ab1KVJDX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 04:03:23 -0500
Received: from emcscan.emc.com.tw ([192.72.220.5]:44290 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452Ab1KVJCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 04:02:55 -0500
From: JJ Ding <jj_ding@emc.com.tw>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        JJ Ding <jj_ding@emc.com.tw>, JJ Ding <dgdunix@gmail.com>
Subject: [PATCH TRIVIAL 3/5] Input: mouse: use macro module_platform_driver()
Date: Tue, 22 Nov 2011 17:00:44 +0800
Message-Id: <1321952446-7591-4-git-send-email-jj_ding@emc.com.tw>
X-Mailer: git-send-email 1.7.8-rc2
In-Reply-To: <1321952446-7591-1-git-send-email-jj_ding@emc.com.tw>
References: <1321952446-7591-1-git-send-email-jj_ding@emc.com.tw>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: JJ Ding <dgdunix@gmail.com>

Commit 940ab88962bc1aff3273a8356d64577a6e386736 introduced a new macro to
save some platform_driver boilerplate code. Use it.

Signed-off-by: JJ Ding <dgdunix@gmail.com>
---
 drivers/input/mouse/amimouse.c       |   16 ++--------------
 drivers/input/mouse/gpio_mouse.c     |   13 +------------
 drivers/input/mouse/pxa930_trkball.c |   14 +-------------
 3 files changed, 4 insertions(+), 39 deletions(-)

diff --git a/drivers/input/mouse/amimouse.c b/drivers/input/mouse/amimouse.c
index ff5f61a..39be7b8 100644
--- a/drivers/input/mouse/amimouse.c
+++ b/drivers/input/mouse/amimouse.c
@@ -140,25 +140,13 @@ static int __exit amimouse_remove(struct platform_device *pdev)
 }
 
 static struct platform_driver amimouse_driver = {
+	.probe = amimouse_probe,
 	.remove = __exit_p(amimouse_remove),
 	.driver   = {
 		.name	= "amiga-mouse",
 		.owner	= THIS_MODULE,
 	},
 };
-
-static int __init amimouse_init(void)
-{
-	return platform_driver_probe(&amimouse_driver, amimouse_probe);
-}
-
-module_init(amimouse_init);
-
-static void __exit amimouse_exit(void)
-{
-	platform_driver_unregister(&amimouse_driver);
-}
-
-module_exit(amimouse_exit);
+module_platform_driver(amimouse_driver);
 
 MODULE_ALIAS("platform:amiga-mouse");
diff --git a/drivers/input/mouse/gpio_mouse.c b/drivers/input/mouse/gpio_mouse.c
index 58902fb..a9ad8e1 100644
--- a/drivers/input/mouse/gpio_mouse.c
+++ b/drivers/input/mouse/gpio_mouse.c
@@ -178,18 +178,7 @@ static struct platform_driver gpio_mouse_device_driver = {
 		.owner	= THIS_MODULE,
 	}
 };
-
-static int __init gpio_mouse_init(void)
-{
-	return platform_driver_register(&gpio_mouse_device_driver);
-}
-module_init(gpio_mouse_init);
-
-static void __exit gpio_mouse_exit(void)
-{
-	platform_driver_unregister(&gpio_mouse_device_driver);
-}
-module_exit(gpio_mouse_exit);
+module_platform_driver(gpio_mouse_device_driver);
 
 MODULE_AUTHOR("Hans-Christian Egtvedt <egtvedt@samfundet.no>");
 MODULE_DESCRIPTION("GPIO mouse driver");
diff --git a/drivers/input/mouse/pxa930_trkball.c b/drivers/input/mouse/pxa930_trkball.c
index ee3b0ca..a9e4bfd 100644
--- a/drivers/input/mouse/pxa930_trkball.c
+++ b/drivers/input/mouse/pxa930_trkball.c
@@ -250,19 +250,7 @@ static struct platform_driver pxa930_trkball_driver = {
 	.probe		= pxa930_trkball_probe,
 	.remove		= __devexit_p(pxa930_trkball_remove),
 };
-
-static int __init pxa930_trkball_init(void)
-{
-	return platform_driver_register(&pxa930_trkball_driver);
-}
-
-static void __exit pxa930_trkball_exit(void)
-{
-	platform_driver_unregister(&pxa930_trkball_driver);
-}
-
-module_init(pxa930_trkball_init);
-module_exit(pxa930_trkball_exit);
+module_platform_driver(pxa930_trkball_driver);
 
 MODULE_AUTHOR("Yong Yao <yaoyong@marvell.com>");
 MODULE_DESCRIPTION("PXA930 Trackball Mouse Driver");
-- 
1.7.8-rc2

