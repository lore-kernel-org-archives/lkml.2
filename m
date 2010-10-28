Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772Ab0J1WpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 18:45:09 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:53579 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753305Ab0J1WpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 18:45:03 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEACaYyUxR8EpR/2dsb2JhbAChU3K+WA2CZ4JUBA
Date: Fri, 29 Oct 2010 00:44:59 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Seth Heasley <seth.heasley@intel.com>,
        Prarit Bhargava <prarit@redhat.com>, Joe Perches <joe@perches.com>,
        Ondrej Zajicek <santiago@crfreenet.org>,
        Timo Juhani Lindfors <timo.lindfors@iki.fi>,
        Nicolas Kaiser <nikai@nikai.net>, Giel van Schijndel <me@mortis.eu>,
        Florian Fainelli <florian@openwrt.org>
Subject: [GIT PULL REQUEST] watchdog - v2.6.37-rc1
Message-ID: <20101028224459.GE4046@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 drivers/watchdog/Kconfig       |   23 +-
 drivers/watchdog/Makefile      |    1 
 drivers/watchdog/bcm63xx_wdt.c |  350 +++++++++++++++++++++++++++++++++++++++++
 drivers/watchdog/f71808e_wdt.c |   10 +
 drivers/watchdog/iTCO_wdt.c    |   26 +--
 drivers/watchdog/it8712f_wdt.c |   25 +-
 drivers/watchdog/it87_wdt.c    |   96 +++++++----
 drivers/watchdog/machzwd.c     |    4 
 8 files changed, 479 insertions(+), 56 deletions(-)

with these Changes:

Author: Prarit Bhargava <prarit@redhat.com>
Date:   Wed Oct 27 09:50:22 2010 -0400

    watchdog: iTCO_wdt.c: remove extra pci_dev_put()'s from init code
    
    The iTCO_wdt driver erroneously releases the pci_dev, and causes PCI hotremove
    to fail because of an incorrect usage count.
    
    The probe for this driver does a for_each_pci_dev() which gets a reference for
    a pci_dev when iTCO_wdt_init() is successful.  The for_each_pci_dev() loop
    puts a reference for a pci_dev when iTCO_wdt_init() fails, so the
    iTCO_wdt_init() does not need to do any pci_dev_put()'s.
    
    The only pci_dev_put() that is required is in the iTCO_wdt_cleanup() function.
    
    Signed-off-by: Prarit Bhargava <prarit@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Florian Fainelli <florian@openwrt.org>
Date:   Sat Aug 28 22:03:45 2010 +0200

    watchdog: add support for Broadcom BCM63xx built-in watchdog
    
    This patch adds support for the Broadcom BCM63xx SoC built-in watchdog, it
    uses one of the BCM63xx hardware timer id.
    
    Signed-off-by: Miguel Gaio <miguel.gaio@efixo.com>
    Signed-off-by: Florian Fainelli <florian@openwrt.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Giel van Schijndel <me@mortis.eu>
Date:   Mon Oct 4 10:45:28 2010 +0200

    watchdog: f71808e_wdt: add support for the F71889FG
    
    Signed-off-by: Giel van Schijndel <me@mortis.eu>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Nicolas Kaiser <nikai@nikai.net>
Date:   Sat Oct 9 14:19:46 2010 +0200

    watchdog: MachZ: fix debug macro
    
    Fix debug macro line wrapping.
    
    Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Timo Juhani Lindfors <timo.lindfors@iki.fi>
Date:   Thu Sep 30 17:08:04 2010 +0300

    watchdog: it8712f_wdt: Add module parameter for alternative reset sources
    
    On iEi PCISA-9652-R10 (BIOS version 1.5) single board computer reads
    from the game port do not seem to reset the watchdog timer. This patch
    adds a module parameter wdt_config_reg to specify alternative reset
    sources. At least WDT_RESET_KBD has been tested, even just running
    
    while true; do
        setleds -L +scroll
        sleep 1
        setleds -L -scroll
        sleep 1
    done
    
    is enough to keep the watchdog happy.
    
    Signed-off-by: Timo Juhani Lindfors <timo.lindfors@iki.fi>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Timo Juhani Lindfors <timo.lindfors@iki.fi>
Date:   Thu Sep 30 17:08:03 2010 +0300

     watchdog: it8712f_wdt: Add comments for config/control register names
    
    Signed-off-by: Timo Juhani Lindfors <timo.lindfors@iki.fi>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Ondrej Zajicek <santiago@crfreenet.org>
Date:   Tue Sep 14 02:54:16 2010 +0200

    watchdog: it87_wdt: Add support for watchdogs with 8b timers
    
    This patch adds support for watchdogs with 8b timers, like ones in
    IT8702F and older revisions of IT8712F Super IO chip, to it87_wdt
    driver. This patch should be used after the patch
    'it87_wdt: Add support for IT8720F watchdog'.
    
    Signed-off-by: Ondrej Zajicek <santiago@crfreenet.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: Ondrej Zajicek <santiago@crfreenet.org>
