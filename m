Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517Ab3AILPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 06:15:44 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:35301 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756183Ab3AILPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 06:15:41 -0500
From: Fabio Porcedda <fabio.porcedda@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-watchdog@vger.kernel.org, linux-usb@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: [PATCH 3/3] usb: converto drivers/usb/* to use module_platform_driver_probe()
Date: Wed,  9 Jan 2013 12:15:28 +0100
Message-Id: <1357730128-23018-4-git-send-email-fabio.porcedda@gmail.com>
X-Mailer: git-send-email 1.8.0.3
In-Reply-To: <1357730128-23018-1-git-send-email-fabio.porcedda@gmail.com>
References: <1357730128-23018-1-git-send-email-fabio.porcedda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers in drivers/usb/* to use the
module_platform_driver_probe() macro which makes the code smaller and
a bit simpler.

Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
Cc: linux-usb@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
---
 drivers/usb/gadget/at91_udc.c       | 12 +-----------
 drivers/usb/gadget/atmel_usba_udc.c | 12 +-----------
 drivers/usb/gadget/fusb300_udc.c    | 13 +------------
 drivers/usb/gadget/imx_udc.c        | 12 +-----------
 drivers/usb/gadget/lpc32xx_udc.c    | 12 +-----------
 drivers/usb/gadget/m66592-udc.c     | 12 +-----------
 drivers/usb/gadget/pxa25x_udc.c     | 15 +++------------
 drivers/usb/gadget/r8a66597-udc.c   | 15 ++-------------
 drivers/usb/otg/gpio_vbus.c         | 12 +-----------
 drivers/usb/otg/msm_otg.c           | 13 +------------
 10 files changed, 13 insertions(+), 115 deletions(-)

diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
index f4a21f6..0143ffa 100644
--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -1982,17 +1982,7 @@ static struct platform_driver at91_udc_driver = {
 	},
 };
 
-static int __init udc_init_module(void)
-{
-	return platform_driver_probe(&at91_udc_driver, at91udc_probe);
-}
-module_init(udc_init_module);
-
-static void __exit udc_exit_module(void)
-{
-	platform_driver_unregister(&at91_udc_driver);
-}
-module_exit(udc_exit_module);
+module_platform_driver_probe(at91_udc_driver, at91udc_probe);
 
 MODULE_DESCRIPTION("AT91 udc driver");
 MODULE_AUTHOR("Thomas Rathbone, David Brownell");
diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
index a7aed84..bc19496 100644
--- a/drivers/usb/gadget/atmel_usba_udc.c
+++ b/drivers/usb/gadget/atmel_usba_udc.c
@@ -2066,17 +2066,7 @@ static struct platform_driver udc_driver = {
 	},
 };
 
-static int __init udc_init(void)
-{
-	return platform_driver_probe(&udc_driver, usba_udc_probe);
-}
-module_init(udc_init);
-
-static void __exit udc_exit(void)
-{
-	platform_driver_unregister(&udc_driver);
-}
-module_exit(udc_exit);
+module_platform_driver_probe(udc_driver, usba_udc_probe);
 
 MODULE_DESCRIPTION("Atmel USBA UDC driver");
 MODULE_AUTHOR("Haavard Skinnemoen (Atmel)");
diff --git a/drivers/usb/gadget/fusb300_udc.c b/drivers/usb/gadget/fusb300_udc.c
index 72cd5e6..fc7cb09 100644
--- a/drivers/usb/gadget/fusb300_udc.c
+++ b/drivers/usb/gadget/fusb300_udc.c
@@ -1547,15 +1547,4 @@ static struct platform_driver fusb300_driver = {
 	},
 };
 
-static int __init fusb300_udc_init(void)
-{
-	return platform_driver_probe(&fusb300_driver, fusb300_probe);
-}
-
-module_init(fusb300_udc_init);
-
-static void __exit fusb300_udc_cleanup(void)
-{
-	platform_driver_unregister(&fusb300_driver);
-}
-module_exit(fusb300_udc_cleanup);
+module_platform_driver_probe(fusb300_driver, fusb300_probe);
diff --git a/drivers/usb/gadget/imx_udc.c b/drivers/usb/gadget/imx_udc.c
index a0eb857..8efd755 100644
--- a/drivers/usb/gadget/imx_udc.c
+++ b/drivers/usb/gadget/imx_udc.c
@@ -1556,17 +1556,7 @@ static struct platform_driver udc_driver = {
 	.resume		= imx_udc_resume,
 };
 
-static int __init udc_init(void)
-{
-	return platform_driver_probe(&udc_driver, imx_udc_probe);
-}
-module_init(udc_init);
-
-static void __exit udc_exit(void)
-{
-	platform_driver_unregister(&udc_driver);
-}
-module_exit(udc_exit);
+module_platform_driver_probe(udc_driver, imx_udc_probe);
 
 MODULE_DESCRIPTION("IMX USB Device Controller driver");
 MODULE_AUTHOR("Darius Augulis <augulis.darius@gmail.com>");
diff --git a/drivers/usb/gadget/lpc32xx_udc.c b/drivers/usb/gadget/lpc32xx_udc.c
index dd1c9b1..aa04089 100644
--- a/drivers/usb/gadget/lpc32xx_udc.c
+++ b/drivers/usb/gadget/lpc32xx_udc.c
@@ -3458,17 +3458,7 @@ static struct platform_driver lpc32xx_udc_driver = {
 	},
 };
 
-static int __init udc_init_module(void)
-{
-	return platform_driver_probe(&lpc32xx_udc_driver, lpc32xx_udc_probe);
-}
-module_init(udc_init_module);
-
-static void __exit udc_exit_module(void)
-{
-	platform_driver_unregister(&lpc32xx_udc_driver);
-}
-module_exit(udc_exit_module);
+module_platform_driver_probe(lpc32xx_udc_driver, lpc32xx_udc_probe);
 
 MODULE_DESCRIPTION("LPC32XX udc driver");
 MODULE_AUTHOR("Kevin Wells <kevin.wells@nxp.com>");
diff --git a/drivers/usb/gadget/m66592-udc.c b/drivers/usb/gadget/m66592-udc.c
index b6401f1..dfce0cf 100644
--- a/drivers/usb/gadget/m66592-udc.c
+++ b/drivers/usb/gadget/m66592-udc.c
@@ -1753,14 +1753,4 @@ static struct platform_driver m66592_driver = {
 	},
 };
 
-static int __init m66592_udc_init(void)
-{
-	return platform_driver_probe(&m66592_driver, m66592_probe);
-}
-module_init(m66592_udc_init);
-
-static void __exit m66592_udc_cleanup(void)
-{
-	platform_driver_unregister(&m66592_driver);
-}
-module_exit(m66592_udc_cleanup);
+module_platform_driver_probe(m66592_driver, m66592_probe);
diff --git a/drivers/usb/gadget/pxa25x_udc.c b/drivers/usb/gadget/pxa25x_udc.c
index d4ca9f1..d52e869 100644
--- a/drivers/usb/gadget/pxa25x_udc.c
+++ b/drivers/usb/gadget/pxa25x_udc.c
@@ -2100,6 +2100,8 @@ static int __init pxa25x_udc_probe(struct platform_device *pdev)
 	int retval, irq;
 	u32 chiprev;
 
+	pr_info("%s: version %s\n", driver_name, DRIVER_VERSION);
+
 	/* insist on Intel/ARM/XScale */
 	asm("mrc%? p15, 0, %0, c0, c0" : "=r" (chiprev));
 	if ((chiprev & CP15R0_VENDOR_MASK) != CP15R0_XSCALE_VALUE) {
@@ -2346,18 +2348,7 @@ static struct platform_driver udc_driver = {
 	},
 };
 
