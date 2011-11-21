Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab1KUP7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 10:59:00 -0500
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:37336 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753572Ab1KUP66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 10:58:58 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkgFAP90yk5tg6zW/2dsb2JhbAA6CadLgm2BBoIgExwjGBUCRiUDDRQTiAUGtD4ShlKDMwSUO5IH
Date: Mon, 21 Nov 2011 16:55:44 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Subject: [GIT PULL REQUEST] watchdog - v3.1-rc2 - Fixes and removal
Message-ID: <20111121155544.GI23376@infomag.iguana.be>
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

 b/drivers/watchdog/Kconfig       |    7 
 b/drivers/watchdog/Makefile      |    1 
 b/drivers/watchdog/s3c2410_wdt.c |    4 
 b/drivers/watchdog/wm831x_wdt.c  |    2 
 drivers/watchdog/adx_wdt.c       |  355 ---------------------------------------
 5 files changed, 3 insertions(+), 366 deletions(-)

with these Changes:

commit 20403e845f9988446c5b48024ff4d0c3a5929f7d
Author: Dmitry Artamonow <mad_soft@inbox.ru>
Date:   Wed Nov 16 12:46:13 2011 +0400

    watchdog: fix initialisation printout in s3c2410_wdt
    
    Looks like a typo creeped in, and driver prints
    s3c2410-wdt s3c2410-wdt: watchdog active, reset abled, irq abled
    
    instead of
    s3c2410-wdt s3c2410-wdt: watchdog active, reset enabled, irq enabled
    
    Also it may completely disinform about irq status, as it prints
    "irq enabled" when S3C2410_WTCON_INTEN is in fact 0.
    
    Fix it.
    
    Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
    Tested-by: Thomas Abraham <thomas.abraham@linaro.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit f9849100851b28c8ad83e86d68d5110497a4e9d6
Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
Date:   Wed Nov 16 11:52:12 2011 +0000

    watchdog: Don't overwrite error value in wm831x_wdt_set_timeout()
    
    Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
    Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 943ef2ec4f5f14940ea391d25bf93eb99eb2ff2a
Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Tue Nov 15 11:45:16 2011 +0100

    watchdog: adx_wdt.c: remove driver
    
    Remove the driver (that was added in v2.6.32) since the architecture
    has never been merged into mainline.
    
    Reported-by: Paul Bolle <pebolle@tiscali.nl>
    Acked-by: Thierry Reding <thierry.reding@avionic-design.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 6285867..79fd606 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -314,13 +314,6 @@ config NUC900_WATCHDOG
 	  To compile this driver as a module, choose M here: the
 	  module will be called nuc900_wdt.
 
-config ADX_WATCHDOG
-	tristate "Avionic Design Xanthos watchdog"
-	depends on ARCH_PXA_ADX
-	help
-	  Say Y here if you want support for the watchdog timer on Avionic
-	  Design Xanthos boards.
-
 config TS72XX_WATCHDOG
 	tristate "TS-72XX SBC Watchdog"
 	depends on MACH_TS72XX
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 55bd574..fe893e9 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -51,7 +51,6 @@ obj-$(CONFIG_ORION_WATCHDOG) += orion_wdt.o
 obj-$(CONFIG_COH901327_WATCHDOG) += coh901327_wdt.o
 obj-$(CONFIG_STMP3XXX_WATCHDOG) += stmp3xxx_wdt.o
 obj-$(CONFIG_NUC900_WATCHDOG) += nuc900_wdt.o
-obj-$(CONFIG_ADX_WATCHDOG) += adx_wdt.o
 obj-$(CONFIG_TS72XX_WATCHDOG) += ts72xx_wdt.o
 obj-$(CONFIG_IMX2_WDT) += imx2_wdt.o
 