Date:   Tue Sep 14 02:47:28 2010 +0200

    watchdog: it87_wdt: Add support for IT8720F watchdog
    
    This simple patch adds support for a watchdog in IT8720F Super IO chip
    to it87_wdt driver.
    
    Signed-off-by: Ondrej Zajicek <santiago@crfreenet.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: Joe Perches <joe@perches.com>
Date:   Mon Sep 13 21:23:59 2010 -0700

    watchdog:  Use static const char * const where possible
    
    Signed-off-by: Joe Perches <joe@perches.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Prarit Bhargava <prarit@redhat.com>
Date:   Fri Aug 6 11:41:24 2010 -0400

    watchdog: iTCO_wdt: Cleanup warning messages
    
    The current iTCO_wdt driver warnings are confusing.  Currently when the device
    driver returns an error the console contains:
    
    iTCO_vendor_support: vendor-support=0
    iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
    iTCO_wdt: failed to reset NO_REBOOT flag, reboot disabled by hardware
    iTCO_wdt: No card detected
    
    After the patch,
    
    iTCO_vendor_support: vendor-support=0
    iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
    iTCO_wdt: failed to reset NO_REBOOT flag, device disabled by hardware/BIOS
    
    Clean this up and use the word "device" to describe the device.
    
    Signed-off-by: Prarit Bhargava <prarit@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Seth Heasley <seth.heasley@intel.com>
Date:   Thu Sep 9 09:58:03 2010 -0700

    watchdog: iTCO_wdt: TCO Watchdog patch for Intel Patsburg DeviceIDs
    
    This patch adds the Intel Patsburg (PCH) DeviceIDs for iTCO Watchdog.
    
    Signed-off-by: Seth Heasley <seth.heasley@intel.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index c356146..4a29104 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -409,11 +409,11 @@ config ALIM7101_WDT
 	  Most people will say N.
 
 config F71808E_WDT
-	tristate "Fintek F71808E and F71882FG Watchdog"
+	tristate "Fintek F71808E, F71882FG and F71889FG Watchdog"
 	depends on X86 && EXPERIMENTAL
 	help
 	  This is the driver for the hardware watchdog on the Fintek
-	  F71808E and F71882FG Super I/O controllers.
+	  F71808E, F71882FG and F71889FG Super I/O controllers.
 
 	  You can compile this driver directly into the kernel, or use
 	  it as a module.  The module will be called f71808e_wdt.
@@ -565,10 +565,11 @@ config IT87_WDT
 	tristate "IT87 Watchdog Timer"
 	depends on X86 && EXPERIMENTAL
 	---help---
-	  This is the driver for the hardware watchdog on the ITE IT8716,
-	  IT8718, IT8726, IT8712(Version J,K) Super I/O chips. This watchdog
-	  simply watches your kernel to make sure it doesn't freeze, and if
-	  it does, it reboots your computer after a certain amount of time.
+	  This is the driver for the hardware watchdog on the ITE IT8702,
+	  IT8712, IT8716, IT8718, IT8720, IT8726, IT8712 Super I/O chips.
+	  This watchdog simply watches your kernel to make sure it doesn't
+	  freeze, and if it does, it reboots your computer after a certain
+	  amount of time.
 
 	  To compile this driver as a module, choose M here: the module will
 	  be called it87_wdt.
@@ -916,6 +917,16 @@ config OCTEON_WDT
 	  from the first interrupt, it is then only poked when the
 	  device is written.
 
+config BCM63XX_WDT
+	tristate "Broadcom BCM63xx hardware watchdog"
+	depends on BCM63XX
+	help
+	  Watchdog driver for the built in watchdog hardware in Broadcom
+	  BCM63xx SoC.
+
+	  To compile this driver as a loadable module, choose M here.
+	  The module will be called bcm63xx_wdt.
+
 # PARISC Architecture
 
 # POWERPC Architecture
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 8374503..4b0ef38 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -109,6 +109,7 @@ obj-$(CONFIG_SBC_EPX_C3_WATCHDOG) += sbc_epx_c3.o
 
 # MIPS Architecture
 obj-$(CONFIG_BCM47XX_WDT) += bcm47xx_wdt.o
+obj-$(CONFIG_BCM63XX_WDT) += bcm63xx_wdt.o
 obj-$(CONFIG_RC32434_WDT) += rc32434_wdt.o
 obj-$(CONFIG_INDYDOG) += indydog.o
 obj-$(CONFIG_WDT_MTX1) += mtx-1_wdt.o