-static int __init udc_init(void)
-{
-	pr_info("%s: version %s\n", driver_name, DRIVER_VERSION);
-	return platform_driver_probe(&udc_driver, pxa25x_udc_probe);
-}
-module_init(udc_init);
-
-static void __exit udc_exit(void)
-{
-	platform_driver_unregister(&udc_driver);
-}
-module_exit(udc_exit);
+module_platform_driver_probe(udc_driver, pxa25x_udc_probe);
 
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_AUTHOR("Frank Becker, Robert Schwebel, David Brownell");
diff --git a/drivers/usb/gadget/r8a66597-udc.c b/drivers/usb/gadget/r8a66597-udc.c
index 5a80751..9a9fadd 100644
--- a/drivers/usb/gadget/r8a66597-udc.c
+++ b/drivers/usb/gadget/r8a66597-udc.c
@@ -2031,21 +2031,10 @@ static struct platform_driver r8a66597_driver = {
 		.name =	(char *) udc_name,
 	},
 };
-MODULE_ALIAS("platform:r8a66597_udc");
-
-static int __init r8a66597_udc_init(void)
-{
-	return platform_driver_probe(&r8a66597_driver, r8a66597_probe);
-}
-module_init(r8a66597_udc_init);
 
-static void __exit r8a66597_udc_cleanup(void)
-{
-	platform_driver_unregister(&r8a66597_driver);
-}
-module_exit(r8a66597_udc_cleanup);
+module_platform_driver_probe(r8a66597_driver, r8a66597_probe);
 
 MODULE_DESCRIPTION("R8A66597 USB gadget driver");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Yoshihiro Shimoda");
-
+MODULE_ALIAS("platform:r8a66597_udc");
diff --git a/drivers/usb/otg/gpio_vbus.c b/drivers/usb/otg/gpio_vbus.c
index a67ffe2..a7d4ac5 100644
--- a/drivers/usb/otg/gpio_vbus.c
+++ b/drivers/usb/otg/gpio_vbus.c
@@ -409,17 +409,7 @@ static struct platform_driver gpio_vbus_driver = {
 	.remove  = __exit_p(gpio_vbus_remove),
 };
 
-static int __init gpio_vbus_init(void)
-{
-	return platform_driver_probe(&gpio_vbus_driver, gpio_vbus_probe);
-}
-module_init(gpio_vbus_init);
-
-static void __exit gpio_vbus_exit(void)
-{
-	platform_driver_unregister(&gpio_vbus_driver);
-}
-module_exit(gpio_vbus_exit);
+module_platform_driver_probe(gpio_vbus_driver, gpio_vbus_probe);
 
 MODULE_DESCRIPTION("simple GPIO controlled OTG transceiver driver");
 MODULE_AUTHOR("Philipp Zabel");
diff --git a/drivers/usb/otg/msm_otg.c b/drivers/usb/otg/msm_otg.c
index 3b9f0d9..749fbf4 100644
--- a/drivers/usb/otg/msm_otg.c
+++ b/drivers/usb/otg/msm_otg.c
@@ -1756,18 +1756,7 @@ static struct platform_driver msm_otg_driver = {
 	},
 };
 
-static int __init msm_otg_init(void)
-{
-	return platform_driver_probe(&msm_otg_driver, msm_otg_probe);
-}
-
-static void __exit msm_otg_exit(void)
-{
-	platform_driver_unregister(&msm_otg_driver);
-}
-
-module_init(msm_otg_init);
-module_exit(msm_otg_exit);
+module_platform_driver_probe(msm_otg_driver, msm_otg_probe);
 
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("MSM USB transceiver driver");
-- 
1.8.0.3

