Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab2AJL3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 06:29:41 -0500
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:60101 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752371Ab2AJL3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 06:29:37 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAKofDE9tgx+R/2dsb2JhbAA6CaxYgQaCEwEMExwTAQ8YF0YNGAMhE4d8BrZcE4hEglljBJULinaHRg
Date: Tue, 10 Jan 2012 12:29:32 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Shubhrajyoti D <shubhrajyoti@ti.com>,
        Marc Vertes <marc.vertes@sigfox.com>, Gabor Juhos <juhosg@openwrt.org>,
        Julia Lawall <julia@diku.dk>, Wolfram Sang <w.sang@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Axel Lin <axel.lin@gmail.com>
Subject: [GIT PULL REQUEST] watchdog - v3.2
Message-ID: <20120110112932.GA7871@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://www.linux-watchdog.org/linux-watchdog.git

This will update the following files:

 Documentation/watchdog/00-INDEX                          |    2 
 Documentation/watchdog/convert_drivers_to_kernel_api.txt |   19 +
 Documentation/watchdog/watchdog-kernel-api.txt           |   10 
 drivers/watchdog/Kconfig                                 |   13 
 drivers/watchdog/Makefile                                |    1 
 drivers/watchdog/ar7_wdt.c                               |   17 
 drivers/watchdog/ath79_wdt.c                             |    6 
 drivers/watchdog/bcm63xx_wdt.c                           |   13 
 drivers/watchdog/cpu5wdt.c                               |    3 
 drivers/watchdog/cpwd.c                                  |   13 
 drivers/watchdog/davinci_wdt.c                           |   13 
 drivers/watchdog/dw_wdt.c                                |   12 
 drivers/watchdog/eurotechwdt.c                           |    4 
 drivers/watchdog/ibmasr.c                                |    4 
 drivers/watchdog/indydog.c                               |    4 
 drivers/watchdog/iop_wdt.c                               |    5 
 drivers/watchdog/ixp2000_wdt.c                           |    3 
 drivers/watchdog/ixp4xx_wdt.c                            |    1 
 drivers/watchdog/jz4740_wdt.c                            |   13 
 drivers/watchdog/ks8695_wdt.c                            |    3 
 drivers/watchdog/lantiq_wdt.c                            |    3 
 drivers/watchdog/max63xx_wdt.c                           |   13 
 drivers/watchdog/mtx-1_wdt.c                             |   13 
 drivers/watchdog/nuc900_wdt.c                            |   13 
 drivers/watchdog/of_xilinx_wdt.c                         |   13 
 drivers/watchdog/omap_wdt.c                              |   17 
 drivers/watchdog/orion_wdt.c                             |   16 
 drivers/watchdog/pnx4008_wdt.c                           |   13 
 drivers/watchdog/rc32434_wdt.c                           |   13 
 drivers/watchdog/rdc321x_wdt.c                           |   13 
 drivers/watchdog/riowd.c                                 |   13 
 drivers/watchdog/s3c2410_wdt.c                           |    2 
 drivers/watchdog/stmp3xxx_wdt.c                          |   13 
 drivers/watchdog/ts72xx_wdt.c                            |   12 
 drivers/watchdog/twl4030_wdt.c                           |   12 
 drivers/watchdog/via_wdt.c                               |  267 +++++++++++++++
 drivers/watchdog/wm831x_wdt.c                            |   23 -
 drivers/watchdog/wm8350_wdt.c                            |   12 
 include/linux/watchdog.h                                 |   21 -
 39 files changed, 371 insertions(+), 290 deletions(-)

with these Changes:

commit e2bf7c4c22939bd83814d8da40a352d246030b1b
Author: Shubhrajyoti D <shubhrajyoti@ti.com>
Date:   Wed Jan 4 19:45:28 2012 +0530

    watchdog: omap_wdt.c: fix the WDIOC_GETBOOTSTATUS ioctl if not implemented.
    
    WDIOC_GETBOOTSTATUS ioctl is imlemented for cpu_is_omap16xx and cpu_is_omap24xx
    cpus only. For other cpus it falls through to WDIOC_KEEPALIVE.
    This patch prevents the fall through.
    
    Cc: sricharan <r.sricharan@ti.com>
    Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit dc3c56b703dad4aec8a9b3dd86f03a90d0c26a2d
Author: Marc Vertes <marc.vertes@sigfox.com>
Date:   Mon Dec 5 17:00:23 2011 +0100

    watchdog: new driver for VIA chipsets
    
    New driver for the hardware watchdog timer on VIA chipsets.
    This driver uses the new watchdog framework.
    PnP must be enabled in BIOS to get full control of watchdog registers.
    The timer code has been added by Wim Van Sebroeck.
    Tested on a Artigo A1100, VX855 chipset.
    
    Signed-off-by: Marc Vertes <marc.vertes@sigfox.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 86955e2bcb320bf8f271443cb7b03896fc3cbd67
Author: Gabor Juhos <juhosg@openwrt.org>
Date:   Fri Dec 23 19:25:42 2011 +0100

    watchdog: ath79_wdt: flush register writes
    
    The watchdog register writes required to have a flush
    in order to commit the values to the register. Without
    the flush, the driver not function correctly on AR934X
    SoCs.
    
    Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
    Acked-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 60daac4a9084d5a6216443f428d0060c42eb44ff
