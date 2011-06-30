Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758397Ab1F3Hbn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 03:31:43 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:28449 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751403Ab1F3Hbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 03:31:38 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EACUmDE5tg3B1/2dsb2JhbABShEKjCniIeq5bkQEOgR2CB4FygQwEm2WGaw
Date: Thu, 30 Jun 2011 09:31:23 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Florian Fainelli <florian@openwrt.org>, Jesper Juhl <jj@chaosbits.net>,
        Axel Lin <axel.lin@gmail.com>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Subject: [GIT PULL REQUEST] watchdog - v3.0-rc5 - Fixes
Message-ID: <20110630073123.GM23305@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
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

 arch/x86/include/asm/apb_timer.h      |    2 +-
 drivers/watchdog/Kconfig              |    3 +--
 drivers/watchdog/at32ap700x_wdt.c     |    2 +-
 drivers/watchdog/gef_wdt.c            |    2 +-
 drivers/watchdog/intel_scu_watchdog.c |    1 -
 drivers/watchdog/mtx-1_wdt.c          |   29 ++++++++++++++++-------------
 drivers/watchdog/wm831x_wdt.c         |    5 +++++
 7 files changed, 25 insertions(+), 19 deletions(-)

with these Changes:

Author: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Date:   Tue Jun 28 17:01:14 2011 +0200

    watchdog: update author email for at32ap700x_wdt
    
    This patch updates the email address of the at32ap700x_wdt driver supported by
    me to an email account I will use on a more regular basis in the future.
    
    Signed-off-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Axel Lin <axel.lin@gmail.com>
Date:   Mon Jun 27 22:37:16 2011 +0800

    watchdog: gef_wdt: fix MODULE_ALIAS
    
    Remove the space between "platform:" prefix and the driver name.
    
    Signed-off-by: Axel Lin <axel.lin@gmail.com>
    Acked-by: Martyn Welch <martyn.welch@ge.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Jesper Juhl <jj@chaosbits.net>
Date:   Thu May 26 11:12:53 2011 +0200

    watchdog: Intel SCU Watchdog: Fix build and remove duplicate code
    
    Trying to build the Intel SCU Watchdog fails for me with gcc 4.6.0 -
    $ gcc --version | head -n 1
    gcc (GCC) 4.6.0 20110513 (prerelease)
    
    like this :
      CC      drivers/watchdog/intel_scu_watchdog.o
    In file included from drivers/watchdog/intel_scu_watchdog.c:49:0:
    /home/jj/src/linux-2.6/arch/x86/include/asm/apb_timer.h: In function ‘apbt_time_init’:
    /home/jj/src/linux-2.6/arch/x86/include/asm/apb_timer.h:65:42: warning: ‘return’ with a value, in function returning void [enabled by default]
    drivers/watchdog/intel_scu_watchdog.c: In function ‘intel_scu_watchdog_init’:
    drivers/watchdog/intel_scu_watchdog.c:468:2: error: implicit declaration of function ‘sfi_get_mtmr’ [-Werror=implicit-function-declaration]
    drivers/watchdog/intel_scu_watchdog.c:468:32: warning: assignment makes pointer from integer without a cast [enabled by default]
    cc1: some warnings being treated as errors
    
    make[1]: *** [drivers/watchdog/intel_scu_watchdog.o] Error 1
    make: *** [drivers/watchdog/intel_scu_watchdog.o] Error 2
    
    Additionally, linux/types.h is needlessly being included twice in
    drivers/watchdog/intel_scu_watchdog.c
    
    Signed-off-by: Jesper Juhl <jj@chaosbits.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Florian Fainelli <florian@openwrt.org>
Date:   Wed Jun 15 19:15:52 2011 +0200

    watchdog: mtx1-wdt: fix section mismatch
    
    Fix section mismatch and remove unused variable 'tmp'.
    
    Signed-off-by: Florian Fainelli <florian@openwrt.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Florian Fainelli <florian@openwrt.org>
Date:   Wed Jun 15 19:15:41 2011 +0200

    watchdog: mtx1-wdt: fix GPIO toggling
    
    Commit e391be76 (MIPS: Alchemy: Clean up GPIO registers and accessors)
    changed the way the GPIO was toggled. Prior to this patch, we would
    always actively drive the GPIO output to either 0 or 1, this patch
    drove the GPIO active to 0, and put the GPIO in tristate to drive it
    to 1, unfortunately this does not work, revert back to active driving.
    
    Using a signed variable (gstate) to hold the gpio state and using a bit-
    wise operation on it also resulted in toggling value from 1 to -2 since
    the variable is signed. This value was then passed on to gpio_direction_
    output, which always perform a if (value) ... to set the value to the
    gpio, so we were always writing a 1 to this GPIO instead of 1 -> 0 -> 1 ...
    
    Signed-off-by: Florian Fainelli <florian@openwrt.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: stable <stable@kernel.org>