diff --git a/drivers/watchdog/bcm63xx_wdt.c b/drivers/watchdog/bcm63xx_wdt.c
new file mode 100644
index 0000000..a1debc8
--- /dev/null
+++ b/drivers/watchdog/bcm63xx_wdt.c
@@ -0,0 +1,350 @@
+/*
+ *  Broadcom BCM63xx SoC watchdog driver
+ *
+ *  Copyright (C) 2007, Miguel Gaio <miguel.gaio@efixo.com>
+ *  Copyright (C) 2008, Florian Fainelli <florian@openwrt.org>
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation; either version
+ *  2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/bitops.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/reboot.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+#include <linux/watchdog.h>
+#include <linux/timer.h>
+#include <linux/jiffies.h>
+#include <linux/interrupt.h>
+#include <linux/ptrace.h>
+#include <linux/resource.h>
+#include <linux/platform_device.h>
+
+#include <bcm63xx_cpu.h>
+#include <bcm63xx_io.h>
+#include <bcm63xx_regs.h>
+#include <bcm63xx_timer.h>
+
+#define PFX KBUILD_MODNAME
+
+#define WDT_HZ		50000000 /* Fclk */
+#define WDT_DEFAULT_TIME	30      /* seconds */
+#define WDT_MAX_TIME		256     /* seconds */
+
+static struct {
+	void __iomem *regs;
+	struct timer_list timer;
+	int default_ticks;
+	unsigned long inuse;
+	atomic_t ticks;
+} bcm63xx_wdt_device;
+
+static int expect_close;
+
+static int wdt_time = WDT_DEFAULT_TIME;
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
+	__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+/* HW functions */
+static void bcm63xx_wdt_hw_start(void)
+{
+	bcm_writel(0xfffffffe, bcm63xx_wdt_device.regs + WDT_DEFVAL_REG);
+	bcm_writel(WDT_START_1, bcm63xx_wdt_device.regs + WDT_CTL_REG);
+	bcm_writel(WDT_START_2, bcm63xx_wdt_device.regs + WDT_CTL_REG);
+}
+
+static void bcm63xx_wdt_hw_stop(void)
+{
+	bcm_writel(WDT_STOP_1, bcm63xx_wdt_device.regs + WDT_CTL_REG);
+	bcm_writel(WDT_STOP_2, bcm63xx_wdt_device.regs + WDT_CTL_REG);
+}
+
+static void bcm63xx_wdt_isr(void *data)
+{
+	struct pt_regs *regs = get_irq_regs();
+
+	die(PFX " fire", regs);
+}
+
+static void bcm63xx_timer_tick(unsigned long unused)
+{
+	if (!atomic_dec_and_test(&bcm63xx_wdt_device.ticks)) {
+		bcm63xx_wdt_hw_start();
+		mod_timer(&bcm63xx_wdt_device.timer, jiffies + HZ);
+	} else
+		printk(KERN_CRIT PFX ": watchdog will restart system\n");
+}
+
+static void bcm63xx_wdt_pet(void)
+{
+	atomic_set(&bcm63xx_wdt_device.ticks, wdt_time);
+}
+
+static void bcm63xx_wdt_start(void)
+{
+	bcm63xx_wdt_pet();
+	bcm63xx_timer_tick(0);
+}
+
+static void bcm63xx_wdt_pause(void)
+{
+	del_timer_sync(&bcm63xx_wdt_device.timer);
+	bcm63xx_wdt_hw_stop();
+}
+
+static int bcm63xx_wdt_settimeout(int new_time)
+{
+	if ((new_time <= 0) || (new_time > WDT_MAX_TIME))
+		return -EINVAL;
+
+	wdt_time = new_time;
+
+	return 0;
+}
+
+static int bcm63xx_wdt_open(struct inode *inode, struct file *file)
+{
+	if (test_and_set_bit(0, &bcm63xx_wdt_device.inuse))
+		return -EBUSY;
+
+	bcm63xx_wdt_start();
+	return nonseekable_open(inode, file);
+}
+
+static int bcm63xx_wdt_release(struct inode *inode, struct file *file)
+{
+	if (expect_close == 42)
+		bcm63xx_wdt_pause();
+	else {
+		printk(KERN_CRIT PFX
+			": Unexpected close, not stopping watchdog!\n");
+		bcm63xx_wdt_start();
+	}
+	clear_bit(0, &bcm63xx_wdt_device.inuse);
+	expect_close = 0;
+	return 0;
+}
+
+static ssize_t bcm63xx_wdt_write(struct file *file, const char *data,
+				size_t len, loff_t *ppos)
+{
+	if (len) {
+		if (!nowayout) {
+			size_t i;
+
+			/* In case it was set long ago */
+			expect_close = 0;
+
+			for (i = 0; i != len; i++) {
+				char c;
+				if (get_user(c, data + i))
+					return -EFAULT;
+				if (c == 'V')
+					expect_close = 42;
+			}
+		}
+		bcm63xx_wdt_pet();
+	}
+	return len;
+}
+
+static struct watchdog_info bcm63xx_wdt_info = {
+	.identity       = PFX,
+	.options        = WDIOF_SETTIMEOUT |
+				WDIOF_KEEPALIVEPING |
+				WDIOF_MAGICCLOSE,
+};
+
+
+static long bcm63xx_wdt_ioctl(struct file *file, unsigned int cmd,
+				unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+	int new_value, retval = -EINVAL;
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &bcm63xx_wdt_info,
+			sizeof(bcm63xx_wdt_info)) ? -EFAULT : 0;
+
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+
+	case WDIOC_SETOPTIONS:
+		if (get_user(new_value, p))
+			return -EFAULT;
+
+		if (new_value & WDIOS_DISABLECARD) {
+			bcm63xx_wdt_pause();
+			retval = 0;
+		}
+		if (new_value & WDIOS_ENABLECARD) {
+			bcm63xx_wdt_start();
+			retval = 0;
+		}
+
+		return retval;
+
+	case WDIOC_KEEPALIVE:
+		bcm63xx_wdt_pet();
+		return 0;
+
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_value, p))
+			return -EFAULT;
+
+		if (bcm63xx_wdt_settimeout(new_value))
+			return -EINVAL;
+
+		bcm63xx_wdt_pet();
+
+	case WDIOC_GETTIMEOUT:
+		return put_user(wdt_time, p);
+
+	default:
+		return -ENOTTY;
+
+	}
+}
+
+static int bcm63xx_wdt_notify_sys(struct notifier_block *this,
+				unsigned long code, void *unused)
+{
+	if (code == SYS_DOWN || code == SYS_HALT)
+		bcm63xx_wdt_pause();
+	return NOTIFY_DONE;
+}
+
+static const struct file_operations bcm63xx_wdt_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.write		= bcm63xx_wdt_write,
+	.unlocked_ioctl	= bcm63xx_wdt_ioctl,
+	.open		= bcm63xx_wdt_open,
+	.release	= bcm63xx_wdt_release,
+};
+
+static struct miscdevice bcm63xx_wdt_miscdev = {
+	.minor	= WATCHDOG_MINOR,
+	.name	= "watchdog",
+	.fops	= &bcm63xx_wdt_fops,
+};
+
+static struct notifier_block bcm63xx_wdt_notifier = {
+	.notifier_call = bcm63xx_wdt_notify_sys,
+};
+
+
+static int bcm63xx_wdt_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct resource *r;
+
+	setup_timer(&bcm63xx_wdt_device.timer, bcm63xx_timer_tick, 0L);
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!r) {
+		dev_err(&pdev->dev, "failed to get resources\n");
+		return -ENODEV;
+	}
+
+	bcm63xx_wdt_device.regs = ioremap_nocache(r->start, r->end - r->start);
+	if (!bcm63xx_wdt_device.regs) {
+		dev_err(&pdev->dev, "failed to remap I/O resources\n");
+		return -ENXIO;
+	}
+
+	ret = bcm63xx_timer_register(TIMER_WDT_ID, bcm63xx_wdt_isr, NULL);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to register wdt timer isr\n");
+		goto unmap;
+	}
+
+	if (bcm63xx_wdt_settimeout(wdt_time)) {
+		bcm63xx_wdt_settimeout(WDT_DEFAULT_TIME);
+		dev_info(&pdev->dev,
+			": wdt_time value must be 1 <= wdt_time <= 256, using %d\n",
+			wdt_time);
+	}
+
+	ret = register_reboot_notifier(&bcm63xx_wdt_notifier);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to register reboot_notifier\n");
+		goto unregister_timer;
+	}
+
+	ret = misc_register(&bcm63xx_wdt_miscdev);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to register watchdog device\n");
+		goto unregister_reboot_notifier;
+	}
+
+	dev_info(&pdev->dev, " started, timer margin: %d sec\n",
+						WDT_DEFAULT_TIME);
+
+	return 0;
+
+unregister_reboot_notifier:
+	unregister_reboot_notifier(&bcm63xx_wdt_notifier);
+unregister_timer:
+	bcm63xx_timer_unregister(TIMER_WDT_ID);
+unmap:
+	iounmap(bcm63xx_wdt_device.regs);
+	return ret;
+}
+
+static int bcm63xx_wdt_remove(struct platform_device *pdev)
+{
+	if (!nowayout)
+		bcm63xx_wdt_pause();
+
+	misc_deregister(&bcm63xx_wdt_miscdev);
+
+	iounmap(bcm63xx_wdt_device.regs);
+
+	unregister_reboot_notifier(&bcm63xx_wdt_notifier);
+	bcm63xx_timer_unregister(TIMER_WDT_ID);
+
+	return 0;
+}
+
+static struct platform_driver bcm63xx_wdt = {
+	.probe	= bcm63xx_wdt_probe,
+	.remove = bcm63xx_wdt_remove,
+	.driver = {
+		.name = "bcm63xx-wdt",
+	}
+};
+
+static int __init bcm63xx_wdt_init(void)
+{
+	return platform_driver_register(&bcm63xx_wdt);
+}
+
+static void __exit bcm63xx_wdt_exit(void)
+{
+	platform_driver_unregister(&bcm63xx_wdt);
+}
+
+module_init(bcm63xx_wdt_init);
+module_exit(bcm63xx_wdt_exit);
+
+MODULE_AUTHOR("Miguel Gaio <miguel.gaio@efixo.com>");
+MODULE_AUTHOR("Florian Fainelli <florian@openwrt.org>");
+MODULE_DESCRIPTION("Driver for the Broadcom BCM63xx SoC watchdog");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+MODULE_ALIAS("platform:bcm63xx-wdt");
diff --git a/drivers/watchdog/f71808e_wdt.c b/drivers/watchdog/f71808e_wdt.c
index 7e5c266..65e5796 100644
--- a/drivers/watchdog/f71808e_wdt.c
+++ b/drivers/watchdog/f71808e_wdt.c
@@ -308,6 +308,12 @@ static int watchdog_start(void)
 		superio_set_bit(watchdog.sioaddr, 0x29, 1);
 		break;
 
