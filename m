Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab1ESLzY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 07:55:24 -0400
Received: from gate.krista.ru ([84.47.172.34]:29282 "EHLO gate.krista.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831Ab1ESLzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 07:55:23 -0400
Date: Thu, 19 May 2011 15:53:30 +0400
From: samsonov@krista.ru
To: linux-kernel@vger.kernel.org
Subject: proc/base.c patch
Message-ID: <20110519155330.514349f1@wks1198.krista.ru>
Organization: =?KOI8-R?B?7vDvIOvSydPUwQ==?=
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Score: -2.7 [-26] (--) (gate.krista.ru)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- ./linux-2.6.33.4.orig/fs/proc/base.c	2010-05-13 02:04:27.000000000 +0400
+++ ./linux-2.6.33.4/fs/proc/base.c	2011-05-16 15:36:29.385923198 +0400
@@ -2570,11 +2570,11 @@
 static const struct inode_operations proc_task_inode_operations;
 
 static const struct pid_entry tgid_base_stuff[] = {
-	DIR("task",       S_IRUGO|S_IXUGO, proc_task_inode_operations, proc_task_operations),
-	DIR("fd",         S_IRUSR|S_IXUSR, proc_fd_inode_operations, proc_fd_operations),
-	DIR("fdinfo",     S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fdinfo_operations),
+	DIR("task",       S_IWUSR|S_IRUGO|S_IXUGO, proc_task_inode_operations, proc_task_operations),
+	DIR("fd",         S_IWUSR|S_IRUSR|S_IXUSR, proc_fd_inode_operations, proc_fd_operations),
+	DIR("fdinfo",     S_IRUSR|S_IWUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fdinfo_operations),
 #ifdef CONFIG_NET
-	DIR("net",        S_IRUGO|S_IXUGO, proc_net_inode_operations, proc_net_operations),
+	DIR("net",        S_IRUGO|S_IWUSR|S_IXUGO, proc_net_inode_operations, proc_net_operations),
 #endif
 	REG("environ",    S_IRUSR, proc_environ_operations),
 	INF("auxv",       S_IRUSR, proc_pid_auxv),
@@ -2608,7 +2608,7 @@
 	REG("pagemap",    S_IRUSR, proc_pagemap_operations),
 #endif
 #ifdef CONFIG_SECURITY
-	DIR("attr",       S_IRUGO|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
+	DIR("attr",       S_IRUGO|S_IWUSR|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
 #endif
 #ifdef CONFIG_KALLSYMS
 	INF("wchan",      S_IRUGO, proc_pid_wchan),
@@ -2767,7 +2767,7 @@
 	if (!inode)
 		goto out;
 
-	inode->i_mode = S_IFDIR|S_IRUGO|S_IXUGO;
+	inode->i_mode = S_IFDIR|S_IRUSR|S_IWUSR|S_IXUSR|S_IRGRP|S_IXGRP;
 	inode->i_op = &proc_tgid_base_inode_operations;
 	inode->i_fop = &proc_tgid_base_operations;
 	inode->i_flags|=S_IMMUTABLE;
@@ -2909,8 +2909,8 @@
  * Tasks
  */
 static const struct pid_entry tid_base_stuff[] = {
-	DIR("fd",        S_IRUSR|S_IXUSR, proc_fd_inode_operations, proc_fd_operations),
-	DIR("fdinfo",    S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fdinfo_operations),
+	DIR("fd",        S_IRUSR|S_IWUSR|S_IXUSR, proc_fd_inode_operations, proc_fd_operations),
+	DIR("fdinfo",    S_IRUSR|S_IWUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fdinfo_operations),
 	REG("environ",   S_IRUSR, proc_environ_operations),
 	INF("auxv",      S_IRUSR, proc_pid_auxv),
 	ONE("status",    S_IRUGO, proc_pid_status),
@@ -2942,7 +2942,7 @@
 	REG("pagemap",    S_IRUSR, proc_pagemap_operations),
 #endif
 #ifdef CONFIG_SECURITY
-	DIR("attr",      S_IRUGO|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
+	DIR("attr",      S_IRUGO|S_IWUSR|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
 #endif
 #ifdef CONFIG_KALLSYMS
 	INF("wchan",     S_IRUGO, proc_pid_wchan),
@@ -3008,7 +3008,7 @@
 
 	if (!inode)
 		goto out;
-	inode->i_mode = S_IFDIR|S_IRUGO|S_IXUGO;
+	inode->i_mode = S_IFDIR|S_IRUSR|S_IWUSR|S_IXUSR|S_IRGRP|S_IXGRP;
 	inode->i_op = &proc_tid_base_inode_operations;
 	inode->i_fop = &proc_tid_base_operations;
 	inode->i_flags|=S_IMMUTABLE;
