Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590Ab1K3CRd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 21:17:33 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:39778 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756637Ab1K3CR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 21:17:29 -0500
From: Joe Perches <joe@perches.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 15/28] exec: checkpatch wanking
Date: Tue, 29 Nov 2011 18:14:13 -0800
Message-Id: <7b4138e77a35e6708bb166cec276a4f36a7a3d46.1322609673.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1322609672.git.joe@perches.com>
References: <cover.1322609672.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a few style things, all but 1 false positive,
the #include <asm/mmu_context.h> warning, has been
cleaned.

$ ./scripts/checkpatch.pl --terse -f fs/exec.c | cut -f3- -d":" |sort|uniq -c
      4  ERROR: code indent should use tabs where possible
      1  ERROR: do not initialise globals to 0 or NULL
      2  ERROR: do not use assignment in if condition
     10  ERROR: "foo * bar" should be "foo *bar"
      1  ERROR: space required after that ',' (ctx:OxV)
      3  ERROR: space required after that ',' (ctx:VxV)
      1  ERROR: space required before the open parenthesis '('
      2  ERROR: spaces required around that '<=' (ctx:VxV)
      1  ERROR: spaces required around that '<' (ctx:VxV)
      2  ERROR: spaces required around that '==' (ctx:VxV)
      2  ERROR: spaces required around that '=' (ctx:VxV)
      5  ERROR: trailing whitespace
      1  WARNING: braces {} are not necessary for single statement blocks
      6  WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
      3  WARNING: line over 80 characters
      4  WARNING: please, no space before tabs
      4  WARNING: please, no spaces at the start of a line
      1  WARNING: Use #include <linux/mmu_context.h> instead of <asm/mmu_context.h>
      1  WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/exec.c |   83 +++++++++++++++++++++++++++++++------------------------------
 1 files changed, 42 insertions(+), 41 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 0839da4..1365d02 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -19,7 +19,7 @@
  * current->executable is only used by the procfs.  This allows a dispatch
  * table to check for several different types  of binary formats.  We keep
  * trying until we recognize the file or we run out of supported binary
- * formats. 
+ * formats.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -58,7 +58,7 @@
 #include <linux/oom.h>
 #include <linux/compat.h>
 
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <asm/mmu_context.h>
 #include <asm/tlb.h>
 #include "internal.h"
@@ -66,7 +66,7 @@
 int core_uses_pid;
 char core_pattern[CORENAME_MAX_SIZE] = "core";
 unsigned int core_pipe_limit;
