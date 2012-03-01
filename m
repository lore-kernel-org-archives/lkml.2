Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144Ab2CATmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 14:42:46 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:47530 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757088Ab2CATmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 14:42:43 -0500
X-Greylist: delayed 1952 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Mar 2012 14:42:42 EST
Date: Thu, 1 Mar 2012 20:10:06 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Dmitry Artamonow <mad_soft@inbox.ru>,
        Masanari Iida <standby24x7@gmail.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Maxim Uvarov <maxim.uvarov@oracle.com>, Mingarelli@spo001.leaseweb.com,
        Thomas <Thomas.Mingarelli@hp.com>
Subject: [GIT PULL REQUEST] watchdog - v3.3-rc5 Fixes
Message-ID: <20120301191006.GA28692@spo001.leaseweb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://www.linux-watchdog.org/linux-watchdog.git

This will update the following files:

 MAINTAINERS                    |    2 -
 drivers/watchdog/Kconfig       |    2 -
 drivers/watchdog/booke_wdt.c   |    6 +++-
 drivers/watchdog/hpwdt.c       |    5 ++-
 drivers/watchdog/pnx4008_wdt.c |    2 -
 drivers/watchdog/s3c2410_wdt.c |   57 ++++++++++++++++++++++-------------------
 6 files changed, 42 insertions(+), 32 deletions(-)

with these Changes:

commit 741b9c7da1abf2f96f69d232fbeef5aff1371be3
Author: Dmitry Artamonow <mad_soft@inbox.ru>
Date:   Thu Jan 26 23:24:30 2012 +0400

    watchdog: fix GETTIMEOUT ioctl in booke_wdt
    
    Commit dcfb748422 ([WATCHDOG] fix book E watchdog to take
    WDIOC_SETTIMEOUT arg in seconds) fixed SETTIMEOUT ioctl
    to use seconds as a parameter instead of some hardware-specific
    "period", but missed to apply similar changes to GETTIMEOUT,
    so it still returns "period" value. Let's fix it!
    Also, while at it, make SETTIMEOUT ioctl return real timeout
    value as it should do according to the documentation.
    
    Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit f599aaf00f6b5b35ea6af9e428eab8f894752efd
Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Tue Feb 28 17:11:05 2012 +0100

    watchdog: update maintainers git entry
    
    The git repository for watchdog device drivers moved.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 7ec0f040cf0b161a6068ad4797fff0bd63e83e4f
Author: Masanari Iida <standby24x7@gmail.com>
Date:   Sat Feb 11 00:40:56 2012 +0900

    watchdog: Fix typo in pnx4008_wdt.c
    
    Correct spelling "resouce" to "resource" in
    drivers/watchdog/pnx4008_wdt.c
    
    Signed-off-by: Masanari Iida <standby24x7@gmail.com>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit e1d1d68aae86c43d94e0c25ce27ea0050fceea01
Author: Masanari Iida <standby24x7@gmail.com>
Date:   Sat Feb 11 00:42:16 2012 +0900

    watchdog: Fix typo in Kconfig
    
    Correct spelling "overidden" to "overridden" in
    drivers/watchdog/Kconfig
    
    Signed-off-by: Masanari Iida <standby24x7@gmail.com>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 78d3e00bb0bcfb11596b14f5d5472922b4c7e429
Author: MyungJoo Ham <myungjoo.ham@samsung.com>
Date:   Fri Jan 13 14:14:23 2012 +0900

    watchdog: fix error in probe() of s3c2410_wdt (reset at booting)
    
    Probe function of s3c2410 watchdog calls request_irq before initializing
    required value (wdt_count). This incurs resetting watchdog counter value
    and watchdog-reboot during booting up.
    
    This patch addresses such an issue by calling request_irq later.
    
    Error handling in probe function and calling oder in remove function are
    also revised accordingly.
    
    Reported-by: Chanwoo Park <cw00.choi@samsung.com>
    Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
    Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 97d2a10d5804d585ab0b58efbd710948401b886a
