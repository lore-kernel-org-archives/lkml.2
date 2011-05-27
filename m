Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620Ab1E0NkS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 09:40:18 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:62139 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754756Ab1E0NkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 09:40:09 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8EAPGn301tg2dL/2dsb2JhbAAtGg2mN3jFSg6DAQmDBgSfWg
Date: Fri, 27 May 2011 15:40:04 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Nat Gurumoorthy <natg@google.com>,
        Jonathan McDowell <noodles@earth.li>, Jamie Iles <jamie@jamieiles.com>,
        Jesper Juhl <jj@chaosbits.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Watchdog patches for v2.6.40-rc1
Message-ID: <20110527134004.GA17282@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

These are the patches that I will sent Linus on monday:

 drivers/watchdog/Kconfig              |    9 
 drivers/watchdog/Makefile             |    1 
 drivers/watchdog/dw_wdt.c             |  376 +++++++++++++++++++++++++++++++
 drivers/watchdog/iTCO_wdt.c           |  407 +++++++++++-----------------------
 drivers/watchdog/intel_scu_watchdog.c |    1 
 drivers/watchdog/it8712f_wdt.c        |   61 +++--
 drivers/watchdog/it87_wdt.c           |  168 +++++++-------
 drivers/watchdog/pc87413_wdt.c        |   96 ++++----
 8 files changed, 709 insertions(+), 410 deletions(-)

with these Changes:

Author: Jesper Juhl <jj@chaosbits.net>
Date:   Thu May 26 11:12:53 2011 +0200

    watchdog: Intel SCU Watchdog: Fix duplicate include
    
    linux/types.h is needlessly being included twice in
    drivers/watchdog/intel_scu_watchdog.c
    
    Signed-off-by: Jesper Juhl <jj@chaosbits.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Jamie Iles <jamie@jamieiles.com>
Date:   Mon Jan 24 12:19:12 2011 +0000

    watchdog: add support for the Synopsys DesignWare WDT
    
    The Synopsys DesignWare watchdog is found in several ARM based systems
    and provides a choice of 16 timeout periods depending on the clock
    input.  The watchdog cannot be disabled once started.
    
    Signed-off-by: Jamie Iles <jamie@jamieiles.com>
    Acked-by: Viresh Kumar <viresh.kumar@st.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Jonathan McDowell <noodles@earth.li>
Date:   Thu Apr 14 12:02:39 2011 -0700

    watchdog: pc87413_wdt: Cleanup pc87413 watchdog driver to use
    
    Inspired by Nat Gurumoorthy's recent patches for cleaning up the it87
    drivers to use request_muxed_region for accessing the SuperIO area on
    these chips, and the fact I have a GPIO driver for the pc8741x basically
    ready for submission, here is a patch to cleanup the pc87413 watchdog
    driver to use request_muxed_region for accessing the SuperIO area.
    
    It also pulls out the details about the SWC IO area on initial driver
    load, and properly does a request_region for that area - there's no
    requirement to touch the SuperIO area after doing the initial watchdog
    enable and IO base retrieval.
    
    While I have hardware with a pc87413 on it it is not wired in a way that
    allows the watchdog to reboot the machine, so I have not been able to
    fully test these changes - I have checked that the driver correctly
    initialises itself still and requests the SWC io region ok.
    
    Signed-Off-By: Jonathan McDowell <noodles@earth.li>
    Signed-Off-By: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Fri May 20 08:28:48 2011 +0000

    watchdog: iTCO_wdt: clean-up PCI device ID's
    
    Clean up of the iTCO_wdt PCI device ID's.
    Own macro is replaced by the PCI_VDEVICE macro.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Nat Gurumoorthy <natg@google.com>
Date:   Mon May 9 11:45:07 2011 -0700

    watchdog: Use "request_muxed_region" in it87 watchdog drivers
    
    Changes the it87 watchdog drivers to use "request_muxed_region".
    Serialize access to the hardware by using "request_muxed_region" macro defined
    by Alan Cox. Call to this macro will hold off the requestor if the resource is
    currently busy.
    
    The use of the above macro makes it possible to get rid of
    spinlocks in it8712f_wdt.c and it87_wdt.c watchdog drivers.
    This also greatly simplifies the implementation of it87_wdt.c driver.
    
     "superio_enter" will return an error if call to "request_muxed_region" fails.
    Rest of the code change is to ripple an error return from superio_enter to
    the top level.
    
    Signed-off-by: Nat Gurumoorthy <natg@google.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 022f9eb..ca8b6ba 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -186,6 +186,15 @@ config SA1100_WATCHDOG
 	  To compile this driver as a module, choose M here: the
 	  module will be called sa1100_wdt.
 
+config DW_WATCHDOG
+	tristate "Synopsys DesignWare watchdog"
+	depends on ARM && HAVE_CLK
+	help
+	  Say Y here if to include support for the Synopsys DesignWare
+	  watchdog timer found in many ARM chips.
+	  To compile this driver as a module, choose M here: the
+	  module will be called dw_wdt.
+
 config MPCORE_WATCHDOG
 	tristate "MPcore watchdog"
 	depends on HAVE_ARM_TWD
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index ed26f70..b2ddff7 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -37,6 +37,7 @@ obj-$(CONFIG_IXP4XX_WATCHDOG) += ixp4xx_wdt.o
 obj-$(CONFIG_KS8695_WATCHDOG) += ks8695_wdt.o
 obj-$(CONFIG_S3C2410_WATCHDOG) += s3c2410_wdt.o
 obj-$(CONFIG_SA1100_WATCHDOG) += sa1100_wdt.o
+obj-$(CONFIG_DW_WATCHDOG) += dw_wdt.o
 obj-$(CONFIG_MPCORE_WATCHDOG) += mpcore_wdt.o
 obj-$(CONFIG_EP93XX_WATCHDOG) += ep93xx_wdt.o
 obj-$(CONFIG_PNX4008_WATCHDOG) += pnx4008_wdt.o
