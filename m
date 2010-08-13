Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab0HMU7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 16:59:20 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:21134 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751462Ab0HMU7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 16:59:19 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAGpPZUxQyOsb/2dsb2JhbACgOnK/eQ2CZIJJBA
Date: Fri, 13 Aug 2010 22:59:01 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing list <linux-watchdog@vger.kertnel.org>,
        dann frazier <dannf@hp.com>,
        Thomas Mingarelli <Thomas.Mingarelli@hp.com>
Subject: [GIT PULL REQUEST] watchdog - v2.6.36-rc1 - part 2
Message-ID: <20100813205901.GO4288@infomag.iguana.be>
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

 drivers/watchdog/Kconfig |   19 +-
 drivers/watchdog/hpwdt.c |  306 ++++++++++++++++++++++++++---------------------
 2 files changed, 186 insertions(+), 139 deletions(-)

with these Changes:

Author: dann frazier <dannf@hp.com>
Date:   Tue Jul 27 17:51:02 2010 -0600

    watchdog: hpwdt (12/12): Make NMI decoding a compile-time option
    
    hpwdt is quite functional without the NMI decoding feature.
    This change lets users disable the NMI portion at compile-time
    via the new HPWDT_NMI_DECODING config option.
    
    Signed-off-by: dann frazier <dannf@hp.com>
    Acked-by: Thomas Mingarelli <Thomas.Mingarelli@hp.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: dann frazier <dannf@hp.com>
Date:   Wed Jul 28 12:38:43 2010 -0600

    watchdog: hpwdt (11/12): move NMI-decoding init and exit to seperate functions
    
    Move NMI-decoding initialisation and exit code to seperate functions so that
    we can ifdef-out parts of it in the future.
    
    Also, this is for a device, so let's use dev_info instead of printk.
    
    Signed-off-by: dann frazier <dannf@hp.com>
    Acked-by: Thomas Mingarelli <Thomas.Mingarelli@hp.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: dann frazier <dannf@hp.com>
Date:   Tue Jul 27 17:51:01 2010 -0600

    watchdog: hpwdt (10/12): Use "decoding" instead of "sourcing"
    
    The term "decoding" more clearly explains what hpwdt is doing. It isn't
    just finding the source of the interrupt, but rather aids in decoding what
    the interrupt means.
    
    Signed-off-by: dann frazier <dannf@hp.com>
    Acked-by: Thomas Mingarelli <Thomas.Mingarelli@hp.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: dann frazier <dannf@hp.com>
Date:   Tue Jul 27 17:50:49 2010 -0600

    watchdog: hpwdt (9/12): hpwdt_pretimeout reorganization
    
    Reorganize this function to remove excess indentation and highlight
    the single return code. (No functional change).
    
    Signed-off-by: dann frazier <dannf@hp.com>
    Acked-by: Thomas Mingarelli <Thomas.Mingarelli@hp.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: dann frazier <dannf@hp.com>
Date:   Wed Jun 2 16:23:41 2010 -0600

    watchdog: hpwdt (8/12): implement WDIOC_GETTIMELEFT
    
    Let applications check the amount of time left before the watchdog will fire.
    
    Signed-off-by: dann frazier <dannf@hp.com>
    Acked-by: Thomas Mingarelli <Thomas.Mingarelli@hp.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: dann frazier <dannf@hp.com>
Date:   Wed Jun 2 16:23:40 2010 -0600

    watchdog: hpwdt (7/12): allow full range of timer values supported by hardware
    
    The hpwdt timer is a 16 bit value with 128ms resolution.
    Let applications use this entire range.
    
    Signed-off-by: dann frazier <dannf@hp.com>
    Acked-by: Thomas Mingarelli <Thomas.Mingarelli@hp.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: dann frazier <dannf@hp.com>