Author: Florian Fainelli <florian@openwrt.org>
Date:   Wed Jun 15 19:15:23 2011 +0200

    watchdog: mtx1-wdt: request gpio before using it
    
    Otherwise, the gpiolib autorequest feature will produce a WARN_ON():
    
    WARNING: at drivers/gpio/gpiolib.c:101 0x8020ec6c()
    autorequest GPIO-215
    [...]
    
    Signed-off-by: Florian Fainelli <florian@openwrt.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: stable <stable@kernel.org>

Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
Date:   Tue May 31 14:46:55 2011 +0100

    watchdog: Handle multiple wm831x watchdogs being registered
    
    Due to the whole single instance based watchdog API we use static data
    for the wm831x watchdog which means that if the system tries to register
    a second one we end up trying to register the same miscdevice again,
    corrupting the miscdevice list. Work around this by checking for duplicate
    registrations until we get a watchdog core.
    
    Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/arch/x86/include/asm/apb_timer.h b/arch/x86/include/asm/apb_timer.h
index 2fefa50..af60d8a 100644
--- a/arch/x86/include/asm/apb_timer.h
+++ b/arch/x86/include/asm/apb_timer.h
@@ -62,7 +62,7 @@ extern int sfi_mtimer_num;
 #else /* CONFIG_APB_TIMER */
 
 static inline unsigned long apbt_quick_calibrate(void) {return 0; }
-static inline void apbt_time_init(void) {return 0; }
+static inline void apbt_time_init(void) { }
 
 #endif
 #endif /* ASM_X86_APBT_H */
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 022f9eb..9536d38 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -535,8 +535,7 @@ config I6300ESB_WDT
 
 config INTEL_SCU_WATCHDOG
 	bool "Intel SCU Watchdog for Mobile Platforms"
-	depends on WATCHDOG
-	depends on INTEL_SCU_IPC
+	depends on X86_MRST
 	---help---
 	  Hardware driver for the watchdog time built into the Intel SCU
 	  for Intel Mobile Platforms.
diff --git a/drivers/watchdog/at32ap700x_wdt.c b/drivers/watchdog/at32ap700x_wdt.c
index 750bc52..4ca5d40 100644
--- a/drivers/watchdog/at32ap700x_wdt.c
+++ b/drivers/watchdog/at32ap700x_wdt.c
@@ -448,7 +448,7 @@ static void __exit at32_wdt_exit(void)
 }
 module_exit(at32_wdt_exit);
 
-MODULE_AUTHOR("Hans-Christian Egtvedt <hcegtvedt@atmel.com>");
+MODULE_AUTHOR("Hans-Christian Egtvedt <egtvedt@samfundet.no>");
 MODULE_DESCRIPTION("Watchdog driver for Atmel AT32AP700X");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/watchdog/gef_wdt.c b/drivers/watchdog/gef_wdt.c
