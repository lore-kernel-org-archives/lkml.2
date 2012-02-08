Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245Ab2BHA4E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 19:56:04 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:36216 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756602Ab2BHAz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 19:55:59 -0500
Message-ID: <1328662556.15787.8.camel@joe2Laptop>
Subject: [PATCH next] watchdog: Use pr_<fmt> and pr_<level>
From: Joe Perches <joe@perches.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-watchdog <linux-watchdog@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 07 Feb 2012 16:55:56 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the current logging styles.

Make sure all output has a prefix.
Add missing newlines.
Remove now unnecessary PFX, NAME, and miscellaneous other #defines.
Coalesce formats.

Signed-off-by: Joe Perches <joe@perches.com>
---
Compiled x86 allyesconfig only.

 drivers/watchdog/acquirewdt.c          |   24 +++----
 drivers/watchdog/advantechwdt.c        |   30 +++-----
 drivers/watchdog/alim1535_wdt.c        |   21 +++---
 drivers/watchdog/alim7101_wdt.c        |   51 +++++---------
 drivers/watchdog/ar7_wdt.c             |   34 ++++-----
 drivers/watchdog/at91rm9200_wdt.c      |   10 ++-
 drivers/watchdog/at91sam9_wdt.c        |    8 ++-
 drivers/watchdog/ath79_wdt.c           |    5 +-
 drivers/watchdog/bcm47xx_wdt.c         |   14 ++--
 drivers/watchdog/bcm63xx_wdt.c         |    7 +-
 drivers/watchdog/bfin_wdt.c            |   27 +++-----
 drivers/watchdog/booke_wdt.c           |   14 ++--
 drivers/watchdog/cpu5wdt.c             |   19 +++---
 drivers/watchdog/cpwd.c                |   20 +++---
 drivers/watchdog/dw_wdt.c              |    3 +-
 drivers/watchdog/ep93xx_wdt.c          |   12 ++--
 drivers/watchdog/eurotechwdt.c         |   28 ++++----
 drivers/watchdog/f71808e_wdt.c         |   40 +++++------
 drivers/watchdog/gef_wdt.c             |   11 ++--
 drivers/watchdog/geodewdt.c            |    5 +-
 drivers/watchdog/hpwdt.c               |   27 +++-----
 drivers/watchdog/i6300esb.c            |   35 ++++-----
 drivers/watchdog/iTCO_vendor_support.c |    7 +-
 drivers/watchdog/iTCO_wdt.c            |   55 ++++++--------
 drivers/watchdog/ib700wdt.c            |   22 +++----
 drivers/watchdog/ibmasr.c              |   14 ++--
 drivers/watchdog/indydog.c             |   20 ++---
 drivers/watchdog/intel_scu_watchdog.c  |   71 +++++++++----------
 drivers/watchdog/intel_scu_watchdog.h  |    1 -
 drivers/watchdog/iop_wdt.c             |   11 ++--
 drivers/watchdog/it8712f_wdt.c         |   35 +++++-----
 drivers/watchdog/it87_wdt.c            |   42 +++++-------
 drivers/watchdog/ixp2000_wdt.c         |    7 +-
 drivers/watchdog/ixp4xx_wdt.c          |   11 ++--
 drivers/watchdog/ks8695_wdt.c          |    6 +-
 drivers/watchdog/lantiq_wdt.c          |    4 +-
 drivers/watchdog/m54xx_wdt.c           |   10 ++--
 drivers/watchdog/machzwd.c             |   33 ++++-----
 drivers/watchdog/mixcomwd.c            |   25 +++----
 drivers/watchdog/mpc8xxx_wdt.c         |   13 ++--
 drivers/watchdog/mpcore_wdt.c          |   11 ++--
 drivers/watchdog/mv64x60_wdt.c         |   11 ++--
 drivers/watchdog/nv_tco.c              |   42 +++++------
 drivers/watchdog/octeon-wdt-main.c     |   12 ++--
 drivers/watchdog/of_xilinx_wdt.c       |   41 +++++------
 drivers/watchdog/omap_wdt.c            |    4 +-
 drivers/watchdog/orion_wdt.c           |   11 ++--
 drivers/watchdog/pc87413_wdt.c         |   53 ++++++--------
 drivers/watchdog/pcwd.c                |  123 +++++++++++++-------------------
 drivers/watchdog/pcwd_pci.c            |  109 ++++++++++++----------------
 drivers/watchdog/pcwd_usb.c            |   74 +++++++++----------
 drivers/watchdog/pika_wdt.c            |   19 +++---
 drivers/watchdog/pnx4008_wdt.c         |   14 ++--
 drivers/watchdog/pnx833x_wdt.c         |   26 +++----
 drivers/watchdog/rc32434_wdt.c         |   29 +++-----
 drivers/watchdog/riowd.c               |   10 ++-
 drivers/watchdog/s3c2410_wdt.c         |   25 +++----
 drivers/watchdog/sa1100_wdt.c          |   10 ++-
 drivers/watchdog/sb_wdog.c             |   29 ++++----
 drivers/watchdog/sbc60xxwdt.c          |   37 ++++------
 drivers/watchdog/sbc7240_wdt.c         |   40 ++++-------
 drivers/watchdog/sbc8360.c             |   20 +++---
 drivers/watchdog/sbc_epx_c3.c          |   19 ++---
 drivers/watchdog/sbc_fitpc2_wdt.c      |    9 +--
 drivers/watchdog/sc1200wdt.c           |   30 ++++-----
 drivers/watchdog/sc520_wdt.c           |   35 ++++------
 drivers/watchdog/sch311x_wdt.c         |   13 ++--
 drivers/watchdog/scx200_wdt.c          |   21 +++---
 drivers/watchdog/shwdt.c               |   15 +++--
 drivers/watchdog/smsc37b787_wdt.c      |   38 ++++------
 drivers/watchdog/softdog.c             |   35 ++++------
 drivers/watchdog/sp5100_tco.c          |   31 ++++-----
 drivers/watchdog/stmp3xxx_wdt.c        |    6 +-
 drivers/watchdog/txx9wdt.c             |   11 ++--
 drivers/watchdog/via_wdt.c             |    3 +
 drivers/watchdog/w83627hf_wdt.c        |   34 ++++-----
 drivers/watchdog/w83697hf_wdt.c        |   39 ++++------
 drivers/watchdog/w83697ug_wdt.c        |   34 ++++-----
 drivers/watchdog/w83877f_wdt.c         |   36 ++++------
 drivers/watchdog/w83977f_wdt.c         |   34 ++++-----
 drivers/watchdog/wafer5823wdt.c        |   30 +++-----
 drivers/watchdog/watchdog_core.c       |    4 +-
 drivers/watchdog/watchdog_dev.c        |   10 ++--
 drivers/watchdog/wdrtas.c              |   69 ++++++++----------
 drivers/watchdog/wdt.c                 |   51 ++++++-------
 drivers/watchdog/wdt285.c              |   12 ++--
 drivers/watchdog/wdt977.c              |   36 ++++------
 drivers/watchdog/wdt_pci.c             |   66 ++++++++---------
 drivers/watchdog/wm8350_wdt.c          |    2 +
 drivers/watchdog/xen_wdt.c             |   25 +++----
 90 files changed, 1043 insertions(+), 1287 deletions(-)

diff --git a/drivers/watchdog/acquirewdt.c b/drivers/watchdog/acquirewdt.c
index b6a2b58..8947ccd 100644
--- a/drivers/watchdog/acquirewdt.c
+++ b/drivers/watchdog/acquirewdt.c
@@ -52,6 +52,8 @@
  *	Includes, defines, variables, module parameters, ...
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 /* Includes */
 #include <linux/module.h>		/* For module specific items */
 #include <linux/moduleparam.h>		/* For new moduleparam's */
@@ -70,7 +72,6 @@
 
 /* Module information */
 #define DRV_NAME "acquirewdt"
-#define PFX DRV_NAME ": "
 #define WATCHDOG_NAME "Acquire WDT"
 /* There is no way to see what the correct time-out period is */
 #define WATCHDOG_HEARTBEAT 0
@@ -208,8 +209,7 @@ static int acq_close(struct inode *inode, struct file *file)
 	if (expect_close == 42) {
 		acq_stop();
 	} else {
-		printk(KERN_CRIT PFX
-			"Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		acq_keepalive();
 	}
 	clear_bit(0, &acq_is_open);
@@ -246,27 +246,24 @@ static int __devinit acq_probe(struct platform_device *dev)
 
 	if (wdt_stop != wdt_start) {
 		if (!request_region(wdt_stop, 1, WATCHDOG_NAME)) {
-			printk(KERN_ERR PFX
-			    "I/O address 0x%04x already in use\n", wdt_stop);
+			pr_err("I/O address 0x%04x already in use\n", wdt_stop);
 			ret = -EIO;
 			goto out;
 		}
 	}
 
 	if (!request_region(wdt_start, 1, WATCHDOG_NAME)) {
-		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
-			wdt_start);
+		pr_err("I/O address 0x%04x already in use\n", wdt_start);
 		ret = -EIO;
 		goto unreg_stop;
 	}
 	ret = misc_register(&acq_miscdev);
 	if (ret != 0) {
-		printk(KERN_ERR PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-							WATCHDOG_MINOR, ret);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
 		goto unreg_regions;
 	}
-	printk(KERN_INFO PFX "initialized. (nowayout=%d)\n", nowayout);
+	pr_info("initialized. (nowayout=%d)\n", nowayout);
 
 	return 0;
 unreg_regions:
@@ -308,8 +305,7 @@ static int __init acq_init(void)
 {
 	int err;
 
-	printk(KERN_INFO
-	      "WDT driver for Acquire single board computer initialising.\n");
+	pr_info("WDT driver for Acquire single board computer initialising\n");
 
 	err = platform_driver_register(&acquirewdt_driver);
 	if (err)
@@ -332,7 +328,7 @@ static void __exit acq_exit(void)
 {
 	platform_device_unregister(acq_platform_device);
 	platform_driver_unregister(&acquirewdt_driver);
-	printk(KERN_INFO PFX "Watchdog Module Unloaded.\n");
+	pr_info("Watchdog Module Unloaded\n");
 }
 
 module_init(acq_init);
diff --git a/drivers/watchdog/advantechwdt.c b/drivers/watchdog/advantechwdt.c
index 4d40965..986258a 100644
--- a/drivers/watchdog/advantechwdt.c
+++ b/drivers/watchdog/advantechwdt.c
@@ -28,6 +28,8 @@
  *	    add wdt_start and wdt_stop as parameters.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -43,7 +45,6 @@
 #include <asm/system.h>
 
 #define DRV_NAME "advantechwdt"
-#define PFX DRV_NAME ": "
 #define WATCHDOG_NAME "Advantech WDT"
 #define WATCHDOG_TIMEOUT 60		/* 60 sec default timeout */
 
@@ -207,8 +208,7 @@ static int advwdt_close(struct inode *inode, struct file *file)
 	if (adv_expect_close == 42) {
 		advwdt_disable();
 	} else {
-		printk(KERN_CRIT PFX
-				"Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		advwdt_ping();
 	}
 	clear_bit(0, &advwdt_is_open);
@@ -245,18 +245,15 @@ static int __devinit advwdt_probe(struct platform_device *dev)
 
 	if (wdt_stop != wdt_start) {
 		if (!request_region(wdt_stop, 1, WATCHDOG_NAME)) {
-			printk(KERN_ERR PFX
-				"I/O address 0x%04x already in use\n",
-								wdt_stop);
+			pr_err("I/O address 0x%04x already in use\n",
+			       wdt_stop);
 			ret = -EIO;
 			goto out;
 		}
 	}
 
 	if (!request_region(wdt_start, 1, WATCHDOG_NAME)) {
-		printk(KERN_ERR PFX
-				"I/O address 0x%04x already in use\n",
-								wdt_start);
+		pr_err("I/O address 0x%04x already in use\n", wdt_start);
 		ret = -EIO;
 		goto unreg_stop;
 	}
@@ -265,18 +262,16 @@ static int __devinit advwdt_probe(struct platform_device *dev)
 	 * if not reset to the default */
 	if (advwdt_set_heartbeat(timeout)) {
 		advwdt_set_heartbeat(WATCHDOG_TIMEOUT);
-		printk(KERN_INFO PFX
-			"timeout value must be 1<=x<=63, using %d\n", timeout);
+		pr_info("timeout value must be 1<=x<=63, using %d\n", timeout);
 	}
 
 	ret = misc_register(&advwdt_miscdev);
 	if (ret != 0) {
-		printk(KERN_ERR PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-							WATCHDOG_MINOR, ret);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
 		goto unreg_regions;
 	}
-	printk(KERN_INFO PFX "initialized. timeout=%d sec (nowayout=%d)\n",
+	pr_info("initialized. timeout=%d sec (nowayout=%d)\n",
 		timeout, nowayout);
 out:
 	return ret;
@@ -318,8 +313,7 @@ static int __init advwdt_init(void)
 {
 	int err;
 
-	printk(KERN_INFO
-	     "WDT driver for Advantech single board computer initialising.\n");
+	pr_info("WDT driver for Advantech single board computer initialising\n");
 
 	err = platform_driver_register(&advwdt_driver);
 	if (err)
@@ -343,7 +337,7 @@ static void __exit advwdt_exit(void)
 {
 	platform_device_unregister(advwdt_platform_device);
 	platform_driver_unregister(&advwdt_driver);
-	printk(KERN_INFO PFX "Watchdog Module Unloaded.\n");
+	pr_info("Watchdog Module Unloaded\n");
 }
 
 module_init(advwdt_init);
diff --git a/drivers/watchdog/alim1535_wdt.c b/drivers/watchdog/alim1535_wdt.c
index f16dcbd..e802f5e 100644
--- a/drivers/watchdog/alim1535_wdt.c
+++ b/drivers/watchdog/alim1535_wdt.c
@@ -7,6 +7,8 @@
  *	2 of the License, or (at your option) any later version.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -22,7 +24,6 @@
 #include <linux/io.h>
 
 #define WATCHDOG_NAME "ALi_M1535"
-#define PFX WATCHDOG_NAME ": "
 #define WATCHDOG_TIMEOUT 60	/* 60 sec default timeout */
 
 /* internal variables */
@@ -268,8 +269,7 @@ static int ali_release(struct inode *inode, struct file *file)
 	if (ali_expect_release == 42)
 		ali_stop();
 	else {
-		printk(KERN_CRIT PFX
-				"Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		ali_keepalive();
 	}
 	clear_bit(0, &ali_is_open);
@@ -399,9 +399,8 @@ static int __init watchdog_init(void)
 	   if not reset to the default */
 	if (timeout < 1 || timeout >= 18000) {
 		timeout = WATCHDOG_TIMEOUT;
-		printk(KERN_INFO PFX
-		     "timeout value must be 0 < timeout < 18000, using %d\n",
-							timeout);
+		pr_info("timeout value must be 0 < timeout < 18000, using %d\n",
+			timeout);
 	}
 
 	/* Calculate the watchdog's timeout */
@@ -409,20 +408,18 @@ static int __init watchdog_init(void)
 
 	ret = register_reboot_notifier(&ali_notifier);
 	if (ret != 0) {
-		printk(KERN_ERR PFX
-			"cannot register reboot notifier (err=%d)\n", ret);
+		pr_err("cannot register reboot notifier (err=%d)\n", ret);
 		goto out;
 	}
 
 	ret = misc_register(&ali_miscdev);
 	if (ret != 0) {
-		printk(KERN_ERR PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-						WATCHDOG_MINOR, ret);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
 		goto unreg_reboot;
 	}
 
-	printk(KERN_INFO PFX "initialized. timeout=%d sec (nowayout=%d)\n",
+	pr_info("initialized. timeout=%d sec (nowayout=%d)\n",
 		timeout, nowayout);
 
 out:
diff --git a/drivers/watchdog/alim7101_wdt.c b/drivers/watchdog/alim7101_wdt.c
index 46f4b85..e90f4ce 100644
--- a/drivers/watchdog/alim7101_wdt.c
+++ b/drivers/watchdog/alim7101_wdt.c
@@ -19,6 +19,8 @@
  *                  -- Mike Waychison <michael.waychison@sun.com>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -36,9 +38,6 @@
 
 #include <asm/system.h>
 
-#define OUR_NAME "alim7101_wdt"
-#define PFX OUR_NAME ": "
-
 #define WDT_ENABLE 0x9C
 #define WDT_DISABLE 0x8C
 
@@ -112,8 +111,7 @@ static void wdt_timer_ping(unsigned long data)
 					ALI_7101_GPIO_O, tmp & ~0x20);
 		}
 	} else {
-		printk(KERN_WARNING PFX
-			"Heartbeat lost! Will not ping the watchdog\n");
+		pr_warn("Heartbeat lost! Will not ping the watchdog\n");
 	}
 	/* Re-set the timer interval */
 	mod_timer(&timer, jiffies + WDT_INTERVAL);
@@ -162,7 +160,7 @@ static void wdt_startup(void)
 	/* Start the timer */
 	mod_timer(&timer, jiffies + WDT_INTERVAL);
 
-	printk(KERN_INFO PFX "Watchdog timer is now enabled.\n");
+	pr_info("Watchdog timer is now enabled\n");
 }
 
 static void wdt_turnoff(void)
@@ -170,7 +168,7 @@ static void wdt_turnoff(void)
 	/* Stop the timer */
 	del_timer_sync(&timer);
 	wdt_change(WDT_DISABLE);
-	printk(KERN_INFO PFX "Watchdog timer is now disabled...\n");
+	pr_info("Watchdog timer is now disabled...\n");
 }
 
 static void wdt_keepalive(void)
@@ -226,8 +224,7 @@ static int fop_close(struct inode *inode, struct file *file)
 		wdt_turnoff();
 	else {
 		/* wim: shouldn't there be a: del_timer(&timer); */
-		printk(KERN_CRIT PFX
-		  "device file closed unexpectedly. Will not stop the WDT!\n");
+		pr_crit("device file closed unexpectedly. Will not stop the WDT!\n");
 	}
 	clear_bit(0, &wdt_is_open);
 	wdt_expect_close = 0;
@@ -322,8 +319,7 @@ static int wdt_notify_sys(struct notifier_block *this,
 		 * watchdog on reboot with no heartbeat
 		 */
 		wdt_change(WDT_ENABLE);
-		printk(KERN_INFO PFX "Watchdog timer is now enabled "
-			"with no heartbeat - should reboot in ~1 second.\n");
+		pr_info("Watchdog timer is now enabled with no heartbeat - should reboot in ~1 second\n");
 	}
 	return NOTIFY_DONE;
 }
@@ -352,12 +348,11 @@ static int __init alim7101_wdt_init(void)
 	struct pci_dev *ali1543_south;
 	char tmp;
 
-	printk(KERN_INFO PFX "Steve Hill <steve@navaho.co.uk>.\n");
+	pr_info("Steve Hill <steve@navaho.co.uk>\n");
 	alim7101_pmu = pci_get_device(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M7101,
 		NULL);
 	if (!alim7101_pmu) {
-		printk(KERN_INFO PFX
-			"ALi M7101 PMU not present - WDT not set\n");
+		pr_info("ALi M7101 PMU not present - WDT not set\n");
 		return -EBUSY;
 	}
 
@@ -367,56 +362,46 @@ static int __init alim7101_wdt_init(void)
 	ali1543_south = pci_get_device(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M1533,
 		NULL);
 	if (!ali1543_south) {
-		printk(KERN_INFO PFX
-			"ALi 1543 South-Bridge not present - WDT not set\n");
+		pr_info("ALi 1543 South-Bridge not present - WDT not set\n");
 		goto err_out;
 	}
 	pci_read_config_byte(ali1543_south, 0x5e, &tmp);
 	pci_dev_put(ali1543_south);
 	if ((tmp & 0x1e) == 0x00) {
 		if (!use_gpio) {
-			printk(KERN_INFO PFX
-				"Detected old alim7101 revision 'a1d'.  "
-				"If this is a cobalt board, set the 'use_gpio' "
-				"module parameter.\n");
+			pr_info("Detected old alim7101 revision 'a1d'.  If this is a cobalt board, set the 'use_gpio' module parameter.\n");
 			goto err_out;
 		}
 		nowayout = 1;
 	} else if ((tmp & 0x1e) != 0x12 && (tmp & 0x1e) != 0x00) {
-		printk(KERN_INFO PFX
-			"ALi 1543 South-Bridge does not have the correct "
-			"revision number (???1001?) - WDT not set\n");
+		pr_info("ALi 1543 South-Bridge does not have the correct revision number (???1001?) - WDT not set\n");
 		goto err_out;
 	}
 
 	if (timeout < 1 || timeout > 3600) {
 		/* arbitrary upper limit */
 		timeout = WATCHDOG_TIMEOUT;
-		printk(KERN_INFO PFX
-			"timeout value must be 1 <= x <= 3600, using %d\n",
-								timeout);
+		pr_info("timeout value must be 1 <= x <= 3600, using %d\n",
+			timeout);
 	}
 
 	rc = register_reboot_notifier(&wdt_notifier);
 	if (rc) {
-		printk(KERN_ERR PFX
-			"cannot register reboot notifier (err=%d)\n", rc);
+		pr_err("cannot register reboot notifier (err=%d)\n", rc);
 		goto err_out;
 	}
 
 	rc = misc_register(&wdt_miscdev);
 	if (rc) {
-		printk(KERN_ERR PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-			wdt_miscdev.minor, rc);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       wdt_miscdev.minor, rc);
 		goto err_out_reboot;
 	}
 
 	if (nowayout)
 		__module_get(THIS_MODULE);
 
-	printk(KERN_INFO PFX "WDT driver for ALi M7101 initialised. "
-					"timeout=%d sec (nowayout=%d)\n",
+	pr_info("WDT driver for ALi M7101 initialised. timeout=%d sec (nowayout=%d)\n",
 		timeout, nowayout);
 	return 0;
 
diff --git a/drivers/watchdog/ar7_wdt.c b/drivers/watchdog/ar7_wdt.c
index 502773a..2df16eb 100644
--- a/drivers/watchdog/ar7_wdt.c
+++ b/drivers/watchdog/ar7_wdt.c
@@ -23,6 +23,8 @@
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/errno.h>
@@ -39,7 +41,6 @@
 #include <asm/addrspace.h>
 #include <asm/mach-ar7/ar7.h>
 
-#define DRVNAME "ar7_wdt"
 #define LONGNAME "TI AR7 Watchdog Timer"
 
 MODULE_AUTHOR("Nicolas Thill <nico@openwrt.org>");
@@ -93,7 +94,7 @@ static void ar7_wdt_kick(u32 value)
 			return;
 		}
 	}
-	printk(KERN_ERR DRVNAME ": failed to unlock WDT kick reg\n");
+	pr_err("failed to unlock WDT kick reg\n");
 }
 
 static void ar7_wdt_prescale(u32 value)
@@ -106,7 +107,7 @@ static void ar7_wdt_prescale(u32 value)
 			return;
 		}
 	}
-	printk(KERN_ERR DRVNAME ": failed to unlock WDT prescale reg\n");
+	pr_err("failed to unlock WDT prescale reg\n");
 }
 
 static void ar7_wdt_change(u32 value)
@@ -119,7 +120,7 @@ static void ar7_wdt_change(u32 value)
 			return;
 		}
 	}
-	printk(KERN_ERR DRVNAME ": failed to unlock WDT change reg\n");
+	pr_err("failed to unlock WDT change reg\n");
 }
 
 static void ar7_wdt_disable(u32 value)
@@ -135,7 +136,7 @@ static void ar7_wdt_disable(u32 value)
 			}
 		}
 	}
-	printk(KERN_ERR DRVNAME ": failed to unlock WDT disable reg\n");
+	pr_err("failed to unlock WDT disable reg\n");
 }
 
 static void ar7_wdt_update_margin(int new_margin)
@@ -151,21 +152,20 @@ static void ar7_wdt_update_margin(int new_margin)
 		change = 0xffff;
 	ar7_wdt_change(change);
 	margin = change * prescale_value / vbus_rate;
-	printk(KERN_INFO DRVNAME
-	       ": timer margin %d seconds (prescale %d, change %d, freq %d)\n",
-	       margin, prescale_value, change, vbus_rate);
+	pr_info("timer margin %d seconds (prescale %d, change %d, freq %d)\n",
+		margin, prescale_value, change, vbus_rate);
 }
 
 static void ar7_wdt_enable_wdt(void)
 {
-	printk(KERN_DEBUG DRVNAME ": enabling watchdog timer\n");
+	pr_debug("enabling watchdog timer\n");
 	ar7_wdt_disable(1);
 	ar7_wdt_kick(1);
 }
 
 static void ar7_wdt_disable_wdt(void)
 {
-	printk(KERN_DEBUG DRVNAME ": disabling watchdog timer\n");
+	pr_debug("disabling watchdog timer\n");
 	ar7_wdt_disable(0);
 }
 
@@ -183,9 +183,7 @@ static int ar7_wdt_open(struct inode *inode, struct file *file)
 static int ar7_wdt_release(struct inode *inode, struct file *file)
 {
 	if (!expect_close)
-		printk(KERN_WARNING DRVNAME
-		": watchdog device closed unexpectedly,"
-		"will not disable the watchdog timer\n");
+		pr_warn("watchdog device closed unexpectedly, will not disable the watchdog timer\n");
 	else if (!nowayout)
 		ar7_wdt_disable_wdt();
 	clear_bit(0, &wdt_is_open);
@@ -283,28 +281,28 @@ static int __devinit ar7_wdt_probe(struct platform_device *pdev)
 	ar7_regs_wdt =
 		platform_get_resource_byname(pdev, IORESOURCE_MEM, "regs");
 	if (!ar7_regs_wdt) {
-		printk(KERN_ERR DRVNAME ": could not get registers resource\n");
+		pr_err("could not get registers resource\n");
 		rc = -ENODEV;
 		goto out;
 	}
 
 	if (!request_mem_region(ar7_regs_wdt->start,
 				resource_size(ar7_regs_wdt), LONGNAME)) {
-		printk(KERN_WARNING DRVNAME ": watchdog I/O region busy\n");
+		pr_warn("watchdog I/O region busy\n");
 		rc = -EBUSY;
 		goto out;
 	}
 
 	ar7_wdt = ioremap(ar7_regs_wdt->start, resource_size(ar7_regs_wdt));
 	if (!ar7_wdt) {
-		printk(KERN_ERR DRVNAME ": could not ioremap registers\n");
+		pr_err("could not ioremap registers\n");
 		rc = -ENXIO;
 		goto out_mem_region;
 	}
 
 	vbus_clk = clk_get(NULL, "vbus");
 	if (IS_ERR(vbus_clk)) {
-		printk(KERN_ERR DRVNAME ": could not get vbus clock\n");
+		pr_err("could not get vbus clock\n");
 		rc = PTR_ERR(vbus_clk);
 		goto out_mem_region;
 	}
@@ -315,7 +313,7 @@ static int __devinit ar7_wdt_probe(struct platform_device *pdev)
 
 	rc = misc_register(&ar7_wdt_miscdev);
 	if (rc) {
-		printk(KERN_ERR DRVNAME ": unable to register misc device\n");
+		pr_err("unable to register misc device\n");
 		goto out_alloc;
 	}
 	goto out;
diff --git a/drivers/watchdog/at91rm9200_wdt.c b/drivers/watchdog/at91rm9200_wdt.c
index b3046dc..3ecd246 100644
--- a/drivers/watchdog/at91rm9200_wdt.c
+++ b/drivers/watchdog/at91rm9200_wdt.c
@@ -9,6 +9,8 @@
  * 2 of the License, or (at your option) any later version.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/bitops.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
@@ -209,8 +211,8 @@ static int __devinit at91wdt_probe(struct platform_device *pdev)
 	if (res)
 		return res;
 
-	printk(KERN_INFO "AT91 Watchdog Timer enabled (%d seconds%s)\n",
-				wdt_time, nowayout ? ", nowayout" : "");
+	pr_info("AT91 Watchdog Timer enabled (%d seconds%s)\n",
+		wdt_time, nowayout ? ", nowayout" : "");
 	return 0;
 }
 
@@ -268,8 +270,8 @@ static int __init at91_wdt_init(void)
 	   if not reset to the default */
 	if (at91_wdt_settimeout(wdt_time)) {
 		at91_wdt_settimeout(WDT_DEFAULT_TIME);
-		pr_info("at91_wdt: wdt_time value must be 1 <= wdt_time <= 256"
-						", using %d\n", wdt_time);
+		pr_info("wdt_time value must be 1 <= wdt_time <= 256, using %d\n",
+			wdt_time);
 	}
 
 	return platform_driver_register(&at91wdt_driver);
diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
index 0056256..cf39847 100644
--- a/drivers/watchdog/at91sam9_wdt.c
+++ b/drivers/watchdog/at91sam9_wdt.c
@@ -15,6 +15,8 @@
  * bootloader doesn't write to this register.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/errno.h>
 #include <linux/fs.h>
 #include <linux/init.h>
@@ -96,7 +98,7 @@ static void at91_ping(unsigned long data)
 		at91_wdt_reset();
 		mod_timer(&at91wdt_private.timer, jiffies + WDT_TIMEOUT);
 	} else
-		printk(KERN_CRIT DRV_NAME": I will reset your machine !\n");
+		pr_crit("I will reset your machine !\n");
 }
 
 /*
@@ -140,7 +142,7 @@ static int at91_wdt_settimeout(unsigned int timeout)
 	/* Check if disabled */
 	mr = wdt_read(AT91_WDT_MR);
 	if (mr & AT91_WDT_WDDIS) {
-		printk(KERN_ERR DRV_NAME": sorry, watchdog is disabled\n");
+		pr_err("sorry, watchdog is disabled\n");
 		return -EIO;
 	}
 
@@ -283,7 +285,7 @@ static int __init at91wdt_probe(struct platform_device *pdev)
 	setup_timer(&at91wdt_private.timer, at91_ping, 0);
 	mod_timer(&at91wdt_private.timer, jiffies + WDT_TIMEOUT);
 
-	printk(KERN_INFO DRV_NAME " enabled (heartbeat=%d sec, nowayout=%d)\n",
+	pr_info("enabled (heartbeat=%d sec, nowayout=%d)\n",
 		heartbeat, nowayout);
 
 	return 0;
diff --git a/drivers/watchdog/ath79_wdt.c b/drivers/watchdog/ath79_wdt.c
index 9db8083..3bb49fd 100644
--- a/drivers/watchdog/ath79_wdt.c
+++ b/drivers/watchdog/ath79_wdt.c
@@ -17,6 +17,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/bitops.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
@@ -114,8 +116,7 @@ static int ath79_wdt_release(struct inode *inode, struct file *file)
 	if (test_bit(WDT_FLAGS_EXPECT_CLOSE, &wdt_flags))
 		ath79_wdt_disable();
 	else {
-		pr_crit(DRIVER_NAME ": device closed unexpectedly, "
-			"watchdog timer will not stop!\n");
+		pr_crit("device closed unexpectedly, watchdog timer will not stop!\n");
 		ath79_wdt_keepalive();
 	}
 
diff --git a/drivers/watchdog/bcm47xx_wdt.c b/drivers/watchdog/bcm47xx_wdt.c
index 5c5f4b1..1989e17 100644
--- a/drivers/watchdog/bcm47xx_wdt.c
+++ b/drivers/watchdog/bcm47xx_wdt.c
@@ -10,6 +10,8 @@
  *  2 of the License, or (at your option) any later version.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/bitops.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
@@ -91,7 +93,7 @@ static void bcm47xx_timer_tick(unsigned long unused)
 		bcm47xx_wdt_hw_start();
 		mod_timer(&wdt_timer, jiffies + HZ);
 	} else {
-		printk(KERN_CRIT DRV_NAME "Watchdog will fire soon!!!\n");
+		pr_crit("Watchdog will fire soon!!!\n");
 	}
 }
 
@@ -140,8 +142,7 @@ static int bcm47xx_wdt_release(struct inode *inode, struct file *file)
 	if (expect_release == 42) {
 		bcm47xx_wdt_stop();
 	} else {
-		printk(KERN_CRIT DRV_NAME
-			": Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		bcm47xx_wdt_start();
 	}
 
@@ -270,8 +271,7 @@ static int __init bcm47xx_wdt_init(void)
 
 	if (bcm47xx_wdt_settimeout(wdt_time)) {
 		bcm47xx_wdt_settimeout(WDT_DEFAULT_TIME);
-		printk(KERN_INFO DRV_NAME ": "
-			"wdt_time value must be 0 < wdt_time < %d, using %d\n",
+		pr_info("wdt_time value must be 0 < wdt_time < %d, using %d\n",
 			(WDT_MAX_TIME + 1), wdt_time);
 	}
 
@@ -285,8 +285,8 @@ static int __init bcm47xx_wdt_init(void)
 		return ret;
 	}
 
-	printk(KERN_INFO "BCM47xx Watchdog Timer enabled (%d seconds%s)\n",
-				wdt_time, nowayout ? ", nowayout" : "");
+	pr_info("BCM47xx Watchdog Timer enabled (%d seconds%s)\n",
+		wdt_time, nowayout ? ", nowayout" : "");
 	return 0;
 }
 
diff --git a/drivers/watchdog/bcm63xx_wdt.c b/drivers/watchdog/bcm63xx_wdt.c
index 8dc7de6..af95b38 100644
--- a/drivers/watchdog/bcm63xx_wdt.c
+++ b/drivers/watchdog/bcm63xx_wdt.c
@@ -10,6 +10,8 @@
  *  2 of the License, or (at your option) any later version.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/bitops.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
@@ -82,7 +84,7 @@ static void bcm63xx_timer_tick(unsigned long unused)
 		bcm63xx_wdt_hw_start();
 		mod_timer(&bcm63xx_wdt_device.timer, jiffies + HZ);
 	} else
-		printk(KERN_CRIT PFX ": watchdog will restart system\n");
+		pr_crit("watchdog will restart system\n");
 }
 
 static void bcm63xx_wdt_pet(void)
