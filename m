Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab1K1LW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 06:22:26 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55971 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab1K1LWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 06:22:23 -0500
Message-ID: <1322479335.1939.6.camel@phoenix>
Subject: [PATCH] TTY: serial: convert drivers/tty/serial/* to use
 module_platform_driver()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Jamie Iles <jamie@jamieiles.com>,
        Yoichi Yuasa <yuasa@linux-mips.org>, linux-serial@vger.kernel.org
Date: Mon, 28 Nov 2011 19:22:15 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers in drivers/tty/serial/* to use the
module_platform_driver() macro which makes the code smaller and a bit
simpler.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jamie Iles <jamie@jamieiles.com>
Cc: Yoichi Yuasa <yuasa@linux-mips.org>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/tty/serial/8250_dw.c    |   12 +-----------
 drivers/tty/serial/sc26xx.c     |   14 +-------------
 drivers/tty/serial/timbuart.c   |   15 +--------------
 drivers/tty/serial/vr41xx_siu.c |   13 +------------
 4 files changed, 4 insertions(+), 50 deletions(-)

diff --git a/drivers/tty/serial/8250_dw.c b/drivers/tty/serial/8250_dw.c
index bf1fba6..f574eef 100644
--- a/drivers/tty/serial/8250_dw.c
+++ b/drivers/tty/serial/8250_dw.c
@@ -177,17 +177,7 @@ static struct platform_driver dw8250_platform_driver = {
 	.remove			= __devexit_p(dw8250_remove),
 };
 
-static int __init dw8250_init(void)
-{
-	return platform_driver_register(&dw8250_platform_driver);
-}
-module_init(dw8250_init);
-
-static void __exit dw8250_exit(void)
-{
-	platform_driver_unregister(&dw8250_platform_driver);
-}
-module_exit(dw8250_exit);
+module_platform_driver(dw8250_platform_driver);
 
 MODULE_AUTHOR("Jamie Iles");
 MODULE_LICENSE("GPL");
diff --git a/drivers/tty/serial/sc26xx.c b/drivers/tty/serial/sc26xx.c
index 75038ad..e0b4b0a 100644
--- a/drivers/tty/serial/sc26xx.c
+++ b/drivers/tty/serial/sc26xx.c
@@ -736,19 +736,7 @@ static struct platform_driver sc26xx_driver = {
 	},
 };
 
-static int __init sc26xx_init(void)
-{
-	return platform_driver_register(&sc26xx_driver);
-}
-
-static void __exit sc26xx_exit(void)
-{
-	platform_driver_unregister(&sc26xx_driver);
-}
-
-module_init(sc26xx_init);
-module_exit(sc26xx_exit);
-
+module_platform_driver(sc26xx_driver);
 
 MODULE_AUTHOR("Thomas Bogendörfer");
 MODULE_DESCRIPTION("SC681/SC2692 serial driver");
diff --git a/drivers/tty/serial/timbuart.c b/drivers/tty/serial/timbuart.c
index e76c8b7..70f9749 100644
--- a/drivers/tty/serial/timbuart.c
+++ b/drivers/tty/serial/timbuart.c
@@ -513,20 +513,7 @@ static struct platform_driver timbuart_platform_driver = {
 	.remove		= __devexit_p(timbuart_remove),
 };
 
-/*--------------------------------------------------------------------------*/
-
-static int __init timbuart_init(void)
-{
-	return platform_driver_register(&timbuart_platform_driver);
-}
-
-static void __exit timbuart_exit(void)
-{
-	platform_driver_unregister(&timbuart_platform_driver);
-}
-
-module_init(timbuart_init);
-module_exit(timbuart_exit);
+module_platform_driver(timbuart_platform_driver);
 
 MODULE_DESCRIPTION("Timberdale UART driver");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/tty/serial/vr41xx_siu.c b/drivers/tty/serial/vr41xx_siu.c
index 3beb6ab..83148e7 100644
--- a/drivers/tty/serial/vr41xx_siu.c
+++ b/drivers/tty/serial/vr41xx_siu.c
@@ -961,18 +961,7 @@ static struct platform_driver siu_device_driver = {
 	},
 };
 
-static int __init vr41xx_siu_init(void)
-{
-	return platform_driver_register(&siu_device_driver);
-}
-
-static void __exit vr41xx_siu_exit(void)
-{
-	platform_driver_unregister(&siu_device_driver);
-}
-
-module_init(vr41xx_siu_init);
-module_exit(vr41xx_siu_exit);
+module_platform_driver(siu_device_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:SIU");
-- 
1.7.5.4