Date:   Wed Jun 2 16:23:39 2010 -0600

    watchdog: hpwdt (6/12): Introduce SECS_TO_TICKS() macro
    
    Define a macro to convert from seconds to timer ticks.
    
    Signed-off-by: dann frazier <dannf@hp.com>
    Acked-by: Thomas Mingarelli <Thomas.Mingarelli@hp.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: dann frazier <dannf@hp.com>
Date:   Tue Jul 27 17:50:59 2010 -0600

    watchdog: hpwdt (5/12): Make x86 assembly ifdef guard more strict
    
    The 32-bit assembly is guarded by an #ifndef CONFIG_X86_64. Kconfig prevents
    us from building this driver on !X86, so that happens to suffice - but we
    should really lock it down to #ifdef CONFIG_X86_32.
    
    Signed-off-by: dann frazier <dannf@hp.com>
    Acked-by: Thomas Mingarelli <Thomas.Mingarelli@hp.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: dann frazier <dannf@hp.com>
Date:   Tue Jul 27 17:50:57 2010 -0600

    watchdog: hpwdt (4/12): Despecificate driver from iLO2
    
    This driver supports both iLO2 and iLO3, but our user-visible strings
    currently only reference iLO2. Let's just call it "iLO2+" to avoid having
    to update strings for each iLO generation. This driver doesn't support
    iLO ASICs prior to iLO2, but that is sufficiently explained in Kconfig.
    
    Signed-off-by: dann frazier <dannf@hp.com>
    Acked-by: Thomas Mingarelli <Thomas.Mingarelli@hp.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: dann frazier <dannf@hp.com>
Date:   Tue Jul 27 17:50:54 2010 -0600

    watchdog: hpwdt (3/12): Group NMI sourcing specific items together
    
    * Group together includes specific to NMI sourcing
    * Group defines only used by NMI sourcing together
    * Group declarations specific to NMI sourcing together
    
    This gives a clean seperation of watchdog specific items and
    NMI sourcing specific items (which is needed for making it
    possible to build hpwdt without the NMI functionality).
    
    Signed-off-by: dann frazier <dannf@hp.com>
    Acked-by: Thomas Mingarelli <Thomas.Mingarelli@hp.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: dann frazier <dannf@hp.com>
Date:   Tue Jul 27 17:50:54 2010 -0600

    watchdog: hpwdt (2/12): Group options that affect watchdog behavior together
    
    Reorganization only.
    
    Signed-off-by: dann frazier <dannf@hp.com>
    Acked-by: Thomas Mingarelli <Thomas.Mingarelli@hp.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: dann frazier <dannf@hp.com>
Date:   Tue Jul 27 17:50:50 2010 -0600

    watchdog: hpwdt (1/12): clean-up include-files.
    
    * remove unnecessary includes
    * We use a spinlock, but lacked the include
    * We need bitops.h for test_and_set_bit/clear_bit
    
    Signed-off-by: dann frazier <dannf@hp.com>
    Acked-by: Thomas Mingarelli <Thomas.Mingarelli@hp.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 4d2992a..b036677 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -574,16 +574,21 @@ config IT87_WDT
 	  be called it87_wdt.
 
 config HP_WATCHDOG
-	tristate "HP Proliant iLO 2 Hardware Watchdog Timer"
+	tristate "HP Proliant iLO2+ Hardware Watchdog Timer"
 	depends on X86
 	help
 	  A software monitoring watchdog and NMI sourcing driver. This driver
-	  will detect lockups and provide stack trace. Also, when an NMI
-	  occurs this driver will make the necessary BIOS calls to log
-	  the cause of the NMI. This is a driver that will only load on a
-	  HP ProLiant system with a minimum of iLO2 support.
-	  To compile this driver as a module, choose M here: the
-	  module will be called hpwdt.
+	  will detect lockups and provide a stack trace. This is a driver that
+	  will only load on a HP ProLiant system with a minimum of iLO2 support.
+	  To compile this driver as a module, choose M here: the module will be
+	  called hpwdt.
+
+config HPWDT_NMI_DECODING
+	bool "NMI decoding support for the HP ProLiant iLO2+ Hardware Watchdog Timer"
+	depends on HP_WATCHDOG
+	help
+	  When an NMI occurs this feature will make the necessary BIOS calls to
+	  log the cause of the NMI.
 
 config SC1200_WDT
 	tristate "National Semiconductor PC87307/PC97307 (ala SC1200) Watchdog"
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index fd312fc..3d77116 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -16,38 +16,55 @@
 #include <linux/device.h>
 #include <linux/fs.h>
 #include <linux/init.h>
