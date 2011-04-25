Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758364Ab1DYKpF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 06:45:05 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51918 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758328Ab1DYKo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 06:44:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Qw2VIt0NQhu4WilR5YhxuiKLISzOeqoXf6OojxAgWnm8tX05RDUtkiL1NA10lHVxEX
         P/i6BTerYNlS035T4awtwYn6vLB0AMiNM+8g0O6EJUPr5rpNGSlvakqvB+EIjJ/qZixu
         iSztlX5WpjqIhbtE/pf07FtQjB8tm0tPV6dFE=
From: Geunsik Lim <leemgs1@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Hugh Dickins <hughd@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Darren Hart <dvhart@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [PATCH 2/4] munmap: sysctl extension for tunable parameter
Date: Mon, 25 Apr 2011 19:44:30 +0900
Message-Id: <1303728272-11408-3-git-send-email-leemgs1@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1303728272-11408-1-git-send-email-leemgs1@gmail.com>
References: <1303728272-11408-1-git-send-email-leemgs1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geunsik Lim <geunsik.lim@samsung.com>

Support sysctl interface(tunalbe parameter) to find a suitable munmap
operation unit at runtime favoringly

* sysctl: An interface for examining and dynamically changing munmap opearon
          size parameters in Linux. In Linux, the sysctl is implemented as
	  a wrapper around file system routines that access contents of files
	  in the /proc

Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>
Acked-by: Hyunjin Choi <hj89.choi@samsung.com>
---
 kernel/sysctl.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c0bb324..9b85041 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -56,6 +56,7 @@
 #include <linux/kprobes.h>
 #include <linux/pipe_fs_i.h>
 #include <linux/oom.h>
+#include <linux/munmap_unit_size.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -1278,6 +1279,15 @@ static struct ctl_table vm_table[] = {
 		.proc_handler	= mmap_min_addr_handler,
 	},
 #endif
+#ifdef CONFIG_MMU
+	{
+		.procname	= "munmap_unit_size",
+		.data		= &sysctl_munmap_unit_size,
+		.maxlen		= sizeof(unsigned long),
+		.mode		= 0644,
+		.proc_handler	= munmap_unit_size_handler,
+	},
+#endif
 #ifdef CONFIG_NUMA
 	{
 		.procname	= "numa_zonelist_order",
-- 
1.7.3.4

