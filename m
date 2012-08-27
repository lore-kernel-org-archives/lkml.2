Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab2H0HWG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 03:22:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53591 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab2H0HWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 03:22:02 -0400
From: Alex Kelly <alex.page.kelly@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>, David Howells <dhowells@redhat.com>,
        Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org
Cc: Alex Kelly <alex.page.kelly@gmail.com>
Subject: [PATCHv2] fs: Amended coredump-related sysctl functions
Date: Mon, 27 Aug 2012 00:18:03 -0700
Message-Id: <1346051885-4366-1-git-send-email-alex.page.kelly@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes an error introduced in the coredump-header patch in
the coredump removal patch I submitted earlier. It should be squashed
into that patch series so that the Kconfig option to remove coredump
doesn't cause compile-time errors.

Signed-off-by: Alex Kelly <alex.page.kelly@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
v2: Removed an erroneous return statement that shouldn't have gotten into
the original patch. I apologize for the spam

---
Note to Andrew Morton: This is a small fix of an oversight in the coredump
patch I submitted earlier. Could this be squashed into the others in -mm?

 kernel/sysctl.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index af57e84..9050b50 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -179,8 +179,10 @@ static int proc_dointvec_minmax_sysadmin(struct ctl_table *table, int write,
 
 static int proc_dointvec_minmax_coredump(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp, loff_t *ppos);
+#ifdef CONFIG_COREDUMP
 static int proc_dostring_coredump(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp, loff_t *ppos);
+#endif
 
 #ifdef CONFIG_MAGIC_SYSRQ
 /* Note: sysrq code uses it's own private copy */
@@ -2040,12 +2042,14 @@ int proc_dointvec_minmax(struct ctl_table *table, int write,
 
 static void validate_coredump_safety(void)
 {
+#ifdef CONFIG_COREDUMP
 	if (suid_dumpable == SUID_DUMPABLE_SAFE &&
 	    core_pattern[0] != '/' && core_pattern[0] != '|') {
 		printk(KERN_WARNING "Unsafe core_pattern used with "\
 			"suid_dumpable=2. Pipe handler or fully qualified "\
 			"core dump path required.\n");
 	}
+#endif
 }
 
 static int proc_dointvec_minmax_coredump(struct ctl_table *table, int write,
@@ -2057,6 +2061,7 @@ static int proc_dointvec_minmax_coredump(struct ctl_table *table, int write,
 	return error;
 }
 
+#ifdef CONFIG_COREDUMP
 static int proc_dostring_coredump(struct ctl_table *table, int write,
 		  void __user *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -2065,6 +2070,7 @@ static int proc_dostring_coredump(struct ctl_table *table, int write,
 		validate_coredump_safety();
 	return error;
 }
+#endif
 
 static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int write,
 				     void __user *buffer,
-- 
1.7.11.4