Author: Julia Lawall <julia@diku.dk>
Date:   Mon Dec 26 18:38:00 2011 +0100

    drivers/watchdog/lantiq_wdt.c: drop iounmap for devm_ allocated data
    
    Data allocated with devm_ioremap or devm_ioremap_nocache should not be
    freed using iounmap, because doing so causes a dangling pointer, and a
    subsequent double free.
    
    The semantic match that finds this problem is as follows:
    (http://coccinelle.lip6.fr/)
    
    // <smpl>
    @r@
    expression x;
    @@
    (
     x = devm_ioremap(...)
    |
     x = devm_ioremap_nocache(...)
    )
    
    @@
    expression r.x;
    @@
    * iounmap(x)
    // </smpl>
    
    Signed-off-by: Julia Lawall <julia@diku.dk>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 02861cca4b4f1ceaa7dc805041d84caee580670b
Author: Wolfram Sang <w.sang@pengutronix.de>
Date:   Fri Dec 2 00:43:11 2011 +0100

    watchdog: documentation: describe nowayout in coversion-guide
    
    nowayout is also handled by the watchdog core. Describe how this needs
    to be addressed in the conversion guide.
    
    Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 9d36bc8cd8d607ec5db98bcc85b27cff9e1b6dfd
Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Tue Nov 29 12:14:30 2011 +0100

    watchdog: documentation: update index file
    
    Add the convert_drivers_to_kernel_api.txt to the 00-INDEX file.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 7b9bb6d8cfe80580329318caf6c3a137762ecea3
Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
Date:   Thu Dec 15 02:23:19 2011 +0800

    watchdog: Convert wm831x driver to devm_kzalloc()
    
    Saves a small amount of code and systematically eliminates leaks.
    
    Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit ff0b3cd4a416bc727b0797b95b229b278d2a28f2
Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Tue Nov 29 16:24:16 2011 +0100

    watchdog: add nowayout helpers to Watchdog Timer Driver Kernel API
    
    Add two nowayout helpers for the Watchdog Timer Driver Kernel API.
    And apply this to the already converted drivers.
    Note: s3c2410_wdt lost the nowayout feature during the conversion.
    
    Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>
    Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit b8ec61189f3b4cd9d1b2856342f5d7676151d01c
Author: Axel Lin <axel.lin@gmail.com>
Date:   Tue Nov 29 13:56:27 2011 +0800

    watchdog: convert drivers/watchdog/* to use module_platform_driver()
    
    This patch converts the drivers in drivers/watchdog/* to use the
    module_platform_driver() macro which makes the code smaller and a bit
    simpler.
    
    Signed-off-by: Axel Lin <axel.lin@gmail.com>
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
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 1334f32938e46fb321c67a652997d33583257249
Author: Axel Lin <axel.lin@gmail.com>
Date:   Tue Nov 29 13:54:01 2011 +0800

    watchdog: Use DEFINE_SPINLOCK() for static spinlocks
    
    Rather than just defining static spinlock_t variables and then
    initializing them later in init functions, simply define them with
    DEFINE_SPINLOCK() and remove the calls to spin_lock_init().
    
    Signed-off-by: Axel Lin <axel.lin@gmail.com>
    Cc: Nicolas Thill <nico@openwrt.org>
    Cc: Heiko Ronsdorf <hero@ihg.uni-duisburg.de>
    Cc: Rodolfo Giometti <giometti@ascensit.com>
    Cc: Andrey Panin <pazke@donpac.ru>
    Cc: Guido Guenther <agx@sigxcpu.org>
    Cc: Curt E Bruns <curt.e.bruns@intel.com>
    Cc: Deepak Saxena <dsaxena@plexity.net>
    Cc: Andrew Victor <linux@maxim.org.za>
    Cc: George G. Davis <gdavis@mvista.com>
    Cc: Sylver Bruneau <sylver.bruneau@googlemail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 216f3ad9aa5731024b9c96e63b676f9f65078dd5
Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
Date:   Wed Nov 23 15:22:36 2011 +0000

    watchdog: Convert Wolfson drivers to module_platform_driver
    
    Factors out some boilerplate code.
    
    Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/Documentation/watchdog/00-INDEX b/Documentation/watchdog/00-INDEX
index fc51128..fc9082a 100644
--- a/Documentation/watchdog/00-INDEX
+++ b/Documentation/watchdog/00-INDEX
@@ -1,5 +1,7 @@
 00-INDEX
 	- this file.
+convert_drivers_to_kernel_api.txt
+	- how-to for converting old watchdog drivers to the new kernel API.
 hpwdt.txt
 	- information on the HP iLO2 NMI watchdog
 pcwd-watchdog.txt
diff --git a/Documentation/watchdog/convert_drivers_to_kernel_api.txt b/Documentation/watchdog/convert_drivers_to_kernel_api.txt
index ae1e900..be8119b 100644
--- a/Documentation/watchdog/convert_drivers_to_kernel_api.txt
+++ b/Documentation/watchdog/convert_drivers_to_kernel_api.txt
@@ -163,6 +163,25 @@ Here is a simple example for a watchdog device:
 +};
 
 
+Handle the 'nowayout' feature
+-----------------------------
+
+A few drivers use nowayout statically, i.e. there is no module parameter for it
+and only CONFIG_WATCHDOG_NOWAYOUT determines if the feature is going to be
+used. This needs to be converted by initializing the status variable of the
+watchdog_device like this:
+
+        .status = WATCHDOG_NOWAYOUT_INIT_STATUS,
+
+Most drivers, however, also allow runtime configuration of nowayout, usually
+by adding a module parameter. The conversion for this would be something like:
+
+	watchdog_set_nowayout(&s3c2410_wdd, nowayout);
+
+The module parameter itself needs to stay, everything else related to nowayout
+can go, though. This will likely be some code in open(), close() or write().
+
+
 Register the watchdog device
 ----------------------------
 
diff --git a/Documentation/watchdog/watchdog-kernel-api.txt b/Documentation/watchdog/watchdog-kernel-api.txt
index 4f7c894..4b93c28 100644
--- a/Documentation/watchdog/watchdog-kernel-api.txt
+++ b/Documentation/watchdog/watchdog-kernel-api.txt
@@ -1,6 +1,6 @@
 The Linux WatchDog Timer Driver Core kernel API.
 ===============================================
-Last reviewed: 22-Jul-2011
+Last reviewed: 29-Nov-2011
 
 Wim Van Sebroeck <wim@iguana.be>
 
@@ -142,6 +142,14 @@ bit-operations. The status bits that are defined are:
 * WDOG_NO_WAY_OUT: this bit stores the nowayout setting for the watchdog.
   If this bit is set then the watchdog timer will not be able to stop.
 
+  To set the WDOG_NO_WAY_OUT status bit (before registering your watchdog
+  timer device) you can either:
+  * set it statically in your watchdog_device struct with
+	.status = WATCHDOG_NOWAYOUT_INIT_STATUS,
+    (this will set the value the same as CONFIG_WATCHDOG_NOWAYOUT) or
+  * use the following helper function:
+  static inline void watchdog_set_nowayout(struct watchdog_device *wdd, int nowayout)
+
 Note: The WatchDog Timer Driver Core supports the magic close feature and
 the nowayout feature. To use the magic close feature you must set the
 WDIOF_MAGICCLOSE bit in the options field of the watchdog's info structure.
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 79fd606..877b107 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -772,6 +772,19 @@ config SMSC37B787_WDT
 
 	  Most people will say N.
 
+config VIA_WDT
+	tristate "VIA Watchdog Timer"
+	depends on X86
+	select WATCHDOG_CORE
+	---help---
+	This is the driver for the hardware watchdog timer on VIA
+	southbridge chipset CX700, VX800/VX820 or VX855/VX875.
+
+	To compile this driver as a module, choose M here; the module
+	will be called via_wdt.
+
+	Most people will say N.
+
 config W83627HF_WDT
 	tristate "W83627HF/W83627DHG Watchdog Timer"
 	depends on X86
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index fe893e9..e8f479a 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -99,6 +99,7 @@ obj-$(CONFIG_SBC7240_WDT) += sbc7240_wdt.o
 obj-$(CONFIG_CPU5_WDT) += cpu5wdt.o
 obj-$(CONFIG_SMSC_SCH311X_WDT) += sch311x_wdt.o
 obj-$(CONFIG_SMSC37B787_WDT) += smsc37b787_wdt.o
+obj-$(CONFIG_VIA_WDT) += via_wdt.o
 obj-$(CONFIG_W83627HF_WDT) += w83627hf_wdt.o
 obj-$(CONFIG_W83697HF_WDT) += w83697hf_wdt.o
 obj-$(CONFIG_W83697UG_WDT) += w83697ug_wdt.o
diff --git a/drivers/watchdog/ar7_wdt.c b/drivers/watchdog/ar7_wdt.c
index b292217..502773a 100644
--- a/drivers/watchdog/ar7_wdt.c
+++ b/drivers/watchdog/ar7_wdt.c
@@ -70,8 +70,8 @@ struct ar7_wdt {
 };
 
 static unsigned long wdt_is_open;
-static spinlock_t wdt_lock;
 static unsigned expect_close;
+static DEFINE_SPINLOCK(wdt_lock);
 
 /* XXX currently fixed, allows max margin ~68.72 secs */
 #define prescale_value 0xffff
@@ -280,8 +280,6 @@ static int __devinit ar7_wdt_probe(struct platform_device *pdev)
 {
 	int rc;
 
-	spin_lock_init(&wdt_lock);
-
 	ar7_regs_wdt =
 		platform_get_resource_byname(pdev, IORESOURCE_MEM, "regs");
 	if (!ar7_regs_wdt) {
@@ -355,15 +353,4 @@ static struct platform_driver ar7_wdt_driver = {
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
diff --git a/drivers/watchdog/ath79_wdt.c b/drivers/watchdog/ath79_wdt.c
index 725c84b..9db8083 100644
--- a/drivers/watchdog/ath79_wdt.c
+++ b/drivers/watchdog/ath79_wdt.c
@@ -68,17 +68,23 @@ static int max_timeout;
 static inline void ath79_wdt_keepalive(void)
 {
 	ath79_reset_wr(AR71XX_RESET_REG_WDOG, wdt_freq * timeout);
+	/* flush write */
+	ath79_reset_rr(AR71XX_RESET_REG_WDOG);
 }
 
 static inline void ath79_wdt_enable(void)
 {
 	ath79_wdt_keepalive();
 	ath79_reset_wr(AR71XX_RESET_REG_WDOG_CTRL, WDOG_CTRL_ACTION_FCR);
+	/* flush write */
+	ath79_reset_rr(AR71XX_RESET_REG_WDOG_CTRL);
 }
 
 static inline void ath79_wdt_disable(void)
 {
 	ath79_reset_wr(AR71XX_RESET_REG_WDOG_CTRL, WDOG_CTRL_ACTION_NONE);
+	/* flush write */
+	ath79_reset_rr(AR71XX_RESET_REG_WDOG_CTRL);
 }
 
 static int ath79_wdt_set_timeout(int val)
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
diff --git a/drivers/watchdog/cpu5wdt.c b/drivers/watchdog/cpu5wdt.c
index edd3475..251c863 100644
--- a/drivers/watchdog/cpu5wdt.c
+++ b/drivers/watchdog/cpu5wdt.c
@@ -39,7 +39,7 @@
 static int verbose;
 static int port = 0x91;
 static int ticks = 10000;
-static spinlock_t cpu5wdt_lock;
+static DEFINE_SPINLOCK(cpu5wdt_lock);
 
 #define PFX			"cpu5wdt: "
 
@@ -223,7 +223,6 @@ static int __devinit cpu5wdt_init(void)
 				"port=0x%x, verbose=%i\n", port, verbose);
 
 	init_completion(&cpu5wdt_device.stop);
-	spin_lock_init(&cpu5wdt_lock);
 	cpu5wdt_device.queue = 0;
 	setup_timer(&cpu5wdt_device.timer, cpu5wdt_trigger, 0);
 	cpu5wdt_device.default_ticks = ticks;
diff --git a/drivers/watchdog/cpwd.c b/drivers/watchdog/cpwd.c
index 1e013e8..1b793df 100644
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
diff --git a/drivers/watchdog/eurotechwdt.c b/drivers/watchdog/eurotechwdt.c
index 41018d4..3946c51 100644
--- a/drivers/watchdog/eurotechwdt.c
+++ b/drivers/watchdog/eurotechwdt.c
@@ -64,7 +64,7 @@
 static unsigned long eurwdt_is_open;
 static int eurwdt_timeout;
 static char eur_expect_close;
-static spinlock_t eurwdt_lock;
+static DEFINE_SPINLOCK(eurwdt_lock);
 
 /*
  * You must set these - there is no sane way to probe for this board.
@@ -446,8 +446,6 @@ static int __init eurwdt_init(void)
 		goto outreg;
 	}
 
-	spin_lock_init(&eurwdt_lock);
-
 	ret = misc_register(&eurwdt_miscdev);
 	if (ret) {
 		printk(KERN_ERR "eurwdt: can't misc_register on minor=%d\n",
diff --git a/drivers/watchdog/ibmasr.c b/drivers/watchdog/ibmasr.c
index 195e0f7..c7481ad 100644
--- a/drivers/watchdog/ibmasr.c
+++ b/drivers/watchdog/ibmasr.c
@@ -68,7 +68,7 @@ static char asr_expect_close;
 static unsigned int asr_type, asr_base, asr_length;
 static unsigned int asr_read_addr, asr_write_addr;
 static unsigned char asr_toggle_mask, asr_disable_mask;
-static spinlock_t asr_lock;
+static DEFINE_SPINLOCK(asr_lock);
 
 static void __asr_toggle(void)
 {
@@ -386,8 +386,6 @@ static int __init ibmasr_init(void)
 	if (!asr_type)
 		return -ENODEV;
 
-	spin_lock_init(&asr_lock);
-
 	rc = asr_get_base_address();
 	if (rc)
 		return rc;
diff --git a/drivers/watchdog/indydog.c b/drivers/watchdog/indydog.c
index 1cc5609..1475e09 100644
--- a/drivers/watchdog/indydog.c
+++ b/drivers/watchdog/indydog.c
@@ -28,7 +28,7 @@
 
 #define PFX "indydog: "
 static unsigned long indydog_alive;
-static spinlock_t indydog_lock;
+static DEFINE_SPINLOCK(indydog_lock);
 
 #define WATCHDOG_TIMEOUT 30		/* 30 sec default timeout */
 
@@ -185,8 +185,6 @@ static int __init watchdog_init(void)
 {
 	int ret;
 
-	spin_lock_init(&indydog_lock);
-
 	ret = register_reboot_notifier(&indydog_notifier);
 	if (ret) {
 		printk(KERN_ERR PFX
diff --git a/drivers/watchdog/iop_wdt.c b/drivers/watchdog/iop_wdt.c
index aef9478..82fa7a9 100644
--- a/drivers/watchdog/iop_wdt.c
+++ b/drivers/watchdog/iop_wdt.c
@@ -37,7 +37,7 @@
 static int nowayout = WATCHDOG_NOWAYOUT;
 static unsigned long wdt_status;
 static unsigned long boot_status;
-static spinlock_t wdt_lock;
+static DEFINE_SPINLOCK(wdt_lock);
 
 #define WDT_IN_USE		0
 #define WDT_OK_TO_CLOSE		1
@@ -226,9 +226,6 @@ static int __init iop_wdt_init(void)
 {
 	int ret;
 
-	spin_lock_init(&wdt_lock);
-
-
 	/* check if the reset was caused by the watchdog timer */
 	boot_status = (read_rcsr() & IOP_RCSR_WDT) ? WDIOF_CARDRESET : 0;
 
diff --git a/drivers/watchdog/ixp2000_wdt.c b/drivers/watchdog/ixp2000_wdt.c
index e86952a..084f71a 100644
--- a/drivers/watchdog/ixp2000_wdt.c
+++ b/drivers/watchdog/ixp2000_wdt.c
@@ -32,7 +32,7 @@
 static int nowayout = WATCHDOG_NOWAYOUT;
 static unsigned int heartbeat = 60;	/* (secs) Default is 1 minute */
 static unsigned long wdt_status;
-static spinlock_t wdt_lock;
+static DEFINE_SPINLOCK(wdt_lock);
 
 #define	WDT_IN_USE		0
 #define	WDT_OK_TO_CLOSE		1
@@ -189,7 +189,6 @@ static int __init ixp2000_wdt_init(void)
 		return -EIO;
 	}
 	wdt_tick_rate = (*IXP2000_T1_CLD * HZ) / 256;
-	spin_lock_init(&wdt_lock);
 	return misc_register(&ixp2000_wdt_miscdev);
 }
 
diff --git a/drivers/watchdog/ixp4xx_wdt.c b/drivers/watchdog/ixp4xx_wdt.c
index e02c0ec..4fc2e9a 100644
--- a/drivers/watchdog/ixp4xx_wdt.c
+++ b/drivers/watchdog/ixp4xx_wdt.c
@@ -181,7 +181,6 @@ static int __init ixp4xx_wdt_init(void)
 
 		return -ENODEV;
 	}
-	spin_lock_init(&wdt_lock);
 	boot_status = (*IXP4XX_OSST & IXP4XX_OSST_TIMER_WARM_RESET) ?
 			WDIOF_CARDRESET : 0;
 	ret = misc_register(&ixp4xx_wdt_miscdev);
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
diff --git a/drivers/watchdog/ks8695_wdt.c b/drivers/watchdog/ks8695_wdt.c
index 8114719..51757a5 100644
--- a/drivers/watchdog/ks8695_wdt.c
+++ b/drivers/watchdog/ks8695_wdt.c
@@ -42,7 +42,7 @@ MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
 
 
 static unsigned long ks8695wdt_busy;
-static spinlock_t ks8695_lock;
+static DEFINE_SPINLOCK(ks8695_lock);
 
 /* ......................................................................... */
 
@@ -288,7 +288,6 @@ static struct platform_driver ks8695wdt_driver = {
 
 static int __init ks8695_wdt_init(void)
 {
-	spin_lock_init(&ks8695_lock);
 	/* Check that the heartbeat value is within range;
 	   if not reset to the default */
 	if (ks8695_wdt_settimeout(wdt_time)) {
diff --git a/drivers/watchdog/lantiq_wdt.c b/drivers/watchdog/lantiq_wdt.c
index 102aed0..d3a63be 100644
--- a/drivers/watchdog/lantiq_wdt.c
+++ b/drivers/watchdog/lantiq_wdt.c
@@ -222,9 +222,6 @@ ltq_wdt_remove(struct platform_device *pdev)
 {
 	misc_deregister(&ltq_wdt_miscdev);
 
-	if (ltq_wdt_membase)
-		iounmap(ltq_wdt_membase);
-
 	return 0;
 }
 
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
index 2b4acb8..4b33e3f 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -55,7 +55,7 @@ module_param(timer_margin, uint, 0);
 MODULE_PARM_DESC(timer_margin, "initial watchdog timeout (in seconds)");
 
 static unsigned int wdt_trgr_pattern = 0x1234;
-static spinlock_t wdt_lock;
+static DEFINE_SPINLOCK(wdt_lock);
 
 struct omap_wdt_dev {
 	void __iomem    *base;          /* physical */
@@ -232,6 +232,7 @@ static long omap_wdt_ioctl(struct file *file, unsigned int cmd,
 		if (cpu_is_omap24xx())
 			return put_user(omap_prcm_get_reset_sources(),
 					(int __user *)arg);
+		return put_user(0, (int __user *)arg);
 	case WDIOC_KEEPALIVE:
 		pm_runtime_get_sync(wdev->dev);
 		spin_lock(&wdt_lock);
@@ -437,19 +438,7 @@ static struct platform_driver omap_wdt_driver = {
 	},
 };
 
-static int __init omap_wdt_init(void)
-{
-	spin_lock_init(&wdt_lock);
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
index 2d9fb96..4ad78f8 100644
--- a/drivers/watchdog/orion_wdt.c
+++ b/drivers/watchdog/orion_wdt.c
@@ -41,7 +41,7 @@ static int heartbeat = -1;		/* module parameter (seconds) */
 static unsigned int wdt_max_duration;	/* (seconds) */
 static unsigned int wdt_tclk;
 static unsigned long wdt_status;
-static spinlock_t wdt_lock;
+static DEFINE_SPINLOCK(wdt_lock);
 
 static void orion_wdt_ping(void)
 {
@@ -294,19 +294,7 @@ static struct platform_driver orion_wdt_driver = {
 	},
 };
 
-static int __init orion_wdt_init(void)
-{
-	spin_lock_init(&wdt_lock);
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
diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index a79e384..4bc3744 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -378,6 +378,8 @@ static int __devinit s3c2410wdt_probe(struct platform_device *pdev)
 							"cannot start\n");
 	}
 
+	watchdog_set_nowayout(&s3c2410_wdd, nowayout);
+
 	ret = watchdog_register_device(&s3c2410_wdd);
 	if (ret) {
 		dev_err(dev, "cannot register watchdog (%d)\n", ret);
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
diff --git a/drivers/watchdog/via_wdt.c b/drivers/watchdog/via_wdt.c
new file mode 100644
index 0000000..026b4bb
--- /dev/null
+++ b/drivers/watchdog/via_wdt.c
@@ -0,0 +1,267 @@
+/*
+ * VIA Chipset Watchdog Driver
+ *
+ * Copyright (C) 2011 Sigfox
+ * License terms: GNU General Public License (GPL) version 2
+ * Author: Marc Vertes <marc.vertes@sigfox.com>
+ * Based on a preliminary version from Harald Welte <HaraldWelte@viatech.com>
+ * Timer code by Wim Van Sebroeck <wim@iguana.be>
+ *
+ * Caveat: PnP must be enabled in BIOS to allow full access to watchdog
+ * control registers. If not, the watchdog must be configured in BIOS manually.
+ */
+#include <linux/device.h>
+#include <linux/io.h>
+#include <linux/jiffies.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/timer.h>
+#include <linux/watchdog.h>
+
+/* Configuration registers relative to the pci device */
+#define VIA_WDT_MMIO_BASE	0xe8	/* MMIO region base address */
+#define VIA_WDT_CONF		0xec	/* watchdog enable state */
+
+/* Relevant bits for the VIA_WDT_CONF register */
+#define VIA_WDT_CONF_ENABLE	0x01	/* 1: enable watchdog */
+#define VIA_WDT_CONF_MMIO	0x02	/* 1: enable watchdog MMIO */
+
+/*
+ * The MMIO region contains the watchog control register and the
+ * hardware timer counter.
+ */
+#define VIA_WDT_MMIO_LEN	8	/* MMIO region length in bytes */
+#define VIA_WDT_CTL		0	/* MMIO addr+0: state/control reg. */
+#define VIA_WDT_COUNT		4	/* MMIO addr+4: timer counter reg. */
+
+/* Bits for the VIA_WDT_CTL register */
+#define VIA_WDT_RUNNING		0x01	/* 0: stop, 1: running */
+#define VIA_WDT_FIRED		0x02	/* 1: restarted by expired watchdog */
+#define VIA_WDT_PWROFF		0x04	/* 0: reset, 1: poweroff */
+#define VIA_WDT_DISABLED	0x08	/* 1: timer is disabled */
+#define VIA_WDT_TRIGGER		0x80	/* 1: start a new countdown */
+
+/* Hardware heartbeat in seconds */
+#define WDT_HW_HEARTBEAT 1
+
+/* Timer heartbeat (500ms) */
+#define WDT_HEARTBEAT	(HZ/2)	/* should be <= ((WDT_HW_HEARTBEAT*HZ)/2) */
+
+/* User space timeout in seconds */
+#define WDT_TIMEOUT_MAX	1023	/* approx. 17 min. */
+#define WDT_TIMEOUT	60
+static int timeout = WDT_TIMEOUT;
+module_param(timeout, int, 0);
+MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds, between 1 and 1023 "
+	"(default = " __MODULE_STRING(WDT_TIMEOUT) ")");
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started "
+	"(default = " __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+static struct watchdog_device wdt_dev;
+static struct resource wdt_res;
+static void __iomem *wdt_mem;
+static unsigned int mmio;
+static void wdt_timer_tick(unsigned long data);
+static DEFINE_TIMER(timer, wdt_timer_tick, 0, 0);
+					/* The timer that pings the watchdog */
+static unsigned long next_heartbeat;	/* the next_heartbeat for the timer */
+
+static inline void wdt_reset(void)
+{
+	unsigned int ctl = readl(wdt_mem);
+
+	writel(ctl | VIA_WDT_TRIGGER, wdt_mem);
+}
+
+/*
+ * Timer tick: the timer will make sure that the watchdog timer hardware
+ * is being reset in time. The conditions to do this are:
+ *  1) the watchog timer has been started and /dev/watchdog is open
+ *     and there is still time left before userspace should send the
+ *     next heartbeat/ping. (note: the internal heartbeat is much smaller
+ *     then the external/userspace heartbeat).
+ *  2) the watchdog timer has been stopped by userspace.
+ */
+static void wdt_timer_tick(unsigned long data)
+{
+	if (time_before(jiffies, next_heartbeat) ||
+	   (!test_bit(WDOG_ACTIVE, &wdt_dev.status))) {
+		wdt_reset();
+		mod_timer(&timer, jiffies + WDT_HEARTBEAT);
+	} else
+		pr_crit("I will reboot your machine !\n");
+}
+
+static int wdt_ping(struct watchdog_device *wdd)
+{
+	/* calculate when the next userspace timeout will be */
+	next_heartbeat = jiffies + timeout * HZ;
+	return 0;
+}
+
+static int wdt_start(struct watchdog_device *wdd)
+{
+	unsigned int ctl = readl(wdt_mem);
+
+	writel(timeout, wdt_mem + VIA_WDT_COUNT);
+	writel(ctl | VIA_WDT_RUNNING | VIA_WDT_TRIGGER, wdt_mem);
+	wdt_ping(wdd);
+	mod_timer(&timer, jiffies + WDT_HEARTBEAT);
+	return 0;
+}
+
+static int wdt_stop(struct watchdog_device *wdd)
+{
+	unsigned int ctl = readl(wdt_mem);
+
+	writel(ctl & ~VIA_WDT_RUNNING, wdt_mem);
+	return 0;
+}
+
+static int wdt_set_timeout(struct watchdog_device *wdd,
+			   unsigned int new_timeout)
+{
+	if (new_timeout < 1 || new_timeout > WDT_TIMEOUT_MAX)
+		return -EINVAL;
+	writel(new_timeout, wdt_mem + VIA_WDT_COUNT);
+	timeout = new_timeout;
+	return 0;
+}
+
+static const struct watchdog_info wdt_info = {
+	.identity =	"VIA watchdog",
+	.options =	WDIOF_CARDRESET |
+			WDIOF_SETTIMEOUT |
+			WDIOF_MAGICCLOSE |
+			WDIOF_KEEPALIVEPING,
+};
+
+static const struct watchdog_ops wdt_ops = {
+	.owner =	THIS_MODULE,
+	.start =	wdt_start,
+	.stop =		wdt_stop,
+	.ping =		wdt_ping,
+	.set_timeout =	wdt_set_timeout,
+};
+
+static struct watchdog_device wdt_dev = {
+	.info =		&wdt_info,
+	.ops =		&wdt_ops,
+};
+
+static int __devinit wdt_probe(struct pci_dev *pdev,
+			       const struct pci_device_id *ent)
+{
+	unsigned char conf;
+	int ret = -ENODEV;
+
+	if (pci_enable_device(pdev)) {
+		dev_err(&pdev->dev, "cannot enable PCI device\n");
+		return -ENODEV;
+	}
+
+	/*
+	 * Allocate a MMIO region which contains watchdog control register
+	 * and counter, then configure the watchdog to use this region.
+	 * This is possible only if PnP is properly enabled in BIOS.
+	 * If not, the watchdog must be configured in BIOS manually.
+	 */
+	if (allocate_resource(&iomem_resource, &wdt_res, VIA_WDT_MMIO_LEN,
+			      0xf0000000, 0xffffff00, 0xff, NULL, NULL)) {
+		dev_err(&pdev->dev, "MMIO allocation failed\n");
+		goto err_out_disable_device;
+	}
+
+	pci_write_config_dword(pdev, VIA_WDT_MMIO_BASE, wdt_res.start);
+	pci_read_config_byte(pdev, VIA_WDT_CONF, &conf);
+	conf |= VIA_WDT_CONF_ENABLE | VIA_WDT_CONF_MMIO;
+	pci_write_config_byte(pdev, VIA_WDT_CONF, conf);
+
+	pci_read_config_dword(pdev, VIA_WDT_MMIO_BASE, &mmio);
+	if (mmio) {
+		dev_info(&pdev->dev, "VIA Chipset watchdog MMIO: %x\n", mmio);
+	} else {
+		dev_err(&pdev->dev, "MMIO setting failed. Check BIOS.\n");
+		goto err_out_resource;
+	}
+
+	if (!request_mem_region(mmio, VIA_WDT_MMIO_LEN, "via_wdt")) {
+		dev_err(&pdev->dev, "MMIO region busy\n");
+		goto err_out_resource;
+	}
+
+	wdt_mem = ioremap(mmio, VIA_WDT_MMIO_LEN);
+	if (wdt_mem == NULL) {
+		dev_err(&pdev->dev, "cannot remap VIA wdt MMIO registers\n");
+		goto err_out_release;
+	}
+
+	wdt_dev.timeout = timeout;
+	watchdog_set_nowayout(&wdt_dev, nowayout);
+	if (readl(wdt_mem) & VIA_WDT_FIRED)
+		wdt_dev.bootstatus |= WDIOF_CARDRESET;
+
+	ret = watchdog_register_device(&wdt_dev);
+	if (ret)
+		goto err_out_iounmap;
+
+	/* start triggering, in case of watchdog already enabled by BIOS */
+	mod_timer(&timer, jiffies + WDT_HEARTBEAT);
+	return 0;
+
+err_out_iounmap:
+	iounmap(wdt_mem);
+err_out_release:
+	release_mem_region(mmio, VIA_WDT_MMIO_LEN);
+err_out_resource:
+	release_resource(&wdt_res);
+err_out_disable_device:
+	pci_disable_device(pdev);
+	return ret;
+}
+
+static void __devexit wdt_remove(struct pci_dev *pdev)
+{
+	watchdog_unregister_device(&wdt_dev);
+	del_timer(&timer);
+	iounmap(wdt_mem);
+	release_mem_region(mmio, VIA_WDT_MMIO_LEN);
+	release_resource(&wdt_res);
+	pci_disable_device(pdev);
+}
+
+DEFINE_PCI_DEVICE_TABLE(wdt_pci_table) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_CX700) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VX800) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VX855) },
+	{ 0 }
+};
+
+static struct pci_driver wdt_driver = {
+	.name		= "via_wdt",
+	.id_table	= wdt_pci_table,
+	.probe		= wdt_probe,
+	.remove		= __devexit_p(wdt_remove),
+};
+
+static int __init wdt_init(void)
+{
+	if (timeout < 1 || timeout > WDT_TIMEOUT_MAX)
+		timeout = WDT_TIMEOUT;
+	return pci_register_driver(&wdt_driver);
+}
+
+static void __exit wdt_exit(void)
+{
+	pci_unregister_driver(&wdt_driver);
+}
+
+module_init(wdt_init);
+module_exit(wdt_exit);
+
+MODULE_AUTHOR("Marc Vertes");
+MODULE_DESCRIPTION("Driver for watchdog timer on VIA chipset");
+MODULE_LICENSE("GPL");
diff --git a/drivers/watchdog/wm831x_wdt.c b/drivers/watchdog/wm831x_wdt.c
index e789a47..263c883 100644
--- a/drivers/watchdog/wm831x_wdt.c
+++ b/drivers/watchdog/wm831x_wdt.c
@@ -199,7 +199,8 @@ static int __devinit wm831x_wdt_probe(struct platform_device *pdev)
 	if (reg & WM831X_WDOG_DEBUG)
 		dev_warn(wm831x->dev, "Watchdog is paused\n");
 
-	driver_data = kzalloc(sizeof(*driver_data), GFP_KERNEL);
+	driver_data = devm_kzalloc(&pdev->dev, sizeof(*driver_data),
+				   GFP_KERNEL);
 	if (!driver_data) {
 		dev_err(wm831x->dev, "Unable to alloacate watchdog device\n");
 		ret = -ENOMEM;
@@ -213,11 +214,9 @@ static int __devinit wm831x_wdt_probe(struct platform_device *pdev)
 
 	wm831x_wdt->info = &wm831x_wdt_info;
 	wm831x_wdt->ops = &wm831x_wdt_ops;
+	watchdog_set_nowayout(wm831x_wdt, nowayout);
 	watchdog_set_drvdata(wm831x_wdt, driver_data);
 
-	if (nowayout)
-		wm831x_wdt->status |= WDOG_NO_WAY_OUT;
-
 	reg = wm831x_reg_read(wm831x, WM831X_WATCHDOG);
 	reg &= WM831X_WDOG_TO_MASK;
 	for (i = 0; i < ARRAY_SIZE(wm831x_wdt_cfgs); i++)
@@ -252,7 +251,7 @@ static int __devinit wm831x_wdt_probe(struct platform_device *pdev)
 				dev_err(wm831x->dev,
 					"Failed to request update GPIO: %d\n",
 					ret);
-				goto err_alloc;
+				goto err;
 			}
 
 			ret = gpio_direction_output(pdata->update_gpio, 0);
@@ -294,8 +293,6 @@ static int __devinit wm831x_wdt_probe(struct platform_device *pdev)
 err_gpio:
 	if (driver_data->update_gpio)
 		gpio_free(driver_data->update_gpio);
-err_alloc:
-	kfree(driver_data);
 err:
 	return ret;
 }
@@ -320,17 +317,7 @@ static struct platform_driver wm831x_wdt_driver = {
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
diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
index 111843f..43ba5b3 100644
--- a/include/linux/watchdog.h
+++ b/include/linux/watchdog.h
@@ -53,11 +53,7 @@ struct watchdog_info {
 
 #ifdef __KERNEL__
 
-#ifdef CONFIG_WATCHDOG_NOWAYOUT
-#define WATCHDOG_NOWAYOUT	1
-#else
-#define WATCHDOG_NOWAYOUT	0
-#endif
+#include <linux/bitops.h>
 
 struct watchdog_ops;
 struct watchdog_device;
@@ -122,6 +118,21 @@ struct watchdog_device {
 #define WDOG_NO_WAY_OUT		3	/* Is 'nowayout' feature set ? */
 };
 
+#ifdef CONFIG_WATCHDOG_NOWAYOUT
+#define WATCHDOG_NOWAYOUT		1
+#define WATCHDOG_NOWAYOUT_INIT_STATUS	(1 << WDOG_NO_WAY_OUT)
+#else
+#define WATCHDOG_NOWAYOUT		0
+#define WATCHDOG_NOWAYOUT_INIT_STATUS	0
+#endif
+
+/* Use the following function to set the nowayout feature */
+static inline void watchdog_set_nowayout(struct watchdog_device *wdd, int nowayout)
+{
+	if (nowayout)
+		set_bit(WDOG_NO_WAY_OUT, &wdd->status);
+}
+
 /* Use the following functions to manipulate watchdog driver specific data */
 static inline void watchdog_set_drvdata(struct watchdog_device *wdd, void *data)
 {
