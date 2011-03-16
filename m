Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab1CPVcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:32:36 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:12153 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755566Ab1CPVc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:32:29 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEALfIgE1R8scj/2dsb2JhbACmDHjDBA2Cb4JnBJNR
Date: Wed, 16 Mar 2011 22:32:24 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Alan Cox <alan@linux.intel.com>,
        Donald Johnson <donald.k.johnson@intel.com>,
        Haruo Tomita <haruo.tomita@toshiba.co.jp>,
        Jan Beulich <jbeulich@novell.com>,
        Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Shuduo Sang <shuduo.sang@intel.com>, Timur Tabi <timur@freescale.com>,
        Tony Camuso <tcamuso@redhat.com>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Subject: [GIT PULL REQUEST] watchdog - v2.6.39-rc1
Message-ID: <20110316213224.GQ1751@infomag.iguana.be>
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

 arch/mips/include/asm/mach-jz4740/platform.h |    1 
 arch/mips/jz4740/platform.c                  |   16 
 drivers/watchdog/Kconfig                     |   34 +
 drivers/watchdog/Makefile                    |    5 
 drivers/watchdog/alim1535_wdt.c              |   10 
 drivers/watchdog/alim7101_wdt.c              |    2 
 drivers/watchdog/bcm47xx_wdt.c               |    4 
 drivers/watchdog/bfin_wdt.c                  |    4 
 drivers/watchdog/booke_wdt.c                 |   19 
 drivers/watchdog/cpwd.c                      |   36 -
 drivers/watchdog/eurotechwdt.c               |    2 
 drivers/watchdog/hpwdt.c                     |    2 
 drivers/watchdog/i6300esb.c                  |    2 
 drivers/watchdog/iTCO_wdt.c                  |    4 
 drivers/watchdog/intel_scu_watchdog.c        |  572 +++++++++++++++++++++++++++
 drivers/watchdog/intel_scu_watchdog.h        |   66 +++
 drivers/watchdog/it8712f_wdt.c               |    2 
 drivers/watchdog/it87_wdt.c                  |   28 -
 drivers/watchdog/jz4740_wdt.c                |  322 +++++++++++++++
 drivers/watchdog/machzwd.c                   |    2 
 drivers/watchdog/max63xx_wdt.c               |    2 
 drivers/watchdog/mpc8xxx_wdt.c               |    6 
 drivers/watchdog/mpcore_wdt.c                |    2 
 drivers/watchdog/mtx-1_wdt.c                 |   14 
 drivers/watchdog/nv_tco.c                    |    2 
 drivers/watchdog/omap_wdt.h                  |    2 
 drivers/watchdog/pc87413_wdt.c               |    2 
 drivers/watchdog/pcwd_pci.c                  |    2 
 drivers/watchdog/pnx4008_wdt.c               |    2 
 drivers/watchdog/s3c2410_wdt.c               |    2 
 drivers/watchdog/sbc8360.c                   |    2 
 drivers/watchdog/sbc_fitpc2_wdt.c            |    2 
 drivers/watchdog/smsc37b787_wdt.c            |    4 
 drivers/watchdog/softdog.c                   |    2 
 drivers/watchdog/sp5100_tco.c                |    2 
 drivers/watchdog/ts72xx_wdt.c                |    2 
 drivers/watchdog/w83697ug_wdt.c              |    4 
 drivers/watchdog/wdt.c                       |    2 
 drivers/watchdog/wdt977.c                    |    2 
 drivers/watchdog/wdt_pci.c                   |    6 
 drivers/watchdog/xen_wdt.c                   |  359 ++++++++++++++++
 include/xen/interface/sched.h                |   34 +
 42 files changed, 1498 insertions(+), 92 deletions(-)

with these Changes:

Author: Timur Tabi <timur@freescale.com>
Date:   Tue Feb 8 17:39:46 2011 -0600

    watchdog: booke_wdt: clean up status messages
    
    Improve the status messages that are displayed during some operations of the
    PowerPC watchdog timer driver.  When the watchdog is enabled, the timeout is
    displayed as a number of seconds, instead of an obscure "period".  The "period"
    is the position of a bit in a 64-bit timer register.  The higher the value,
    the quicker the watchdog timeout occurs.  Some people chose a high "period"
    value for the timer and get confused as to why the board resets within a
    few seconds.
    
    Messages displayed during open and close are now debug messages, so that they
    don't clutter the console by default.  Finally, printk() is replaced with the
    pr_xxx() equivalent.
    
    Signed-off-by: Timur Tabi <timur@freescale.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Wed Feb 23 20:04:38 2011 +0000

    watchdog: cleanup spaces before tabs
    
    cleanup spaces before tabs in drivers/watchdog/
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Mon Feb 21 12:16:44 2011 +0000

    watchdog: convert to DEFINE_PCI_DEVICE_TABLE
    
    Convert static struct pci_device_id *[] to static DEFINE_PCI_DEVICE_TABLE tables.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Jan Beulich <JBeulich@novell.com>
Date:   Mon Oct 4 10:37:26 2010 +0100

    watchdog: Xen watchdog driver
    
    While the hypervisor change adding SCHEDOP_watchdog support included a
    daemon to make use of the new functionality, having a kernel driver
    for /dev/watchdog so that user space code doesn't need to distinguish
    non-Xen and Xen seems to be preferable.
    
    Signed-off-by: Jan Beulich <jbeulich@novell.com>
    Cc: Jeremy Fitzhardinge <jeremy@goop.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Donald Johnson <donald.k.johnson@intel.com>
Date:   Wed Feb 2 16:20:16 2011 +0000

    watchdog: Intel SCU Watchdog Timer Driver for Moorestown and Medfield platforms.
    
    This submission includes:
      - Fix to intel_scu_write() to start watchdog timer the on the
        first write, and refresh on subsequent writes.
        This enables Open, write, write, ... usage model.
      - Moves boot parameter checks from intel_scu_open() to
        intel_scu_watchdog_init(), so driver init will fail if these
        parameters are out of bounds.
      - Adds check for whether process waiting in wait_event_interruptible()
        received a signal while it was waiting.
      - Other small error handling changes.
    
    Removed the read() method for now as that wass a non-standard behaviour.
    
    Signed-off-by: Donald Johnson <donald.k.johnson@intel.com>
    Signed-off-by: Shuduo Sang <shuduo.sang@intel.com>
    Signed-off-by: Alan Cox <alan@linux.intel.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Sun Jan 16 19:05:39 2011 +0000

    watchdog: jz4740_wdt - fix magic character checking
    
    When writing to /dev/watchdog all characters should be checked
    for the magic character 'V'.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Paul Cercueil <paul@crapouillou.net>
Date:   Sun Dec 5 21:08:22 2010 +0100

    watchdog: add JZ4740 watchdog driver
    
    Adds support for the hardware watchdog found in Ingenic's jz4740
    System-on-Chip.
    
    Signed-off-by: Paul Cercueil <paul@crapouillou.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Huaro Tomita <haruo.tomita@toshiba.co.jp>
Date:   Fri Jan 21 07:37:51 2011 +0900

    watchdog: it87_wdt: Add support for IT8721F watchdog
    
    This patch adds support for a watchdog in IT8721F Super IO
    chip to it87_wdt driver.
    This new chips differ from the older IT87xxxF chips
    in the following ways:
    
    * WDT_GAMEPORT is not in IT8721F.
    * WDT_PWROK is not in IT8721F.
    
    Signed-off-by: Haruo Tomita <haruo.tomita@toshiba.co.jp>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Tony Camuso <tcamuso@redhat.com>
Date:   Fri Feb 4 17:38:59 2011 -0500

    watchdog: hpwdt: build hpwdt as module by default with NMI_DECODING enabled
    
    Builds the hpwdt driver as a module by default.
    If the hardware is present, the module will be loaded.
    Also, if hpwdt is loaded, it will decode NMIs by default.
    
    This has been made possible by he patches to hpwdt made by Dann Frazier
    as well as related patches submitted by Don Zickus.
    
    hpwdt only loads on hp ProLiant x86 32-bit and 64-bit platforms.
    
    Signed-off-by: Tony Camuso <tcamuso@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Date:   Fri Feb 4 19:47:13 2011 +0000

    watchdog: hpwdt: Fix a couple of typos
    
    Fix some typos.
    
    Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/arch/mips/include/asm/mach-jz4740/platform.h b/arch/mips/include/asm/mach-jz4740/platform.h
index 8987a76..564ab81 100644
--- a/arch/mips/include/asm/mach-jz4740/platform.h
+++ b/arch/mips/include/asm/mach-jz4740/platform.h
@@ -30,6 +30,7 @@ extern struct platform_device jz4740_i2s_device;
 extern struct platform_device jz4740_pcm_device;
 extern struct platform_device jz4740_codec_device;
 extern struct platform_device jz4740_adc_device;
+extern struct platform_device jz4740_wdt_device;
 
 void jz4740_serial_device_register(void);
 
diff --git a/arch/mips/jz4740/platform.c b/arch/mips/jz4740/platform.c
index 1cc9e54..10929e2 100644
--- a/arch/mips/jz4740/platform.c
+++ b/arch/mips/jz4740/platform.c
@@ -289,3 +289,19 @@ void jz4740_serial_device_register(void)
 
 	platform_device_register(&jz4740_uart_device);
 }
+
+/* Watchdog */
+static struct resource jz4740_wdt_resources[] = {
+	{
+		.start = JZ4740_WDT_BASE_ADDR,
+		.end   = JZ4740_WDT_BASE_ADDR + 0x10 - 1,
+		.flags = IORESOURCE_MEM,
+	},
+};
+
+struct platform_device jz4740_wdt_device = {
+	.name          = "jz4740-wdt",
+	.id            = -1,
+	.num_resources = ARRAY_SIZE(jz4740_wdt_resources),
+	.resource      = jz4740_wdt_resources,
+};
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 31649b7..6c216f9 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -533,6 +533,16 @@ config I6300ESB_WDT
 	  To compile this driver as a module, choose M here: the
 	  module will be called i6300esb.
 
+config INTEL_SCU_WATCHDOG
+	bool "Intel SCU Watchdog for Mobile Platforms"
+	depends on WATCHDOG
+	depends on INTEL_SCU_IPC
+	---help---
+	  Hardware driver for the watchdog time built into the Intel SCU
+	  for Intel Mobile Platforms.
+
+	  To compile this driver as a module, choose M here.
+
 config ITCO_WDT
 	tristate "Intel TCO Timer/Watchdog"
 	depends on (X86 || IA64) && PCI
@@ -580,7 +590,7 @@ config IT87_WDT
 	depends on X86 && EXPERIMENTAL
 	---help---
 	  This is the driver for the hardware watchdog on the ITE IT8702,
-	  IT8712, IT8716, IT8718, IT8720, IT8726, IT8712 Super I/O chips.
+	  IT8712, IT8716, IT8718, IT8720, IT8721, IT8726 Super I/O chips.
 	  This watchdog simply watches your kernel to make sure it doesn't
 	  freeze, and if it does, it reboots your computer after a certain
 	  amount of time.
@@ -589,18 +599,20 @@ config IT87_WDT
 	  be called it87_wdt.
 
 config HP_WATCHDOG
-	tristate "HP Proliant iLO2+ Hardware Watchdog Timer"
+	tristate "HP ProLiant iLO2+ Hardware Watchdog Timer"
 	depends on X86
+	default m
 	help
 	  A software monitoring watchdog and NMI sourcing driver. This driver
 	  will detect lockups and provide a stack trace. This is a driver that
-	  will only load on a HP ProLiant system with a minimum of iLO2 support.
+	  will only load on an HP ProLiant system with a minimum of iLO2 support.
 	  To compile this driver as a module, choose M here: the module will be
 	  called hpwdt.
 
 config HPWDT_NMI_DECODING
 	bool "NMI decoding support for the HP ProLiant iLO2+ Hardware Watchdog Timer"
 	depends on HP_WATCHDOG
