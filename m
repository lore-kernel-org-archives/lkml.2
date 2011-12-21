Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab1LUNXC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 08:23:02 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53846 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab1LUNXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 08:23:00 -0500
Date: Wed, 21 Dec 2011 17:22:56 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrey Vagin <avagin@openvz.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm] fs: proc -- Make /proc/<pid>/map_files being
 CHECKPOINT_RESTORE dependent
Message-ID: <20111221132256.GJ12782@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This entry was introduced in a sake of C/R, so no need to
built it in by default.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

For -mm tree

 fs/proc/base.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6.git/fs/proc/base.c
===================================================================
--- linux-2.6.git.orig/fs/proc/base.c
+++ linux-2.6.git/fs/proc/base.c
@@ -2160,6 +2160,8 @@ static const struct file_operations proc
 	.llseek		= default_llseek,
 };
 
+#ifdef CONFIG_CHECKPOINT_RESTORE
+
 /*
  * dname_to_vma_addr - maps a dentry name into two unsigned longs
  * which represent vma start and end addresses.
@@ -2505,6 +2507,8 @@ static const struct file_operations proc
 	.llseek		= default_llseek,
 };
 
+#endif /* CONFIG_CHECKPOINT_RESTORE */
+
 /*
  * /proc/pid/fd needs a special permission handler so that a process can still
  * access /proc/self/fd after it has executed a setuid().
@@ -3120,7 +3124,9 @@ static const struct inode_operations pro
 static const struct pid_entry tgid_base_stuff[] = {
 	DIR("task",       S_IRUGO|S_IXUGO, proc_task_inode_operations, proc_task_operations),
 	DIR("fd",         S_IRUSR|S_IXUSR, proc_fd_inode_operations, proc_fd_operations),
+#ifdef CONFIG_CHECKPOINT_RESTORE
 	DIR("map_files",  S_IRUSR|S_IXUSR, proc_map_files_inode_operations, proc_map_files_operations),
+#endif
 	DIR("fdinfo",     S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fdinfo_operations),
 	DIR("ns",	  S_IRUSR|S_IXUGO, proc_ns_dir_inode_operations, proc_ns_dir_operations),
 #ifdef CONFIG_NET