+	case f71889fg:
+		/* set pin 40 to WDTRST# */
+		superio_outb(watchdog.sioaddr, 0x2b,
+				superio_inb(watchdog.sioaddr, 0x2b) & 0xcf);
+		break;
+
 	default:
 		/*
 		 * 'default' label to shut up the compiler and catch
@@ -708,8 +714,10 @@ static int __init f71808e_find(int sioaddr)
 	case SIO_F71882_ID:
 		watchdog.type = f71882fg;
 		break;
-	case SIO_F71862_ID:
 	case SIO_F71889_ID:
+		watchdog.type = f71889fg;
+		break;
+	case SIO_F71862_ID:
 		/* These have a watchdog, though it isn't implemented (yet). */
 		err = -ENOSYS;
 		goto exit;
diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index 69de871..f7e90fe 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -146,6 +146,7 @@ enum iTCO_chipsets {
 	TCO_CPT29,	/* Cougar Point */
 	TCO_CPT30,	/* Cougar Point */
 	TCO_CPT31,	/* Cougar Point */
+	TCO_PBG,	/* Patsburg */
 };
 
 static struct {
@@ -233,6 +234,7 @@ static struct {
 	{"Cougar Point", 2},
 	{"Cougar Point", 2},
 	{"Cougar Point", 2},
+	{"Patsburg", 2},
 	{NULL, 0}
 };
 
@@ -348,6 +350,7 @@ static struct pci_device_id iTCO_wdt_pci_tbl[] = {
 	{ ITCO_PCI_DEVICE(0x1c5d,				TCO_CPT29)},
 	{ ITCO_PCI_DEVICE(0x1c5e,				TCO_CPT30)},
 	{ ITCO_PCI_DEVICE(0x1c5f,				TCO_CPT31)},
+	{ ITCO_PCI_DEVICE(0x1d40,				TCO_PBG)},
 	{ 0, },			/* End of list */
 };
 MODULE_DEVICE_TABLE(pci, iTCO_wdt_pci_tbl);
@@ -374,7 +377,7 @@ static char expect_release;
 static struct {		/* this is private data for the iTCO_wdt device */
 	/* TCO version/generation */
 	unsigned int iTCO_version;
-	/* The cards ACPIBASE address (TCOBASE = ACPIBASE+0x60) */
+	/* The device's ACPIBASE address (TCOBASE = ACPIBASE+0x60) */
 	unsigned long ACPIBASE;
 	/* NO_REBOOT flag is Memory-Mapped GCS register bit 5 (TCO version 2)*/
 	unsigned long __iomem *gcs;
@@ -467,7 +470,7 @@ static int iTCO_wdt_start(void)
 	if (iTCO_wdt_unset_NO_REBOOT_bit()) {
 		spin_unlock(&iTCO_wdt_private.io_lock);
 		printk(KERN_ERR PFX "failed to reset NO_REBOOT flag, "
-					"reboot disabled by hardware\n");
+					"reboot disabled by hardware/BIOS\n");
 		return -EIO;
 	}
 
@@ -781,8 +784,8 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 	base_address &= 0x0000ff80;
 	if (base_address == 0x00000000) {
 		/* Something's wrong here, ACPIBASE has to be set */
-		printk(KERN_ERR PFX "failed to get TCOBASE address\n");
-		pci_dev_put(pdev);
+		printk(KERN_ERR PFX "failed to get TCOBASE address, "
+					"device disabled by hardware/BIOS\n");
 		return -ENODEV;
 	}
 	iTCO_wdt_private.iTCO_version =
@@ -797,7 +800,8 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 	if (iTCO_wdt_private.iTCO_version == 2) {
 		pci_read_config_dword(pdev, 0xf0, &base_address);
 		if ((base_address & 1) == 0) {
-			printk(KERN_ERR PFX "RCBA is disabled by hardware\n");
+			printk(KERN_ERR PFX "RCBA is disabled by hardware"
+						"/BIOS, device disabled\n");
 			ret = -ENODEV;
 			goto out;
 		}
@@ -808,7 +812,7 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 	/* Check chipset's NO_REBOOT bit */
 	if (iTCO_wdt_unset_NO_REBOOT_bit() && iTCO_vendor_check_noreboot_on()) {
 		printk(KERN_INFO PFX "unable to reset NO_REBOOT flag, "
-					"platform may have disabled it\n");
+					"device disabled by hardware/BIOS\n");
 		ret = -ENODEV;	/* Cannot reset NO_REBOOT bit */
 		goto out_unmap;
 	}
@@ -819,7 +823,8 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 	/* The TCO logic uses the TCO_EN bit in the SMI_EN register */
 	if (!request_region(SMI_EN, 4, "iTCO_wdt")) {
 		printk(KERN_ERR PFX
-			"I/O address 0x%04lx already in use\n", SMI_EN);
+			"I/O address 0x%04lx already in use, "
+						"device disabled\n", SMI_EN);
 		ret = -EIO;
 		goto out_unmap;
 	}
