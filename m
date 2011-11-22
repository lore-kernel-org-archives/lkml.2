Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619Ab1KVJDP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 04:03:15 -0500
Received: from emcscan.emc.com.tw ([192.72.220.5]:24345 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011Ab1KVJC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 04:02:56 -0500
From: JJ Ding <jj_ding@emc.com.tw>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        JJ Ding <jj_ding@emc.com.tw>, JJ Ding <dgdunix@gmail.com>
Subject: [PATCH TRIVIAL 4/5] Input: serio: use macro module_platform_driver()
Date: Tue, 22 Nov 2011 17:00:45 +0800
Message-Id: <1321952446-7591-5-git-send-email-jj_ding@emc.com.tw>
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
 drivers/input/serio/altera_ps2.c |   13 +------------
 drivers/input/serio/at32psif.c   |   14 +-------------
 drivers/input/serio/rpckbd.c     |   14 +-------------
 drivers/input/serio/xilinx_ps2.c |   14 +-------------
 4 files changed, 4 insertions(+), 51 deletions(-)

diff --git a/drivers/input/serio/altera_ps2.c b/drivers/input/serio/altera_ps2.c
index d363dc4..35864c6 100644
--- a/drivers/input/serio/altera_ps2.c
+++ b/drivers/input/serio/altera_ps2.c
@@ -196,18 +196,7 @@ static struct platform_driver altera_ps2_driver = {
 		.of_match_table = altera_ps2_match,
 	},
 };
-
-static int __init altera_ps2_init(void)
-{
-	return platform_driver_register(&altera_ps2_driver);
-}
-module_init(altera_ps2_init);
-
-static void __exit altera_ps2_exit(void)
-{
-	platform_driver_unregister(&altera_ps2_driver);
-}
-module_exit(altera_ps2_exit);
+module_platform_driver(altera_ps2_driver);
 
 MODULE_DESCRIPTION("Altera University Program PS2 controller driver");
 MODULE_AUTHOR("Thomas Chou <thomas@wytron.com.tw>");
diff --git a/drivers/input/serio/at32psif.c b/drivers/input/serio/at32psif.c
index 95280f9..421a744 100644
--- a/drivers/input/serio/at32psif.c
+++ b/drivers/input/serio/at32psif.c
@@ -358,19 +358,7 @@ static struct platform_driver psif_driver = {
 	.suspend	= psif_suspend,
 	.resume		= psif_resume,
 };
-
-static int __init psif_init(void)
-{
-	return platform_driver_probe(&psif_driver, psif_probe);
-}
-
-static void __exit psif_exit(void)
-{
-	platform_driver_unregister(&psif_driver);
-}
-
-module_init(psif_init);
-module_exit(psif_exit);
+module_platform_driver(psif_driver);
 
 MODULE_AUTHOR("Hans-Christian Egtvedt <egtvedt@samfundet.no>");
 MODULE_DESCRIPTION("Atmel AVR32 PSIF PS/2 driver");
diff --git a/drivers/input/serio/rpckbd.c b/drivers/input/serio/rpckbd.c
index 7ec3c97..8b44ddc 100644
--- a/drivers/input/serio/rpckbd.c
+++ b/drivers/input/serio/rpckbd.c
@@ -143,16 +143,4 @@ static struct platform_driver rpckbd_driver = {
 		.owner	= THIS_MODULE,
 	},
 };
-
-static int __init rpckbd_init(void)
-{
-	return platform_driver_register(&rpckbd_driver);
-}
-
-static void __exit rpckbd_exit(void)
-{
-	platform_driver_unregister(&rpckbd_driver);
-}
-
-module_init(rpckbd_init);
-module_exit(rpckbd_exit);
+module_platform_driver(rpckbd_driver);
diff --git a/drivers/input/serio/xilinx_ps2.c b/drivers/input/serio/xilinx_ps2.c
index d64c5a4..127c391 100644
--- a/drivers/input/serio/xilinx_ps2.c
+++ b/drivers/input/serio/xilinx_ps2.c
@@ -369,19 +369,7 @@ static struct platform_driver xps2_of_driver = {
 	.probe		= xps2_of_probe,
 	.remove		= __devexit_p(xps2_of_remove),
 };
-
-static int __init xps2_init(void)
-{
-	return platform_driver_register(&xps2_of_driver);
-}
-
-static void __exit xps2_cleanup(void)
-{
-	platform_driver_unregister(&xps2_of_driver);
-}
-
-module_init(xps2_init);
-module_exit(xps2_cleanup);
+module_platform_driver(xps2_of_driver);
 
 MODULE_AUTHOR("Xilinx, Inc.");
 MODULE_DESCRIPTION("Xilinx XPS PS/2 driver");
-- 
1.7.8-rc2

