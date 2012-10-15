Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632Ab2JOImK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 04:42:10 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38810 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab2JOImG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 04:42:06 -0400
From: "\"Levan Giguashvili" <levangig@gmail.com>
To: rusty@rustcorp.com.au
Cc: mingo@kernel.org, jim.cromie@gmail.com, viro@zeniv.linux.org.uk,
        hpa@linux.intel.com, linux-kernel@vger.kernel.org, levangig@gmail.com
Subject: [PATCH] init: main: fixed coding style issues and errors
Date: Mon, 15 Oct 2012 10:41:44 +0200
Message-Id: <1350290504-13931-1-git-send-email-user@ubuntu>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Odinn <odinn@ubuntu.(none)>

Fixed coding style issues regarding spaces and braces.
Removed init of a static variable.
Added KERN_DEBUG to printk that was missing it

Signed-off-by: Levan Giguashvili <levangig@gmail.com>
---
 init/main.c |   52 +++++++++++++++++++++++++---------------------------
 1 file changed, 25 insertions(+), 27 deletions(-)

diff --git a/init/main.c b/init/main.c
index 9cf77ab..43e3852 100644
--- a/init/main.c
+++ b/init/main.c
@@ -6,7 +6,7 @@
  *  GK 2/5/95  -  Changed to support mounting root fs via NFS
  *  Added initrd & change_root: Werner Almesberger & Hans Lermen, Feb '96
  *  Moan early if gcc is old, avoiding bogus kernels - Paul Gortmaker, May '96
- *  Simplified starting of init:  Michael A. Griffith <grif@acm.org> 
+ *  Simplified starting of init:  Michael A. Griffith <grif@acm.org>
  */
 
 #include <linux/types.h>
@@ -71,14 +71,14 @@
 #include <linux/file.h>
 #include <linux/ptrace.h>
 
-#include <asm/io.h>
+#include <linux/io.h>
 #include <asm/bugs.h>
 #include <asm/setup.h>
 #include <asm/sections.h>
 #include <asm/cacheflush.h>
 
 #ifdef CONFIG_X86_LOCAL_APIC
-#include <asm/smp.h>
+#include <linux/smp.h>
 #endif
 
 static int kernel_init(void *);
@@ -149,8 +149,8 @@ static int __init set_reset_devices(char *str)
 
 __setup("reset_devices", set_reset_devices);
 
-static const char * argv_init[MAX_INIT_ARGS+2] = { "init", NULL, };
-const char * envp_init[MAX_INIT_ENVS+2] = { "HOME=/", "TERM=linux", NULL, };
+static const char *argv_init[MAX_INIT_ARGS+2] = { "init", NULL, };
+const char *envp_init[MAX_INIT_ENVS+2] = { "HOME=/", "TERM=linux", NULL, };
 static const char *panic_later, *panic_param;
 
 extern const struct obs_kernel_param __setup_start[], __setup_end[];
@@ -172,8 +172,8 @@ static int __init obsolete_checksetup(char *line)
 				if (line[n] == '\0' || line[n] == '=')
 					had_early_param = 1;
 			} else if (!p->setup_func) {
-				printk(KERN_WARNING "Parameter %s is obsolete,"
-				       " ignored\n", p->str);
+				printk(KERN_WARNING "Parameter %s is obsolete" \
+				       ", ignored\n", p->str);
 				return 1;
 			} else if (p->setup_func(line + n))
 				return 1;
@@ -189,7 +189,6 @@ static int __init obsolete_checksetup(char *line)
  * still work even if initially too large, it will just take slightly longer
  */
 unsigned long loops_per_jiffy = (1<<12);
-
 EXPORT_SYMBOL(loops_per_jiffy);
 
 static int __init debug_kernel(char *str)