-#include <linux/interrupt.h>
 #include <linux/io.h>
-#include <linux/irq.h>
-#include <linux/nmi.h>
+#include <linux/bitops.h>
 #include <linux/kernel.h>
 #include <linux/miscdevice.h>
-#include <linux/mm.h>
 #include <linux/module.h>
-#include <linux/kdebug.h>
 #include <linux/moduleparam.h>
-#include <linux/notifier.h>
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
-#include <linux/reboot.h>
-#include <linux/sched.h>
-#include <linux/timer.h>
 #include <linux/types.h>
 #include <linux/uaccess.h>
 #include <linux/watchdog.h>
+#ifdef CONFIG_HPWDT_NMI_DECODING
 #include <linux/dmi.h>
-#include <linux/efi.h>
-#include <linux/string.h>
-#include <linux/bootmem.h>
-#include <asm/desc.h>
+#include <linux/spinlock.h>
+#include <linux/nmi.h>
+#include <linux/kdebug.h>
+#include <linux/notifier.h>
 #include <asm/cacheflush.h>
+#endif /* CONFIG_HPWDT_NMI_DECODING */
+
+#define HPWDT_VERSION			"1.2.0"
+#define SECS_TO_TICKS(secs)		((secs) * 1000 / 128)
+#define TICKS_TO_SECS(ticks)		((ticks) * 128 / 1000)
+#define HPWDT_MAX_TIMER			TICKS_TO_SECS(65535)
+#define DEFAULT_MARGIN			30
+
+static unsigned int soft_margin = DEFAULT_MARGIN;	/* in seconds */
+static unsigned int reload;			/* the computed soft_margin */
+static int nowayout = WATCHDOG_NOWAYOUT;
+static char expect_release;
+static unsigned long hpwdt_is_open;
+
+static void __iomem *pci_mem_addr;		/* the PCI-memory address */
+static unsigned long __iomem *hpwdt_timer_reg;
+static unsigned long __iomem *hpwdt_timer_con;
 
+static struct pci_device_id hpwdt_devices[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPAQ, 0xB203) },	/* iLO2 */
+	{ PCI_DEVICE(PCI_VENDOR_ID_HP, 0x3306) },	/* iLO3 */
+	{0},			/* terminate list */
+};
+MODULE_DEVICE_TABLE(pci, hpwdt_devices);
+
+#ifdef CONFIG_HPWDT_NMI_DECODING
 #define PCI_BIOS32_SD_VALUE		0x5F32335F	/* "_32_" */
 #define CRU_BIOS_SIGNATURE_VALUE	0x55524324
 #define PCI_BIOS32_PARAGRAPH_LEN	16
 #define PCI_ROM_BASE1			0x000F0000
 #define ROM_SIZE			0x10000
-#define HPWDT_VERSION			"1.1.1"
 
 struct bios32_service_dir {
 	u32 signature;
@@ -112,37 +129,17 @@ struct cmn_registers {
 	u32 reflags;
 }  __attribute__((packed));
 
-#define DEFAULT_MARGIN	30
-static unsigned int soft_margin = DEFAULT_MARGIN;	/* in seconds */
-static unsigned int reload;			/* the computed soft_margin */
-static int nowayout = WATCHDOG_NOWAYOUT;
-static char expect_release;
-static unsigned long hpwdt_is_open;
+static unsigned int hpwdt_nmi_decoding;
 static unsigned int allow_kdump;
-static unsigned int hpwdt_nmi_sourcing;
 static unsigned int priority;		/* hpwdt at end of die_notify list */
-
-static void __iomem *pci_mem_addr;		/* the PCI-memory address */
-static unsigned long __iomem *hpwdt_timer_reg;
-static unsigned long __iomem *hpwdt_timer_con;
-
 static DEFINE_SPINLOCK(rom_lock);
-
 static void *cru_rom_addr;
-
 static struct cmn_registers cmn_regs;
 
-static struct pci_device_id hpwdt_devices[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_COMPAQ, 0xB203) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_HP, 0x3306) },
-	{0},			/* terminate list */
-};
-MODULE_DEVICE_TABLE(pci, hpwdt_devices);
-
 extern asmlinkage void asminline_call(struct cmn_registers *pi86Regs,
 						unsigned long *pRomEntry);
 