@@ -126,8 +128,7 @@ static int bcm63xx_wdt_release(struct inode *inode, struct file *file)
 	if (expect_close == 42)
 		bcm63xx_wdt_pause();
 	else {
-		printk(KERN_CRIT PFX
-			": Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		bcm63xx_wdt_start();
 	}
 	clear_bit(0, &bcm63xx_wdt_device.inuse);
diff --git a/drivers/watchdog/bfin_wdt.c b/drivers/watchdog/bfin_wdt.c
index b9fa9b7..402e9cc 100644
--- a/drivers/watchdog/bfin_wdt.c
+++ b/drivers/watchdog/bfin_wdt.c
@@ -11,6 +11,8 @@
  * Licensed under the GPL-2 or later.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/platform_device.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
@@ -28,15 +30,8 @@
 #define stamp(fmt, args...) \
 	pr_debug("%s:%i: " fmt "\n", __func__, __LINE__, ## args)
 #define stampit() stamp("here i am")
-#define pr_devinit(fmt, args...) \
-	({ static const __devinitconst char __fmt[] = fmt; \
-	printk(__fmt, ## args); })
-#define pr_init(fmt, args...) \
-	({ static const __initconst char __fmt[] = fmt; \
-	printk(__fmt, ## args); })
 
 #define WATCHDOG_NAME "bfin-wdt"
-#define PFX WATCHDOG_NAME ": "
 
 /* The BF561 has two watchdogs (one per core), but since Linux
  * only runs on core A, we'll just work with that one.
@@ -126,7 +121,7 @@ static int bfin_wdt_set_timeout(unsigned long t)
 	stamp("maxtimeout=%us newtimeout=%lus (cnt=%#x)", max_t, t, cnt);
 
 	if (t > max_t) {
-		printk(KERN_WARNING PFX "timeout value is too large\n");
+		pr_warn("timeout value is too large\n");
 		return -EINVAL;
 	}
 
@@ -182,8 +177,7 @@ static int bfin_wdt_release(struct inode *inode, struct file *file)
 	if (expect_close == 42)
 		bfin_wdt_stop();
 	else {
-		printk(KERN_CRIT PFX
-			"Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		bfin_wdt_keepalive();
 	}
 	expect_close = 0;
@@ -368,14 +362,13 @@ static int __devinit bfin_wdt_probe(struct platform_device *pdev)
 
 	ret = misc_register(&bfin_wdt_miscdev);
 	if (ret) {
-		pr_devinit(KERN_ERR PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-				WATCHDOG_MINOR, ret);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
 		return ret;
 	}
 
-	pr_devinit(KERN_INFO PFX "initialized: timeout=%d sec (nowayout=%d)\n",
-	       timeout, nowayout);
+	pr_info("initialized: timeout=%d sec (nowayout=%d)\n",
+		timeout, nowayout);
 
 	return 0;
 }
@@ -439,14 +432,14 @@ static int __init bfin_wdt_init(void)
 	 */
 	ret = platform_driver_register(&bfin_wdt_driver);
 	if (ret) {
-		pr_init(KERN_ERR PFX "unable to register driver\n");
+		pr_err("unable to register driver\n");
 		return ret;
 	}
 
 	bfin_wdt_device = platform_device_register_simple(WATCHDOG_NAME,
 								-1, NULL, 0);
 	if (IS_ERR(bfin_wdt_device)) {
-		pr_init(KERN_ERR PFX "unable to register device\n");
+		pr_err("unable to register device\n");
 		platform_driver_unregister(&bfin_wdt_driver);
 		return PTR_ERR(bfin_wdt_device);
 	}
diff --git a/drivers/watchdog/booke_wdt.c b/drivers/watchdog/booke_wdt.c
index 337265b..ddbee0b 100644
--- a/drivers/watchdog/booke_wdt.c
+++ b/drivers/watchdog/booke_wdt.c
@@ -12,6 +12,8 @@
  * option) any later version.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/smp.h>
@@ -221,8 +223,8 @@ static int booke_wdt_open(struct inode *inode, struct file *file)
 	if (booke_wdt_enabled == 0) {
 		booke_wdt_enabled = 1;
 		on_each_cpu(__booke_wdt_enable, NULL, 0);
-		pr_debug("booke_wdt: watchdog enabled (timeout = %llu sec)\n",
-			period_to_sec(booke_wdt_period));
+		pr_debug("watchdog enabled (timeout = %llu sec)\n",
+			 period_to_sec(booke_wdt_period));
 	}
 	spin_unlock(&booke_wdt_lock);
 
@@ -239,7 +241,7 @@ static int booke_wdt_release(struct inode *inode, struct file *file)
 	 */
 	on_each_cpu(__booke_wdt_disable, NULL, 0);
 	booke_wdt_enabled = 0;
-	pr_debug("booke_wdt: watchdog disabled\n");
+	pr_debug("watchdog disabled\n");
 #endif
 
 	clear_bit(0, &wdt_is_active);
@@ -271,19 +273,19 @@ static int __init booke_wdt_init(void)
 {
 	int ret = 0;
 
-	pr_info("booke_wdt: powerpc book-e watchdog driver loaded\n");
+	pr_info("powerpc book-e watchdog driver loaded\n");
 	ident.firmware_version = cur_cpu_spec->pvr_value;
 
 	ret = misc_register(&booke_wdt_miscdev);
 	if (ret) {
-		pr_err("booke_wdt: cannot register device (minor=%u, ret=%i)\n",
+		pr_err("cannot register device (minor=%u, ret=%i)\n",
 		       WATCHDOG_MINOR, ret);
 		return ret;
 	}
 
 	spin_lock(&booke_wdt_lock);
 	if (booke_wdt_enabled == 1) {
-		pr_info("booke_wdt: watchdog enabled (timeout = %llu sec)\n",
+		pr_info("watchdog enabled (timeout = %llu sec)\n",
 			period_to_sec(booke_wdt_period));
 		on_each_cpu(__booke_wdt_enable, NULL, 0);
 	}
diff --git a/drivers/watchdog/cpu5wdt.c b/drivers/watchdog/cpu5wdt.c
index 251c863..7e88839 100644
--- a/drivers/watchdog/cpu5wdt.c
+++ b/drivers/watchdog/cpu5wdt.c
@@ -19,6 +19,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -71,7 +73,7 @@ static struct {
 static void cpu5wdt_trigger(unsigned long unused)
 {
 	if (verbose > 2)
-		printk(KERN_DEBUG PFX "trigger at %i ticks\n", ticks);
+		pr_debug("trigger at %i ticks\n", ticks);
 
 	if (cpu5wdt_device.running)
 		ticks--;
@@ -96,7 +98,7 @@ static void cpu5wdt_reset(void)
 	ticks = cpu5wdt_device.default_ticks;
 
 	if (verbose)
-		printk(KERN_DEBUG PFX "reset (%i ticks)\n", (int) ticks);
+		pr_debug("reset (%i ticks)\n", (int) ticks);
 
 }
 
@@ -129,7 +131,7 @@ static int cpu5wdt_stop(void)
 	ticks = cpu5wdt_device.default_ticks;
 	spin_unlock_irqrestore(&cpu5wdt_lock, flags);
 	if (verbose)
-		printk(KERN_CRIT PFX "stop not possible\n");
+		pr_crit("stop not possible\n");
 	return -EIO;
 }
 
@@ -219,8 +221,7 @@ static int __devinit cpu5wdt_init(void)
 	int err;
 
 	if (verbose)
-		printk(KERN_DEBUG PFX
-				"port=0x%x, verbose=%i\n", port, verbose);
+		pr_debug("port=0x%x, verbose=%i\n", port, verbose);
 
 	init_completion(&cpu5wdt_device.stop);
 	cpu5wdt_device.queue = 0;
@@ -228,7 +229,7 @@ static int __devinit cpu5wdt_init(void)
 	cpu5wdt_device.default_ticks = ticks;
 
 	if (!request_region(port, CPU5WDT_EXTENT, PFX)) {
-		printk(KERN_ERR PFX "request_region failed\n");
+		pr_err("request_region failed\n");
 		err = -EBUSY;
 		goto no_port;
 	}
@@ -237,16 +238,16 @@ static int __devinit cpu5wdt_init(void)
 	val = inb(port + CPU5WDT_STATUS_REG);
 	val = (val >> 2) & 1;
 	if (!val)
-		printk(KERN_INFO PFX "sorry, was my fault\n");
+		pr_info("sorry, was my fault\n");
 
 	err = misc_register(&cpu5wdt_misc);
 	if (err < 0) {
-		printk(KERN_ERR PFX "misc_register failed\n");
+		pr_err("misc_register failed\n");
 		goto no_misc;
 	}
 
 
-	printk(KERN_INFO PFX "init success\n");
+	pr_info("init success\n");
 	return 0;
 
 no_misc:
diff --git a/drivers/watchdog/cpwd.c b/drivers/watchdog/cpwd.c
index 1b793df..95b1b95 100644
--- a/drivers/watchdog/cpwd.c
+++ b/drivers/watchdog/cpwd.c
@@ -14,6 +14,8 @@
  * Copyright (C) 2008 David S. Miller <davem@davemloft.net>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/fs.h>
@@ -35,7 +37,6 @@
 #include <asm/watchdog.h>
 
 #define DRIVER_NAME	"cpwd"
-#define PFX		DRIVER_NAME ": "
 
 #define WD_OBPNAME	"watchdog"
 #define WD_BADMODEL	"SUNW,501-5336"
@@ -385,8 +386,7 @@ static int cpwd_open(struct inode *inode, struct file *f)
 	if (!p->initialized) {
 		if (request_irq(p->irq, &cpwd_interrupt,
 				IRQF_SHARED, DRIVER_NAME, p)) {
-			printk(KERN_ERR PFX "Cannot register IRQ %d\n",
-				p->irq);
+			pr_err("Cannot register IRQ %d\n", p->irq);
 			mutex_unlock(&cpwd_mutex);
 			return -EBUSY;
 		}
@@ -542,7 +542,7 @@ static int __devinit cpwd_probe(struct platform_device *op)
 	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	err = -ENOMEM;
 	if (!p) {
-		printk(KERN_ERR PFX "Unable to allocate struct cpwd.\n");
+		pr_err("Unable to allocate struct cpwd\n");
 		goto out;
 	}
 
@@ -553,14 +553,14 @@ static int __devinit cpwd_probe(struct platform_device *op)
 	p->regs = of_ioremap(&op->resource[0], 0,
 			     4 * WD_TIMER_REGSZ, DRIVER_NAME);
 	if (!p->regs) {
-		printk(KERN_ERR PFX "Unable to map registers.\n");
+		pr_err("Unable to map registers\n");
 		goto out_free;
 	}
 
 	options = of_find_node_by_path("/options");
 	err = -ENODEV;
 	if (!options) {
-		printk(KERN_ERR PFX "Unable to find /options node.\n");
+		pr_err("Unable to find /options node\n");
 		goto out_iounmap;
 	}
 
@@ -605,8 +605,8 @@ static int __devinit cpwd_probe(struct platform_device *op)
 
 		err = misc_register(&p->devs[i].misc);
 		if (err) {
-			printk(KERN_ERR "Could not register misc device for "
-			       "dev %d\n", i);
+			pr_err("Could not register misc device for dev %d\n",
+			       i);
 			goto out_unregister;
 		}
 	}
@@ -617,8 +617,8 @@ static int __devinit cpwd_probe(struct platform_device *op)
 		cpwd_timer.data		= (unsigned long) p;
 		cpwd_timer.expires	= WD_BTIMEOUT;
 
-		printk(KERN_INFO PFX "PLD defect workaround enabled for "
-		       "model " WD_BADMODEL ".\n");
+		pr_info("PLD defect workaround enabled for model %s\n",
+			WD_BADMODEL);
 	}
 
 	dev_set_drvdata(&op->dev, p);
diff --git a/drivers/watchdog/dw_wdt.c b/drivers/watchdog/dw_wdt.c
index 63d7b58..78a6827 100644
--- a/drivers/watchdog/dw_wdt.c
+++ b/drivers/watchdog/dw_wdt.c
@@ -16,7 +16,8 @@
  * If we receive an expected close for the watchdog then we keep the timer
  * running, otherwise the timer is stopped and the watchdog will expire.
  */
-#define pr_fmt(fmt) "dw_wdt: " fmt
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/bitops.h>
 #include <linux/clk.h>
diff --git a/drivers/watchdog/ep93xx_wdt.c b/drivers/watchdog/ep93xx_wdt.c
index 726b7df..a6532b5 100644
--- a/drivers/watchdog/ep93xx_wdt.c
+++ b/drivers/watchdog/ep93xx_wdt.c
@@ -23,6 +23,8 @@
  *	- Add a few missing ioctls
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/miscdevice.h>
@@ -33,7 +35,6 @@
 #include <mach/hardware.h>
 
 #define WDT_VERSION	"0.3"
-#define PFX		"ep93xx_wdt: "
 
 /* default timeout (secs) */
 #define WDT_TIMEOUT 30
@@ -173,8 +174,7 @@ static int ep93xx_wdt_release(struct inode *inode, struct file *file)
 	if (test_bit(WDT_OK_TO_CLOSE, &wdt_status))
 		wdt_shutdown();
 	else
-		printk(KERN_CRIT PFX
-			"Device closed unexpectedly - timer will not stop\n");
+		pr_crit("Device closed unexpectedly - timer will not stop\n");
 
 	clear_bit(WDT_IN_USE, &wdt_status);
 	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
@@ -214,15 +214,13 @@ static int __init ep93xx_wdt_init(void)
 
 	boot_status = __raw_readl(EP93XX_WDT_WATCHDOG) & 0x01 ? 1 : 0;
 
-	printk(KERN_INFO PFX "EP93XX watchdog, driver version "
-		WDT_VERSION "%s\n",
+	pr_info("EP93XX watchdog, driver version " WDT_VERSION "%s\n",
 		(__raw_readl(EP93XX_WDT_WATCHDOG) & 0x08)
 		? " (nCS1 disable detected)" : "");
 
 	if (timeout < 1 || timeout > 3600) {
 		timeout = WDT_TIMEOUT;
-		printk(KERN_INFO PFX
-			"timeout value must be 1<=x<=3600, using %d\n",
+		pr_info("timeout value must be 1<=x<=3600, using %d\n",
 			timeout);
 	}
 
diff --git a/drivers/watchdog/eurotechwdt.c b/drivers/watchdog/eurotechwdt.c
index 3946c51..22d967a 100644
--- a/drivers/watchdog/eurotechwdt.c
+++ b/drivers/watchdog/eurotechwdt.c
@@ -45,6 +45,8 @@
  *	of the on-board SUPER I/O device SMSC FDC 37B782.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
@@ -144,11 +146,11 @@ static void eurwdt_activate_timer(void)
 
 	/* Setting interrupt line */
 	if (irq == 2 || irq > 15 || irq < 0) {
-		printk(KERN_ERR ": invalid irq number\n");
+		pr_err("invalid irq number\n");
 		irq = 0;	/* if invalid we disable interrupt */
 	}
 	if (irq == 0)
-		printk(KERN_INFO ": interrupt disabled\n");
+		pr_info("interrupt disabled\n");
 
 	eurwdt_write_reg(WDT_TIMER_CFG, irq << 4);
 
@@ -163,12 +165,12 @@ static void eurwdt_activate_timer(void)
 
 static irqreturn_t eurwdt_interrupt(int irq, void *dev_id)
 {
-	printk(KERN_CRIT "timeout WDT timeout\n");
+	pr_crit("timeout WDT timeout\n");
 
 #ifdef ONLY_TESTING
-	printk(KERN_CRIT "Would Reboot.\n");
+	pr_crit("Would Reboot\n");
 #else
-	printk(KERN_CRIT "Initiating system reboot.\n");
+	pr_crit("Initiating system reboot\n");
 	emergency_restart();
 #endif
 	return IRQ_HANDLED;
@@ -335,8 +337,7 @@ static int eurwdt_release(struct inode *inode, struct file *file)
 	if (eur_expect_close == 42)
 		eurwdt_disable_timer();
 	else {
-		printk(KERN_CRIT
-			"eurwdt: Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		eurwdt_ping();
 	}
 	clear_bit(0, &eurwdt_is_open);
@@ -429,35 +430,32 @@ static int __init eurwdt_init(void)
 
 	ret = request_irq(irq, eurwdt_interrupt, 0, "eurwdt", NULL);
 	if (ret) {
-		printk(KERN_ERR "eurwdt: IRQ %d is not free.\n", irq);
+		pr_err("IRQ %d is not free\n", irq);
 		goto out;
 	}
 
 	if (!request_region(io, 2, "eurwdt")) {
-		printk(KERN_ERR "eurwdt: IO %X is not free.\n", io);
+		pr_err("IO %X is not free\n", io);
 		ret = -EBUSY;
 		goto outirq;
 	}
 
 	ret = register_reboot_notifier(&eurwdt_notifier);
 	if (ret) {
-		printk(KERN_ERR
-		    "eurwdt: can't register reboot notifier (err=%d)\n", ret);
+		pr_err("can't register reboot notifier (err=%d)\n", ret);
 		goto outreg;
 	}
 
 	ret = misc_register(&eurwdt_miscdev);
 	if (ret) {
-		printk(KERN_ERR "eurwdt: can't misc_register on minor=%d\n",
-		WATCHDOG_MINOR);
+		pr_err("can't misc_register on minor=%d\n", WATCHDOG_MINOR);
 		goto outreboot;
 	}
 
 	eurwdt_unlock_chip();
 
 	ret = 0;
-	printk(KERN_INFO "Eurotech WDT driver 0.01 at %X (Interrupt %d)"
-		" - timeout event: %s\n",
+	pr_info("Eurotech WDT driver 0.01 at %X (Interrupt %d) - timeout event: %s\n",
 		io, irq, (!strcmp("int", ev) ? "int" : "reboot"));
 
 out:
diff --git a/drivers/watchdog/f71808e_wdt.c b/drivers/watchdog/f71808e_wdt.c
index e45ca2b..c65b0a5 100644
--- a/drivers/watchdog/f71808e_wdt.c
+++ b/drivers/watchdog/f71808e_wdt.c
@@ -19,6 +19,8 @@
  *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
  ***************************************************************************/
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/err.h>
 #include <linux/fs.h>
 #include <linux/init.h>
@@ -189,8 +191,7 @@ static inline int superio_enter(int base)
 {
 	/* Don't step on other drivers' I/O space by accident */
 	if (!request_muxed_region(base, 2, DRVNAME)) {
-		printk(KERN_ERR DRVNAME ": I/O address 0x%04x already in use\n",
-				(int)base);
+		pr_err("I/O address 0x%04x already in use\n", (int)base);
 		return -EBUSY;
 	}
 
@@ -217,7 +218,7 @@ static int watchdog_set_timeout(int timeout)
 {
 	if (timeout <= 0
 	 || timeout >  max_timeout) {
-		printk(KERN_ERR DRVNAME ": watchdog timeout out of range\n");
+		pr_err("watchdog timeout out of range\n");
 		return -EINVAL;
 	}
 
@@ -252,7 +253,7 @@ static int watchdog_set_pulse_width(unsigned int pw)
 	} else if (pw <= 5000) {
 		watchdog.pulse_val = 3;
 	} else {
-		printk(KERN_ERR DRVNAME ": pulse width out of range\n");
+		pr_err("pulse width out of range\n");
 		err = -EINVAL;
 		goto exit_unlock;
 	}
@@ -309,8 +310,7 @@ static int f71862fg_pin_configure(unsigned short ioaddr)
 		if (ioaddr)
 			superio_set_bit(ioaddr, SIO_REG_MFUNCT1, 1);
 	} else {
-		printk(KERN_ERR DRVNAME ": Invalid argument f71862fg_pin=%d\n",
-				f71862fg_pin);
+		pr_err("Invalid argument f71862fg_pin=%d\n", f71862fg_pin);
 		return -EINVAL;
 	}
 	return 0;
@@ -487,8 +487,7 @@ static int watchdog_release(struct inode *inode, struct file *file)
 
 	if (!watchdog.expect_close) {
 		watchdog_keepalive();
-		printk(KERN_CRIT DRVNAME
-			": Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 	} else if (!nowayout) {
 		watchdog_stop();
 	}
@@ -672,25 +671,22 @@ static int __init watchdog_init(int sioaddr)
 
 	err = misc_register(&watchdog_miscdev);
 	if (err) {
-		printk(KERN_ERR DRVNAME
-			": cannot register miscdev on minor=%d\n",
-				watchdog_miscdev.minor);
+		pr_err("cannot register miscdev on minor=%d\n",
+		       watchdog_miscdev.minor);
 		goto exit_reboot;
 	}
 
 	if (start_withtimeout) {
 		if (start_withtimeout <= 0
 		 || start_withtimeout >  max_timeout) {
-			printk(KERN_ERR DRVNAME
-				": starting timeout out of range\n");
+			pr_err("starting timeout out of range\n");
 			err = -EINVAL;
 			goto exit_miscdev;
 		}
 
 		err = watchdog_start();
 		if (err) {
-			printk(KERN_ERR DRVNAME
-				": cannot start watchdog timer\n");
+			pr_err("cannot start watchdog timer\n");
 			goto exit_miscdev;
 		}
 
@@ -720,8 +716,7 @@ static int __init watchdog_init(int sioaddr)
 		if (nowayout)
 			__module_get(THIS_MODULE);
 
-		printk(KERN_INFO DRVNAME
-			": watchdog started with initial timeout of %u sec\n",
+		pr_info("watchdog started with initial timeout of %u sec\n",
 			start_withtimeout);
 	}
 
@@ -746,7 +741,7 @@ static int __init f71808e_find(int sioaddr)
 
 	devid = superio_inw(sioaddr, SIO_REG_MANID);
 	if (devid != SIO_FINTEK_ID) {
-		pr_debug(DRVNAME ": Not a Fintek device\n");
+		pr_debug("Not a Fintek device\n");
 		err = -ENODEV;
 		goto exit;
 	}
@@ -774,13 +769,13 @@ static int __init f71808e_find(int sioaddr)
 		err = -ENODEV;
 		goto exit;
 	default:
-		printk(KERN_INFO DRVNAME ": Unrecognized Fintek device: %04x\n",
-		       (unsigned int)devid);
+		pr_info("Unrecognized Fintek device: %04x\n",
+			(unsigned int)devid);
 		err = -ENODEV;
 		goto exit;
 	}
 
-	printk(KERN_INFO DRVNAME ": Found %s watchdog chip, revision %d\n",
+	pr_info("Found %s watchdog chip, revision %d\n",
 		f71808e_names[watchdog.type],
 		(int)superio_inb(sioaddr, SIO_REG_DEVREV));
 exit:
@@ -808,8 +803,7 @@ static int __init f71808e_init(void)
 static void __exit f71808e_exit(void)
 {
 	if (watchdog_is_running()) {
-		printk(KERN_WARNING DRVNAME
-			": Watchdog timer still running, stopping it\n");
+		pr_warn("Watchdog timer still running, stopping it\n");
 		watchdog_stop();
 	}
 	misc_deregister(&watchdog_miscdev);
diff --git a/drivers/watchdog/gef_wdt.c b/drivers/watchdog/gef_wdt.c
index b146082..d95203b 100644
--- a/drivers/watchdog/gef_wdt.c
+++ b/drivers/watchdog/gef_wdt.c
@@ -24,6 +24,8 @@
  * capabilities) a kernel-based watchdog.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/compiler.h>
 #include <linux/init.h>
@@ -110,7 +112,7 @@ static void gef_wdt_handler_enable(void)
 	if (gef_wdt_toggle_wdc(GEF_WDC_ENABLED_FALSE,
 				   GEF_WDC_ENABLE_SHIFT)) {
 		gef_wdt_service();
-		printk(KERN_NOTICE "gef_wdt: watchdog activated\n");
+		pr_notice("watchdog activated\n");
 	}
 }
 
@@ -118,7 +120,7 @@ static void gef_wdt_handler_disable(void)
 {
 	if (gef_wdt_toggle_wdc(GEF_WDC_ENABLED_TRUE,
 				   GEF_WDC_ENABLE_SHIFT))
-		printk(KERN_NOTICE "gef_wdt: watchdog deactivated\n");
+		pr_notice("watchdog deactivated\n");
 }
 
 static void gef_wdt_set_timeout(unsigned int timeout)
@@ -234,8 +236,7 @@ static int gef_wdt_release(struct inode *inode, struct file *file)
 	if (expect_close == 42)
 		gef_wdt_handler_disable();
 	else {
-		printk(KERN_CRIT
-		       "gef_wdt: unexpected close, not stopping timer!\n");
+		pr_crit("unexpected close, not stopping timer!\n");
 		gef_wdt_service();
 	}
 	expect_close = 0;
@@ -313,7 +314,7 @@ static struct platform_driver gef_wdt_driver = {
 
 static int __init gef_wdt_init(void)
 {
-	printk(KERN_INFO "GE watchdog driver\n");
+	pr_info("GE watchdog driver\n");
 	return platform_driver_register(&gef_wdt_driver);
 }
 
diff --git a/drivers/watchdog/geodewdt.c b/drivers/watchdog/geodewdt.c
index 9b49b12..19044a3 100644
--- a/drivers/watchdog/geodewdt.c
+++ b/drivers/watchdog/geodewdt.c
@@ -9,6 +9,7 @@
  * 2 of the License, or (at your option) any later version.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
@@ -100,7 +101,7 @@ static int geodewdt_release(struct inode *inode, struct file *file)
 		geodewdt_disable();
 		module_put(THIS_MODULE);
 	} else {
-		printk(KERN_CRIT "Unexpected close - watchdog is not stopping.\n");
+		pr_crit("Unexpected close - watchdog is not stopping\n");
 		geodewdt_ping();
 
 		set_bit(WDT_FLAGS_ORPHAN, &wdt_flags);
@@ -220,7 +221,7 @@ static int __devinit geodewdt_probe(struct platform_device *dev)
 
 	wdt_timer = cs5535_mfgpt_alloc_timer(MFGPT_TIMER_ANY, MFGPT_DOMAIN_WORKING);
 	if (!wdt_timer) {
-		printk(KERN_ERR "geodewdt:  No timers were available\n");
+		pr_err("No timers were available\n");
 		return -ENODEV;
 	}
 
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 3c166d3..54c64f5 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -13,6 +13,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/device.h>
 #include <linux/fs.h>
 #include <linux/init.h>
@@ -235,8 +237,7 @@ static int __devinit cru_detect(unsigned long map_entry,
 	asminline_call(&cmn_regs, bios32_entrypoint);
 
 	if (cmn_regs.u1.ral != 0) {
-		printk(KERN_WARNING
-			"hpwdt: Call succeeded but with an error: 0x%x\n",
+		pr_warn("Call succeeded but with an error: 0x%x\n",
 			cmn_regs.u1.ral);
 	} else {
 		physical_bios_base = cmn_regs.u2.rebx;
@@ -256,14 +257,10 @@ static int __devinit cru_detect(unsigned long map_entry,
 			}
 		}
 
-		printk(KERN_DEBUG "hpwdt: CRU Base Address:   0x%lx\n",
-			physical_bios_base);
-		printk(KERN_DEBUG "hpwdt: CRU Offset Address: 0x%lx\n",
-			physical_bios_offset);
-		printk(KERN_DEBUG "hpwdt: CRU Length:         0x%lx\n",
-			cru_length);
-		printk(KERN_DEBUG "hpwdt: CRU Mapped Address: %p\n",
-			&cru_rom_addr);
+		pr_debug("CRU Base Address:   0x%lx\n", physical_bios_base);
+		pr_debug("CRU Offset Address: 0x%lx\n", physical_bios_offset);
+		pr_debug("CRU Length:         0x%lx\n", cru_length);
+		pr_debug("CRU Mapped Address: %p\n", &cru_rom_addr);
 	}
 	iounmap(bios32_map);
 	return retval;
@@ -458,16 +455,13 @@ static void hpwdt_ping(void)
 static int hpwdt_change_timer(int new_margin)
 {
 	if (new_margin < 1 || new_margin > HPWDT_MAX_TIMER) {
-		printk(KERN_WARNING
-			"hpwdt: New value passed in is invalid: %d seconds.\n",
+		pr_warn("New value passed in is invalid: %d seconds\n",
 			new_margin);
 		return -EINVAL;
 	}
 
 	soft_margin = new_margin;
-	printk(KERN_DEBUG
-		"hpwdt: New timer passed in is %d seconds.\n",
-		new_margin);
+	pr_debug("New timer passed in is %d seconds\n", new_margin);
 	reload = SECS_TO_TICKS(soft_margin);
 
 	return 0;
@@ -535,8 +529,7 @@ static int hpwdt_release(struct inode *inode, struct file *file)
 	if (expect_release == 42) {
 		hpwdt_stop();
 	} else {
-		printk(KERN_CRIT
-			"hpwdt: Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		hpwdt_ping();
 	}
 
diff --git a/drivers/watchdog/i6300esb.c b/drivers/watchdog/i6300esb.c
index db45091..15548e6 100644
--- a/drivers/watchdog/i6300esb.c
+++ b/drivers/watchdog/i6300esb.c
@@ -27,6 +27,8 @@
  *      Includes, defines, variables, module parameters, ...
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
@@ -44,7 +46,6 @@
 #define ESB_VERSION "0.05"
 #define ESB_MODULE_NAME "i6300ESB timer"
 #define ESB_DRIVER_NAME ESB_MODULE_NAME ", v" ESB_VERSION
-#define PFX ESB_MODULE_NAME ": "
 
 /* PCI configuration registers */
 #define ESB_CONFIG_REG  0x60            /* Config register                   */
@@ -213,8 +214,7 @@ static int esb_release(struct inode *inode, struct file *file)
 	if (esb_expect_close == 42)
 		esb_timer_stop();
 	else {
-		printk(KERN_CRIT PFX
-				"Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		esb_timer_keepalive();
 	}
 	clear_bit(0, &timer_alive);
@@ -347,19 +347,19 @@ MODULE_DEVICE_TABLE(pci, esb_pci_tbl);
 static unsigned char __devinit esb_getdevice(struct pci_dev *pdev)
 {
 	if (pci_enable_device(pdev)) {
-		printk(KERN_ERR PFX "failed to enable device\n");
+		pr_err("failed to enable device\n");
 		goto err_devput;
 	}
 
 	if (pci_request_region(pdev, 0, ESB_MODULE_NAME)) {
-		printk(KERN_ERR PFX "failed to request region\n");
+		pr_err("failed to request region\n");
 		goto err_disable;
 	}
 
 	BASEADDR = pci_ioremap_bar(pdev, 0);
 	if (BASEADDR == NULL) {
 		/* Something's wrong here, BASEADDR has to be set */
-		printk(KERN_ERR PFX "failed to get BASEADDR\n");
+		pr_err("failed to get BASEADDR\n");
 		goto err_release;
 	}
 
@@ -397,7 +397,7 @@ static void __devinit esb_initdevice(void)
 	/* Check that the WDT isn't already locked */
 	pci_read_config_byte(esb_pci, ESB_LOCK_REG, &val1);
 	if (val1 & ESB_WDT_LOCK)
-		printk(KERN_WARNING PFX "nowayout already set\n");
+		pr_warn("nowayout already set\n");
 
 	/* Set the timer to watchdog mode and disable it for now */
 	pci_write_config_byte(esb_pci, ESB_LOCK_REG, 0x00);
@@ -423,11 +423,11 @@ static int __devinit esb_probe(struct pci_dev *pdev,
 
 	cards_found++;
 	if (cards_found == 1)
-		printk(KERN_INFO PFX "Intel 6300ESB WatchDog Timer Driver v%s\n",
+		pr_info("Intel 6300ESB WatchDog Timer Driver v%s\n",
 			ESB_VERSION);
 
 	if (cards_found > 1) {
-		printk(KERN_ERR PFX "This driver only supports 1 device\n");
+		pr_err("This driver only supports 1 device\n");
 		return -ENODEV;
 	}
 
@@ -439,9 +439,8 @@ static int __devinit esb_probe(struct pci_dev *pdev,
 	   if not reset to the default */
 	if (heartbeat < 0x1 || heartbeat > 2 * 0x03ff) {
 		heartbeat = WATCHDOG_HEARTBEAT;
-		printk(KERN_INFO PFX
-			"heartbeat value must be 1<heartbeat<2046, using %d\n",
-								heartbeat);
+		pr_info("heartbeat value must be 1<heartbeat<2046, using %d\n",
+			heartbeat);
 	}
 
 	/* Initialize the watchdog and make sure it does not run */
@@ -450,14 +449,12 @@ static int __devinit esb_probe(struct pci_dev *pdev,
 	/* Register the watchdog so that userspace has access to it */
 	ret = misc_register(&esb_miscdev);
 	if (ret != 0) {
-		printk(KERN_ERR PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-							WATCHDOG_MINOR, ret);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
 		goto err_unmap;
 	}
-	printk(KERN_INFO PFX
-		"initialized (0x%p). heartbeat=%d sec (nowayout=%d)\n",
-						BASEADDR, heartbeat, nowayout);
+	pr_info("initialized (0x%p). heartbeat=%d sec (nowayout=%d)\n",
+		BASEADDR, heartbeat, nowayout);
 	return 0;
 
 err_unmap:
@@ -503,7 +500,7 @@ static int __init watchdog_init(void)
 static void __exit watchdog_cleanup(void)
 {
 	pci_unregister_driver(&esb_driver);
-	printk(KERN_INFO PFX "Watchdog Module Unloaded.\n");
+	pr_info("Watchdog Module Unloaded\n");
 }
 
 module_init(watchdog_init);
diff --git a/drivers/watchdog/iTCO_vendor_support.c b/drivers/watchdog/iTCO_vendor_support.c
index 481d1ad..2721d29 100644
--- a/drivers/watchdog/iTCO_vendor_support.c
+++ b/drivers/watchdog/iTCO_vendor_support.c
@@ -17,10 +17,11 @@
  *	Includes, defines, variables, module parameters, ...
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 /* Module and version information */
 #define DRV_NAME	"iTCO_vendor_support"
 #define DRV_VERSION	"1.04"
-#define PFX		DRV_NAME ": "
 
 /* Includes */
 #include <linux/module.h>		/* For module specific items */
@@ -355,13 +356,13 @@ EXPORT_SYMBOL(iTCO_vendor_check_noreboot_on);
 
 static int __init iTCO_vendor_init_module(void)
 {
-	printk(KERN_INFO PFX "vendor-support=%d\n", vendorsupport);
+	pr_info("vendor-support=%d\n", vendorsupport);
 	return 0;
 }
 
 static void __exit iTCO_vendor_exit_module(void)
 {
-	printk(KERN_INFO PFX "Module Unloaded\n");
+	pr_info("Module Unloaded\n");
 }
 
 module_init(iTCO_vendor_init_module);
diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index bdf401b..3b4db72 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -43,10 +43,11 @@
  *	Includes, defines, variables, module parameters, ...
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 /* Module and version information */
 #define DRV_NAME	"iTCO_wdt"
 #define DRV_VERSION	"1.07"
-#define PFX		DRV_NAME ": "
 
 /* Includes */
 #include <linux/module.h>		/* For module specific items */
@@ -489,8 +490,7 @@ static int iTCO_wdt_start(void)
 	/* disable chipset's NO_REBOOT bit */
 	if (iTCO_wdt_unset_NO_REBOOT_bit()) {
 		spin_unlock(&iTCO_wdt_private.io_lock);
-		printk(KERN_ERR PFX "failed to reset NO_REBOOT flag, "
-					"reboot disabled by hardware/BIOS\n");
+		pr_err("failed to reset NO_REBOOT flag, reboot disabled by hardware/BIOS\n");
 		return -EIO;
 	}
 
@@ -661,8 +661,7 @@ static int iTCO_wdt_release(struct inode *inode, struct file *file)
 	if (expect_release == 42) {
 		iTCO_wdt_stop();
 	} else {
-		printk(KERN_CRIT PFX
-			"Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		iTCO_wdt_keepalive();
 	}
 	clear_bit(0, &is_active);
@@ -804,8 +803,7 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 	base_address &= 0x0000ff80;
 	if (base_address == 0x00000000) {
 		/* Something's wrong here, ACPIBASE has to be set */
-		printk(KERN_ERR PFX "failed to get TCOBASE address, "
-					"device disabled by hardware/BIOS\n");
+		pr_err("failed to get TCOBASE address, device disabled by hardware/BIOS\n");
 		return -ENODEV;
 	}
 	iTCO_wdt_private.iTCO_version =
@@ -820,8 +818,7 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 	if (iTCO_wdt_private.iTCO_version == 2) {
 		pci_read_config_dword(pdev, 0xf0, &base_address);
 		if ((base_address & 1) == 0) {
-			printk(KERN_ERR PFX "RCBA is disabled by hardware"
-						"/BIOS, device disabled\n");
+			pr_err("RCBA is disabled by hardware/BIOS, device disabled\n");
 			ret = -ENODEV;
 			goto out;
 		}
@@ -831,8 +828,7 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 
 	/* Check chipset's NO_REBOOT bit */
 	if (iTCO_wdt_unset_NO_REBOOT_bit() && iTCO_vendor_check_noreboot_on()) {
-		printk(KERN_INFO PFX "unable to reset NO_REBOOT flag, "
-					"device disabled by hardware/BIOS\n");
+		pr_info("unable to reset NO_REBOOT flag, device disabled by hardware/BIOS\n");
 		ret = -ENODEV;	/* Cannot reset NO_REBOOT bit */
 		goto out_unmap;
 	}
@@ -842,9 +838,8 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 
 	/* The TCO logic uses the TCO_EN bit in the SMI_EN register */
 	if (!request_region(SMI_EN, 4, "iTCO_wdt")) {
-		printk(KERN_ERR PFX
-			"I/O address 0x%04lx already in use, "
-						"device disabled\n", SMI_EN);
+		pr_err("I/O address 0x%04lx already in use, device disabled\n",
+		       SMI_EN);
 		ret = -EIO;
 		goto out_unmap;
 	}
@@ -858,17 +853,16 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 	/* The TCO I/O registers reside in a 32-byte range pointed to
 	   by the TCOBASE value */
 	if (!request_region(TCOBASE, 0x20, "iTCO_wdt")) {
-		printk(KERN_ERR PFX "I/O address 0x%04lx already in use "
-						"device disabled\n", TCOBASE);
+		pr_err("I/O address 0x%04lx already in use, device disabled\n",
+		       TCOBASE);
 		ret = -EIO;
 		goto unreg_smi_en;
 	}
 
-	printk(KERN_INFO PFX
-		"Found a %s TCO device (Version=%d, TCOBASE=0x%04lx)\n",
-			iTCO_chipset_info[ent->driver_data].name,
-			iTCO_chipset_info[ent->driver_data].iTCO_version,
-			TCOBASE);
+	pr_info("Found a %s TCO device (Version=%d, TCOBASE=0x%04lx)\n",
+		iTCO_chipset_info[ent->driver_data].name,
+		iTCO_chipset_info[ent->driver_data].iTCO_version,
+		TCOBASE);
 
 	/* Clear out the (probably old) status */
 	outw(0x0008, TCO1_STS);	/* Clear the Time Out Status bit */
@@ -882,20 +876,18 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 	   if not reset to the default */
 	if (iTCO_wdt_set_heartbeat(heartbeat)) {
 		iTCO_wdt_set_heartbeat(WATCHDOG_HEARTBEAT);
-		printk(KERN_INFO PFX
-			"timeout value out of range, using %d\n", heartbeat);
+		pr_info("timeout value out of range, using %d\n", heartbeat);
 	}
 
 	ret = misc_register(&iTCO_wdt_miscdev);
 	if (ret != 0) {
-		printk(KERN_ERR PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-							WATCHDOG_MINOR, ret);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
 		goto unreg_region;
 	}
 
-	printk(KERN_INFO PFX "initialized. heartbeat=%d sec (nowayout=%d)\n",
-							heartbeat, nowayout);
+	pr_info("initialized. heartbeat=%d sec (nowayout=%d)\n",
+		heartbeat, nowayout);
 
 	return 0;
 
@@ -947,7 +939,7 @@ static int __devinit iTCO_wdt_probe(struct platform_device *dev)
 	}
 
 	if (!found)
-		printk(KERN_INFO PFX "No device detected.\n");
+		pr_info("No device detected\n");
 
 	return ret;
 }
@@ -979,8 +971,7 @@ static int __init iTCO_wdt_init_module(void)
 {
 	int err;
 
-	printk(KERN_INFO PFX "Intel TCO WatchDog Timer Driver v%s\n",
-		DRV_VERSION);
+	pr_info("Intel TCO WatchDog Timer Driver v%s\n", DRV_VERSION);
 
 	err = platform_driver_register(&iTCO_wdt_driver);
 	if (err)
@@ -1004,7 +995,7 @@ static void __exit iTCO_wdt_cleanup_module(void)
 {
 	platform_device_unregister(iTCO_wdt_platform_device);
 	platform_driver_unregister(&iTCO_wdt_driver);
-	printk(KERN_INFO PFX "Watchdog Module Unloaded.\n");
+	pr_info("Watchdog Module Unloaded\n");
 }
 
 module_init(iTCO_wdt_init_module);
diff --git a/drivers/watchdog/ib700wdt.c b/drivers/watchdog/ib700wdt.c
index 0149d8d..7df861b 100644
--- a/drivers/watchdog/ib700wdt.c
+++ b/drivers/watchdog/ib700wdt.c
@@ -31,6 +31,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/miscdevice.h>
@@ -53,7 +55,6 @@ static char expect_close;
 
 /* Module information */
 #define DRV_NAME "ib700wdt"
-#define PFX DRV_NAME ": "
 
 /*
  *
@@ -246,8 +247,7 @@ static int ibwdt_close(struct inode *inode, struct file *file)
 	if (expect_close == 42) {
 		ibwdt_disable();
 	} else {
-		printk(KERN_CRIT PFX
-		     "WDT device closed unexpectedly.  WDT will not stop!\n");
+		pr_crit("WDT device closed unexpectedly.  WDT will not stop!\n");
 		ibwdt_ping();
 	}
 	clear_bit(0, &ibwdt_is_open);
@@ -284,16 +284,14 @@ static int __devinit ibwdt_probe(struct platform_device *dev)
 
 #if WDT_START != WDT_STOP
 	if (!request_region(WDT_STOP, 1, "IB700 WDT")) {
-		printk(KERN_ERR PFX "STOP method I/O %X is not available.\n",
-								WDT_STOP);
+		pr_err("STOP method I/O %X is not available\n", WDT_STOP);
 		res = -EIO;
 		goto out_nostopreg;
 	}
 #endif
 
 	if (!request_region(WDT_START, 1, "IB700 WDT")) {
-		printk(KERN_ERR PFX "START method I/O %X is not available.\n",
-								WDT_START);
+		pr_err("START method I/O %X is not available\n", WDT_START);
 		res = -EIO;
 		goto out_nostartreg;
 	}
@@ -302,13 +300,12 @@ static int __devinit ibwdt_probe(struct platform_device *dev)
 	 * if not reset to the default */
 	if (ibwdt_set_heartbeat(timeout)) {
 		ibwdt_set_heartbeat(WATCHDOG_TIMEOUT);
-		printk(KERN_INFO PFX
-			"timeout value must be 0<=x<=30, using %d\n", timeout);
+		pr_info("timeout value must be 0<=x<=30, using %d\n", timeout);
 	}
 
 	res = misc_register(&ibwdt_miscdev);
 	if (res) {
-		printk(KERN_ERR PFX "failed to register misc device\n");
+		pr_err("failed to register misc device\n");
 		goto out_nomisc;
 	}
 	return 0;
@@ -353,8 +350,7 @@ static int __init ibwdt_init(void)
 {
 	int err;
 
-	printk(KERN_INFO PFX
-		"WDT driver for IB700 single board computer initialising.\n");
+	pr_info("WDT driver for IB700 single board computer initialising\n");
 
 	err = platform_driver_register(&ibwdt_driver);
 	if (err)
@@ -378,7 +374,7 @@ static void __exit ibwdt_exit(void)
 {
 	platform_device_unregister(ibwdt_platform_device);
 	platform_driver_unregister(&ibwdt_driver);
-	printk(KERN_INFO PFX "Watchdog Module Unloaded.\n");
+	pr_info("Watchdog Module Unloaded\n");
 }
 
 module_init(ibwdt_init);
diff --git a/drivers/watchdog/ibmasr.c b/drivers/watchdog/ibmasr.c
index c7481ad..6cd4969 100644
--- a/drivers/watchdog/ibmasr.c
+++ b/drivers/watchdog/ibmasr.c
@@ -10,6 +10,8 @@
  * of the GNU Public License, incorporated herein by reference.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/fs.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -31,8 +33,6 @@ enum {
 	ASMTYPE_SPRUCE,
 };
 
-#define PFX "ibmasr: "
-
 #define TOPAZ_ASR_REG_OFFSET	4
 #define TOPAZ_ASR_TOGGLE	0x40
 #define TOPAZ_ASR_DISABLE	0x80
@@ -234,12 +234,11 @@ static int __init asr_get_base_address(void)
 	}
 
 	if (!request_region(asr_base, asr_length, "ibmasr")) {
-		printk(KERN_ERR PFX "address %#x already in use\n",
-			asr_base);
+		pr_err("address %#x already in use\n", asr_base);
 		return -EBUSY;
 	}
 
-	printk(KERN_INFO PFX "found %sASR @ addr %#x\n", type, asr_base);
+	pr_info("found %sASR @ addr %#x\n", type, asr_base);
 
 	return 0;
 }
@@ -332,8 +331,7 @@ static int asr_release(struct inode *inode, struct file *file)
 	if (asr_expect_close == 42)
 		asr_disable();
 	else {
-		printk(KERN_CRIT PFX
-				"unexpected close, not stopping watchdog!\n");
+		pr_crit("unexpected close, not stopping watchdog!\n");
 		asr_toggle();
 	}
 	clear_bit(0, &asr_is_open);
@@ -393,7 +391,7 @@ static int __init ibmasr_init(void)
 	rc = misc_register(&asr_miscdev);
 	if (rc < 0) {
 		release_region(asr_base, asr_length);
-		printk(KERN_ERR PFX "failed to register misc device\n");
+		pr_err("failed to register misc device\n");
 		return rc;
 	}
 
diff --git a/drivers/watchdog/indydog.c b/drivers/watchdog/indydog.c
index 1475e09..5fa5b2d 100644
--- a/drivers/watchdog/indydog.c
+++ b/drivers/watchdog/indydog.c
@@ -12,6 +12,8 @@
  *	based on softdog.c by Alan Cox <alan@lxorguk.ukuu.org.uk>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -26,7 +28,6 @@
 #include <linux/uaccess.h>
 #include <asm/sgi/mc.h>
 
-#define PFX "indydog: "
 static unsigned long indydog_alive;
 static DEFINE_SPINLOCK(indydog_lock);
 
@@ -60,7 +61,7 @@ static void indydog_stop(void)
 	sgimc->cpuctrl0 = mc_ctrl0;
 	spin_unlock(&indydog_lock);
 
-	printk(KERN_INFO PFX "Stopped watchdog timer.\n");
+	pr_info("Stopped watchdog timer\n");
 }
 
 static void indydog_ping(void)
@@ -83,7 +84,7 @@ static int indydog_open(struct inode *inode, struct file *file)
 	indydog_start();
 	indydog_ping();
 
-	printk(KERN_INFO "Started watchdog timer.\n");
+	pr_info("Started watchdog timer\n");
 
 	return nonseekable_open(inode, file);
 }
@@ -178,30 +179,25 @@ static struct notifier_block indydog_notifier = {
 	.notifier_call = indydog_notify_sys,
 };
 
-static char banner[] __initdata =
-	KERN_INFO PFX "Hardware Watchdog Timer for SGI IP22: 0.3\n";
-
 static int __init watchdog_init(void)
 {
 	int ret;
 
 	ret = register_reboot_notifier(&indydog_notifier);
 	if (ret) {
-		printk(KERN_ERR PFX
-			"cannot register reboot notifier (err=%d)\n", ret);
+		pr_err("cannot register reboot notifier (err=%d)\n", ret);
 		return ret;
 	}
 
 	ret = misc_register(&indydog_miscdev);
 	if (ret) {
-		printk(KERN_ERR PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-							WATCHDOG_MINOR, ret);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
 		unregister_reboot_notifier(&indydog_notifier);
 		return ret;
 	}
 
-	printk(banner);
+	pr_info("Hardware Watchdog Timer for SGI IP22: 0.3\n");
 
 	return 0;
 }
diff --git a/drivers/watchdog/intel_scu_watchdog.c b/drivers/watchdog/intel_scu_watchdog.c
index 1abdc04..9dda2d0 100644
--- a/drivers/watchdog/intel_scu_watchdog.c
+++ b/drivers/watchdog/intel_scu_watchdog.c
@@ -22,6 +22,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/compiler.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
@@ -96,15 +98,14 @@ static struct intel_scu_watchdog_dev watchdog_device;
 static void watchdog_fire(void)
 {
 	if (force_boot) {
-		printk(KERN_CRIT PFX "Initiating system reboot.\n");
+		pr_crit("Initiating system reboot\n");
 		emergency_restart();
-		printk(KERN_CRIT PFX "Reboot didn't ?????\n");
+		pr_crit("Reboot didn't ?????\n");
 	}
 
 	else {
-		printk(KERN_CRIT PFX "Immediate Reboot Disabled\n");
-		printk(KERN_CRIT PFX
-			"System will reset when watchdog timer times out!\n");
+		pr_crit("Immediate Reboot Disabled\n");
+		pr_crit("System will reset when watchdog timer times out!\n");
 	}
 }
 
@@ -112,8 +113,8 @@ static int check_timer_margin(int new_margin)
 {
 	if ((new_margin < MIN_TIME_CYCLE) ||
 	    (new_margin > MAX_TIME - timer_set)) {
-		pr_debug("Watchdog timer: value of new_margin %d is out of the range %d to %d\n",
-			  new_margin, MIN_TIME_CYCLE, MAX_TIME - timer_set);
+		pr_debug("value of new_margin %d is out of the range %d to %d\n",
+			 new_margin, MIN_TIME_CYCLE, MAX_TIME - timer_set);
 		return -EINVAL;
 	}
 	return 0;
@@ -156,14 +157,14 @@ static irqreturn_t watchdog_timer_interrupt(int irq, void *dev_id)
 	int int_status;
 	int_status = ioread32(watchdog_device.timer_interrupt_status_addr);
 
-	pr_debug("Watchdog timer: irq, int_status: %x\n", int_status);
+	pr_debug("irq, int_status: %x\n", int_status);
 
 	if (int_status != 0)
 		return IRQ_NONE;
 
 	/* has the timer been started? If not, then this is spurious */
 	if (watchdog_device.timer_started == 0) {
-		pr_debug("Watchdog timer: spurious interrupt received\n");
+		pr_debug("spurious interrupt received\n");
 		return IRQ_HANDLED;
 	}
 
@@ -220,16 +221,15 @@ static int intel_scu_set_heartbeat(u32 t)
 		(watchdog_device.timer_set - timer_margin)
 		* watchdog_device.timer_tbl_ptr->freq_hz;
 
-	pr_debug("Watchdog timer: set_heartbeat: timer freq is %d\n",
-		watchdog_device.timer_tbl_ptr->freq_hz);
-	pr_debug("Watchdog timer: set_heartbeat: timer_set is %x (hex)\n",
-		watchdog_device.timer_set);
-	pr_debug("Watchdog timer: set_hearbeat: timer_margin is %x (hex)\n",
-		timer_margin);
-	pr_debug("Watchdog timer: set_heartbeat: threshold is %x (hex)\n",
-		watchdog_device.threshold);
-	pr_debug("Watchdog timer: set_heartbeat: soft_threshold is %x (hex)\n",
-		watchdog_device.soft_threshold);
+	pr_debug("set_heartbeat: timer freq is %d\n",
+		 watchdog_device.timer_tbl_ptr->freq_hz);
+	pr_debug("set_heartbeat: timer_set is %x (hex)\n",
+		 watchdog_device.timer_set);
+	pr_debug("set_hearbeat: timer_margin is %x (hex)\n", timer_margin);
+	pr_debug("set_heartbeat: threshold is %x (hex)\n",
+		 watchdog_device.threshold);
+	pr_debug("set_heartbeat: soft_threshold is %x (hex)\n",
+		 watchdog_device.soft_threshold);
 
 	/* Adjust thresholds by FREQ_ADJUSTMENT factor, to make the */
 	/* watchdog timing come out right. */
@@ -264,7 +264,7 @@ static int intel_scu_set_heartbeat(u32 t)
 
 		if (MAX_RETRY < retry_count++) {
 			/* Unable to set timer value */
-			pr_err("Watchdog timer: Unable to set timer\n");
+			pr_err("Unable to set timer\n");
 			return -ENODEV;
 		}
 
@@ -321,18 +321,17 @@ static int intel_scu_release(struct inode *inode, struct file *file)
 	 */
 
 	if (!test_and_clear_bit(0, &watchdog_device.driver_open)) {
-		pr_debug("Watchdog timer: intel_scu_release, without open\n");
+		pr_debug("intel_scu_release, without open\n");
 		return -ENOTTY;
 	}
 
 	if (!watchdog_device.timer_started) {
 		/* Just close, since timer has not been started */
-		pr_debug("Watchdog timer: closed, without starting timer\n");
+		pr_debug("closed, without starting timer\n");
 		return 0;
 	}
 
-	printk(KERN_CRIT PFX
-	       "Unexpected close of /dev/watchdog!\n");
+	pr_crit("Unexpected close of /dev/watchdog!\n");
 
 	/* Since the timer was started, prevent future reopens */
 	watchdog_device.driver_closed = 1;
@@ -454,9 +453,8 @@ static int __init intel_scu_watchdog_init(void)
 	/* Check value of timer_set boot parameter */
 	if ((timer_set < MIN_TIME_CYCLE) ||
 	    (timer_set > MAX_TIME - MIN_TIME_CYCLE)) {
-		pr_err("Watchdog timer: value of timer_set %x (hex) "
-		  "is out of range from %x to %x (hex)\n",
-		  timer_set, MIN_TIME_CYCLE, MAX_TIME - MIN_TIME_CYCLE);
+		pr_err("value of timer_set %x (hex) is out of range from %x to %x (hex)\n",
+		       timer_set, MIN_TIME_CYCLE, MAX_TIME - MIN_TIME_CYCLE);
 		return -EINVAL;
 	}
 
@@ -467,19 +465,18 @@ static int __init intel_scu_watchdog_init(void)
 	watchdog_device.timer_tbl_ptr = sfi_get_mtmr(sfi_mtimer_num-1);
 
 	if (watchdog_device.timer_tbl_ptr == NULL) {
-		pr_debug("Watchdog timer - Intel SCU watchdog: timer is not available\n");
+		pr_debug("timer is not available\n");
 		return -ENODEV;
 	}
 	/* make sure the timer exists */
 	if (watchdog_device.timer_tbl_ptr->phys_addr == 0) {
-		pr_debug("Watchdog timer - Intel SCU watchdog - timer %d does not have valid physical memory\n",
-								sfi_mtimer_num);
+		pr_debug("timer %d does not have valid physical memory\n",
+			 sfi_mtimer_num);
 		return -ENODEV;
 	}
 
 	if (watchdog_device.timer_tbl_ptr->irq == 0) {
-		pr_debug("Watchdog timer: timer %d invalid irq\n",
-							sfi_mtimer_num);
+		pr_debug("timer %d invalid irq\n", sfi_mtimer_num);
 		return -ENODEV;
 	}
 
@@ -487,7 +484,7 @@ static int __init intel_scu_watchdog_init(void)
 			20);
 
 	if (tmp_addr == NULL) {
-		pr_debug("Watchdog timer: timer unable to ioremap\n");
+		pr_debug("timer unable to ioremap\n");
 		return -ENOMEM;
 	}
 
@@ -512,7 +509,7 @@ static int __init intel_scu_watchdog_init(void)
 
 	ret = register_reboot_notifier(&watchdog_device.intel_scu_notifier);
 	if (ret) {
-		pr_err("Watchdog timer: cannot register notifier %d)\n", ret);
+		pr_err("cannot register notifier %d)\n", ret);
 		goto register_reboot_error;
 	}
 
@@ -522,8 +519,8 @@ static int __init intel_scu_watchdog_init(void)
 
 	ret = misc_register(&watchdog_device.miscdev);
 	if (ret) {
-		pr_err("Watchdog timer: cannot register miscdev %d err =%d\n",
-							WATCHDOG_MINOR, ret);
+		pr_err("cannot register miscdev %d err =%d\n",
+		       WATCHDOG_MINOR, ret);
 		goto misc_register_error;
 	}
 
@@ -532,7 +529,7 @@ static int __init intel_scu_watchdog_init(void)
 		IRQF_SHARED, "watchdog",
 		&watchdog_device.timer_load_count_addr);
 	if (ret) {
-		pr_err("Watchdog timer: error requesting irq %d\n", ret);
+		pr_err("error requesting irq %d\n", ret);
 		goto request_irq_error;
 	}
 	/* Make sure timer is disabled before returning */
diff --git a/drivers/watchdog/intel_scu_watchdog.h b/drivers/watchdog/intel_scu_watchdog.h
index d2b074a..f3ac608 100644
--- a/drivers/watchdog/intel_scu_watchdog.h
+++ b/drivers/watchdog/intel_scu_watchdog.h
@@ -25,7 +25,6 @@
 #ifndef __INTEL_SCU_WATCHDOG_H
 #define __INTEL_SCU_WATCHDOG_H
 
-#define PFX "Intel_SCU: "
 #define WDT_VER "0.3"
 
 /* minimum time between interrupts */
diff --git a/drivers/watchdog/iop_wdt.c b/drivers/watchdog/iop_wdt.c
index 82fa7a9..add259b 100644
--- a/drivers/watchdog/iop_wdt.c
+++ b/drivers/watchdog/iop_wdt.c
@@ -24,6 +24,8 @@
  *	Dan Williams <dan.j.williams@intel.com>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/fs.h>
@@ -85,7 +87,7 @@ static int wdt_disable(void)
 		write_wdtcr(IOP_WDTCR_DIS);
 		clear_bit(WDT_ENABLED, &wdt_status);
 		spin_unlock(&wdt_lock);
-		printk(KERN_INFO "WATCHDOG: Disabled\n");
+		pr_info("Disabled\n");
 		return 0;
 	} else
 		return 1;
@@ -197,8 +199,8 @@ static int iop_wdt_release(struct inode *inode, struct file *file)
 	 */
 	if (state != 0) {
 		wdt_enable();
-		printk(KERN_CRIT "WATCHDOG: Device closed unexpectedly - "
-		       "reset in %lu seconds\n", iop_watchdog_timeout());
+		pr_crit("Device closed unexpectedly - reset in %lu seconds\n",
+			iop_watchdog_timeout());
 	}
 
 	clear_bit(WDT_IN_USE, &wdt_status);
@@ -238,8 +240,7 @@ static int __init iop_wdt_init(void)
 	   with an open */
 	ret = misc_register(&iop_wdt_miscdev);
 	if (ret == 0)
-		printk(KERN_INFO "iop watchdog timer: timeout %lu sec\n",
-		       iop_watchdog_timeout());
+		pr_info("timeout %lu sec\n", iop_watchdog_timeout());
 
 	return ret;
 }
diff --git a/drivers/watchdog/it8712f_wdt.c b/drivers/watchdog/it8712f_wdt.c
index 8d2d850..ebd1793 100644
--- a/drivers/watchdog/it8712f_wdt.c
+++ b/drivers/watchdog/it8712f_wdt.c
@@ -20,6 +20,8 @@
  *	software is provided AS-IS with no warranties.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/init.h>
@@ -33,6 +35,7 @@
 #include <linux/io.h>
 #include <linux/ioport.h>
 
+#define DEBUG
 #define NAME "it8712f_wdt"
 
 MODULE_AUTHOR("Jorge Boncompte - DTI2 <jorge@dti2.net>");
@@ -158,10 +161,10 @@ static void it8712f_wdt_update_margin(void)
 	 */
 	if (units <= max_units) {
 		config |= WDT_UNIT_SEC; /* else UNIT is MINUTES */
-		printk(KERN_INFO NAME ": timer margin %d seconds\n", units);
+		pr_info("timer margin %d seconds\n", units);
 	} else {
 		units /= 60;
-		printk(KERN_INFO NAME ": timer margin %d minutes\n", units);
+		pr_info("timer margin %d minutes\n", units);
 	}
 	superio_outb(config, WDT_CONFIG);
 
@@ -184,7 +187,7 @@ static int it8712f_wdt_enable(void)
 	if (ret)
 		return ret;
 
-	printk(KERN_DEBUG NAME ": enabling watchdog timer\n");
+	pr_debug("enabling watchdog timer\n");
 	superio_select(LDN_GPIO);
 
 	superio_outb(wdt_control_reg, WDT_CONTROL);
@@ -204,7 +207,7 @@ static int it8712f_wdt_disable(void)
 	if (ret)
 		return ret;
 
-	printk(KERN_DEBUG NAME ": disabling watchdog timer\n");
+	pr_debug("disabling watchdog timer\n");
 	superio_select(LDN_GPIO);
 
 	superio_outb(0, WDT_CONFIG);
@@ -331,12 +334,10 @@ static int it8712f_wdt_open(struct inode *inode, struct file *file)
 static int it8712f_wdt_release(struct inode *inode, struct file *file)
 {
 	if (expect_close != 42) {
-		printk(KERN_WARNING NAME
-			": watchdog device closed unexpectedly, will not"
-			" disable the watchdog timer\n");
+		pr_warn("watchdog device closed unexpectedly, will not disable the watchdog timer\n");
 	} else if (!nowayout) {
 		if (it8712f_wdt_disable())
-			printk(KERN_WARNING NAME "Watchdog disable failed\n");
+			pr_warn("Watchdog disable failed\n");
 	}
 	expect_close = 0;
 	clear_bit(0, &wdt_open);
@@ -374,13 +375,13 @@ static int __init it8712f_wdt_find(unsigned short *address)
 	superio_select(LDN_GAME);
 	superio_outb(1, ACT_REG);
 	if (!(superio_inb(ACT_REG) & 0x01)) {
-		printk(KERN_ERR NAME ": Device not activated, skipping\n");
+		pr_err("Device not activated, skipping\n");
 		goto exit;
 	}
 
 	*address = superio_inw(BASE_REG);
 	if (*address == 0) {
-		printk(KERN_ERR NAME ": Base address not set, skipping\n");
+		pr_err("Base address not set, skipping\n");
 		goto exit;
 	}
 
@@ -394,8 +395,7 @@ static int __init it8712f_wdt_find(unsigned short *address)
 	if (margin > (max_units * 60))
 		margin = (max_units * 60);
 
-	printk(KERN_INFO NAME ": Found IT%04xF chip revision %d - "
-		"using DogFood address 0x%x\n",
+	pr_info("Found IT%04xF chip revision %d - using DogFood address 0x%x\n",
 		chip_type, revision, *address);
 
 exit:
@@ -411,27 +411,26 @@ static int __init it8712f_wdt_init(void)
 		return -ENODEV;
 
 	if (!request_region(address, 1, "IT8712F Watchdog")) {
-		printk(KERN_WARNING NAME ": watchdog I/O region busy\n");
+		pr_warn("watchdog I/O region busy\n");
 		return -EBUSY;
 	}
 
 	err = it8712f_wdt_disable();
 	if (err) {
-		printk(KERN_ERR NAME ": unable to disable watchdog timer.\n");
+		pr_err("unable to disable watchdog timer\n");
 		goto out;
 	}
 
 	err = register_reboot_notifier(&it8712f_wdt_notifier);
 	if (err) {
-		printk(KERN_ERR NAME ": unable to register reboot notifier\n");
+		pr_err("unable to register reboot notifier\n");
 		goto out;
 	}
 
 	err = misc_register(&it8712f_wdt_miscdev);
 	if (err) {
-		printk(KERN_ERR NAME
-			": cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, err);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, err);
 		goto reboot_out;
 	}
 
diff --git a/drivers/watchdog/it87_wdt.c b/drivers/watchdog/it87_wdt.c
index a2d9a12..86b3688 100644
--- a/drivers/watchdog/it87_wdt.c
+++ b/drivers/watchdog/it87_wdt.c
@@ -29,6 +29,8 @@
  *	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -47,7 +49,6 @@
 
 #define WATCHDOG_VERSION	"1.14"
 #define WATCHDOG_NAME		"IT87 WDT"
-#define PFX			WATCHDOG_NAME ": "
 #define DRIVER_VERSION		WATCHDOG_NAME " driver, v" WATCHDOG_VERSION "\n"
 #define WD_MAGIC		'V'
 
@@ -428,8 +429,7 @@ static int wdt_release(struct inode *inode, struct file *file)
 			clear_bit(WDTS_TIMER_RUN, &wdt_status);
 		} else {
 			wdt_keepalive();
-			printk(KERN_CRIT PFX
-			       "unexpected close, not stopping watchdog!\n");
+			pr_crit("unexpected close, not stopping watchdog!\n");
 		}
 	}
 	clear_bit(WDTS_DEV_OPEN, &wdt_status);
@@ -621,16 +621,14 @@ static int __init it87_wdt_init(void)
 		try_gameport = 0;
 		break;
 	case IT8705_ID:
-		printk(KERN_ERR PFX
-		       "Unsupported Chip found, Chip %04x Revision %02x\n",
+		pr_err("Unsupported Chip found, Chip %04x Revision %02x\n",
 		       chip_type, chip_rev);
 		return -ENODEV;
 	case NO_DEV_ID:
-		printk(KERN_ERR PFX "no device\n");
+		pr_err("no device\n");
 		return -ENODEV;
 	default:
-		printk(KERN_ERR PFX
-		       "Unknown Chip found, Chip %04x Revision %04x\n",
+		pr_err("Unknown Chip found, Chip %04x Revision %04x\n",
 		       chip_type, chip_rev);
 		return -ENODEV;
 	}
@@ -663,13 +661,11 @@ static int __init it87_wdt_init(void)
 	if (!test_bit(WDTS_USE_GP, &wdt_status)) {
 		if (!request_region(CIR_BASE, 8, WATCHDOG_NAME)) {
 			if (gp_rreq_fail)
-				printk(KERN_ERR PFX
-					"I/O Address 0x%04x and 0x%04x"
-					" already in use\n", base, CIR_BASE);
+				pr_err("I/O Address 0x%04x and 0x%04x already in use\n",
+				       base, CIR_BASE);
 			else
-				printk(KERN_ERR PFX
-					"I/O Address 0x%04x already in use\n",
-					CIR_BASE);
+				pr_err("I/O Address 0x%04x already in use\n",
+				       CIR_BASE);
 			rc = -EIO;
 			goto err_out;
 		}
@@ -688,9 +684,8 @@ static int __init it87_wdt_init(void)
 
 	if (timeout < 1 || timeout > max_units * 60) {
 		timeout = DEFAULT_TIMEOUT;
-		printk(KERN_WARNING PFX
-		       "Timeout value out of range, use default %d sec\n",
-		       DEFAULT_TIMEOUT);
+		pr_warn("Timeout value out of range, use default %d sec\n",
+			DEFAULT_TIMEOUT);
 	}
 
 	if (timeout > max_units)
@@ -698,16 +693,14 @@ static int __init it87_wdt_init(void)
 
 	rc = register_reboot_notifier(&wdt_notifier);
 	if (rc) {
-		printk(KERN_ERR PFX
-		       "Cannot register reboot notifier (err=%d)\n", rc);
+		pr_err("Cannot register reboot notifier (err=%d)\n", rc);
 		goto err_out_region;
 	}
 
 	rc = misc_register(&wdt_miscdev);
 	if (rc) {
-		printk(KERN_ERR PFX
-		       "Cannot register miscdev on minor=%d (err=%d)\n",
-			wdt_miscdev.minor, rc);
+		pr_err("Cannot register miscdev on minor=%d (err=%d)\n",
+		       wdt_miscdev.minor, rc);
 		goto err_out_reboot;
 	}
 
@@ -722,9 +715,8 @@ static int __init it87_wdt_init(void)
 		outb(0x09, CIR_IER(base));
 	}
 
-	printk(KERN_INFO PFX "Chip IT%04x revision %d initialized. "
-		"timeout=%d sec (nowayout=%d testmode=%d exclusive=%d "
-		"nogameport=%d)\n", chip_type, chip_rev, timeout,
+	pr_info("Chip IT%04x revision %d initialized. timeout=%d sec (nowayout=%d testmode=%d exclusive=%d nogameport=%d)\n",
+		chip_type, chip_rev, timeout,
 		nowayout, testmode, exclusive, nogameport);
 
 	superio_exit();
diff --git a/drivers/watchdog/ixp2000_wdt.c b/drivers/watchdog/ixp2000_wdt.c
index 084f71aa..fc603c5 100644
--- a/drivers/watchdog/ixp2000_wdt.c
+++ b/drivers/watchdog/ixp2000_wdt.c
@@ -16,6 +16,8 @@
  * warranty of any kind, whether express or implied.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -158,8 +160,7 @@ static int ixp2000_wdt_release(struct inode *inode, struct file *file)
 	if (test_bit(WDT_OK_TO_CLOSE, &wdt_status))
 		wdt_disable();
 	else
-		printk(KERN_CRIT "WATCHDOG: Device closed unexpectedly - "
-					"timer will not stop\n");
+		pr_crit("Device closed unexpectedly - timer will not stop\n");
 	clear_bit(WDT_IN_USE, &wdt_status);
 	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
 
@@ -185,7 +186,7 @@ static struct miscdevice ixp2000_wdt_miscdev = {
 static int __init ixp2000_wdt_init(void)
 {
 	if ((*IXP2000_PRODUCT_ID & 0x001ffef0) == 0x00000000) {
-		printk(KERN_INFO "Unable to use IXP2000 watchdog due to IXP2800 erratum #25.\n");
+		pr_info("Unable to use IXP2000 watchdog due to IXP2800 erratum #25\n");
 		return -EIO;
 	}
 	wdt_tick_rate = (*IXP2000_T1_CLD * HZ) / 256;
diff --git a/drivers/watchdog/ixp4xx_wdt.c b/drivers/watchdog/ixp4xx_wdt.c
index 4fc2e9a..792f95c 100644
--- a/drivers/watchdog/ixp4xx_wdt.c
+++ b/drivers/watchdog/ixp4xx_wdt.c
@@ -13,6 +13,8 @@
  * warranty of any kind, whether express or implied.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -147,8 +149,7 @@ static int ixp4xx_wdt_release(struct inode *inode, struct file *file)
 	if (test_bit(WDT_OK_TO_CLOSE, &wdt_status))
 		wdt_disable();
 	else
-		printk(KERN_CRIT "WATCHDOG: Device closed unexpectedly - "
-					"timer will not stop\n");
+		pr_crit("Device closed unexpectedly - timer will not stop\n");
 	clear_bit(WDT_IN_USE, &wdt_status);
 	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
 
@@ -176,8 +177,7 @@ static int __init ixp4xx_wdt_init(void)
 	int ret;
 
 	if (!(read_cpuid_id() & 0xf) && !cpu_is_ixp46x()) {
-		printk(KERN_ERR "IXP4XXX Watchdog: Rev. A0 IXP42x CPU detected"
-			" - watchdog disabled\n");
+		pr_err("Rev. A0 IXP42x CPU detected - watchdog disabled\n");
 
 		return -ENODEV;
 	}
@@ -185,8 +185,7 @@ static int __init ixp4xx_wdt_init(void)
 			WDIOF_CARDRESET : 0;
 	ret = misc_register(&ixp4xx_wdt_miscdev);
 	if (ret == 0)
-		printk(KERN_INFO "IXP4xx Watchdog Timer: heartbeat %d sec\n",
-			heartbeat);
+		pr_info("timer heartbeat %d sec\n", heartbeat);
 	return ret;
 }
 
diff --git a/drivers/watchdog/ks8695_wdt.c b/drivers/watchdog/ks8695_wdt.c
index 51757a5..4ee0c71 100644
--- a/drivers/watchdog/ks8695_wdt.c
+++ b/drivers/watchdog/ks8695_wdt.c
@@ -8,6 +8,8 @@
  * published by the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/bitops.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
@@ -233,8 +235,8 @@ static int __devinit ks8695wdt_probe(struct platform_device *pdev)
 	if (res)
 		return res;
 
-	printk(KERN_INFO "KS8695 Watchdog Timer enabled (%d seconds%s)\n",
-				wdt_time, nowayout ? ", nowayout" : "");
+	pr_info("KS8695 Watchdog Timer enabled (%d seconds%s)\n",
+		wdt_time, nowayout ? ", nowayout" : "");
 	return 0;
 }
 
diff --git a/drivers/watchdog/lantiq_wdt.c b/drivers/watchdog/lantiq_wdt.c
index 9c8b10c..127ba7c 100644
--- a/drivers/watchdog/lantiq_wdt.c
+++ b/drivers/watchdog/lantiq_wdt.c
@@ -7,6 +7,8 @@
  *  Based on EP93xx wdt driver
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/miscdevice.h>
@@ -160,7 +162,7 @@ ltq_wdt_release(struct inode *inode, struct file *file)
 	if (ltq_wdt_ok_to_close)
 		ltq_wdt_disable();
 	else
-		pr_err("ltq_wdt: watchdog closed without warning\n");
+		pr_err("watchdog closed without warning\n");
 	ltq_wdt_ok_to_close = 0;
 	clear_bit(0, &ltq_wdt_in_use);
 
diff --git a/drivers/watchdog/m54xx_wdt.c b/drivers/watchdog/m54xx_wdt.c
index 4d43286..88e6c8b 100644
--- a/drivers/watchdog/m54xx_wdt.c
+++ b/drivers/watchdog/m54xx_wdt.c
@@ -16,6 +16,8 @@
  * warranty of any kind, whether express or implied.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -166,8 +168,7 @@ static int m54xx_wdt_release(struct inode *inode, struct file *file)
 	if (test_bit(WDT_OK_TO_CLOSE, &wdt_status))
 		wdt_disable();
 	else {
-		printk(KERN_CRIT "WATCHDOG: Device closed unexpectedly - "
-					"timer will not stop\n");
+		pr_crit("Device closed unexpectedly - timer will not stop\n");
 		wdt_keepalive();
 	}
 	clear_bit(WDT_IN_USE, &wdt_status);
@@ -196,11 +197,10 @@ static int __init m54xx_wdt_init(void)
 {
 	if (!request_mem_region(MCF_MBAR + MCF_GPT_GCIR0, 4,
 						"Coldfire M54xx Watchdog")) {
-		printk(KERN_WARNING
-				"Coldfire M54xx Watchdog : I/O region busy\n");
+		pr_warn("I/O region busy\n");
 		return -EBUSY;
 	}
-	printk(KERN_INFO "ColdFire watchdog driver is loaded.\n");
+	pr_info("driver is loaded\n");
 
 	return misc_register(&m54xx_wdt_miscdev);
 }
diff --git a/drivers/watchdog/machzwd.c b/drivers/watchdog/machzwd.c
index 1332b83..a2ecc96 100644
--- a/drivers/watchdog/machzwd.c
+++ b/drivers/watchdog/machzwd.c
@@ -28,6 +28,8 @@
  *      Added nowayout module option to override CONFIG_WATCHDOG_NOWAYOUT
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -141,10 +143,10 @@ static unsigned long next_heartbeat;
 #define ZF_CTIMEOUT 0xffff
 
 #ifndef ZF_DEBUG
-#	define dprintk(format, args...)
+#define dprintk(format, args...)
 #else
-#	define dprintk(format, args...) printk(KERN_DEBUG PFX \
-				":%s:%d: " format, __func__, __LINE__ , ## args)
+#define dprintk(format, args...)					\
+	pr_debug(":%s:%d: " format, __func__, __LINE__ , ## args)
 #endif
 
 
@@ -203,7 +205,7 @@ static void zf_timer_off(void)
 	zf_set_control(ctrl_reg);
 	spin_unlock_irqrestore(&zf_port_lock, flags);
 
-	printk(KERN_INFO PFX ": Watchdog timer is now disabled\n");
+	pr_info("Watchdog timer is now disabled\n");
 }
 
 
@@ -233,7 +235,7 @@ static void zf_timer_on(void)
 	zf_set_control(ctrl_reg);
 	spin_unlock_irqrestore(&zf_port_lock, flags);
 
-	printk(KERN_INFO PFX ": Watchdog timer is now enabled\n");
+	pr_info("Watchdog timer is now enabled\n");
 }
 
 
@@ -263,7 +265,7 @@ static void zf_ping(unsigned long data)
 
 		mod_timer(&zf_timer, jiffies + ZF_HW_TIMEO);
 	} else
-		printk(KERN_CRIT PFX ": I will reset your machine\n");
+		pr_crit("I will reset your machine\n");
 }
 
 static ssize_t zf_write(struct file *file, const char __user *buf, size_t count,
@@ -342,8 +344,7 @@ static int zf_close(struct inode *inode, struct file *file)
 		zf_timer_off();
 	else {
 		del_timer(&zf_timer);
-		printk(KERN_ERR PFX ": device file closed unexpectedly. "
-						"Will not stop the WDT!\n");
+		pr_err("device file closed unexpectedly. Will not stop the WDT!\n");
 	}
 	clear_bit(0, &zf_is_open);
 	zf_expect_close = 0;
@@ -390,19 +391,18 @@ static void __init zf_show_action(int act)
 {
 	static const char * const str[] = { "RESET", "SMI", "NMI", "SCI" };
 
-	printk(KERN_INFO PFX ": Watchdog using action = %s\n", str[act]);
+	pr_info("Watchdog using action = %s\n", str[act]);
 }
 
 static int __init zf_init(void)
 {
 	int ret;
 
-	printk(KERN_INFO PFX
-		": MachZ ZF-Logic Watchdog driver initializing.\n");
+	pr_info("MachZ ZF-Logic Watchdog driver initializing\n");
 
 	ret = zf_get_ZFL_version();
 	if (!ret || ret == 0xffff) {
-		printk(KERN_WARNING PFX ": no ZF-Logic found\n");
+		pr_warn("no ZF-Logic found\n");
 		return -ENODEV;
 	}
 
@@ -414,23 +414,20 @@ static int __init zf_init(void)
 	zf_show_action(action);
 
 	if (!request_region(ZF_IOBASE, 3, "MachZ ZFL WDT")) {
-		printk(KERN_ERR "cannot reserve I/O ports at %d\n",
-							ZF_IOBASE);
+		pr_err("cannot reserve I/O ports at %d\n", ZF_IOBASE);
 		ret = -EBUSY;
 		goto no_region;
 	}
 
 	ret = register_reboot_notifier(&zf_notifier);
 	if (ret) {
-		printk(KERN_ERR "can't register reboot notifier (err=%d)\n",
-									ret);
+		pr_err("can't register reboot notifier (err=%d)\n", ret);
 		goto no_reboot;
 	}
 
 	ret = misc_register(&zf_miscdev);
 	if (ret) {
-		printk(KERN_ERR "can't misc_register on minor=%d\n",
-							WATCHDOG_MINOR);
+		pr_err("can't misc_register on minor=%d\n", WATCHDOG_MINOR);
 		goto no_misc;
 	}
 
diff --git a/drivers/watchdog/mixcomwd.c b/drivers/watchdog/mixcomwd.c
index bc820d1..17ec5b9 100644
--- a/drivers/watchdog/mixcomwd.c
+++ b/drivers/watchdog/mixcomwd.c
@@ -39,9 +39,10 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define VERSION "0.6"
 #define WATCHDOG_NAME "mixcomwd"
-#define PFX WATCHDOG_NAME ": "
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
@@ -156,15 +157,13 @@ static int mixcomwd_release(struct inode *inode, struct file *file)
 {
 	if (expect_close == 42) {
 		if (mixcomwd_timer_alive) {
-			printk(KERN_ERR PFX
-				"release called while internal timer alive");
+			pr_err("release called while internal timer alive\n");
 			return -EBUSY;
 		}
 		mixcomwd_timer_alive = 1;
 		mod_timer(&mixcomwd_timer, jiffies + 5 * HZ);
 	} else
-		printk(KERN_CRIT PFX
-		    "WDT device closed unexpectedly.  WDT will not stop!\n");
+		pr_crit("WDT device closed unexpectedly.  WDT will not stop!\n");
 
 	clear_bit(0, &mixcomwd_opened);
 	expect_close = 0;
@@ -274,22 +273,19 @@ static int __init mixcomwd_init(void)
 	}
 
 	if (!found) {
-		printk(KERN_ERR PFX
-			"No card detected, or port not available.\n");
+		pr_err("No card detected, or port not available\n");
 		return -ENODEV;
 	}
 
 	ret = misc_register(&mixcomwd_miscdev);
 	if (ret) {
-		printk(KERN_ERR PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-					WATCHDOG_MINOR, ret);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
 		goto error_misc_register_watchdog;
 	}
 
-	printk(KERN_INFO
-		"MixCOM watchdog driver v%s, watchdog port at 0x%3x\n",
-					VERSION, watchdog_port);
+	pr_info("MixCOM watchdog driver v%s, watchdog port at 0x%3x\n",
+		VERSION, watchdog_port);
 
 	return 0;
 
@@ -303,8 +299,7 @@ static void __exit mixcomwd_exit(void)
 {
 	if (!nowayout) {
 		if (mixcomwd_timer_alive) {
-			printk(KERN_WARNING PFX "I quit now, hardware will"
-			       " probably reboot!\n");
+			pr_warn("I quit now, hardware will probably reboot!\n");
 			del_timer_sync(&mixcomwd_timer);
 			mixcomwd_timer_alive = 0;
 		}
diff --git a/drivers/watchdog/mpc8xxx_wdt.c b/drivers/watchdog/mpc8xxx_wdt.c
index 20feb4d..3e335fa 100644
--- a/drivers/watchdog/mpc8xxx_wdt.c
+++ b/drivers/watchdog/mpc8xxx_wdt.c
@@ -17,6 +17,8 @@
  * option) any later version.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -96,7 +98,7 @@ static void mpc8xxx_wdt_timer_ping(unsigned long arg)
 
 static void mpc8xxx_wdt_pr_warn(const char *msg)
 {
-	pr_crit("mpc8xxx_wdt: %s, expect the %s soon!\n", msg,
+	pr_crit("%s, expect the %s soon!\n", msg,
 		reset ? "reset" : "machine check exception");
 }
 
@@ -209,7 +211,7 @@ static int __devinit mpc8xxx_wdt_probe(struct platform_device *ofdev)
 
 	enabled = in_be32(&wd_base->swcrr) & SWCRR_SWEN;
 	if (!enabled && wdt_type->hw_enabled) {
-		pr_info("mpc8xxx_wdt: could not be enabled in software\n");
+		pr_info("could not be enabled in software\n");
 		ret = -ENOSYS;
 		goto err_unmap;
 	}
@@ -226,9 +228,8 @@ static int __devinit mpc8xxx_wdt_probe(struct platform_device *ofdev)
 		goto err_unmap;
 #endif
 
-	pr_info("WDT driver for MPC8xxx initialized. mode:%s timeout=%d "
-		"(%d seconds)\n", reset ? "reset" : "interrupt", timeout,
-		timeout_sec);
+	pr_info("WDT driver for MPC8xxx initialized. mode:%s timeout=%d (%d seconds)\n",
+		reset ? "reset" : "interrupt", timeout, timeout_sec);
 
 	/*
 	 * If the watchdog was previously enabled or we're running on
@@ -303,7 +304,7 @@ static int mpc8xxx_wdt_init_late(void)
 	ret = misc_register(&mpc8xxx_wdt_miscdev);
 	if (ret) {
 		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
+		       WATCHDOG_MINOR, ret);
 		return ret;
 	}
 	return 0;
diff --git a/drivers/watchdog/mpcore_wdt.c b/drivers/watchdog/mpcore_wdt.c
index 82ccd36..a7de5f6 100644
--- a/drivers/watchdog/mpcore_wdt.c
+++ b/drivers/watchdog/mpcore_wdt.c
@@ -19,6 +19,9 @@
  *	(c) Copyright 1995    Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -442,9 +445,6 @@ static struct platform_driver mpcore_wdt_driver = {
 	},
 };
 
-static char banner[] __initdata = KERN_INFO "MPcore Watchdog Timer: 0.1. "
-		"mpcore_noboot=%d mpcore_margin=%d sec (nowayout= %d)\n";
-
 static int __init mpcore_wdt_init(void)
 {
 	/*
@@ -453,11 +453,12 @@ static int __init mpcore_wdt_init(void)
 	 */
 	if (mpcore_wdt_set_heartbeat(mpcore_margin)) {
 		mpcore_wdt_set_heartbeat(TIMER_MARGIN);
-		printk(KERN_INFO "mpcore_margin value must be 0 < mpcore_margin < 65536, using %d\n",
+		pr_info("mpcore_margin value must be 0 < mpcore_margin < 65536, using %d\n",
 			TIMER_MARGIN);
 	}
 
-	printk(banner, mpcore_noboot, mpcore_margin, nowayout);
+	pr_info("MPcore Watchdog Timer: 0.1. mpcore_noboot=%d mpcore_margin=%d sec (nowayout= %d)\n",
+		mpcore_noboot, mpcore_margin, nowayout);
 
 	return platform_driver_register(&mpcore_wdt_driver);
 }
diff --git a/drivers/watchdog/mv64x60_wdt.c b/drivers/watchdog/mv64x60_wdt.c
index 97f8a48..ee0f828 100644
--- a/drivers/watchdog/mv64x60_wdt.c
+++ b/drivers/watchdog/mv64x60_wdt.c
@@ -15,6 +15,8 @@
  * or implied.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -100,7 +102,7 @@ static void mv64x60_wdt_handler_enable(void)
 	if (mv64x60_wdt_toggle_wdc(MV64x60_WDC_ENABLED_FALSE,
 				   MV64x60_WDC_ENABLE_SHIFT)) {
 		mv64x60_wdt_service();
-		printk(KERN_NOTICE "mv64x60_wdt: watchdog activated\n");
+		pr_notice("watchdog activated\n");
 	}
 }
 
@@ -108,7 +110,7 @@ static void mv64x60_wdt_handler_disable(void)
 {
 	if (mv64x60_wdt_toggle_wdc(MV64x60_WDC_ENABLED_TRUE,
 				   MV64x60_WDC_ENABLE_SHIFT))
-		printk(KERN_NOTICE "mv64x60_wdt: watchdog deactivated\n");
+		pr_notice("watchdog deactivated\n");
 }
 
 static void mv64x60_wdt_set_timeout(unsigned int timeout)
@@ -139,8 +141,7 @@ static int mv64x60_wdt_release(struct inode *inode, struct file *file)
 	if (expect_close == 42)
 		mv64x60_wdt_handler_disable();
 	else {
-		printk(KERN_CRIT
-		       "mv64x60_wdt: unexpected close, not stopping timer!\n");
+		pr_crit("unexpected close, not stopping timer!\n");
 		mv64x60_wdt_service();
 	}
 	expect_close = 0;
@@ -308,7 +309,7 @@ static struct platform_driver mv64x60_wdt_driver = {
 
 static int __init mv64x60_wdt_init(void)
 {
-	printk(KERN_INFO "MV64x60 watchdog driver\n");
+	pr_info("MV64x60 watchdog driver\n");
 
 	return platform_driver_register(&mv64x60_wdt_driver);
 }
diff --git a/drivers/watchdog/nv_tco.c b/drivers/watchdog/nv_tco.c
index 809f41c..16d9413 100644
--- a/drivers/watchdog/nv_tco.c
+++ b/drivers/watchdog/nv_tco.c
@@ -21,6 +21,8 @@
  *	Includes, defines, variables, module parameters, ...
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -41,7 +43,6 @@
 #define TCO_VERSION "0.01"
 #define TCO_MODULE_NAME "NV_TCO"
 #define TCO_DRIVER_NAME   TCO_MODULE_NAME ", v" TCO_VERSION
-#define PFX TCO_MODULE_NAME ": "
 
 /* internal variables */
 static unsigned int tcobase;
@@ -169,8 +170,7 @@ static int nv_tco_release(struct inode *inode, struct file *file)
 	if (tco_expect_close == 42) {
 		tco_timer_stop();
 	} else {
-		printk(KERN_CRIT PFX "Unexpected close, not stopping "
-		       "watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		tco_timer_keepalive();
 	}
 	clear_bit(0, &timer_alive);
@@ -323,15 +323,14 @@ static unsigned char __devinit nv_tco_getdevice(void)
 	val &= 0xffff;
 	if (val == 0x0001 || val == 0x0000) {
 		/* Something is wrong here, bar isn't setup */
-		printk(KERN_ERR PFX "failed to get tcobase address\n");
+		pr_err("failed to get tcobase address\n");
 		return 0;
 	}
 	val &= 0xff00;
 	tcobase = val + 0x40;
 
 	if (!request_region(tcobase, 0x10, "NV TCO")) {
-		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
-		       tcobase);
+		pr_err("I/O address 0x%04x already in use\n", tcobase);
 		return 0;
 	}
 
@@ -347,7 +346,7 @@ static unsigned char __devinit nv_tco_getdevice(void)
 
 	/* Disable SMI caused by TCO */
 	if (!request_region(MCP51_SMI_EN(tcobase), 4, "NV TCO")) {
-		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
+		pr_err("I/O address 0x%04x already in use\n",
 		       MCP51_SMI_EN(tcobase));
 		goto out;
 	}
@@ -357,7 +356,7 @@ static unsigned char __devinit nv_tco_getdevice(void)
 	val = inl(MCP51_SMI_EN(tcobase));
 	release_region(MCP51_SMI_EN(tcobase), 4);
 	if (val & MCP51_SMI_EN_TCO) {
-		printk(KERN_ERR PFX "Could not disable SMI caused by TCO\n");
+		pr_err("Could not disable SMI caused by TCO\n");
 		goto out;
 	}
 
@@ -367,8 +366,7 @@ static unsigned char __devinit nv_tco_getdevice(void)
 	pci_write_config_dword(tco_pci, MCP51_SMBUS_SETUP_B, val);
 	pci_read_config_dword(tco_pci, MCP51_SMBUS_SETUP_B, &val);
 	if (!(val & MCP51_SMBUS_SETUP_B_TCO_REBOOT)) {
-		printk(KERN_ERR PFX "failed to reset NO_REBOOT flag, reboot "
-		       "disabled by hardware\n");
+		pr_err("failed to reset NO_REBOOT flag, reboot disabled by hardware\n");
 		goto out;
 	}
 
@@ -387,8 +385,8 @@ static int __devinit nv_tco_init(struct platform_device *dev)
 		return -ENODEV;
 
 	/* Check to see if last reboot was due to watchdog timeout */
-	printk(KERN_INFO PFX "Watchdog reboot %sdetected.\n",
-	       inl(TCO_STS(tcobase)) & TCO_STS_TCO2TO_STS ? "" : "not ");
+	pr_info("Watchdog reboot %sdetected\n",
+		inl(TCO_STS(tcobase)) & TCO_STS_TCO2TO_STS ? "" : "not ");
 
 	/* Clear out the old status */
 	outl(TCO_STS_RESET, TCO_STS(tcobase));
@@ -400,14 +398,14 @@ static int __devinit nv_tco_init(struct platform_device *dev)
 	if (tco_timer_set_heartbeat(heartbeat)) {
 		heartbeat = WATCHDOG_HEARTBEAT;
 		tco_timer_set_heartbeat(heartbeat);
-		printk(KERN_INFO PFX "heartbeat value must be 2<heartbeat<39, "
-		       "using %d\n", heartbeat);
+		pr_info("heartbeat value must be 2<heartbeat<39, using %d\n",
+			heartbeat);
 	}
 
 	ret = misc_register(&nv_tco_miscdev);
 	if (ret != 0) {
-		printk(KERN_ERR PFX "cannot register miscdev on minor=%d "
-		       "(err=%d)\n", WATCHDOG_MINOR, ret);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
 		goto unreg_region;
 	}
 
@@ -415,8 +413,8 @@ static int __devinit nv_tco_init(struct platform_device *dev)
 
 	tco_timer_stop();
 
-	printk(KERN_INFO PFX "initialized (0x%04x). heartbeat=%d sec "
-	       "(nowayout=%d)\n", tcobase, heartbeat, nowayout);
+	pr_info("initialized (0x%04x). heartbeat=%d sec (nowayout=%d)\n",
+		tcobase, heartbeat, nowayout);
 
 	return 0;
 
@@ -439,8 +437,7 @@ static void __devexit nv_tco_cleanup(void)
 	pci_write_config_dword(tco_pci, MCP51_SMBUS_SETUP_B, val);
 	pci_read_config_dword(tco_pci, MCP51_SMBUS_SETUP_B, &val);
 	if (val & MCP51_SMBUS_SETUP_B_TCO_REBOOT) {
-		printk(KERN_CRIT PFX "Couldn't unset REBOOT bit.  Machine may "
-		       "soon reset\n");
+		pr_crit("Couldn't unset REBOOT bit.  Machine may soon reset\n");
 	}
 
 	/* Deregister */
@@ -483,8 +480,7 @@ static int __init nv_tco_init_module(void)
 {
 	int err;
 
-	printk(KERN_INFO PFX "NV TCO WatchDog Timer Driver v%s\n",
-	       TCO_VERSION);
+	pr_info("NV TCO WatchDog Timer Driver v%s\n", TCO_VERSION);
 
 	err = platform_driver_register(&nv_tco_driver);
 	if (err)
@@ -508,7 +504,7 @@ static void __exit nv_tco_cleanup_module(void)
 {
 	platform_device_unregister(nv_tco_platform_device);
 	platform_driver_unregister(&nv_tco_driver);
-	printk(KERN_INFO PFX "NV TCO Watchdog Module Unloaded.\n");
+	pr_info("NV TCO Watchdog Module Unloaded\n");
 }
 
 module_init(nv_tco_init_module);
diff --git a/drivers/watchdog/octeon-wdt-main.c b/drivers/watchdog/octeon-wdt-main.c
index 7c0d863..c5a3ff9 100644
--- a/drivers/watchdog/octeon-wdt-main.c
+++ b/drivers/watchdog/octeon-wdt-main.c
@@ -52,6 +52,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/miscdevice.h>
 #include <linux/interrupt.h>
 #include <linux/watchdog.h>
@@ -201,7 +203,7 @@ static void __init octeon_wdt_build_stage1(void)
 	uasm_resolve_relocs(relocs, labels);
 
 	len = (int)(p - nmi_stage1_insns);
-	pr_debug("Synthesized NMI stage 1 handler (%d instructions).\n", len);
+	pr_debug("Synthesized NMI stage 1 handler (%d instructions)\n", len);
 
 	pr_debug("\t.set push\n");
 	pr_debug("\t.set noreorder\n");
@@ -627,7 +629,7 @@ static int octeon_wdt_release(struct inode *inode, struct file *file)
 		do_coundown = 0;
 		octeon_wdt_ping();
 	} else {
-		pr_crit("octeon_wdt: WDT device closed unexpectedly.  WDT will not stop!\n");
+		pr_crit("WDT device closed unexpectedly.  WDT will not stop!\n");
 	}
 	clear_bit(0, &octeon_wdt_is_open);
 	expect_close = 0;
@@ -684,12 +686,12 @@ static int __init octeon_wdt_init(void)
 
 	octeon_wdt_calc_parameters(heartbeat);
 
-	pr_info("octeon_wdt: Initial granularity %d Sec.\n", timeout_sec);
+	pr_info("Initial granularity %d Sec\n", timeout_sec);
 
 	ret = misc_register(&octeon_wdt_miscdev);
 	if (ret) {
-		pr_err("octeon_wdt: cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
 		goto out;
 	}
 
diff --git a/drivers/watchdog/of_xilinx_wdt.c b/drivers/watchdog/of_xilinx_wdt.c
index f359ab8..55d2f66 100644
--- a/drivers/watchdog/of_xilinx_wdt.c
+++ b/drivers/watchdog/of_xilinx_wdt.c
@@ -19,6 +19,8 @@
 *		  know the wdt reset interval
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
@@ -99,7 +101,7 @@ static void xwdt_stop(void)
 	iowrite32(0, xdev.base + XWT_TWCSR1_OFFSET);
 
 	spin_unlock(&spinlock);
-	printk(KERN_INFO PFX "Stopped!\n");
+	pr_info("Stopped!\n");
 }
 
 static void xwdt_keepalive(void)
@@ -165,7 +167,7 @@ static int xwdt_open(struct inode *inode, struct file *file)
 		__module_get(THIS_MODULE);
 
 	xwdt_start();
-	printk(KERN_INFO PFX "Started...\n");
+	pr_info("Started...\n");
 
 	return nonseekable_open(inode, file);
 }
@@ -175,8 +177,7 @@ static int xwdt_release(struct inode *inode, struct file *file)
 	if (expect_close == 42) {
 		xwdt_stop();
 	} else {
-		printk(KERN_CRIT PFX
-			"Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		xwdt_keepalive();
 	}
 
@@ -300,22 +301,20 @@ static int __devinit xwdt_probe(struct platform_device *pdev)
 					"clock-frequency", NULL);
 
 	if (pfreq == NULL) {
-		printk(KERN_WARNING PFX
-			"The watchdog clock frequency cannot be obtained!\n");
+		pr_warn("The watchdog clock frequency cannot be obtained!\n");
 		no_timeout = 1;
 	}
 
 	rc = of_address_to_resource(pdev->dev.of_node, 0, &xdev.res);
 	if (rc) {
-		printk(KERN_WARNING PFX "invalid address!\n");
+		pr_warn("invalid address!\n");
 		return rc;
 	}
 
 	tmptr = (u32 *)of_get_property(pdev->dev.of_node,
 					"xlnx,wdt-interval", NULL);
 	if (tmptr == NULL) {
-		printk(KERN_WARNING PFX "Parameter \"xlnx,wdt-interval\""
-					" not found in device tree!\n");
+		pr_warn("Parameter \"xlnx,wdt-interval\" not found in device tree!\n");
 		no_timeout = 1;
 	} else {
 		xdev.wdt_interval = *tmptr;
@@ -324,8 +323,7 @@ static int __devinit xwdt_probe(struct platform_device *pdev)
 	tmptr = (u32 *)of_get_property(pdev->dev.of_node,
 					"xlnx,wdt-enable-once", NULL);
 	if (tmptr == NULL) {
-		printk(KERN_WARNING PFX "Parameter \"xlnx,wdt-enable-once\""
-					" not found in device tree!\n");
+		pr_warn("Parameter \"xlnx,wdt-enable-once\" not found in device tree!\n");
 		xdev.nowayout = WATCHDOG_NOWAYOUT;
 	}
 
@@ -339,20 +337,20 @@ static int __devinit xwdt_probe(struct platform_device *pdev)
 	if (!request_mem_region(xdev.res.start,
 			xdev.res.end - xdev.res.start + 1, WATCHDOG_NAME)) {
 		rc = -ENXIO;
-		printk(KERN_ERR PFX "memory request failure!\n");
+		pr_err("memory request failure!\n");
 		goto err_out;
 	}
 
 	xdev.base = ioremap(xdev.res.start, xdev.res.end - xdev.res.start + 1);
 	if (xdev.base == NULL) {
 		rc = -ENOMEM;
-		printk(KERN_ERR PFX "ioremap failure!\n");
+		pr_err("ioremap failure!\n");
 		goto release_mem;
 	}
 
 	rc = xwdt_selftest();
 	if (rc == XWT_TIMER_FAILED) {
-		printk(KERN_ERR PFX "SelfTest routine error!\n");
+		pr_err("SelfTest routine error!\n");
 		goto unmap_io;
 	}
 
@@ -360,20 +358,17 @@ static int __devinit xwdt_probe(struct platform_device *pdev)
 
 	rc = misc_register(&xwdt_miscdev);
 	if (rc) {
-		printk(KERN_ERR PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-						xwdt_miscdev.minor, rc);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       xwdt_miscdev.minor, rc);
 		goto unmap_io;
 	}
 
 	if (no_timeout)
-		printk(KERN_INFO PFX
-			"driver loaded (timeout=? sec, nowayout=%d)\n",
-						    xdev.nowayout);
+		pr_info("driver loaded (timeout=? sec, nowayout=%d)\n",
+			xdev.nowayout);
 	else
-		printk(KERN_INFO PFX
-			"driver loaded (timeout=%d sec, nowayout=%d)\n",
-					timeout, xdev.nowayout);
+		pr_info("driver loaded (timeout=%d sec, nowayout=%d)\n",
+			timeout, xdev.nowayout);
 
 	expect_close = 0;
 	clear_bit(0, &driver_open);
diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index d19ff51..8285d65 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -26,6 +26,8 @@
  *	Use the driver model and standard identifiers; handle bigger timeouts.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
@@ -183,7 +185,7 @@ static int omap_wdt_release(struct inode *inode, struct file *file)
 
 	pm_runtime_put_sync(wdev->dev);
 #else
-	printk(KERN_CRIT "omap_wdt: Unexpected close, not stopping!\n");
+	pr_crit("Unexpected close, not stopping!\n");
 #endif
 	wdev->omap_wdt_users = 0;
 
diff --git a/drivers/watchdog/orion_wdt.c b/drivers/watchdog/orion_wdt.c
index 4ad78f8..25c954d 100644
--- a/drivers/watchdog/orion_wdt.c
+++ b/drivers/watchdog/orion_wdt.c
@@ -10,6 +10,8 @@
  * warranty of any kind, whether express or implied.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -209,8 +211,7 @@ static int orion_wdt_release(struct inode *inode, struct file *file)
 	if (test_bit(WDT_OK_TO_CLOSE, &wdt_status))
 		orion_wdt_disable();
 	else
-		printk(KERN_CRIT "WATCHDOG: Device closed unexpectedly - "
-					"timer will not stop\n");
+		pr_crit("Device closed unexpectedly - timer will not stop\n");
 	clear_bit(WDT_IN_USE, &wdt_status);
 	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
 
@@ -241,7 +242,7 @@ static int __devinit orion_wdt_probe(struct platform_device *pdev)
 	if (pdata) {
 		wdt_tclk = pdata->tclk;
 	} else {
-		printk(KERN_ERR "Orion Watchdog misses platform data\n");
+		pr_err("misses platform data\n");
 		return -ENODEV;
 	}
 
@@ -257,8 +258,8 @@ static int __devinit orion_wdt_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	printk(KERN_INFO "Orion Watchdog Timer: Initial timeout %d sec%s\n",
-				heartbeat, nowayout ? ", nowayout" : "");
+	pr_info("Initial timeout %d sec%s\n",
+		heartbeat, nowayout ? ", nowayout" : "");
 	return 0;
 }
 
diff --git a/drivers/watchdog/pc87413_wdt.c b/drivers/watchdog/pc87413_wdt.c
index e78d899..a86f405 100644
--- a/drivers/watchdog/pc87413_wdt.c
+++ b/drivers/watchdog/pc87413_wdt.c
@@ -18,6 +18,8 @@
  *      Release 1.1
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/miscdevice.h>
@@ -42,7 +44,6 @@
 
 #define VERSION             "1.1"
 #define MODNAME             "pc87413 WDT"
-#define PFX                 MODNAME ": "
 #define DPFX                MODNAME " - DEBUG: "
 
 #define WDT_INDEX_IO_PORT   (io+0)	/* I/O port base (index register) */
@@ -87,7 +88,7 @@ static inline void pc87413_select_wdt_out(void)
 	outb_p(cr_data, WDT_DATA_IO_PORT);
 
 #ifdef DEBUG
-	printk(KERN_INFO DPFX
+	pr_info(DPFX
 		"Select multiple pin,pin55,as WDT output: Bit7 to 1: %d\n",
 								cr_data);
 #endif
@@ -111,7 +112,7 @@ static inline void pc87413_enable_swc(void)
 	outb_p(cr_data, WDT_DATA_IO_PORT);	/* Index0x30_bit0P1 */
 
 #ifdef DEBUG
-	printk(KERN_INFO DPFX "pc87413 - Enable SWC functions\n");
+	pr_info(DPFX "pc87413 - Enable SWC functions\n");
 #endif
 }
 
@@ -132,7 +133,7 @@ static void pc87413_get_swc_base_addr(void)
 
 	swc_base_addr = (addr_h << 8) + addr_l;
 #ifdef DEBUG
-	printk(KERN_INFO DPFX
+	pr_info(DPFX
 		"Read SWC I/O Base Address: low %d, high %d, res %d\n",
 						addr_l, addr_h, swc_base_addr);
 #endif
@@ -145,7 +146,7 @@ static inline void pc87413_swc_bank3(void)
 	/* Step 4: Select Bank3 of SWC */
 	outb_p(inb(swc_base_addr + 0x0f) | 0x03, swc_base_addr + 0x0f);
 #ifdef DEBUG
-	printk(KERN_INFO DPFX "Select Bank3 of SWC\n");
+	pr_info(DPFX "Select Bank3 of SWC\n");
 #endif
 }
 
@@ -156,7 +157,7 @@ static inline void pc87413_programm_wdto(char pc87413_time)
 	/* Step 5: Programm WDTO, Twd. */
 	outb_p(pc87413_time, swc_base_addr + WDTO);
 #ifdef DEBUG
-	printk(KERN_INFO DPFX "Set WDTO to %d minutes\n", pc87413_time);
+	pr_info(DPFX "Set WDTO to %d minutes\n", pc87413_time);
 #endif
 }
 
@@ -167,7 +168,7 @@ static inline void pc87413_enable_wden(void)
 	/* Step 6: Enable WDEN */
 	outb_p(inb(swc_base_addr + WDCTL) | 0x01, swc_base_addr + WDCTL);
 #ifdef DEBUG
-	printk(KERN_INFO DPFX "Enable WDEN\n");
+	pr_info(DPFX "Enable WDEN\n");
 #endif
 }
 
@@ -177,7 +178,7 @@ static inline void pc87413_enable_sw_wd_tren(void)
 	/* Enable SW_WD_TREN */
 	outb_p(inb(swc_base_addr + WDCFG) | 0x80, swc_base_addr + WDCFG);
 #ifdef DEBUG
-	printk(KERN_INFO DPFX "Enable SW_WD_TREN\n");
+	pr_info(DPFX "Enable SW_WD_TREN\n");
 #endif
 }
 
@@ -188,7 +189,7 @@ static inline void pc87413_disable_sw_wd_tren(void)
 	/* Disable SW_WD_TREN */
 	outb_p(inb(swc_base_addr + WDCFG) & 0x7f, swc_base_addr + WDCFG);
 #ifdef DEBUG
-	printk(KERN_INFO DPFX "pc87413 - Disable SW_WD_TREN\n");
+	pr_info(DPFX "pc87413 - Disable SW_WD_TREN\n");
 #endif
 }
 
@@ -199,7 +200,7 @@ static inline void pc87413_enable_sw_wd_trg(void)
 	/* Enable SW_WD_TRG */
 	outb_p(inb(swc_base_addr + WDCTL) | 0x80, swc_base_addr + WDCTL);
 #ifdef DEBUG
-	printk(KERN_INFO DPFX "pc87413 - Enable SW_WD_TRG\n");
+	pr_info(DPFX "pc87413 - Enable SW_WD_TRG\n");
 #endif
 }
 
@@ -210,7 +211,7 @@ static inline void pc87413_disable_sw_wd_trg(void)
 	/* Disable SW_WD_TRG */
 	outb_p(inb(swc_base_addr + WDCTL) & 0x7f, swc_base_addr + WDCTL);
 #ifdef DEBUG
-	printk(KERN_INFO DPFX "Disable SW_WD_TRG\n");
+	pr_info(DPFX "Disable SW_WD_TRG\n");
 #endif
 }
 
@@ -284,8 +285,7 @@ static int pc87413_open(struct inode *inode, struct file *file)
 	/* Reload and activate timer */
 	pc87413_refresh();
 
-	printk(KERN_INFO MODNAME
-		"Watchdog enabled. Timeout set to %d minute(s).\n", timeout);
+	pr_info("Watchdog enabled. Timeout set to %d minute(s).\n", timeout);
 
 	return nonseekable_open(inode, file);
 }
@@ -308,11 +308,9 @@ static int pc87413_release(struct inode *inode, struct file *file)
 
 	if (expect_close == 42) {
 		pc87413_disable();
-		printk(KERN_INFO MODNAME
-				"Watchdog disabled, sleeping again...\n");
+		pr_info("Watchdog disabled, sleeping again...\n");
 	} else {
-		printk(KERN_CRIT MODNAME
-				"Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		pc87413_refresh();
 	}
 	clear_bit(0, &timer_enabled);
@@ -428,7 +426,7 @@ static long pc87413_ioctl(struct file *file, unsigned int cmd,
 	case WDIOC_KEEPALIVE:
 		pc87413_refresh();
 #ifdef DEBUG
-		printk(KERN_INFO DPFX "keepalive\n");
+		pr_info(DPFX "keepalive\n");
 #endif
 		return 0;
 	case WDIOC_SETTIMEOUT:
@@ -508,7 +506,7 @@ static int __init pc87413_init(void)
 {
 	int ret;
 
-	printk(KERN_INFO PFX "Version " VERSION " at io 0x%X\n",
+	pr_info("Version " VERSION " at io 0x%X\n",
 							WDT_INDEX_IO_PORT);
 
 	if (!request_muxed_region(io, 2, MODNAME))
@@ -516,26 +514,23 @@ static int __init pc87413_init(void)
 
 	ret = register_reboot_notifier(&pc87413_notifier);
 	if (ret != 0) {
-		printk(KERN_ERR PFX
-			"cannot register reboot notifier (err=%d)\n", ret);
+		pr_err("cannot register reboot notifier (err=%d)\n", ret);
 	}
 
 	ret = misc_register(&pc87413_miscdev);
 	if (ret != 0) {
-		printk(KERN_ERR PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
 		goto reboot_unreg;
 	}
-	printk(KERN_INFO PFX "initialized. timeout=%d min \n", timeout);
+	pr_info("initialized. timeout=%d min\n", timeout);
 
 	pc87413_select_wdt_out();
 	pc87413_enable_swc();
 	pc87413_get_swc_base_addr();
 
 	if (!request_region(swc_base_addr, 0x20, MODNAME)) {
-		printk(KERN_ERR PFX
-			"cannot request SWC region at 0x%x\n", swc_base_addr);
+		pr_err("cannot request SWC region at 0x%x\n", swc_base_addr);
 		ret = -EBUSY;
 		goto misc_unreg;
 	}
@@ -568,14 +563,14 @@ static void __exit pc87413_exit(void)
 	/* Stop the timer before we leave */
 	if (!nowayout) {
 		pc87413_disable();
-		printk(KERN_INFO MODNAME "Watchdog disabled.\n");
+		pr_info("Watchdog disabled\n");
 	}
 
 	misc_deregister(&pc87413_miscdev);
 	unregister_reboot_notifier(&pc87413_notifier);
 	release_region(swc_base_addr, 0x20);
 
-	printk(KERN_INFO MODNAME " watchdog component driver removed.\n");
+	pr_info("watchdog component driver removed\n");
 }
 
 module_init(pc87413_init);
diff --git a/drivers/watchdog/pcwd.c b/drivers/watchdog/pcwd.c
index 06f7922..fe370de 100644
--- a/drivers/watchdog/pcwd.c
+++ b/drivers/watchdog/pcwd.c
@@ -51,6 +51,8 @@
  *	http://www.pcwatchdog.com/
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>	/* For module specific items */
 #include <linux/moduleparam.h>	/* For new moduleparam's */
 #include <linux/types.h>	/* For standard types (like size_t) */
@@ -75,7 +77,6 @@
 #define WATCHDOG_DATE "18 Feb 2007"
 #define WATCHDOG_DRIVER_NAME "ISA-PC Watchdog"
 #define WATCHDOG_NAME "pcwd"
-#define PFX WATCHDOG_NAME ": "
 #define DRIVER_VERSION WATCHDOG_DRIVER_NAME " driver, v" WATCHDOG_VERSION "\n"
 
 /*
@@ -220,8 +221,7 @@ static int send_isa_command(int cmd)
 	int port0, last_port0;	/* Double read for stabilising */
 
 	if (debug >= DEBUG)
-		printk(KERN_DEBUG PFX "sending following data cmd=0x%02x\n",
-			cmd);
+		pr_debug("sending following data cmd=0x%02x\n", cmd);
 
 	/* The WCMD bit must be 1 and the command is only 4 bits in size */
 	control_status = (cmd & 0x0F) | WD_WCMD;
@@ -240,9 +240,8 @@ static int send_isa_command(int cmd)
 	}
 
 	if (debug >= DEBUG)
-		printk(KERN_DEBUG PFX "received following data for "
-			"cmd=0x%02x: port0=0x%02x last_port0=0x%02x\n",
-			cmd, port0, last_port0);
+		pr_debug("received following data for cmd=0x%02x: port0=0x%02x last_port0=0x%02x\n",
+			 cmd, port0, last_port0);
 
 	return port0;
 }
@@ -271,8 +270,7 @@ static int set_command_mode(void)
 	pcwd_private.command_mode = found;
 
 	if (debug >= DEBUG)
-		printk(KERN_DEBUG PFX "command_mode=%d\n",
-				pcwd_private.command_mode);
+		pr_debug("command_mode=%d\n", pcwd_private.command_mode);
 
 	return found;
 }
@@ -288,8 +286,7 @@ static void unset_command_mode(void)
 	pcwd_private.command_mode = 0;
 
 	if (debug >= DEBUG)
-		printk(KERN_DEBUG PFX "command_mode=%d\n",
-				pcwd_private.command_mode);
+		pr_debug("command_mode=%d\n", pcwd_private.command_mode);
 }
 
 static inline void pcwd_check_temperature_support(void)
@@ -336,17 +333,14 @@ static void pcwd_show_card_info(void)
 
 	/* Get some extra info from the hardware (in command/debug/diag mode) */
 	if (pcwd_private.revision == PCWD_REVISION_A)
-		printk(KERN_INFO PFX
-			"ISA-PC Watchdog (REV.A) detected at port 0x%04x\n",
-							pcwd_private.io_addr);
+		pr_info("ISA-PC Watchdog (REV.A) detected at port 0x%04x\n",
+			pcwd_private.io_addr);
 	else if (pcwd_private.revision == PCWD_REVISION_C) {
 		pcwd_get_firmware();
-		printk(KERN_INFO PFX "ISA-PC Watchdog (REV.C) detected at port "
-			"0x%04x (Firmware version: %s)\n",
+		pr_info("ISA-PC Watchdog (REV.C) detected at port 0x%04x (Firmware version: %s)\n",
 			pcwd_private.io_addr, pcwd_private.fw_ver_str);
 		option_switches = pcwd_get_option_switches();
-		printk(KERN_INFO PFX "Option switches (0x%02x): "
-			"Temperature Reset Enable=%s, Power On Delay=%s\n",
+		pr_info("Option switches (0x%02x): Temperature Reset Enable=%s, Power On Delay=%s\n",
 			option_switches,
 			((option_switches & 0x10) ? "ON" : "OFF"),
 			((option_switches & 0x08) ? "ON" : "OFF"));
@@ -359,22 +353,18 @@ static void pcwd_show_card_info(void)
 	}
 
 	if (pcwd_private.supports_temp)
-		printk(KERN_INFO PFX "Temperature Option Detected\n");
+		pr_info("Temperature Option Detected\n");
 
 	if (pcwd_private.boot_status & WDIOF_CARDRESET)
-		printk(KERN_INFO PFX
-			"Previous reboot was caused by the card\n");
+		pr_info("Previous reboot was caused by the card\n");
 
 	if (pcwd_private.boot_status & WDIOF_OVERHEAT) {
-		printk(KERN_EMERG PFX
-			"Card senses a CPU Overheat. Panicking!\n");
-		printk(KERN_EMERG PFX
-			"CPU Overheat\n");
+		pr_emerg("Card senses a CPU Overheat. Panicking!\n");
+		pr_emerg("CPU Overheat\n");
 	}
 
 	if (pcwd_private.boot_status == 0)
-		printk(KERN_INFO PFX
-			"No previous trip detected - Cold boot or reset\n");
+		pr_info("No previous trip detected - Cold boot or reset\n");
 }
 
 static void pcwd_timer_ping(unsigned long data)
@@ -404,8 +394,7 @@ static void pcwd_timer_ping(unsigned long data)
 
 		spin_unlock(&pcwd_private.io_lock);
 	} else {
-		printk(KERN_WARNING PFX
-			"Heartbeat lost! Will not ping the watchdog\n");
+		pr_warn("Heartbeat lost! Will not ping the watchdog\n");
 	}
 }
 
@@ -426,13 +415,13 @@ static int pcwd_start(void)
 		stat_reg = inb_p(pcwd_private.io_addr + 2);
 		spin_unlock(&pcwd_private.io_lock);
 		if (stat_reg & WD_WDIS) {
-			printk(KERN_INFO PFX "Could not start watchdog\n");
+			pr_info("Could not start watchdog\n");
 			return -EIO;
 		}
 	}
 
 	if (debug >= VERBOSE)
-		printk(KERN_DEBUG PFX "Watchdog started\n");
+		pr_debug("Watchdog started\n");
 
 	return 0;
 }
@@ -454,13 +443,13 @@ static int pcwd_stop(void)
 		stat_reg = inb_p(pcwd_private.io_addr + 2);
 		spin_unlock(&pcwd_private.io_lock);
 		if ((stat_reg & WD_WDIS) == 0) {
-			printk(KERN_INFO PFX "Could not stop watchdog\n");
+			pr_info("Could not stop watchdog\n");
 			return -EIO;
 		}
 	}
 
 	if (debug >= VERBOSE)
-		printk(KERN_DEBUG PFX "Watchdog stopped\n");
+		pr_debug("Watchdog stopped\n");
 
 	return 0;
 }
@@ -471,7 +460,7 @@ static int pcwd_keepalive(void)
 	pcwd_private.next_heartbeat = jiffies + (heartbeat * HZ);
 
 	if (debug >= DEBUG)
-		printk(KERN_DEBUG PFX "Watchdog keepalive signal send\n");
+		pr_debug("Watchdog keepalive signal send\n");
 
 	return 0;
 }
@@ -484,8 +473,7 @@ static int pcwd_set_heartbeat(int t)
 	heartbeat = t;
 
 	if (debug >= VERBOSE)
-		printk(KERN_DEBUG PFX "New heartbeat: %d\n",
-		       heartbeat);
+		pr_debug("New heartbeat: %d\n", heartbeat);
 
 	return 0;
 }
@@ -518,8 +506,7 @@ static int pcwd_get_status(int *status)
 		if (control_status & WD_T110) {
 			*status |= WDIOF_OVERHEAT;
 			if (temp_panic) {
-				printk(KERN_INFO PFX
-					"Temperature overheat trip!\n");
+				pr_info("Temperature overheat trip!\n");
 				kernel_power_off();
 			}
 		}
@@ -530,8 +517,7 @@ static int pcwd_get_status(int *status)
 		if (control_status & WD_REVC_TTRP) {
 			*status |= WDIOF_OVERHEAT;
 			if (temp_panic) {
-				printk(KERN_INFO PFX
-					"Temperature overheat trip!\n");
+				pr_info("Temperature overheat trip!\n");
 				kernel_power_off();
 			}
 		}
@@ -548,16 +534,14 @@ static int pcwd_clear_status(void)
 		spin_lock(&pcwd_private.io_lock);
 
 		if (debug >= VERBOSE)
-			printk(KERN_INFO PFX
-					"clearing watchdog trip status\n");
+			pr_info("clearing watchdog trip status\n");
 
 		control_status = inb_p(pcwd_private.io_addr + 1);
 
 		if (debug >= DEBUG) {
-			printk(KERN_DEBUG PFX "status was: 0x%02x\n",
-				control_status);
-			printk(KERN_DEBUG PFX "sending: 0x%02x\n",
-				(control_status & WD_REVC_R2DS));
+			pr_debug("status was: 0x%02x\n", control_status);
+			pr_debug("sending: 0x%02x\n",
+				 (control_status & WD_REVC_R2DS));
 		}
 
 		/* clear reset status & Keep Relay 2 disable state as it is */
@@ -588,8 +572,7 @@ static int pcwd_get_temperature(int *temperature)
 	spin_unlock(&pcwd_private.io_lock);
 
 	if (debug >= DEBUG) {
-		printk(KERN_DEBUG PFX "temperature is: %d F\n",
-			*temperature);
+		pr_debug("temperature is: %d F\n", *temperature);
 	}
 
 	return 0;
@@ -720,8 +703,7 @@ static int pcwd_close(struct inode *inode, struct file *file)
 	if (expect_close == 42)
 		pcwd_stop();
 	else {
-		printk(KERN_CRIT PFX
-			"Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		pcwd_keepalive();
 	}
 	expect_close = 0;
@@ -828,11 +810,10 @@ static int __devinit pcwd_isa_match(struct device *dev, unsigned int id)
 	int retval;
 
 	if (debug >= DEBUG)
-		printk(KERN_DEBUG PFX "pcwd_isa_match id=%d\n",
-			id);
+		pr_debug("pcwd_isa_match id=%d\n", id);
 
 	if (!request_region(base_addr, 4, "PCWD")) {
-		printk(KERN_INFO PFX "Port 0x%04x unavailable\n", base_addr);
+		pr_info("Port 0x%04x unavailable\n", base_addr);
 		return 0;
 	}
 
@@ -870,21 +851,20 @@ static int __devinit pcwd_isa_probe(struct device *dev, unsigned int id)
 	int ret;
 
 	if (debug >= DEBUG)
-		printk(KERN_DEBUG PFX "pcwd_isa_probe id=%d\n",
-			id);
+		pr_debug("pcwd_isa_probe id=%d\n", id);
 
 	cards_found++;
 	if (cards_found == 1)
-		printk(KERN_INFO PFX "v%s Ken Hollis (kenji@bitgate.com)\n",
+		pr_info("v%s Ken Hollis (kenji@bitgate.com)\n",
 							WATCHDOG_VERSION);
 
 	if (cards_found > 1) {
-		printk(KERN_ERR PFX "This driver only supports 1 device\n");
+		pr_err("This driver only supports 1 device\n");
 		return -ENODEV;
 	}
 
 	if (pcwd_ioports[id] == 0x0000) {
-		printk(KERN_ERR PFX "No I/O-Address for card detected\n");
+		pr_err("No I/O-Address for card detected\n");
 		return -ENODEV;
 	}
 	pcwd_private.io_addr = pcwd_ioports[id];
@@ -896,8 +876,8 @@ static int __devinit pcwd_isa_probe(struct device *dev, unsigned int id)
 
 	if (!request_region(pcwd_private.io_addr,
 		(pcwd_private.revision == PCWD_REVISION_A) ? 2 : 4, "PCWD")) {
-		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
-			pcwd_private.io_addr);
+		pr_err("I/O address 0x%04x already in use\n",
+		       pcwd_private.io_addr);
 		ret = -EIO;
 		goto error_request_region;
 	}
@@ -932,30 +912,27 @@ static int __devinit pcwd_isa_probe(struct device *dev, unsigned int id)
 	   if not reset to the default */
 	if (pcwd_set_heartbeat(heartbeat)) {
 		pcwd_set_heartbeat(WATCHDOG_HEARTBEAT);
-		printk(KERN_INFO PFX
-		  "heartbeat value must be 2 <= heartbeat <= 7200, using %d\n",
-							WATCHDOG_HEARTBEAT);
+		pr_info("heartbeat value must be 2 <= heartbeat <= 7200, using %d\n",
+			WATCHDOG_HEARTBEAT);
 	}
 
 	if (pcwd_private.supports_temp) {
 		ret = misc_register(&temp_miscdev);
 		if (ret) {
-			printk(KERN_ERR PFX
-			    "cannot register miscdev on minor=%d (err=%d)\n",
-							TEMP_MINOR, ret);
+			pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+			       TEMP_MINOR, ret);
 			goto error_misc_register_temp;
 		}
 	}
 
 	ret = misc_register(&pcwd_miscdev);
 	if (ret) {
-		printk(KERN_ERR PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-					WATCHDOG_MINOR, ret);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
 		goto error_misc_register_watchdog;
 	}
 
-	printk(KERN_INFO PFX "initialized. heartbeat=%d sec (nowayout=%d)\n",
+	pr_info("initialized. heartbeat=%d sec (nowayout=%d)\n",
 		heartbeat, nowayout);
 
 	return 0;
@@ -975,8 +952,7 @@ error_request_region:
 static int __devexit pcwd_isa_remove(struct device *dev, unsigned int id)
 {
 	if (debug >= DEBUG)
-		printk(KERN_DEBUG PFX "pcwd_isa_remove id=%d\n",
-			id);
+		pr_debug("pcwd_isa_remove id=%d\n", id);
 
 	if (!pcwd_private.io_addr)
 		return 1;
@@ -1000,8 +976,7 @@ static int __devexit pcwd_isa_remove(struct device *dev, unsigned int id)
 static void pcwd_isa_shutdown(struct device *dev, unsigned int id)
 {
 	if (debug >= DEBUG)
-		printk(KERN_DEBUG PFX "pcwd_isa_shutdown id=%d\n",
-			id);
+		pr_debug("pcwd_isa_shutdown id=%d\n", id);
 
 	pcwd_stop();
 }
@@ -1025,7 +1000,7 @@ static int __init pcwd_init_module(void)
 static void __exit pcwd_cleanup_module(void)
 {
 	isa_unregister_driver(&pcwd_isa_driver);
-	printk(KERN_INFO PFX "Watchdog Module Unloaded.\n");
+	pr_info("Watchdog Module Unloaded\n");
 }
 
 module_init(pcwd_init_module);
diff --git a/drivers/watchdog/pcwd_pci.c b/drivers/watchdog/pcwd_pci.c
index b8d14f8..75f2fa8 100644
--- a/drivers/watchdog/pcwd_pci.c
+++ b/drivers/watchdog/pcwd_pci.c
@@ -32,6 +32,8 @@
  *	Includes, defines, variables, module parameters, ...
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>	/* For module specific items */
 #include <linux/moduleparam.h>	/* For new moduleparam's */
 #include <linux/types.h>	/* For standard types (like size_t) */
@@ -54,8 +56,7 @@
 #define WATCHDOG_VERSION "1.03"
 #define WATCHDOG_DRIVER_NAME "PCI-PC Watchdog"
 #define WATCHDOG_NAME "pcwd_pci"
-#define PFX WATCHDOG_NAME ": "
-#define DRIVER_VERSION WATCHDOG_DRIVER_NAME " driver, v" WATCHDOG_VERSION "\n"
+#define DRIVER_VERSION WATCHDOG_DRIVER_NAME " driver, v" WATCHDOG_VERSION
 
 /* Stuff for the PCI ID's  */
 #ifndef PCI_VENDOR_ID_QUICKLOGIC
@@ -159,8 +160,8 @@ static int send_command(int cmd, int *msb, int *lsb)
 	int got_response, count;
 
 	if (debug >= DEBUG)
-		printk(KERN_DEBUG PFX "sending following data "
-		"cmd=0x%02x msb=0x%02x lsb=0x%02x\n", cmd, *msb, *lsb);
+		pr_debug("sending following data cmd=0x%02x msb=0x%02x lsb=0x%02x\n",
+			 cmd, *msb, *lsb);
 
 	spin_lock(&pcipcwd_private.io_lock);
 	/* If a command requires data it should be written first.
@@ -185,12 +186,10 @@ static int send_command(int cmd, int *msb, int *lsb)
 
 	if (debug >= DEBUG) {
 		if (got_response) {
-			printk(KERN_DEBUG PFX
-				"time to process command was: %d ms\n",
-				count);
+			pr_debug("time to process command was: %d ms\n",
+				 count);
 		} else {
-			printk(KERN_DEBUG PFX
-				"card did not respond on command!\n");
+			pr_debug("card did not respond on command!\n");
 		}
 	}
 
@@ -203,9 +202,8 @@ static int send_command(int cmd, int *msb, int *lsb)
 		inb_p(pcipcwd_private.io_addr + 6);
 
 		if (debug >= DEBUG)
-			printk(KERN_DEBUG PFX "received following data for "
-				"cmd=0x%02x: msb=0x%02x lsb=0x%02x\n",
-				cmd, *msb, *lsb);
+			pr_debug("received following data for cmd=0x%02x: msb=0x%02x lsb=0x%02x\n",
+				 cmd, *msb, *lsb);
 	}
 
 	spin_unlock(&pcipcwd_private.io_lock);
@@ -243,27 +241,23 @@ static void pcipcwd_show_card_info(void)
 	/* Get switch settings */
 	option_switches = pcipcwd_get_option_switches();
 
-	printk(KERN_INFO PFX "Found card at port "
-		"0x%04x (Firmware: %s) %s temp option\n",
+	pr_info("Found card at port 0x%04x (Firmware: %s) %s temp option\n",
 		(int) pcipcwd_private.io_addr, fw_ver_str,
 		(pcipcwd_private.supports_temp ? "with" : "without"));
 
-	printk(KERN_INFO PFX "Option switches (0x%02x): "
-		"Temperature Reset Enable=%s, Power On Delay=%s\n",
+	pr_info("Option switches (0x%02x): Temperature Reset Enable=%s, Power On Delay=%s\n",
 		option_switches,
 		((option_switches & 0x10) ? "ON" : "OFF"),
 		((option_switches & 0x08) ? "ON" : "OFF"));
 
 	if (pcipcwd_private.boot_status & WDIOF_CARDRESET)
-		printk(KERN_INFO PFX
-			"Previous reset was caused by the Watchdog card\n");
+		pr_info("Previous reset was caused by the Watchdog card\n");
 
 	if (pcipcwd_private.boot_status & WDIOF_OVERHEAT)
-		printk(KERN_INFO PFX "Card sensed a CPU Overheat\n");
+		pr_info("Card sensed a CPU Overheat\n");
 
 	if (pcipcwd_private.boot_status == 0)
-		printk(KERN_INFO PFX
-			"No previous trip detected - Cold boot or reset\n");
+		pr_info("No previous trip detected - Cold boot or reset\n");
 }
 
 static int pcipcwd_start(void)
@@ -278,12 +272,12 @@ static int pcipcwd_start(void)
 	spin_unlock(&pcipcwd_private.io_lock);
 
 	if (stat_reg & WD_PCI_WDIS) {
-		printk(KERN_ERR PFX "Card timer not enabled\n");
+		pr_err("Card timer not enabled\n");
 		return -1;
 	}
 
 	if (debug >= VERBOSE)
-		printk(KERN_DEBUG PFX "Watchdog started\n");
+		pr_debug("Watchdog started\n");
 
 	return 0;
 }
@@ -303,13 +297,12 @@ static int pcipcwd_stop(void)
 	spin_unlock(&pcipcwd_private.io_lock);
 
 	if (!(stat_reg & WD_PCI_WDIS)) {
-		printk(KERN_ERR PFX
-			"Card did not acknowledge disable attempt\n");
+		pr_err("Card did not acknowledge disable attempt\n");
 		return -1;
 	}
 
 	if (debug >= VERBOSE)
-		printk(KERN_DEBUG PFX "Watchdog stopped\n");
+		pr_debug("Watchdog stopped\n");
 
 	return 0;
 }
@@ -322,7 +315,7 @@ static int pcipcwd_keepalive(void)
 	spin_unlock(&pcipcwd_private.io_lock);
 
 	if (debug >= DEBUG)
-		printk(KERN_DEBUG PFX "Watchdog keepalive signal send\n");
+		pr_debug("Watchdog keepalive signal send\n");
 
 	return 0;
 }
@@ -340,8 +333,7 @@ static int pcipcwd_set_heartbeat(int t)
 
 	heartbeat = t;
 	if (debug >= VERBOSE)
-		printk(KERN_DEBUG PFX "New heartbeat: %d\n",
-		       heartbeat);
+		pr_debug("New heartbeat: %d\n", heartbeat);
 
 	return 0;
 }
@@ -357,12 +349,11 @@ static int pcipcwd_get_status(int *status)
 	if (control_status & WD_PCI_TTRP) {
 		*status |= WDIOF_OVERHEAT;
 		if (temp_panic)
-			panic(PFX "Temperature overheat trip!\n");
+			panic(KBUILD_MODNAME ": Temperature overheat trip!\n");
 	}
 
 	if (debug >= DEBUG)
-		printk(KERN_DEBUG PFX "Control Status #1: 0x%02x\n",
-		       control_status);
+		pr_debug("Control Status #1: 0x%02x\n", control_status);
 
 	return 0;
 }
@@ -374,14 +365,14 @@ static int pcipcwd_clear_status(void)
 	int reset_counter;
 
 	if (debug >= VERBOSE)
-		printk(KERN_INFO PFX "clearing watchdog trip status & LED\n");
+		pr_info("clearing watchdog trip status & LED\n");
 
 	control_status = inb_p(pcipcwd_private.io_addr + 1);
 
 	if (debug >= DEBUG) {
-		printk(KERN_DEBUG PFX "status was: 0x%02x\n", control_status);
-		printk(KERN_DEBUG PFX "sending: 0x%02x\n",
-		       (control_status & WD_PCI_R2DS) | WD_PCI_WTRP);
+		pr_debug("status was: 0x%02x\n", control_status);
+		pr_debug("sending: 0x%02x\n",
+			 (control_status & WD_PCI_R2DS) | WD_PCI_WTRP);
 	}
 
 	/* clear trip status & LED and keep mode of relay 2 */
@@ -394,8 +385,7 @@ static int pcipcwd_clear_status(void)
 	send_command(CMD_GET_CLEAR_RESET_COUNT, &msb, &reset_counter);
 
 	if (debug >= DEBUG) {
-		printk(KERN_DEBUG PFX "reset count was: 0x%02x\n",
-		       reset_counter);
+		pr_debug("reset count was: 0x%02x\n", reset_counter);
 	}
 
 	return 0;
@@ -418,8 +408,7 @@ static int pcipcwd_get_temperature(int *temperature)
 	*temperature = (*temperature * 9 / 5) + 32;
 
 	if (debug >= DEBUG) {
-		printk(KERN_DEBUG PFX "temperature is: %d F\n",
-		       *temperature);
+		pr_debug("temperature is: %d F\n", *temperature);
 	}
 
 	return 0;
@@ -437,8 +426,7 @@ static int pcipcwd_get_timeleft(int *time_left)
 	*time_left = (msb << 8) + lsb;
 
 	if (debug >= VERBOSE)
-		printk(KERN_DEBUG PFX "Time left before next reboot: %d\n",
-		       *time_left);
+		pr_debug("Time left before next reboot: %d\n", *time_left);
 
 	return 0;
 }
@@ -583,8 +571,7 @@ static int pcipcwd_open(struct inode *inode, struct file *file)
 	/* /dev/watchdog can only be opened once */
 	if (test_and_set_bit(0, &is_active)) {
 		if (debug >= VERBOSE)
-			printk(KERN_ERR PFX
-				"Attempt to open already opened device.\n");
+			pr_err("Attempt to open already opened device\n");
 		return -EBUSY;
 	}
 
@@ -602,8 +589,7 @@ static int pcipcwd_release(struct inode *inode, struct file *file)
 	if (expect_release == 42) {
 		pcipcwd_stop();
 	} else {
-		printk(KERN_CRIT PFX
-			"Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		pcipcwd_keepalive();
 	}
 	expect_release = 0;
@@ -703,20 +689,20 @@ static int __devinit pcipcwd_card_init(struct pci_dev *pdev,
 
 	cards_found++;
 	if (cards_found == 1)
-		printk(KERN_INFO PFX DRIVER_VERSION);
+		pr_info("%s\n", DRIVER_VERSION);
 
 	if (cards_found > 1) {
-		printk(KERN_ERR PFX "This driver only supports 1 device\n");
+		pr_err("This driver only supports 1 device\n");
 		return -ENODEV;
 	}
 
 	if (pci_enable_device(pdev)) {
-		printk(KERN_ERR PFX "Not possible to enable PCI Device\n");
+		pr_err("Not possible to enable PCI Device\n");
 		return -ENODEV;
 	}
 
 	if (pci_resource_start(pdev, 0) == 0x0000) {
-		printk(KERN_ERR PFX "No I/O-Address for card detected\n");
+		pr_err("No I/O-Address for card detected\n");
 		ret = -ENODEV;
 		goto err_out_disable_device;
 	}
@@ -725,8 +711,8 @@ static int __devinit pcipcwd_card_init(struct pci_dev *pdev,
 	pcipcwd_private.io_addr = pci_resource_start(pdev, 0);
 
 	if (pci_request_regions(pdev, WATCHDOG_NAME)) {
-		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
-			(int) pcipcwd_private.io_addr);
+		pr_err("I/O address 0x%04x already in use\n",
+		       (int) pcipcwd_private.io_addr);
 		ret = -EIO;
 		goto err_out_disable_device;
 	}
@@ -755,36 +741,33 @@ static int __devinit pcipcwd_card_init(struct pci_dev *pdev,
 	 * if not reset to the default */
 	if (pcipcwd_set_heartbeat(heartbeat)) {
 		pcipcwd_set_heartbeat(WATCHDOG_HEARTBEAT);
-		printk(KERN_INFO PFX
-			"heartbeat value must be 0<heartbeat<65536, using %d\n",
+		pr_info("heartbeat value must be 0<heartbeat<65536, using %d\n",
 			WATCHDOG_HEARTBEAT);
 	}
 
 	ret = register_reboot_notifier(&pcipcwd_notifier);
 	if (ret != 0) {
-		printk(KERN_ERR PFX
-			"cannot register reboot notifier (err=%d)\n", ret);
+		pr_err("cannot register reboot notifier (err=%d)\n", ret);
 		goto err_out_release_region;
 	}
 
 	if (pcipcwd_private.supports_temp) {
 		ret = misc_register(&pcipcwd_temp_miscdev);
 		if (ret != 0) {
-			printk(KERN_ERR PFX "cannot register miscdev on "
-				"minor=%d (err=%d)\n", TEMP_MINOR, ret);
+			pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+			       TEMP_MINOR, ret);
 			goto err_out_unregister_reboot;
 		}
 	}
 
 	ret = misc_register(&pcipcwd_miscdev);
 	if (ret != 0) {
-		printk(KERN_ERR PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
 		goto err_out_misc_deregister;
 	}
 
-	printk(KERN_INFO PFX "initialized. heartbeat=%d sec (nowayout=%d)\n",
+	pr_info("initialized. heartbeat=%d sec (nowayout=%d)\n",
 		heartbeat, nowayout);
 
 	return 0;
@@ -842,7 +825,7 @@ static void __exit pcipcwd_cleanup_module(void)
 {
 	pci_unregister_driver(&pcipcwd_driver);
 
-	printk(KERN_INFO PFX "Watchdog Module Unloaded.\n");
+	pr_info("Watchdog Module Unloaded\n");
 }
 
 module_init(pcipcwd_init_module);
diff --git a/drivers/watchdog/pcwd_usb.c b/drivers/watchdog/pcwd_usb.c
index d8de1dd..3e66a6b 100644
--- a/drivers/watchdog/pcwd_usb.c
+++ b/drivers/watchdog/pcwd_usb.c
@@ -24,6 +24,8 @@
  *	http://www.berkprod.com/ or http://www.pcwatchdog.com/
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>	/* For module specific items */
 #include <linux/moduleparam.h>	/* For new moduleparam's */
 #include <linux/types.h>	/* For standard types (like size_t) */
@@ -42,17 +44,23 @@
 #include <linux/hid.h>		/* For HID_REQ_SET_REPORT & HID_DT_REPORT */
 #include <linux/uaccess.h>	/* For copy_to_user/put_user/... */
 
-
 #ifdef CONFIG_USB_DEBUG
-	static int debug = 1;
+static int debug = 1;
 #else
-	static int debug;
+static int debug;
 #endif
 
 /* Use our own dbg macro */
+
 #undef dbg
-#define dbg(format, arg...) \
-	do { if (debug) printk(KERN_DEBUG PFX format "\n" , ## arg); } while (0)
+#ifndef DEBUG
+#define DEBUG
+#endif
+#define dbg(format, ...)				\
+do {							\
+	if (debug)					\
+		pr_debug(format "\n", ##__VA_ARGS__);	\
+} while (0)
 
 /* Module and Version Information */
 #define DRIVER_VERSION "1.02"
@@ -60,7 +68,6 @@
 #define DRIVER_DESC "Berkshire USB-PC Watchdog driver"
 #define DRIVER_LICENSE "GPL"
 #define DRIVER_NAME "pcwd_usb"
-#define PFX DRIVER_NAME ": "
 
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
@@ -220,8 +227,8 @@ static void usb_pcwd_intr_done(struct urb *urb)
 resubmit:
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
 	if (retval)
-		printk(KERN_ERR PFX "can't resubmit intr, "
-			"usb_submit_urb failed with result %d\n", retval);
+		pr_err("can't resubmit intr, usb_submit_urb failed with result %d\n",
+		       retval);
 }
 
 static int usb_pcwd_send_command(struct usb_pcwd_private *usb_pcwd,
@@ -284,8 +291,7 @@ static int usb_pcwd_start(struct usb_pcwd_private *usb_pcwd)
 								&msb, &lsb);
 
 	if ((retval == 0) || (lsb == 0)) {
-		printk(KERN_ERR PFX
-				"Card did not acknowledge enable attempt\n");
+		pr_err("Card did not acknowledge enable attempt\n");
 		return -1;
 	}
 
@@ -303,8 +309,7 @@ static int usb_pcwd_stop(struct usb_pcwd_private *usb_pcwd)
 								&msb, &lsb);
 
 	if ((retval == 0) || (lsb != 0)) {
-		printk(KERN_ERR PFX
-			"Card did not acknowledge disable attempt\n");
+		pr_err("Card did not acknowledge disable attempt\n");
 		return -1;
 	}
 
@@ -506,8 +511,7 @@ static int usb_pcwd_release(struct inode *inode, struct file *file)
 	if (expect_release == 42) {
 		usb_pcwd_stop(usb_pcwd_device);
 	} else {
-		printk(KERN_CRIT PFX
-			"Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		usb_pcwd_keepalive(usb_pcwd_device);
 	}
 	expect_release = 0;
@@ -627,7 +631,7 @@ static int usb_pcwd_probe(struct usb_interface *interface,
 
 	cards_found++;
 	if (cards_found > 1) {
-		printk(KERN_ERR PFX "This driver only supports 1 device\n");
+		pr_err("This driver only supports 1 device\n");
 		return -ENODEV;
 	}
 
@@ -636,8 +640,7 @@ static int usb_pcwd_probe(struct usb_interface *interface,
 
 	/* check out that we have a HID device */
 	if (!(iface_desc->desc.bInterfaceClass == USB_CLASS_HID)) {
-		printk(KERN_ERR PFX
-			"The device isn't a Human Interface Device\n");
+		pr_err("The device isn't a Human Interface Device\n");
 		return -ENODEV;
 	}
 
@@ -646,7 +649,7 @@ static int usb_pcwd_probe(struct usb_interface *interface,
 
 	if (!usb_endpoint_is_int_in(endpoint)) {
 		/* we didn't find a Interrupt endpoint with direction IN */
-		printk(KERN_ERR PFX "Couldn't find an INTR & IN endpoint\n");
+		pr_err("Couldn't find an INTR & IN endpoint\n");
 		return -ENODEV;
 	}
 
@@ -657,7 +660,7 @@ static int usb_pcwd_probe(struct usb_interface *interface,
 	/* allocate memory for our device and initialize it */
 	usb_pcwd = kzalloc(sizeof(struct usb_pcwd_private), GFP_KERNEL);
 	if (usb_pcwd == NULL) {
-		printk(KERN_ERR PFX "Out of memory\n");
+		pr_err("Out of memory\n");
 		goto error;
 	}
 
@@ -674,14 +677,14 @@ static int usb_pcwd_probe(struct usb_interface *interface,
 	usb_pcwd->intr_buffer = usb_alloc_coherent(udev, usb_pcwd->intr_size,
 					GFP_ATOMIC, &usb_pcwd->intr_dma);
 	if (!usb_pcwd->intr_buffer) {
-		printk(KERN_ERR PFX "Out of memory\n");
+		pr_err("Out of memory\n");
 		goto error;
 	}
 
 	/* allocate the urb's */
 	usb_pcwd->intr_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!usb_pcwd->intr_urb) {
-		printk(KERN_ERR PFX "Out of memory\n");
+		pr_err("Out of memory\n");
 		goto error;
 	}
 
@@ -694,7 +697,7 @@ static int usb_pcwd_probe(struct usb_interface *interface,
 
 	/* register our interrupt URB with the USB system */
 	if (usb_submit_urb(usb_pcwd->intr_urb, GFP_KERNEL)) {
-		printk(KERN_ERR PFX "Problem registering interrupt URB\n");
+		pr_err("Problem registering interrupt URB\n");
 		retval = -EIO; /* failure */
 		goto error;
 	}
@@ -713,15 +716,13 @@ static int usb_pcwd_probe(struct usb_interface *interface,
 	else
 		sprintf(fw_ver_str, "<card no answer>");
 
-	printk(KERN_INFO PFX "Found card (Firmware: %s) with temp option\n",
-		fw_ver_str);
+	pr_info("Found card (Firmware: %s) with temp option\n", fw_ver_str);
 
 	/* Get switch settings */
 	usb_pcwd_send_command(usb_pcwd, CMD_GET_DIP_SWITCH_SETTINGS, &dummy,
 							&option_switches);
 
-	printk(KERN_INFO PFX "Option switches (0x%02x): "
-		"Temperature Reset Enable=%s, Power On Delay=%s\n",
+	pr_info("Option switches (0x%02x): Temperature Reset Enable=%s, Power On Delay=%s\n",
 		option_switches,
 		((option_switches & 0x10) ? "ON" : "OFF"),
 		((option_switches & 0x08) ? "ON" : "OFF"));
@@ -734,39 +735,34 @@ static int usb_pcwd_probe(struct usb_interface *interface,
 	 * if not reset to the default */
 	if (usb_pcwd_set_heartbeat(usb_pcwd, heartbeat)) {
 		usb_pcwd_set_heartbeat(usb_pcwd, WATCHDOG_HEARTBEAT);
-		printk(KERN_INFO PFX
-			"heartbeat value must be 0<heartbeat<65536, using %d\n",
+		pr_info("heartbeat value must be 0<heartbeat<65536, using %d\n",
 			WATCHDOG_HEARTBEAT);
 	}
 
 	retval = register_reboot_notifier(&usb_pcwd_notifier);
 	if (retval != 0) {
-		printk(KERN_ERR PFX
-			"cannot register reboot notifier (err=%d)\n",
-			retval);
+		pr_err("cannot register reboot notifier (err=%d)\n", retval);
 		goto error;
 	}
 
 	retval = misc_register(&usb_pcwd_temperature_miscdev);
 	if (retval != 0) {
-		printk(KERN_ERR PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-			TEMP_MINOR, retval);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       TEMP_MINOR, retval);
 		goto err_out_unregister_reboot;
 	}
 
 	retval = misc_register(&usb_pcwd_miscdev);
 	if (retval != 0) {
-		printk(KERN_ERR PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, retval);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, retval);
 		goto err_out_misc_deregister;
 	}
 
 	/* we can register the device now, as it is ready */
 	usb_set_intfdata(interface, usb_pcwd);
 
-	printk(KERN_INFO PFX "initialized. heartbeat=%d sec (nowayout=%d)\n",
+	pr_info("initialized. heartbeat=%d sec (nowayout=%d)\n",
 		heartbeat, nowayout);
 
 	return 0;
@@ -824,7 +820,7 @@ static void usb_pcwd_disconnect(struct usb_interface *interface)
 
 	mutex_unlock(&disconnect_mutex);
 
-	printk(KERN_INFO PFX "USB PC Watchdog disconnected\n");
+	pr_info("USB PC Watchdog disconnected\n");
 }
 
 module_usb_driver(usb_pcwd_driver);
diff --git a/drivers/watchdog/pika_wdt.c b/drivers/watchdog/pika_wdt.c
index 2d22e99..e287762 100644
--- a/drivers/watchdog/pika_wdt.c
+++ b/drivers/watchdog/pika_wdt.c
@@ -5,6 +5,8 @@
  *   Sean MacLennan <smaclennan@pikatech.com>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/module.h>
@@ -23,7 +25,6 @@
 #include <linux/of_platform.h>
 
 #define DRV_NAME "PIKA-WDT"
-#define PFX DRV_NAME ": "
 
 /* Hardware timeout in seconds */
 #define WDT_HW_TIMEOUT 2
@@ -90,7 +91,7 @@ static void pikawdt_ping(unsigned long data)
 		pikawdt_reset();
 		mod_timer(&pikawdt_private.timer, jiffies + WDT_TIMEOUT);
 	} else
-		printk(KERN_CRIT PFX "I will reset your machine !\n");
+		pr_crit("I will reset your machine !\n");
 }
 
 
@@ -228,14 +229,14 @@ static int __init pikawdt_init(void)
 
 	np = of_find_compatible_node(NULL, NULL, "pika,fpga");
 	if (np == NULL) {
-		printk(KERN_ERR PFX "Unable to find fpga.\n");
+		pr_err("Unable to find fpga\n");
 		return -ENOENT;
 	}
 
 	pikawdt_private.fpga = of_iomap(np, 0);
 	of_node_put(np);
 	if (pikawdt_private.fpga == NULL) {
-		printk(KERN_ERR PFX "Unable to map fpga.\n");
+		pr_err("Unable to map fpga\n");
 		return -ENOMEM;
 	}
 
@@ -244,7 +245,7 @@ static int __init pikawdt_init(void)
 	/* POST information is in the sd area. */
 	np = of_find_compatible_node(NULL, NULL, "pika,fpga-sd");
 	if (np == NULL) {
-		printk(KERN_ERR PFX "Unable to find fpga-sd.\n");
+		pr_err("Unable to find fpga-sd\n");
 		ret = -ENOENT;
 		goto out;
 	}
@@ -252,7 +253,7 @@ static int __init pikawdt_init(void)
 	fpga = of_iomap(np, 0);
 	of_node_put(np);
 	if (fpga == NULL) {
-		printk(KERN_ERR PFX "Unable to map fpga-sd.\n");
+		pr_err("Unable to map fpga-sd\n");
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -271,12 +272,12 @@ static int __init pikawdt_init(void)
 
 	ret = misc_register(&pikawdt_miscdev);
 	if (ret) {
-		printk(KERN_ERR PFX "Unable to register miscdev.\n");
+		pr_err("Unable to register miscdev\n");
 		goto out;
 	}
 
-	printk(KERN_INFO PFX "initialized. heartbeat=%d sec (nowayout=%d)\n",
-							heartbeat, nowayout);
+	pr_info("initialized. heartbeat=%d sec (nowayout=%d)\n",
+		heartbeat, nowayout);
 	return 0;
 
 out:
diff --git a/drivers/watchdog/pnx4008_wdt.c b/drivers/watchdog/pnx4008_wdt.c
index 8e210aa..40bf9aa 100644
--- a/drivers/watchdog/pnx4008_wdt.c
+++ b/drivers/watchdog/pnx4008_wdt.c
@@ -14,6 +14,8 @@
  * or implied.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -226,7 +228,7 @@ static long pnx4008_wdt_ioctl(struct file *file, unsigned int cmd,
 static int pnx4008_wdt_release(struct inode *inode, struct file *file)
 {
 	if (!test_bit(WDT_OK_TO_CLOSE, &wdt_status))
-		printk(KERN_WARNING "WATCHDOG: Device closed unexpectedly\n");
+		pr_warn("Device closed unexpectedly\n");
 
 	wdt_disable();
 	clk_disable(wdt_clk);
@@ -258,20 +260,18 @@ static int __devinit pnx4008_wdt_probe(struct platform_device *pdev)
 	if (heartbeat < 1 || heartbeat > MAX_HEARTBEAT)
 		heartbeat = DEFAULT_HEARTBEAT;
 
-	printk(KERN_INFO MODULE_NAME
-		"PNX4008 Watchdog Timer: heartbeat %d sec\n", heartbeat);
+	pr_info("PNX4008 Watchdog Timer: heartbeat %d sec\n", heartbeat);
 
 	wdt_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (wdt_mem == NULL) {
-		printk(KERN_INFO MODULE_NAME
-			"failed to get memory region resouce\n");
+		pr_info("failed to get memory region resouce\n");
 		return -ENOENT;
 	}
 
 	size = resource_size(wdt_mem);
 
 	if (!request_mem_region(wdt_mem->start, size, pdev->name)) {
-		printk(KERN_INFO MODULE_NAME "failed to get memory region\n");
+		pr_info("failed to get memory region\n");
 		return -ENOENT;
 	}
 	wdt_base = (void __iomem *)IO_ADDRESS(wdt_mem->start);
@@ -294,7 +294,7 @@ static int __devinit pnx4008_wdt_probe(struct platform_device *pdev)
 
 	ret = misc_register(&pnx4008_wdt_miscdev);
 	if (ret < 0) {
-		printk(KERN_ERR MODULE_NAME "cannot register misc device\n");
+		pr_err("cannot register misc device\n");
 		release_mem_region(wdt_mem->start, size);
 		wdt_mem = NULL;
 		clk_disable(wdt_clk);
diff --git a/drivers/watchdog/pnx833x_wdt.c b/drivers/watchdog/pnx833x_wdt.c
index a7b5ad2..97959e9 100644
--- a/drivers/watchdog/pnx833x_wdt.c
+++ b/drivers/watchdog/pnx833x_wdt.c
@@ -17,6 +17,8 @@
  * based on softdog.c by Alan Cox <alan@redhat.com>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -30,7 +32,6 @@
 #include <linux/init.h>
 #include <asm/mach-pnx833x/pnx833x.h>
 
-#define PFX "pnx833x: "
 #define WATCHDOG_TIMEOUT 30		/* 30 sec Maximum timeout */
 #define WATCHDOG_COUNT_FREQUENCY 68000000U /* Watchdog counts at 68MHZ. */
 #define	PNX_WATCHDOG_TIMEOUT	(WATCHDOG_TIMEOUT * WATCHDOG_COUNT_FREQUENCY)
@@ -76,7 +77,7 @@ static void pnx833x_wdt_start(void)
 	PNX833X_REG(PNX833X_CONFIG +
 				PNX833X_CONFIG_CPU_COUNTERS_CONTROL) |= 0x1;
 
-	printk(KERN_INFO PFX "Started watchdog timer.\n");
+	pr_info("Started watchdog timer\n");
 }
 
 static void pnx833x_wdt_stop(void)
@@ -87,7 +88,7 @@ static void pnx833x_wdt_stop(void)
 	PNX833X_REG(PNX833X_CONFIG +
 			PNX833X_CONFIG_CPU_COUNTERS_CONTROL) &= 0xFFFFFFFE;
 
-	printk(KERN_INFO PFX "Stopped watchdog timer.\n");
+	pr_info("Stopped watchdog timer\n");
 }
 
 static void pnx833x_wdt_ping(void)
@@ -113,7 +114,7 @@ static int pnx833x_wdt_open(struct inode *inode, struct file *file)
 
 	pnx833x_wdt_ping();
 
-	printk(KERN_INFO "Started watchdog timer.\n");
+	pr_info("Started watchdog timer\n");
 
 	return nonseekable_open(inode, file);
 }
@@ -232,9 +233,6 @@ static struct notifier_block pnx833x_wdt_notifier = {
 	.notifier_call = pnx833x_wdt_notify_sys,
 };
 
-static char banner[] __initdata =
-	KERN_INFO PFX "Hardware Watchdog Timer for PNX833x: Version 0.1\n";
-
 static int __init watchdog_init(void)
 {
 	int ret, cause;
@@ -243,27 +241,25 @@ static int __init watchdog_init(void)
 	cause = PNX833X_REG(PNX833X_RESET);
 	/*If bit 31 is set then watchdog was cause of reset.*/
 	if (cause & 0x80000000) {
-		printk(KERN_INFO PFX "The system was previously reset due to "
-			"the watchdog firing - please investigate...\n");
+		pr_info("The system was previously reset due to the watchdog firing - please investigate...\n");
 	}
 
 	ret = register_reboot_notifier(&pnx833x_wdt_notifier);
 	if (ret) {
-		printk(KERN_ERR PFX
-			"cannot register reboot notifier (err=%d)\n", ret);
+		pr_err("cannot register reboot notifier (err=%d)\n", ret);
 		return ret;
 	}
 
 	ret = misc_register(&pnx833x_wdt_miscdev);
 	if (ret) {
-		printk(KERN_ERR PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
 		unregister_reboot_notifier(&pnx833x_wdt_notifier);
 		return ret;
 	}
 
-	printk(banner);
+	pr_info("Hardware Watchdog Timer for PNX833x: Version 0.1\n");
+
 	if (start_enabled)
 		pnx833x_wdt_start();
 
diff --git a/drivers/watchdog/rc32434_wdt.c b/drivers/watchdog/rc32434_wdt.c
index bf7bc8a..76c9d1c 100644
--- a/drivers/watchdog/rc32434_wdt.c
+++ b/drivers/watchdog/rc32434_wdt.c
@@ -17,6 +17,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>		/* For module specific items */
 #include <linux/moduleparam.h>		/* For new moduleparam's */
 #include <linux/types.h>		/* For standard types (like size_t) */
@@ -33,8 +35,6 @@
 
 #include <asm/mach-rc32434/integ.h>	/* For the Watchdog registers */
 
-#define PFX KBUILD_MODNAME ": "
-
 #define VERSION "1.0"
 
 static struct {
@@ -78,8 +78,7 @@ static int rc32434_wdt_set(int new_timeout)
 	int max_to = WTCOMP2SEC((u32)-1);
 
 	if (new_timeout < 0 || new_timeout > max_to) {
-		printk(KERN_ERR PFX "timeout value must be between 0 and %d",
-			max_to);
+		pr_err("timeout value must be between 0 and %d\n", max_to);
 		return -EINVAL;
 	}
 	timeout = new_timeout;
@@ -119,7 +118,7 @@ static void rc32434_wdt_start(void)
 	SET_BITS(wdt_reg->wtc, or, nand);
 
 	spin_unlock(&rc32434_wdt_device.io_lock);
-	printk(KERN_INFO PFX "Started watchdog timer.\n");
+	pr_info("Started watchdog timer\n");
 }
 
 static void rc32434_wdt_stop(void)
@@ -130,7 +129,7 @@ static void rc32434_wdt_stop(void)
 	SET_BITS(wdt_reg->wtc, 0, 1 << RC32434_WTC_EN);
 
 	spin_unlock(&rc32434_wdt_device.io_lock);
-	printk(KERN_INFO PFX "Stopped watchdog timer.\n");
+	pr_info("Stopped watchdog timer\n");
 }
 
 static void rc32434_wdt_ping(void)
@@ -160,8 +159,7 @@ static int rc32434_wdt_release(struct inode *inode, struct file *file)
 		rc32434_wdt_stop();
 		module_put(THIS_MODULE);
 	} else {
-		printk(KERN_CRIT PFX
-			"device closed unexpectedly. WDT will not stop!\n");
+		pr_crit("device closed unexpectedly. WDT will not stop!\n");
 		rc32434_wdt_ping();
 	}
 	clear_bit(0, &rc32434_wdt_device.inuse);
@@ -262,9 +260,6 @@ static struct miscdevice rc32434_wdt_miscdev = {
 	.fops	= &rc32434_wdt_fops,
 };
 
-static char banner[] __devinitdata = KERN_INFO PFX
-		"Watchdog Timer version " VERSION ", timer margin: %d sec\n";
-
 static int __devinit rc32434_wdt_probe(struct platform_device *pdev)
 {
 	int ret;
@@ -272,13 +267,13 @@ static int __devinit rc32434_wdt_probe(struct platform_device *pdev)
 
 	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "rb532_wdt_res");
 	if (!r) {
-		printk(KERN_ERR PFX "failed to retrieve resources\n");
+		pr_err("failed to retrieve resources\n");
 		return -ENODEV;
 	}
 
 	wdt_reg = ioremap_nocache(r->start, resource_size(r));
 	if (!wdt_reg) {
-		printk(KERN_ERR PFX "failed to remap I/O resources\n");
+		pr_err("failed to remap I/O resources\n");
 		return -ENXIO;
 	}
 
@@ -291,18 +286,18 @@ static int __devinit rc32434_wdt_probe(struct platform_device *pdev)
 	 * if not reset to the default */
 	if (rc32434_wdt_set(timeout)) {
 		rc32434_wdt_set(WATCHDOG_TIMEOUT);
-		printk(KERN_INFO PFX
-			"timeout value must be between 0 and %d\n",
+		pr_info("timeout value must be between 0 and %d\n",
 			WTCOMP2SEC((u32)-1));
 	}
 
 	ret = misc_register(&rc32434_wdt_miscdev);
 	if (ret < 0) {
-		printk(KERN_ERR PFX "failed to register watchdog device\n");
+		pr_err("failed to register watchdog device\n");
 		goto unmap;
 	}
 
-	printk(banner, timeout);
+	pr_info("Watchdog Timer version " VERSION ", timer margin: %d sec\n",
+		timeout);
 
 	return 0;
 
diff --git a/drivers/watchdog/riowd.c b/drivers/watchdog/riowd.c
index c7e17ce..49e1b1c 100644
--- a/drivers/watchdog/riowd.c
+++ b/drivers/watchdog/riowd.c
@@ -3,6 +3,8 @@
  * Copyright (C) 2001, 2008 David S. Miller (davem@davemloft.net)
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/types.h>
@@ -189,7 +191,7 @@ static int __devinit riowd_probe(struct platform_device *op)
 
 	p->regs = of_ioremap(&op->resource[0], 0, 2, DRIVER_NAME);
 	if (!p->regs) {
-		printk(KERN_ERR PFX "Cannot map registers.\n");
+		pr_err("Cannot map registers\n");
 		goto out_free;
 	}
 	/* Make miscdev useable right away */
@@ -197,12 +199,12 @@ static int __devinit riowd_probe(struct platform_device *op)
 
 	err = misc_register(&riowd_miscdev);
 	if (err) {
-		printk(KERN_ERR PFX "Cannot register watchdog misc device.\n");
+		pr_err("Cannot register watchdog misc device\n");
 		goto out_iounmap;
 	}
 
-	printk(KERN_INFO PFX "Hardware watchdog [%i minutes], "
-	       "regs at %p\n", riowd_timeout, p->regs);
+	pr_info("Hardware watchdog [%i minutes], regs at %p\n",
+		riowd_timeout, p->regs);
 
 	dev_set_drvdata(&op->dev, p);
 	return 0;
diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index 404172f..ce18029 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -23,6 +23,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -46,8 +48,6 @@
 
 #include <plat/regs-watchdog.h>
 
-#define PFX "s3c2410-wdt: "
-
 #define CONFIG_S3C2410_WATCHDOG_ATBOOT		(0)
 #define CONFIG_S3C2410_WATCHDOG_DEFAULT_TIME	(15)
 
@@ -84,10 +84,11 @@ static DEFINE_SPINLOCK(wdt_lock);
 
 /* watchdog control routines */
 
-#define DBG(msg...) do { \
-	if (debug) \
-		printk(KERN_INFO msg); \
-	} while (0)
+#define DBG(fmt, ...)					\
+do {							\
+	if (debug)					\
+		pr_info(fmt, ##__VA_ARGS__);		\
+} while (0)
 
 /* functions */
 
@@ -354,7 +355,7 @@ static int __devinit s3c2410wdt_probe(struct platform_device *pdev)
 
 	ret = s3c2410wdt_cpufreq_register();
 	if (ret < 0) {
-		printk(KERN_ERR PFX "failed to register cpufreq\n");
+		pr_err("failed to register cpufreq\n");
 		goto err_clk;
 	}
 
@@ -483,8 +484,8 @@ static int s3c2410wdt_resume(struct platform_device *dev)
 	writel(wtdat_save, wdt_base + S3C2410_WTCNT); /* Reset count */
 	writel(wtcon_save, wdt_base + S3C2410_WTCON);
 
-	printk(KERN_INFO PFX "watchdog %sabled\n",
-	       (wtcon_save & S3C2410_WTCON_ENABLE) ? "en" : "dis");
+	pr_info("watchdog %sabled\n",
+		(wtcon_save & S3C2410_WTCON_ENABLE) ? "en" : "dis");
 
 	return 0;
 }
@@ -518,12 +519,10 @@ static struct platform_driver s3c2410wdt_driver = {
 };
 
 
-static char banner[] __initdata =
-	KERN_INFO "S3C2410 Watchdog Timer, (c) 2004 Simtec Electronics\n";
-
 static int __init watchdog_init(void)
 {
-	printk(banner);
+	pr_info("S3C2410 Watchdog Timer, (c) 2004 Simtec Electronics\n";
+
 	return platform_driver_register(&s3c2410wdt_driver);
 }
 
diff --git a/drivers/watchdog/sa1100_wdt.c b/drivers/watchdog/sa1100_wdt.c
index 0162454..d54e04d 100644
--- a/drivers/watchdog/sa1100_wdt.c
+++ b/drivers/watchdog/sa1100_wdt.c
@@ -17,6 +17,9 @@
  *
  *	27/11/2000 Initial release
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -66,7 +69,7 @@ static int sa1100dog_open(struct inode *inode, struct file *file)
  */
 static int sa1100dog_release(struct inode *inode, struct file *file)
 {
-	printk(KERN_CRIT "WATCHDOG: Device closed - timer will not stop\n");
+	pr_crit("Device closed - timer will not stop\n");
 	clear_bit(1, &sa1100wdt_users);
 	return 0;
 }
@@ -169,9 +172,8 @@ static int __init sa1100dog_init(void)
 
 	ret = misc_register(&sa1100dog_miscdev);
 	if (ret == 0)
-		printk(KERN_INFO
-			"SA1100/PXA2xx Watchdog Timer: timer margin %d sec\n",
-						margin);
+		pr_info("SA1100/PXA2xx Watchdog Timer: timer margin %d sec\n",
+			margin);
 	return ret;
 }
 
diff --git a/drivers/watchdog/sb_wdog.c b/drivers/watchdog/sb_wdog.c
index b01a30e..e1e6551 100644
--- a/drivers/watchdog/sb_wdog.c
+++ b/drivers/watchdog/sb_wdog.c
@@ -43,6 +43,9 @@
  *	version 1 or 2 as published by the Free Software Foundation.
  *
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/io.h>
 #include <linux/uaccess.h>
@@ -125,9 +128,8 @@ static int sbwdog_release(struct inode *inode, struct file *file)
 		__raw_writeb(0, user_dog);
 		module_put(THIS_MODULE);
 	} else {
-		printk(KERN_CRIT
-			"%s: Unexpected close, not stopping watchdog!\n",
-						ident.identity);
+		pr_crit("%s: Unexpected close, not stopping watchdog!\n",
+			ident.identity);
 		sbwdog_pet(user_dog);
 	}
 	clear_bit(0, &sbwdog_gate);
@@ -269,8 +271,7 @@ irqreturn_t sbwdog_interrupt(int irq, void *addr)
 	 * if it's the second watchdog timer, it's for those users
 	 */
 	if (wd_cfg_reg == user_dog)
-		printk(KERN_CRIT "%s in danger of initiating system reset "
-			"in %ld.%01ld seconds\n",
+		pr_crit("%s in danger of initiating system reset in %ld.%01ld seconds\n",
 			ident.identity,
 			wd_init / 1000000, (wd_init / 100000) % 10);
 	else
@@ -290,9 +291,8 @@ static int __init sbwdog_init(void)
 	 */
 	ret = register_reboot_notifier(&sbwdog_notifier);
 	if (ret) {
-		printk(KERN_ERR
-			"%s: cannot register reboot notifier (err=%d)\n",
-						ident.identity, ret);
+		pr_err("%s: cannot register reboot notifier (err=%d)\n",
+		       ident.identity, ret);
 		return ret;
 	}
 
@@ -303,16 +303,16 @@ static int __init sbwdog_init(void)
 	ret = request_irq(1, sbwdog_interrupt, IRQF_SHARED,
 		ident.identity, (void *)user_dog);
 	if (ret) {
-		printk(KERN_ERR "%s: failed to request irq 1 - %d\n",
-						ident.identity, ret);
+		pr_err("%s: failed to request irq 1 - %d\n",
+		       ident.identity, ret);
 		goto out;
 	}
 
 	ret = misc_register(&sbwdog_miscdev);
 	if (ret == 0) {
-		printk(KERN_INFO "%s: timeout is %ld.%ld secs\n",
-				ident.identity,
-				timeout / 1000000, (timeout / 100000) % 10);
+		pr_info("%s: timeout is %ld.%ld secs\n",
+			ident.identity,
+			timeout / 1000000, (timeout / 100000) % 10);
 		return 0;
 	}
 	free_irq(1, (void *)user_dog);
@@ -353,8 +353,7 @@ void platform_wd_setup(void)
 	ret = request_irq(1, sbwdog_interrupt, IRQF_SHARED,
 		"Kernel Watchdog", IOADDR(A_SCD_WDOG_CFG_0));
 	if (ret) {
-		printk(KERN_CRIT
-		  "Watchdog IRQ zero(0) failed to be requested - %d\n", ret);
+		pr_crit("Watchdog IRQ zero(0) failed to be requested - %d\n", ret);
 	}
 }
 
diff --git a/drivers/watchdog/sbc60xxwdt.c b/drivers/watchdog/sbc60xxwdt.c
index 626d0e8..1d0c971 100644
--- a/drivers/watchdog/sbc60xxwdt.c
+++ b/drivers/watchdog/sbc60xxwdt.c
@@ -48,6 +48,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -132,8 +134,7 @@ static void wdt_timer_ping(unsigned long data)
 		/* Re-set the timer interval */
 		mod_timer(&timer, jiffies + WDT_INTERVAL);
 	} else
-		printk(KERN_WARNING PFX
-			"Heartbeat lost! Will not ping the watchdog\n");
+		pr_warn("Heartbeat lost! Will not ping the watchdog\n");
 }
 
 /*
@@ -146,7 +147,7 @@ static void wdt_startup(void)
 
 	/* Start the timer */
 	mod_timer(&timer, jiffies + WDT_INTERVAL);
-	printk(KERN_INFO PFX "Watchdog timer is now enabled.\n");
+	pr_info("Watchdog timer is now enabled\n");
 }
 
 static void wdt_turnoff(void)
@@ -154,7 +155,7 @@ static void wdt_turnoff(void)
 	/* Stop the timer */
 	del_timer(&timer);
 	inb_p(wdt_stop);
-	printk(KERN_INFO PFX "Watchdog timer is now disabled...\n");
+	pr_info("Watchdog timer is now disabled...\n");
 }
 
 static void wdt_keepalive(void)
@@ -217,8 +218,7 @@ static int fop_close(struct inode *inode, struct file *file)
 		wdt_turnoff();
 	else {
 		del_timer(&timer);
-		printk(KERN_CRIT PFX
-		  "device file closed unexpectedly. Will not stop the WDT!\n");
+		pr_crit("device file closed unexpectedly. Will not stop the WDT!\n");
 	}
 	clear_bit(0, &wdt_is_open);
 	wdt_expect_close = 0;
@@ -335,14 +335,12 @@ static int __init sbc60xxwdt_init(void)
 
 	if (timeout < 1 || timeout > 3600) { /* arbitrary upper limit */
 		timeout = WATCHDOG_TIMEOUT;
-		printk(KERN_INFO PFX
-			"timeout value must be 1 <= x <= 3600, using %d\n",
-								timeout);
+		pr_info("timeout value must be 1 <= x <= 3600, using %d\n",
+			timeout);
 	}
 
 	if (!request_region(wdt_start, 1, "SBC 60XX WDT")) {
-		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
-			wdt_start);
+		pr_err("I/O address 0x%04x already in use\n", wdt_start);
 		rc = -EIO;
 		goto err_out;
 	}
@@ -350,9 +348,7 @@ static int __init sbc60xxwdt_init(void)
 	/* We cannot reserve 0x45 - the kernel already has! */
 	if (wdt_stop != 0x45 && wdt_stop != wdt_start) {
 		if (!request_region(wdt_stop, 1, "SBC 60XX WDT")) {
-			printk(KERN_ERR PFX
-				"I/O address 0x%04x already in use\n",
-							wdt_stop);
+			pr_err("I/O address 0x%04x already in use\n", wdt_stop);
 			rc = -EIO;
 			goto err_out_region1;
 		}
@@ -360,21 +356,18 @@ static int __init sbc60xxwdt_init(void)
 
 	rc = register_reboot_notifier(&wdt_notifier);
 	if (rc) {
-		printk(KERN_ERR PFX
-			"cannot register reboot notifier (err=%d)\n", rc);
+		pr_err("cannot register reboot notifier (err=%d)\n", rc);
 		goto err_out_region2;
 	}
 
 	rc = misc_register(&wdt_miscdev);
 	if (rc) {
-		printk(KERN_ERR PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-						wdt_miscdev.minor, rc);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       wdt_miscdev.minor, rc);
 		goto err_out_reboot;
 	}
-	printk(KERN_INFO PFX
-		"WDT driver for 60XX single board computer initialised. "
-		"timeout=%d sec (nowayout=%d)\n", timeout, nowayout);
+	pr_info("WDT driver for 60XX single board computer initialised. timeout=%d sec (nowayout=%d)\n",
+		timeout, nowayout);
 
 	return 0;
 
diff --git a/drivers/watchdog/sbc7240_wdt.c b/drivers/watchdog/sbc7240_wdt.c
index 93ac589..77cb302 100644
--- a/drivers/watchdog/sbc7240_wdt.c
+++ b/drivers/watchdog/sbc7240_wdt.c
@@ -16,6 +16,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/ioport.h>
@@ -32,8 +34,6 @@
 #include <linux/atomic.h>
 #include <asm/system.h>
 
-#define SBC7240_PREFIX "sbc7240_wdt: "
-
 #define SBC7240_ENABLE_PORT		0x443
 #define SBC7240_DISABLE_PORT		0x043
 #define SBC7240_SET_TIMEOUT_PORT	SBC7240_ENABLE_PORT
@@ -65,8 +65,7 @@ static void wdt_disable(void)
 	/* disable the watchdog */
 	if (test_and_clear_bit(SBC7240_ENABLED_STATUS_BIT, &wdt_status)) {
 		inb_p(SBC7240_DISABLE_PORT);
-		printk(KERN_INFO SBC7240_PREFIX
-		       "Watchdog timer is now disabled.\n");
+		pr_info("Watchdog timer is now disabled\n");
 	}
 }
 
@@ -75,23 +74,20 @@ static void wdt_enable(void)
 	/* enable the watchdog */
 	if (!test_and_set_bit(SBC7240_ENABLED_STATUS_BIT, &wdt_status)) {
 		inb_p(SBC7240_ENABLE_PORT);
-		printk(KERN_INFO SBC7240_PREFIX
-		       "Watchdog timer is now enabled.\n");
+		pr_info("Watchdog timer is now enabled\n");
 	}
 }
 
 static int wdt_set_timeout(int t)
 {
 	if (t < 1 || t > SBC7240_MAX_TIMEOUT) {
-		printk(KERN_ERR SBC7240_PREFIX
-		       "timeout value must be 1<=x<=%d\n",
-		       SBC7240_MAX_TIMEOUT);
+		pr_err("timeout value must be 1<=x<=%d\n", SBC7240_MAX_TIMEOUT);
 		return -1;
 	}
 	/* set the timeout */
 	outb_p((unsigned)t, SBC7240_SET_TIMEOUT_PORT);
 	timeout = t;
-	printk(KERN_INFO SBC7240_PREFIX "timeout set to %d seconds\n", t);
+	pr_info("timeout set to %d seconds\n", t);
 	return 0;
 }
 
@@ -150,8 +146,7 @@ static int fop_close(struct inode *inode, struct file *file)
 	    || !nowayout) {
 		wdt_disable();
 	} else {
-		printk(KERN_CRIT SBC7240_PREFIX
-		       "Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		wdt_keepalive();
 	}
 
@@ -252,7 +247,7 @@ static struct notifier_block wdt_notifier = {
 
 static void __exit sbc7240_wdt_unload(void)
 {
-	printk(KERN_INFO SBC7240_PREFIX "Removing watchdog\n");
+	pr_info("Removing watchdog\n");
 	misc_deregister(&wdt_miscdev);
 
 	unregister_reboot_notifier(&wdt_notifier);
@@ -264,8 +259,7 @@ static int __init sbc7240_wdt_init(void)
 	int rc = -EBUSY;
 
 	if (!request_region(SBC7240_ENABLE_PORT, 1, "SBC7240 WDT")) {
-		printk(KERN_ERR SBC7240_PREFIX
-		       "I/O address 0x%04x already in use\n",
+		pr_err("I/O address 0x%04x already in use\n",
 		       SBC7240_ENABLE_PORT);
 		rc = -EIO;
 		goto err_out;
@@ -277,31 +271,27 @@ static int __init sbc7240_wdt_init(void)
 
 	if (timeout < 1 || timeout > SBC7240_MAX_TIMEOUT) {
 		timeout = SBC7240_TIMEOUT;
-		printk(KERN_INFO SBC7240_PREFIX
-		       "timeout value must be 1<=x<=%d, using %d\n",
-		       SBC7240_MAX_TIMEOUT, timeout);
+		pr_info("timeout value must be 1<=x<=%d, using %d\n",
+			SBC7240_MAX_TIMEOUT, timeout);
 	}
 	wdt_set_timeout(timeout);
 	wdt_disable();
 
 	rc = register_reboot_notifier(&wdt_notifier);
 	if (rc) {
-		printk(KERN_ERR SBC7240_PREFIX
-		       "cannot register reboot notifier (err=%d)\n", rc);
+		pr_err("cannot register reboot notifier (err=%d)\n", rc);
 		goto err_out_region;
 	}
 
 	rc = misc_register(&wdt_miscdev);
 	if (rc) {
-		printk(KERN_ERR SBC7240_PREFIX
-		       "cannot register miscdev on minor=%d (err=%d)\n",
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
 		       wdt_miscdev.minor, rc);
 		goto err_out_reboot_notifier;
 	}
 
-	printk(KERN_INFO SBC7240_PREFIX
-	       "Watchdog driver for SBC7240 initialised (nowayout=%d)\n",
-	       nowayout);
+	pr_info("Watchdog driver for SBC7240 initialised (nowayout=%d)\n",
+		nowayout);
 
 	return 0;
 
diff --git a/drivers/watchdog/sbc8360.c b/drivers/watchdog/sbc8360.c
index 514ec23..f72b6e0 100644
--- a/drivers/watchdog/sbc8360.c
+++ b/drivers/watchdog/sbc8360.c
@@ -36,6 +36,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/miscdevice.h>
@@ -56,8 +58,6 @@
 static unsigned long sbc8360_is_open;
 static char expect_close;
 
-#define PFX "sbc8360: "
-
 /*
  *
  * Watchdog Timer Configuration
@@ -280,8 +280,7 @@ static int sbc8360_close(struct inode *inode, struct file *file)
 	if (expect_close == 42)
 		sbc8360_stop();
 	else
-		printk(KERN_CRIT PFX "SBC8360 device closed unexpectedly.  "
-						"SBC8360 will not stop!\n");
+		pr_crit("SBC8360 device closed unexpectedly.  SBC8360 will not stop!\n");
 
 	clear_bit(0, &sbc8360_is_open);
 	expect_close = 0;
@@ -334,20 +333,19 @@ static int __init sbc8360_init(void)
 	unsigned long int mseconds = 60000;
 
 	if (timeout < 0 || timeout > 63) {
-		printk(KERN_ERR PFX "Invalid timeout index (must be 0-63).\n");
+		pr_err("Invalid timeout index (must be 0-63)\n");
 		res = -EINVAL;
 		goto out;
 	}
 
 	if (!request_region(SBC8360_ENABLE, 1, "SBC8360")) {
-		printk(KERN_ERR PFX "ENABLE method I/O %X is not available.\n",
+		pr_err("ENABLE method I/O %X is not available\n",
 		       SBC8360_ENABLE);
 		res = -EIO;
 		goto out;
 	}
 	if (!request_region(SBC8360_BASETIME, 1, "SBC8360")) {
-		printk(KERN_ERR PFX
-		       "BASETIME method I/O %X is not available.\n",
+		pr_err("BASETIME method I/O %X is not available\n",
 		       SBC8360_BASETIME);
 		res = -EIO;
 		goto out_nobasetimereg;
@@ -355,13 +353,13 @@ static int __init sbc8360_init(void)
 
 	res = register_reboot_notifier(&sbc8360_notifier);
 	if (res) {
-		printk(KERN_ERR PFX "Failed to register reboot notifier.\n");
+		pr_err("Failed to register reboot notifier\n");
 		goto out_noreboot;
 	}
 
 	res = misc_register(&sbc8360_miscdev);
 	if (res) {
-		printk(KERN_ERR PFX "failed to register misc device\n");
+		pr_err("failed to register misc device\n");
 		goto out_nomisc;
 	}
 
@@ -378,7 +376,7 @@ static int __init sbc8360_init(void)
 		mseconds = (wd_margin + 1) * 100000;
 
 	/* My kingdom for the ability to print "0.5 seconds" in the kernel! */
-	printk(KERN_INFO PFX "Timeout set at %ld ms.\n", mseconds);
+	pr_info("Timeout set at %ld ms\n", mseconds);
 
 	return 0;
 
diff --git a/drivers/watchdog/sbc_epx_c3.c b/drivers/watchdog/sbc_epx_c3.c
index eaca366..1a13d36 100644
--- a/drivers/watchdog/sbc_epx_c3.c
+++ b/drivers/watchdog/sbc_epx_c3.c
@@ -13,6 +13,8 @@
  *	based on softdog.c by Alan Cox <alan@lxorguk.ukuu.org.uk>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -28,7 +30,6 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 
-#define PFX "epx_c3: "
 static int epx_c3_alive;
 
 #define WATCHDOG_TIMEOUT 1		/* 1 sec default timeout */
@@ -51,7 +52,7 @@ static void epx_c3_stop(void)
 
 	outb(0, EPXC3_WATCHDOG_CTL_REG);
 
-	printk(KERN_INFO PFX "Stopped watchdog timer.\n");
+	pr_info("Stopped watchdog timer\n");
 }
 
 static void epx_c3_pet(void)
@@ -75,7 +76,7 @@ static int epx_c3_open(struct inode *inode, struct file *file)
 	epx_c3_pet();
 
 	epx_c3_alive = 1;
-	printk(KERN_INFO "Started watchdog timer.\n");
+	pr_info("Started watchdog timer\n");
 
 	return nonseekable_open(inode, file);
 }
@@ -173,9 +174,6 @@ static struct notifier_block epx_c3_notifier = {
 	.notifier_call = epx_c3_notify_sys,
 };
 
-static const char banner[] __initconst = KERN_INFO PFX
-	"Hardware Watchdog Timer for Winsystems EPX-C3 SBC: 0.1\n";
-
 static int __init watchdog_init(void)
 {
 	int ret;
@@ -185,20 +183,19 @@ static int __init watchdog_init(void)
 
 	ret = register_reboot_notifier(&epx_c3_notifier);
 	if (ret) {
-		printk(KERN_ERR PFX "cannot register reboot notifier "
-			"(err=%d)\n", ret);
+		pr_err("cannot register reboot notifier (err=%d)\n", ret);
 		goto out;
 	}
 
 	ret = misc_register(&epx_c3_miscdev);
 	if (ret) {
-		printk(KERN_ERR PFX "cannot register miscdev on minor=%d "
-			"(err=%d)\n", WATCHDOG_MINOR, ret);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
 		unregister_reboot_notifier(&epx_c3_notifier);
 		goto out;
 	}
 
-	printk(banner);
+	pr_info("Hardware Watchdog Timer for Winsystems EPX-C3 SBC: 0.1\n");
 
 	return 0;
 
diff --git a/drivers/watchdog/sbc_fitpc2_wdt.c b/drivers/watchdog/sbc_fitpc2_wdt.c
index d5d3994..ca9c6c4 100644
--- a/drivers/watchdog/sbc_fitpc2_wdt.c
+++ b/drivers/watchdog/sbc_fitpc2_wdt.c
@@ -171,8 +171,7 @@ static int fitpc2_wdt_release(struct inode *inode, struct file *file)
 		wdt_disable();
 		pr_info("Device disabled\n");
 	} else {
-		pr_warning("Device closed unexpectedly -"
-			" timer will not stop\n");
+		pr_warn("Device closed unexpectedly - timer will not stop\n");
 		wdt_enable();
 	}
 
@@ -222,8 +221,8 @@ static int __init fitpc2_wdt_init(void)
 	}
 
 	if (margin < 31 || margin > 255) {
-		pr_err("margin must be in range 31 - 255"
-		       " seconds, you tried to set %d\n", margin);
+		pr_err("margin must be in range 31 - 255 seconds, you tried to set %d\n",
+		       margin);
 		err = -EINVAL;
 		goto err_margin;
 	}
@@ -231,7 +230,7 @@ static int __init fitpc2_wdt_init(void)
 	err = misc_register(&fitpc2_wdt_miscdev);
 	if (err) {
 		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
-							WATCHDOG_MINOR, err);
+		       WATCHDOG_MINOR, err);
 		goto err_margin;
 	}
 
diff --git a/drivers/watchdog/sc1200wdt.c b/drivers/watchdog/sc1200wdt.c
index c01daca..0698b3d 100644
--- a/drivers/watchdog/sc1200wdt.c
+++ b/drivers/watchdog/sc1200wdt.c
@@ -31,6 +31,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/miscdevice.h>
@@ -48,7 +50,6 @@
 
 #define SC1200_MODULE_VER	"build 20020303"
 #define SC1200_MODULE_NAME	"sc1200wdt"
-#define PFX			SC1200_MODULE_NAME ": "
 
 #define	MAX_TIMEOUT	255	/* 255 minutes */
 #define PMIR		(io)	/* Power Management Index Register */
@@ -71,7 +72,6 @@
 #define UART2_IRQ	0x04	/* Serial1 */
 /* 5 -7 are reserved */
 
-static char banner[] __initdata = PFX SC1200_MODULE_VER;
 static int timeout = 1;
 static int io = -1;
 static int io_len = 2;		/* for non plug and play */
@@ -176,7 +176,7 @@ static int sc1200wdt_open(struct inode *inode, struct file *file)
 		timeout = MAX_TIMEOUT;
 
 	sc1200wdt_start();
-	printk(KERN_INFO PFX "Watchdog enabled, timeout = %d min(s)", timeout);
+	pr_info("Watchdog enabled, timeout = %d min(s)", timeout);
 
 	return nonseekable_open(inode, file);
 }
@@ -254,11 +254,10 @@ static int sc1200wdt_release(struct inode *inode, struct file *file)
 {
 	if (expect_close == 42) {
 		sc1200wdt_stop();
-		printk(KERN_INFO PFX "Watchdog disabled\n");
+		pr_info("Watchdog disabled\n");
 	} else {
 		sc1200wdt_write_data(WDTO, timeout);
-		printk(KERN_CRIT PFX
-			"Unexpected close!, timeout = %d min(s)\n", timeout);
+		pr_crit("Unexpected close!, timeout = %d min(s)\n", timeout);
 	}
 	clear_bit(0, &open_flag);
 	expect_close = 0;
@@ -361,12 +360,11 @@ static int scl200wdt_pnp_probe(struct pnp_dev *dev,
 	io_len = pnp_port_len(wdt_dev, 0);
 
 	if (!request_region(io, io_len, SC1200_MODULE_NAME)) {
-		printk(KERN_ERR PFX "Unable to register IO port %#x\n", io);
+		pr_err("Unable to register IO port %#x\n", io);
 		return -EBUSY;
 	}
 
-	printk(KERN_INFO "scl200wdt: PnP device found at io port %#x/%d\n",
-								io, io_len);
+	pr_info("PnP device found at io port %#x/%d\n", io, io_len);
 	return 0;
 }
 
@@ -392,7 +390,7 @@ static int __init sc1200wdt_init(void)
 {
 	int ret;
 
-	printk(KERN_INFO "%s\n", banner);
+	pr_info("%s\n", SC1200_MODULE_VER);
 
 #if defined CONFIG_PNP
 	if (isapnp) {
@@ -403,7 +401,7 @@ static int __init sc1200wdt_init(void)
 #endif
 
 	if (io == -1) {
-		printk(KERN_ERR PFX "io parameter must be specified\n");
+		pr_err("io parameter must be specified\n");
 		ret = -EINVAL;
 		goto out_pnp;
 	}
@@ -416,7 +414,7 @@ static int __init sc1200wdt_init(void)
 #endif
 
 	if (!request_region(io, io_len, SC1200_MODULE_NAME)) {
-		printk(KERN_ERR PFX "Unable to register IO port %#x\n", io);
+		pr_err("Unable to register IO port %#x\n", io);
 		ret = -EBUSY;
 		goto out_pnp;
 	}
@@ -427,16 +425,14 @@ static int __init sc1200wdt_init(void)
 
 	ret = register_reboot_notifier(&sc1200wdt_notifier);
 	if (ret) {
-		printk(KERN_ERR PFX
-			"Unable to register reboot notifier err = %d\n", ret);
+		pr_err("Unable to register reboot notifier err = %d\n", ret);
 		goto out_io;
 	}
 
 	ret = misc_register(&sc1200wdt_miscdev);
 	if (ret) {
-		printk(KERN_ERR PFX
-			"Unable to register miscdev on minor %d\n",
-							WATCHDOG_MINOR);
+		pr_err("Unable to register miscdev on minor %d\n",
+		       WATCHDOG_MINOR);
 		goto out_rbt;
 	}
 
diff --git a/drivers/watchdog/sc520_wdt.c b/drivers/watchdog/sc520_wdt.c
index b284040..e975b33 100644
--- a/drivers/watchdog/sc520_wdt.c
+++ b/drivers/watchdog/sc520_wdt.c
@@ -52,6 +52,8 @@
  *  This driver uses memory mapped IO, and spinlock.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -69,9 +71,6 @@
 
 #include <asm/system.h>
 
-#define OUR_NAME "sc520_wdt"
-#define PFX OUR_NAME ": "
-
 /*
  * The AMD Elan SC520 timeout value is 492us times a power of 2 (0-7)
  *
@@ -151,8 +150,7 @@ static void wdt_timer_ping(unsigned long data)
 		/* Re-set the timer interval */
 		mod_timer(&timer, jiffies + WDT_INTERVAL);
 	} else
-		printk(KERN_WARNING PFX
-			"Heartbeat lost! Will not ping the watchdog\n");
+		pr_warn("Heartbeat lost! Will not ping the watchdog\n");
 }
 
 /*
@@ -187,7 +185,7 @@ static int wdt_startup(void)
 	/* Start the watchdog */
 	wdt_config(WDT_ENB | WDT_WRST_ENB | WDT_EXP_SEL_04);
 
-	printk(KERN_INFO PFX "Watchdog timer is now enabled.\n");
+	pr_info("Watchdog timer is now enabled\n");
 	return 0;
 }
 
@@ -199,7 +197,7 @@ static int wdt_turnoff(void)
 	/* Stop the watchdog */
 	wdt_config(0);
 
-	printk(KERN_INFO PFX "Watchdog timer is now disabled...\n");
+	pr_info("Watchdog timer is now disabled...\n");
 	return 0;
 }
 
@@ -270,8 +268,7 @@ static int fop_close(struct inode *inode, struct file *file)
 	if (wdt_expect_close == 42)
 		wdt_turnoff();
 	else {
-		printk(KERN_CRIT PFX
-			"Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		wdt_keepalive();
 	}
 	clear_bit(0, &wdt_is_open);
@@ -393,36 +390,32 @@ static int __init sc520_wdt_init(void)
 	   if not reset to the default */
 	if (wdt_set_heartbeat(timeout)) {
 		wdt_set_heartbeat(WATCHDOG_TIMEOUT);
-		printk(KERN_INFO PFX
-		    "timeout value must be 1 <= timeout <= 3600, using %d\n",
-							WATCHDOG_TIMEOUT);
+		pr_info("timeout value must be 1 <= timeout <= 3600, using %d\n",
+			WATCHDOG_TIMEOUT);
 	}
 
 	wdtmrctl = ioremap(MMCR_BASE + OFFS_WDTMRCTL, 2);
 	if (!wdtmrctl) {
-		printk(KERN_ERR PFX "Unable to remap memory\n");
+		pr_err("Unable to remap memory\n");
 		rc = -ENOMEM;
 		goto err_out_region2;
 	}
 
 	rc = register_reboot_notifier(&wdt_notifier);
 	if (rc) {
-		printk(KERN_ERR PFX
-			"cannot register reboot notifier (err=%d)\n", rc);
+		pr_err("cannot register reboot notifier (err=%d)\n", rc);
 		goto err_out_ioremap;
 	}
 
 	rc = misc_register(&wdt_miscdev);
 	if (rc) {
-		printk(KERN_ERR PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-							WATCHDOG_MINOR, rc);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, rc);
 		goto err_out_notifier;
 	}
 
-	printk(KERN_INFO PFX
-	   "WDT driver for SC520 initialised. timeout=%d sec (nowayout=%d)\n",
-							timeout, nowayout);
+	pr_info("WDT driver for SC520 initialised. timeout=%d sec (nowayout=%d)\n",
+		timeout, nowayout);
 
 	return 0;
 
diff --git a/drivers/watchdog/sch311x_wdt.c b/drivers/watchdog/sch311x_wdt.c
index 029467e..1702c3e 100644
--- a/drivers/watchdog/sch311x_wdt.c
+++ b/drivers/watchdog/sch311x_wdt.c
@@ -18,6 +18,8 @@
  *	Includes, defines, variables, module parameters, ...
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 /* Includes */
 #include <linux/module.h>		/* For module specific items */
 #include <linux/moduleparam.h>		/* For new moduleparam's */
@@ -37,7 +39,6 @@
 
 /* Module and version information */
 #define DRV_NAME	"sch311x_wdt"
-#define PFX		DRV_NAME ": "
 
 /* Runtime registers */
 #define RESGEN			0x1d
@@ -323,8 +324,7 @@ static int sch311x_wdt_close(struct inode *inode, struct file *file)
 	if (sch311x_wdt_expect_close == 42) {
 		sch311x_wdt_stop();
 	} else {
-		printk(KERN_CRIT PFX
-				"Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		sch311x_wdt_keepalive();
 	}
 	clear_bit(0, &sch311x_wdt_is_open);
@@ -504,20 +504,19 @@ static int __init sch311x_detect(int sio_config_port, unsigned short *addr)
 
 	/* Check if Logical Device Register is currently active */
 	if ((sch311x_sio_inb(sio_config_port, 0x30) & 0x01) == 0)
-		printk(KERN_INFO PFX "Seems that LDN 0x0a is not active...\n");
+		pr_info("Seems that LDN 0x0a is not active...\n");
 
 	/* Get the base address of the runtime registers */
 	base_addr = (sch311x_sio_inb(sio_config_port, 0x60) << 8) |
 			   sch311x_sio_inb(sio_config_port, 0x61);
 	if (!base_addr) {
-		printk(KERN_ERR PFX "Base address not set.\n");
+		pr_err("Base address not set\n");
 		err = -ENODEV;
 		goto exit;
 	}
 	*addr = base_addr;
 
-	printk(KERN_INFO PFX "Found an SMSC SCH311%d chip at 0x%04x\n",
-		dev_id, base_addr);
+	pr_info("Found an SMSC SCH311%d chip at 0x%04x\n", dev_id, base_addr);
 
 exit:
 	sch311x_sio_exit(sio_config_port);
diff --git a/drivers/watchdog/scx200_wdt.c b/drivers/watchdog/scx200_wdt.c
index e67b76c..35ada2e 100644
--- a/drivers/watchdog/scx200_wdt.c
+++ b/drivers/watchdog/scx200_wdt.c
@@ -17,6 +17,8 @@
    of any nature resulting due to the use of this software. This
    software is provided AS-IS with no warranties. */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/init.h>
@@ -30,7 +32,7 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 
-#define NAME "scx200_wdt"
+#define DEBUG
 
 MODULE_AUTHOR("Christer Weinigel <wingel@nano-system.com>");
 MODULE_DESCRIPTION("NatSemi SCx200 Watchdog Driver");
@@ -66,14 +68,13 @@ static void scx200_wdt_ping(void)
 
 static void scx200_wdt_update_margin(void)
 {
-	printk(KERN_INFO NAME ": timer margin %d seconds\n", margin);
+	pr_info("timer margin %d seconds\n", margin);
 	wdto_restart = margin * W_SCALE;
 }
 
 static void scx200_wdt_enable(void)
 {
-	printk(KERN_DEBUG NAME ": enabling watchdog timer, wdto_restart = %d\n",
-	       wdto_restart);
+	pr_debug("enabling watchdog timer, wdto_restart = %d\n", wdto_restart);
 
 	spin_lock(&scx_lock);
 	outw(0, scx200_cb_base + SCx200_WDT_WDTO);
@@ -86,7 +87,7 @@ static void scx200_wdt_enable(void)
 
 static void scx200_wdt_disable(void)
 {
-	printk(KERN_DEBUG NAME ": disabling watchdog timer\n");
+	pr_debug("disabling watchdog timer\n");
 
 	spin_lock(&scx_lock);
 	outw(0, scx200_cb_base + SCx200_WDT_WDTO);
@@ -108,9 +109,7 @@ static int scx200_wdt_open(struct inode *inode, struct file *file)
 static int scx200_wdt_release(struct inode *inode, struct file *file)
 {
 	if (expect_close != 42)
-		printk(KERN_WARNING NAME
-			": watchdog device closed unexpectedly, "
-			"will not disable the watchdog timer\n");
+		pr_warn("watchdog device closed unexpectedly, will not disable the watchdog timer\n");
 	else if (!nowayout)
 		scx200_wdt_disable();
 	expect_close = 0;
@@ -219,7 +218,7 @@ static int __init scx200_wdt_init(void)
 {
 	int r;
 
-	printk(KERN_DEBUG NAME ": NatSemi SCx200 Watchdog Driver\n");
+	pr_debug("NatSemi SCx200 Watchdog Driver\n");
 
 	/* check that we have found the configuration block */
 	if (!scx200_cb_present())
@@ -228,7 +227,7 @@ static int __init scx200_wdt_init(void)
 	if (!request_region(scx200_cb_base + SCx200_WDT_OFFSET,
 			    SCx200_WDT_SIZE,
 			    "NatSemi SCx200 Watchdog")) {
-		printk(KERN_WARNING NAME ": watchdog I/O region busy\n");
+		pr_warn("watchdog I/O region busy\n");
 		return -EBUSY;
 	}
 
@@ -237,7 +236,7 @@ static int __init scx200_wdt_init(void)
 
 	r = register_reboot_notifier(&scx200_wdt_notifier);
 	if (r) {
-		printk(KERN_ERR NAME ": unable to register reboot notifier");
+		pr_err("unable to register reboot notifier\n");
 		release_region(scx200_cb_base + SCx200_WDT_OFFSET,
 				SCx200_WDT_SIZE);
 		return r;
diff --git a/drivers/watchdog/shwdt.c b/drivers/watchdog/shwdt.c
index a267dc0..75bd239 100644
--- a/drivers/watchdog/shwdt.c
+++ b/drivers/watchdog/shwdt.c
@@ -17,6 +17,9 @@
  *     Added expect close support, made emulated timeout runtime changeable
  *     general cleanups, add some ioctls
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/platform_device.h>
@@ -440,20 +443,20 @@ static int __init sh_wdt_init(void)
 		     clock_division_ratio > 0x7)) {
 		clock_division_ratio = WTCSR_CKS_4096;
 
-		pr_info("%s: divisor must be 0x5<=x<=0x7, using %d\n",
-			 DRV_NAME, clock_division_ratio);
+		pr_info("divisor must be 0x5<=x<=0x7, using %d\n",
+			clock_division_ratio);
 	}
 
 	rc = sh_wdt_set_heartbeat(heartbeat);
 	if (unlikely(rc)) {
 		heartbeat = WATCHDOG_HEARTBEAT;
 
-		pr_info("%s: heartbeat value must be 1<=x<=3600, using %d\n",
-			DRV_NAME, heartbeat);
+		pr_info("heartbeat value must be 1<=x<=3600, using %d\n",
+			heartbeat);
 	}
 
-	pr_info("%s: configured with heartbeat=%d sec (nowayout=%d)\n",
-		DRV_NAME, heartbeat, nowayout);
+	pr_info("configured with heartbeat=%d sec (nowayout=%d)\n",
+		heartbeat, nowayout);
 
 	return platform_driver_register(&sh_wdt_driver);
 }
diff --git a/drivers/watchdog/smsc37b787_wdt.c b/drivers/watchdog/smsc37b787_wdt.c
index 97b8184..5e4d373 100644
--- a/drivers/watchdog/smsc37b787_wdt.c
+++ b/drivers/watchdog/smsc37b787_wdt.c
@@ -43,6 +43,8 @@
  *   Documentation/watchdog/wdt.txt
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -70,7 +72,6 @@
 #define UNIT_SECOND     0
 #define UNIT_MINUTE     1
 
-#define MODNAME		"smsc37b787_wdt: "
 #define VERSION		"1.1"
 
 #define IOPORT		0x3F0
@@ -363,8 +364,7 @@ static int wb_smsc_wdt_open(struct inode *inode, struct file *file)
 	/* Reload and activate timer */
 	wb_smsc_wdt_enable();
 
-	printk(KERN_INFO MODNAME
-		"Watchdog enabled. Timeout set to %d %s.\n",
+	pr_info("Watchdog enabled. Timeout set to %d %s\n",
 		timeout, (unit == UNIT_SECOND) ? "second(s)" : "minute(s)");
 
 	return nonseekable_open(inode, file);
@@ -378,11 +378,9 @@ static int wb_smsc_wdt_release(struct inode *inode, struct file *file)
 
 	if (expect_close == 42) {
 		wb_smsc_wdt_disable();
-		printk(KERN_INFO MODNAME
-				"Watchdog disabled, sleeping again...\n");
+		pr_info("Watchdog disabled, sleeping again...\n");
 	} else {
-		printk(KERN_CRIT MODNAME
-				"Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		wb_smsc_wdt_reset_timer();
 	}
 
@@ -534,12 +532,11 @@ static int __init wb_smsc_wdt_init(void)
 {
 	int ret;
 
-	printk(KERN_INFO "SMsC 37B787 watchdog component driver "
-					VERSION " initialising...\n");
+	pr_info("SMsC 37B787 watchdog component driver "
+		VERSION " initialising...\n");
 
 	if (!request_region(IOPORT, IOPORT_SIZE, "SMsC 37B787 watchdog")) {
-		printk(KERN_ERR MODNAME "Unable to register IO port %#x\n",
-								IOPORT);
+		pr_err("Unable to register IO port %#x\n", IOPORT);
 		ret = -EBUSY;
 		goto out_pnp;
 	}
@@ -553,25 +550,22 @@ static int __init wb_smsc_wdt_init(void)
 
 	ret = register_reboot_notifier(&wb_smsc_wdt_notifier);
 	if (ret) {
-		printk(KERN_ERR MODNAME
-			"Unable to register reboot notifier err = %d\n", ret);
+		pr_err("Unable to register reboot notifier err = %d\n", ret);
 		goto out_io;
 	}
 
 	ret = misc_register(&wb_smsc_wdt_miscdev);
 	if (ret) {
-		printk(KERN_ERR MODNAME
-			"Unable to register miscdev on minor %d\n",
-							WATCHDOG_MINOR);
+		pr_err("Unable to register miscdev on minor %d\n",
+		       WATCHDOG_MINOR);
 		goto out_rbt;
 	}
 
 	/* output info */
-	printk(KERN_INFO MODNAME "Timeout set to %d %s.\n",
+	pr_info("Timeout set to %d %s\n",
 		timeout, (unit == UNIT_SECOND) ? "second(s)" : "minute(s)");
-	printk(KERN_INFO MODNAME
-		"Watchdog initialized and sleeping (nowayout=%d)...\n",
-								nowayout);
+	pr_info("Watchdog initialized and sleeping (nowayout=%d)...\n",
+		nowayout);
 out_clean:
 	return ret;
 
@@ -592,14 +586,14 @@ static void __exit wb_smsc_wdt_exit(void)
 	/* Stop the timer before we leave */
 	if (!nowayout) {
 		wb_smsc_wdt_shutdown();
-		printk(KERN_INFO MODNAME "Watchdog disabled.\n");
+		pr_info("Watchdog disabled\n");
 	}
 
 	misc_deregister(&wb_smsc_wdt_miscdev);
 	unregister_reboot_notifier(&wb_smsc_wdt_notifier);
 	release_region(IOPORT, IOPORT_SIZE);
 
-	printk(KERN_INFO "SMsC 37B787 watchdog component driver removed.\n");
+	pr_info("SMsC 37B787 watchdog component driver removed\n");
 }
 
 module_init(wb_smsc_wdt_init);
diff --git a/drivers/watchdog/softdog.c b/drivers/watchdog/softdog.c
index bf16ffb..a1adc8c 100644
--- a/drivers/watchdog/softdog.c
+++ b/drivers/watchdog/softdog.c
@@ -36,6 +36,8 @@
  *	Added Matt Domsch's nowayout module option.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -50,8 +52,6 @@
 #include <linux/uaccess.h>
 #include <linux/kernel.h>
 
-#define PFX "SoftDog: "
-
 #define TIMER_MARGIN	60		/* Default is 60 seconds */
 static int soft_margin = TIMER_MARGIN;	/* in seconds */
 module_param(soft_margin, int, 0);
@@ -103,14 +103,14 @@ static void watchdog_fire(unsigned long data)
 		module_put(THIS_MODULE);
 
 	if (soft_noboot)
-		printk(KERN_CRIT PFX "Triggered - Reboot ignored.\n");
+		pr_crit("Triggered - Reboot ignored\n");
 	else if (soft_panic) {
-		printk(KERN_CRIT PFX "Initiating panic.\n");
-		panic("Software Watchdog Timer expired.");
+		pr_crit("Initiating panic\n");
+		panic("Software Watchdog Timer expired");
 	} else {
-		printk(KERN_CRIT PFX "Initiating system reboot.\n");
+		pr_crit("Initiating system reboot\n");
 		emergency_restart();
-		printk(KERN_CRIT PFX "Reboot didn't ?????\n");
+		pr_crit("Reboot didn't ?????\n");
 	}
 }
 
@@ -166,8 +166,7 @@ static int softdog_release(struct inode *inode, struct file *file)
 		softdog_stop();
 		module_put(THIS_MODULE);
 	} else {
-		printk(KERN_CRIT PFX
-			"Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		set_bit(0, &orphan_timer);
 		softdog_keepalive();
 	}
@@ -275,10 +274,6 @@ static struct notifier_block softdog_notifier = {
 	.notifier_call	= softdog_notify_sys,
 };
 
-static char banner[] __initdata = KERN_INFO "Software Watchdog Timer: 0.07 "
-	"initialized. soft_noboot=%d soft_margin=%d sec soft_panic=%d "
-	"(nowayout= %d)\n";
-
 static int __init watchdog_init(void)
 {
 	int ret;
@@ -287,28 +282,26 @@ static int __init watchdog_init(void)
 	   if not reset to the default */
 	if (softdog_set_heartbeat(soft_margin)) {
 		softdog_set_heartbeat(TIMER_MARGIN);
-		printk(KERN_INFO PFX
-		    "soft_margin must be 0 < soft_margin < 65536, using %d\n",
+		pr_info("soft_margin must be 0 < soft_margin < 65536, using %d\n",
 			TIMER_MARGIN);
 	}
 
 	ret = register_reboot_notifier(&softdog_notifier);
 	if (ret) {
-		printk(KERN_ERR PFX
-			"cannot register reboot notifier (err=%d)\n", ret);
+		pr_err("cannot register reboot notifier (err=%d)\n", ret);
 		return ret;
 	}
 
 	ret = misc_register(&softdog_miscdev);
 	if (ret) {
-		printk(KERN_ERR PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-						WATCHDOG_MINOR, ret);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
 		unregister_reboot_notifier(&softdog_notifier);
 		return ret;
 	}
 
-	printk(banner, soft_noboot, soft_margin, soft_panic, nowayout);
+	pr_info("Software Watchdog Timer: 0.07 initialized. soft_noboot=%d soft_margin=%d sec soft_panic=%d (nowayout= %d)\n",
+		soft_noboot, soft_margin, soft_panic, nowayout);
 
 	return 0;
 }
diff --git a/drivers/watchdog/sp5100_tco.c b/drivers/watchdog/sp5100_tco.c
index 87e0527..954a7b6 100644
--- a/drivers/watchdog/sp5100_tco.c
+++ b/drivers/watchdog/sp5100_tco.c
@@ -20,6 +20,8 @@
  *	Includes, defines, variables, module parameters, ...
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -39,7 +41,6 @@
 #define TCO_VERSION "0.01"
 #define TCO_MODULE_NAME "SP5100 TCO timer"
 #define TCO_DRIVER_NAME   TCO_MODULE_NAME ", v" TCO_VERSION
-#define PFX TCO_MODULE_NAME ": "
 
 /* internal variables */
 static u32 tcobase_phys;
@@ -143,8 +144,7 @@ static int sp5100_tco_release(struct inode *inode, struct file *file)
 	if (tco_expect_close == 42) {
 		tco_timer_stop();
 	} else {
-		printk(KERN_CRIT PFX
-			"Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		tco_timer_keepalive();
 	}
 	clear_bit(0, &timer_alive);
@@ -290,8 +290,7 @@ static unsigned char __devinit sp5100_tco_setupdevice(void)
 	/* Request the IO ports used by this driver */
 	pm_iobase = SP5100_IO_PM_INDEX_REG;
 	if (!request_region(pm_iobase, SP5100_PM_IOPORTS_SIZE, "SP5100 TCO")) {
-		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
-			pm_iobase);
+		pr_err("I/O address 0x%04x already in use\n", pm_iobase);
 		goto exit;
 	}
 
@@ -308,15 +307,14 @@ static unsigned char __devinit sp5100_tco_setupdevice(void)
 
 	if (!request_mem_region_exclusive(val, SP5100_WDT_MEM_MAP_SIZE,
 								"SP5100 TCO")) {
-		printk(KERN_ERR PFX "mmio address 0x%04x already in use\n",
-			val);
+		pr_err("mmio address 0x%04x already in use\n", val);
 		goto unreg_region;
 	}
 	tcobase_phys = val;
 
 	tcobase = ioremap(val, SP5100_WDT_MEM_MAP_SIZE);
 	if (tcobase == 0) {
-		printk(KERN_ERR PFX "failed to get tcobase address\n");
+		pr_err("failed to get tcobase address\n");
 		goto unreg_mem_region;
 	}
 
@@ -375,9 +373,9 @@ static int __devinit sp5100_tco_init(struct platform_device *dev)
 		return -ENODEV;
 
 	/* Check to see if last reboot was due to watchdog timeout */
-	printk(KERN_INFO PFX "Watchdog reboot %sdetected.\n",
-	       readl(SP5100_WDT_CONTROL(tcobase)) & SP5100_PM_WATCHDOG_FIRED ?
-		      "" : "not ");
+	pr_info("Watchdog reboot %sdetected\n",
+		readl(SP5100_WDT_CONTROL(tcobase)) & SP5100_PM_WATCHDOG_FIRED ?
+		"" : "not ");
 
 	/* Clear out the old status */
 	val = readl(SP5100_WDT_CONTROL(tcobase));
@@ -395,16 +393,14 @@ static int __devinit sp5100_tco_init(struct platform_device *dev)
 
 	ret = misc_register(&sp5100_tco_miscdev);
 	if (ret != 0) {
-		printk(KERN_ERR PFX "cannot register miscdev on minor="
-		       "%d (err=%d)\n",
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
 		       WATCHDOG_MINOR, ret);
 		goto exit;
 	}
 
 	clear_bit(0, &timer_alive);
 
-	printk(KERN_INFO PFX "initialized (0x%p). heartbeat=%d sec"
-		" (nowayout=%d)\n",
+	pr_info("initialized (0x%p). heartbeat=%d sec (nowayout=%d)\n",
 		tcobase, heartbeat, nowayout);
 
 	return 0;
@@ -455,8 +451,7 @@ static int __init sp5100_tco_init_module(void)
 {
 	int err;
 
-	printk(KERN_INFO PFX "SP5100 TCO WatchDog Timer Driver v%s\n",
-	       TCO_VERSION);
+	pr_info("SP5100 TCO WatchDog Timer Driver v%s\n", TCO_VERSION);
 
 	err = platform_driver_register(&sp5100_tco_driver);
 	if (err)
@@ -480,7 +475,7 @@ static void __exit sp5100_tco_cleanup_module(void)
 {
 	platform_device_unregister(sp5100_tco_platform_device);
 	platform_driver_unregister(&sp5100_tco_driver);
-	printk(KERN_INFO PFX "SP5100 TCO Watchdog Module Unloaded.\n");
+	pr_info("SP5100 TCO Watchdog Module Unloaded\n");
 }
 
 module_init(sp5100_tco_init_module);
diff --git a/drivers/watchdog/stmp3xxx_wdt.c b/drivers/watchdog/stmp3xxx_wdt.c
index e37d811..1809413 100644
--- a/drivers/watchdog/stmp3xxx_wdt.c
+++ b/drivers/watchdog/stmp3xxx_wdt.c
@@ -6,6 +6,9 @@
  * Copyright 2008 Freescale Semiconductor, Inc. All Rights Reserved.
  * Copyright 2008 Embedded Alley Solutions, Inc All Rights Reserved.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/fs.h>
@@ -221,8 +224,7 @@ static int __devinit stmp3xxx_wdt_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	printk(KERN_INFO "stmp3xxx watchdog: initialized, heartbeat %d sec\n",
-		heartbeat);
+	pr_info("initialized, heartbeat %d sec\n", heartbeat);
 
 	return ret;
 }
diff --git a/drivers/watchdog/txx9wdt.c b/drivers/watchdog/txx9wdt.c
index 9e9ed7b..99204a8 100644
--- a/drivers/watchdog/txx9wdt.c
+++ b/drivers/watchdog/txx9wdt.c
@@ -7,6 +7,9 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -96,8 +99,7 @@ static int txx9wdt_release(struct inode *inode, struct file *file)
 	if (expect_close)
 		txx9wdt_stop();
 	else {
-		printk(KERN_CRIT "txx9wdt: "
-		       "Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		txx9wdt_ping();
 	}
 	clear_bit(0, &txx9wdt_alive);
@@ -213,9 +215,8 @@ static int __init txx9wdt_probe(struct platform_device *dev)
 		goto exit;
 	}
 
-	printk(KERN_INFO "Hardware Watchdog Timer for TXx9: "
-	       "timeout=%d sec (max %ld) (nowayout= %d)\n",
-	       timeout, WD_MAX_TIMEOUT, nowayout);
+	pr_info("Hardware Watchdog Timer: timeout=%d sec (max %ld) (nowayout= %d)\n",
+		timeout, WD_MAX_TIMEOUT, nowayout);
 
 	return 0;
 exit_busy:
diff --git a/drivers/watchdog/via_wdt.c b/drivers/watchdog/via_wdt.c
index 8f07dd4..bacbbc9 100644
--- a/drivers/watchdog/via_wdt.c
+++ b/drivers/watchdog/via_wdt.c
@@ -10,6 +10,9 @@
  * Caveat: PnP must be enabled in BIOS to allow full access to watchdog
  * control registers. If not, the watchdog must be configured in BIOS manually.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/device.h>
 #include <linux/io.h>
 #include <linux/jiffies.h>
diff --git a/drivers/watchdog/w83627hf_wdt.c b/drivers/watchdog/w83627hf_wdt.c
index 576a388..9693587 100644
--- a/drivers/watchdog/w83627hf_wdt.c
+++ b/drivers/watchdog/w83627hf_wdt.c
@@ -26,6 +26,8 @@
  *	(c) Copyright 1995    Alan Cox <alan@lxorguk.ukuu.org.uk>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -43,7 +45,6 @@
 #include <asm/system.h>
 
 #define WATCHDOG_NAME "w83627hf/thf/hg/dhg WDT"
-#define PFX WATCHDOG_NAME ": "
 #define WATCHDOG_TIMEOUT 60		/* 60 sec default timeout */
 
 static unsigned long wdt_is_open;
@@ -119,9 +120,8 @@ static void w83627hf_init(void)
 	outb_p(0xF6, WDT_EFER); /* Select CRF6 */
 	t = inb_p(WDT_EFDR);      /* read CRF6 */
 	if (t != 0) {
-		printk(KERN_INFO PFX
-		     "Watchdog already running. Resetting timeout to %d sec\n",
-								timeout);
+		pr_info("Watchdog already running. Resetting timeout to %d sec\n",
+			timeout);
 		outb_p(timeout, WDT_EFDR);    /* Write back to CRF6 */
 	}
 
@@ -290,8 +290,7 @@ static int wdt_close(struct inode *inode, struct file *file)
 	if (expect_close == 42)
 		wdt_disable();
 	else {
-		printk(KERN_CRIT PFX
-			"Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		wdt_ping();
 	}
 	expect_close = 0;
@@ -344,18 +343,16 @@ static int __init wdt_init(void)
 {
 	int ret;
 
-	printk(KERN_INFO "WDT driver for the Winbond(TM) W83627HF/THF/HG/DHG Super I/O chip initialising.\n");
+	pr_info("WDT driver for the Winbond(TM) W83627HF/THF/HG/DHG Super I/O chip initialising\n");
 
 	if (wdt_set_heartbeat(timeout)) {
 		wdt_set_heartbeat(WATCHDOG_TIMEOUT);
-		printk(KERN_INFO PFX
-		     "timeout value must be 1 <= timeout <= 255, using %d\n",
-				WATCHDOG_TIMEOUT);
+		pr_info("timeout value must be 1 <= timeout <= 255, using %d\n",
+			WATCHDOG_TIMEOUT);
 	}
 
 	if (!request_region(wdt_io, 1, WATCHDOG_NAME)) {
-		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
-			wdt_io);
+		pr_err("I/O address 0x%04x already in use\n", wdt_io);
 		ret = -EIO;
 		goto out;
 	}
@@ -364,22 +361,19 @@ static int __init wdt_init(void)
 
 	ret = register_reboot_notifier(&wdt_notifier);
 	if (ret != 0) {
-		printk(KERN_ERR PFX
-			"cannot register reboot notifier (err=%d)\n", ret);
+		pr_err("cannot register reboot notifier (err=%d)\n", ret);
 		goto unreg_regions;
 	}
 
 	ret = misc_register(&wdt_miscdev);
 	if (ret != 0) {
-		printk(KERN_ERR PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-							WATCHDOG_MINOR, ret);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
 		goto unreg_reboot;
 	}
 
-	printk(KERN_INFO PFX
-			"initialized. timeout=%d sec (nowayout=%d)\n",
-							timeout, nowayout);
+	pr_info("initialized. timeout=%d sec (nowayout=%d)\n",
+		timeout, nowayout);
 
 out:
 	return ret;
diff --git a/drivers/watchdog/w83697hf_wdt.c b/drivers/watchdog/w83697hf_wdt.c
index af08972..2307418 100644
--- a/drivers/watchdog/w83697hf_wdt.c
+++ b/drivers/watchdog/w83697hf_wdt.c
@@ -25,6 +25,8 @@
  *	"AS-IS" and at no charge.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -42,7 +44,6 @@
 #include <asm/system.h>
 
 #define WATCHDOG_NAME "w83697hf/hg WDT"
-#define PFX WATCHDOG_NAME ": "
 #define WATCHDOG_TIMEOUT 60		/* 60 sec default timeout */
 #define WATCHDOG_EARLY_DISABLE 1	/* Disable until userland kicks in */
 
@@ -309,8 +310,7 @@ static int wdt_close(struct inode *inode, struct file *file)
 	if (expect_close == 42)
 		wdt_disable();
 	else {
-		printk(KERN_CRIT PFX
-			"Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		wdt_ping();
 	}
 	expect_close = 0;
@@ -362,24 +362,21 @@ static struct notifier_block wdt_notifier = {
 static int w83697hf_check_wdt(void)
 {
 	if (!request_region(wdt_io, 2, WATCHDOG_NAME)) {
-		printk(KERN_ERR PFX
-			"I/O address 0x%x already in use\n", wdt_io);
+		pr_err("I/O address 0x%x already in use\n", wdt_io);
 		return -EIO;
 	}
 
-	printk(KERN_DEBUG PFX
-			"Looking for watchdog at address 0x%x\n", wdt_io);
+	pr_debug("Looking for watchdog at address 0x%x\n", wdt_io);
 	w83697hf_unlock();
 	if (w83697hf_get_reg(0x20) == 0x60) {
-		printk(KERN_INFO PFX
-			"watchdog found at address 0x%x\n", wdt_io);
+		pr_info("watchdog found at address 0x%x\n", wdt_io);
 		w83697hf_lock();
 		return 0;
 	}
 	/* Reprotect in case it was a compatible device */
 	w83697hf_lock();
 
-	printk(KERN_INFO PFX "watchdog not found at address 0x%x\n", wdt_io);
+	pr_info("watchdog not found at address 0x%x\n", wdt_io);
 	release_region(wdt_io, 2);
 	return -EIO;
 }
@@ -390,7 +387,7 @@ static int __init wdt_init(void)
 {
 	int ret, i, found = 0;
 
-	printk(KERN_INFO PFX "WDT driver for W83697HF/HG initializing\n");
+	pr_info("WDT driver for W83697HF/HG initializing\n");
 
 	if (wdt_io == 0) {
 		/* we will autodetect the W83697HF/HG watchdog */
@@ -405,7 +402,7 @@ static int __init wdt_init(void)
 	}
 
 	if (!found) {
-		printk(KERN_ERR PFX "No W83697HF/HG could be found\n");
+		pr_err("No W83697HF/HG could be found\n");
 		ret = -EIO;
 		goto out;
 	}
@@ -413,34 +410,30 @@ static int __init wdt_init(void)
 	w83697hf_init();
 	if (early_disable) {
 		if (wdt_running())
-			printk(KERN_WARNING PFX "Stopping previously enabled "
-					"watchdog until userland kicks in\n");
+			pr_warn("Stopping previously enabled watchdog until userland kicks in\n");
 		wdt_disable();
 	}
 
 	if (wdt_set_heartbeat(timeout)) {
 		wdt_set_heartbeat(WATCHDOG_TIMEOUT);
-		printk(KERN_INFO PFX
-		     "timeout value must be 1 <= timeout <= 255, using %d\n",
-							WATCHDOG_TIMEOUT);
+		pr_info("timeout value must be 1 <= timeout <= 255, using %d\n",
+			WATCHDOG_TIMEOUT);
 	}
 
 	ret = register_reboot_notifier(&wdt_notifier);
 	if (ret != 0) {
-		printk(KERN_ERR PFX
-			"cannot register reboot notifier (err=%d)\n", ret);
+		pr_err("cannot register reboot notifier (err=%d)\n", ret);
 		goto unreg_regions;
 	}
 
 	ret = misc_register(&wdt_miscdev);
 	if (ret != 0) {
-		printk(KERN_ERR PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-						WATCHDOG_MINOR, ret);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
 		goto unreg_reboot;
 	}
 
-	printk(KERN_INFO PFX "initialized. timeout=%d sec (nowayout=%d)\n",
+	pr_info("initialized. timeout=%d sec (nowayout=%d)\n",
 		timeout, nowayout);
 
 out:
diff --git a/drivers/watchdog/w83697ug_wdt.c b/drivers/watchdog/w83697ug_wdt.c
index be9c4d8..025736b 100644
--- a/drivers/watchdog/w83697ug_wdt.c
+++ b/drivers/watchdog/w83697ug_wdt.c
@@ -30,6 +30,8 @@
  *	(c) Copyright 1995    Alan Cox <alan@redhat.com>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -47,7 +49,6 @@
 #include <asm/system.h>
 
 #define WATCHDOG_NAME "w83697ug/uf WDT"
-#define PFX WATCHDOG_NAME ": "
 #define WATCHDOG_TIMEOUT 60		/* 60 sec default timeout */
 
 static unsigned long wdt_is_open;
@@ -91,8 +92,8 @@ static int w83697ug_select_wd_register(void)
 	version = inb(WDT_EFDR);
 
 	if (version == 0x68) {	/* W83697UG		*/
-		printk(KERN_INFO PFX "Watchdog chip version 0x%02x = "
-			"W83697UG/UF found at 0x%04x\n", version, wdt_io);
+		pr_info("Watchdog chip version 0x%02x = W83697UG/UF found at 0x%04x\n",
+			version, wdt_io);
 
 		outb_p(0x2b, WDT_EFER);
 		c = inb_p(WDT_EFDR);    /* select WDT0 */
@@ -101,7 +102,7 @@ static int w83697ug_select_wd_register(void)
 		outb_p(c, WDT_EFDR);	/* set pin118 to WDT0 */
 
 	} else {
-		printk(KERN_ERR PFX "No W83697UG/UF could be found\n");
+		pr_err("No W83697UG/UF could be found\n");
 		return -ENODEV;
 	}
 
@@ -131,8 +132,8 @@ static int w83697ug_init(void)
 	outb_p(0xF6, WDT_EFER); /* Select CRF6 */
 	t = inb_p(WDT_EFDR);    /* read CRF6 */
 	if (t != 0) {
-		printk(KERN_INFO PFX "Watchdog already running."
-			" Resetting timeout to %d sec\n", timeout);
+		pr_info("Watchdog already running. Resetting timeout to %d sec\n",
+			timeout);
 		outb_p(timeout, WDT_EFDR);    /* Write back to CRF6 */
 	}
 	outb_p(0xF5, WDT_EFER); /* Select CRF5 */
@@ -286,8 +287,7 @@ static int wdt_close(struct inode *inode, struct file *file)
 	if (expect_close == 42)
 		wdt_disable();
 	else {
-		printk(KERN_CRIT PFX
-			"Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		wdt_ping();
 	}
 	expect_close = 0;
@@ -340,18 +340,16 @@ static int __init wdt_init(void)
 {
 	int ret;
 
-	printk(KERN_INFO "WDT driver for the Winbond(TM) W83697UG/UF Super I/O chip initialising.\n");
+	pr_info("WDT driver for the Winbond(TM) W83697UG/UF Super I/O chip initialising\n");
 
 	if (wdt_set_heartbeat(timeout)) {
 		wdt_set_heartbeat(WATCHDOG_TIMEOUT);
-		printk(KERN_INFO PFX
-			"timeout value must be 1<=timeout<=255, using %d\n",
+		pr_info("timeout value must be 1<=timeout<=255, using %d\n",
 			WATCHDOG_TIMEOUT);
 	}
 
 	if (!request_region(wdt_io, 1, WATCHDOG_NAME)) {
-		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
-			wdt_io);
+		pr_err("I/O address 0x%04x already in use\n", wdt_io);
 		ret = -EIO;
 		goto out;
 	}
@@ -362,20 +360,18 @@ static int __init wdt_init(void)
 
 	ret = register_reboot_notifier(&wdt_notifier);
 	if (ret != 0) {
-		printk(KERN_ERR PFX
-			"cannot register reboot notifier (err=%d)\n", ret);
+		pr_err("cannot register reboot notifier (err=%d)\n", ret);
 		goto unreg_regions;
 	}
 
 	ret = misc_register(&wdt_miscdev);
 	if (ret != 0) {
-		printk(KERN_ERR PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
 		goto unreg_reboot;
 	}
 
-	printk(KERN_INFO PFX "initialized. timeout=%d sec (nowayout=%d)\n",
+	pr_info("initialized. timeout=%d sec (nowayout=%d)\n",
 		timeout, nowayout);
 
 out:
diff --git a/drivers/watchdog/w83877f_wdt.c b/drivers/watchdog/w83877f_wdt.c
index 24587d2..d761414 100644
--- a/drivers/watchdog/w83877f_wdt.c
+++ b/drivers/watchdog/w83877f_wdt.c
@@ -42,6 +42,8 @@
  *  daemon always getting scheduled within that time frame.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -59,7 +61,6 @@
 #include <asm/system.h>
 
 #define OUR_NAME "w83877f_wdt"
-#define PFX OUR_NAME ": "
 
 #define ENABLE_W83877F_PORT 0x3F0
 #define ENABLE_W83877F 0x87
@@ -126,8 +127,7 @@ static void wdt_timer_ping(unsigned long data)
 		spin_unlock(&wdt_spinlock);
 
 	} else
-		printk(KERN_WARNING PFX
-			"Heartbeat lost! Will not ping the watchdog\n");
+		pr_warn("Heartbeat lost! Will not ping the watchdog\n");
 }
 
 /*
@@ -165,7 +165,7 @@ static void wdt_startup(void)
 
 	wdt_change(WDT_ENABLE);
 
-	printk(KERN_INFO PFX "Watchdog timer is now enabled.\n");
+	pr_info("Watchdog timer is now enabled\n");
 }
 
 static void wdt_turnoff(void)
@@ -175,7 +175,7 @@ static void wdt_turnoff(void)
 
 	wdt_change(WDT_DISABLE);
 
-	printk(KERN_INFO PFX "Watchdog timer is now disabled...\n");
+	pr_info("Watchdog timer is now disabled...\n");
 }
 
 static void wdt_keepalive(void)
@@ -234,8 +234,7 @@ static int fop_close(struct inode *inode, struct file *file)
 		wdt_turnoff();
 	else {
 		del_timer(&timer);
-		printk(KERN_CRIT PFX
-		  "device file closed unexpectedly. Will not stop the WDT!\n");
+		pr_crit("device file closed unexpectedly. Will not stop the WDT!\n");
 	}
 	clear_bit(0, &wdt_is_open);
 	wdt_expect_close = 0;
@@ -357,42 +356,37 @@ static int __init w83877f_wdt_init(void)
 
 	if (timeout < 1 || timeout > 3600) { /* arbitrary upper limit */
 		timeout = WATCHDOG_TIMEOUT;
-		printk(KERN_INFO PFX
-			"timeout value must be 1 <= x <= 3600, using %d\n",
-							timeout);
+		pr_info("timeout value must be 1 <= x <= 3600, using %d\n",
+			timeout);
 	}
 
 	if (!request_region(ENABLE_W83877F_PORT, 2, "W83877F WDT")) {
-		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
-			ENABLE_W83877F_PORT);
+		pr_err("I/O address 0x%04x already in use\n",
+		       ENABLE_W83877F_PORT);
 		rc = -EIO;
 		goto err_out;
 	}
 
 	if (!request_region(WDT_PING, 1, "W8387FF WDT")) {
-		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
-			WDT_PING);
+		pr_err("I/O address 0x%04x already in use\n", WDT_PING);
 		rc = -EIO;
 		goto err_out_region1;
 	}
 
 	rc = register_reboot_notifier(&wdt_notifier);
 	if (rc) {
-		printk(KERN_ERR PFX
-			"cannot register reboot notifier (err=%d)\n", rc);
+		pr_err("cannot register reboot notifier (err=%d)\n", rc);
 		goto err_out_region2;
 	}
 
 	rc = misc_register(&wdt_miscdev);
 	if (rc) {
-		printk(KERN_ERR PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-							wdt_miscdev.minor, rc);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       wdt_miscdev.minor, rc);
 		goto err_out_reboot;
 	}
 
-	printk(KERN_INFO PFX
-	  "WDT driver for W83877F initialised. timeout=%d sec (nowayout=%d)\n",
+	pr_info("WDT driver for W83877F initialised. timeout=%d sec (nowayout=%d)\n",
 		timeout, nowayout);
 
 	return 0;
diff --git a/drivers/watchdog/w83977f_wdt.c b/drivers/watchdog/w83977f_wdt.c
index 6e6743d..d301b1b 100644
--- a/drivers/watchdog/w83977f_wdt.c
+++ b/drivers/watchdog/w83977f_wdt.c
@@ -15,6 +15,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -33,8 +35,6 @@
 
 #define WATCHDOG_VERSION  "1.00"
 #define WATCHDOG_NAME     "W83977F WDT"
-#define PFX WATCHDOG_NAME ": "
-#define DRIVER_VERSION    WATCHDOG_NAME " driver, v" WATCHDOG_VERSION "\n"
 
 #define IO_INDEX_PORT     0x3F0
 #define IO_DATA_PORT      (IO_INDEX_PORT+1)
@@ -131,7 +131,7 @@ static int wdt_start(void)
 
 	spin_unlock_irqrestore(&spinlock, flags);
 
-	printk(KERN_INFO PFX "activated.\n");
+	pr_info("activated\n");
 
 	return 0;
 }
@@ -185,7 +185,7 @@ static int wdt_stop(void)
 
 	spin_unlock_irqrestore(&spinlock, flags);
 
-	printk(KERN_INFO PFX "shutdown.\n");
+	pr_info("shutdown\n");
 
 	return 0;
 }
@@ -313,8 +313,7 @@ static int wdt_release(struct inode *inode, struct file *file)
 		clear_bit(0, &timer_alive);
 	} else {
 		wdt_keepalive();
-		printk(KERN_CRIT PFX
-			"unexpected close, not stopping watchdog!\n");
+		pr_crit("unexpected close, not stopping watchdog!\n");
 	}
 	expect_close = 0;
 	return 0;
@@ -471,7 +470,7 @@ static int __init w83977f_wdt_init(void)
 {
 	int rc;
 
-	printk(KERN_INFO PFX DRIVER_VERSION);
+	pr_info("driver v%s\n", WATCHDOG_VERSION);
 
 	/*
 	 * Check that the timeout value is within it's range;
@@ -479,36 +478,31 @@ static int __init w83977f_wdt_init(void)
 	 */
 	if (wdt_set_timeout(timeout)) {
 		wdt_set_timeout(DEFAULT_TIMEOUT);
-		printk(KERN_INFO PFX
-		    "timeout value must be 15 <= timeout <= 7635, using %d\n",
-							DEFAULT_TIMEOUT);
+		pr_info("timeout value must be 15 <= timeout <= 7635, using %d\n",
+			DEFAULT_TIMEOUT);
 	}
 
 	if (!request_region(IO_INDEX_PORT, 2, WATCHDOG_NAME)) {
-		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
-			IO_INDEX_PORT);
+		pr_err("I/O address 0x%04x already in use\n", IO_INDEX_PORT);
 		rc = -EIO;
 		goto err_out;
 	}
 
 	rc = register_reboot_notifier(&wdt_notifier);
 	if (rc) {
-		printk(KERN_ERR PFX
-			"cannot register reboot notifier (err=%d)\n", rc);
+		pr_err("cannot register reboot notifier (err=%d)\n", rc);
 		goto err_out_region;
 	}
 
 	rc = misc_register(&wdt_miscdev);
 	if (rc) {
-		printk(KERN_ERR PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-						wdt_miscdev.minor, rc);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       wdt_miscdev.minor, rc);
 		goto err_out_reboot;
 	}
 
-	printk(KERN_INFO PFX
-		"initialized. timeout=%d sec (nowayout=%d testmode=%d)\n",
-					timeout, nowayout, testmode);
+	pr_info("initialized. timeout=%d sec (nowayout=%d testmode=%d)\n",
+		timeout, nowayout, testmode);
 
 	return 0;
 
diff --git a/drivers/watchdog/wafer5823wdt.c b/drivers/watchdog/wafer5823wdt.c
index c3c3188..1dea144 100644
--- a/drivers/watchdog/wafer5823wdt.c
+++ b/drivers/watchdog/wafer5823wdt.c
@@ -26,6 +26,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/miscdevice.h>
@@ -203,8 +205,7 @@ static int wafwdt_close(struct inode *inode, struct file *file)
 	if (expect_close == 42)
 		wafwdt_stop();
 	else {
-		printk(KERN_CRIT PFX
-		    "WDT device closed unexpectedly.  WDT will not stop!\n");
+		pr_crit("WDT device closed unexpectedly.  WDT will not stop!\n");
 		wafwdt_ping();
 	}
 	clear_bit(0, &wafwdt_is_open);
@@ -256,49 +257,42 @@ static int __init wafwdt_init(void)
 {
 	int ret;
 
-	printk(KERN_INFO
-	  "WDT driver for Wafer 5823 single board computer initialising.\n");
+	pr_info("WDT driver for Wafer 5823 single board computer initialising\n");
 
 	if (timeout < 1 || timeout > 255) {
 		timeout = WD_TIMO;
-		printk(KERN_INFO PFX
-			"timeout value must be 1 <= x <= 255, using %d\n",
-								timeout);
+		pr_info("timeout value must be 1 <= x <= 255, using %d\n",
+			timeout);
 	}
 
 	if (wdt_stop != wdt_start) {
 		if (!request_region(wdt_stop, 1, "Wafer 5823 WDT")) {
-			printk(KERN_ERR PFX
-				"I/O address 0x%04x already in use\n",
-								wdt_stop);
+			pr_err("I/O address 0x%04x already in use\n", wdt_stop);
 			ret = -EIO;
 			goto error;
 		}
 	}
 
 	if (!request_region(wdt_start, 1, "Wafer 5823 WDT")) {
-		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
-			wdt_start);
+		pr_err("I/O address 0x%04x already in use\n", wdt_start);
 		ret = -EIO;
 		goto error2;
 	}
 
 	ret = register_reboot_notifier(&wafwdt_notifier);
 	if (ret != 0) {
-		printk(KERN_ERR PFX
-			"cannot register reboot notifier (err=%d)\n", ret);
+		pr_err("cannot register reboot notifier (err=%d)\n", ret);
 		goto error3;
 	}
 
 	ret = misc_register(&wafwdt_miscdev);
 	if (ret != 0) {
-		printk(KERN_ERR PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-						WATCHDOG_MINOR, ret);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
 		goto error4;
 	}
 
-	printk(KERN_INFO PFX "initialized. timeout=%d sec (nowayout=%d)\n",
+	pr_info("initialized. timeout=%d sec (nowayout=%d)\n",
 		timeout, nowayout);
 
 	return ret;
diff --git a/drivers/watchdog/watchdog_core.c b/drivers/watchdog/watchdog_core.c
index cfa1a15..14d768b 100644
--- a/drivers/watchdog/watchdog_core.c
+++ b/drivers/watchdog/watchdog_core.c
@@ -77,7 +77,7 @@ int watchdog_register_device(struct watchdog_device *wdd)
 	/* We only support 1 watchdog device via the /dev/watchdog interface */
 	ret = watchdog_dev_register(wdd);
 	if (ret) {
-		pr_err("error registering /dev/watchdog (err=%d).\n", ret);
+		pr_err("error registering /dev/watchdog (err=%d)\n", ret);
 		return ret;
 	}
 
@@ -101,7 +101,7 @@ void watchdog_unregister_device(struct watchdog_device *wdd)
 
 	ret = watchdog_dev_unregister(wdd);
 	if (ret)
-		pr_err("error unregistering /dev/watchdog (err=%d).\n", ret);
+		pr_err("error unregistering /dev/watchdog (err=%d)\n", ret);
 }
 EXPORT_SYMBOL_GPL(watchdog_unregister_device);
 
diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index 1199da0..55b1f60 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -347,7 +347,7 @@ int watchdog_dev_register(struct watchdog_device *watchdog)
 
 	/* Only one device can register for /dev/watchdog */
 	if (test_and_set_bit(0, &watchdog_dev_busy)) {
-		pr_err("only one watchdog can use /dev/watchdog.\n");
+		pr_err("only one watchdog can use /dev/watchdog\n");
 		return -EBUSY;
 	}
 
@@ -355,8 +355,8 @@ int watchdog_dev_register(struct watchdog_device *watchdog)
 
 	err = misc_register(&watchdog_miscdev);
 	if (err != 0) {
-		pr_err("%s: cannot register miscdev on minor=%d (err=%d).\n",
-			watchdog->info->identity, WATCHDOG_MINOR, err);
+		pr_err("%s: cannot register miscdev on minor=%d (err=%d)\n",
+		       watchdog->info->identity, WATCHDOG_MINOR, err);
 		goto out;
 	}
 
@@ -383,8 +383,8 @@ int watchdog_dev_unregister(struct watchdog_device *watchdog)
 
 	/* We can only unregister the watchdog device that was registered */
 	if (watchdog != wdd) {
-		pr_err("%s: watchdog was not registered as /dev/watchdog.\n",
-			watchdog->info->identity);
+		pr_err("%s: watchdog was not registered as /dev/watchdog\n",
+		       watchdog->info->identity);
 		return -ENODEV;
 	}
 
diff --git a/drivers/watchdog/wdrtas.c b/drivers/watchdog/wdrtas.c
index 94ec22b..b7b3460 100644
--- a/drivers/watchdog/wdrtas.c
+++ b/drivers/watchdog/wdrtas.c
@@ -26,6 +26,8 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -93,8 +95,8 @@ static int wdrtas_set_interval(int interval)
 	result = rtas_call(wdrtas_token_set_indicator, 3, 1, NULL,
 			   WDRTAS_SURVEILLANCE_IND, 0, interval);
 	if (result < 0 && print_msg) {
-		printk(KERN_ERR "wdrtas: setting the watchdog to %i "
-		       "timeout failed: %li\n", interval, result);
+		pr_err("setting the watchdog to %i timeout failed: %li\n",
+		       interval, result);
 		print_msg--;
 	}
 
@@ -128,8 +130,8 @@ static int wdrtas_get_interval(int fallback_value)
 	spin_unlock(&rtas_data_buf_lock);
 
 	if (value[0] != 0 || value[1] != 2 || value[3] != 0 || result < 0) {
-		printk(KERN_WARNING "wdrtas: could not get sp_spi watchdog "
-		       "timeout (%li). Continuing\n", result);
+		pr_warn("could not get sp_spi watchdog timeout (%li). Continuing\n",
+			result);
 		return fallback_value;
 	}
 
@@ -170,18 +172,18 @@ static void wdrtas_log_scanned_event(void)
 	int i;
 
 	for (i = 0; i < WDRTAS_LOGBUFFER_LEN; i += 16)
-		printk(KERN_INFO "wdrtas: dumping event (line %i/%i), data = "
-		       "%02x %02x %02x %02x  %02x %02x %02x %02x   "
-		       "%02x %02x %02x %02x  %02x %02x %02x %02x\n",
-		       (i / 16) + 1, (WDRTAS_LOGBUFFER_LEN / 16),
-		       wdrtas_logbuffer[i + 0], wdrtas_logbuffer[i + 1],
-		       wdrtas_logbuffer[i + 2], wdrtas_logbuffer[i + 3],
-		       wdrtas_logbuffer[i + 4], wdrtas_logbuffer[i + 5],
-		       wdrtas_logbuffer[i + 6], wdrtas_logbuffer[i + 7],
-		       wdrtas_logbuffer[i + 8], wdrtas_logbuffer[i + 9],
-		       wdrtas_logbuffer[i + 10], wdrtas_logbuffer[i + 11],
-		       wdrtas_logbuffer[i + 12], wdrtas_logbuffer[i + 13],
-		       wdrtas_logbuffer[i + 14], wdrtas_logbuffer[i + 15]);
+		pr_info("dumping event (line %i/%i), data = "
+			"%02x %02x %02x %02x  %02x %02x %02x %02x   "
+			"%02x %02x %02x %02x  %02x %02x %02x %02x\n",
+			(i / 16) + 1, (WDRTAS_LOGBUFFER_LEN / 16),
+			wdrtas_logbuffer[i + 0], wdrtas_logbuffer[i + 1],
+			wdrtas_logbuffer[i + 2], wdrtas_logbuffer[i + 3],
+			wdrtas_logbuffer[i + 4], wdrtas_logbuffer[i + 5],
+			wdrtas_logbuffer[i + 6], wdrtas_logbuffer[i + 7],
+			wdrtas_logbuffer[i + 8], wdrtas_logbuffer[i + 9],
+			wdrtas_logbuffer[i + 10], wdrtas_logbuffer[i + 11],
+			wdrtas_logbuffer[i + 12], wdrtas_logbuffer[i + 13],
+			wdrtas_logbuffer[i + 14], wdrtas_logbuffer[i + 15]);
 }
 
 /**
@@ -201,8 +203,7 @@ static void wdrtas_timer_keepalive(void)
 				   (void *)__pa(wdrtas_logbuffer),
 				   WDRTAS_LOGBUFFER_LEN);
 		if (result < 0)
-			printk(KERN_ERR "wdrtas: event-scan failed: %li\n",
-			       result);
+			pr_err("event-scan failed: %li\n", result);
 		if (result == 0)
 			wdrtas_log_scanned_event();
 	} while (result == 0);
@@ -224,8 +225,7 @@ static int wdrtas_get_temperature(void)
 	result = rtas_get_sensor(WDRTAS_THERMAL_SENSOR, 0, &temperature);
 
 	if (result < 0)
-		printk(KERN_WARNING "wdrtas: reading the thermal sensor "
-		       "failed: %i\n", result);
+		pr_warn("reading the thermal sensor failed: %i\n", result);
 	else
 		temperature = ((temperature * 9) / 5) + 32; /* fahrenheit */
 
@@ -419,8 +419,7 @@ static int wdrtas_close(struct inode *inode, struct file *file)
 	if (wdrtas_expect_close == WDRTAS_MAGIC_CHAR)
 		wdrtas_timer_stop();
 	else {
-		printk(KERN_WARNING "wdrtas: got unexpected close. Watchdog "
-		       "not stopped.\n");
+		pr_warn("got unexpected close. Watchdog not stopped.\n");
 		wdrtas_timer_keepalive();
 	}
 
@@ -552,30 +551,24 @@ static int wdrtas_get_tokens(void)
 {
 	wdrtas_token_get_sensor_state = rtas_token("get-sensor-state");
 	if (wdrtas_token_get_sensor_state == RTAS_UNKNOWN_SERVICE) {
-		printk(KERN_WARNING "wdrtas: couldn't get token for "
-		       "get-sensor-state. Trying to continue without "
-		       "temperature support.\n");
+		pr_warn("couldn't get token for get-sensor-state. Trying to continue without temperature support.\n");
 	}
 
 	wdrtas_token_get_sp = rtas_token("ibm,get-system-parameter");
 	if (wdrtas_token_get_sp == RTAS_UNKNOWN_SERVICE) {
-		printk(KERN_WARNING "wdrtas: couldn't get token for "
-		       "ibm,get-system-parameter. Trying to continue with "
-		       "a default timeout value of %i seconds.\n",
-		       WDRTAS_DEFAULT_INTERVAL);
+		pr_warn("couldn't get token for ibm,get-system-parameter. Trying to continue with a default timeout value of %i seconds.\n",
+			WDRTAS_DEFAULT_INTERVAL);
 	}
 
 	wdrtas_token_set_indicator = rtas_token("set-indicator");
 	if (wdrtas_token_set_indicator == RTAS_UNKNOWN_SERVICE) {
-		printk(KERN_ERR "wdrtas: couldn't get token for "
-		       "set-indicator. Terminating watchdog code.\n");
+		pr_err("couldn't get token for set-indicator. Terminating watchdog code.\n");
 		return -EIO;
 	}
 
 	wdrtas_token_event_scan = rtas_token("event-scan");
 	if (wdrtas_token_event_scan == RTAS_UNKNOWN_SERVICE) {
-		printk(KERN_ERR "wdrtas: couldn't get token for event-scan. "
-		       "Terminating watchdog code.\n");
+		pr_err("couldn't get token for event-scan. Terminating watchdog code.\n");
 		return -EIO;
 	}
 
@@ -609,17 +602,14 @@ static int wdrtas_register_devs(void)
 
 	result = misc_register(&wdrtas_miscdev);
 	if (result) {
-		printk(KERN_ERR "wdrtas: couldn't register watchdog misc "
-		       "device. Terminating watchdog code.\n");
+		pr_err("couldn't register watchdog misc device. Terminating watchdog code.\n");
 		return result;
 	}
 
 	if (wdrtas_token_get_sensor_state != RTAS_UNKNOWN_SERVICE) {
 		result = misc_register(&wdrtas_tempdev);
 		if (result) {
-			printk(KERN_WARNING "wdrtas: couldn't register "
-			       "watchdog temperature misc device. Continuing "
-			       "without temperature support.\n");
+			pr_warn("couldn't register watchdog temperature misc device. Continuing without temperature support.\n");
 			wdrtas_token_get_sensor_state = RTAS_UNKNOWN_SERVICE;
 		}
 	}
@@ -643,8 +633,7 @@ static int __init wdrtas_init(void)
 		return -ENODEV;
 
 	if (register_reboot_notifier(&wdrtas_notifier)) {
-		printk(KERN_ERR "wdrtas: could not register reboot notifier. "
-		       "Terminating watchdog code.\n");
+		pr_err("could not register reboot notifier. Terminating watchdog code.\n");
 		wdrtas_unregister_devs();
 		return -ENODEV;
 	}
diff --git a/drivers/watchdog/wdt.c b/drivers/watchdog/wdt.c
index d2ef002..4ef6702 100644
--- a/drivers/watchdog/wdt.c
+++ b/drivers/watchdog/wdt.c
@@ -32,6 +32,8 @@
  *		Matt Domsch	:	Added nowayout module option
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
@@ -252,11 +254,11 @@ static int wdt_get_temperature(void)
 static void wdt_decode_501(int status)
 {
 	if (!(status & WDC_SR_TGOOD))
-		printk(KERN_CRIT "Overheat alarm.(%d)\n", inb_p(WDT_RT));
+		pr_crit("Overheat alarm (%d)\n", inb_p(WDT_RT));
 	if (!(status & WDC_SR_PSUOVER))
-		printk(KERN_CRIT "PSU over voltage.\n");
+		pr_crit("PSU over voltage\n");
 	if (!(status & WDC_SR_PSUUNDR))
-		printk(KERN_CRIT "PSU under voltage.\n");
+		pr_crit("PSU under voltage\n");
 }
 
 /**
@@ -280,25 +282,25 @@ static irqreturn_t wdt_interrupt(int irq, void *dev_id)
 	spin_lock(&wdt_lock);
 	status = inb_p(WDT_SR);
 
-	printk(KERN_CRIT "WDT status %d\n", status);
+	pr_crit("WDT status %d\n", status);
 
 	if (type == 501) {
 		wdt_decode_501(status);
 		if (tachometer) {
 			if (!(status & WDC_SR_FANGOOD))
-				printk(KERN_CRIT "Possible fan fault.\n");
+				pr_crit("Possible fan fault\n");
 		}
 	}
 	if (!(status & WDC_SR_WCCR)) {
 #ifdef SOFTWARE_REBOOT
 #ifdef ONLY_TESTING
-		printk(KERN_CRIT "Would Reboot.\n");
+		pr_crit("Would Reboot\n");
 #else
-		printk(KERN_CRIT "Initiating system reboot.\n");
+		pr_crit("Initiating system reboot\n");
 		emergency_restart();
 #endif
 #else
-		printk(KERN_CRIT "Reset in 5ms.\n");
+		pr_crit("Reset in 5ms\n");
 #endif
 	}
 	spin_unlock(&wdt_lock);
@@ -441,8 +443,7 @@ static int wdt_release(struct inode *inode, struct file *file)
 		wdt_stop();
 		clear_bit(0, &wdt_is_open);
 	} else {
-		printk(KERN_CRIT
-		 "wdt: WDT device closed unexpectedly.  WDT will not stop!\n");
+		pr_crit("WDT device closed unexpectedly.  WDT will not stop!\n");
 		wdt_ping();
 	}
 	expect_close = 0;
@@ -593,7 +594,7 @@ static int __init wdt_init(void)
 	int ret;
 
 	if (type != 500 && type != 501) {
-		printk(KERN_ERR "wdt: unknown card type '%d'.\n", type);
+		pr_err("unknown card type '%d'\n", type);
 		return -ENODEV;
 	}
 
@@ -601,53 +602,49 @@ static int __init wdt_init(void)
 	   if not reset to the default */
 	if (wdt_set_heartbeat(heartbeat)) {
 		wdt_set_heartbeat(WD_TIMO);
-		printk(KERN_INFO "wdt: heartbeat value must be "
-			"0 < heartbeat < 65536, using %d\n", WD_TIMO);
+		pr_info("heartbeat value must be 0 < heartbeat < 65536, using %d\n",
+			WD_TIMO);
 	}
 
 	if (!request_region(io, 8, "wdt501p")) {
-		printk(KERN_ERR
-			"wdt: I/O address 0x%04x already in use\n", io);
+		pr_err("I/O address 0x%04x already in use\n", io);
 		ret = -EBUSY;
 		goto out;
 	}
 
 	ret = request_irq(irq, wdt_interrupt, 0, "wdt501p", NULL);
 	if (ret) {
-		printk(KERN_ERR "wdt: IRQ %d is not free.\n", irq);
+		pr_err("IRQ %d is not free\n", irq);
 		goto outreg;
 	}
 
 	ret = register_reboot_notifier(&wdt_notifier);
 	if (ret) {
-		printk(KERN_ERR
-		      "wdt: cannot register reboot notifier (err=%d)\n", ret);
+		pr_err("cannot register reboot notifier (err=%d)\n", ret);
 		goto outirq;
 	}
 
 	if (type == 501) {
 		ret = misc_register(&temp_miscdev);
 		if (ret) {
-			printk(KERN_ERR "wdt: cannot register miscdev "
-				"on minor=%d (err=%d)\n", TEMP_MINOR, ret);
+			pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+			       TEMP_MINOR, ret);
 			goto outrbt;
 		}
 	}
 
 	ret = misc_register(&wdt_miscdev);
 	if (ret) {
-		printk(KERN_ERR
-			"wdt: cannot register miscdev on minor=%d (err=%d)\n",
-							WATCHDOG_MINOR, ret);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
 		goto outmisc;
 	}
 
-	printk(KERN_INFO "WDT500/501-P driver 0.10 "
-		"at 0x%04x (Interrupt %d). heartbeat=%d sec (nowayout=%d)\n",
+	pr_info("WDT500/501-P driver 0.10 at 0x%04x (Interrupt %d). heartbeat=%d sec (nowayout=%d)\n",
 		io, irq, heartbeat, nowayout);
 	if (type == 501)
-		printk(KERN_INFO "wdt: Fan Tachometer is %s\n",
-				(tachometer ? "Enabled" : "Disabled"));
+		pr_info("Fan Tachometer is %s\n",
+			tachometer ? "Enabled" : "Disabled");
 	return 0;
 
 outmisc:
diff --git a/drivers/watchdog/wdt285.c b/drivers/watchdog/wdt285.c
index f551356..3daa330 100644
--- a/drivers/watchdog/wdt285.c
+++ b/drivers/watchdog/wdt285.c
@@ -16,6 +16,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -49,7 +51,7 @@ static unsigned long timer_alive;
  */
 static void watchdog_fire(int irq, void *dev_id)
 {
-	printk(KERN_CRIT "Watchdog: Would Reboot.\n");
+	pr_crit("Would Reboot\n");
 	*CSR_TIMER4_CNTL = 0;
 	*CSR_TIMER4_CLR = 0;
 }
@@ -205,13 +207,11 @@ static int __init footbridge_watchdog_init(void)
 	if (retval < 0)
 		return retval;
 
-	printk(KERN_INFO
-		"Footbridge Watchdog Timer: 0.01, timer margin: %d sec\n",
-								soft_margin);
+	pr_info("Footbridge Watchdog Timer: 0.01, timer margin: %d sec\n",
+		soft_margin);
 
 	if (machine_is_cats())
-		printk(KERN_WARNING
-		  "Warning: Watchdog reset may not work on this machine.\n");
+		pr_warn("Warning: Watchdog reset may not work on this machine\n");
 	return 0;
 }
 
diff --git a/drivers/watchdog/wdt977.c b/drivers/watchdog/wdt977.c
index a2f01c9..cfb0a8c 100644
--- a/drivers/watchdog/wdt977.c
+++ b/drivers/watchdog/wdt977.c
@@ -23,6 +23,8 @@
  *				    Netwinders only
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -42,8 +44,6 @@
 
 #define WATCHDOG_VERSION  "0.04"
 #define WATCHDOG_NAME     "Wdt977"
-#define PFX WATCHDOG_NAME ": "
-#define DRIVER_VERSION    WATCHDOG_NAME " driver, v" WATCHDOG_VERSION "\n"
 
 #define IO_INDEX_PORT	0x370		/* on some systems it can be 0x3F0 */
 #define IO_DATA_PORT	(IO_INDEX_PORT + 1)
@@ -119,7 +119,7 @@ static int wdt977_start(void)
 	outb_p(LOCK_DATA, IO_INDEX_PORT);
 
 	spin_unlock_irqrestore(&spinlock, flags);
-	printk(KERN_INFO PFX "activated.\n");
+	pr_info("activated\n");
 
 	return 0;
 }
@@ -164,7 +164,7 @@ static int wdt977_stop(void)
 	outb_p(LOCK_DATA, IO_INDEX_PORT);
 
 	spin_unlock_irqrestore(&spinlock, flags);
-	printk(KERN_INFO PFX "shutdown.\n");
+	pr_info("shutdown\n");
 
 	return 0;
 }
@@ -288,8 +288,7 @@ static int wdt977_release(struct inode *inode, struct file *file)
 		clear_bit(0, &timer_alive);
 	} else {
 		wdt977_keepalive();
-		printk(KERN_CRIT PFX
-			"Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 	}
 	expect_close = 0;
 	return 0;
@@ -446,15 +445,14 @@ static int __init wd977_init(void)
 {
 	int rc;
 
-	printk(KERN_INFO PFX DRIVER_VERSION);
+	pr_info("driver v%s\n", WATCHDOG_VERSION);
 
 	/* Check that the timeout value is within its range;
 	   if not reset to the default */
 	if (wdt977_set_timeout(timeout)) {
 		wdt977_set_timeout(DEFAULT_TIMEOUT);
-		printk(KERN_INFO PFX
-		      "timeout value must be 60 < timeout < 15300, using %d\n",
-							DEFAULT_TIMEOUT);
+		pr_info("timeout value must be 60 < timeout < 15300, using %d\n",
+			DEFAULT_TIMEOUT);
 	}
 
 	/* on Netwinder the IOports are already reserved by
@@ -462,9 +460,8 @@ static int __init wd977_init(void)
 	 */
 	if (!machine_is_netwinder()) {
 		if (!request_region(IO_INDEX_PORT, 2, WATCHDOG_NAME)) {
-			printk(KERN_ERR PFX
-				"I/O address 0x%04x already in use\n",
-								IO_INDEX_PORT);
+			pr_err("I/O address 0x%04x already in use\n",
+			       IO_INDEX_PORT);
 			rc = -EIO;
 			goto err_out;
 		}
@@ -472,22 +469,19 @@ static int __init wd977_init(void)
 
 	rc = register_reboot_notifier(&wdt977_notifier);
 	if (rc) {
-		printk(KERN_ERR PFX
-			"cannot register reboot notifier (err=%d)\n", rc);
+		pr_err("cannot register reboot notifier (err=%d)\n", rc);
 		goto err_out_region;
 	}
 
 	rc = misc_register(&wdt977_miscdev);
 	if (rc) {
-		printk(KERN_ERR PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-						wdt977_miscdev.minor, rc);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       wdt977_miscdev.minor, rc);
 		goto err_out_reboot;
 	}
 
-	printk(KERN_INFO PFX
-		"initialized. timeout=%d sec (nowayout=%d, testmode=%i)\n",
-						timeout, nowayout, testmode);
+	pr_info("initialized. timeout=%d sec (nowayout=%d, testmode=%i)\n",
+		timeout, nowayout, testmode);
 
 	return 0;
 
diff --git a/drivers/watchdog/wdt_pci.c b/drivers/watchdog/wdt_pci.c
index e0fc3baa..c099b6f 100644
--- a/drivers/watchdog/wdt_pci.c
+++ b/drivers/watchdog/wdt_pci.c
@@ -37,6 +37,8 @@
  *		Matt Domsch	:	nowayout module option
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
@@ -58,8 +60,6 @@
 #define WDT_IS_PCI
 #include "wd501p.h"
 
-#define PFX "wdt_pci: "
-
 /* We can only use 1 card due to the /dev/watchdog restriction */
 static int dev_count;
 
@@ -312,33 +312,32 @@ static irqreturn_t wdtpci_interrupt(int irq, void *dev_id)
 	status = inb(WDT_SR);
 	udelay(8);
 
-	printk(KERN_CRIT PFX "status %d\n", status);
+	pr_crit("status %d\n", status);
 
 	if (type == 501) {
 		if (!(status & WDC_SR_TGOOD)) {
-			printk(KERN_CRIT PFX "Overheat alarm.(%d)\n",
-								inb(WDT_RT));
+			pr_crit("Overheat alarm (%d)\n", inb(WDT_RT));
 			udelay(8);
 		}
 		if (!(status & WDC_SR_PSUOVER))
-			printk(KERN_CRIT PFX "PSU over voltage.\n");
+			pr_crit("PSU over voltage\n");
 		if (!(status & WDC_SR_PSUUNDR))
-			printk(KERN_CRIT PFX "PSU under voltage.\n");
+			pr_crit("PSU under voltage\n");
 		if (tachometer) {
 			if (!(status & WDC_SR_FANGOOD))
-				printk(KERN_CRIT PFX "Possible fan fault.\n");
+				pr_crit("Possible fan fault\n");
 		}
 	}
 	if (!(status & WDC_SR_WCCR)) {
 #ifdef SOFTWARE_REBOOT
 #ifdef ONLY_TESTING
-		printk(KERN_CRIT PFX "Would Reboot.\n");
+		pr_crit("Would Reboot\n");
 #else
-		printk(KERN_CRIT PFX "Initiating system reboot.\n");
+		pr_crit("Initiating system reboot\n");
 		emergency_restart(NULL);
 #endif
 #else
-		printk(KERN_CRIT PFX "Reset in 5ms.\n");
+		pr_crit("Reset in 5ms\n");
 #endif
 	}
 	spin_unlock(&wdtpci_lock);
@@ -484,7 +483,7 @@ static int wdtpci_release(struct inode *inode, struct file *file)
 	if (expect_close == 42) {
 		wdtpci_stop();
 	} else {
-		printk(KERN_CRIT PFX "Unexpected close, not stopping timer!");
+		pr_crit("Unexpected close, not stopping timer!\n");
 		wdtpci_ping();
 	}
 	expect_close = 0;
@@ -614,29 +613,29 @@ static int __devinit wdtpci_init_one(struct pci_dev *dev,
 
 	dev_count++;
 	if (dev_count > 1) {
-		printk(KERN_ERR PFX "This driver only supports one device\n");
+		pr_err("This driver only supports one device\n");
 		return -ENODEV;
 	}
 
 	if (type != 500 && type != 501) {
-		printk(KERN_ERR PFX "unknown card type '%d'.\n", type);
+		pr_err("unknown card type '%d'\n", type);
 		return -ENODEV;
 	}
 
 	if (pci_enable_device(dev)) {
-		printk(KERN_ERR PFX "Not possible to enable PCI Device\n");
+		pr_err("Not possible to enable PCI Device\n");
 		return -ENODEV;
 	}
 
 	if (pci_resource_start(dev, 2) == 0x0000) {
-		printk(KERN_ERR PFX "No I/O-Address for card detected\n");
+		pr_err("No I/O-Address for card detected\n");
 		ret = -ENODEV;
 		goto out_pci;
 	}
 
 	if (pci_request_region(dev, 2, "wdt_pci")) {
-		printk(KERN_ERR PFX "I/O address 0x%llx already in use\n",
-			(unsigned long long)pci_resource_start(dev, 2));
+		pr_err("I/O address 0x%llx already in use\n",
+		       (unsigned long long)pci_resource_start(dev, 2));
 		goto out_pci;
 	}
 
@@ -645,53 +644,48 @@ static int __devinit wdtpci_init_one(struct pci_dev *dev,
 
 	if (request_irq(irq, wdtpci_interrupt, IRQF_SHARED,
 			 "wdt_pci", &wdtpci_miscdev)) {
-		printk(KERN_ERR PFX "IRQ %d is not free\n", irq);
+		pr_err("IRQ %d is not free\n", irq);
 		goto out_reg;
 	}
 
-	printk(KERN_INFO
-	 "PCI-WDT500/501 (PCI-WDG-CSM) driver 0.10 at 0x%llx (Interrupt %d)\n",
-					(unsigned long long)io, irq);
+	pr_info("PCI-WDT500/501 (PCI-WDG-CSM) driver 0.10 at 0x%llx (Interrupt %d)\n",
+		(unsigned long long)io, irq);
 
 	/* Check that the heartbeat value is within its range;
 	   if not reset to the default */
 	if (wdtpci_set_heartbeat(heartbeat)) {
 		wdtpci_set_heartbeat(WD_TIMO);
-		printk(KERN_INFO PFX
-		  "heartbeat value must be 0 < heartbeat < 65536, using %d\n",
-								WD_TIMO);
+		pr_info("heartbeat value must be 0 < heartbeat < 65536, using %d\n",
+			WD_TIMO);
 	}
 
 	ret = register_reboot_notifier(&wdtpci_notifier);
 	if (ret) {
-		printk(KERN_ERR PFX
-			"cannot register reboot notifier (err=%d)\n", ret);
+		pr_err("cannot register reboot notifier (err=%d)\n", ret);
 		goto out_irq;
 	}
 
 	if (type == 501) {
 		ret = misc_register(&temp_miscdev);
 		if (ret) {
-			printk(KERN_ERR PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-							TEMP_MINOR, ret);
+			pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+			       TEMP_MINOR, ret);
 			goto out_rbt;
 		}
 	}
 
 	ret = misc_register(&wdtpci_miscdev);
 	if (ret) {
-		printk(KERN_ERR PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-						WATCHDOG_MINOR, ret);
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
 		goto out_misc;
 	}
 
-	printk(KERN_INFO PFX "initialized. heartbeat=%d sec (nowayout=%d)\n",
+	pr_info("initialized. heartbeat=%d sec (nowayout=%d)\n",
 		heartbeat, nowayout);
 	if (type == 501)
-		printk(KERN_INFO "wdt: Fan Tachometer is %s\n",
-				(tachometer ? "Enabled" : "Disabled"));
+		pr_info("Fan Tachometer is %s\n",
+			tachometer ? "Enabled" : "Disabled");
 
 	ret = 0;
 out:
diff --git a/drivers/watchdog/wm8350_wdt.c b/drivers/watchdog/wm8350_wdt.c
index 5d7113c..f18499e 100644
--- a/drivers/watchdog/wm8350_wdt.c
+++ b/drivers/watchdog/wm8350_wdt.c
@@ -8,6 +8,8 @@
  * as published by the Free Software Foundation
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
diff --git a/drivers/watchdog/xen_wdt.c b/drivers/watchdog/xen_wdt.c
index 49bd9d3..79aa7f9 100644
--- a/drivers/watchdog/xen_wdt.c
+++ b/drivers/watchdog/xen_wdt.c
@@ -9,9 +9,10 @@
  *	2 of the License, or (at your option) any later version.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define DRV_NAME	"wdt"
 #define DRV_VERSION	"0.01"
-#define PFX		DRV_NAME ": "
 
 #include <linux/bug.h>
 #include <linux/errno.h>
@@ -134,8 +135,7 @@ static int xen_wdt_release(struct inode *inode, struct file *file)
 	if (expect_release)
 		xen_wdt_stop();
 	else {
-		printk(KERN_CRIT PFX
-		       "unexpected close, not stopping watchdog!\n");
+		pr_crit("unexpected close, not stopping watchdog!\n");
 		xen_wdt_kick();
 	}
 	is_active = false;
@@ -251,30 +251,27 @@ static int __devinit xen_wdt_probe(struct platform_device *dev)
 	case -EINVAL:
 		if (!timeout) {
 			timeout = WATCHDOG_TIMEOUT;
-			printk(KERN_INFO PFX
-			       "timeout value invalid, using %d\n", timeout);
+			pr_info("timeout value invalid, using %d\n", timeout);
 		}
 
 		ret = misc_register(&xen_wdt_miscdev);
 		if (ret) {
-			printk(KERN_ERR PFX
-			       "cannot register miscdev on minor=%d (%d)\n",
+			pr_err("cannot register miscdev on minor=%d (%d)\n",
 			       WATCHDOG_MINOR, ret);
 			break;
 		}
 
-		printk(KERN_INFO PFX
-		       "initialized (timeout=%ds, nowayout=%d)\n",
-		       timeout, nowayout);
+		pr_info("initialized (timeout=%ds, nowayout=%d)\n",
+			timeout, nowayout);
 		break;
 
 	case -ENOSYS:
-		printk(KERN_INFO PFX "not supported\n");
+		pr_info("not supported\n");
 		ret = -ENODEV;
 		break;
 
 	default:
-		printk(KERN_INFO PFX "bogus return value %d\n", ret);
+		pr_info("bogus return value %d\n", ret);
 		break;
 	}
 
@@ -326,7 +323,7 @@ static int __init xen_wdt_init_module(void)
 	if (!xen_domain())
 		return -ENODEV;
 
-	printk(KERN_INFO PFX "Xen WatchDog Timer Driver v%s\n", DRV_VERSION);
+	pr_info("Xen WatchDog Timer Driver v%s\n", DRV_VERSION);
 
 	err = platform_driver_register(&xen_wdt_driver);
 	if (err)
@@ -346,7 +343,7 @@ static void __exit xen_wdt_cleanup_module(void)
 {
 	platform_device_unregister(platform_device);
 	platform_driver_unregister(&xen_wdt_driver);
-	printk(KERN_INFO PFX "module unloaded\n");
+	pr_info("module unloaded\n");
 }
 
 module_init(xen_wdt_init_module);