@@ -831,8 +836,8 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 	/* The TCO I/O registers reside in a 32-byte range pointed to
 	   by the TCOBASE value */
 	if (!request_region(TCOBASE, 0x20, "iTCO_wdt")) {
-		printk(KERN_ERR PFX "I/O address 0x%04lx already in use\n",
-			TCOBASE);
+		printk(KERN_ERR PFX "I/O address 0x%04lx already in use "
+						"device disabled\n", TCOBASE);
 		ret = -EIO;
 		goto unreg_smi_en;
 	}
@@ -880,7 +885,6 @@ out_unmap:
 	if (iTCO_wdt_private.iTCO_version == 2)
 		iounmap(iTCO_wdt_private.gcs);
 out:
-	pci_dev_put(iTCO_wdt_private.pdev);
 	iTCO_wdt_private.ACPIBASE = 0;
 	return ret;
 }
@@ -921,7 +925,7 @@ static int __devinit iTCO_wdt_probe(struct platform_device *dev)
 	}
 
 	if (!found)
-		printk(KERN_INFO PFX "No card detected\n");
+		printk(KERN_INFO PFX "No device detected.\n");
 
 	return ret;
 }
diff --git a/drivers/watchdog/it8712f_wdt.c b/drivers/watchdog/it8712f_wdt.c
index f52c162..b32c6c0 100644
--- a/drivers/watchdog/it8712f_wdt.c
+++ b/drivers/watchdog/it8712f_wdt.c
@@ -75,15 +75,23 @@ static unsigned short address;
 #define WDT_CONFIG	0x72	/* WDT Register: Configuration */
 #define WDT_TIMEOUT	0x73	/* WDT Register: Timeout Value */
 