Author: Maxim Uvarov <maxim.uvarov@oracle.com>
Date:   Sun Jan 15 20:02:50 2012 -0800

    watchdog: hpwdt: clean up set_memory_x call for 32 bit
    
    1. address has to be page aligned.
    2. set_memory_x uses page size argument, not size.
    Bug causes with following commit:
    	commit da28179b4e90dda56912ee825c7eaa62fc103797
    	Author: Mingarelli, Thomas <Thomas.Mingarelli@hp.com>
    	Date:   Mon Nov 7 10:59:00 2011 +0100
    
         watchdog: hpwdt: Changes to handle NX secure bit in 32bit path
    
        commit e67d668e147c3b4fec638c9e0ace04319f5ceccd upstream.
    
        This patch makes use of the set_memory_x() kernel API in order
        to make necessary BIOS calls to source NMIs.
    
    Signed-off-by: Maxim Uvarov <maxim.uvarov@oracle.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: stable <stable@vger.kernel.org>

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/MAINTAINERS b/MAINTAINERS
index 0a96e80..4e41d52 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7271,7 +7271,7 @@ WATCHDOG DEVICE DRIVERS
 M:	Wim Van Sebroeck <wim@iguana.be>
 L:	linux-watchdog@vger.kernel.org
 W:	http://www.linux-watchdog.org/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
+T:	git git://www.linux-watchdog.org/linux-watchdog.git
 S:	Maintained
 F:	Documentation/watchdog/
 F:	drivers/watchdog/
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 877b107..df9e8f0 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -1098,7 +1098,7 @@ config BOOKE_WDT_DEFAULT_TIMEOUT
 	  For Freescale Book-E processors, this is a number between 0 and 63.
 	  For other Book-E processors, this is a number between 0 and 3.
 
-	  The value can be overidden by the wdt_period command-line parameter.
+	  The value can be overridden by the wdt_period command-line parameter.
 
 # PPC64 Architecture
 
diff --git a/drivers/watchdog/booke_wdt.c b/drivers/watchdog/booke_wdt.c
index 337265b..7c0fdfc 100644
--- a/drivers/watchdog/booke_wdt.c
+++ b/drivers/watchdog/booke_wdt.c
@@ -198,9 +198,13 @@ static long booke_wdt_ioctl(struct file *file,
 		booke_wdt_period = tmp;
 #endif
 		booke_wdt_set();
-		return 0;
+		/* Fall */
 	case WDIOC_GETTIMEOUT:
+#ifdef	CONFIG_FSL_BOOKE
+		return put_user(period_to_sec(booke_wdt_period), p);
+#else
 		return put_user(booke_wdt_period, p);
+#endif
 	default:
 		return -ENOTTY;
 	}
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 8464ea1..3c166d3 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -231,7 +231,7 @@ static int __devinit cru_detect(unsigned long map_entry,
 
 	cmn_regs.u1.reax = CRU_BIOS_SIGNATURE_VALUE;
 
-	set_memory_x((unsigned long)bios32_entrypoint, (2 * PAGE_SIZE));
+	set_memory_x((unsigned long)bios32_map, 2);
 	asminline_call(&cmn_regs, bios32_entrypoint);
 
 	if (cmn_regs.u1.ral != 0) {
@@ -250,7 +250,8 @@ static int __devinit cru_detect(unsigned long map_entry,
 			cru_rom_addr =
 				ioremap(cru_physical_address, cru_length);
 			if (cru_rom_addr) {
-				set_memory_x((unsigned long)cru_rom_addr, cru_length);
+				set_memory_x((unsigned long)cru_rom_addr & PAGE_MASK,
+					(cru_length + PAGE_SIZE - 1) >> PAGE_SHIFT);
 				retval = 0;
 			}
 		}
diff --git a/drivers/watchdog/pnx4008_wdt.c b/drivers/watchdog/pnx4008_wdt.c
index 8e210aa..dfae030 100644
--- a/drivers/watchdog/pnx4008_wdt.c
+++ b/drivers/watchdog/pnx4008_wdt.c
@@ -264,7 +264,7 @@ static int __devinit pnx4008_wdt_probe(struct platform_device *pdev)
 	wdt_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (wdt_mem == NULL) {
 		printk(KERN_INFO MODULE_NAME
-			"failed to get memory region resouce\n");
+			"failed to get memory region resource\n");
 		return -ENOENT;
 	}
 
diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index 4bc3744..404172f 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -312,18 +312,26 @@ static int __devinit s3c2410wdt_probe(struct platform_device *pdev)
 	dev = &pdev->dev;
 	wdt_dev = &pdev->dev;
 
-	/* get the memory region for the watchdog timer */
-
 	wdt_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (wdt_mem == NULL) {
 		dev_err(dev, "no memory resource specified\n");
 		return -ENOENT;
 	}
 
+	wdt_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (wdt_irq == NULL) {
+		dev_err(dev, "no irq resource specified\n");
+		ret = -ENOENT;
+		goto err;
+	}
+
+	/* get the memory region for the watchdog timer */
+
 	size = resource_size(wdt_mem);
 	if (!request_mem_region(wdt_mem->start, size, pdev->name)) {
 		dev_err(dev, "failed to get memory region\n");
-		return -EBUSY;
+		ret = -EBUSY;
+		goto err;
 	}
 
 	wdt_base = ioremap(wdt_mem->start, size);
@@ -335,29 +343,17 @@ static int __devinit s3c2410wdt_probe(struct platform_device *pdev)
 
 	DBG("probe: mapped wdt_base=%p\n", wdt_base);
 
-	wdt_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	if (wdt_irq == NULL) {
-		dev_err(dev, "no irq resource specified\n");
-		ret = -ENOENT;
-		goto err_map;
-	}
-
-	ret = request_irq(wdt_irq->start, s3c2410wdt_irq, 0, pdev->name, pdev);
-	if (ret != 0) {
-		dev_err(dev, "failed to install irq (%d)\n", ret);
-		goto err_map;
-	}
-
 	wdt_clock = clk_get(&pdev->dev, "watchdog");
 	if (IS_ERR(wdt_clock)) {
 		dev_err(dev, "failed to find watchdog clock source\n");
 		ret = PTR_ERR(wdt_clock);
-		goto err_irq;
+		goto err_map;
 	}
 
 	clk_enable(wdt_clock);
 
-	if (s3c2410wdt_cpufreq_register() < 0) {
+	ret = s3c2410wdt_cpufreq_register();
+	if (ret < 0) {
 		printk(KERN_ERR PFX "failed to register cpufreq\n");
 		goto err_clk;
 	}
@@ -378,12 +374,18 @@ static int __devinit s3c2410wdt_probe(struct platform_device *pdev)
 							"cannot start\n");
 	}
 
