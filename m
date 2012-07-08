Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab2GHOXX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 10:23:23 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:59196 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab2GHOXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 10:23:22 -0400
From: Valentin Ilie <valentin.ilie@gmail.com>
To: akpm@linux-foundation.org
Cc: mingo@kernel.org, gregkh@suse.de, linux-kernel@vger.kernel.org,
        Valentin Ilie <valentin.ilie@gmail.com>
Subject: Kernel: panic.c: fixed checkpatch warnings
Date: Sun,  8 Jul 2012 17:23:10 +0300
Message-Id: <1341757390-3279-1-git-send-email-valentin.ilie@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced printk(KERN_WARNING.. with pr_warn..

Signed-off-by: Valentin Ilie <valentin.ilie@gmail.com>
---
 kernel/panic.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index d2a5f4e..be76bc4 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -37,7 +37,6 @@ int panic_timeout;
 EXPORT_SYMBOL_GPL(panic_timeout);
 
 ATOMIC_NOTIFIER_HEAD(panic_notifier_list);
-
 EXPORT_SYMBOL(panic_notifier_list);
 
 static long no_blink(int state)
@@ -92,7 +91,7 @@ void panic(const char *fmt, ...)
 	va_start(args, fmt);
 	vsnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
-	printk(KERN_EMERG "Kernel panic - not syncing: %s\n",buf);
+	pr_emerg("Kernel panic - not syncing: %s\n", buf);
 #ifdef CONFIG_DEBUG_BUGVERBOSE
 	/*
 	 * Avoid nested stack-dumping if a panic occurs during oops processing
@@ -129,7 +128,7 @@ void panic(const char *fmt, ...)
 		 * Delay timeout seconds before rebooting the machine.
 		 * We can't use the "normal" timers since we just panicked.
 		 */
-		printk(KERN_EMERG "Rebooting in %d seconds..", panic_timeout);
+		pr_emerg("Rebooting in %d seconds..", panic_timeout);
 
 		for (i = 0; i < panic_timeout * 1000; i += PANIC_TIMER_STEP) {
 			touch_nmi_watchdog();
@@ -153,7 +152,7 @@ void panic(const char *fmt, ...)
 		extern int stop_a_enabled;
 		/* Make sure the user can actually press Stop-A (L1-A) */
 		stop_a_enabled = 1;
-		printk(KERN_EMERG "Press Stop-A (L1-A) to return to the boot prom\n");
+		pr_emerg("Press Stop-A (L1-A) to return to the boot prom\n");
 	}
 #endif
 #if defined(CONFIG_S390)
@@ -174,7 +173,6 @@ void panic(const char *fmt, ...)
 		mdelay(PANIC_TIMER_STEP);
 	}
 }
-
 EXPORT_SYMBOL(panic);
 
 
@@ -269,7 +267,7 @@ void add_taint(unsigned flag)
 
 	default:
 		if (__debug_locks_off())
-			printk(KERN_WARNING "Disabling lock debugging due to kernel taint\n");
+			pr_warn("Disabling lock debugging due to kernel taint\n");
 	}
 
 	set_bit(flag, &tainted_mask);
@@ -375,7 +373,7 @@ late_initcall(init_oops_id);
 void print_oops_end_marker(void)
 {
 	init_oops_id();
-	printk(KERN_WARNING "---[ end trace %016llx ]---\n",
+	pr_warn("---[ end trace %016llx ]---\n",
 		(unsigned long long)oops_id);
 }
 
@@ -401,11 +399,11 @@ static void warn_slowpath_common(const char *file, int line, void *caller,
 {
 	const char *board;
 
-	printk(KERN_WARNING "------------[ cut here ]------------\n");
-	printk(KERN_WARNING "WARNING: at %s:%d %pS()\n", file, line, caller);
+	pr_warn("------------[ cut here ]------------\n");
+	pr_warn("WARNING: at %s:%d %pS()\n", file, line, caller);
 	board = dmi_get_system_info(DMI_PRODUCT_NAME);
 	if (board)
-		printk(KERN_WARNING "Hardware name: %s\n", board);
+		pr_warn("Hardware name: %s\n", board);
 
 	if (args)
 		vprintk(args->fmt, args->args);
-- 
1.7.10.4