+	default y
 	help
 	  When an NMI occurs this feature will make the necessary BIOS calls to
 	  log the cause of the NMI.
@@ -903,6 +915,12 @@ config INDYDOG
 	  timer expired and no process has written to /dev/watchdog during
 	  that time.
 
+config JZ4740_WDT
+	tristate "Ingenic jz4740 SoC hardware watchdog"
+	depends on MACH_JZ4740
+	help
+	  Hardware driver for the built-in watchdog timer on Ingenic jz4740 SoCs.
+
 config WDT_MTX1
 	tristate "MTX-1 Hardware Watchdog"
 	depends on MIPS_MTX1
@@ -1119,6 +1137,16 @@ config WATCHDOG_RIO
 
 # XTENSA Architecture
 
+# Xen Architecture
+
+config XEN_WDT
+	tristate "Xen Watchdog support"
+	depends on XEN
+	help
+	  Say Y here to support the hypervisor watchdog capability provided
+	  by Xen 4.0 and newer.  The watchdog timeout period is normally one
+	  minute but can be changed with a boot-time parameter.
+
 #
 # ISA-based Watchdog Cards
 #
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 20e44c4..d520bf9 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -102,6 +102,7 @@ obj-$(CONFIG_W83877F_WDT) += w83877f_wdt.o
 obj-$(CONFIG_W83977F_WDT) += w83977f_wdt.o
 obj-$(CONFIG_MACHZ_WDT) += machzwd.o
 obj-$(CONFIG_SBC_EPX_C3_WATCHDOG) += sbc_epx_c3.o
+obj-$(CONFIG_INTEL_SCU_WATCHDOG) += intel_scu_watchdog.o
 
 # M32R Architecture
 
@@ -114,6 +115,7 @@ obj-$(CONFIG_BCM47XX_WDT) += bcm47xx_wdt.o
 obj-$(CONFIG_BCM63XX_WDT) += bcm63xx_wdt.o
 obj-$(CONFIG_RC32434_WDT) += rc32434_wdt.o
 obj-$(CONFIG_INDYDOG) += indydog.o
+obj-$(CONFIG_JZ4740_WDT) += jz4740_wdt.o
 obj-$(CONFIG_WDT_MTX1) += mtx-1_wdt.o
 obj-$(CONFIG_PNX833X_WDT) += pnx833x_wdt.o
 obj-$(CONFIG_SIBYTE_WDOG) += sb_wdog.o
@@ -148,6 +150,9 @@ obj-$(CONFIG_WATCHDOG_CP1XXX)		+= cpwd.o
 
 # XTENSA Architecture
 
+# Xen
+obj-$(CONFIG_XEN_WDT) += xen_wdt.o
+
 # Architecture Independant
 obj-$(CONFIG_WM831X_WATCHDOG) += wm831x_wdt.o
 obj-$(CONFIG_WM8350_WATCHDOG) += wm8350_wdt.o