-#ifndef CONFIG_X86_64
+#ifdef CONFIG_X86_32
 /* --32 Bit Bios------------------------------------------------------------ */
 
 #define HPWDT_ARCH	32
@@ -331,8 +328,9 @@ static int __devinit detect_cru_service(void)
 	iounmap(p);
 	return rc;
 }
-
-#else
+/* ------------------------------------------------------------------------- */
+#endif /* CONFIG_X86_32 */
+#ifdef CONFIG_X86_64
 /* --64 Bit Bios------------------------------------------------------------ */
 
 #define HPWDT_ARCH	64
@@ -410,17 +408,16 @@ static int __devinit detect_cru_service(void)
 	/* if cru_rom_addr has been set then we found a CRU service */
 	return ((cru_rom_addr != NULL) ? 0 : -ENODEV);
 }
-
 /* ------------------------------------------------------------------------- */
-
-#endif
+#endif /* CONFIG_X86_64 */
+#endif /* CONFIG_HPWDT_NMI_DECODING */
 
 /*
  *	Watchdog operations
  */
 static void hpwdt_start(void)
 {
-	reload = (soft_margin * 1000) / 128;
+	reload = SECS_TO_TICKS(soft_margin);
 	iowrite16(reload, hpwdt_timer_reg);
 	iowrite16(0x85, hpwdt_timer_con);
 }