diff --git a/drivers/watchdog/dw_wdt.c b/drivers/watchdog/dw_wdt.c
new file mode 100644
index 0000000..f10f8c0
--- /dev/null
+++ b/drivers/watchdog/dw_wdt.c
@@ -0,0 +1,376 @@
+/*
+ * Copyright 2010-2011 Picochip Ltd., Jamie Iles
+ * http://www.picochip.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ *
+ * This file implements a driver for the Synopsys DesignWare watchdog device
+ * in the many ARM subsystems. The watchdog has 16 different timeout periods
+ * and these are a function of the input clock frequency.
+ *
+ * The DesignWare watchdog cannot be stopped once it has been started so we
+ * use a software timer to implement a ping that will keep the watchdog alive.
+ * If we receive an expected close for the watchdog then we keep the timer
+ * running, otherwise the timer is stopped and the watchdog will expire.
+ */
+#define pr_fmt(fmt) "dw_wdt: " fmt
+
+#include <linux/bitops.h>
+#include <linux/clk.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/fs.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/pm.h>
+#include <linux/platform_device.h>
+#include <linux/spinlock.h>
+#include <linux/timer.h>
+#include <linux/uaccess.h>
+#include <linux/watchdog.h>
+
+#define WDOG_CONTROL_REG_OFFSET		    0x00
+#define WDOG_CONTROL_REG_WDT_EN_MASK	    0x01
+#define WDOG_TIMEOUT_RANGE_REG_OFFSET	    0x04
+#define WDOG_CURRENT_COUNT_REG_OFFSET	    0x08
+#define WDOG_COUNTER_RESTART_REG_OFFSET     0x0c
+#define WDOG_COUNTER_RESTART_KICK_VALUE	    0x76
+
+/* The maximum TOP (timeout period) value that can be set in the watchdog. */
+#define DW_WDT_MAX_TOP		15
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started "
+		 "(default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+#define WDT_TIMEOUT		(HZ / 2)
+
+static struct {
+	spinlock_t		lock;
+	void __iomem		*regs;
+	struct clk		*clk;
+	unsigned long		in_use;
+	unsigned long		next_heartbeat;
+	struct timer_list	timer;
+	int			expect_close;
+} dw_wdt;
+
+static inline int dw_wdt_is_enabled(void)
+{
+	return readl(dw_wdt.regs + WDOG_CONTROL_REG_OFFSET) &
+		WDOG_CONTROL_REG_WDT_EN_MASK;
+}
+
+static inline int dw_wdt_top_in_seconds(unsigned top)
+{
+	/*
+	 * There are 16 possible timeout values in 0..15 where the number of
+	 * cycles is 2 ^ (16 + i) and the watchdog counts down.
+	 */
+	return (1 << (16 + top)) / clk_get_rate(dw_wdt.clk);
+}
+
+static int dw_wdt_get_top(void)
+{
+	int top = readl(dw_wdt.regs + WDOG_TIMEOUT_RANGE_REG_OFFSET) & 0xF;
+
+	return dw_wdt_top_in_seconds(top);
+}
+
+static inline void dw_wdt_set_next_heartbeat(void)
+{
+	dw_wdt.next_heartbeat = jiffies + dw_wdt_get_top() * HZ;
+}
+
+static int dw_wdt_set_top(unsigned top_s)
+{
+	int i, top_val = DW_WDT_MAX_TOP;
+
+	/*
+	 * Iterate over the timeout values until we find the closest match. We
+	 * always look for >=.
+	 */
+	for (i = 0; i <= DW_WDT_MAX_TOP; ++i)
+		if (dw_wdt_top_in_seconds(i) >= top_s) {
+			top_val = i;
+			break;
+		}
+
+	/* Set the new value in the watchdog. */
+	writel(top_val, dw_wdt.regs + WDOG_TIMEOUT_RANGE_REG_OFFSET);
+
+	dw_wdt_set_next_heartbeat();
+
+	return dw_wdt_top_in_seconds(top_val);
+}
+
+static void dw_wdt_keepalive(void)
+{
+	writel(WDOG_COUNTER_RESTART_KICK_VALUE, dw_wdt.regs +
+	       WDOG_COUNTER_RESTART_REG_OFFSET);
+}
+
+static void dw_wdt_ping(unsigned long data)
+{
+	if (time_before(jiffies, dw_wdt.next_heartbeat) ||
+	    (!nowayout && !dw_wdt.in_use)) {
+		dw_wdt_keepalive();
+		mod_timer(&dw_wdt.timer, jiffies + WDT_TIMEOUT);
+	} else
+		pr_crit("keepalive missed, machine will reset\n");
+}
+
+static int dw_wdt_open(struct inode *inode, struct file *filp)
+{
+	if (test_and_set_bit(0, &dw_wdt.in_use))
+		return -EBUSY;
+
+	/* Make sure we don't get unloaded. */
+	__module_get(THIS_MODULE);
+
+	spin_lock(&dw_wdt.lock);
+	if (!dw_wdt_is_enabled()) {
+		/*
+		 * The watchdog is not currently enabled. Set the timeout to
+		 * the maximum and then start it.
+		 */
+		dw_wdt_set_top(DW_WDT_MAX_TOP);
+		writel(WDOG_CONTROL_REG_WDT_EN_MASK,
+		       dw_wdt.regs + WDOG_CONTROL_REG_OFFSET);
+	}
+
+	dw_wdt_set_next_heartbeat();
+
+	spin_unlock(&dw_wdt.lock);
+
+	return nonseekable_open(inode, filp);
+}
+
+ssize_t dw_wdt_write(struct file *filp, const char __user *buf, size_t len,
+		     loff_t *offset)
+{
+	if (!len)
+		return 0;
+
+	if (!nowayout) {
+		size_t i;
+
+		dw_wdt.expect_close = 0;
+
+		for (i = 0; i < len; ++i) {
+			char c;
+
+			if (get_user(c, buf + i))
+				return -EFAULT;
+
+			if (c == 'V') {
+				dw_wdt.expect_close = 1;
+				break;
+			}
+		}
+	}
+
+	dw_wdt_set_next_heartbeat();
+	mod_timer(&dw_wdt.timer, jiffies + WDT_TIMEOUT);
+
+	return len;
+}
+
+static u32 dw_wdt_time_left(void)
+{
+	return readl(dw_wdt.regs + WDOG_CURRENT_COUNT_REG_OFFSET) /
+		clk_get_rate(dw_wdt.clk);
+}
+
+static const struct watchdog_info dw_wdt_ident = {
+	.options	= WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT |
+			  WDIOF_MAGICCLOSE,
+	.identity	= "Synopsys DesignWare Watchdog",
+};
+
+static long dw_wdt_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	unsigned long val;
+	int timeout;
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user((struct watchdog_info *)arg, &dw_wdt_ident,
+				    sizeof(dw_wdt_ident)) ? -EFAULT : 0;
+
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, (int *)arg);
+
+	case WDIOC_KEEPALIVE:
+		dw_wdt_set_next_heartbeat();
+		return 0;
+
+	case WDIOC_SETTIMEOUT:
+		if (get_user(val, (int __user *)arg))
+			return -EFAULT;
+		timeout = dw_wdt_set_top(val);
+		return put_user(timeout , (int __user *)arg);
+
+	case WDIOC_GETTIMEOUT:
+		return put_user(dw_wdt_get_top(), (int __user *)arg);
+
+	case WDIOC_GETTIMELEFT:
+		/* Get the time left until expiry. */
+		if (get_user(val, (int __user *)arg))
+			return -EFAULT;
+		return put_user(dw_wdt_time_left(), (int __user *)arg);
+
+	default:
+		return -ENOTTY;
+	}
+}
+
+static int dw_wdt_release(struct inode *inode, struct file *filp)
+{
+	clear_bit(0, &dw_wdt.in_use);
+
+	if (!dw_wdt.expect_close) {
+		del_timer(&dw_wdt.timer);
+
+		if (!nowayout)
+			pr_crit("unexpected close, system will reboot soon\n");
+		else
+			pr_crit("watchdog cannot be disabled, system will reboot soon\n");
+	}
+
+	dw_wdt.expect_close = 0;
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int dw_wdt_suspend(struct device *dev)
+{
+	clk_disable(dw_wdt.clk);
+
+	return 0;
+}
+
+static int dw_wdt_resume(struct device *dev)
+{
+	int err = clk_enable(dw_wdt.clk);
+
+	if (err)
+		return err;
+
+	dw_wdt_keepalive();
+
+	return 0;
+}
+
+static const struct dev_pm_ops dw_wdt_pm_ops = {
+	.suspend	= dw_wdt_suspend,
+	.resume		= dw_wdt_resume,
+};
+#endif /* CONFIG_PM */
+
+static const struct file_operations wdt_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.open		= dw_wdt_open,
+	.write		= dw_wdt_write,
+	.unlocked_ioctl	= dw_wdt_ioctl,
+	.release	= dw_wdt_release
+};
+
+static struct miscdevice dw_wdt_miscdev = {
+	.fops		= &wdt_fops,
+	.name		= "watchdog",
+	.minor		= WATCHDOG_MINOR,
+};
+
+static int __devinit dw_wdt_drv_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct resource *mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
+	if (!mem)
+		return -EINVAL;
+
+	if (!devm_request_mem_region(&pdev->dev, mem->start, resource_size(mem),
+				     "dw_wdt"))
+		return -ENOMEM;
+
+	dw_wdt.regs = devm_ioremap(&pdev->dev, mem->start, resource_size(mem));
+	if (!dw_wdt.regs)
+		return -ENOMEM;
+
+	dw_wdt.clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(dw_wdt.clk))
+		return PTR_ERR(dw_wdt.clk);
+
+	ret = clk_enable(dw_wdt.clk);
+	if (ret)
+		goto out_put_clk;
+
+	spin_lock_init(&dw_wdt.lock);
+
+	ret = misc_register(&dw_wdt_miscdev);
+	if (ret)
+		goto out_disable_clk;
+
+	dw_wdt_set_next_heartbeat();
+	setup_timer(&dw_wdt.timer, dw_wdt_ping, 0);
+	mod_timer(&dw_wdt.timer, jiffies + WDT_TIMEOUT);
+
+	return 0;
+
+out_disable_clk:
+	clk_disable(dw_wdt.clk);
+out_put_clk:
+	clk_put(dw_wdt.clk);
+
+	return ret;
+}
+
+static int __devexit dw_wdt_drv_remove(struct platform_device *pdev)
+{
+	misc_deregister(&dw_wdt_miscdev);
+
+	clk_disable(dw_wdt.clk);
+	clk_put(dw_wdt.clk);
+
+	return 0;
+}
+
+static struct platform_driver dw_wdt_driver = {
+	.probe		= dw_wdt_drv_probe,
+	.remove		= __devexit_p(dw_wdt_drv_remove),
+	.driver		= {
+		.name	= "dw_wdt",
+		.owner	= THIS_MODULE,
+#ifdef CONFIG_PM
+		.pm	= &dw_wdt_pm_ops,
+#endif /* CONFIG_PM */
+	},
+};
+
+static int __init dw_wdt_watchdog_init(void)
+{
+	return platform_driver_register(&dw_wdt_driver);
+}
+module_init(dw_wdt_watchdog_init);
+
+static void __exit dw_wdt_watchdog_exit(void)
+{
+	platform_driver_unregister(&dw_wdt_driver);
+}
+module_exit(dw_wdt_watchdog_exit);
+
+MODULE_AUTHOR("Jamie Iles");
+MODULE_DESCRIPTION("Synopsys DesignWare Watchdog Driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index 5fd020d..1190bf1 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -120,72 +120,12 @@ enum iTCO_chipsets {
 	TCO_3420,	/* 3420 */
 	TCO_3450,	/* 3450 */
 	TCO_EP80579,	/* EP80579 */
-	TCO_CPT1,	/* Cougar Point */
-	TCO_CPT2,	/* Cougar Point Desktop */
-	TCO_CPT3,	/* Cougar Point Mobile */
-	TCO_CPT4,	/* Cougar Point */
-	TCO_CPT5,	/* Cougar Point */
-	TCO_CPT6,	/* Cougar Point */
-	TCO_CPT7,	/* Cougar Point */
-	TCO_CPT8,	/* Cougar Point */
-	TCO_CPT9,	/* Cougar Point */
-	TCO_CPT10,	/* Cougar Point */
-	TCO_CPT11,	/* Cougar Point */
-	TCO_CPT12,	/* Cougar Point */
-	TCO_CPT13,	/* Cougar Point */
-	TCO_CPT14,	/* Cougar Point */
-	TCO_CPT15,	/* Cougar Point */
-	TCO_CPT16,	/* Cougar Point */
-	TCO_CPT17,	/* Cougar Point */
-	TCO_CPT18,	/* Cougar Point */
-	TCO_CPT19,	/* Cougar Point */
-	TCO_CPT20,	/* Cougar Point */
-	TCO_CPT21,	/* Cougar Point */
-	TCO_CPT22,	/* Cougar Point */
-	TCO_CPT23,	/* Cougar Point */
-	TCO_CPT24,	/* Cougar Point */
-	TCO_CPT25,	/* Cougar Point */
-	TCO_CPT26,	/* Cougar Point */
-	TCO_CPT27,	/* Cougar Point */
-	TCO_CPT28,	/* Cougar Point */
-	TCO_CPT29,	/* Cougar Point */
-	TCO_CPT30,	/* Cougar Point */
-	TCO_CPT31,	/* Cougar Point */
-	TCO_PBG1,	/* Patsburg */
-	TCO_PBG2,	/* Patsburg */
+	TCO_CPT,	/* Cougar Point */
+	TCO_CPTD,	/* Cougar Point Desktop */
+	TCO_CPTM,	/* Cougar Point Mobile */
+	TCO_PBG,	/* Patsburg */
 	TCO_DH89XXCC,	/* DH89xxCC */
-	TCO_PPT0,	/* Panther Point */
-	TCO_PPT1,	/* Panther Point */
-	TCO_PPT2,	/* Panther Point */
-	TCO_PPT3,	/* Panther Point */
-	TCO_PPT4,	/* Panther Point */
-	TCO_PPT5,	/* Panther Point */
-	TCO_PPT6,	/* Panther Point */
-	TCO_PPT7,	/* Panther Point */
-	TCO_PPT8,	/* Panther Point */
-	TCO_PPT9,	/* Panther Point */
-	TCO_PPT10,	/* Panther Point */
-	TCO_PPT11,	/* Panther Point */
-	TCO_PPT12,	/* Panther Point */
-	TCO_PPT13,	/* Panther Point */
-	TCO_PPT14,	/* Panther Point */
-	TCO_PPT15,	/* Panther Point */
-	TCO_PPT16,	/* Panther Point */
-	TCO_PPT17,	/* Panther Point */
-	TCO_PPT18,	/* Panther Point */
-	TCO_PPT19,	/* Panther Point */
-	TCO_PPT20,	/* Panther Point */
-	TCO_PPT21,	/* Panther Point */
-	TCO_PPT22,	/* Panther Point */
-	TCO_PPT23,	/* Panther Point */
-	TCO_PPT24,	/* Panther Point */
-	TCO_PPT25,	/* Panther Point */
-	TCO_PPT26,	/* Panther Point */
-	TCO_PPT27,	/* Panther Point */
-	TCO_PPT28,	/* Panther Point */
-	TCO_PPT29,	/* Panther Point */
-	TCO_PPT30,	/* Panther Point */
-	TCO_PPT31,	/* Panther Point */
+	TCO_PPT,	/* Panther Point */
 };
 
 static struct {
@@ -244,83 +184,14 @@ static struct {
 	{"3450", 2},
 	{"EP80579", 2},
 	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Patsburg", 2},
+	{"Cougar Point Desktop", 2},
+	{"Cougar Point Mobile", 2},
 	{"Patsburg", 2},
 	{"DH89xxCC", 2},
 	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
 	{NULL, 0}
 };
 
-#define ITCO_PCI_DEVICE(dev, data) \
-	.vendor = PCI_VENDOR_ID_INTEL,	\
-	.device = dev,			\
-	.subvendor = PCI_ANY_ID,	\
-	.subdevice = PCI_ANY_ID,	\
-	.class = 0,			\
-	.class_mask = 0,		\
-	.driver_data = data
-
 /*
  * This data only exists for exporting the supported PCI ids
  * via MODULE_DEVICE_TABLE.  We do not actually register a
@@ -328,138 +199,138 @@ static struct {
  * functions that probably will be registered by other drivers.
  */
 static DEFINE_PCI_DEVICE_TABLE(iTCO_wdt_pci_tbl) = {
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801AA_0,	TCO_ICH)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801AB_0,	TCO_ICH0)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801BA_0,	TCO_ICH2)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801BA_10,	TCO_ICH2M)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801CA_0,	TCO_ICH3)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801CA_12,	TCO_ICH3M)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801DB_0,	TCO_ICH4)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801DB_12,	TCO_ICH4M)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801E_0,		TCO_CICH)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801EB_0,	TCO_ICH5)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ESB_1,		TCO_6300ESB)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH6_0,		TCO_ICH6)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH6_1,		TCO_ICH6M)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH6_2,		TCO_ICH6W)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ESB2_0,		TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x2671,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x2672,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x2673,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x2674,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x2675,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x2676,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x2677,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x2678,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x2679,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x267a,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x267b,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x267c,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x267d,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x267e,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x267f,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH7_0,		TCO_ICH7)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH7_30,		TCO_ICH7DH)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH7_1,		TCO_ICH7M)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH7_31,		TCO_ICH7MDH)},
-	{ ITCO_PCI_DEVICE(0x27bc,				TCO_NM10)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_0,		TCO_ICH8)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_2,		TCO_ICH8DH)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_3,		TCO_ICH8DO)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_4,		TCO_ICH8M)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_1,		TCO_ICH8ME)},
-	{ ITCO_PCI_DEVICE(0x2918,				TCO_ICH9)},
-	{ ITCO_PCI_DEVICE(0x2916,				TCO_ICH9R)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH9_2,		TCO_ICH9DH)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH9_4,		TCO_ICH9DO)},
-	{ ITCO_PCI_DEVICE(0x2919,				TCO_ICH9M)},
-	{ ITCO_PCI_DEVICE(0x2917,				TCO_ICH9ME)},
-	{ ITCO_PCI_DEVICE(0x3a18,				TCO_ICH10)},
-	{ ITCO_PCI_DEVICE(0x3a16,				TCO_ICH10R)},
-	{ ITCO_PCI_DEVICE(0x3a1a,				TCO_ICH10D)},
-	{ ITCO_PCI_DEVICE(0x3a14,				TCO_ICH10DO)},
-	{ ITCO_PCI_DEVICE(0x3b00,				TCO_PCH)},
-	{ ITCO_PCI_DEVICE(0x3b01,				TCO_PCHM)},
-	{ ITCO_PCI_DEVICE(0x3b02,				TCO_P55)},
-	{ ITCO_PCI_DEVICE(0x3b03,				TCO_PM55)},
-	{ ITCO_PCI_DEVICE(0x3b06,				TCO_H55)},
-	{ ITCO_PCI_DEVICE(0x3b07,				TCO_QM57)},
-	{ ITCO_PCI_DEVICE(0x3b08,				TCO_H57)},
-	{ ITCO_PCI_DEVICE(0x3b09,				TCO_HM55)},
-	{ ITCO_PCI_DEVICE(0x3b0a,				TCO_Q57)},
-	{ ITCO_PCI_DEVICE(0x3b0b,				TCO_HM57)},
-	{ ITCO_PCI_DEVICE(0x3b0d,				TCO_PCHMSFF)},
-	{ ITCO_PCI_DEVICE(0x3b0f,				TCO_QS57)},
-	{ ITCO_PCI_DEVICE(0x3b12,				TCO_3400)},
-	{ ITCO_PCI_DEVICE(0x3b14,				TCO_3420)},
-	{ ITCO_PCI_DEVICE(0x3b16,				TCO_3450)},
-	{ ITCO_PCI_DEVICE(0x5031,				TCO_EP80579)},
-	{ ITCO_PCI_DEVICE(0x1c41,				TCO_CPT1)},
-	{ ITCO_PCI_DEVICE(0x1c42,				TCO_CPT2)},
-	{ ITCO_PCI_DEVICE(0x1c43,				TCO_CPT3)},
-	{ ITCO_PCI_DEVICE(0x1c44,				TCO_CPT4)},
-	{ ITCO_PCI_DEVICE(0x1c45,				TCO_CPT5)},
-	{ ITCO_PCI_DEVICE(0x1c46,				TCO_CPT6)},
-	{ ITCO_PCI_DEVICE(0x1c47,				TCO_CPT7)},
-	{ ITCO_PCI_DEVICE(0x1c48,				TCO_CPT8)},
-	{ ITCO_PCI_DEVICE(0x1c49,				TCO_CPT9)},
-	{ ITCO_PCI_DEVICE(0x1c4a,				TCO_CPT10)},
-	{ ITCO_PCI_DEVICE(0x1c4b,				TCO_CPT11)},
-	{ ITCO_PCI_DEVICE(0x1c4c,				TCO_CPT12)},
-	{ ITCO_PCI_DEVICE(0x1c4d,				TCO_CPT13)},
-	{ ITCO_PCI_DEVICE(0x1c4e,				TCO_CPT14)},
-	{ ITCO_PCI_DEVICE(0x1c4f,				TCO_CPT15)},
-	{ ITCO_PCI_DEVICE(0x1c50,				TCO_CPT16)},
-	{ ITCO_PCI_DEVICE(0x1c51,				TCO_CPT17)},
-	{ ITCO_PCI_DEVICE(0x1c52,				TCO_CPT18)},
-	{ ITCO_PCI_DEVICE(0x1c53,				TCO_CPT19)},
-	{ ITCO_PCI_DEVICE(0x1c54,				TCO_CPT20)},
-	{ ITCO_PCI_DEVICE(0x1c55,				TCO_CPT21)},
-	{ ITCO_PCI_DEVICE(0x1c56,				TCO_CPT22)},
-	{ ITCO_PCI_DEVICE(0x1c57,				TCO_CPT23)},
-	{ ITCO_PCI_DEVICE(0x1c58,				TCO_CPT24)},
-	{ ITCO_PCI_DEVICE(0x1c59,				TCO_CPT25)},
-	{ ITCO_PCI_DEVICE(0x1c5a,				TCO_CPT26)},
-	{ ITCO_PCI_DEVICE(0x1c5b,				TCO_CPT27)},
-	{ ITCO_PCI_DEVICE(0x1c5c,				TCO_CPT28)},
-	{ ITCO_PCI_DEVICE(0x1c5d,				TCO_CPT29)},
-	{ ITCO_PCI_DEVICE(0x1c5e,				TCO_CPT30)},
-	{ ITCO_PCI_DEVICE(0x1c5f,				TCO_CPT31)},
-	{ ITCO_PCI_DEVICE(0x1d40,				TCO_PBG1)},
-	{ ITCO_PCI_DEVICE(0x1d41,				TCO_PBG2)},
-	{ ITCO_PCI_DEVICE(0x2310,				TCO_DH89XXCC)},
-	{ ITCO_PCI_DEVICE(0x1e40,				TCO_PPT0)},
-	{ ITCO_PCI_DEVICE(0x1e41,				TCO_PPT1)},
-	{ ITCO_PCI_DEVICE(0x1e42,				TCO_PPT2)},
-	{ ITCO_PCI_DEVICE(0x1e43,				TCO_PPT3)},
-	{ ITCO_PCI_DEVICE(0x1e44,				TCO_PPT4)},
-	{ ITCO_PCI_DEVICE(0x1e45,				TCO_PPT5)},
-	{ ITCO_PCI_DEVICE(0x1e46,				TCO_PPT6)},
-	{ ITCO_PCI_DEVICE(0x1e47,				TCO_PPT7)},
-	{ ITCO_PCI_DEVICE(0x1e48,				TCO_PPT8)},
-	{ ITCO_PCI_DEVICE(0x1e49,				TCO_PPT9)},
-	{ ITCO_PCI_DEVICE(0x1e4a,				TCO_PPT10)},
-	{ ITCO_PCI_DEVICE(0x1e4b,				TCO_PPT11)},
-	{ ITCO_PCI_DEVICE(0x1e4c,				TCO_PPT12)},
-	{ ITCO_PCI_DEVICE(0x1e4d,				TCO_PPT13)},
-	{ ITCO_PCI_DEVICE(0x1e4e,				TCO_PPT14)},
-	{ ITCO_PCI_DEVICE(0x1e4f,				TCO_PPT15)},
-	{ ITCO_PCI_DEVICE(0x1e50,				TCO_PPT16)},
-	{ ITCO_PCI_DEVICE(0x1e51,				TCO_PPT17)},
-	{ ITCO_PCI_DEVICE(0x1e52,				TCO_PPT18)},
-	{ ITCO_PCI_DEVICE(0x1e53,				TCO_PPT19)},
-	{ ITCO_PCI_DEVICE(0x1e54,				TCO_PPT20)},
-	{ ITCO_PCI_DEVICE(0x1e55,				TCO_PPT21)},
-	{ ITCO_PCI_DEVICE(0x1e56,				TCO_PPT22)},
-	{ ITCO_PCI_DEVICE(0x1e57,				TCO_PPT23)},
-	{ ITCO_PCI_DEVICE(0x1e58,				TCO_PPT24)},
-	{ ITCO_PCI_DEVICE(0x1e59,				TCO_PPT25)},
-	{ ITCO_PCI_DEVICE(0x1e5a,				TCO_PPT26)},
-	{ ITCO_PCI_DEVICE(0x1e5b,				TCO_PPT27)},
-	{ ITCO_PCI_DEVICE(0x1e5c,				TCO_PPT28)},
-	{ ITCO_PCI_DEVICE(0x1e5d,				TCO_PPT29)},
-	{ ITCO_PCI_DEVICE(0x1e5e,				TCO_PPT30)},
-	{ ITCO_PCI_DEVICE(0x1e5f,				TCO_PPT31)},
+	{ PCI_VDEVICE(INTEL, 0x2410), TCO_ICH},
+	{ PCI_VDEVICE(INTEL, 0x2420), TCO_ICH0},
+	{ PCI_VDEVICE(INTEL, 0x2440), TCO_ICH2},
+	{ PCI_VDEVICE(INTEL, 0x244c), TCO_ICH2M},
+	{ PCI_VDEVICE(INTEL, 0x2480), TCO_ICH3},
+	{ PCI_VDEVICE(INTEL, 0x248c), TCO_ICH3M},
+	{ PCI_VDEVICE(INTEL, 0x24c0), TCO_ICH4},
+	{ PCI_VDEVICE(INTEL, 0x24cc), TCO_ICH4M},
+	{ PCI_VDEVICE(INTEL, 0x2450), TCO_CICH},
+	{ PCI_VDEVICE(INTEL, 0x24d0), TCO_ICH5},
+	{ PCI_VDEVICE(INTEL, 0x25a1), TCO_6300ESB},
+	{ PCI_VDEVICE(INTEL, 0x2640), TCO_ICH6},
+	{ PCI_VDEVICE(INTEL, 0x2641), TCO_ICH6M},
+	{ PCI_VDEVICE(INTEL, 0x2642), TCO_ICH6W},
+	{ PCI_VDEVICE(INTEL, 0x2670), TCO_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x2671), TCO_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x2672), TCO_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x2673), TCO_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x2674), TCO_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x2675), TCO_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x2676), TCO_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x2677), TCO_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x2678), TCO_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x2679), TCO_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x267a), TCO_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x267b), TCO_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x267c), TCO_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x267d), TCO_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x267e), TCO_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x267f), TCO_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x27b8), TCO_ICH7},
+	{ PCI_VDEVICE(INTEL, 0x27b0), TCO_ICH7DH},
+	{ PCI_VDEVICE(INTEL, 0x27b9), TCO_ICH7M},
+	{ PCI_VDEVICE(INTEL, 0x27bd), TCO_ICH7MDH},
+	{ PCI_VDEVICE(INTEL, 0x27bc), TCO_NM10},
+	{ PCI_VDEVICE(INTEL, 0x2810), TCO_ICH8},
+	{ PCI_VDEVICE(INTEL, 0x2812), TCO_ICH8DH},
+	{ PCI_VDEVICE(INTEL, 0x2814), TCO_ICH8DO},
+	{ PCI_VDEVICE(INTEL, 0x2815), TCO_ICH8M},
+	{ PCI_VDEVICE(INTEL, 0x2811), TCO_ICH8ME},
+	{ PCI_VDEVICE(INTEL, 0x2918), TCO_ICH9},
+	{ PCI_VDEVICE(INTEL, 0x2916), TCO_ICH9R},
+	{ PCI_VDEVICE(INTEL, 0x2912), TCO_ICH9DH},
+	{ PCI_VDEVICE(INTEL, 0x2914), TCO_ICH9DO},
+	{ PCI_VDEVICE(INTEL, 0x2919), TCO_ICH9M},
+	{ PCI_VDEVICE(INTEL, 0x2917), TCO_ICH9ME},
+	{ PCI_VDEVICE(INTEL, 0x3a18), TCO_ICH10},
+	{ PCI_VDEVICE(INTEL, 0x3a16), TCO_ICH10R},
+	{ PCI_VDEVICE(INTEL, 0x3a1a), TCO_ICH10D},
+	{ PCI_VDEVICE(INTEL, 0x3a14), TCO_ICH10DO},
+	{ PCI_VDEVICE(INTEL, 0x3b00), TCO_PCH},
+	{ PCI_VDEVICE(INTEL, 0x3b01), TCO_PCHM},
+	{ PCI_VDEVICE(INTEL, 0x3b02), TCO_P55},
+	{ PCI_VDEVICE(INTEL, 0x3b03), TCO_PM55},
+	{ PCI_VDEVICE(INTEL, 0x3b06), TCO_H55},
+	{ PCI_VDEVICE(INTEL, 0x3b07), TCO_QM57},
+	{ PCI_VDEVICE(INTEL, 0x3b08), TCO_H57},
+	{ PCI_VDEVICE(INTEL, 0x3b09), TCO_HM55},
+	{ PCI_VDEVICE(INTEL, 0x3b0a), TCO_Q57},
+	{ PCI_VDEVICE(INTEL, 0x3b0b), TCO_HM57},
+	{ PCI_VDEVICE(INTEL, 0x3b0d), TCO_PCHMSFF},
+	{ PCI_VDEVICE(INTEL, 0x3b0f), TCO_QS57},
+	{ PCI_VDEVICE(INTEL, 0x3b12), TCO_3400},
+	{ PCI_VDEVICE(INTEL, 0x3b14), TCO_3420},
+	{ PCI_VDEVICE(INTEL, 0x3b16), TCO_3450},
+	{ PCI_VDEVICE(INTEL, 0x5031), TCO_EP80579},
+	{ PCI_VDEVICE(INTEL, 0x1c41), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c42), TCO_CPTD},
+	{ PCI_VDEVICE(INTEL, 0x1c43), TCO_CPTM},
+	{ PCI_VDEVICE(INTEL, 0x1c44), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c45), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c46), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c47), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c48), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c49), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c4a), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c4b), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c4c), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c4d), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c4e), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c4f), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c50), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c51), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c52), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c53), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c54), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c55), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c56), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c57), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c58), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c59), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c5a), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c5b), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c5c), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c5d), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c5e), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c5f), TCO_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1d40), TCO_PBG},
+	{ PCI_VDEVICE(INTEL, 0x1d41), TCO_PBG},
+	{ PCI_VDEVICE(INTEL, 0x2310), TCO_DH89XXCC},
+	{ PCI_VDEVICE(INTEL, 0x1e40), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e41), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e42), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e43), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e44), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e45), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e46), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e47), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e48), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e49), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e4a), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e4b), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e4c), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e4d), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e4e), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e4f), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e50), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e51), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e52), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e53), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e54), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e55), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e56), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e57), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e58), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e59), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e5a), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e5b), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e5c), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e5d), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e5e), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e5f), TCO_PPT},
 	{ 0, },			/* End of list */
 };
 MODULE_DEVICE_TABLE(pci, iTCO_wdt_pci_tbl);