diff --git a/drivers/watchdog/alim1535_wdt.c b/drivers/watchdog/alim1535_wdt.c
index fa4d360..f16dcbd 100644
--- a/drivers/watchdog/alim1535_wdt.c
+++ b/drivers/watchdog/alim1535_wdt.c
@@ -301,7 +301,7 @@ static int ali_notify_sys(struct notifier_block *this,
  *	want to register another driver on the same PCI id.
  */
 
-static struct pci_device_id ali_pci_tbl[] __used = {
+static DEFINE_PCI_DEVICE_TABLE(ali_pci_tbl) __used = {
 	{ PCI_VENDOR_ID_AL, 0x1533, PCI_ANY_ID, PCI_ANY_ID,},
 	{ PCI_VENDOR_ID_AL, 0x1535, PCI_ANY_ID, PCI_ANY_ID,},
 	{ 0, },
@@ -362,12 +362,12 @@ static int __init ali_find_watchdog(void)
  */
 
 static const struct file_operations ali_fops = {
-	.owner 		=	THIS_MODULE,
-	.llseek 	=	no_llseek,
+	.owner		=	THIS_MODULE,
+	.llseek		=	no_llseek,
 	.write		=	ali_write,
 	.unlocked_ioctl =	ali_ioctl,
-	.open 		=	ali_open,
-	.release 	=	ali_release,
+	.open		=	ali_open,
+	.release	=	ali_release,
 };
 
 static struct miscdevice ali_miscdev = {
diff --git a/drivers/watchdog/alim7101_wdt.c b/drivers/watchdog/alim7101_wdt.c
index 4b7a2b4..46f4b85 100644
--- a/drivers/watchdog/alim7101_wdt.c
+++ b/drivers/watchdog/alim7101_wdt.c
@@ -430,7 +430,7 @@ err_out:
 module_init(alim7101_wdt_init);
 module_exit(alim7101_wdt_unload);
 
-static struct pci_device_id alim7101_pci_tbl[] __devinitdata __used = {
+static DEFINE_PCI_DEVICE_TABLE(alim7101_pci_tbl) __used = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M1533) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M7101) },
 	{ }
diff --git a/drivers/watchdog/bcm47xx_wdt.c b/drivers/watchdog/bcm47xx_wdt.c
index 5f24552..bd44417 100644
--- a/drivers/watchdog/bcm47xx_wdt.c
+++ b/drivers/watchdog/bcm47xx_wdt.c
@@ -150,8 +150,8 @@ static ssize_t bcm47xx_wdt_write(struct file *file, const char __user *data,
 }
 
 static const struct watchdog_info bcm47xx_wdt_info = {
-	.identity 	= DRV_NAME,
-	.options 	= WDIOF_SETTIMEOUT |
+	.identity	= DRV_NAME,
+	.options	= WDIOF_SETTIMEOUT |
 				WDIOF_KEEPALIVEPING |
 				WDIOF_MAGICCLOSE,
 };
diff --git a/drivers/watchdog/bfin_wdt.c b/drivers/watchdog/bfin_wdt.c
index 9042a95..b9fa9b7 100644
--- a/drivers/watchdog/bfin_wdt.c
+++ b/drivers/watchdog/bfin_wdt.c
@@ -63,7 +63,7 @@ static DEFINE_SPINLOCK(bfin_wdt_spinlock);
 /**
  *	bfin_wdt_keepalive - Keep the Userspace Watchdog Alive
  *
- * 	The Userspace watchdog got a KeepAlive: schedule the next timeout.
+ *	The Userspace watchdog got a KeepAlive: schedule the next timeout.
  */
 static int bfin_wdt_keepalive(void)
 {
@@ -337,7 +337,7 @@ static int bfin_wdt_resume(struct platform_device *pdev)
 static const struct file_operations bfin_wdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
-	.write    	= bfin_wdt_write,
+	.write		= bfin_wdt_write,
 	.unlocked_ioctl	= bfin_wdt_ioctl,
 	.open		= bfin_wdt_open,
 	.release	= bfin_wdt_release,
diff --git a/drivers/watchdog/booke_wdt.c b/drivers/watchdog/booke_wdt.c
index 7e7ec9c..337265b 100644
--- a/drivers/watchdog/booke_wdt.c
+++ b/drivers/watchdog/booke_wdt.c
@@ -4,7 +4,7 @@
  * Author: Matthew McClintock
  * Maintainer: Kumar Gala <galak@kernel.crashing.org>
  *
- * Copyright 2005, 2008, 2010 Freescale Semiconductor Inc.
+ * Copyright 2005, 2008, 2010-2011 Freescale Semiconductor Inc.
  *
  * This program is free software; you can redistribute  it and/or modify it
  * under  the terms of  the GNU General  Public License as published by the
@@ -221,9 +221,8 @@ static int booke_wdt_open(struct inode *inode, struct file *file)
 	if (booke_wdt_enabled == 0) {
 		booke_wdt_enabled = 1;
 		on_each_cpu(__booke_wdt_enable, NULL, 0);
-		printk(KERN_INFO
-		      "PowerPC Book-E Watchdog Timer Enabled (wdt_period=%d)\n",
-				booke_wdt_period);
+		pr_debug("booke_wdt: watchdog enabled (timeout = %llu sec)\n",
+			period_to_sec(booke_wdt_period));
 	}
 	spin_unlock(&booke_wdt_lock);
 
@@ -240,6 +239,7 @@ static int booke_wdt_release(struct inode *inode, struct file *file)
 	 */
 	on_each_cpu(__booke_wdt_disable, NULL, 0);
 	booke_wdt_enabled = 0;
+	pr_debug("booke_wdt: watchdog disabled\n");
 #endif
 
 	clear_bit(0, &wdt_is_active);
@@ -271,21 +271,20 @@ static int __init booke_wdt_init(void)
 {
 	int ret = 0;
 
-	printk(KERN_INFO "PowerPC Book-E Watchdog Timer Loaded\n");
+	pr_info("booke_wdt: powerpc book-e watchdog driver loaded\n");
 	ident.firmware_version = cur_cpu_spec->pvr_value;
 
 	ret = misc_register(&booke_wdt_miscdev);
 	if (ret) {
-		printk(KERN_CRIT "Cannot register miscdev on minor=%d: %d\n",
-				WATCHDOG_MINOR, ret);
+		pr_err("booke_wdt: cannot register device (minor=%u, ret=%i)\n",
+		       WATCHDOG_MINOR, ret);
 		return ret;
 	}
 
 	spin_lock(&booke_wdt_lock);
 	if (booke_wdt_enabled == 1) {
-		printk(KERN_INFO
-		      "PowerPC Book-E Watchdog Timer Enabled (wdt_period=%d)\n",
-				booke_wdt_period);
+		pr_info("booke_wdt: watchdog enabled (timeout = %llu sec)\n",
+			period_to_sec(booke_wdt_period));
 		on_each_cpu(__booke_wdt_enable, NULL, 0);
 	}
 	spin_unlock(&booke_wdt_lock);
diff --git a/drivers/watchdog/cpwd.c b/drivers/watchdog/cpwd.c
index 3de4ba0..1e60ff3 100644
--- a/drivers/watchdog/cpwd.c
+++ b/drivers/watchdog/cpwd.c
@@ -5,10 +5,10 @@
  * interface and Solaris-compatible ioctls as best it is
  * able.
  *
- * NOTE: 	CP1400 systems appear to have a defective intr_mask
- * 			register on the PLD, preventing the disabling of
- * 			timer interrupts.  We use a timer to periodically
- * 			reset 'stopped' watchdogs on affected platforms.
+ * NOTE:	CP1400 systems appear to have a defective intr_mask
+ *			register on the PLD, preventing the disabling of
+ *			timer interrupts.  We use a timer to periodically
+ *			reset 'stopped' watchdogs on affected platforms.
  *
  * Copyright (c) 2000 Eric Brower (ebrower@usa.net)
  * Copyright (C) 2008 David S. Miller <davem@davemloft.net>
@@ -107,13 +107,13 @@ static struct cpwd *cpwd_device;
  * -------------------
  * |-  counter val  -|
  * -------------------
- * dcntr - 	Current 16-bit downcounter value.
- * 			When downcounter reaches '0' watchdog expires.
- * 			Reading this register resets downcounter with
- * 			'limit' value.
- * limit - 	16-bit countdown value in 1/10th second increments.
- * 			Writing this register begins countdown with input value.
- * 			Reading from this register does not affect counter.
+ * dcntr -	Current 16-bit downcounter value.
+ *			When downcounter reaches '0' watchdog expires.
+ *			Reading this register resets downcounter with
+ *			'limit' value.
+ * limit -	16-bit countdown value in 1/10th second increments.
+ *			Writing this register begins countdown with input value.
+ *			Reading from this register does not affect counter.
  * NOTES:	After watchdog reset, dcntr and limit contain '1'
  *
  * status register (byte access):
@@ -123,7 +123,7 @@ static struct cpwd *cpwd_device;
  * |-   UNUSED  -| EXP | RUN |
  * ---------------------------
  * status-	Bit 0 - Watchdog is running
- * 			Bit 1 - Watchdog has expired
+ *			Bit 1 - Watchdog has expired
  *
  *** PLD register block definition (struct wd_pld_regblk)
  *
@@ -197,7 +197,7 @@ static u8 cpwd_readb(void __iomem *addr)
  * Because of the CP1400 defect this should only be
  * called during initialzation or by wd_[start|stop]timer()
  *
- * index 	- sub-device index, or -1 for 'all'
+ * index	- sub-device index, or -1 for 'all'
  * enable	- non-zero to enable interrupts, zero to disable
  */
 static void cpwd_toggleintr(struct cpwd *p, int index, int enable)
@@ -317,13 +317,13 @@ static int cpwd_getstatus(struct cpwd *p, int index)
 		} else {
 			/* Fudge WD_EXPIRED status for defective CP1400--
 			 * IF timer is running
-			 * 	AND brokenstop is set
-			 * 	AND an interrupt has been serviced
+			 *	AND brokenstop is set
+			 *	AND an interrupt has been serviced
 			 * we are WD_EXPIRED.
 			 *
 			 * IF timer is running
-			 * 	AND brokenstop is set
-			 * 	AND no interrupt has been serviced
+			 *	AND brokenstop is set
+			 *	AND no interrupt has been serviced
 			 * we are WD_FREERUN.
 			 */
 			if (p->broken &&
@@ -614,7 +614,7 @@ static int __devinit cpwd_probe(struct platform_device *op,
 
 	if (p->broken) {
 		init_timer(&cpwd_timer);
-		cpwd_timer.function 	= cpwd_brokentimer;
+		cpwd_timer.function	= cpwd_brokentimer;
 		cpwd_timer.data		= (unsigned long) p;
 		cpwd_timer.expires	= WD_BTIMEOUT;
 
diff --git a/drivers/watchdog/eurotechwdt.c b/drivers/watchdog/eurotechwdt.c
index 3f3dc09..f1d1da6 100644
--- a/drivers/watchdog/eurotechwdt.c
+++ b/drivers/watchdog/eurotechwdt.c
@@ -201,7 +201,7 @@ static void eurwdt_ping(void)
 static ssize_t eurwdt_write(struct file *file, const char __user *buf,
 size_t count, loff_t *ppos)
 {
-	if (count) 	{
+	if (count) {
 		if (!nowayout) {
 			size_t i;
 
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 204a560..8cb2685 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -52,7 +52,7 @@ static void __iomem *pci_mem_addr;		/* the PCI-memory address */
 static unsigned long __iomem *hpwdt_timer_reg;
 static unsigned long __iomem *hpwdt_timer_con;
 
-static struct pci_device_id hpwdt_devices[] = {
+static DEFINE_PCI_DEVICE_TABLE(hpwdt_devices) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_COMPAQ, 0xB203) },	/* iLO2 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_HP, 0x3306) },	/* iLO3 */
 	{0},			/* terminate list */
diff --git a/drivers/watchdog/i6300esb.c b/drivers/watchdog/i6300esb.c
index bb9750a..db45091 100644
--- a/drivers/watchdog/i6300esb.c
+++ b/drivers/watchdog/i6300esb.c
@@ -334,7 +334,7 @@ static struct miscdevice esb_miscdev = {
 /*
  * Data for PCI driver interface
  */
-static struct pci_device_id esb_pci_tbl[] = {
+static DEFINE_PCI_DEVICE_TABLE(esb_pci_tbl) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ESB_9), },
 	{ 0, },                 /* End of list */
 };
diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index 2c6c2b4..35a0d12 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -247,7 +247,7 @@ static struct {
 	{NULL, 0}
 };
 
-#define ITCO_PCI_DEVICE(dev, data) 	\
+#define ITCO_PCI_DEVICE(dev, data) \
 	.vendor = PCI_VENDOR_ID_INTEL,	\
 	.device = dev,			\
 	.subvendor = PCI_ANY_ID,	\
@@ -262,7 +262,7 @@ static struct {
  * pci_driver, because the I/O Controller Hub has also other
  * functions that probably will be registered by other drivers.
  */
-static struct pci_device_id iTCO_wdt_pci_tbl[] = {
+static DEFINE_PCI_DEVICE_TABLE(iTCO_wdt_pci_tbl) = {
 	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801AA_0,	TCO_ICH)},
 	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801AB_0,	TCO_ICH0)},
 	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801BA_0,	TCO_ICH2)},
diff --git a/drivers/watchdog/intel_scu_watchdog.c b/drivers/watchdog/intel_scu_watchdog.c
new file mode 100644
index 0000000..919bdd1
--- /dev/null
+++ b/drivers/watchdog/intel_scu_watchdog.c
@@ -0,0 +1,572 @@
+/*
+ *      Intel_SCU 0.2:  An Intel SCU IOH Based Watchdog Device
+ *			for Intel part #(s):
+ *				- AF82MP20 PCH
+ *
+ *      Copyright (C) 2009-2010 Intel Corporation. All rights reserved.
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of version 2 of the GNU General
+ *      Public License as published by the Free Software Foundation.
+ *
+ *      This program is distributed in the hope that it will be
+ *      useful, but WITHOUT ANY WARRANTY; without even the implied
+ *      warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
+ *      PURPOSE.  See the GNU General Public License for more details.
+ *      You should have received a copy of the GNU General Public
+ *      License along with this program; if not, write to the Free
+ *      Software Foundation, Inc., 59 Temple Place - Suite 330,
+ *      Boston, MA  02111-1307, USA.
+ *      The full GNU General Public License is included in this
+ *      distribution in the file called COPYING.
+ *
+ */
+
+#include <linux/compiler.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/moduleparam.h>
+#include <linux/types.h>
+#include <linux/miscdevice.h>
+#include <linux/watchdog.h>
+#include <linux/fs.h>
+#include <linux/notifier.h>
+#include <linux/reboot.h>
+#include <linux/init.h>
+#include <linux/jiffies.h>
+#include <linux/uaccess.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/sched.h>
+#include <linux/signal.h>
+#include <linux/sfi.h>
+#include <linux/types.h>
+#include <asm/irq.h>
+#include <asm/atomic.h>
+#include <asm/intel_scu_ipc.h>
+#include <asm/apb_timer.h>
+#include <asm/mrst.h>
+
+#include "intel_scu_watchdog.h"
+
+/* Bounds number of times we will retry loading time count */
+/* This retry is a work around for a silicon bug.	   */
+#define MAX_RETRY 16
+
+#define IPC_SET_WATCHDOG_TIMER	0xF8
+
+static int timer_margin = DEFAULT_SOFT_TO_HARD_MARGIN;
+module_param(timer_margin, int, 0);
+MODULE_PARM_DESC(timer_margin,
+		"Watchdog timer margin"
+		"Time between interrupt and resetting the system"
+		"The range is from 1 to 160"
+		"This is the time for all keep alives to arrive");
+
+static int timer_set = DEFAULT_TIME;
+module_param(timer_set, int, 0);
+MODULE_PARM_DESC(timer_set,
+		"Default Watchdog timer setting"
+		"Complete cycle time"
+		"The range is from 1 to 170"
+		"This is the time for all keep alives to arrive");
+
+/* After watchdog device is closed, check force_boot. If:
+ * force_boot == 0, then force boot on next watchdog interrupt after close,
+ * force_boot == 1, then force boot immediately when device is closed.
+ */
+static int force_boot;
+module_param(force_boot, int, 0);
+MODULE_PARM_DESC(force_boot,
+		"A value of 1 means that the driver will reboot"
+		"the system immediately if the /dev/watchdog device is closed"
+		"A value of 0 means that when /dev/watchdog device is closed"
+		"the watchdog timer will be refreshed for one more interval"
+		"of length: timer_set. At the end of this interval, the"
+		"watchdog timer will reset the system."
+		);
+
+/* there is only one device in the system now; this can be made into
+ * an array in the future if we have more than one device */
+
+static struct intel_scu_watchdog_dev watchdog_device;
+
+/* Forces restart, if force_reboot is set */
+static void watchdog_fire(void)
+{
+	if (force_boot) {
+		printk(KERN_CRIT PFX "Initiating system reboot.\n");
+		emergency_restart();
+		printk(KERN_CRIT PFX "Reboot didn't ?????\n");
+	}
+
+	else {
+		printk(KERN_CRIT PFX "Immediate Reboot Disabled\n");
+		printk(KERN_CRIT PFX
+			"System will reset when watchdog timer times out!\n");
+	}
+}
+
+static int check_timer_margin(int new_margin)
+{
+	if ((new_margin < MIN_TIME_CYCLE) ||
+	    (new_margin > MAX_TIME - timer_set)) {
+		pr_debug("Watchdog timer: value of new_margin %d is out of the range %d to %d\n",
+			  new_margin, MIN_TIME_CYCLE, MAX_TIME - timer_set);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/*
+ * IPC operations
+ */
+static int watchdog_set_ipc(int soft_threshold, int threshold)
+{
+	u32	*ipc_wbuf;
+	u8	 cbuf[16] = { '\0' };
+	int	 ipc_ret = 0;
+
+	ipc_wbuf = (u32 *)&cbuf;
+	ipc_wbuf[0] = soft_threshold;
+	ipc_wbuf[1] = threshold;
+
+	ipc_ret = intel_scu_ipc_command(
+			IPC_SET_WATCHDOG_TIMER,
+			0,
+			ipc_wbuf,
+			2,
+			NULL,
+			0);
+
+	if (ipc_ret != 0)
+		pr_err("Error setting SCU watchdog timer: %x\n", ipc_ret);
+
+	return ipc_ret;
+};
+
+/*
+ *      Intel_SCU operations
+ */
+
+/* timer interrupt handler */
+static irqreturn_t watchdog_timer_interrupt(int irq, void *dev_id)
+{
+	int int_status;
+	int_status = ioread32(watchdog_device.timer_interrupt_status_addr);
+
+	pr_debug("Watchdog timer: irq, int_status: %x\n", int_status);
+
+	if (int_status != 0)
+		return IRQ_NONE;
+
+	/* has the timer been started? If not, then this is spurious */
+	if (watchdog_device.timer_started == 0) {
+		pr_debug("Watchdog timer: spurious interrupt received\n");
+		return IRQ_HANDLED;
+	}
+
+	/* temporarily disable the timer */
+	iowrite32(0x00000002, watchdog_device.timer_control_addr);
+
+	/* set the timer to the threshold */
+	iowrite32(watchdog_device.threshold,
+		  watchdog_device.timer_load_count_addr);
+
+	/* allow the timer to run */
+	iowrite32(0x00000003, watchdog_device.timer_control_addr);
+
+	return IRQ_HANDLED;
+}
+
+static int intel_scu_keepalive(void)
+{
+
+	/* read eoi register - clears interrupt */
+	ioread32(watchdog_device.timer_clear_interrupt_addr);
+
+	/* temporarily disable the timer */
+	iowrite32(0x00000002, watchdog_device.timer_control_addr);
+
+	/* set the timer to the soft_threshold */
+	iowrite32(watchdog_device.soft_threshold,
+		  watchdog_device.timer_load_count_addr);
+
+	/* allow the timer to run */
+	iowrite32(0x00000003, watchdog_device.timer_control_addr);
+
+	return 0;
+}
+
+static int intel_scu_stop(void)
+{
+	iowrite32(0, watchdog_device.timer_control_addr);
+	return 0;
+}
+
+static int intel_scu_set_heartbeat(u32 t)
+{
+	int			 ipc_ret;
+	int			 retry_count;
+	u32			 soft_value;
+	u32			 hw_pre_value;
+	u32			 hw_value;
+
+	watchdog_device.timer_set = t;
+	watchdog_device.threshold =
+		timer_margin * watchdog_device.timer_tbl_ptr->freq_hz;
+	watchdog_device.soft_threshold =
+		(watchdog_device.timer_set - timer_margin)
+		* watchdog_device.timer_tbl_ptr->freq_hz;
+
+	pr_debug("Watchdog timer: set_heartbeat: timer freq is %d\n",
+		watchdog_device.timer_tbl_ptr->freq_hz);
+	pr_debug("Watchdog timer: set_heartbeat: timer_set is %x (hex)\n",
+		watchdog_device.timer_set);
+	pr_debug("Watchdog timer: set_hearbeat: timer_margin is %x (hex)\n",
+		timer_margin);
+	pr_debug("Watchdog timer: set_heartbeat: threshold is %x (hex)\n",
+		watchdog_device.threshold);
+	pr_debug("Watchdog timer: set_heartbeat: soft_threshold is %x (hex)\n",
+		watchdog_device.soft_threshold);
+
+	/* Adjust thresholds by FREQ_ADJUSTMENT factor, to make the */
+	/* watchdog timing come out right. */
+	watchdog_device.threshold =
+		watchdog_device.threshold / FREQ_ADJUSTMENT;
+	watchdog_device.soft_threshold =
+		watchdog_device.soft_threshold / FREQ_ADJUSTMENT;
+
+	/* temporarily disable the timer */
+	iowrite32(0x00000002, watchdog_device.timer_control_addr);
+
+	/* send the threshold and soft_threshold via IPC to the processor */
+	ipc_ret = watchdog_set_ipc(watchdog_device.soft_threshold,
+				   watchdog_device.threshold);
+
+	if (ipc_ret != 0) {
+		/* Make sure the watchdog timer is stopped */
+		intel_scu_stop();
+		return ipc_ret;
+	}
+
+	/* Soft Threshold set loop. Early versions of silicon did */
+	/* not always set this count correctly.  This loop checks */
+	/* the value and retries if it was not set correctly.     */
+
+	retry_count = 0;
+	soft_value = watchdog_device.soft_threshold & 0xFFFF0000;
+	do {
+
+		/* Make sure timer is stopped */
+		intel_scu_stop();
+
+		if (MAX_RETRY < retry_count++) {
+			/* Unable to set timer value */
+			pr_err("Watchdog timer: Unable to set timer\n");
+			return -ENODEV;
+		}
+
+		/* set the timer to the soft threshold */
+		iowrite32(watchdog_device.soft_threshold,
+			watchdog_device.timer_load_count_addr);
+
+		/* read count value before starting timer */
+		hw_pre_value = ioread32(watchdog_device.timer_load_count_addr);
+		hw_pre_value = hw_pre_value & 0xFFFF0000;
+
+		/* Start the timer */
+		iowrite32(0x00000003, watchdog_device.timer_control_addr);
+
+		/* read the value the time loaded into its count reg */
+		hw_value = ioread32(watchdog_device.timer_load_count_addr);
+		hw_value = hw_value & 0xFFFF0000;
+
+
+	} while (soft_value != hw_value);
+
+	watchdog_device.timer_started = 1;
+
+	return 0;
+}
+
+/*
+ * /dev/watchdog handling
+ */
+
+static int intel_scu_open(struct inode *inode, struct file *file)
+{
+
+	/* Set flag to indicate that watchdog device is open */
+	if (test_and_set_bit(0, &watchdog_device.driver_open))
+		return -EBUSY;
+
+	/* Check for reopen of driver. Reopens are not allowed */
+	if (watchdog_device.driver_closed)
+		return -EPERM;
+
+	return nonseekable_open(inode, file);
+}
+
+static int intel_scu_release(struct inode *inode, struct file *file)
+{
+	/*
+	 * This watchdog should not be closed, after the timer
+	 * is started with the WDIPC_SETTIMEOUT ioctl
+	 * If force_boot is set watchdog_fire() will cause an
+	 * immediate reset. If force_boot is not set, the watchdog
+	 * timer is refreshed for one more interval. At the end
+	 * of that interval, the watchdog timer will reset the system.
+	 */
+
+	if (!test_and_clear_bit(0, &watchdog_device.driver_open)) {
+		pr_debug("Watchdog timer: intel_scu_release, without open\n");
+		return -ENOTTY;
+	}
+
+	if (!watchdog_device.timer_started) {
+		/* Just close, since timer has not been started */
+		pr_debug("Watchdog timer: closed, without starting timer\n");
+		return 0;
+	}
+
+	printk(KERN_CRIT PFX
+	       "Unexpected close of /dev/watchdog!\n");
+
+	/* Since the timer was started, prevent future reopens */
+	watchdog_device.driver_closed = 1;
+
+	/* Refresh the timer for one more interval */
+	intel_scu_keepalive();
+
+	/* Reboot system (if force_boot is set) */
+	watchdog_fire();
+
+	/* We should only reach this point if force_boot is not set */
+	return 0;
+}
+
+static ssize_t intel_scu_write(struct file *file,
+			      char const *data,
+			      size_t len,
+			      loff_t *ppos)
+{
+
+	if (watchdog_device.timer_started)
+		/* Watchdog already started, keep it alive */
+		intel_scu_keepalive();
+	else
+		/* Start watchdog with timer value set by init */
+		intel_scu_set_heartbeat(watchdog_device.timer_set);
+
+	return len;
+}
+
+static long intel_scu_ioctl(struct file *file,
+			   unsigned int cmd,
+			   unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	u32 __user *p = argp;
+	u32 new_margin;
+
+
+	static const struct watchdog_info ident = {
+		.options =          WDIOF_SETTIMEOUT
+				    | WDIOF_KEEPALIVEPING,
+		.firmware_version = 0,  /* @todo Get from SCU via
+						 ipc_get_scu_fw_version()? */
+		.identity =         "Intel_SCU IOH Watchdog"  /* len < 32 */
+	};
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp,
+				    &ident,
+				    sizeof(ident)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+	case WDIOC_KEEPALIVE:
+		intel_scu_keepalive();
+
+		return 0;
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_margin, p))
+			return -EFAULT;
+
+		if (check_timer_margin(new_margin))
+			return -EINVAL;
+
+		if (intel_scu_set_heartbeat(new_margin))
+			return -EINVAL;
+		return 0;
+	case WDIOC_GETTIMEOUT:
+		return put_user(watchdog_device.soft_threshold, p);
+
+	default:
+		return -ENOTTY;
+	}
+}
+
+/*
+ *      Notifier for system down
+ */
+static int intel_scu_notify_sys(struct notifier_block *this,
+			       unsigned long code,
+			       void *another_unused)
+{
+	if (code == SYS_DOWN || code == SYS_HALT)
+		/* Turn off the watchdog timer. */
+		intel_scu_stop();
+	return NOTIFY_DONE;
+}
+
+/*
+ *      Kernel Interfaces
+ */
+static const struct file_operations intel_scu_fops = {
+	.owner          = THIS_MODULE,
+	.llseek         = no_llseek,
+	.write          = intel_scu_write,
+	.unlocked_ioctl = intel_scu_ioctl,
+	.open           = intel_scu_open,
+	.release        = intel_scu_release,
+};
+
+static int __init intel_scu_watchdog_init(void)
+{
+	int ret;
+	u32 __iomem *tmp_addr;
+
+	/*
+	 * We don't really need to check this as the SFI timer get will fail
+	 * but if we do so we can exit with a clearer reason and no noise.
+	 *
+	 * If it isn't an intel MID device then it doesn't have this watchdog
+	 */
+	if (!mrst_identify_cpu())
+		return -ENODEV;
+
+	/* Check boot parameters to verify that their initial values */
+	/* are in range. */
+	/* Check value of timer_set boot parameter */
+	if ((timer_set < MIN_TIME_CYCLE) ||
+	    (timer_set > MAX_TIME - MIN_TIME_CYCLE)) {
+		pr_err("Watchdog timer: value of timer_set %x (hex) "
+		  "is out of range from %x to %x (hex)\n",
+		  timer_set, MIN_TIME_CYCLE, MAX_TIME - MIN_TIME_CYCLE);
+		return -EINVAL;
+	}
+
+	/* Check value of timer_margin boot parameter */
+	if (check_timer_margin(timer_margin))
+		return -EINVAL;
+
+	watchdog_device.timer_tbl_ptr = sfi_get_mtmr(sfi_mtimer_num-1);
+
+	if (watchdog_device.timer_tbl_ptr == NULL) {
+		pr_debug("Watchdog timer - Intel SCU watchdog: timer is not available\n");
+		return -ENODEV;
+	}
+	/* make sure the timer exists */
+	if (watchdog_device.timer_tbl_ptr->phys_addr == 0) {
+		pr_debug("Watchdog timer - Intel SCU watchdog - timer %d does not have valid physical memory\n",
+								sfi_mtimer_num);
+		return -ENODEV;
+	}
+
+	if (watchdog_device.timer_tbl_ptr->irq == 0) {
+		pr_debug("Watchdog timer: timer %d invalid irq\n",
+							sfi_mtimer_num);
+		return -ENODEV;
+	}
+
+	tmp_addr = ioremap_nocache(watchdog_device.timer_tbl_ptr->phys_addr,
+			20);
+
+	if (tmp_addr == NULL) {
+		pr_debug("Watchdog timer: timer unable to ioremap\n");
+		return -ENOMEM;
+	}
+
+	watchdog_device.timer_load_count_addr = tmp_addr++;
+	watchdog_device.timer_current_value_addr = tmp_addr++;
+	watchdog_device.timer_control_addr = tmp_addr++;
+	watchdog_device.timer_clear_interrupt_addr = tmp_addr++;
+	watchdog_device.timer_interrupt_status_addr = tmp_addr++;
+
+	/* Set the default time values in device structure */
+
+	watchdog_device.timer_set = timer_set;
+	watchdog_device.threshold =
+		timer_margin * watchdog_device.timer_tbl_ptr->freq_hz;
+	watchdog_device.soft_threshold =
+		(watchdog_device.timer_set - timer_margin)
+		* watchdog_device.timer_tbl_ptr->freq_hz;
+
+
+	watchdog_device.intel_scu_notifier.notifier_call =
+		intel_scu_notify_sys;
+
+	ret = register_reboot_notifier(&watchdog_device.intel_scu_notifier);
+	if (ret) {
+		pr_err("Watchdog timer: cannot register notifier %d)\n", ret);
+		goto register_reboot_error;
+	}
+
+	watchdog_device.miscdev.minor = WATCHDOG_MINOR;
+	watchdog_device.miscdev.name = "watchdog";
+	watchdog_device.miscdev.fops = &intel_scu_fops;
+
+	ret = misc_register(&watchdog_device.miscdev);
+	if (ret) {
+		pr_err("Watchdog timer: cannot register miscdev %d err =%d\n",
+							WATCHDOG_MINOR, ret);
+		goto misc_register_error;
+	}
+
+	ret = request_irq((unsigned int)watchdog_device.timer_tbl_ptr->irq,
+		watchdog_timer_interrupt,
+		IRQF_SHARED, "watchdog",
+		&watchdog_device.timer_load_count_addr);
+	if (ret) {
+		pr_err("Watchdog timer: error requesting irq %d\n", ret);
+		goto request_irq_error;
+	}
+	/* Make sure timer is disabled before returning */
+	intel_scu_stop();
+	return 0;
+
+/* error cleanup */
+
+request_irq_error:
+	misc_deregister(&watchdog_device.miscdev);
+misc_register_error:
+	unregister_reboot_notifier(&watchdog_device.intel_scu_notifier);
+register_reboot_error:
+	intel_scu_stop();
+	iounmap(watchdog_device.timer_load_count_addr);
+	return ret;
+}
+
+static void __exit intel_scu_watchdog_exit(void)
+{
+
+	misc_deregister(&watchdog_device.miscdev);
+	unregister_reboot_notifier(&watchdog_device.intel_scu_notifier);
+	/* disable the timer */
+	iowrite32(0x00000002, watchdog_device.timer_control_addr);
+	iounmap(watchdog_device.timer_load_count_addr);
+}
+
+late_initcall(intel_scu_watchdog_init);
+module_exit(intel_scu_watchdog_exit);
+
+MODULE_AUTHOR("Intel Corporation");
+MODULE_DESCRIPTION("Intel SCU Watchdog Device Driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+MODULE_VERSION(WDT_VER);
diff --git a/drivers/watchdog/intel_scu_watchdog.h b/drivers/watchdog/intel_scu_watchdog.h
new file mode 100644
index 0000000..d2b074a
--- /dev/null
+++ b/drivers/watchdog/intel_scu_watchdog.h
@@ -0,0 +1,66 @@
+/*
+ *      Intel_SCU 0.2:  An Intel SCU IOH Based Watchdog Device
+ *			for Intel part #(s):
+ *				- AF82MP20 PCH
+ *
+ *      Copyright (C) 2009-2010 Intel Corporation. All rights reserved.
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of version 2 of the GNU General
+ *      Public License as published by the Free Software Foundation.
+ *
+ *      This program is distributed in the hope that it will be
+ *      useful, but WITHOUT ANY WARRANTY; without even the implied
+ *      warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
+ *      PURPOSE.  See the GNU General Public License for more details.
+ *      You should have received a copy of the GNU General Public
+ *      License along with this program; if not, write to the Free
+ *      Software Foundation, Inc., 59 Temple Place - Suite 330,
+ *      Boston, MA  02111-1307, USA.
+ *      The full GNU General Public License is included in this
+ *      distribution in the file called COPYING.
+ *
+ */
+
+#ifndef __INTEL_SCU_WATCHDOG_H
+#define __INTEL_SCU_WATCHDOG_H
+
+#define PFX "Intel_SCU: "
+#define WDT_VER "0.3"
+
+/* minimum time between interrupts */
+#define MIN_TIME_CYCLE 1
+
+/* Time from warning to reboot is 2 seconds */
+#define DEFAULT_SOFT_TO_HARD_MARGIN 2
+
+#define MAX_TIME 170
+
+#define DEFAULT_TIME 5
+
+#define MAX_SOFT_TO_HARD_MARGIN (MAX_TIME-MIN_TIME_CYCLE)
+
+/* Ajustment to clock tick frequency to make timing come out right */
+#define FREQ_ADJUSTMENT 8
+
+struct intel_scu_watchdog_dev {
+	ulong driver_open;
+	ulong driver_closed;
+	u32 timer_started;
+	u32 timer_set;
+	u32 threshold;
+	u32 soft_threshold;
+	u32 __iomem *timer_load_count_addr;
+	u32 __iomem *timer_current_value_addr;
+	u32 __iomem *timer_control_addr;
+	u32 __iomem *timer_clear_interrupt_addr;
+	u32 __iomem *timer_interrupt_status_addr;
+	struct sfi_timer_table_entry *timer_tbl_ptr;
+	struct notifier_block intel_scu_notifier;
+	struct miscdevice miscdev;
+};
+
+extern int sfi_mtimer_num;
+
+/* extern struct sfi_timer_table_entry *sfi_get_mtmr(int hint); */
+#endif /* __INTEL_SCU_WATCHDOG_H */
diff --git a/drivers/watchdog/it8712f_wdt.c b/drivers/watchdog/it8712f_wdt.c
index b32c6c0..6143f52 100644
--- a/drivers/watchdog/it8712f_wdt.c
+++ b/drivers/watchdog/it8712f_wdt.c
@@ -69,7 +69,7 @@ static unsigned short address;
 #define IT8712F_DEVID	0x8712
 
 #define LDN_GPIO	0x07	/* GPIO and Watch Dog Timer */
-#define LDN_GAME 	0x09	/* Game Port */
+#define LDN_GAME	0x09	/* Game Port */
 
 #define WDT_CONTROL	0x71	/* WDT Register: Control */
 #define WDT_CONFIG	0x72	/* WDT Register: Configuration */
diff --git a/drivers/watchdog/it87_wdt.c b/drivers/watchdog/it87_wdt.c
index dad2924..b1bc72f 100644
--- a/drivers/watchdog/it87_wdt.c
+++ b/drivers/watchdog/it87_wdt.c
@@ -12,7 +12,7 @@
  *		    http://www.ite.com.tw/
  *
  *	Support of the watchdog timers, which are available on
- *	IT8702, IT8712, IT8716, IT8718, IT8720 and IT8726.
+ *	IT8702, IT8712, IT8716, IT8718, IT8720, IT8721 and IT8726.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
@@ -45,7 +45,7 @@
 
 #include <asm/system.h>
 
-#define WATCHDOG_VERSION	"1.13"
+#define WATCHDOG_VERSION	"1.14"
 #define WATCHDOG_NAME		"IT87 WDT"
 #define PFX			WATCHDOG_NAME ": "
 #define DRIVER_VERSION		WATCHDOG_NAME " driver, v" WATCHDOG_VERSION "\n"
@@ -54,7 +54,7 @@
 /* Defaults for Module Parameter */
 #define DEFAULT_NOGAMEPORT	0
 #define DEFAULT_EXCLUSIVE	1
-#define DEFAULT_TIMEOUT 	60
+#define DEFAULT_TIMEOUT		60
 #define DEFAULT_TESTMODE	0
 #define DEFAULT_NOWAYOUT	WATCHDOG_NOWAYOUT
 
@@ -70,9 +70,9 @@
 /* Configuration Registers and Functions */
 #define LDNREG		0x07
 #define CHIPID		0x20
-#define CHIPREV 	0x22
+#define CHIPREV		0x22
 #define ACTREG		0x30
-#define BASEREG 	0x60
+#define BASEREG		0x60
 
 /* Chip Id numbers */
 #define NO_DEV_ID	0xffff
@@ -82,10 +82,11 @@
 #define IT8716_ID	0x8716
 #define IT8718_ID	0x8718
 #define IT8720_ID	0x8720
+#define IT8721_ID	0x8721
 #define IT8726_ID	0x8726	/* the data sheet suggest wrongly 0x8716 */
 
 /* GPIO Configuration Registers LDN=0x07 */
-#define WDTCTRL 	0x71
+#define WDTCTRL		0x71
 #define WDTCFG		0x72
 #define WDTVALLSB	0x73
 #define WDTVALMSB	0x74
@@ -94,7 +95,7 @@
 #define WDT_CIRINT	0x80
 #define WDT_MOUSEINT	0x40
 #define WDT_KYBINT	0x20
-#define WDT_GAMEPORT	0x10 /* not in it8718, it8720 */
+#define WDT_GAMEPORT	0x10 /* not in it8718, it8720, it8721 */
 #define WDT_FORCE	0x02
 #define WDT_ZERO	0x01
 
@@ -102,11 +103,11 @@
 #define WDT_TOV1	0x80
 #define WDT_KRST	0x40
 #define WDT_TOVE	0x20
-#define WDT_PWROK	0x10
+#define WDT_PWROK	0x10 /* not in it8721 */
 #define WDT_INT_MASK	0x0f
 
 /* CIR Configuration Register LDN=0x0a */
-#define CIR_ILS 	0x70
+#define CIR_ILS		0x70
 
 /* The default Base address is not always available, we use this */
 #define CIR_BASE	0x0208
@@ -134,7 +135,7 @@
 #define WDTS_USE_GP	4
 #define WDTS_EXPECTED	5
 
-static	unsigned int base, gpact, ciract, max_units;
+static	unsigned int base, gpact, ciract, max_units, chip_type;
 static	unsigned long wdt_status;
 static	DEFINE_SPINLOCK(spinlock);
 
@@ -215,7 +216,7 @@ static inline void superio_outw(int val, int reg)
 /* Internal function, should be called after superio_select(GPIO) */
 static void wdt_update_timeout(void)
 {
-	unsigned char cfg = WDT_KRST | WDT_PWROK;
+	unsigned char cfg = WDT_KRST;
 	int tm = timeout;
 
 	if (testmode)
@@ -226,6 +227,9 @@ static void wdt_update_timeout(void)
 	else
 		tm /= 60;
 
+	if (chip_type != IT8721_ID)
+		cfg |= WDT_PWROK;
+
 	superio_outb(cfg, WDTCFG);
 	superio_outb(tm, WDTVALLSB);
 	if (max_units > 255)
@@ -555,7 +559,6 @@ static int __init it87_wdt_init(void)
 {
 	int rc = 0;
 	int try_gameport = !nogameport;
-	u16 chip_type;
 	u8  chip_rev;
 	unsigned long flags;
 
@@ -581,6 +584,7 @@ static int __init it87_wdt_init(void)
 		break;
 	case IT8718_ID:
 	case IT8720_ID:
+	case IT8721_ID:
 		max_units = 65535;
 		try_gameport = 0;
 		break;
diff --git a/drivers/watchdog/jz4740_wdt.c b/drivers/watchdog/jz4740_wdt.c
new file mode 100644
index 0000000..684ba01
--- /dev/null
+++ b/drivers/watchdog/jz4740_wdt.c
@@ -0,0 +1,322 @@
+/*
+ *  Copyright (C) 2010, Paul Cercueil <paul@crapouillou.net>
+ *  JZ4740 Watchdog driver
+ *
+ *  This program is free software; you can redistribute it and/or modify it
+ *  under  the terms of the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the License, or (at your
+ *  option) any later version.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+#include <linux/watchdog.h>
+#include <linux/init.h>
+#include <linux/bitops.h>
+#include <linux/platform_device.h>
+#include <linux/spinlock.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
+#include <linux/device.h>
+#include <linux/clk.h>
+#include <linux/slab.h>
+
+#include <asm/mach-jz4740/timer.h>
+
+#define JZ_REG_WDT_TIMER_DATA     0x0
+#define JZ_REG_WDT_COUNTER_ENABLE 0x4
+#define JZ_REG_WDT_TIMER_COUNTER  0x8
+#define JZ_REG_WDT_TIMER_CONTROL  0xC
+
+#define JZ_WDT_CLOCK_PCLK 0x1
+#define JZ_WDT_CLOCK_RTC  0x2
+#define JZ_WDT_CLOCK_EXT  0x4
+
+#define WDT_IN_USE        0
+#define WDT_OK_TO_CLOSE   1
+
+#define JZ_WDT_CLOCK_DIV_SHIFT   3
+
+#define JZ_WDT_CLOCK_DIV_1    (0 << JZ_WDT_CLOCK_DIV_SHIFT)
+#define JZ_WDT_CLOCK_DIV_4    (1 << JZ_WDT_CLOCK_DIV_SHIFT)
+#define JZ_WDT_CLOCK_DIV_16   (2 << JZ_WDT_CLOCK_DIV_SHIFT)
+#define JZ_WDT_CLOCK_DIV_64   (3 << JZ_WDT_CLOCK_DIV_SHIFT)
+#define JZ_WDT_CLOCK_DIV_256  (4 << JZ_WDT_CLOCK_DIV_SHIFT)
+#define JZ_WDT_CLOCK_DIV_1024 (5 << JZ_WDT_CLOCK_DIV_SHIFT)
+
+#define DEFAULT_HEARTBEAT 5
+#define MAX_HEARTBEAT     2048
+
+static struct {
+	void __iomem *base;
+	struct resource	*mem;
+	struct clk *rtc_clk;
+	unsigned long status;
+} jz4740_wdt;
+
+static int heartbeat = DEFAULT_HEARTBEAT;
+
+
+static void jz4740_wdt_service(void)
+{
+	writew(0x0, jz4740_wdt.base + JZ_REG_WDT_TIMER_COUNTER);
+}
+
+static void jz4740_wdt_set_heartbeat(int new_heartbeat)
+{
+	unsigned int rtc_clk_rate;
+	unsigned int timeout_value;
+	unsigned short clock_div = JZ_WDT_CLOCK_DIV_1;
+
+	heartbeat = new_heartbeat;
+
+	rtc_clk_rate = clk_get_rate(jz4740_wdt.rtc_clk);
+
+	timeout_value = rtc_clk_rate * heartbeat;
+	while (timeout_value > 0xffff) {
+		if (clock_div == JZ_WDT_CLOCK_DIV_1024) {
+			/* Requested timeout too high;
+			* use highest possible value. */
+			timeout_value = 0xffff;
+			break;
+		}
+		timeout_value >>= 2;
+		clock_div += (1 << JZ_WDT_CLOCK_DIV_SHIFT);
+	}
+
+	writeb(0x0, jz4740_wdt.base + JZ_REG_WDT_COUNTER_ENABLE);
+	writew(clock_div, jz4740_wdt.base + JZ_REG_WDT_TIMER_CONTROL);
+
+	writew((u16)timeout_value, jz4740_wdt.base + JZ_REG_WDT_TIMER_DATA);
+	writew(0x0, jz4740_wdt.base + JZ_REG_WDT_TIMER_COUNTER);
+	writew(clock_div | JZ_WDT_CLOCK_RTC,
+		jz4740_wdt.base + JZ_REG_WDT_TIMER_CONTROL);
+
+	writeb(0x1, jz4740_wdt.base + JZ_REG_WDT_COUNTER_ENABLE);
+}
+
+static void jz4740_wdt_enable(void)
+{
+	jz4740_timer_enable_watchdog();
+	jz4740_wdt_set_heartbeat(heartbeat);
+}
+
+static void jz4740_wdt_disable(void)
+{
+	jz4740_timer_disable_watchdog();
+	writeb(0x0, jz4740_wdt.base + JZ_REG_WDT_COUNTER_ENABLE);
+}
+
+static int jz4740_wdt_open(struct inode *inode, struct file *file)
+{
+	if (test_and_set_bit(WDT_IN_USE, &jz4740_wdt.status))
+		return -EBUSY;
+
+	jz4740_wdt_enable();
+
+	return nonseekable_open(inode, file);
+}
+
+static ssize_t jz4740_wdt_write(struct file *file, const char *data,
+		size_t len, loff_t *ppos)
+{
+	if (len) {
+		size_t i;
+
+		clear_bit(WDT_OK_TO_CLOSE, &jz4740_wdt.status);
+		for (i = 0; i != len; i++) {
+			char c;
+
+			if (get_user(c, data + i))
+				return -EFAULT;
+
+			if (c == 'V')
+				set_bit(WDT_OK_TO_CLOSE, &jz4740_wdt.status);
+		}
+		jz4740_wdt_service();
+	}
+
+	return len;
+}
+
+static const struct watchdog_info ident = {
+	.options = WDIOF_KEEPALIVEPING,
+	.identity = "jz4740 Watchdog",
+};
+
+static long jz4740_wdt_ioctl(struct file *file,
+					unsigned int cmd, unsigned long arg)
+{
+	int ret = -ENOTTY;
+	int heartbeat_seconds;
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		ret = copy_to_user((struct watchdog_info *)arg, &ident,
+				sizeof(ident)) ? -EFAULT : 0;
+		break;
+
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		ret = put_user(0, (int *)arg);
+		break;
+
+	case WDIOC_KEEPALIVE:
+		jz4740_wdt_service();
+		return 0;
+
+	case WDIOC_SETTIMEOUT:
+		if (get_user(heartbeat_seconds, (int __user *)arg))
+			return -EFAULT;
+
+		jz4740_wdt_set_heartbeat(heartbeat_seconds);
+		return 0;
+
+	case WDIOC_GETTIMEOUT:
+		return put_user(heartbeat, (int *)arg);
+
+	default:
+		break;
+	}
+
+	return ret;
+}
+
+static int jz4740_wdt_release(struct inode *inode, struct file *file)
+{
+	jz4740_wdt_service();
+
+	if (test_and_clear_bit(WDT_OK_TO_CLOSE, &jz4740_wdt.status))
+		jz4740_wdt_disable();
+
+	clear_bit(WDT_IN_USE, &jz4740_wdt.status);
+	return 0;
+}
+
+static const struct file_operations jz4740_wdt_fops = {
+	.owner = THIS_MODULE,
+	.llseek = no_llseek,
+	.write = jz4740_wdt_write,
+	.unlocked_ioctl = jz4740_wdt_ioctl,
+	.open = jz4740_wdt_open,
+	.release = jz4740_wdt_release,
+};
+
+static struct miscdevice jz4740_wdt_miscdev = {
+	.minor = WATCHDOG_MINOR,
+	.name = "watchdog",
+	.fops = &jz4740_wdt_fops,
+};
+
+static int __devinit jz4740_wdt_probe(struct platform_device *pdev)
+{
+	int ret = 0, size;
+	struct resource *res;
+	struct device *dev = &pdev->dev;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
+		dev_err(dev, "failed to get memory region resource\n");
+		return -ENXIO;
+	}
+
+	size = resource_size(res);
+	jz4740_wdt.mem = request_mem_region(res->start, size, pdev->name);
+	if (jz4740_wdt.mem == NULL) {
+		dev_err(dev, "failed to get memory region\n");
+		return -EBUSY;
+	}
+
+	jz4740_wdt.base = ioremap_nocache(res->start, size);
+	if (jz4740_wdt.base == NULL) {
+		dev_err(dev, "failed to map memory region\n");
+		ret = -EBUSY;
+		goto err_release_region;
+	}
+
+	jz4740_wdt.rtc_clk = clk_get(NULL, "rtc");
+	if (IS_ERR(jz4740_wdt.rtc_clk)) {
+		dev_err(dev, "cannot find RTC clock\n");
+		ret = PTR_ERR(jz4740_wdt.rtc_clk);
+		goto err_iounmap;
+	}
+
+	ret = misc_register(&jz4740_wdt_miscdev);
+	if (ret < 0) {
+		dev_err(dev, "cannot register misc device\n");
+		goto err_disable_clk;
+	}
+
+	return 0;
+
+err_disable_clk:
+	clk_put(jz4740_wdt.rtc_clk);
+err_iounmap:
+	iounmap(jz4740_wdt.base);
+err_release_region:
+	release_mem_region(jz4740_wdt.mem->start,
+			resource_size(jz4740_wdt.mem));
+	return ret;
+}
+
+
+static int __devexit jz4740_wdt_remove(struct platform_device *pdev)
+{
+	jz4740_wdt_disable();
+	misc_deregister(&jz4740_wdt_miscdev);
+	clk_put(jz4740_wdt.rtc_clk);
+
+	iounmap(jz4740_wdt.base);
+	jz4740_wdt.base = NULL;
+
+	release_mem_region(jz4740_wdt.mem->start,
+				resource_size(jz4740_wdt.mem));
+	jz4740_wdt.mem = NULL;
+
+	return 0;
+}
+
+
+static struct platform_driver jz4740_wdt_driver = {
+	.probe = jz4740_wdt_probe,
+	.remove = __devexit_p(jz4740_wdt_remove),
+	.driver = {
+		.name = "jz4740-wdt",
+		.owner	= THIS_MODULE,
+	},
+};
+
+
+static int __init jz4740_wdt_init(void)
+{
+	return platform_driver_register(&jz4740_wdt_driver);
+}
+module_init(jz4740_wdt_init);
+
+static void __exit jz4740_wdt_exit(void)
+{
+	platform_driver_unregister(&jz4740_wdt_driver);
+}
+module_exit(jz4740_wdt_exit);
+
+MODULE_AUTHOR("Paul Cercueil <paul@crapouillou.net>");
+MODULE_DESCRIPTION("jz4740 Watchdog Driver");
+
+module_param(heartbeat, int, 0);
+MODULE_PARM_DESC(heartbeat,
+		"Watchdog heartbeat period in seconds from 1 to "
+		__MODULE_STRING(MAX_HEARTBEAT) ", default "
+		__MODULE_STRING(DEFAULT_HEARTBEAT));
+
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+MODULE_ALIAS("platform:jz4740-wdt");
diff --git a/drivers/watchdog/machzwd.c b/drivers/watchdog/machzwd.c
index 9280350..1332b83 100644
--- a/drivers/watchdog/machzwd.c
+++ b/drivers/watchdog/machzwd.c
@@ -54,7 +54,7 @@
 
 /* indexes */			/* size */
 #define ZFL_VERSION	0x02	/* 16   */
-#define CONTROL 	0x10	/* 16   */
+#define CONTROL		0x10	/* 16   */
 #define STATUS		0x12	/* 8    */
 #define COUNTER_1	0x0C	/* 16   */
 #define COUNTER_2	0x0E	/* 8    */
diff --git a/drivers/watchdog/max63xx_wdt.c b/drivers/watchdog/max63xx_wdt.c
index 3053ff0..7a82ce5 100644
--- a/drivers/watchdog/max63xx_wdt.c
+++ b/drivers/watchdog/max63xx_wdt.c
@@ -41,7 +41,7 @@ static int nowayout  = WATCHDOG_NOWAYOUT;
  * to ping the watchdog.
  */
 #define MAX6369_WDSET	(7 << 0)
-#define MAX6369_WDI   	(1 << 3)
+#define MAX6369_WDI	(1 << 3)
 
 static DEFINE_SPINLOCK(io_lock);
 
diff --git a/drivers/watchdog/mpc8xxx_wdt.c b/drivers/watchdog/mpc8xxx_wdt.c
index 8fa213c..3dee837 100644
--- a/drivers/watchdog/mpc8xxx_wdt.c
+++ b/drivers/watchdog/mpc8xxx_wdt.c
@@ -2,9 +2,9 @@
  * mpc8xxx_wdt.c - MPC8xx/MPC83xx/MPC86xx watchdog userspace interface
  *
  * Authors: Dave Updegraff <dave@cray.org>
- * 	    Kumar Gala <galak@kernel.crashing.org>
- * 		Attribution: from 83xx_wst: Florian Schirmer <jolt@tuxbox.org>
- * 				..and from sc520_wdt
+ *	    Kumar Gala <galak@kernel.crashing.org>
+ *		Attribution: from 83xx_wst: Florian Schirmer <jolt@tuxbox.org>
+ *				..and from sc520_wdt
  * Copyright (c) 2008  MontaVista Software, Inc.
  *                     Anton Vorontsov <avorontsov@ru.mvista.com>
  *
diff --git a/drivers/watchdog/mpcore_wdt.c b/drivers/watchdog/mpcore_wdt.c
index b8ec7ac..2b4af22 100644
--- a/drivers/watchdog/mpcore_wdt.c
+++ b/drivers/watchdog/mpcore_wdt.c
@@ -172,7 +172,7 @@ static int mpcore_wdt_release(struct inode *inode, struct file *file)
 
 	/*
 	 *	Shut off the timer.
-	 * 	Lock it in if it's a module and we set nowayout
+	 *	Lock it in if it's a module and we set nowayout
 	 */
 	if (wdt->expect_close == 42)
 		mpcore_wdt_stop(wdt);
diff --git a/drivers/watchdog/mtx-1_wdt.c b/drivers/watchdog/mtx-1_wdt.c
index 08e8a6a..5ec5ac1 100644
--- a/drivers/watchdog/mtx-1_wdt.c
+++ b/drivers/watchdog/mtx-1_wdt.c
@@ -190,19 +190,19 @@ static ssize_t mtx1_wdt_write(struct file *file, const char *buf,
 }
 
 static const struct file_operations mtx1_wdt_fops = {
-	.owner 		= THIS_MODULE,
+	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.unlocked_ioctl	= mtx1_wdt_ioctl,
-	.open 		= mtx1_wdt_open,
-	.write 		= mtx1_wdt_write,
-	.release 	= mtx1_wdt_release,
+	.open		= mtx1_wdt_open,
+	.write		= mtx1_wdt_write,
+	.release	= mtx1_wdt_release,
 };
 
 
 static struct miscdevice mtx1_wdt_misc = {
-	.minor 	= WATCHDOG_MINOR,
-	.name 	= "watchdog",
-	.fops 	= &mtx1_wdt_fops,
+	.minor	= WATCHDOG_MINOR,
+	.name	= "watchdog",
+	.fops	= &mtx1_wdt_fops,
 };
 
 
diff --git a/drivers/watchdog/nv_tco.c b/drivers/watchdog/nv_tco.c
index 1a50aa7..267377a 100644
--- a/drivers/watchdog/nv_tco.c
+++ b/drivers/watchdog/nv_tco.c
@@ -289,7 +289,7 @@ static struct miscdevice nv_tco_miscdev = {
  * register a pci_driver, because someone else might one day
  * want to register another driver on the same PCI id.
  */
-static struct pci_device_id tco_pci_tbl[] = {
+static DEFINE_PCI_DEVICE_TABLE(tco_pci_tbl) = {
 	{ PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_SMBUS,
 	  PCI_ANY_ID, PCI_ANY_ID, },
 	{ PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SMBUS,
diff --git a/drivers/watchdog/omap_wdt.h b/drivers/watchdog/omap_wdt.h
index fc02ec6..09b774c 100644
--- a/drivers/watchdog/omap_wdt.h
+++ b/drivers/watchdog/omap_wdt.h
@@ -44,7 +44,7 @@
  * months before firing.  These limits work without scaling,
  * with the 60 second default assumed by most tools and docs.
  */
-#define TIMER_MARGIN_MAX    	(24 * 60 * 60)	/* 1 day */
+#define TIMER_MARGIN_MAX	(24 * 60 * 60)	/* 1 day */
 #define TIMER_MARGIN_DEFAULT	60	/* 60 secs */
 #define TIMER_MARGIN_MIN	1
 
diff --git a/drivers/watchdog/pc87413_wdt.c b/drivers/watchdog/pc87413_wdt.c
index 3a56bc3..139d773 100644
--- a/drivers/watchdog/pc87413_wdt.c
+++ b/drivers/watchdog/pc87413_wdt.c
@@ -514,7 +514,7 @@ static struct miscdevice pc87413_miscdev = {
 /* -- Module init functions -------------------------------------*/
 
 /**
- * 	pc87413_init: module's "constructor"
+ *	pc87413_init: module's "constructor"
  *
  *	Set up the WDT watchdog board. All we have to do is grab the
  *	resources we require and bitch if anyone beat us to them.
diff --git a/drivers/watchdog/pcwd_pci.c b/drivers/watchdog/pcwd_pci.c
index 64374d6..b8d14f8 100644
--- a/drivers/watchdog/pcwd_pci.c
+++ b/drivers/watchdog/pcwd_pci.c
@@ -817,7 +817,7 @@ static void __devexit pcipcwd_card_exit(struct pci_dev *pdev)
 	cards_found--;
 }
 
-static struct pci_device_id pcipcwd_pci_tbl[] = {
+static DEFINE_PCI_DEVICE_TABLE(pcipcwd_pci_tbl) = {
 	{ PCI_VENDOR_ID_QUICKLOGIC, PCI_DEVICE_ID_WATCHDOG_PCIPCWD,
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{ 0 },			/* End of list */
diff --git a/drivers/watchdog/pnx4008_wdt.c b/drivers/watchdog/pnx4008_wdt.c
index bf5b97c..c7cf4cb 100644
--- a/drivers/watchdog/pnx4008_wdt.c
+++ b/drivers/watchdog/pnx4008_wdt.c
@@ -4,7 +4,7 @@
  * Watchdog driver for PNX4008 board
  *
  * Authors: Dmitry Chigirev <source@mvista.com>,
- * 	    Vitaly Wool <vitalywool@gmail.com>
+ *	    Vitaly Wool <vitalywool@gmail.com>
  * Based on sa1100 driver,
  * Copyright (C) 2000 Oleg Drokin <green@crimea.edu>
  *
diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index ae53662..25b39bf 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -224,7 +224,7 @@ static int s3c2410wdt_release(struct inode *inode, struct file *file)
 {
 	/*
 	 *	Shut off the timer.
-	 * 	Lock it in if it's a module and we set nowayout
+	 *	Lock it in if it's a module and we set nowayout
 	 */
 
 	if (expect_close == 42)
diff --git a/drivers/watchdog/sbc8360.c b/drivers/watchdog/sbc8360.c
index 68e2e2d..514ec23 100644
--- a/drivers/watchdog/sbc8360.c
+++ b/drivers/watchdog/sbc8360.c
@@ -114,7 +114,7 @@ static char expect_close;
  *	C |	6.5s	65s	650s	1300s
  *	D |	7s	70s	700s	1400s
  *	E |	7.5s	75s	750s	1500s
- *	F |	8s	80s 	800s 	1600s
+ *	F |	8s	80s	800s	1600s
  *
  * Another way to say the same things is:
  *  For N=1, Timeout = (M+1) * 0.5s
diff --git a/drivers/watchdog/sbc_fitpc2_wdt.c b/drivers/watchdog/sbc_fitpc2_wdt.c
index 7990625..d5d3994 100644
--- a/drivers/watchdog/sbc_fitpc2_wdt.c
+++ b/drivers/watchdog/sbc_fitpc2_wdt.c
@@ -41,7 +41,7 @@ static DEFINE_MUTEX(wdt_lock);
 #define IFACE_ON_COMMAND	1
 #define REBOOT_COMMAND		2
 
-#define WATCHDOG_NAME 		"SBC-FITPC2 Watchdog"
+#define WATCHDOG_NAME		"SBC-FITPC2 Watchdog"
 
 static void wdt_send_data(unsigned char command, unsigned char data)
 {
diff --git a/drivers/watchdog/smsc37b787_wdt.c b/drivers/watchdog/smsc37b787_wdt.c
index 8a1f0bc..df88cfa 100644
--- a/drivers/watchdog/smsc37b787_wdt.c
+++ b/drivers/watchdog/smsc37b787_wdt.c
@@ -434,11 +434,11 @@ static long wb_smsc_wdt_ioctl(struct file *file,
 	} uarg;
 
 	static const struct watchdog_info ident = {
-		.options = 		WDIOF_KEEPALIVEPING |
+		.options =		WDIOF_KEEPALIVEPING |
 					WDIOF_SETTIMEOUT |
 					WDIOF_MAGICCLOSE,
 		.firmware_version =	0,
-		.identity = 		"SMsC 37B787 Watchdog",
+		.identity =		"SMsC 37B787 Watchdog",
 	};
 
 	uarg.i = (int __user *)arg;
diff --git a/drivers/watchdog/softdog.c b/drivers/watchdog/softdog.c
index 833f49f..100b114 100644
--- a/drivers/watchdog/softdog.c
+++ b/drivers/watchdog/softdog.c
@@ -151,7 +151,7 @@ static int softdog_release(struct inode *inode, struct file *file)
 {
 	/*
 	 *	Shut off the timer.
-	 * 	Lock it in if it's a module and we set nowayout
+	 *	Lock it in if it's a module and we set nowayout
 	 */
 	if (expect_close == 42) {
 		softdog_stop();
diff --git a/drivers/watchdog/sp5100_tco.c b/drivers/watchdog/sp5100_tco.c
index 8083728..1bc4938 100644
--- a/drivers/watchdog/sp5100_tco.c
+++ b/drivers/watchdog/sp5100_tco.c
@@ -259,7 +259,7 @@ static struct miscdevice sp5100_tco_miscdev = {
  * register a pci_driver, because someone else might
  * want to register another driver on the same PCI id.
  */
-static struct pci_device_id sp5100_tco_pci_tbl[] = {
+static DEFINE_PCI_DEVICE_TABLE(sp5100_tco_pci_tbl) = {
 	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS, PCI_ANY_ID,
 	  PCI_ANY_ID, },
 	{ 0, },			/* End of list */
diff --git a/drivers/watchdog/ts72xx_wdt.c b/drivers/watchdog/ts72xx_wdt.c
index 18cdeb4..5a90a4a 100644
--- a/drivers/watchdog/ts72xx_wdt.c
+++ b/drivers/watchdog/ts72xx_wdt.c
@@ -68,7 +68,7 @@ struct platform_device *ts72xx_wdt_pdev;
  * to control register):
  *	value	description
  *	-------------------------
- * 	0x00	watchdog disabled
+ *	0x00	watchdog disabled
  *	0x01	250ms
  *	0x02	500ms
  *	0x03	1s
diff --git a/drivers/watchdog/w83697ug_wdt.c b/drivers/watchdog/w83697ug_wdt.c
index df2a64d..be9c4d8 100644
--- a/drivers/watchdog/w83697ug_wdt.c
+++ b/drivers/watchdog/w83697ug_wdt.c
@@ -87,10 +87,10 @@ static int w83697ug_select_wd_register(void)
 	outb_p(0x87, WDT_EFER); /* Enter extended function mode */
 	outb_p(0x87, WDT_EFER); /* Again according to manual */
 
-	outb(0x20, WDT_EFER); 	/* check chip version	*/
+	outb(0x20, WDT_EFER);	/* check chip version	*/
 	version = inb(WDT_EFDR);
 
-	if (version == 0x68) {	/* W83697UG 		*/
+	if (version == 0x68) {	/* W83697UG		*/
 		printk(KERN_INFO PFX "Watchdog chip version 0x%02x = "
 			"W83697UG/UF found at 0x%04x\n", version, wdt_io);
 
diff --git a/drivers/watchdog/wdt.c b/drivers/watchdog/wdt.c
index 552a438..bb03e15 100644
--- a/drivers/watchdog/wdt.c
+++ b/drivers/watchdog/wdt.c
@@ -581,7 +581,7 @@ static void __exit wdt_exit(void)
 }
 
 /**
- * 	wdt_init:
+ *	wdt_init:
  *
  *	Set up the WDT watchdog board. All we have to do is grab the
  *	resources we require and bitch if anyone beat us to them.
diff --git a/drivers/watchdog/wdt977.c b/drivers/watchdog/wdt977.c
index 5c2521f..a2f01c9 100644
--- a/drivers/watchdog/wdt977.c
+++ b/drivers/watchdog/wdt977.c
@@ -281,7 +281,7 @@ static int wdt977_release(struct inode *inode, struct file *file)
 {
 	/*
 	 *	Shut off the timer.
-	 * 	Lock it in if it's a module and we set nowayout
+	 *	Lock it in if it's a module and we set nowayout
 	 */
 	if (expect_close == 42) {
 		wdt977_stop();
diff --git a/drivers/watchdog/wdt_pci.c b/drivers/watchdog/wdt_pci.c
index 6130c88..172dad6 100644
--- a/drivers/watchdog/wdt_pci.c
+++ b/drivers/watchdog/wdt_pci.c
@@ -31,7 +31,7 @@
  *		Jeff Garzik	:	PCI cleanups
  *		Tigran Aivazian	:	Restructured wdtpci_init_one() to handle
  *					failures
- *		Joel Becker 	:	Added WDIOC_GET/SETTIMEOUT
+ *		Joel Becker	:	Added WDIOC_GET/SETTIMEOUT
  *		Zwane Mwaikambo	:	Magic char closing, locking changes,
  *					cleanups
  *		Matt Domsch	:	nowayout module option
@@ -727,7 +727,7 @@ static void __devexit wdtpci_remove_one(struct pci_dev *pdev)
 }
 
 
-static struct pci_device_id wdtpci_pci_tbl[] = {
+static DEFINE_PCI_DEVICE_TABLE(wdtpci_pci_tbl) = {
 	{
 		.vendor	   = PCI_VENDOR_ID_ACCESSIO,
 		.device	   = PCI_DEVICE_ID_ACCESSIO_WDG_CSM,
@@ -764,7 +764,7 @@ static void __exit wdtpci_cleanup(void)
 
 
 /**
- * 	wdtpci_init:
+ *	wdtpci_init:
  *
  *	Set up the WDT watchdog board. All we have to do is grab the
  *	resources we require and bitch if anyone beat us to them.
diff --git a/drivers/watchdog/xen_wdt.c b/drivers/watchdog/xen_wdt.c
new file mode 100644
index 0000000..49bd9d3
--- /dev/null
+++ b/drivers/watchdog/xen_wdt.c
@@ -0,0 +1,359 @@
+/*
+ *	Xen Watchdog Driver
+ *
+ *	(c) Copyright 2010 Novell, Inc.
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	as published by the Free Software Foundation; either version
+ *	2 of the License, or (at your option) any later version.
+ */
+
+#define DRV_NAME	"wdt"
+#define DRV_VERSION	"0.01"
+#define PFX		DRV_NAME ": "
+
+#include <linux/bug.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/hrtimer.h>
+#include <linux/kernel.h>
+#include <linux/ktime.h>
+#include <linux/init.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/platform_device.h>
+#include <linux/spinlock.h>
+#include <linux/uaccess.h>
+#include <linux/watchdog.h>
+#include <xen/xen.h>
+#include <asm/xen/hypercall.h>
+#include <xen/interface/sched.h>
+
+static struct platform_device *platform_device;
+static DEFINE_SPINLOCK(wdt_lock);
+static struct sched_watchdog wdt;
+static __kernel_time_t wdt_expires;
+static bool is_active, expect_release;
+
+#define WATCHDOG_TIMEOUT 60 /* in seconds */
+static unsigned int timeout = WATCHDOG_TIMEOUT;
+module_param(timeout, uint, S_IRUGO);
+MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds "
+	"(default=" __MODULE_STRING(WATCHDOG_TIMEOUT) ")");
+
+static bool nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, bool, S_IRUGO);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started "
+	"(default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+static inline __kernel_time_t set_timeout(void)
+{
+	wdt.timeout = timeout;
+	return ktime_to_timespec(ktime_get()).tv_sec + timeout;
+}
+
+static int xen_wdt_start(void)
+{
+	__kernel_time_t expires;
+	int err;
+
+	spin_lock(&wdt_lock);
+
+	expires = set_timeout();
+	if (!wdt.id)
+		err = HYPERVISOR_sched_op(SCHEDOP_watchdog, &wdt);
+	else
+		err = -EBUSY;
+	if (err > 0) {
+		wdt.id = err;
+		wdt_expires = expires;
+		err = 0;
+	} else
+		BUG_ON(!err);
+
+	spin_unlock(&wdt_lock);
+
+	return err;
+}
+
+static int xen_wdt_stop(void)
+{
+	int err = 0;
+
+	spin_lock(&wdt_lock);
+
+	wdt.timeout = 0;
+	if (wdt.id)
+		err = HYPERVISOR_sched_op(SCHEDOP_watchdog, &wdt);
+	if (!err)
+		wdt.id = 0;
+
+	spin_unlock(&wdt_lock);
+
+	return err;
+}
+
+static int xen_wdt_kick(void)
+{
+	__kernel_time_t expires;
+	int err;
+
+	spin_lock(&wdt_lock);
+
+	expires = set_timeout();
+	if (wdt.id)
+		err = HYPERVISOR_sched_op(SCHEDOP_watchdog, &wdt);
+	else
+		err = -ENXIO;
+	if (!err)
+		wdt_expires = expires;
+
+	spin_unlock(&wdt_lock);
+
+	return err;
+}
+
+static int xen_wdt_open(struct inode *inode, struct file *file)
+{
+	int err;
+
+	/* /dev/watchdog can only be opened once */
+	if (xchg(&is_active, true))
+		return -EBUSY;
+
+	err = xen_wdt_start();
+	if (err == -EBUSY)
+		err = xen_wdt_kick();
+	return err ?: nonseekable_open(inode, file);
+}
+
+static int xen_wdt_release(struct inode *inode, struct file *file)
+{
+	if (expect_release)
+		xen_wdt_stop();
+	else {
+		printk(KERN_CRIT PFX
+		       "unexpected close, not stopping watchdog!\n");
+		xen_wdt_kick();
+	}
+	is_active = false;
+	expect_release = false;
+	return 0;
+}
+
+static ssize_t xen_wdt_write(struct file *file, const char __user *data,
+			     size_t len, loff_t *ppos)
+{
+	/* See if we got the magic character 'V' and reload the timer */
+	if (len) {
+		if (!nowayout) {
+			size_t i;
+
+			/* in case it was set long ago */
+			expect_release = false;
+
+			/* scan to see whether or not we got the magic
+			   character */
+			for (i = 0; i != len; i++) {
+				char c;
+				if (get_user(c, data + i))
+					return -EFAULT;
+				if (c == 'V')
+					expect_release = true;
+			}
+		}
+
+		/* someone wrote to us, we should reload the timer */
+		xen_wdt_kick();
+	}
+	return len;
+}
+
+static long xen_wdt_ioctl(struct file *file, unsigned int cmd,
+			  unsigned long arg)
+{
+	int new_options, retval = -EINVAL;
+	int new_timeout;
+	int __user *argp = (void __user *)arg;
+	static const struct watchdog_info ident = {
+		.options =		WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE,
+		.firmware_version =	0,
+		.identity =		DRV_NAME,
+	};
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
+
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, argp);
+
+	case WDIOC_SETOPTIONS:
+		if (get_user(new_options, argp))
+			return -EFAULT;
+
+		if (new_options & WDIOS_DISABLECARD)
+			retval = xen_wdt_stop();
+		if (new_options & WDIOS_ENABLECARD) {
+			retval = xen_wdt_start();
+			if (retval == -EBUSY)
+				retval = xen_wdt_kick();
+		}
+		return retval;
+
+	case WDIOC_KEEPALIVE:
+		xen_wdt_kick();
+		return 0;
+
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_timeout, argp))
+			return -EFAULT;
+		if (!new_timeout)
+			return -EINVAL;
+		timeout = new_timeout;
+		xen_wdt_kick();
+		/* fall through */
+	case WDIOC_GETTIMEOUT:
+		return put_user(timeout, argp);
+
+	case WDIOC_GETTIMELEFT:
+		retval = wdt_expires - ktime_to_timespec(ktime_get()).tv_sec;
+		return put_user(retval, argp);
+	}
+
+	return -ENOTTY;
+}
+
+static const struct file_operations xen_wdt_fops = {
+	.owner =		THIS_MODULE,
+	.llseek =		no_llseek,
+	.write =		xen_wdt_write,
+	.unlocked_ioctl =	xen_wdt_ioctl,
+	.open =			xen_wdt_open,
+	.release =		xen_wdt_release,
+};
+
+static struct miscdevice xen_wdt_miscdev = {
+	.minor =	WATCHDOG_MINOR,
+	.name =		"watchdog",
+	.fops =		&xen_wdt_fops,
+};
+
+static int __devinit xen_wdt_probe(struct platform_device *dev)
+{
+	struct sched_watchdog wd = { .id = ~0 };
+	int ret = HYPERVISOR_sched_op(SCHEDOP_watchdog, &wd);
+
+	switch (ret) {
+	case -EINVAL:
+		if (!timeout) {
+			timeout = WATCHDOG_TIMEOUT;
+			printk(KERN_INFO PFX
+			       "timeout value invalid, using %d\n", timeout);
+		}
+
+		ret = misc_register(&xen_wdt_miscdev);
+		if (ret) {
+			printk(KERN_ERR PFX
+			       "cannot register miscdev on minor=%d (%d)\n",
+			       WATCHDOG_MINOR, ret);
+			break;
+		}
+
+		printk(KERN_INFO PFX
+		       "initialized (timeout=%ds, nowayout=%d)\n",
+		       timeout, nowayout);
+		break;
+
+	case -ENOSYS:
+		printk(KERN_INFO PFX "not supported\n");
+		ret = -ENODEV;
+		break;
+
+	default:
+		printk(KERN_INFO PFX "bogus return value %d\n", ret);
+		break;
+	}
+
+	return ret;
+}
+
+static int __devexit xen_wdt_remove(struct platform_device *dev)
+{
+	/* Stop the timer before we leave */
+	if (!nowayout)
+		xen_wdt_stop();
+
+	misc_deregister(&xen_wdt_miscdev);
+
+	return 0;
+}
+
+static void xen_wdt_shutdown(struct platform_device *dev)
+{
+	xen_wdt_stop();
+}
+
+static int xen_wdt_suspend(struct platform_device *dev, pm_message_t state)
+{
+	return xen_wdt_stop();
+}
+
+static int xen_wdt_resume(struct platform_device *dev)
+{
+	return xen_wdt_start();
+}
+
+static struct platform_driver xen_wdt_driver = {
+	.probe          = xen_wdt_probe,
+	.remove         = __devexit_p(xen_wdt_remove),
+	.shutdown       = xen_wdt_shutdown,
+	.suspend        = xen_wdt_suspend,
+	.resume         = xen_wdt_resume,
+	.driver         = {
+		.owner  = THIS_MODULE,
+		.name   = DRV_NAME,
+	},
+};
+
+static int __init xen_wdt_init_module(void)
+{
+	int err;
+
+	if (!xen_domain())
+		return -ENODEV;
+
+	printk(KERN_INFO PFX "Xen WatchDog Timer Driver v%s\n", DRV_VERSION);
+
+	err = platform_driver_register(&xen_wdt_driver);
+	if (err)
+		return err;
+
+	platform_device = platform_device_register_simple(DRV_NAME,
+								  -1, NULL, 0);
+	if (IS_ERR(platform_device)) {
+		err = PTR_ERR(platform_device);
+		platform_driver_unregister(&xen_wdt_driver);
+	}
+
+	return err;
+}
+
+static void __exit xen_wdt_cleanup_module(void)
+{
+	platform_device_unregister(platform_device);
+	platform_driver_unregister(&xen_wdt_driver);
+	printk(KERN_INFO PFX "module unloaded\n");
+}
+
+module_init(xen_wdt_init_module);
+module_exit(xen_wdt_cleanup_module);
+
+MODULE_AUTHOR("Jan Beulich <jbeulich@novell.com>");
+MODULE_DESCRIPTION("Xen WatchDog Timer Driver");
+MODULE_VERSION(DRV_VERSION);
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/include/xen/interface/sched.h b/include/xen/interface/sched.h
index 5fec575..dd55dac 100644
--- a/include/xen/interface/sched.h
+++ b/include/xen/interface/sched.h
@@ -65,6 +65,39 @@ struct sched_poll {
 DEFINE_GUEST_HANDLE_STRUCT(sched_poll);
 
 /*
+ * Declare a shutdown for another domain. The main use of this function is
+ * in interpreting shutdown requests and reasons for fully-virtualized
+ * domains.  A para-virtualized domain may use SCHEDOP_shutdown directly.
+ * @arg == pointer to sched_remote_shutdown structure.
+ */
+#define SCHEDOP_remote_shutdown        4
+struct sched_remote_shutdown {
+    domid_t domain_id;         /* Remote domain ID */
+    unsigned int reason;       /* SHUTDOWN_xxx reason */
+};
+
+/*
+ * Latch a shutdown code, so that when the domain later shuts down it
+ * reports this code to the control tools.
+ * @arg == as for SCHEDOP_shutdown.
+ */
+#define SCHEDOP_shutdown_code 5
+
+/*
+ * Setup, poke and destroy a domain watchdog timer.
+ * @arg == pointer to sched_watchdog structure.
+ * With id == 0, setup a domain watchdog timer to cause domain shutdown
+ *               after timeout, returns watchdog id.
+ * With id != 0 and timeout == 0, destroy domain watchdog timer.
+ * With id != 0 and timeout != 0, poke watchdog timer and set new timeout.
+ */
+#define SCHEDOP_watchdog    6
+struct sched_watchdog {
+    uint32_t id;                /* watchdog ID */
+    uint32_t timeout;           /* timeout */
+};
+
+/*
  * Reason codes for SCHEDOP_shutdown. These may be interpreted by control
  * software to determine the appropriate action. For the most part, Xen does
  * not care about the shutdown code.
@@ -73,5 +106,6 @@ DEFINE_GUEST_HANDLE_STRUCT(sched_poll);
 #define SHUTDOWN_reboot     1  /* Clean up, kill, and then restart.          */
 #define SHUTDOWN_suspend    2  /* Clean up, save suspend info, kill.         */
 #define SHUTDOWN_crash      3  /* Tell controller we've crashed.             */
+#define SHUTDOWN_watchdog   4  /* Restart because watchdog time expired.     */
 
 #endif /* __XEN_PUBLIC_SCHED_H__ */
