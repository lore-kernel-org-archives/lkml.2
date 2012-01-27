Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab2A0JWo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 04:22:44 -0500
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:22044 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751517Ab2A0JWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 04:22:40 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAO9rIk9tg128/2dsb2JhbABCrlGBBoIgExwjGBdGDRgDIROHfga3fROJAwMKAwsFBgkGAgEBAQgBCAYFAQsCgngJAwICBhsChAZjBJUZiwOHTA
Date: Fri, 27 Jan 2012 10:22:37 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Axel Lin <axel.lin@gmail.com>, Julia Lawall <julia@diku.dk>,
        Masanari Iida <standby24x7@gmail.com>,
        Seth Heasley <seth.heasley@intel.com>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [GIT PULL REQUEST] watchdog - v3.3-rc1 Fixes
Message-ID: <20120127092236.GA31462@infomag.iguana.be>
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

(Note: the hpwdt fix is still under test/review).

This will update the following files:

 dw_wdt.c       |    6 +-----
 iTCO_wdt.c     |   35 +++++++++++++++++++++++++++++++++++
 imx2_wdt.c     |   11 +----------
 nuc900_wdt.c   |    5 +++--
 omap_wdt.c     |    2 ++
 pnx4008_wdt.c  |    2 +-
 stmp3xxx_wdt.c |    2 +-
 via_wdt.c      |    6 +++---
 wafer5823wdt.c |    4 ++--
 wm8350_wdt.c   |    4 ++--
 10 files changed, 51 insertions(+), 26 deletions(-)

with these Changes:

commit 84e83c2846ffb42772056a0f825d8578dc92d586
Author: Seth Heasley <seth.heasley@intel.com>
Date:   Mon Jan 23 16:40:55 2012 -0800

    watchdog: iTCO_wdt: add Intel Lynx Point DeviceIDs
    
    This patch adds the TCO Watchdog DeviceIDs for the Intel Lynx Point PCH.
    
    Signed-off-by: Seth Heasley <seth.heasley@intel.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit f6dd94f8194408e11df4e33e1f7113612e84ca17
Author: Axel Lin <axel.lin@gmail.com>
Date:   Sat Jan 21 15:08:38 2012 +0800

    watchdog: via_wdt: Set min_timeout and max_timeout for wdt_dev
    
    Let the watchdog core to check the valid value range of min_timeout/max_timeout.
    
    Signed-off-by: Axel Lin <axel.lin@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit b1785dfd4fcd4011834f914810c1acb46b007a44
Author: Masanari Iida <standby24x7@gmail.com>
Date:   Fri Jan 20 23:56:19 2012 +0900

    watchdog: Fix typo "unexpectdly"
    
    Correct typo "unexpectdly" to "unexpectedly" in pnx4008_wdt.c
    and stmp3xxx_wdt.c
    
    Signed-off-by: Masanari Iida<standby24x7@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 8a062ac693d5597b3c5d0e347ce7d1d82b967698
Author: Axel Lin <axel.lin@gmail.com>
Date:   Wed Jan 18 19:26:43 2012 +0800

    watchdog: wafer5823wdt: Fix handling WDIOS_DISABLECARD/WDIOS_ENABLECARD options
    
    While receiving WDIOS_DISABLECARD option for WDIOC_SETOPTIONS command,
    call wafwdt_stop() to disable watchdog.
    Call wafwdt_start() while receiving WDIOS_ENABLECARD option.
    
    Current code has reverse behavior.
    
    Signed-off-by: Axel Lin <axel.lin@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit ebe06e826faed9d710c3d49fe336c74b5f3a5f2a
Author: Axel Lin <axel.lin@gmail.com>
Date:   Wed Jan 18 19:25:01 2012 +0800

    watchdog: wm8350_wdt: Fix handling WDIOS_DISABLECARD/WDIOS_ENABLECARD options
    
    While receiving WDIOS_DISABLECARD option for WDIOC_SETOPTIONS command,
    call wm8350_wdt_stop() to disable watchdog.
    Call wm8350_wdt_start() while receiving WDIOS_ENABLECARD option.
    
    Current code has reverse behavior.
    
    Signed-off-by: Axel Lin <axel.lin@gmail.com>
    Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 2865e770c9dddd40676eadf7c3dfe80aee7628e4
Author: Axel Lin <axel.lin@gmail.com>
Date:   Wed Jan 18 10:46:52 2012 +0800

    watchdog: Return proper error in nuc900wdt_probe if misc_register fails
    
    Return proper error instead of 0 if misc_register fails
    
    Signed-off-by: Axel Lin <axel.lin@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit e352829a67c1a80c73dfad33ba9dca8ddf2ef0fd