diff --git a/drivers/watchdog/intel_scu_watchdog.c b/drivers/watchdog/intel_scu_watchdog.c
index 919bdd1..ba43860 100644
--- a/drivers/watchdog/intel_scu_watchdog.c
+++ b/drivers/watchdog/intel_scu_watchdog.c
@@ -42,7 +42,6 @@
 #include <linux/sched.h>
 #include <linux/signal.h>
 #include <linux/sfi.h>
-#include <linux/types.h>
 #include <asm/irq.h>
 #include <asm/atomic.h>
 #include <asm/intel_scu_ipc.h>
diff --git a/drivers/watchdog/it8712f_wdt.c b/drivers/watchdog/it8712f_wdt.c
index 6143f52..6901449 100644
--- a/drivers/watchdog/it8712f_wdt.c
+++ b/drivers/watchdog/it8712f_wdt.c
@@ -51,7 +51,6 @@ MODULE_PARM_DESC(nowayout, "Disable watchdog shutdown on close");
 
 static unsigned long wdt_open;
 static unsigned expect_close;
-static spinlock_t io_lock;
 static unsigned char revision;
 
 /* Dog Food address - We use the game port address */
@@ -121,20 +120,26 @@ static inline void superio_select(int ldn)
 	outb(ldn, VAL);
 }
 
