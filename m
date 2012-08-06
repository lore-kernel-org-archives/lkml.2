Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab2HFMqa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 08:46:30 -0400
Received: from hedgehog.storkhole.cz ([90.183.218.18]:16572 "EHLO
	hedgehog.storkhole.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755811Ab2HFMq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 08:46:28 -0400
X-Greylist: delayed 1506 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Aug 2012 08:46:27 EDT
From: Martin Pelikan <pelikan@storkhole.cz>
To: jason.wessel@windriver.com
Cc: pelikan@storkhole.cz, linux-kernel@vger.kernel.org,
        Martin Pelikan <mpelikan@redhat.com>
Subject: [PATCH] kdb: code cleanup, no functional change.
Date: Mon,  6 Aug 2012 14:20:09 +0200
Message-Id: <1344255609-8168-1-git-send-email-pelikan@storkhole.cz>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Pelikan <mpelikan@redhat.com>

Remove some useless and invalid comments;  (char *)0 where NULL should be
used;  static array is zeroed by definition and therefore it's reasonable
to specify its size explicitly, rather than having tens of bonkers lines.

If someone can document the original meaning or intention of the NOSECT
environment variable, it would be very helpful.  I don't see any.

Signed-off-by: Martin Pelikan <pelikan@storkhole.cz>
---
 kernel/debug/debug_core.c   |    4 --
 kernel/debug/kdb/kdb_bp.c   |   32 ---------------
 kernel/debug/kdb/kdb_main.c |   89 ++++++++++++++-----------------------------
 3 files changed, 29 insertions(+), 96 deletions(-)

diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 0557f24..18900cd 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -116,10 +116,6 @@ EXPORT_SYMBOL_GPL(kgdb_active);
 static DEFINE_RAW_SPINLOCK(dbg_master_lock);
 static DEFINE_RAW_SPINLOCK(dbg_slave_lock);
 
-/*
- * We use NR_CPUs not PERCPU, in case kgdb is used to debug early
- * bootup code (which might not have percpu set up yet):
- */
 static atomic_t			masters_in_kgdb;
 static atomic_t			slaves_in_kgdb;
 static atomic_t			kgdb_break_tasklet_var;
diff --git a/kernel/debug/kdb/kdb_bp.c b/kernel/debug/kdb/kdb_bp.c
index 8418c2f..a58c481 100644
--- a/kernel/debug/kdb/kdb_bp.c
+++ b/kernel/debug/kdb/kdb_bp.c
@@ -189,21 +189,6 @@ void kdb_bp_install(struct pt_regs *regs)
 	}
 }
 
-/*
- * kdb_bp_remove
- *
- *	Remove kdb_breakpoints upon entry to the kernel debugger.
- *
- * Parameters:
- *	None.
- * Outputs:
- *	None.
- * Returns:
- *	None.
- * Locking:
- *	None.
- * Remarks:
- */
 void kdb_bp_remove(void)
 {
 	int i;
@@ -220,23 +205,6 @@ void kdb_bp_remove(void)
 	}
 }
 
