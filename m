Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab1EUMVj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 08:21:39 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:48643 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752086Ab1EUMVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 08:21:37 -0400
Date: Sat, 21 May 2011 14:21:35 +0200
From: Pavel Machek <pavel@ucw.cz>
To: rpurdie@rpsys.net, lenz@cs.wisc.edu,
        kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
        Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org,
        Marek Vasut <marek.vasut@gmail.com>
Subject: spitz pm: move definitions to header file
Message-ID: <20110521122135.GA6915@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will allow me to use the definitions from spitz_battery.c module.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/arch/arm/mach-pxa/include/mach/sharpsl_pm.h b/arch/arm/mach-pxa/include/mach/sharpsl_pm.h
index 905be67..7407717 100644
--- a/arch/arm/mach-pxa/include/mach/sharpsl_pm.h
+++ b/arch/arm/mach-pxa/include/mach/sharpsl_pm.h
@@ -110,4 +110,22 @@ void sharpsl_pm_led(int val);
 int sharpsl_pm_pxa_read_max1111(int channel);
 
 void corgi_lcd_limit_intensity(int limit);
+
+/*
+ * Constants
+ */
+#define SHARPSL_CHARGE_ON_TIME_INTERVAL        (msecs_to_jiffies(1*60*1000))  /* 1 min */
+#define SHARPSL_CHARGE_FINISH_TIME             (msecs_to_jiffies(10*60*1000)) /* 10 min */
+#define SHARPSL_BATCHK_TIME                    (msecs_to_jiffies(15*1000))    /* 15 sec */
+#define SHARPSL_BATCHK_TIME_SUSPEND            (60*10)                        /* 10 min */
+
+#define SHARPSL_WAIT_CO_TIME                   15  /* 15 sec */
+#define SHARPSL_WAIT_DISCHARGE_ON              100 /* 100 msec */
+#define SHARPSL_CHECK_BATTERY_WAIT_TIME_TEMP   10  /* 10 msec */
+#define SHARPSL_CHECK_BATTERY_WAIT_TIME_VOLT   10  /* 10 msec */
+#define SHARPSL_CHECK_BATTERY_WAIT_TIME_ACIN   10  /* 10 msec */
+#define SHARPSL_CHARGE_WAIT_TIME               15  /* 15 msec */
+#define SHARPSL_CHARGE_CO_CHECK_TIME           5   /* 5 msec */
+#define SHARPSL_CHARGE_RETRY_CNT               1   /* eqv. 10 min */
+
 #endif
diff --git a/arch/arm/mach-pxa/sharpsl_pm.c b/arch/arm/mach-pxa/sharpsl_pm.c
index 785880f..513588c 100644
--- a/arch/arm/mach-pxa/sharpsl_pm.c
+++ b/arch/arm/mach-pxa/sharpsl_pm.c
@@ -32,23 +32,6 @@
 #include <mach/sharpsl_pm.h>
 
 /*
- * Constants
- */
-#define SHARPSL_CHARGE_ON_TIME_INTERVAL        (msecs_to_jiffies(1*60*1000))  /* 1 min */
-#define SHARPSL_CHARGE_FINISH_TIME             (msecs_to_jiffies(10*60*1000)) /* 10 min */
-#define SHARPSL_BATCHK_TIME                    (msecs_to_jiffies(15*1000))    /* 15 sec */
-#define SHARPSL_BATCHK_TIME_SUSPEND            (60*10)                        /* 10 min */
-
-#define SHARPSL_WAIT_CO_TIME                   15  /* 15 sec */
-#define SHARPSL_WAIT_DISCHARGE_ON              100 /* 100 msec */
-#define SHARPSL_CHECK_BATTERY_WAIT_TIME_TEMP   10  /* 10 msec */
-#define SHARPSL_CHECK_BATTERY_WAIT_TIME_VOLT   10  /* 10 msec */
-#define SHARPSL_CHECK_BATTERY_WAIT_TIME_ACIN   10  /* 10 msec */
-#define SHARPSL_CHARGE_WAIT_TIME               15  /* 15 msec */
-#define SHARPSL_CHARGE_CO_CHECK_TIME           5   /* 5 msec */
-#define SHARPSL_CHARGE_RETRY_CNT               1   /* eqv. 10 min */
-
-/*
  * Prototypes
  */
 #ifdef CONFIG_PM

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