-static inline void superio_enter(void)
+static inline int superio_enter(void)
 {
-	spin_lock(&io_lock);
+	/*
+	 * Try to reserve REG and REG + 1 for exclusive access.
+	 */
+	if (!request_muxed_region(REG, 2, NAME))
+		return -EBUSY;
+
 	outb(0x87, REG);
 	outb(0x01, REG);
 	outb(0x55, REG);
 	outb(0x55, REG);
+	return 0;
 }
 
 static inline void superio_exit(void)
 {
 	outb(0x02, REG);
 	outb(0x02, VAL);
-	spin_unlock(&io_lock);
+	release_region(REG, 2);
 }
 
 static inline void it8712f_wdt_ping(void)
@@ -173,10 +178,13 @@ static int it8712f_wdt_get_status(void)
 		return 0;
 }
 
-static void it8712f_wdt_enable(void)
+static int it8712f_wdt_enable(void)
 {
+	int ret = superio_enter();
+	if (ret)
+		return ret;
+
 	printk(KERN_DEBUG NAME ": enabling watchdog timer\n");
-	superio_enter();
 	superio_select(LDN_GPIO);
 
 	superio_outb(wdt_control_reg, WDT_CONTROL);
@@ -186,13 +194,17 @@ static void it8712f_wdt_enable(void)
 	superio_exit();
 
 	it8712f_wdt_ping();
+
+	return 0;
 }
 
