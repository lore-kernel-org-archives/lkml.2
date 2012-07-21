Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab2GUA37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 20:29:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43863 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab2GUA36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 20:29:58 -0400
Date: Fri, 20 Jul 2012 17:27:54 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kay Sievers <kay@vrfy.org>, Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 2/4] printk: Remove kdb_syslog_data
Message-ID: <20120721002754.GB2213@lizard>
References: <20120721002529.GA20567@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120721002529.GA20567@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function is no longer needed, so remove it.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 kernel/debug/kdb/kdb_private.h |    1 -
 kernel/printk.c                |   15 ---------------
 2 files changed, 16 deletions(-)

diff --git a/kernel/debug/kdb/kdb_private.h b/kernel/debug/kdb/kdb_private.h
index 47c4e56..392ec6a 100644
--- a/kernel/debug/kdb/kdb_private.h
+++ b/kernel/debug/kdb/kdb_private.h
@@ -205,7 +205,6 @@ extern char kdb_grep_string[];
 extern int kdb_grep_leading;
 extern int kdb_grep_trailing;
 extern char *kdb_cmds[];
-extern void kdb_syslog_data(char *syslog_data[]);
 extern unsigned long kdb_task_state_string(const char *);
 extern char kdb_task_state_char (const struct task_struct *);
 extern unsigned long kdb_task_state(const struct task_struct *p,
diff --git a/kernel/printk.c b/kernel/printk.c
index 177fa49..c812967 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1192,21 +1192,6 @@ SYSCALL_DEFINE3(syslog, int, type, char __user *, buf, int, len)
 	return do_syslog(type, buf, len, SYSLOG_FROM_CALL);
 }
 
-#ifdef	CONFIG_KGDB_KDB
-/* kdb dmesg command needs access to the syslog buffer.  do_syslog()
- * uses locks so it cannot be used during debugging.  Just tell kdb
- * where the start and end of the physical and logical logs are.  This
- * is equivalent to do_syslog(3).
- */
-void kdb_syslog_data(char *syslog_data[4])
-{
-	syslog_data[0] = log_buf;
-	syslog_data[1] = log_buf + log_buf_len;
-	syslog_data[2] = log_buf + log_first_idx;
-	syslog_data[3] = log_buf + log_next_idx;
-}
-#endif	/* CONFIG_KGDB_KDB */
-
 static bool __read_mostly ignore_loglevel;
 
 static int __init ignore_loglevel_setup(char *str)
-- 
1.7.10.4