@@ -340,10 +339,10 @@ static inline void smp_prepare_cpus(unsigned int maxcpus) { }
  */
 static void __init setup_command_line(char *command_line)
 {
-	saved_command_line = alloc_bootmem(strlen (boot_command_line)+1);
-	static_command_line = alloc_bootmem(strlen (command_line)+1);
-	strcpy (saved_command_line, boot_command_line);
-	strcpy (static_command_line, command_line);
+	saved_command_line = alloc_bootmem(strlen(boot_command_line)+1);
+	static_command_line = alloc_bootmem(strlen(command_line)+1);
+	strcpy(saved_command_line, boot_command_line);
+	strcpy(static_command_line, command_line);
 }
 
 /*
@@ -412,7 +411,7 @@ void __init parse_early_options(char *cmdline)
 /* Arch code calls this early on, or if not, just before other parsing. */
 void __init parse_early_param(void)
 {
-	static __initdata int done = 0;
+	static __initdata int done;
 	static __initdata char tmp_cmdline[COMMAND_LINE_SIZE];
 
 	if (done)
@@ -465,7 +464,7 @@ static void __init mm_init(void)
 
 asmlinkage void __init start_kernel(void)
 {
-	char * command_line;
+	char *command_line;
 	extern const struct kernel_param __start___param[], __stop___param[];
 
 	/*
@@ -536,8 +535,8 @@ asmlinkage void __init start_kernel(void)
 	 */
 	preempt_disable();
 	if (!irqs_disabled()) {
-		printk(KERN_WARNING "start_kernel(): bug: interrupts were "
-				"enabled *very* early, fixing it\n");
+		printk(KERN_WARNING "start_kernel(): bug: interrupts were" \
+				" enabled *very* early, fixing it\n");
 		local_irq_disable();
 	}
 	idr_init_cache();
@@ -555,8 +554,8 @@ asmlinkage void __init start_kernel(void)
 	profile_init();
 	call_function_init();
 	if (!irqs_disabled())
-		printk(KERN_CRIT "start_kernel(): bug: interrupts were "
-				 "enabled early\n");
+		printk(KERN_CRIT "start_kernel(): bug: interrupts" \
+				 " were enabled early\n");
 	early_boot_irqs_disabled = false;
 	local_irq_enable();
 
@@ -583,8 +582,8 @@ asmlinkage void __init start_kernel(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 	if (initrd_start && !initrd_below_start_ok &&
 	    page_to_pfn(virt_to_page((void *)initrd_start)) < min_low_pfn) {
-		printk(KERN_CRIT "initrd overwritten (0x%08lx < 0x%08lx) - "
-		    "disabling it.\n",
+		printk(KERN_CRIT "initrd overwritten (0x%08lx < 0x%08lx)" \
+		    " - disabling it.\n",
 		    page_to_pfn(virt_to_page((void *)initrd_start)),
 		    min_low_pfn);
 		initrd_start = 0;
@@ -698,9 +697,8 @@ int __init_or_module do_one_initcall(initcall_t fn)
 		strlcat(msgbuf, "disabled interrupts ", sizeof(msgbuf));
 		local_irq_enable();
 	}
-	if (msgbuf[0]) {
-		printk("initcall %pF returned with %s\n", fn, msgbuf);
-	}
+	if (msgbuf[0])
+		printk(KERN_DEBUG "initcall %pF returned with %s\n", fn, msgbuf);
 
 	return ret;
 }
@@ -829,8 +827,8 @@ static int __ref kernel_init(void *unused)
 	if (execute_command) {
 		if (!run_init_process(execute_command))
 			return 0;
-		printk(KERN_WARNING "Failed to execute %s.  Attempting "
-					"defaults...\n", execute_command);
+		printk(KERN_WARNING "Failed to execute %s.  Attempting" \
+					" defaults...\n", execute_command);
 	}
 	if (!run_init_process("/sbin/init") ||
 	    !run_init_process("/etc/init") ||
@@ -838,8 +836,8 @@ static int __ref kernel_init(void *unused)
 	    !run_init_process("/bin/sh"))
 		return 0;
 
-	panic("No init found.  Try passing init= option to kernel. "
-	      "See Linux Documentation/init.txt for guidance.");
+	panic("No init found.  Try passing init= option to kernel" \
+	      ". See Linux Documentation/init.txt for guidance.");
 }
 
 static void __init kernel_init_freeable(void)
-- 
1.7.9.5