-#define WDT_RESET_GAME	0x10
-#define WDT_RESET_KBD	0x20
-#define WDT_RESET_MOUSE	0x40
-#define WDT_RESET_CIR	0x80
+#define WDT_RESET_GAME	0x10	/* Reset timer on read or write to game port */
+#define WDT_RESET_KBD	0x20	/* Reset timer on keyboard interrupt */
+#define WDT_RESET_MOUSE	0x40	/* Reset timer on mouse interrupt */
+#define WDT_RESET_CIR	0x80	/* Reset timer on consumer IR interrupt */
 
 #define WDT_UNIT_SEC	0x80	/* If 0 in MINUTES */
 
-#define WDT_OUT_PWROK	0x10
-#define WDT_OUT_KRST	0x40
+#define WDT_OUT_PWROK	0x10	/* Pulse PWROK on timeout */
+#define WDT_OUT_KRST	0x40	/* Pulse reset on timeout */
+
+static int wdt_control_reg = WDT_RESET_GAME;
+module_param(wdt_control_reg, int, 0);
+MODULE_PARM_DESC(wdt_control_reg, "Value to write to watchdog control "
+		"register. The default WDT_RESET_GAME resets the timer on "
+		"game port reads that this driver generates. You can also "
+		"use KBD, MOUSE or CIR if you have some external way to "
+		"generate those interrupts.");
 
 static int superio_inb(int reg)
 {
@@ -131,7 +139,8 @@ static inline void superio_exit(void)
 
 static inline void it8712f_wdt_ping(void)
 {
-	inb(address);
+	if (wdt_control_reg & WDT_RESET_GAME)
+		inb(address);
 }
 
 static void it8712f_wdt_update_margin(void)
@@ -170,7 +179,7 @@ static void it8712f_wdt_enable(void)
 	superio_enter();
 	superio_select(LDN_GPIO);
 
-	superio_outb(WDT_RESET_GAME, WDT_CONTROL);
+	superio_outb(wdt_control_reg, WDT_CONTROL);
 
 	it8712f_wdt_update_margin();
 
diff --git a/drivers/watchdog/it87_wdt.c b/drivers/watchdog/it87_wdt.c
index b709b3b..dad2924 100644
--- a/drivers/watchdog/it87_wdt.c
+++ b/drivers/watchdog/it87_wdt.c
@@ -12,7 +12,7 @@
  *		    http://www.ite.com.tw/
  *
  *	Support of the watchdog timers, which are available on
- *	IT8716, IT8718, IT8726 and IT8712 (J,K version).
+ *	IT8702, IT8712, IT8716, IT8718, IT8720 and IT8726.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
@@ -45,7 +45,7 @@
 
 #include <asm/system.h>
 
-#define WATCHDOG_VERSION	"1.12"
+#define WATCHDOG_VERSION	"1.13"
 #define WATCHDOG_NAME		"IT87 WDT"
 #define PFX			WATCHDOG_NAME ": "
 #define DRIVER_VERSION		WATCHDOG_NAME " driver, v" WATCHDOG_VERSION "\n"
@@ -76,10 +76,12 @@
 
 /* Chip Id numbers */
 #define NO_DEV_ID	0xffff
+#define IT8702_ID	0x8702
 #define IT8705_ID	0x8705
 #define IT8712_ID	0x8712
 #define IT8716_ID	0x8716
 #define IT8718_ID	0x8718
+#define IT8720_ID	0x8720
 #define IT8726_ID	0x8726	/* the data sheet suggest wrongly 0x8716 */
 
 /* GPIO Configuration Registers LDN=0x07 */
@@ -92,7 +94,7 @@
 #define WDT_CIRINT	0x80
 #define WDT_MOUSEINT	0x40
 #define WDT_KYBINT	0x20
-#define WDT_GAMEPORT	0x10 /* not it8718 */
+#define WDT_GAMEPORT	0x10 /* not in it8718, it8720 */
 #define WDT_FORCE	0x02
 #define WDT_ZERO	0x01
 
@@ -132,7 +134,7 @@
 #define WDTS_USE_GP	4
 #define WDTS_EXPECTED	5
 
-static	unsigned int base, gpact, ciract;
+static	unsigned int base, gpact, ciract, max_units;
 static	unsigned long wdt_status;
 static	DEFINE_SPINLOCK(spinlock);
 
@@ -210,6 +212,33 @@ static inline void superio_outw(int val, int reg)
 	outb(val, VAL);
 }
 
