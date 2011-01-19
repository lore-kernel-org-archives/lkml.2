Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab1ASHaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 02:30:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332Ab1ASHaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 02:30:16 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: WANG Cong <amwang@redhat.com>,
        Ingo Molnar <mingo@elte.hu> (commit_signer:8/43=19% 
	,commit_signer:4/26=15%),
        Andrew Morton <akpm@linux-foundation.org> (commit_signer:7/43=16% 
	,commit_signer:9/26=35%),
        Peter Zijlstra <a.p.zijlstra@chello.nl> (commit_signer:5/43=12%),
        Tejun Heo <tj@kernel.org> (commit_signer:4/43=9%),
        Arnd Bergmann <arnd@arndb.de> (commit_signer:3/43=7%),
        James Morris <jmorris@namei.org> (commit_signer:6/26=23%),
        Kees Cook <kees.cook@canonical.com> (commit_signer:4/26=15%),
        Namhyung Kim <namhyung@gmail.com> (commit_signer:3/26=12%)
Subject: [Patch] printk: move some loglevel setup functions to kernel/printk.c
Date: Wed, 19 Jan 2011 15:29:24 +0800
Message-Id: <1295422165-22269-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These parameter setup functions should go to kernel/printk.c,
and should also be under CONFIG_PRINTK.

Signed-off-by: WANG Cong <amwang@redhat.com>

---
diff --git a/init/main.c b/init/main.c
index 00799c1..b832b69 100644
--- a/init/main.c
+++ b/init/main.c
@@ -240,29 +240,6 @@ unsigned long loops_per_jiffy = (1<<12);
 
 EXPORT_SYMBOL(loops_per_jiffy);
 
-static int __init debug_kernel(char *str)
-{
-	console_loglevel = 10;
-	return 0;
-}
-
-static int __init quiet_kernel(char *str)
-{
-	console_loglevel = 4;
-	return 0;
-}
-
-early_param("debug", debug_kernel);
-early_param("quiet", quiet_kernel);
-
-static int __init loglevel(char *str)
-{
-	get_option(&str, &console_loglevel);
-	return 0;
-}
-
-early_param("loglevel", loglevel);
-
 /*
  * Unknown boot options get handed to init, unless they look like
  * unused parameters (modprobe will find them in /proc/cmdline).
diff --git a/kernel/printk.c b/kernel/printk.c
index 53d9a9e..e495a2c 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -467,6 +467,30 @@ static void __call_console_drivers(unsigned start, unsigned end)
 	}
 }
 
+static int __init debug_kernel(char *str)
+{
+	console_loglevel = 10;
+	return 0;
+}
+
+early_param("debug", debug_kernel);
+
+static int __init quiet_kernel(char *str)
+{
+	console_loglevel = 4;
+	return 0;
+}
+
+early_param("quiet", quiet_kernel);
+
+static int __init loglevel(char *str)
+{
+	get_option(&str, &console_loglevel);
+	return 0;
+}
+
+early_param("loglevel", loglevel);
+
 static int __read_mostly ignore_loglevel;
 
 static int __init ignore_loglevel_setup(char *str)
