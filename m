Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab1F0Nmq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 09:42:46 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47948 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839Ab1F0Nm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 09:42:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=KYSKlAvDhMWP301IHYOGaYFPVoqB1P2ZbTryBRnW8Z2JVdn+P/1tv4/3hygOl6Hsyu
         vnFL1pn5sknoFxafl3Ixm/QayIhSQ91kHeFzc4jvVTRMabLMMwmeDunrvhXx18WVGg+h
         jz9dWil7ZAvB0Wf5OpMOL1zdoZHSssrQdEW+s=
From: Geunsik Lim <leemgs1@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Hugh Dickins <hughd@google.com>, Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: [PATCH V2 2/4] munmap: sysctl extension for tunable parameter
Date: Mon, 27 Jun 2011 22:41:54 +0900
Message-Id: <1309182116-26698-3-git-send-email-leemgs1@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1309182116-26698-1-git-send-email-leemgs1@gmail.com>
References: <1309182116-26698-1-git-send-email-leemgs1@gmail.com>
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
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Steven Rostedt <rostedt@redhat.com>
CC: Hugh Dickins <hughd@google.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>
CC: Ingo Molnar <mingo@elte.hu>
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