+/* Internal function, should be called after superio_select(GPIO) */
+static void wdt_update_timeout(void)
+{
+	unsigned char cfg = WDT_KRST | WDT_PWROK;
+	int tm = timeout;
+
+	if (testmode)
+		cfg = 0;
+
+	if (tm <= max_units)
+		cfg |= WDT_TOV1;
+	else
+		tm /= 60;
+
+	superio_outb(cfg, WDTCFG);
+	superio_outb(tm, WDTVALLSB);
+	if (max_units > 255)
+		superio_outb(tm>>8, WDTVALMSB);
+}
+
+static int wdt_round_time(int t)
+{
+	t += 59;
+	t -= t % 60;
+	return t;
+}
+
 /* watchdog timer handling */
 
 static void wdt_keepalive(void)
@@ -234,12 +263,7 @@ static void wdt_start(void)
 		superio_outb(WDT_GAMEPORT, WDTCTRL);
 	else
 		superio_outb(WDT_CIRINT, WDTCTRL);
-	if (!testmode)
-		superio_outb(WDT_TOV1 | WDT_KRST | WDT_PWROK, WDTCFG);
-	else
-		superio_outb(WDT_TOV1, WDTCFG);
-	superio_outb(timeout>>8, WDTVALMSB);
-	superio_outb(timeout, WDTVALLSB);
+	wdt_update_timeout();
 
 	superio_exit();
 	spin_unlock_irqrestore(&spinlock, flags);
@@ -255,8 +279,9 @@ static void wdt_stop(void)
 	superio_select(GPIO);
 	superio_outb(0x00, WDTCTRL);
 	superio_outb(WDT_TOV1, WDTCFG);
-	superio_outb(0x00, WDTVALMSB);
 	superio_outb(0x00, WDTVALLSB);
+	if (max_units > 255)
+		superio_outb(0x00, WDTVALMSB);
 
 	superio_exit();
 	spin_unlock_irqrestore(&spinlock, flags);
@@ -266,8 +291,8 @@ static void wdt_stop(void)
  *	wdt_set_timeout - set a new timeout value with watchdog ioctl
  *	@t: timeout value in seconds
  *
- *	The hardware device has a 16 bit watchdog timer, thus the
- *	timeout time ranges between 1 and 65535 seconds.
+ *	The hardware device has a 8 or 16 bit watchdog timer (depends on
+ *	chip version) that can be configured to count seconds or minutes.
  *
  *	Used within WDIOC_SETTIMEOUT watchdog device ioctl.
  */