@@ -441,8 +438,7 @@ static void hpwdt_ping(void)
 
 static int hpwdt_change_timer(int new_margin)
 {
-	/* Arbitrary, can't find the card's limits */
-	if (new_margin < 5 || new_margin > 600) {
+	if (new_margin < 1 || new_margin > HPWDT_MAX_TIMER) {
 		printk(KERN_WARNING
 			"hpwdt: New value passed in is invalid: %d seconds.\n",
 			new_margin);
@@ -453,11 +449,17 @@ static int hpwdt_change_timer(int new_margin)
 	printk(KERN_DEBUG
 		"hpwdt: New timer passed in is %d seconds.\n",
 		new_margin);
-	reload = (soft_margin * 1000) / 128;
+	reload = SECS_TO_TICKS(soft_margin);
 
 	return 0;
 }
 
+static int hpwdt_time_left(void)
+{
+	return TICKS_TO_SECS(ioread16(hpwdt_timer_reg));
+}
+
+#ifdef CONFIG_HPWDT_NMI_DECODING
 /*
  *	NMI Handler
  */
@@ -468,26 +470,29 @@ static int hpwdt_pretimeout(struct notifier_block *nb, unsigned long ulReason,
 	static int die_nmi_called;
 
 	if (ulReason != DIE_NMI && ulReason != DIE_NMI_IPI)
-		return NOTIFY_OK;
-
-	if (hpwdt_nmi_sourcing) {
-		spin_lock_irqsave(&rom_lock, rom_pl);
-		if (!die_nmi_called)
-			asminline_call(&cmn_regs, cru_rom_addr);
-		die_nmi_called = 1;
-		spin_unlock_irqrestore(&rom_lock, rom_pl);
-		if (cmn_regs.u1.ral == 0) {
-			printk(KERN_WARNING "hpwdt: An NMI occurred, "
-				"but unable to determine source.\n");
-		} else {
-			if (allow_kdump)
-				hpwdt_stop();
-			panic("An NMI occurred, please see the Integrated "
-				"Management Log for details.\n");
-		}
+		goto out;
+
+	if (!hpwdt_nmi_decoding)
+		goto out;
+
+	spin_lock_irqsave(&rom_lock, rom_pl);
+	if (!die_nmi_called)
+		asminline_call(&cmn_regs, cru_rom_addr);
+	die_nmi_called = 1;
+	spin_unlock_irqrestore(&rom_lock, rom_pl);
+	if (cmn_regs.u1.ral == 0) {
+		printk(KERN_WARNING "hpwdt: An NMI occurred, "
+			"but unable to determine source.\n");
+	} else {
+		if (allow_kdump)
+			hpwdt_stop();
+		panic("An NMI occurred, please see the Integrated "
+			"Management Log for details.\n");
 	}
+out:
 	return NOTIFY_OK;
 }
+#endif /* CONFIG_HPWDT_NMI_DECODING */
 
 /*
  *	/dev/watchdog handling
@@ -557,7 +562,7 @@ static const struct watchdog_info ident = {
 	.options = WDIOF_SETTIMEOUT |
 		   WDIOF_KEEPALIVEPING |
 		   WDIOF_MAGICCLOSE,
-	.identity = "HP iLO2 HW Watchdog Timer",
+	.identity = "HP iLO2+ HW Watchdog Timer",
 };
 
 static long hpwdt_ioctl(struct file *file, unsigned int cmd,
@@ -599,6 +604,10 @@ static long hpwdt_ioctl(struct file *file, unsigned int cmd,
 	case WDIOC_GETTIMEOUT:
 		ret = put_user(soft_margin, p);
 		break;
+
+	case WDIOC_GETTIMELEFT:
+		ret = put_user(hpwdt_time_left(), p);
+		break;
 	}
 	return ret;
 }
@@ -621,80 +630,45 @@ static struct miscdevice hpwdt_miscdev = {
 	.fops = &hpwdt_fops,
 };
 
+#ifdef CONFIG_HPWDT_NMI_DECODING
 static struct notifier_block die_notifier = {
 	.notifier_call = hpwdt_pretimeout,
 	.priority = 0,
 };
+#endif /* CONFIG_HPWDT_NMI_DECODING */
 
 /*
  *	Init & Exit
  */
 
+#ifdef CONFIG_HPWDT_NMI_DECODING
 #ifdef ARCH_HAS_NMI_WATCHDOG
-static void __devinit hpwdt_check_nmi_sourcing(struct pci_dev *dev)
+static void __devinit hpwdt_check_nmi_decoding(struct pci_dev *dev)
 {
 	/*
 	 * If nmi_watchdog is turned off then we can turn on
-	 * our nmi sourcing capability.
+	 * our nmi decoding capability.
 	 */
 	if (!nmi_watchdog_active())
-		hpwdt_nmi_sourcing = 1;
+		hpwdt_nmi_decoding = 1;
 	else
-		dev_warn(&dev->dev, "NMI sourcing is disabled. To enable this "
+		dev_warn(&dev->dev, "NMI decoding is disabled. To enable this "
 			"functionality you must reboot with nmi_watchdog=0 "
 			"and load the hpwdt driver with priority=1.\n");
 }
 #else
-static void __devinit hpwdt_check_nmi_sourcing(struct pci_dev *dev)
+static void __devinit hpwdt_check_nmi_decoding(struct pci_dev *dev)
 {
-	dev_warn(&dev->dev, "NMI sourcing is disabled. "
+	dev_warn(&dev->dev, "NMI decoding is disabled. "
 		"Your kernel does not support a NMI Watchdog.\n");
 }
-#endif
+#endif /* ARCH_HAS_NMI_WATCHDOG */
 
-static int __devinit hpwdt_init_one(struct pci_dev *dev,
-					const struct pci_device_id *ent)
+static int __devinit hpwdt_init_nmi_decoding(struct pci_dev *dev)
 {
 	int retval;
 
 	/*
-	 * Check if we can do NMI sourcing or not
-	 */
-	hpwdt_check_nmi_sourcing(dev);
-
-	/*
-	 * First let's find out if we are on an iLO2 server. We will
-	 * not run on a legacy ASM box.
-	 * So we only support the G5 ProLiant servers and higher.
-	 */
-	if (dev->subsystem_vendor != PCI_VENDOR_ID_HP) {
-		dev_warn(&dev->dev,
-			"This server does not have an iLO2 ASIC.\n");
-		return -ENODEV;
-	}
-
-	if (pci_enable_device(dev)) {
-		dev_warn(&dev->dev,
-			"Not possible to enable PCI Device: 0x%x:0x%x.\n",
-			ent->vendor, ent->device);
-		return -ENODEV;
-	}
-
-	pci_mem_addr = pci_iomap(dev, 1, 0x80);
-	if (!pci_mem_addr) {
-		dev_warn(&dev->dev,
-			"Unable to detect the iLO2 server memory.\n");
-		retval = -ENOMEM;
-		goto error_pci_iomap;
-	}
-	hpwdt_timer_reg = pci_mem_addr + 0x70;
-	hpwdt_timer_con = pci_mem_addr + 0x72;
-
-	/* Make sure that we have a valid soft_margin */
-	if (hpwdt_change_timer(soft_margin))
-		hpwdt_change_timer(DEFAULT_MARGIN);
-
-	/*
 	 * We need to map the ROM to get the CRU service.
 	 * For 32 bit Operating Systems we need to go through the 32 Bit
 	 * BIOS Service Directory
@@ -705,7 +679,7 @@ static int __devinit hpwdt_init_one(struct pci_dev *dev,
 		dev_warn(&dev->dev,
 			"Unable to detect the %d Bit CRU Service.\n",
 			HPWDT_ARCH);
-		goto error_get_cru;
+		return retval;
 	}
 
 	/*
@@ -728,9 +702,87 @@ static int __devinit hpwdt_init_one(struct pci_dev *dev,
 		dev_warn(&dev->dev,
 			"Unable to register a die notifier (err=%d).\n",
 			retval);
-		goto error_die_notifier;
+		if (cru_rom_addr)
+			iounmap(cru_rom_addr);
 	}
 
+	dev_info(&dev->dev,
+			"HP Watchdog Timer Driver: NMI decoding initialized"
+			", allow kernel dump: %s (default = 0/OFF)"
+			", priority: %s (default = 0/LAST).\n",
+			(allow_kdump == 0) ? "OFF" : "ON",
+			(priority == 0) ? "LAST" : "FIRST");
+	return 0;
+}
+
+static void __devexit hpwdt_exit_nmi_decoding(void)
+{
+	unregister_die_notifier(&die_notifier);
+	if (cru_rom_addr)
+		iounmap(cru_rom_addr);
+}
+#else /* !CONFIG_HPWDT_NMI_DECODING */
+static void __devinit hpwdt_check_nmi_decoding(struct pci_dev *dev)
+{
+}
+
+static int __devinit hpwdt_init_nmi_decoding(struct pci_dev *dev)
+{
+	return 0;
+}
+
+static void __devexit hpwdt_exit_nmi_decoding(void)
+{
+}
+#endif /* CONFIG_HPWDT_NMI_DECODING */
+
+static int __devinit hpwdt_init_one(struct pci_dev *dev,
+					const struct pci_device_id *ent)
+{
+	int retval;
+
+	/*
+	 * Check if we can do NMI decoding or not
+	 */
+	hpwdt_check_nmi_decoding(dev);
+
+	/*
+	 * First let's find out if we are on an iLO2+ server. We will
+	 * not run on a legacy ASM box.
+	 * So we only support the G5 ProLiant servers and higher.
+	 */
+	if (dev->subsystem_vendor != PCI_VENDOR_ID_HP) {
+		dev_warn(&dev->dev,
+			"This server does not have an iLO2+ ASIC.\n");
+		return -ENODEV;
+	}
+
+	if (pci_enable_device(dev)) {
+		dev_warn(&dev->dev,
+			"Not possible to enable PCI Device: 0x%x:0x%x.\n",
+			ent->vendor, ent->device);
+		return -ENODEV;
+	}
+
+	pci_mem_addr = pci_iomap(dev, 1, 0x80);
+	if (!pci_mem_addr) {
+		dev_warn(&dev->dev,
+			"Unable to detect the iLO2+ server memory.\n");
+		retval = -ENOMEM;
+		goto error_pci_iomap;
+	}
+	hpwdt_timer_reg = pci_mem_addr + 0x70;
+	hpwdt_timer_con = pci_mem_addr + 0x72;
+
+	/* Make sure that we have a valid soft_margin */
+	if (hpwdt_change_timer(soft_margin))
+		hpwdt_change_timer(DEFAULT_MARGIN);
+
+	/* Initialize NMI Decoding functionality */
+	retval = hpwdt_init_nmi_decoding(dev);
+	if (retval != 0)
+		goto error_init_nmi_decoding;
+
 	retval = misc_register(&hpwdt_miscdev);
 	if (retval < 0) {
 		dev_warn(&dev->dev,
@@ -739,23 +791,14 @@ static int __devinit hpwdt_init_one(struct pci_dev *dev,
 		goto error_misc_register;
 	}
 
-	printk(KERN_INFO
-		"hp Watchdog Timer Driver: %s"
-		", timer margin: %d seconds (nowayout=%d)"
-		", allow kernel dump: %s (default = 0/OFF)"
-		", priority: %s (default = 0/LAST).\n",
-		HPWDT_VERSION, soft_margin, nowayout,
-		(allow_kdump == 0) ? "OFF" : "ON",
-		(priority == 0) ? "LAST" : "FIRST");
-
+	dev_info(&dev->dev, "HP Watchdog Timer Driver: %s"
+			", timer margin: %d seconds (nowayout=%d).\n",
+			HPWDT_VERSION, soft_margin, nowayout);
 	return 0;
 
 error_misc_register:
-	unregister_die_notifier(&die_notifier);
-error_die_notifier:
-	if (cru_rom_addr)
-		iounmap(cru_rom_addr);
-error_get_cru:
+	hpwdt_exit_nmi_decoding();
+error_init_nmi_decoding:
 	pci_iounmap(dev, pci_mem_addr);
 error_pci_iomap:
 	pci_disable_device(dev);
@@ -768,10 +811,7 @@ static void __devexit hpwdt_exit(struct pci_dev *dev)
 		hpwdt_stop();
 
 	misc_deregister(&hpwdt_miscdev);
-	unregister_die_notifier(&die_notifier);
-
-	if (cru_rom_addr)
-		iounmap(cru_rom_addr);
+	hpwdt_exit_nmi_decoding();
 	pci_iounmap(dev, pci_mem_addr);
 	pci_disable_device(dev);
 }
@@ -802,16 +842,18 @@ MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 module_param(soft_margin, int, 0);
 MODULE_PARM_DESC(soft_margin, "Watchdog timeout in seconds");
 
-module_param(allow_kdump, int, 0);
-MODULE_PARM_DESC(allow_kdump, "Start a kernel dump after NMI occurs");
-
 module_param(nowayout, int, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
 		__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
+#ifdef CONFIG_HPWDT_NMI_DECODING
+module_param(allow_kdump, int, 0);
+MODULE_PARM_DESC(allow_kdump, "Start a kernel dump after NMI occurs");
+
 module_param(priority, int, 0);
 MODULE_PARM_DESC(priority, "The hpwdt driver handles NMIs first or last"
 		" (default = 0/Last)\n");
+#endif /* !CONFIG_HPWDT_NMI_DECODING */
 
 module_init(hpwdt_init);
 module_exit(hpwdt_cleanup);