-int suid_dumpable = 0;
+int suid_dumpable;
 
 struct core_name {
 	char *corename;
@@ -79,7 +79,7 @@ static atomic_t call_count = ATOMIC_INIT(1);
 static LIST_HEAD(formats);
 static DEFINE_RWLOCK(binfmt_lock);
 
-int __register_binfmt(struct linux_binfmt * fmt, int insert)
+int __register_binfmt(struct linux_binfmt *fmt, int insert)
 {
 	if (!fmt)
 		return -EINVAL;
@@ -87,21 +87,19 @@ int __register_binfmt(struct linux_binfmt * fmt, int insert)
 	insert ? list_add(&fmt->lh, &formats) :
 		 list_add_tail(&fmt->lh, &formats);
 	write_unlock(&binfmt_lock);
-	return 0;	
+	return 0;
 }
-
 EXPORT_SYMBOL(__register_binfmt);
 
-void unregister_binfmt(struct linux_binfmt * fmt)
+void unregister_binfmt(struct linux_binfmt *fmt)
 {
 	write_lock(&binfmt_lock);
 	list_del(&fmt->lh);
 	write_unlock(&binfmt_lock);
 }
-
 EXPORT_SYMBOL(unregister_binfmt);
 
-static inline void put_binfmt(struct linux_binfmt * fmt)
+static inline void put_binfmt(struct linux_binfmt *fmt)
 {
 	module_put(fmt->module);
 }
@@ -143,8 +141,8 @@ SYSCALL_DEFINE1(uselib, const char __user *, library)
 	fsnotify_open(file);
 
 	error = -ENOEXEC;
-	if(file->f_op) {
-		struct linux_binfmt * fmt;
+	if (file->f_op) {
+		struct linux_binfmt *fmt;
 
 		read_lock(&binfmt_lock);
 		list_for_each_entry(fmt, &formats, lh) {
@@ -164,7 +162,7 @@ SYSCALL_DEFINE1(uselib, const char __user *, library)
 exit:
 	fput(file);
 out:
-  	return error;
+	return error;
 }
 
 #ifdef CONFIG_MMU
@@ -811,13 +809,12 @@ int kernel_read(struct file *file, loff_t offset,
 	set_fs(old_fs);
 	return result;
 }
-
 EXPORT_SYMBOL(kernel_read);
 
 static int exec_mmap(struct mm_struct *mm)
 {
 	struct task_struct *tsk;
-	struct mm_struct * old_mm, *active_mm;
+	struct mm_struct *old_mm, *active_mm;
 
 	/* Notify parent that we're no longer interested in the old VM */
 	tsk = current;
@@ -1012,7 +1009,7 @@ no_thread_group:
  * These functions flushes out all traces of the currently running executable
  * so that a new one can be started
  */
-static void flush_old_files(struct files_struct * files)
+static void flush_old_files(struct files_struct *files)
 {
 	long j = -1;
 	struct fdtable *fdt;
@@ -1031,10 +1028,9 @@ static void flush_old_files(struct files_struct * files)
 			continue;
 		fdt->close_on_exec->fds_bits[j] = 0;
 		spin_unlock(&files->file_lock);
-		for ( ; set ; i++,set >>= 1) {
-			if (set & 1) {
+		for (; set; i++, set >>= 1) {
+			if (set & 1)
 				sys_close(i);
-			}
 		}
 		spin_lock(&files->file_lock);
 
@@ -1069,7 +1065,7 @@ void set_task_comm(struct task_struct *tsk, char *buf)
 	perf_event_comm(tsk);
 }
 
-int flush_old_exec(struct linux_binprm * bprm)
+int flush_old_exec(struct linux_binprm *bprm)
 {
 	int retval;
 
@@ -1112,7 +1108,7 @@ void would_dump(struct linux_binprm *bprm, struct file *file)
 }
 EXPORT_SYMBOL(would_dump);
 
-void setup_new_exec(struct linux_binprm * bprm)
+void setup_new_exec(struct linux_binprm *bprm)
 {
 	int i, ch;
 	const char *name;
@@ -1131,7 +1127,7 @@ void setup_new_exec(struct linux_binprm * bprm)
 	name = bprm->filename;
 
 	/* Copies the binary name from after last slash */
-	for (i=0; (ch = *(name++)) != '\0';) {
+	for (i = 0; (ch = *(name++)) != '\0';) {
 		if (ch == '/')
 			i = 0; /* overwrite what we wrote */
 		else
@@ -1168,7 +1164,7 @@ void setup_new_exec(struct linux_binprm * bprm)
 	   group */
 
 	current->self_exec_id++;
-			
+
 	flush_signal_handlers(current, 0);
 	flush_old_files(current->files);
 }
@@ -1263,8 +1259,8 @@ int check_unsafe_exec(struct linux_binprm *bprm)
 	return res;
 }
 
-/* 
- * Fill the binprm structure from the inode. 
+/*
+ * Fill the binprm structure from the inode.
  * Check permissions, then read the first 128 (BINPRM_BUF_SIZE) bytes
  *
  * This may be called multiple times for binary chains (scripts for example).
@@ -1272,7 +1268,7 @@ int check_unsafe_exec(struct linux_binprm *bprm)
 int prepare_binprm(struct linux_binprm *bprm)
 {
 	umode_t mode;
-	struct inode * inode = bprm->file->f_path.dentry->d_inode;
+	struct inode *inode = bprm->file->f_path.dentry->d_inode;
 	int retval;
 
 	mode = inode->i_mode;
@@ -1311,7 +1307,6 @@ int prepare_binprm(struct linux_binprm *bprm)
 	memset(bprm->buf, 0, BINPRM_BUF_SIZE);
 	return kernel_read(bprm->file, 0, bprm->buf, BINPRM_BUF_SIZE);
 }
-
 EXPORT_SYMBOL(prepare_binprm);
 
 /*
@@ -1361,10 +1356,10 @@ EXPORT_SYMBOL(remove_arg_zero);
 /*
  * cycle the list of binary formats handler, until one recognizes the image
  */
-int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
+int search_binary_handler(struct linux_binprm *bprm, struct pt_regs *regs)
 {
 	unsigned int depth = bprm->recursion_depth;
-	int try,retval;
+	int try, retval;
 	struct linux_binfmt *fmt;
 	pid_t old_pid;
 
@@ -1382,10 +1377,11 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 	rcu_read_unlock();
 
 	retval = -ENOENT;
-	for (try=0; try<2; try++) {
+	for (try = 0; try < 2; try++) {
 		read_lock(&binfmt_lock);
 		list_for_each_entry(fmt, &formats, lh) {
-			int (*fn)(struct linux_binprm *, struct pt_regs *) = fmt->load_binary;
+			int (*fn)(struct linux_binprm *, struct pt_regs *) =
+				fmt->load_binary;
 			if (!fn)
 				continue;
 			if (!try_module_get(fmt->module))
@@ -1425,7 +1421,10 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 		if (retval != -ENOEXEC || bprm->mm == NULL) {
 			break;
 		} else {
-#define printable(c) (((c)=='\t') || ((c)=='\n') || (0x20<=(c) && (c)<=0x7e))
+
+#define printable(c)							\
+	(((c) == '\t') || ((c) == '\n') || (0x20 <= (c) && (c) <= 0x7e))
+
 			if (printable(bprm->buf[0]) &&
 			    printable(bprm->buf[1]) &&
 			    printable(bprm->buf[2]) &&
@@ -1433,7 +1432,8 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 				break; /* -ENOEXEC */
 			if (try)
 				break; /* -ENOEXEC */
-			request_module("binfmt-%04x", *(unsigned short *)(&bprm->buf[2]));
+			request_module("binfmt-%04x",
+				       *(unsigned short *)(&bprm->buf[2]));
 		}
 #else
 		break;
@@ -1441,7 +1441,6 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 	}
 	return retval;
 }
-
 EXPORT_SYMBOL(search_binary_handler);
 
 /*
@@ -1510,11 +1509,13 @@ static int do_execve_common(const char *filename,
 		goto out_file;
 
 	bprm->argc = count(argv, MAX_ARG_STRINGS);
-	if ((retval = bprm->argc) < 0)
+	retval = bprm->argc;
+	if (retval < 0)
 		goto out;
 
 	bprm->envc = count(envp, MAX_ARG_STRINGS);
-	if ((retval = bprm->envc) < 0)
+	retval = bprm->envc;
+	if (retval < 0)
 		goto out;
 
 	retval = prepare_binprm(bprm);
@@ -1534,7 +1535,7 @@ static int do_execve_common(const char *filename,
 	if (retval < 0)
 		goto out;
 
-	retval = search_binary_handler(bprm,regs);
+	retval = search_binary_handler(bprm, regs);
 	if (retval < 0)
 		goto out;
 
@@ -1613,7 +1614,6 @@ void set_binfmt(struct linux_binfmt *new)
 	if (new)
 		__module_get(new->module);
 }
-
 EXPORT_SYMBOL(set_binfmt);
 
 static int expand_corename(struct core_name *cn)
@@ -2090,7 +2090,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 	struct core_state core_state;
 	struct core_name cn;
 	struct mm_struct *mm = current->mm;
-	struct linux_binfmt * binfmt;
+	struct linux_binfmt *binfmt;
 	const struct cred *old_cred;
 	struct cred *cred;
 	int retval = 0;
@@ -2145,7 +2145,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 
 	ispipe = format_corename(&cn, signr);
 
- 	if (ispipe) {
+	if (ispipe) {
 		int dump_count;
 		char **helper_argv;
 
@@ -2198,7 +2198,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 		if (retval) {
 			pr_info("Core dump to %s pipe failed\n", cn.corename);
 			goto close_fail;
- 		}
+		}
 	} else {
 		struct inode *inode;
 
@@ -2264,7 +2264,8 @@ fail:
  */
 int dump_write(struct file *file, const void *addr, int nr)
 {
-	return access_ok(VERIFY_READ, addr, nr) && file->f_op->write(file, addr, nr, &file->f_pos) == nr;
+	return access_ok(VERIFY_READ, addr, nr) &&
+	       file->f_op->write(file, addr, nr, &file->f_pos) == nr;
 }
 EXPORT_SYMBOL(dump_write);
 
-- 
1.7.6.405.gc1be0

