Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737Ab0IRPxk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 11:53:40 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:55044 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391Ab0IRPxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 11:53:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JP8lrAMNWDDyEfgdkA/zwnqI1sj3XUajkGD62PPTHeCTsclM0pjd+cyEdLygGKqKjt
         rLY4DcMlFoNKj7e5krw/sY5CoHsODfT5ZC26q0LN7cm67VJ5fPOcvBgoLd90MRGobTV5
         SIWsUzHsPZ+AQT0Kv85raA4KBzjxJmTsC6QF8=
From: Namhyung Kim <namhyung@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] printk: Declare printk_ratelimit_state in ratelimit.h
Date: Sun, 19 Sep 2010 00:53:02 +0900
Message-Id: <1284825182-32588-5-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1284825182-32588-1-git-send-email-namhyung@gmail.com>
References: <1284825182-32588-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding declaration of printk_ratelimit_state in ratelimit.h removes
potential build breakage and following sparse warning:

 kernel/printk.c:1426:1: warning: symbol 'printk_ratelimit_state' was not declared. Should it be static?

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 include/linux/ratelimit.h |    4 ++++
 kernel/sysctl.c           |    2 --
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/ratelimit.h b/include/linux/ratelimit.h
index 8f69d09..55e1bbc 100644
--- a/include/linux/ratelimit.h
+++ b/include/linux/ratelimit.h
@@ -36,6 +36,10 @@ static inline void ratelimit_state_init(struct ratelimit_state *rs,
 	rs->begin = 0;
 }
 
+#ifdef CONFIG_PRINTK
+extern struct ratelimit_state printk_ratelimit_state;
+#endif
+
 extern int ___ratelimit(struct ratelimit_state *rs, const char *func);
 #define __ratelimit(state) ___ratelimit(state, __func__)
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index f88552c..720ab2b 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -161,8 +161,6 @@ extern int no_unaligned_warning;
 extern int unaligned_dump_stack;
 #endif
 
-extern struct ratelimit_state printk_ratelimit_state;
-
 #ifdef CONFIG_PROC_SYSCTL
 static int proc_do_cad_pid(struct ctl_table *table, int write,
 		  void __user *buffer, size_t *lenp, loff_t *ppos);
-- 
1.7.0.4