-static void it8712f_wdt_disable(void)
+static int it8712f_wdt_disable(void)
 {
-	printk(KERN_DEBUG NAME ": disabling watchdog timer\n");
+	int ret = superio_enter();
+	if (ret)
+		return ret;
 
-	superio_enter();
+	printk(KERN_DEBUG NAME ": disabling watchdog timer\n");
 	superio_select(LDN_GPIO);
 
 	superio_outb(0, WDT_CONFIG);
@@ -202,6 +214,7 @@ static void it8712f_wdt_disable(void)
 	superio_outb(0, WDT_TIMEOUT);
 
 	superio_exit();
+	return 0;
 }
 
 static int it8712f_wdt_notify(struct notifier_block *this,
@@ -252,6 +265,7 @@ static long it8712f_wdt_ioctl(struct file *file, unsigned int cmd,
 						WDIOF_MAGICCLOSE,
 	};
 	int value;
+	int ret;
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
@@ -259,7 +273,9 @@ static long it8712f_wdt_ioctl(struct file *file, unsigned int cmd,
 			return -EFAULT;
 		return 0;
 	case WDIOC_GETSTATUS:
-		superio_enter();
+		ret = superio_enter();
+		if (ret)
+			return ret;
 		superio_select(LDN_GPIO);
 
 		value = it8712f_wdt_get_status();
@@ -280,7 +296,9 @@ static long it8712f_wdt_ioctl(struct file *file, unsigned int cmd,
 		if (value > (max_units * 60))
 			return -EINVAL;
 		margin = value;
-		superio_enter();
+		ret = superio_enter();
+		if (ret)
+			return ret;
 		superio_select(LDN_GPIO);
 
 		it8712f_wdt_update_margin();
@@ -299,10 +317,14 @@ static long it8712f_wdt_ioctl(struct file *file, unsigned int cmd,
 
 static int it8712f_wdt_open(struct inode *inode, struct file *file)
 {
+	int ret;
 	/* only allow one at a time */
 	if (test_and_set_bit(0, &wdt_open))
 		return -EBUSY;
-	it8712f_wdt_enable();
+
+	ret = it8712f_wdt_enable();
+	if (ret)
+		return ret;
 	return nonseekable_open(inode, file);
 }
 
@@ -313,7 +335,8 @@ static int it8712f_wdt_release(struct inode *inode, struct file *file)
 			": watchdog device closed unexpectedly, will not"
 			" disable the watchdog timer\n");
 	} else if (!nowayout) {
-		it8712f_wdt_disable();
+		if (it8712f_wdt_disable())
+			printk(KERN_WARNING NAME "Watchdog disable failed\n");
 	}
 	expect_close = 0;
 	clear_bit(0, &wdt_open);
@@ -340,8 +363,10 @@ static int __init it8712f_wdt_find(unsigned short *address)
 {
 	int err = -ENODEV;
 	int chip_type;
+	int ret = superio_enter();
+	if (ret)
+		return ret;
 
-	superio_enter();
 	chip_type = superio_inw(DEVID);
 	if (chip_type != IT8712F_DEVID)
 		goto exit;
@@ -382,8 +407,6 @@ static int __init it8712f_wdt_init(void)
 {
 	int err = 0;
 
-	spin_lock_init(&io_lock);
-
 	if (it8712f_wdt_find(&address))
 		return -ENODEV;
 
@@ -392,7 +415,11 @@ static int __init it8712f_wdt_init(void)
 		return -EBUSY;
 	}
 
-	it8712f_wdt_disable();
+	err = it8712f_wdt_disable();
+	if (err) {
+		printk(KERN_ERR NAME ": unable to disable watchdog timer.\n");
+		goto out;
+	}
 
 	err = register_reboot_notifier(&it8712f_wdt_notifier);
 	if (err) {
diff --git a/drivers/watchdog/it87_wdt.c b/drivers/watchdog/it87_wdt.c
index b1bc72f..a2d9a12 100644
--- a/drivers/watchdog/it87_wdt.c
+++ b/drivers/watchdog/it87_wdt.c
@@ -137,7 +137,6 @@
 
 static	unsigned int base, gpact, ciract, max_units, chip_type;
 static	unsigned long wdt_status;
-static	DEFINE_SPINLOCK(spinlock);
 
 static	int nogameport = DEFAULT_NOGAMEPORT;
 static	int exclusive  = DEFAULT_EXCLUSIVE;
@@ -163,18 +162,26 @@ MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started, default="
 
 /* Superio Chip */
 
-static inline void superio_enter(void)
+static inline int superio_enter(void)
 {
+	/*
+	 * Try to reserve REG and REG + 1 for exclusive access.
+	 */
+	if (!request_muxed_region(REG, 2, WATCHDOG_NAME))
+		return -EBUSY;
+
 	outb(0x87, REG);
 	outb(0x01, REG);
 	outb(0x55, REG);
 	outb(0x55, REG);
+	return 0;
 }
 
 static inline void superio_exit(void)
 {
 	outb(0x02, REG);
 	outb(0x02, VAL);
+	release_region(REG, 2);
 }
 
 static inline void superio_select(int ldn)
@@ -255,12 +262,11 @@ static void wdt_keepalive(void)
 	set_bit(WDTS_KEEPALIVE, &wdt_status);
 }
 
-static void wdt_start(void)
+static int wdt_start(void)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&spinlock, flags);
-	superio_enter();
+	int ret = superio_enter();
+	if (ret)
+		return ret;
 
 	superio_select(GPIO);
 	if (test_bit(WDTS_USE_GP, &wdt_status))
@@ -270,15 +276,15 @@ static void wdt_start(void)
 	wdt_update_timeout();
 
 	superio_exit();
-	spin_unlock_irqrestore(&spinlock, flags);
+
+	return 0;
 }
 
-static void wdt_stop(void)
+static int wdt_stop(void)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&spinlock, flags);
-	superio_enter();
+	int ret = superio_enter();
+	if (ret)
+		return ret;
 
 	superio_select(GPIO);
 	superio_outb(0x00, WDTCTRL);