diff --git a/drivers/watchdog/adx_wdt.c b/drivers/watchdog/adx_wdt.c
deleted file mode 100644
index af6e6b1..0000000
--- a/drivers/watchdog/adx_wdt.c
+++ /dev/null
@@ -1,355 +0,0 @@
-/*
- * Copyright (C) 2008-2009 Avionic Design GmbH
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/fs.h>
-#include <linux/gfp.h>
-#include <linux/io.h>
-#include <linux/miscdevice.h>
-#include <linux/module.h>
-#include <linux/platform_device.h>
-#include <linux/types.h>
-#include <linux/uaccess.h>
-#include <linux/watchdog.h>
-
-#define WATCHDOG_NAME "adx-wdt"
-
-/* register offsets */
-#define	ADX_WDT_CONTROL		0x00
-#define	ADX_WDT_CONTROL_ENABLE	(1 << 0)
-#define	ADX_WDT_CONTROL_nRESET	(1 << 1)
-#define	ADX_WDT_TIMEOUT		0x08
-
-static struct platform_device *adx_wdt_dev;
-static unsigned long driver_open;
-
-#define	WDT_STATE_STOP	0
-#define	WDT_STATE_START	1
-
-struct adx_wdt {
-	void __iomem *base;
-	unsigned long timeout;
-	unsigned int state;
-	unsigned int wake;
-	spinlock_t lock;
-};
-
-static const struct watchdog_info adx_wdt_info = {
-	.identity = "Avionic Design Xanthos Watchdog",
-	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
-};
-
-static void adx_wdt_start_locked(struct adx_wdt *wdt)
-{
-	u32 ctrl;
-
-	ctrl = readl(wdt->base + ADX_WDT_CONTROL);
-	ctrl |= ADX_WDT_CONTROL_ENABLE;
-	writel(ctrl, wdt->base + ADX_WDT_CONTROL);
-	wdt->state = WDT_STATE_START;
-}
-
-static void adx_wdt_start(struct adx_wdt *wdt)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&wdt->lock, flags);
-	adx_wdt_start_locked(wdt);
-	spin_unlock_irqrestore(&wdt->lock, flags);
-}
-
-static void adx_wdt_stop_locked(struct adx_wdt *wdt)
-{
-	u32 ctrl;
-
-	ctrl = readl(wdt->base + ADX_WDT_CONTROL);
-	ctrl &= ~ADX_WDT_CONTROL_ENABLE;
-	writel(ctrl, wdt->base + ADX_WDT_CONTROL);
-	wdt->state = WDT_STATE_STOP;
-}
-
-static void adx_wdt_stop(struct adx_wdt *wdt)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&wdt->lock, flags);
-	adx_wdt_stop_locked(wdt);
-	spin_unlock_irqrestore(&wdt->lock, flags);
-}
-
-static void adx_wdt_set_timeout(struct adx_wdt *wdt, unsigned long seconds)
-{
-	unsigned long timeout = seconds * 1000;
-	unsigned long flags;
-	unsigned int state;
-
-	spin_lock_irqsave(&wdt->lock, flags);
-	state = wdt->state;
-	adx_wdt_stop_locked(wdt);
-	writel(timeout, wdt->base + ADX_WDT_TIMEOUT);
-
-	if (state == WDT_STATE_START)
-		adx_wdt_start_locked(wdt);
-
-	wdt->timeout = timeout;
-	spin_unlock_irqrestore(&wdt->lock, flags);
-}
-
-static void adx_wdt_get_timeout(struct adx_wdt *wdt, unsigned long *seconds)
-{
-	*seconds = wdt->timeout / 1000;
-}
-
-static void adx_wdt_keepalive(struct adx_wdt *wdt)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&wdt->lock, flags);
-	writel(wdt->timeout, wdt->base + ADX_WDT_TIMEOUT);
-	spin_unlock_irqrestore(&wdt->lock, flags);
-}
-
-static int adx_wdt_open(struct inode *inode, struct file *file)
-{
-	struct adx_wdt *wdt = platform_get_drvdata(adx_wdt_dev);
-
-	if (test_and_set_bit(0, &driver_open))
-		return -EBUSY;
-
-	file->private_data = wdt;
-	adx_wdt_set_timeout(wdt, 30);
-	adx_wdt_start(wdt);
-
-	return nonseekable_open(inode, file);
-}
-
-static int adx_wdt_release(struct inode *inode, struct file *file)
-{
-	struct adx_wdt *wdt = file->private_data;
-
-	adx_wdt_stop(wdt);
-	clear_bit(0, &driver_open);
-
-	return 0;
-}
-
-static long adx_wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
-{
-	struct adx_wdt *wdt = file->private_data;
-	void __user *argp = (void __user *)arg;
-	unsigned long __user *p = argp;
-	unsigned long seconds = 0;
-	unsigned int options;
-	long ret = -EINVAL;
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		if (copy_to_user(argp, &adx_wdt_info, sizeof(adx_wdt_info)))
-			return -EFAULT;
-		else
-			return 0;
-
-	case WDIOC_GETSTATUS:
-	case WDIOC_GETBOOTSTATUS:
-		return put_user(0, p);
-
-	case WDIOC_KEEPALIVE:
-		adx_wdt_keepalive(wdt);
-		return 0;
-
-	case WDIOC_SETTIMEOUT:
-		if (get_user(seconds, p))
-			return -EFAULT;
-
-		adx_wdt_set_timeout(wdt, seconds);
-
-		/* fallthrough */
-	case WDIOC_GETTIMEOUT:
-		adx_wdt_get_timeout(wdt, &seconds);
-		return put_user(seconds, p);
-
-	case WDIOC_SETOPTIONS:
-		if (copy_from_user(&options, argp, sizeof(options)))
-			return -EFAULT;
-
-		if (options & WDIOS_DISABLECARD) {
-			adx_wdt_stop(wdt);
-			ret = 0;
-		}
-
-		if (options & WDIOS_ENABLECARD) {
-			adx_wdt_start(wdt);
-			ret = 0;
-		}
-
-		return ret;
-
-	default:
-		break;
-	}
-
-	return -ENOTTY;
-}
-
-static ssize_t adx_wdt_write(struct file *file, const char __user *data,
-		size_t len, loff_t *ppos)
-{
-	struct adx_wdt *wdt = file->private_data;
-
-	if (len)
-		adx_wdt_keepalive(wdt);
-
-	return len;
-}
-
-static const struct file_operations adx_wdt_fops = {
-	.owner = THIS_MODULE,
-	.llseek = no_llseek,
-	.open = adx_wdt_open,
-	.release = adx_wdt_release,
-	.unlocked_ioctl = adx_wdt_ioctl,
-	.write = adx_wdt_write,
-};
-
-static struct miscdevice adx_wdt_miscdev = {
-	.minor = WATCHDOG_MINOR,
-	.name = "watchdog",
-	.fops = &adx_wdt_fops,
-};
-
-static int __devinit adx_wdt_probe(struct platform_device *pdev)
-{
-	struct resource *res;
-	struct adx_wdt *wdt;
-	int ret = 0;
-	u32 ctrl;
-
-	wdt = devm_kzalloc(&pdev->dev, sizeof(*wdt), GFP_KERNEL);
-	if (!wdt) {
-		dev_err(&pdev->dev, "cannot allocate WDT structure\n");
-		return -ENOMEM;
-	}
-
-	spin_lock_init(&wdt->lock);
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "cannot obtain I/O memory region\n");
-		return -ENXIO;
-	}
-
-	res = devm_request_mem_region(&pdev->dev, res->start,
-			resource_size(res), res->name);
-	if (!res) {
-		dev_err(&pdev->dev, "cannot request I/O memory region\n");
-		return -ENXIO;
-	}
-
-	wdt->base = devm_ioremap_nocache(&pdev->dev, res->start,
-			resource_size(res));
-	if (!wdt->base) {
-		dev_err(&pdev->dev, "cannot remap I/O memory region\n");
-		return -ENXIO;
-	}
-
-	/* disable watchdog and reboot on timeout */
-	ctrl = readl(wdt->base + ADX_WDT_CONTROL);
-	ctrl &= ~ADX_WDT_CONTROL_ENABLE;
-	ctrl &= ~ADX_WDT_CONTROL_nRESET;
-	writel(ctrl, wdt->base + ADX_WDT_CONTROL);
-
-	platform_set_drvdata(pdev, wdt);
-	adx_wdt_dev = pdev;
-
-	ret = misc_register(&adx_wdt_miscdev);
-	if (ret) {
-		dev_err(&pdev->dev, "cannot register miscdev on minor %d "
-				"(err=%d)\n", WATCHDOG_MINOR, ret);
-		return ret;
-	}
-
-	return 0;
-}
-
-static int __devexit adx_wdt_remove(struct platform_device *pdev)
-{
-	struct adx_wdt *wdt = platform_get_drvdata(pdev);
-
-	misc_deregister(&adx_wdt_miscdev);
-	adx_wdt_stop(wdt);
-	platform_set_drvdata(pdev, NULL);
-
-	return 0;
-}
-
-static void adx_wdt_shutdown(struct platform_device *pdev)
-{
-	struct adx_wdt *wdt = platform_get_drvdata(pdev);
-	adx_wdt_stop(wdt);
-}
-
-#ifdef CONFIG_PM
-static int adx_wdt_suspend(struct device *dev)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct adx_wdt *wdt = platform_get_drvdata(pdev);
-
-	wdt->wake = (wdt->state == WDT_STATE_START) ? 1 : 0;
-	adx_wdt_stop(wdt);
-
-	return 0;
-}
-
-static int adx_wdt_resume(struct device *dev)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct adx_wdt *wdt = platform_get_drvdata(pdev);
-
-	if (wdt->wake)
-		adx_wdt_start(wdt);
-
-	return 0;
-}
-
-static const struct dev_pm_ops adx_wdt_pm_ops = {
-	.suspend = adx_wdt_suspend,
-	.resume = adx_wdt_resume,
-};
-
-#  define ADX_WDT_PM_OPS	(&adx_wdt_pm_ops)
-#else
-#  define ADX_WDT_PM_OPS	NULL
-#endif
-
-static struct platform_driver adx_wdt_driver = {
-	.probe = adx_wdt_probe,
-	.remove = __devexit_p(adx_wdt_remove),
-	.shutdown = adx_wdt_shutdown,
-	.driver = {
-		.name = WATCHDOG_NAME,
-		.owner = THIS_MODULE,
-		.pm = ADX_WDT_PM_OPS,
-	},
-};
-
-static int __init adx_wdt_init(void)
-{
-	return platform_driver_register(&adx_wdt_driver);
-}
-
-static void __exit adx_wdt_exit(void)
-{
-	platform_driver_unregister(&adx_wdt_driver);
-}
-
-module_init(adx_wdt_init);
-module_exit(adx_wdt_exit);
-
-MODULE_DESCRIPTION("Avionic Design Xanthos Watchdog Driver");
-MODULE_LICENSE("GPL v2");
-MODULE_AUTHOR("Thierry Reding <thierry.reding@avionic-design.de>");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index 5de7e4f..a79e384 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -401,8 +401,8 @@ static int __devinit s3c2410wdt_probe(struct platform_device *pdev)
 
 	dev_info(dev, "watchdog %sactive, reset %sabled, irq %sabled\n",
 		 (wtcon & S3C2410_WTCON_ENABLE) ?  "" : "in",
-		 (wtcon & S3C2410_WTCON_RSTEN) ? "" : "dis",
-		 (wtcon & S3C2410_WTCON_INTEN) ? "" : "en");
+		 (wtcon & S3C2410_WTCON_RSTEN) ? "en" : "dis",
+		 (wtcon & S3C2410_WTCON_INTEN) ? "en" : "dis");
 
 	return 0;
 
diff --git a/drivers/watchdog/wm831x_wdt.c b/drivers/watchdog/wm831x_wdt.c
index 7be3855..e789a47 100644
--- a/drivers/watchdog/wm831x_wdt.c
+++ b/drivers/watchdog/wm831x_wdt.c
@@ -150,7 +150,7 @@ static int wm831x_wdt_set_timeout(struct watchdog_device *wdt_dev,
 		if (wm831x_wdt_cfgs[i].time == timeout)
 			break;
 	if (i == ARRAY_SIZE(wm831x_wdt_cfgs))
-		ret = -EINVAL;
+		return -EINVAL;
 
 	ret = wm831x_reg_unlock(wm831x);
 	if (ret == 0) {
