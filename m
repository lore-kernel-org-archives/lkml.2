Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521Ab1K3CPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 21:15:41 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:43798 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756637Ab1K3CPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 21:15:38 -0500
From: Joe Perches <joe@perches.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 06/28] exec: Use current logging style
Date: Tue, 29 Nov 2011 18:14:04 -0800
Message-Id: <f8b182abd8416166d1a1696049e1a5a2b7d3d272.1322609672.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1322609672.git.joe@perches.com>
References: <cover.1322609672.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert printks to pr_<level>.
Add pr_fmt.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/exec.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 3625464..0839da4 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -22,6 +22,8 @@
  * formats. 
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/slab.h>
 #include <linux/file.h>
 #include <linux/fdtable.h>
@@ -2148,8 +2150,8 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 		char **helper_argv;
 
 		if (ispipe < 0) {
-			printk(KERN_WARNING "format_corename failed\n");
-			printk(KERN_WARNING "Aborting core\n");
+			pr_warn("format_corename failed\n");
+			pr_warn("Aborting core\n");
 			goto fail_corename;
 		}
 
@@ -2168,26 +2170,24 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 			 * right pid if a thread in a multi-threaded
 			 * core_pattern process dies.
 			 */
-			printk(KERN_WARNING
-				"Process %d(%s) has RLIMIT_CORE set to 1\n",
+			pr_warn("Process %d(%s) has RLIMIT_CORE set to 1\n",
 				task_tgid_vnr(current), current->comm);
-			printk(KERN_WARNING "Aborting core\n");
+			pr_warn("Aborting core\n");
 			goto fail_unlock;
 		}
 		cprm.limit = RLIM_INFINITY;
 
 		dump_count = atomic_inc_return(&core_dump_count);
 		if (core_pipe_limit && (core_pipe_limit < dump_count)) {
-			printk(KERN_WARNING "Pid %d(%s) over core_pipe_limit\n",
-			       task_tgid_vnr(current), current->comm);
-			printk(KERN_WARNING "Skipping core dump\n");
+			pr_warn("Pid %d(%s) over core_pipe_limit\n",
+				task_tgid_vnr(current), current->comm);
+			pr_warn("Skipping core dump\n");
 			goto fail_dropcount;
 		}
 
 		helper_argv = argv_split(GFP_KERNEL, cn.corename+1, NULL);
 		if (!helper_argv) {
-			printk(KERN_WARNING "%s failed to allocate memory\n",
-			       __func__);
+			pr_warn("%s failed to allocate memory\n", __func__);
 			goto fail_dropcount;
 		}
 
@@ -2196,8 +2196,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 					NULL, &cprm);
 		argv_free(helper_argv);
 		if (retval) {
- 			printk(KERN_INFO "Core dump to %s pipe failed\n",
-			       cn.corename);
+			pr_info("Core dump to %s pipe failed\n", cn.corename);
 			goto close_fail;
  		}
 	} else {
-- 
1.7.6.405.gc1be0