@@ -288,7 +294,7 @@ static void wdt_stop(void)
 		superio_outb(0x00, WDTVALMSB);
 
 	superio_exit();
-	spin_unlock_irqrestore(&spinlock, flags);
+	return 0;
 }
 
 /**
@@ -303,8 +309,6 @@ static void wdt_stop(void)
 
 static int wdt_set_timeout(int t)
 {
-	unsigned long flags;
-
 	if (t < 1 || t > max_units * 60)
 		return -EINVAL;
 
@@ -313,14 +317,15 @@ static int wdt_set_timeout(int t)
 	else
 		timeout = t;
 
-	spin_lock_irqsave(&spinlock, flags);
 	if (test_bit(WDTS_TIMER_RUN, &wdt_status)) {
-		superio_enter();
+		int ret = superio_enter();
+		if (ret)
+			return ret;
+
 		superio_select(GPIO);
 		wdt_update_timeout();
 		superio_exit();
 	}
-	spin_unlock_irqrestore(&spinlock, flags);
 	return 0;
 }
 
@@ -339,12 +344,12 @@ static int wdt_set_timeout(int t)
 
 static int wdt_get_status(int *status)
 {
-	unsigned long flags;
-
 	*status = 0;
 	if (testmode) {
-		spin_lock_irqsave(&spinlock, flags);
-		superio_enter();
+		int ret = superio_enter();
+		if (ret)
+			return ret;
+
 		superio_select(GPIO);
 		if (superio_inb(WDTCTRL) & WDT_ZERO) {
 			superio_outb(0x00, WDTCTRL);
@@ -353,7 +358,6 @@ static int wdt_get_status(int *status)
 		}
 
 		superio_exit();
-		spin_unlock_irqrestore(&spinlock, flags);
 	}
 	if (test_and_clear_bit(WDTS_KEEPALIVE, &wdt_status))
 		*status |= WDIOF_KEEPALIVEPING;
@@ -379,9 +383,17 @@ static int wdt_open(struct inode *inode, struct file *file)
 	if (exclusive && test_and_set_bit(WDTS_DEV_OPEN, &wdt_status))
 		return -EBUSY;
 	if (!test_and_set_bit(WDTS_TIMER_RUN, &wdt_status)) {
+		int ret;
 		if (nowayout && !test_and_set_bit(WDTS_LOCKED, &wdt_status))
 			__module_get(THIS_MODULE);
-		wdt_start();
+
+		ret = wdt_start();
+		if (ret) {
+			clear_bit(WDTS_LOCKED, &wdt_status);
+			clear_bit(WDTS_TIMER_RUN, &wdt_status);
+			clear_bit(WDTS_DEV_OPEN, &wdt_status);
+			return ret;
+		}
 	}
 	return nonseekable_open(inode, file);
 }
@@ -403,7 +415,16 @@ static int wdt_release(struct inode *inode, struct file *file)
 {
 	if (test_bit(WDTS_TIMER_RUN, &wdt_status)) {
 		if (test_and_clear_bit(WDTS_EXPECTED, &wdt_status)) {
-			wdt_stop();
+			int ret = wdt_stop();
+			if (ret) {
+				/*
+				 * Stop failed. Just keep the watchdog alive
+				 * and hope nothing bad happens.
+				 */
+				set_bit(WDTS_EXPECTED, &wdt_status);
+				wdt_keepalive();
+				return ret;
+			}
 			clear_bit(WDTS_TIMER_RUN, &wdt_status);
 		} else {
 			wdt_keepalive();
@@ -484,7 +505,9 @@ static long wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 				    &ident, sizeof(ident)) ? -EFAULT : 0;
 
 	case WDIOC_GETSTATUS:
-		wdt_get_status(&status);
+		rc = wdt_get_status(&status);
+		if (rc)
+			return rc;
 		return put_user(status, uarg.i);
 
 	case WDIOC_GETBOOTSTATUS:
@@ -500,14 +523,22 @@ static long wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 		switch (new_options) {
 		case WDIOS_DISABLECARD:
-			if (test_bit(WDTS_TIMER_RUN, &wdt_status))
-				wdt_stop();
+			if (test_bit(WDTS_TIMER_RUN, &wdt_status)) {
+				rc = wdt_stop();
+				if (rc)
+					return rc;
+			}
 			clear_bit(WDTS_TIMER_RUN, &wdt_status);
 			return 0;
 
 		case WDIOS_ENABLECARD:
-			if (!test_and_set_bit(WDTS_TIMER_RUN, &wdt_status))
-				wdt_start();
+			if (!test_and_set_bit(WDTS_TIMER_RUN, &wdt_status)) {
+				rc = wdt_start();
+				if (rc) {
+					clear_bit(WDTS_TIMER_RUN, &wdt_status);
+					return rc;
+				}
+			}
 			return 0;
 
 		default:
@@ -560,16 +591,17 @@ static int __init it87_wdt_init(void)
 	int rc = 0;
 	int try_gameport = !nogameport;
 	u8  chip_rev;
-	unsigned long flags;
+	int gp_rreq_fail = 0;
 
 	wdt_status = 0;
 
-	spin_lock_irqsave(&spinlock, flags);
-	superio_enter();
+	rc = superio_enter();
+	if (rc)
+		return rc;
+
 	chip_type = superio_inw(CHIPID);
 	chip_rev  = superio_inb(CHIPREV) & 0x0f;
 	superio_exit();
-	spin_unlock_irqrestore(&spinlock, flags);
 
 	switch (chip_type) {
 	case IT8702_ID:
@@ -603,8 +635,9 @@ static int __init it87_wdt_init(void)
 		return -ENODEV;
 	}
 
-	spin_lock_irqsave(&spinlock, flags);
-	superio_enter();
+	rc = superio_enter();
+	if (rc)
+		return rc;
 
 	superio_select(GPIO);
 	superio_outb(WDT_TOV1, WDTCFG);
@@ -620,21 +653,16 @@ static int __init it87_wdt_init(void)
 		}
 		gpact = superio_inb(ACTREG);
 		superio_outb(0x01, ACTREG);
-		superio_exit();
-		spin_unlock_irqrestore(&spinlock, flags);
 		if (request_region(base, 1, WATCHDOG_NAME))
 			set_bit(WDTS_USE_GP, &wdt_status);
 		else