+	ret = request_irq(wdt_irq->start, s3c2410wdt_irq, 0, pdev->name, pdev);
+	if (ret != 0) {
+		dev_err(dev, "failed to install irq (%d)\n", ret);
+		goto err_cpufreq;
+	}
+
 	watchdog_set_nowayout(&s3c2410_wdd, nowayout);
 
 	ret = watchdog_register_device(&s3c2410_wdd);
 	if (ret) {
 		dev_err(dev, "cannot register watchdog (%d)\n", ret);
-		goto err_cpufreq;
+		goto err_irq;
 	}
 
 	if (tmr_atboot && started == 0) {
@@ -408,23 +410,26 @@ static int __devinit s3c2410wdt_probe(struct platform_device *pdev)
 
 	return 0;
 
+ err_irq:
+	free_irq(wdt_irq->start, pdev);
+
  err_cpufreq:
 	s3c2410wdt_cpufreq_deregister();
 
  err_clk:
 	clk_disable(wdt_clock);
 	clk_put(wdt_clock);
-
- err_irq:
-	free_irq(wdt_irq->start, pdev);
+	wdt_clock = NULL;
 
  err_map:
 	iounmap(wdt_base);
 
  err_req:
 	release_mem_region(wdt_mem->start, size);
-	wdt_mem = NULL;
 
+ err:
+	wdt_irq = NULL;
+	wdt_mem = NULL;
 	return ret;
 }
 
@@ -432,18 +437,18 @@ static int __devexit s3c2410wdt_remove(struct platform_device *dev)
 {
 	watchdog_unregister_device(&s3c2410_wdd);
 
+	free_irq(wdt_irq->start, dev);
+
 	s3c2410wdt_cpufreq_deregister();
 
 	clk_disable(wdt_clock);
 	clk_put(wdt_clock);
 	wdt_clock = NULL;
 
-	free_irq(wdt_irq->start, dev);
-	wdt_irq = NULL;
-
 	iounmap(wdt_base);
 
 	release_mem_region(wdt_mem->start, resource_size(wdt_mem));
+	wdt_irq = NULL;
 	wdt_mem = NULL;
 	return 0;
 }