index 29a7cd4..b146082 100644
--- a/drivers/watchdog/gef_wdt.c
+++ b/drivers/watchdog/gef_wdt.c
@@ -329,4 +329,4 @@ MODULE_AUTHOR("Martyn Welch <martyn.welch@ge.com>");
 MODULE_DESCRIPTION("GE watchdog driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
-MODULE_ALIAS("platform: gef_wdt");
+MODULE_ALIAS("platform:gef_wdt");
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
diff --git a/drivers/watchdog/mtx-1_wdt.c b/drivers/watchdog/mtx-1_wdt.c
index 1479dc4..0430e09 100644
--- a/drivers/watchdog/mtx-1_wdt.c
+++ b/drivers/watchdog/mtx-1_wdt.c
@@ -66,23 +66,18 @@ static struct {
 	int default_ticks;
 	unsigned long inuse;
 	unsigned gpio;
-	int gstate;
+	unsigned int gstate;
 } mtx1_wdt_device;
 
 static void mtx1_wdt_trigger(unsigned long unused)
 {
-	u32 tmp;
-
 	spin_lock(&mtx1_wdt_device.lock);
 	if (mtx1_wdt_device.running)
 		ticks--;
 
 	/* toggle wdt gpio */
-	mtx1_wdt_device.gstate = ~mtx1_wdt_device.gstate;
-	if (mtx1_wdt_device.gstate)
-		gpio_direction_output(mtx1_wdt_device.gpio, 1);
-	else
-		gpio_direction_input(mtx1_wdt_device.gpio);
+	mtx1_wdt_device.gstate = !mtx1_wdt_device.gstate;
+	gpio_set_value(mtx1_wdt_device.gpio, mtx1_wdt_device.gstate);
 
 	if (mtx1_wdt_device.queue && ticks)
 		mod_timer(&mtx1_wdt_device.timer, jiffies + MTX1_WDT_INTERVAL);
@@ -105,7 +100,7 @@ static void mtx1_wdt_start(void)
 	if (!mtx1_wdt_device.queue) {
 		mtx1_wdt_device.queue = 1;
 		mtx1_wdt_device.gstate = 1;
-		gpio_direction_output(mtx1_wdt_device.gpio, 1);
+		gpio_set_value(mtx1_wdt_device.gpio, 1);
 		mod_timer(&mtx1_wdt_device.timer, jiffies + MTX1_WDT_INTERVAL);
 	}
 	mtx1_wdt_device.running++;
@@ -120,7 +115,7 @@ static int mtx1_wdt_stop(void)
 	if (mtx1_wdt_device.queue) {
 		mtx1_wdt_device.queue = 0;
 		mtx1_wdt_device.gstate = 0;
-		gpio_direction_output(mtx1_wdt_device.gpio, 0);
+		gpio_set_value(mtx1_wdt_device.gpio, 0);
 	}
 	ticks = mtx1_wdt_device.default_ticks;
 	spin_unlock_irqrestore(&mtx1_wdt_device.lock, flags);
@@ -214,6 +209,12 @@ static int __devinit mtx1_wdt_probe(struct platform_device *pdev)
 	int ret;
 
 	mtx1_wdt_device.gpio = pdev->resource[0].start;
+	ret = gpio_request_one(mtx1_wdt_device.gpio,
+				GPIOF_OUT_INIT_HIGH, "mtx1-wdt");
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to request gpio");
+		return ret;
+	}
 
 	spin_lock_init(&mtx1_wdt_device.lock);
 	init_completion(&mtx1_wdt_device.stop);
@@ -239,11 +240,13 @@ static int __devexit mtx1_wdt_remove(struct platform_device *pdev)
 		mtx1_wdt_device.queue = 0;
 		wait_for_completion(&mtx1_wdt_device.stop);
 	}
+
+	gpio_free(mtx1_wdt_device.gpio);
 	misc_deregister(&mtx1_wdt_misc);
 	return 0;
 }
 
-static struct platform_driver mtx1_wdt = {
+static struct platform_driver mtx1_wdt_driver = {
 	.probe = mtx1_wdt_probe,
 	.remove = __devexit_p(mtx1_wdt_remove),
 	.driver.name = "mtx1-wdt",
@@ -252,12 +255,12 @@ static struct platform_driver mtx1_wdt = {
 
 static int __init mtx1_wdt_init(void)
 {
-	return platform_driver_register(&mtx1_wdt);
+	return platform_driver_register(&mtx1_wdt_driver);
 }
 
 static void __exit mtx1_wdt_exit(void)
 {
-	platform_driver_unregister(&mtx1_wdt);
+	platform_driver_unregister(&mtx1_wdt_driver);
 }
 
 module_init(mtx1_wdt_init);
diff --git a/drivers/watchdog/wm831x_wdt.c b/drivers/watchdog/wm831x_wdt.c
index 8c4b2d5..871caea 100644
--- a/drivers/watchdog/wm831x_wdt.c
+++ b/drivers/watchdog/wm831x_wdt.c
@@ -320,6 +320,11 @@ static int __devinit wm831x_wdt_probe(struct platform_device *pdev)
 	struct wm831x_watchdog_pdata *pdata;
 	int reg, ret;
 
+	if (wm831x) {
+		dev_err(&pdev->dev, "wm831x watchdog already registered\n");
+		return -EBUSY;
+	}
+
 	wm831x = dev_get_drvdata(pdev->dev.parent);
 
 	ret = wm831x_reg_read(wm831x, WM831X_WATCHDOG);