@@ -276,19 +301,19 @@ static int wdt_set_timeout(int t)
 {
 	unsigned long flags;
 
-	if (t < 1 || t > 65535)
+	if (t < 1 || t > max_units * 60)
 		return -EINVAL;
 
-	timeout = t;
+	if (t > max_units)
+		timeout = wdt_round_time(t);
+	else
+		timeout = t;
 
 	spin_lock_irqsave(&spinlock, flags);
 	if (test_bit(WDTS_TIMER_RUN, &wdt_status)) {
 		superio_enter();
-
 		superio_select(GPIO);
-		superio_outb(t>>8, WDTVALMSB);
-		superio_outb(t, WDTVALLSB);
-
+		wdt_update_timeout();
 		superio_exit();
 	}
 	spin_unlock_irqrestore(&spinlock, flags);
@@ -529,10 +554,13 @@ static struct notifier_block wdt_notifier = {
 static int __init it87_wdt_init(void)
 {
 	int rc = 0;
+	int try_gameport = !nogameport;
 	u16 chip_type;
 	u8  chip_rev;
 	unsigned long flags;
 
+	wdt_status = 0;
+
 	spin_lock_irqsave(&spinlock, flags);
 	superio_enter();
 	chip_type = superio_inw(CHIPID);
@@ -541,13 +569,21 @@ static int __init it87_wdt_init(void)
 	spin_unlock_irqrestore(&spinlock, flags);
 
 	switch (chip_type) {
+	case IT8702_ID:
+		max_units = 255;
+		break;
+	case IT8712_ID:
+		max_units = (chip_rev < 8) ? 255 : 65535;
+		break;
 	case IT8716_ID:
-	case IT8718_ID:
 	case IT8726_ID:
+		max_units = 65535;
+		break;
+	case IT8718_ID:
+	case IT8720_ID:
+		max_units = 65535;
+		try_gameport = 0;
 		break;
-	case IT8712_ID:
-		if (chip_rev > 7)
-			break;
 	case IT8705_ID:
 		printk(KERN_ERR PFX
 		       "Unsupported Chip found, Chip %04x Revision %02x\n",
@@ -571,7 +607,7 @@ static int __init it87_wdt_init(void)
 	superio_outb(0x00, WDTCTRL);
 
 	/* First try to get Gameport support */
-	if (chip_type != IT8718_ID && !nogameport) {
+	if (try_gameport) {
 		superio_select(GAMEPORT);
 		base = superio_inw(BASEREG);
 		if (!base) {
@@ -623,13 +659,16 @@ static int __init it87_wdt_init(void)
 		spin_unlock_irqrestore(&spinlock, flags);
 	}
 
-	if (timeout < 1 || timeout > 65535) {
+	if (timeout < 1 || timeout > max_units * 60) {
 		timeout = DEFAULT_TIMEOUT;
 		printk(KERN_WARNING PFX
 		       "Timeout value out of range, use default %d sec\n",
 		       DEFAULT_TIMEOUT);
 	}
 
+	if (timeout > max_units)
+		timeout = wdt_round_time(timeout);
+
 	rc = register_reboot_notifier(&wdt_notifier);
 	if (rc) {
 		printk(KERN_ERR PFX
@@ -656,7 +695,7 @@ static int __init it87_wdt_init(void)
 		outb(0x09, CIR_IER(base));
 	}
 
-	printk(KERN_INFO PFX "Chip it%04x revision %d initialized. "
+	printk(KERN_INFO PFX "Chip IT%04x revision %d initialized. "
 		"timeout=%d sec (nowayout=%d testmode=%d exclusive=%d "
 		"nogameport=%d)\n", chip_type, chip_rev, timeout,
 		nowayout, testmode, exclusive, nogameport);
@@ -676,7 +715,7 @@ err_out_region:
 		spin_unlock_irqrestore(&spinlock, flags);
 	}
 err_out:
-	if (chip_type != IT8718_ID && !nogameport) {
+	if (try_gameport) {
 		spin_lock_irqsave(&spinlock, flags);
 		superio_enter();
 		superio_select(GAMEPORT);
@@ -698,8 +737,9 @@ static void __exit it87_wdt_exit(void)
 	superio_select(GPIO);
 	superio_outb(0x00, WDTCTRL);
 	superio_outb(0x00, WDTCFG);
-	superio_outb(0x00, WDTVALMSB);
 	superio_outb(0x00, WDTVALLSB);
+	if (max_units > 255)
+		superio_outb(0x00, WDTVALMSB);
 	if (test_bit(WDTS_USE_GP, &wdt_status)) {
 		superio_select(GAMEPORT);
 		superio_outb(gpact, ACTREG);
diff --git a/drivers/watchdog/machzwd.c b/drivers/watchdog/machzwd.c
index 2d118cf..9280350 100644
--- a/drivers/watchdog/machzwd.c
+++ b/drivers/watchdog/machzwd.c
@@ -143,7 +143,7 @@ static unsigned long next_heartbeat;
 #ifndef ZF_DEBUG
 #	define dprintk(format, args...)
 #else
-#	define dprintk(format, args...) printk(KERN_DEBUG PFX
+#	define dprintk(format, args...) printk(KERN_DEBUG PFX \
 				":%s:%d: " format, __func__, __LINE__ , ## args)
 #endif
 
@@ -388,7 +388,7 @@ static struct notifier_block zf_notifier = {
 
 static void __init zf_show_action(int act)
 {
-	char *str[] = { "RESET", "SMI", "NMI", "SCI" };
+	static const char * const str[] = { "RESET", "SMI", "NMI", "SCI" };
 
 	printk(KERN_INFO PFX ": Watchdog using action = %s\n", str[act]);
 }
