Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357Ab1K2F4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 00:56:39 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37341 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab1K2F4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 00:56:37 -0500
Message-ID: <1322546187.9040.3.camel@phoenix>
Subject: [PATCH 2/2] watchdog: convert drivers/watchdog/* to use
 module_platform_driver()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Wim Van Sebroeck <wim@iguana.be>, Nicolas Thill <nico@openwrt.org>,
        Florian Fainelli <florian@openwrt.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Cercueil <paul@crapouillou.net>,
        Marc Zyngier <maz@misterjones.org>, Wan ZongShun <mcuos.com@gmail.com>,
        Alejandro Cabrera <aldaya@gmail.com>,
        "George G. Davis" <gdavis@mvista.com>,
        Sylver Bruneau <sylver.bruneau@googlemail.com>,
        Vitaly Wool <vital@embeddedalley.com>,
        Mika Westerberg <mika.westerberg@iki.fi>,
        Timo Kokkonen <timo.t.kokkonen@nokia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-watchdog@vger.kernel.org
Date: Tue, 29 Nov 2011 13:56:27 +0800
In-Reply-To: <1322546041.9040.1.camel@phoenix>
References: <1322546041.9040.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers in drivers/watchdog/* to use the
module_platform_driver() macro which makes the code smaller and a bit
simpler.

Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Nicolas Thill <nico@openwrt.org>
Cc: Florian Fainelli <florian@openwrt.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Paul Cercueil <paul@crapouillou.net>
Cc: Marc Zyngier <maz@misterjones.org>
Cc: Wan ZongShun <mcuos.com@gmail.com>
Cc: Alejandro Cabrera <aldaya@gmail.com>
Cc: "George G. Davis" <gdavis@mvista.com>
Cc: Sylver Bruneau <sylver.bruneau@googlemail.com>
Cc: Vitaly Wool <vital@embeddedalley.com>
Cc: Mika Westerberg <mika.westerberg@iki.fi>
Cc: Timo Kokkonen <timo.t.kokkonen@nokia.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/watchdog/ar7_wdt.c       |   13 +------------
 drivers/watchdog/bcm63xx_wdt.c   |   13 +------------
 drivers/watchdog/cpwd.c          |   13 +------------
 drivers/watchdog/davinci_wdt.c   |   13 +------------
 drivers/watchdog/dw_wdt.c        |   12 +-----------
 drivers/watchdog/jz4740_wdt.c    |   13 +------------
 drivers/watchdog/max63xx_wdt.c   |   13 +------------
 drivers/watchdog/mtx-1_wdt.c     |   13 +------------
 drivers/watchdog/nuc900_wdt.c    |   13 +------------
 drivers/watchdog/of_xilinx_wdt.c |   13 +------------
 drivers/watchdog/omap_wdt.c      |   13 +------------
 drivers/watchdog/orion_wdt.c     |   13 +------------
 drivers/watchdog/pnx4008_wdt.c   |   13 +------------
 drivers/watchdog/rc32434_wdt.c   |   13 +------------
 drivers/watchdog/rdc321x_wdt.c   |   13 +------------
 drivers/watchdog/riowd.c         |   13 +------------
 drivers/watchdog/stmp3xxx_wdt.c  |   13 +------------
 drivers/watchdog/ts72xx_wdt.c    |   12 +-----------
 drivers/watchdog/twl4030_wdt.c   |   12 +-----------
 drivers/watchdog/wm831x_wdt.c    |   12 +-----------
 drivers/watchdog/wm8350_wdt.c    |   12 +-----------
 21 files changed, 21 insertions(+), 247 deletions(-)

diff --git a/drivers/watchdog/ar7_wdt.c b/drivers/watchdog/ar7_wdt.c
index b9564c5..502773a 100644
--- a/drivers/watchdog/ar7_wdt.c
+++ b/drivers/watchdog/ar7_wdt.c
@@ -353,15 +353,4 @@ static struct platform_driver ar7_wdt_driver = {
 	},
 };
 
-static int __init ar7_wdt_init(void)
-{
-	return platform_driver_register(&ar7_wdt_driver);
-}
-
-static void __exit ar7_wdt_cleanup(void)
-{
-	platform_driver_unregister(&ar7_wdt_driver);
-}
-
-module_init(ar7_wdt_init);
-module_exit(ar7_wdt_cleanup);
+module_platform_driver(ar7_wdt_driver);
diff --git a/drivers/watchdog/bcm63xx_wdt.c b/drivers/watchdog/bcm63xx_wdt.c
index 5064e83..8dc7de6 100644
--- a/drivers/watchdog/bcm63xx_wdt.c
+++ b/drivers/watchdog/bcm63xx_wdt.c
@@ -311,18 +311,7 @@ static struct platform_driver bcm63xx_wdt = {
 	}
 };
 
-static int __init bcm63xx_wdt_init(void)
-{
-	return platform_driver_register(&bcm63xx_wdt);
-}
-
-static void __exit bcm63xx_wdt_exit(void)
-{
-	platform_driver_unregister(&bcm63xx_wdt);
-}
-
-module_init(bcm63xx_wdt_init);
-module_exit(bcm63xx_wdt_exit);
+module_platform_driver(bcm63xx_wdt);
 
 MODULE_AUTHOR("Miguel Gaio <miguel.gaio@efixo.com>");
 MODULE_AUTHOR("Florian Fainelli <florian@openwrt.org>");
diff --git a/drivers/watchdog/cpwd.c b/drivers/watchdog/cpwd.c
index 1e013e8..1b793dfd 100644
--- a/drivers/watchdog/cpwd.c
+++ b/drivers/watchdog/cpwd.c
@@ -687,15 +687,4 @@ static struct platform_driver cpwd_driver = {
 	.remove		= __devexit_p(cpwd_remove),
 };
 
-static int __init cpwd_init(void)
-{
-	return platform_driver_register(&cpwd_driver);
-}
-
-static void __exit cpwd_exit(void)
-{
-	platform_driver_unregister(&cpwd_driver);
-}
-
-module_init(cpwd_init);
-module_exit(cpwd_exit);
+module_platform_driver(cpwd_driver);
diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
index 51b5551..c8c5c80 100644
--- a/drivers/watchdog/davinci_wdt.c
+++ b/drivers/watchdog/davinci_wdt.c
@@ -271,18 +271,7 @@ static struct platform_driver platform_wdt_driver = {
 	.remove = __devexit_p(davinci_wdt_remove),
 };
 
-static int __init davinci_wdt_init(void)
-{
-	return platform_driver_register(&platform_wdt_driver);
-}
-
-static void __exit davinci_wdt_exit(void)
-{
-	platform_driver_unregister(&platform_wdt_driver);
-}
-
-module_init(davinci_wdt_init);
-module_exit(davinci_wdt_exit);
+module_platform_driver(platform_wdt_driver);
 
 MODULE_AUTHOR("Texas Instruments");
 MODULE_DESCRIPTION("DaVinci Watchdog Driver");
diff --git a/drivers/watchdog/dw_wdt.c b/drivers/watchdog/dw_wdt.c
index f10f8c0..1b0e3dd 100644
--- a/drivers/watchdog/dw_wdt.c
+++ b/drivers/watchdog/dw_wdt.c
@@ -358,17 +358,7 @@ static struct platform_driver dw_wdt_driver = {
 	},
 };
 
-static int __init dw_wdt_watchdog_init(void)
-{
-	return platform_driver_register(&dw_wdt_driver);
-}
-module_init(dw_wdt_watchdog_init);
-
-static void __exit dw_wdt_watchdog_exit(void)
-{
-	platform_driver_unregister(&dw_wdt_driver);
-}
-module_exit(dw_wdt_watchdog_exit);
+module_platform_driver(dw_wdt_driver);
 
 MODULE_AUTHOR("Jamie Iles");
 MODULE_DESCRIPTION("Synopsys DesignWare Watchdog Driver");
diff --git a/drivers/watchdog/jz4740_wdt.c b/drivers/watchdog/jz4740_wdt.c
index 684ba01..17ef300 100644
--- a/drivers/watchdog/jz4740_wdt.c
+++ b/drivers/watchdog/jz4740_wdt.c
@@ -295,18 +295,7 @@ static struct platform_driver jz4740_wdt_driver = {
 	},
 };
 
-
-static int __init jz4740_wdt_init(void)
-{
-	return platform_driver_register(&jz4740_wdt_driver);
-}
-module_init(jz4740_wdt_init);
-
-static void __exit jz4740_wdt_exit(void)
-{
-	platform_driver_unregister(&jz4740_wdt_driver);
-}
-module_exit(jz4740_wdt_exit);
+module_platform_driver(jz4740_wdt_driver);
 
 MODULE_AUTHOR("Paul Cercueil <paul@crapouillou.net>");
 MODULE_DESCRIPTION("jz4740 Watchdog Driver");
diff --git a/drivers/watchdog/max63xx_wdt.c b/drivers/watchdog/max63xx_wdt.c
index 73ba2fd..af63ecf 100644
--- a/drivers/watchdog/max63xx_wdt.c
+++ b/drivers/watchdog/max63xx_wdt.c
@@ -364,18 +364,7 @@ static struct platform_driver max63xx_wdt_driver = {
 	},
 };
 
-static int __init max63xx_wdt_init(void)
-{
-	return platform_driver_register(&max63xx_wdt_driver);
-}
-
-static void __exit max63xx_wdt_exit(void)
-{
-	platform_driver_unregister(&max63xx_wdt_driver);
-}
-
-module_init(max63xx_wdt_init);
-module_exit(max63xx_wdt_exit);
+module_platform_driver(max63xx_wdt_driver);
 
 MODULE_AUTHOR("Marc Zyngier <maz@misterjones.org>");
 MODULE_DESCRIPTION("max63xx Watchdog Driver");
diff --git a/drivers/watchdog/mtx-1_wdt.c b/drivers/watchdog/mtx-1_wdt.c
index ac37bb8..c29e31d 100644
--- a/drivers/watchdog/mtx-1_wdt.c
+++ b/drivers/watchdog/mtx-1_wdt.c
@@ -253,18 +253,7 @@ static struct platform_driver mtx1_wdt_driver = {
 	.driver.owner = THIS_MODULE,
 };
 
-static int __init mtx1_wdt_init(void)
-{
-	return platform_driver_register(&mtx1_wdt_driver);
-}
-
-static void __exit mtx1_wdt_exit(void)
-{
-	platform_driver_unregister(&mtx1_wdt_driver);
-}
-
-module_init(mtx1_wdt_init);
-module_exit(mtx1_wdt_exit);
+module_platform_driver(mtx1_wdt_driver);
 
 MODULE_AUTHOR("Michael Stickel, Florian Fainelli");
 MODULE_DESCRIPTION("Driver for the MTX-1 watchdog");
diff --git a/drivers/watchdog/nuc900_wdt.c b/drivers/watchdog/nuc900_wdt.c
index 6cee33d..50359ba 100644
--- a/drivers/watchdog/nuc900_wdt.c
+++ b/drivers/watchdog/nuc900_wdt.c
@@ -334,18 +334,7 @@ static struct platform_driver nuc900wdt_driver = {
 	},
 };
 
-static int __init nuc900_wdt_init(void)
-{
-	return platform_driver_register(&nuc900wdt_driver);
-}
-
-static void __exit nuc900_wdt_exit(void)
-{
-	platform_driver_unregister(&nuc900wdt_driver);
-}
-
-module_init(nuc900_wdt_init);
-module_exit(nuc900_wdt_exit);
+module_platform_driver(nuc900wdt_driver);
 
 MODULE_AUTHOR("Wan ZongShun <mcuos.com@gmail.com>");
 MODULE_DESCRIPTION("Watchdog driver for NUC900");
diff --git a/drivers/watchdog/of_xilinx_wdt.c b/drivers/watchdog/of_xilinx_wdt.c
index 4ec741a..f359ab8 100644
--- a/drivers/watchdog/of_xilinx_wdt.c
+++ b/drivers/watchdog/of_xilinx_wdt.c
@@ -414,18 +414,7 @@ static struct platform_driver xwdt_driver = {
 	},
 };
 
-static int __init xwdt_init(void)
-{
-	return platform_driver_register(&xwdt_driver);
-}
-
-static void __exit xwdt_exit(void)
-{
-	platform_driver_unregister(&xwdt_driver);
-}
-
-module_init(xwdt_init);
-module_exit(xwdt_exit);
+module_platform_driver(xwdt_driver);
 
 MODULE_AUTHOR("Alejandro Cabrera <aldaya@gmail.com>");
 MODULE_DESCRIPTION("Xilinx Watchdog driver");
diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index cd269b4..324f525 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -437,18 +437,7 @@ static struct platform_driver omap_wdt_driver = {
 	},
 };
 
-static int __init omap_wdt_init(void)
-{
-	return platform_driver_register(&omap_wdt_driver);
-}
-
-static void __exit omap_wdt_exit(void)
-{
-	platform_driver_unregister(&omap_wdt_driver);
-}
-
-module_init(omap_wdt_init);
-module_exit(omap_wdt_exit);
+module_platform_driver(omap_wdt_driver);
 
 MODULE_AUTHOR("George G. Davis");
 MODULE_LICENSE("GPL");
diff --git a/drivers/watchdog/orion_wdt.c b/drivers/watchdog/orion_wdt.c
index 66bd97f..4ad78f8 100644
--- a/drivers/watchdog/orion_wdt.c
+++ b/drivers/watchdog/orion_wdt.c
@@ -294,18 +294,7 @@ static struct platform_driver orion_wdt_driver = {
 	},
 };
 
-static int __init orion_wdt_init(void)
-{
-	return platform_driver_register(&orion_wdt_driver);
-}
-
-static void __exit orion_wdt_exit(void)
-{
-	platform_driver_unregister(&orion_wdt_driver);
-}
-
-module_init(orion_wdt_init);
-module_exit(orion_wdt_exit);
+module_platform_driver(orion_wdt_driver);
 
 MODULE_AUTHOR("Sylver Bruneau <sylver.bruneau@googlemail.com>");
 MODULE_DESCRIPTION("Orion Processor Watchdog");
diff --git a/drivers/watchdog/pnx4008_wdt.c b/drivers/watchdog/pnx4008_wdt.c
index 6149332..bd143c9 100644
--- a/drivers/watchdog/pnx4008_wdt.c
+++ b/drivers/watchdog/pnx4008_wdt.c
@@ -334,18 +334,7 @@ static struct platform_driver platform_wdt_driver = {
 	.remove = __devexit_p(pnx4008_wdt_remove),
 };
 
-static int __init pnx4008_wdt_init(void)
-{
-	return platform_driver_register(&platform_wdt_driver);
-}
-
-static void __exit pnx4008_wdt_exit(void)
-{
-	platform_driver_unregister(&platform_wdt_driver);
-}
-
-module_init(pnx4008_wdt_init);
-module_exit(pnx4008_wdt_exit);
+module_platform_driver(platform_wdt_driver);
 
 MODULE_AUTHOR("MontaVista Software, Inc. <source@mvista.com>");
 MODULE_DESCRIPTION("PNX4008 Watchdog Driver");
diff --git a/drivers/watchdog/rc32434_wdt.c b/drivers/watchdog/rc32434_wdt.c
index d4c29b5..bf7bc8a 100644
--- a/drivers/watchdog/rc32434_wdt.c
+++ b/drivers/watchdog/rc32434_wdt.c
@@ -332,18 +332,7 @@ static struct platform_driver rc32434_wdt_driver = {
 	}
 };
 
-static int __init rc32434_wdt_init(void)
-{
-	return platform_driver_register(&rc32434_wdt_driver);
-}
-
-static void __exit rc32434_wdt_exit(void)
-{
-	platform_driver_unregister(&rc32434_wdt_driver);
-}
-
-module_init(rc32434_wdt_init);
-module_exit(rc32434_wdt_exit);
+module_platform_driver(rc32434_wdt_driver);
 
 MODULE_AUTHOR("Ondrej Zajicek <santiago@crfreenet.org>,"
 		"Florian Fainelli <florian@openwrt.org>");
diff --git a/drivers/watchdog/rdc321x_wdt.c b/drivers/watchdog/rdc321x_wdt.c
index 428f8a1..042ccc5 100644
--- a/drivers/watchdog/rdc321x_wdt.c
+++ b/drivers/watchdog/rdc321x_wdt.c
@@ -293,18 +293,7 @@ static struct platform_driver rdc321x_wdt_driver = {
 	},
 };
 
-static int __init rdc321x_wdt_init(void)
-{
-	return platform_driver_register(&rdc321x_wdt_driver);
-}
-
-static void __exit rdc321x_wdt_exit(void)
-{
-	platform_driver_unregister(&rdc321x_wdt_driver);
-}
-
-module_init(rdc321x_wdt_init);
-module_exit(rdc321x_wdt_exit);
+module_platform_driver(rdc321x_wdt_driver);
 
 MODULE_AUTHOR("Florian Fainelli <florian@openwrt.org>");
 MODULE_DESCRIPTION("RDC321x watchdog driver");
diff --git a/drivers/watchdog/riowd.c b/drivers/watchdog/riowd.c
index 109b533..c7e17ce 100644
--- a/drivers/watchdog/riowd.c
+++ b/drivers/watchdog/riowd.c
@@ -247,15 +247,4 @@ static struct platform_driver riowd_driver = {
 	.remove		= __devexit_p(riowd_remove),
 };
 
-static int __init riowd_init(void)
-{
-	return platform_driver_register(&riowd_driver);
-}
-
-static void __exit riowd_exit(void)
-{
-	platform_driver_unregister(&riowd_driver);
-}
-
-module_init(riowd_init);
-module_exit(riowd_exit);
+module_platform_driver(riowd_driver);
diff --git a/drivers/watchdog/stmp3xxx_wdt.c b/drivers/watchdog/stmp3xxx_wdt.c
index ac2346a..4c2a4e8 100644
--- a/drivers/watchdog/stmp3xxx_wdt.c
+++ b/drivers/watchdog/stmp3xxx_wdt.c
@@ -272,18 +272,7 @@ static struct platform_driver platform_wdt_driver = {
 	.resume = stmp3xxx_wdt_resume,
 };
 
-static int __init stmp3xxx_wdt_init(void)
-{
-	return platform_driver_register(&platform_wdt_driver);
-}
-
-static void __exit stmp3xxx_wdt_exit(void)
-{
-	return platform_driver_unregister(&platform_wdt_driver);
-}
-
-module_init(stmp3xxx_wdt_init);
-module_exit(stmp3xxx_wdt_exit);
+module_platform_driver(platform_wdt_driver);
 
 MODULE_DESCRIPTION("STMP3XXX Watchdog Driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/watchdog/ts72xx_wdt.c b/drivers/watchdog/ts72xx_wdt.c
index 5a90a4a..1490293 100644
--- a/drivers/watchdog/ts72xx_wdt.c
+++ b/drivers/watchdog/ts72xx_wdt.c
@@ -506,17 +506,7 @@ static struct platform_driver ts72xx_wdt_driver = {
 	},
 };
 
-static __init int ts72xx_wdt_init(void)
-{
-	return platform_driver_register(&ts72xx_wdt_driver);
-}
-module_init(ts72xx_wdt_init);
-
-static __exit void ts72xx_wdt_exit(void)
-{
-	platform_driver_unregister(&ts72xx_wdt_driver);
-}
-module_exit(ts72xx_wdt_exit);
+module_platform_driver(ts72xx_wdt_driver);
 
 MODULE_AUTHOR("Mika Westerberg <mika.westerberg@iki.fi>");
 MODULE_DESCRIPTION("TS-72xx SBC Watchdog");
diff --git a/drivers/watchdog/twl4030_wdt.c b/drivers/watchdog/twl4030_wdt.c
index b5045ca..0764c62 100644
--- a/drivers/watchdog/twl4030_wdt.c
+++ b/drivers/watchdog/twl4030_wdt.c
@@ -256,17 +256,7 @@ static struct platform_driver twl4030_wdt_driver = {
 	},
 };
 
-static int __devinit twl4030_wdt_init(void)
-{
-	return platform_driver_register(&twl4030_wdt_driver);
-}
-module_init(twl4030_wdt_init);
-
-static void __devexit twl4030_wdt_exit(void)
-{
-	platform_driver_unregister(&twl4030_wdt_driver);
-}
-module_exit(twl4030_wdt_exit);
+module_platform_driver(twl4030_wdt_driver);
 
 MODULE_AUTHOR("Nokia Corporation");
 MODULE_LICENSE("GPL");
diff --git a/drivers/watchdog/wm831x_wdt.c b/drivers/watchdog/wm831x_wdt.c
index e789a47..beb3ad2 100644
--- a/drivers/watchdog/wm831x_wdt.c
+++ b/drivers/watchdog/wm831x_wdt.c
@@ -320,17 +320,7 @@ static struct platform_driver wm831x_wdt_driver = {
 	},
 };
 
-static int __init wm831x_wdt_init(void)
-{
-	return platform_driver_register(&wm831x_wdt_driver);
-}
-module_init(wm831x_wdt_init);
-
-static void __exit wm831x_wdt_exit(void)
-{
-	platform_driver_unregister(&wm831x_wdt_driver);
-}
-module_exit(wm831x_wdt_exit);
+module_platform_driver(wm831x_wdt_driver);
 
 MODULE_AUTHOR("Mark Brown");
 MODULE_DESCRIPTION("WM831x Watchdog");
diff --git a/drivers/watchdog/wm8350_wdt.c b/drivers/watchdog/wm8350_wdt.c
index b68d928..909c786 100644
--- a/drivers/watchdog/wm8350_wdt.c
+++ b/drivers/watchdog/wm8350_wdt.c
@@ -311,17 +311,7 @@ static struct platform_driver wm8350_wdt_driver = {
 	},
 };
 
-static int __init wm8350_wdt_init(void)
-{
-	return platform_driver_register(&wm8350_wdt_driver);
-}
-module_init(wm8350_wdt_init);
-
-static void __exit wm8350_wdt_exit(void)
-{
-	platform_driver_unregister(&wm8350_wdt_driver);
-}
-module_exit(wm8350_wdt_exit);
+module_platform_driver(wm8350_wdt_driver);
 
 MODULE_AUTHOR("Mark Brown");
 MODULE_DESCRIPTION("WM8350 Watchdog");
-- 
1.7.5.4