-			rc = -EIO;
-	} else {
-		superio_exit();
-		spin_unlock_irqrestore(&spinlock, flags);
+			gp_rreq_fail = 1;
 	}
 
 	/* If we haven't Gameport support, try to get CIR support */
 	if (!test_bit(WDTS_USE_GP, &wdt_status)) {
 		if (!request_region(CIR_BASE, 8, WATCHDOG_NAME)) {
-			if (rc == -EIO)
+			if (gp_rreq_fail)
 				printk(KERN_ERR PFX
 					"I/O Address 0x%04x and 0x%04x"
 					" already in use\n", base, CIR_BASE);
@@ -646,21 +674,16 @@ static int __init it87_wdt_init(void)
 			goto err_out;
 		}
 		base = CIR_BASE;
-		spin_lock_irqsave(&spinlock, flags);
-		superio_enter();
 
 		superio_select(CIR);
 		superio_outw(base, BASEREG);
 		superio_outb(0x00, CIR_ILS);
 		ciract = superio_inb(ACTREG);
 		superio_outb(0x01, ACTREG);
-		if (rc == -EIO) {
+		if (gp_rreq_fail) {
 			superio_select(GAMEPORT);
 			superio_outb(gpact, ACTREG);
 		}
-
-		superio_exit();
-		spin_unlock_irqrestore(&spinlock, flags);
 	}
 
 	if (timeout < 1 || timeout > max_units * 60) {
@@ -704,6 +727,7 @@ static int __init it87_wdt_init(void)
 		"nogameport=%d)\n", chip_type, chip_rev, timeout,
 		nowayout, testmode, exclusive, nogameport);
 
+	superio_exit();
 	return 0;
 
 err_out_reboot:
@@ -711,49 +735,37 @@ err_out_reboot:
 err_out_region:
 	release_region(base, test_bit(WDTS_USE_GP, &wdt_status) ? 1 : 8);
 	if (!test_bit(WDTS_USE_GP, &wdt_status)) {
-		spin_lock_irqsave(&spinlock, flags);
-		superio_enter();
 		superio_select(CIR);
 		superio_outb(ciract, ACTREG);
-		superio_exit();
-		spin_unlock_irqrestore(&spinlock, flags);
 	}
 err_out:
 	if (try_gameport) {
-		spin_lock_irqsave(&spinlock, flags);
-		superio_enter();
 		superio_select(GAMEPORT);
 		superio_outb(gpact, ACTREG);
-		superio_exit();
-		spin_unlock_irqrestore(&spinlock, flags);
 	}
 
+	superio_exit();
 	return rc;
 }
 
 static void __exit it87_wdt_exit(void)
 {
-	unsigned long flags;
-	int nolock;
-
-	nolock = !spin_trylock_irqsave(&spinlock, flags);
-	superio_enter();
-	superio_select(GPIO);
-	superio_outb(0x00, WDTCTRL);
-	superio_outb(0x00, WDTCFG);
-	superio_outb(0x00, WDTVALLSB);
-	if (max_units > 255)
-		superio_outb(0x00, WDTVALMSB);
-	if (test_bit(WDTS_USE_GP, &wdt_status)) {
-		superio_select(GAMEPORT);
-		superio_outb(gpact, ACTREG);
-	} else {
-		superio_select(CIR);
-		superio_outb(ciract, ACTREG);
+	if (superio_enter() == 0) {
+		superio_select(GPIO);
+		superio_outb(0x00, WDTCTRL);
+		superio_outb(0x00, WDTCFG);
+		superio_outb(0x00, WDTVALLSB);
+		if (max_units > 255)
+			superio_outb(0x00, WDTVALMSB);
+		if (test_bit(WDTS_USE_GP, &wdt_status)) {
+			superio_select(GAMEPORT);
+			superio_outb(gpact, ACTREG);
+		} else {
+			superio_select(CIR);
+			superio_outb(ciract, ACTREG);
+		}
+		superio_exit();
 	}
-	superio_exit();
-	if (!nolock)
-		spin_unlock_irqrestore(&spinlock, flags);
 
 	misc_deregister(&wdt_miscdev);
 	unregister_reboot_notifier(&wdt_notifier);
diff --git a/drivers/watchdog/pc87413_wdt.c b/drivers/watchdog/pc87413_wdt.c
index b7c1390..e78d899 100644
--- a/drivers/watchdog/pc87413_wdt.c
+++ b/drivers/watchdog/pc87413_wdt.c
@@ -56,6 +56,7 @@
 #define IO_DEFAULT	0x2E		/* Address used on Portwell Boards */
 
 static int io = IO_DEFAULT;
+static int swc_base_addr = -1;
 
 static int timeout = DEFAULT_TIMEOUT;	/* timeout value */
 static unsigned long timer_enabled;	/* is the timer enabled? */
@@ -116,9 +117,8 @@ static inline void pc87413_enable_swc(void)
 
 /* Read SWC I/O base address */
 
-static inline unsigned int pc87413_get_swc_base(void)
+static void pc87413_get_swc_base_addr(void)
 {
-	unsigned int  swc_base_addr = 0;
 	unsigned char addr_l, addr_h = 0;
 
 	/* Step 3: Read SWC I/O Base Address */
@@ -136,12 +136,11 @@ static inline unsigned int pc87413_get_swc_base(void)
 		"Read SWC I/O Base Address: low %d, high %d, res %d\n",
 						addr_l, addr_h, swc_base_addr);
 #endif
-	return swc_base_addr;
 }
 
 /* Select Bank 3 of SWC */
 
-static inline void pc87413_swc_bank3(unsigned int swc_base_addr)
+static inline void pc87413_swc_bank3(void)
 {
 	/* Step 4: Select Bank3 of SWC */
 	outb_p(inb(swc_base_addr + 0x0f) | 0x03, swc_base_addr + 0x0f);
@@ -152,8 +151,7 @@ static inline void pc87413_swc_bank3(unsigned int swc_base_addr)
 
 /* Set watchdog timeout to x minutes */
 
-static inline void pc87413_programm_wdto(unsigned int swc_base_addr,
-					 char pc87413_time)
+static inline void pc87413_programm_wdto(char pc87413_time)
 {
 	/* Step 5: Programm WDTO, Twd. */
 	outb_p(pc87413_time, swc_base_addr + WDTO);
@@ -164,7 +162,7 @@ static inline void pc87413_programm_wdto(unsigned int swc_base_addr,
 
 /* Enable WDEN */
 
-static inline void pc87413_enable_wden(unsigned int swc_base_addr)
+static inline void pc87413_enable_wden(void)
 {
 	/* Step 6: Enable WDEN */
 	outb_p(inb(swc_base_addr + WDCTL) | 0x01, swc_base_addr + WDCTL);
@@ -174,7 +172,7 @@ static inline void pc87413_enable_wden(unsigned int swc_base_addr)
 }
 
 /* Enable SW_WD_TREN */
-static inline void pc87413_enable_sw_wd_tren(unsigned int swc_base_addr)
+static inline void pc87413_enable_sw_wd_tren(void)
 {
 	/* Enable SW_WD_TREN */
 	outb_p(inb(swc_base_addr + WDCFG) | 0x80, swc_base_addr + WDCFG);
@@ -185,7 +183,7 @@ static inline void pc87413_enable_sw_wd_tren(unsigned int swc_base_addr)
 
 /* Disable SW_WD_TREN */
 
-static inline void pc87413_disable_sw_wd_tren(unsigned int swc_base_addr)
+static inline void pc87413_disable_sw_wd_tren(void)
 {
 	/* Disable SW_WD_TREN */
 	outb_p(inb(swc_base_addr + WDCFG) & 0x7f, swc_base_addr + WDCFG);
@@ -196,7 +194,7 @@ static inline void pc87413_disable_sw_wd_tren(unsigned int swc_base_addr)
 
 /* Enable SW_WD_TRG */
 
-static inline void pc87413_enable_sw_wd_trg(unsigned int swc_base_addr)
+static inline void pc87413_enable_sw_wd_trg(void)
 {
 	/* Enable SW_WD_TRG */
 	outb_p(inb(swc_base_addr + WDCTL) | 0x80, swc_base_addr + WDCTL);
@@ -207,7 +205,7 @@ static inline void pc87413_enable_sw_wd_trg(unsigned int swc_base_addr)
 
 /* Disable SW_WD_TRG */
 
-static inline void pc87413_disable_sw_wd_trg(unsigned int swc_base_addr)
+static inline void pc87413_disable_sw_wd_trg(void)
 {
 	/* Disable SW_WD_TRG */
 	outb_p(inb(swc_base_addr + WDCTL) & 0x7f, swc_base_addr + WDCTL);
@@ -222,18 +220,13 @@ static inline void pc87413_disable_sw_wd_trg(unsigned int swc_base_addr)
 
 static void pc87413_enable(void)
 {
-	unsigned int swc_base_addr;
-
 	spin_lock(&io_lock);
 
-	pc87413_select_wdt_out();
-	pc87413_enable_swc();
-	swc_base_addr = pc87413_get_swc_base();
-	pc87413_swc_bank3(swc_base_addr);
-	pc87413_programm_wdto(swc_base_addr, timeout);
-	pc87413_enable_wden(swc_base_addr);
-	pc87413_enable_sw_wd_tren(swc_base_addr);
-	pc87413_enable_sw_wd_trg(swc_base_addr);
+	pc87413_swc_bank3();
+	pc87413_programm_wdto(timeout);
+	pc87413_enable_wden();
+	pc87413_enable_sw_wd_tren();
+	pc87413_enable_sw_wd_trg();
 
 	spin_unlock(&io_lock);
 }
@@ -242,17 +235,12 @@ static void pc87413_enable(void)
 
 static void pc87413_disable(void)
 {
-	unsigned int swc_base_addr;
-
 	spin_lock(&io_lock);
 
-	pc87413_select_wdt_out();
-	pc87413_enable_swc();
-	swc_base_addr = pc87413_get_swc_base();
-	pc87413_swc_bank3(swc_base_addr);
-	pc87413_disable_sw_wd_tren(swc_base_addr);
-	pc87413_disable_sw_wd_trg(swc_base_addr);
-	pc87413_programm_wdto(swc_base_addr, 0);
+	pc87413_swc_bank3();
+	pc87413_disable_sw_wd_tren();
+	pc87413_disable_sw_wd_trg();
+	pc87413_programm_wdto(0);
 
 	spin_unlock(&io_lock);
 }
@@ -261,20 +249,15 @@ static void pc87413_disable(void)
 
 static void pc87413_refresh(void)
 {
-	unsigned int swc_base_addr;
-
 	spin_lock(&io_lock);
 
-	pc87413_select_wdt_out();
-	pc87413_enable_swc();
-	swc_base_addr = pc87413_get_swc_base();
-	pc87413_swc_bank3(swc_base_addr);
-	pc87413_disable_sw_wd_tren(swc_base_addr);
-	pc87413_disable_sw_wd_trg(swc_base_addr);
-	pc87413_programm_wdto(swc_base_addr, timeout);
-	pc87413_enable_wden(swc_base_addr);
-	pc87413_enable_sw_wd_tren(swc_base_addr);
-	pc87413_enable_sw_wd_trg(swc_base_addr);
+	pc87413_swc_bank3();
+	pc87413_disable_sw_wd_tren();
+	pc87413_disable_sw_wd_trg();
+	pc87413_programm_wdto(timeout);
+	pc87413_enable_wden();
+	pc87413_enable_sw_wd_tren();
+	pc87413_enable_sw_wd_trg();
 
 	spin_unlock(&io_lock);
 }
@@ -528,7 +511,8 @@ static int __init pc87413_init(void)
 	printk(KERN_INFO PFX "Version " VERSION " at io 0x%X\n",
 							WDT_INDEX_IO_PORT);
 
-	/* request_region(io, 2, "pc87413"); */
+	if (!request_muxed_region(io, 2, MODNAME))
+		return -EBUSY;
 
 	ret = register_reboot_notifier(&pc87413_notifier);
 	if (ret != 0) {
@@ -541,12 +525,32 @@ static int __init pc87413_init(void)
 		printk(KERN_ERR PFX
 			"cannot register miscdev on minor=%d (err=%d)\n",
 			WATCHDOG_MINOR, ret);
-		unregister_reboot_notifier(&pc87413_notifier);
-		return ret;
+		goto reboot_unreg;
 	}
 	printk(KERN_INFO PFX "initialized. timeout=%d min \n", timeout);
+
+	pc87413_select_wdt_out();
+	pc87413_enable_swc();
+	pc87413_get_swc_base_addr();
+
+	if (!request_region(swc_base_addr, 0x20, MODNAME)) {
+		printk(KERN_ERR PFX
+			"cannot request SWC region at 0x%x\n", swc_base_addr);
+		ret = -EBUSY;
+		goto misc_unreg;
+	}
+
 	pc87413_enable();
+
+	release_region(io, 2);
 	return 0;
+
+misc_unreg:
+	misc_deregister(&pc87413_miscdev);
+reboot_unreg:
+	unregister_reboot_notifier(&pc87413_notifier);
+	release_region(io, 2);
+	return ret;
 }
 
 /**
@@ -569,7 +573,7 @@ static void __exit pc87413_exit(void)
 
 	misc_deregister(&pc87413_miscdev);
 	unregister_reboot_notifier(&pc87413_notifier);
-	/* release_region(io, 2); */
+	release_region(swc_base_addr, 0x20);
 
 	printk(KERN_INFO MODNAME " watchdog component driver removed.\n");
 }
