Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab2KDMsH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 07:48:07 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:54358 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab2KDMsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 07:48:04 -0500
From: Valentin Ilie <valentin.ilie@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Valentin Ilie <valentin.ilie@gmail.com>
Subject: [PATCH] kernel: panic.c
Date: Sun,  4 Nov 2012 14:47:53 +0200
Message-Id: <1352033273-19558-1-git-send-email-valentin.ilie@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed checkpatch warnings.
Replaced printk(KERN_WARNING with pr_warn

Signed-off-by: Valentin Ilie <valentin.ilie@gmail.com>

---
 kernel/panic.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index e1b2822..8f1709f 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -100,7 +100,7 @@ void panic(const char *fmt, ...)
 	va_start(args, fmt);
 	vsnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
-	printk(KERN_EMERG "Kernel panic - not syncing: %s\n",buf);
+	pr_emerg("Kernel panic - not syncing: %s\n", buf);
 #ifdef CONFIG_DEBUG_BUGVERBOSE
 	/*
 	 * Avoid nested stack-dumping if a panic occurs during oops processing
@@ -137,7 +137,7 @@ void panic(const char *fmt, ...)
 		 * Delay timeout seconds before rebooting the machine.
 		 * We can't use the "normal" timers since we just panicked.
 		 */
-		printk(KERN_EMERG "Rebooting in %d seconds..", panic_timeout);
+		pr_emerg("Rebooting in %d seconds..", panic_timeout);
 
 		for (i = 0; i < panic_timeout * 1000; i += PANIC_TIMER_STEP) {
 			touch_nmi_watchdog();
@@ -161,7 +161,7 @@ void panic(const char *fmt, ...)
 		extern int stop_a_enabled;
 		/* Make sure the user can actually press Stop-A (L1-A) */
 		stop_a_enabled = 1;
-		printk(KERN_EMERG "Press Stop-A (L1-A) to return to the boot prom\n");
+		pr_emerg("Press Stop-A (L1-A) to return to the boot prom\n");
 	}
 #endif
 #if defined(CONFIG_S390)
@@ -182,7 +182,6 @@ void panic(const char *fmt, ...)
 		mdelay(PANIC_TIMER_STEP);
 	}
 }
-
 EXPORT_SYMBOL(panic);
 
 
@@ -277,7 +276,7 @@ void add_taint(unsigned flag)
 
 	default:
 		if (__debug_locks_off())
-			printk(KERN_WARNING "Disabling lock debugging due to kernel taint\n");
+			pr_warn("Disabling lock debugging due to kernel taint\n");
 	}
 
 	set_bit(flag, &tainted_mask);
@@ -383,7 +382,7 @@ late_initcall(init_oops_id);
 void print_oops_end_marker(void)
 {
 	init_oops_id();
-	printk(KERN_WARNING "---[ end trace %016llx ]---\n",
+	pr_warn("---[ end trace %016llx ]---\n",
 		(unsigned long long)oops_id);
 }
 
@@ -409,11 +408,11 @@ static void warn_slowpath_common(const char *file, int line, void *caller,
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