Author: Axel Lin <axel.lin@gmail.com>
Date:   Wed Jan 18 10:45:20 2012 +0800

    watchdog: Staticise nuc900_wdt
    
    It is only used in this driver, so no need to make the symbol global.
    
    Signed-off-by: Axel Lin <axel.lin@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 0318e286f9a73547dedfd9f733671f4941efb0e2
Author: Axel Lin <axel.lin@gmail.com>
Date:   Sat Jan 14 19:34:34 2012 +0800

    watchdog: via_wdt: Staticise wdt_pci_table
    
    It is only used in this driver, so no need to make the symbol global.
    
    Signed-off-by: Axel Lin <axel.lin@gmail.com>
    Acked-by: Marc Vertes <marc.vertes@sigfox.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 12c583d8dca3320f36afe51e514dfa709ac0662e
Author: Shubhrajyoti D <shubhrajyoti@ti.com>
Date:   Wed Jan 11 19:50:18 2012 +0530

    watchdog: omap_wdt.c: Fix the mismatch of pm_runtime enable and disable
    
    Currently the watchdog driver calls the pm_runtime_enable and never
    the disable. This may cause a warning when pm_runtime_enable
    checks for the count match.
    
    Also fixes the error
    
    /build/watchdog # insmod omap_wdt.ko
    [   44.999389] omap_wdt omap_wdt: Unbalanced pm_runtime_enable!
    [   45.011047] OMAP Watchdog Timer Rev 0x00: initial timeout 60 sec
    /build/watchdog #
    
    Attempting to fix the same by calling pm_runtime_disable.
    
    Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 52ea9a7d7946c03aa1f9eeb71adb0191402724dd
Author: Julia Lawall <julia@diku.dk>
Date:   Tue Dec 27 15:01:29 2011 +0100

    watchdog: dw_wdt.c: use devm_request_and_ioremap
    
    Reimplement a call to devm_request_mem_region followed by a call to ioremap
    or ioremap_nocache by a call to devm_request_and_ioremap.
    
    The semantic patch that makes this transformation is as follows:
    (http://coccinelle.lip6.fr/)
    
    // <smpl>
    @nm@
    expression myname;
    identifier i;
    @@
    
    struct platform_driver i = { .driver = { .name = myname } };
    
    @@
    expression dev,res,size;
    expression nm.myname;
    @@
    
    -if (!devm_request_mem_region(dev, res->start, size,
    -                              \(res->name\|dev_name(dev)\|myname\))) {
    -   ...
    -   return ...;
    -}
    ... when != res->start
    (
    -devm_ioremap(dev,res->start,size)
    +devm_request_and_ioremap(dev,res)
    |
    -devm_ioremap_nocache(dev,res->start,size)
    +devm_request_and_ioremap(dev,res)
    )
    ... when any
        when != res->start
    // </smpl>
    
    Signed-off-by: Julia Lawall <julia@diku.dk>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 5d32d4868ad87a5be8571b22b3d732576504dfb0
Author: Julia Lawall <julia@diku.dk>
Date:   Tue Dec 27 15:01:28 2011 +0100

    watchdog: imx2_wdt.c: use devm_request_and_ioremap
    
    Reimplement a call to devm_request_mem_region followed by a call to ioremap
    or ioremap_nocache by a call to devm_request_and_ioremap.
    
    The variable res_size is then no longer needed.
    
    The semantic patch that makes this transformation is as follows:
    (http://coccinelle.lip6.fr/)
    
    // <smpl>
    @nm@
    expression myname;
    identifier i;
    @@
    
    struct platform_driver i = { .driver = { .name = myname } };
    
    @@
    expression dev,res,size;
    expression nm.myname;
    @@
    
    -if (!devm_request_mem_region(dev, res->start, size,
    -                              \(res->name\|dev_name(dev)\|myname\))) {
    -   ...
    -   return ...;
    -}
    ... when != res->start
    (
    -devm_ioremap(dev,res->start,size)
    +devm_request_and_ioremap(dev,res)
    |
    -devm_ioremap_nocache(dev,res->start,size)
    +devm_request_and_ioremap(dev,res)
    )
    ... when any
        when != res->start
    // </smpl>
    
    Signed-off-by: Julia Lawall <julia@diku.dk>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/dw_wdt.c b/drivers/watchdog/dw_wdt.c
index 1b0e3dd..63d7b58 100644
--- a/drivers/watchdog/dw_wdt.c
+++ b/drivers/watchdog/dw_wdt.c
@@ -300,11 +300,7 @@ static int __devinit dw_wdt_drv_probe(struct platform_device *pdev)
 	if (!mem)
 		return -EINVAL;
 
-	if (!devm_request_mem_region(&pdev->dev, mem->start, resource_size(mem),
-				     "dw_wdt"))
-		return -ENOMEM;
-
-	dw_wdt.regs = devm_ioremap(&pdev->dev, mem->start, resource_size(mem));
+	dw_wdt.regs = devm_request_and_ioremap(&pdev->dev, mem);
 	if (!dw_wdt.regs)
 		return -ENOMEM;
 
diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index 99796c5..bdf401b 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -36,6 +36,7 @@
  *	document number TBD                   : Patsburg (PBG)
  *	document number TBD                   : DH89xxCC
  *	document number TBD                   : Panther Point
+ *	document number TBD                   : Lynx Point
  */
 
 /*
@@ -126,6 +127,7 @@ enum iTCO_chipsets {
 	TCO_PBG,	/* Patsburg */
 	TCO_DH89XXCC,	/* DH89xxCC */
 	TCO_PPT,	/* Panther Point */
+	TCO_LPT,	/* Lynx Point */
 };
 
 static struct {
@@ -189,6 +191,7 @@ static struct {
 	{"Patsburg", 2},
 	{"DH89xxCC", 2},
 	{"Panther Point", 2},
+	{"Lynx Point", 2},
 	{NULL, 0}
 };
 
@@ -331,6 +334,38 @@ static DEFINE_PCI_DEVICE_TABLE(iTCO_wdt_pci_tbl) = {
 	{ PCI_VDEVICE(INTEL, 0x1e5d), TCO_PPT},
 	{ PCI_VDEVICE(INTEL, 0x1e5e), TCO_PPT},
 	{ PCI_VDEVICE(INTEL, 0x1e5f), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x8c40), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c41), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c42), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c43), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c44), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c45), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c46), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c47), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c48), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c49), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c4a), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c4b), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c4c), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c4d), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c4e), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c4f), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c50), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c51), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c52), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c53), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c54), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c55), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c56), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c57), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c58), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c59), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c5a), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c5b), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c5c), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c5d), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c5e), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c5f), TCO_LPT},
 	{ 0, },			/* End of list */
 };
 MODULE_DEVICE_TABLE(pci, iTCO_wdt_pci_tbl);
diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
index b8ef2c6..c44c333 100644
--- a/drivers/watchdog/imx2_wdt.c
+++ b/drivers/watchdog/imx2_wdt.c
@@ -247,7 +247,6 @@ static struct miscdevice imx2_wdt_miscdev = {
 static int __init imx2_wdt_probe(struct platform_device *pdev)
 {
 	int ret;
-	int res_size;
 	struct resource *res;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -256,15 +255,7 @@ static int __init imx2_wdt_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	res_size = resource_size(res);
-	if (!devm_request_mem_region(&pdev->dev, res->start, res_size,
-		res->name)) {
-		dev_err(&pdev->dev, "can't allocate %d bytes at %d address\n",
-			res_size, res->start);
-		return -ENOMEM;
-	}
-
-	imx2_wdt.base = devm_ioremap_nocache(&pdev->dev, res->start, res_size);
+	imx2_wdt.base = devm_request_and_ioremap(&pdev->dev, res);
 	if (!imx2_wdt.base) {
 		dev_err(&pdev->dev, "ioremap failed\n");
 		return -ENOMEM;
diff --git a/drivers/watchdog/nuc900_wdt.c b/drivers/watchdog/nuc900_wdt.c
index 50359ba..529085b 100644
--- a/drivers/watchdog/nuc900_wdt.c
+++ b/drivers/watchdog/nuc900_wdt.c
@@ -72,7 +72,7 @@ struct nuc900_wdt {
 };
 
 static unsigned long nuc900wdt_busy;
-struct nuc900_wdt *nuc900_wdt;
+static struct nuc900_wdt *nuc900_wdt;
 
 static inline void nuc900_wdt_keepalive(void)
 {
@@ -287,7 +287,8 @@ static int __devinit nuc900wdt_probe(struct platform_device *pdev)
 
 	setup_timer(&nuc900_wdt->timer, nuc900_wdt_timer_ping, 0);
 
-	if (misc_register(&nuc900wdt_miscdev)) {
+	ret = misc_register(&nuc900wdt_miscdev);
+	if (ret) {
 		dev_err(&pdev->dev, "err register miscdev on minor=%d (%d)\n",
 			WATCHDOG_MINOR, ret);
 		goto err_clk;
diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index 4b33e3f..d19ff51 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -339,6 +339,7 @@ static int __devinit omap_wdt_probe(struct platform_device *pdev)
 	return 0;
 
 err_misc:
+	pm_runtime_disable(wdev->dev);
 	platform_set_drvdata(pdev, NULL);
 	iounmap(wdev->base);
 
@@ -371,6 +372,7 @@ static int __devexit omap_wdt_remove(struct platform_device *pdev)
 	struct omap_wdt_dev *wdev = platform_get_drvdata(pdev);
 	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
+	pm_runtime_disable(wdev->dev);
 	if (!res)
 		return -ENOENT;
 
diff --git a/drivers/watchdog/pnx4008_wdt.c b/drivers/watchdog/pnx4008_wdt.c
index bd143c9..8e210aa 100644
--- a/drivers/watchdog/pnx4008_wdt.c
+++ b/drivers/watchdog/pnx4008_wdt.c
@@ -226,7 +226,7 @@ static long pnx4008_wdt_ioctl(struct file *file, unsigned int cmd,
 static int pnx4008_wdt_release(struct inode *inode, struct file *file)
 {
 	if (!test_bit(WDT_OK_TO_CLOSE, &wdt_status))
-		printk(KERN_WARNING "WATCHDOG: Device closed unexpectdly\n");
+		printk(KERN_WARNING "WATCHDOG: Device closed unexpectedly\n");
 
 	wdt_disable();
 	clk_disable(wdt_clk);
diff --git a/drivers/watchdog/stmp3xxx_wdt.c b/drivers/watchdog/stmp3xxx_wdt.c
index 4c2a4e8..e37d811 100644
--- a/drivers/watchdog/stmp3xxx_wdt.c
+++ b/drivers/watchdog/stmp3xxx_wdt.c
@@ -174,7 +174,7 @@ static int stmp3xxx_wdt_release(struct inode *inode, struct file *file)
 	if (!nowayout) {
 		if (!test_bit(WDT_OK_TO_CLOSE, &wdt_status)) {
 			wdt_ping();
-			pr_debug("%s: Device closed unexpectdly\n", __func__);
+			pr_debug("%s: Device closed unexpectedly\n", __func__);
 			ret = -EINVAL;
 		} else {
 			wdt_disable();
diff --git a/drivers/watchdog/via_wdt.c b/drivers/watchdog/via_wdt.c
index 026b4bb..8f07dd4 100644
--- a/drivers/watchdog/via_wdt.c
+++ b/drivers/watchdog/via_wdt.c
@@ -124,8 +124,6 @@ static int wdt_stop(struct watchdog_device *wdd)
 static int wdt_set_timeout(struct watchdog_device *wdd,
 			   unsigned int new_timeout)
 {
-	if (new_timeout < 1 || new_timeout > WDT_TIMEOUT_MAX)
-		return -EINVAL;
 	writel(new_timeout, wdt_mem + VIA_WDT_COUNT);
 	timeout = new_timeout;
 	return 0;
@@ -150,6 +148,8 @@ static const struct watchdog_ops wdt_ops = {
 static struct watchdog_device wdt_dev = {
 	.info =		&wdt_info,
 	.ops =		&wdt_ops,
+	.min_timeout =	1,
+	.max_timeout =	WDT_TIMEOUT_MAX,
 };
 
 static int __devinit wdt_probe(struct pci_dev *pdev,
@@ -233,7 +233,7 @@ static void __devexit wdt_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
-DEFINE_PCI_DEVICE_TABLE(wdt_pci_table) = {
+static DEFINE_PCI_DEVICE_TABLE(wdt_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_CX700) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VX800) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VX855) },
diff --git a/drivers/watchdog/wafer5823wdt.c b/drivers/watchdog/wafer5823wdt.c
index 42e940c..c3c3188 100644
--- a/drivers/watchdog/wafer5823wdt.c
+++ b/drivers/watchdog/wafer5823wdt.c
@@ -152,12 +152,12 @@ static long wafwdt_ioctl(struct file *file, unsigned int cmd,
 			return -EFAULT;
 
 		if (options & WDIOS_DISABLECARD) {
-			wafwdt_start();
+			wafwdt_stop();
 			retval = 0;
 		}
 
 		if (options & WDIOS_ENABLECARD) {
-			wafwdt_stop();
+			wafwdt_start();
 			retval = 0;
 		}
 
diff --git a/drivers/watchdog/wm8350_wdt.c b/drivers/watchdog/wm8350_wdt.c
index 909c786..5d7113c 100644
--- a/drivers/watchdog/wm8350_wdt.c
+++ b/drivers/watchdog/wm8350_wdt.c
@@ -212,10 +212,10 @@ static long wm8350_wdt_ioctl(struct file *file, unsigned int cmd,
 
 		/* Setting both simultaneously means at least one must fail */
 		if (options == WDIOS_DISABLECARD)
-			ret = wm8350_wdt_start(wm8350);
+			ret = wm8350_wdt_stop(wm8350);
 
 		if (options == WDIOS_ENABLECARD)
-			ret = wm8350_wdt_stop(wm8350);
+			ret = wm8350_wdt_start(wm8350);
 		break;
 	}
 