-
-/*
- * kdb_printbp
- *
- *	Internal function to format and print a breakpoint entry.
- *
- * Parameters:
- *	None.
- * Outputs:
- *	None.
- * Returns:
- *	None.
- * Locking:
- *	None.
- * Remarks:
- */
-
 static void kdb_printbp(kdb_bp_t *bp, int i)
 {
 	kdb_printf("%s ", kdb_bptype(bp));
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 31df170..35516c5 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -127,55 +127,28 @@ static const int __nkdb_err = sizeof(kdbmsgs) / sizeof(kdbmsg_t);
 
 
 /*
- * Initial environment.   This is all kept static and local to
- * this file.   We don't want to rely on the memory allocation
- * mechanisms in the kernel, so we use a very limited allocate-only
- * heap for new and altered environment variables.  The entire
- * environment is limited to a fixed number of entries (add more
- * to __env[] if required) and a fixed amount of heap (add more to
- * KDB_ENVBUFSIZE if required).
+ * Initial environment.  We don't want to rely on memory allocation
+ * mechanisms in the kernel, so we use constant space in .data.
+ * If you need more slots or more space for your strings, feel free
+ * to raise KDB_ENV_SLOTS or KDB_ENV_BUFSIZE, respectively.
  */
+#define	KDB_ENV_BUFSIZE	512
+#define	KDB_ENV_SLOTS	32
 
-static char *__env[] = {
+static char *__env[KDB_ENV_SLOTS] = {
 #if defined(CONFIG_SMP)
- "PROMPT=[%d]kdb> ",
+	"PROMPT=[%d]kdb> ",
 #else
- "PROMPT=kdb> ",
+	"PROMPT=kdb> ",
 #endif
- "MOREPROMPT=more> ",
- "RADIX=16",
- "MDCOUNT=8",			/* lines of md output */
- KDB_PLATFORM_ENV,
- "DTABCOUNT=30",
- "NOSECT=1",
- (char *)0,
- (char *)0,
- (char *)0,
- (char *)0,
- (char *)0,
- (char *)0,
- (char *)0,
- (char *)0,
- (char *)0,
- (char *)0,
- (char *)0,
- (char *)0,
- (char *)0,
- (char *)0,
- (char *)0,
- (char *)0,
- (char *)0,
- (char *)0,
- (char *)0,
- (char *)0,
- (char *)0,
- (char *)0,
- (char *)0,
- (char *)0,
+	"MOREPROMPT=more> ",
+	"RADIX=16",
+	"MDCOUNT=8",	/* lines of md output */
+	KDB_PLATFORM_ENV,
+	"DTABCOUNT=30",	/* how many symbols to print after a <TAB> key */
+	"NOSECT=1",
 };
 
-static const int __nenv = (sizeof(__env) / sizeof(char *));
-
 struct task_struct *kdb_curr_task(int cpu)
 {
 	struct task_struct *p = curr_task(cpu);
@@ -197,19 +170,16 @@ struct task_struct *kdb_curr_task(int cpu)
  */
 char *kdbgetenv(const char *match)
 {
-	char **ep = __env;
-	int matchlen = strlen(match);
+	char *e;
+	const size_t len = strlen(match);
 	int i;
 
-	for (i = 0; i < __nenv; i++) {
-		char *e = *ep++;
-
-		if (!e)
+	for (i = 0; i < KDB_ENV_SLOTS; i++) {
+		if ((e = __env[i]) == NULL)
 			continue;
 
-		if ((strncmp(match, e, matchlen) == 0)
-		 && ((e[matchlen] == '\0')
-		   || (e[matchlen] == '='))) {
+		if ((strncmp(match, e, len) == 0) &&
+		    ((e[len] == '\0') || (e[len] == '='))) {
 			char *cp = strchr(e, '=');
 			return cp ? ++cp : "";
 		}
@@ -235,12 +205,11 @@ char *kdbgetenv(const char *match)
  */
 static char *kdballocenv(size_t bytes)
 {
-#define	KDB_ENVBUFSIZE	512
-	static char envbuffer[KDB_ENVBUFSIZE];
+	static char envbuffer[KDB_ENV_BUFSIZE];
 	static int envbufsize;
 	char *ep = NULL;
 
-	if ((KDB_ENVBUFSIZE - envbufsize) >= bytes) {
+	if ((KDB_ENV_BUFSIZE - envbufsize) >= bytes) {
 		ep = &envbuffer[envbufsize];
 		envbufsize += bytes;
 	}
@@ -395,14 +364,14 @@ int kdb_set(int argc, const char **argv)
 	varlen = strlen(argv[1]);
 	vallen = strlen(argv[2]);
 	ep = kdballocenv(varlen + vallen + 2);
-	if (ep == (char *)0)
+	if (ep == NULL)
 		return KDB_ENVBUFFULL;
 
 	sprintf(ep, "%s=%s", argv[1], argv[2]);
 
 	ep[varlen+vallen+1] = '\0';
 
-	for (i = 0; i < __nenv; i++) {
+	for (i = 0; i < KDB_ENV_SLOTS; i++) {
 		if (__env[i]
 		 && ((strncmp(__env[i], argv[1], varlen) == 0)
 		   && ((__env[i][varlen] == '\0')
@@ -415,8 +384,8 @@ int kdb_set(int argc, const char **argv)
 	/*
 	 * Wasn't existing variable.  Fit into slot.
 	 */
-	for (i = 0; i < __nenv-1; i++) {
-		if (__env[i] == (char *)0) {
+	for (i = 0; i < KDB_ENV_SLOTS - 1; i++) {
+		if (__env[i] == NULL) {
 			__env[i] = ep;
 			return 0;
 		}
@@ -1973,7 +1942,7 @@ static int kdb_lsmod(int argc, const char **argv)
 		kdb_printf("%-20s%8u  0x%p ", mod->name,
 			   mod->core_size, (void *)mod);
 #ifdef CONFIG_MODULE_UNLOAD
-		kdb_printf("%4ld ", module_refcount(mod));
+		kdb_printf("%4lu ", module_refcount(mod));
 #endif
 		if (mod->state == MODULE_STATE_GOING)
 			kdb_printf(" (Unloading)");
@@ -2009,7 +1978,7 @@ static int kdb_env(int argc, const char **argv)
 {
 	int i;
 
-	for (i = 0; i < __nenv; i++) {
+	for (i = 0; i < KDB_ENV_SLOTS; i++) {
 		if (__env[i])
 			kdb_printf("%s\n", __env[i]);
 	}
-- 
1.7.1

