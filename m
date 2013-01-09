Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207Ab3AIXKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 18:10:53 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:31010 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758177Ab3AIXKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 18:10:46 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, rostedt@goodmis.org,
        fweisbec@gmail.com, rusty@rustcorp.com.au, ananth@in.ibm.com,
        anil.s.keshavamurthy@intel.com, masami.hiramatsu.pt@hitachi.com,
        jbaron@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 5/5] ftrace: constify ftrace_text_reserved
Date: Wed,  9 Jan 2013 18:09:20 -0500
Message-Id: <1357772960-4436-5-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1357772960-4436-1-git-send-email-sasha.levin@oracle.com>
References: <1357772960-4436-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 include/linux/ftrace.h | 4 ++--
 kernel/trace/ftrace.c  | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 92691d8..cbd927f 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -277,7 +277,7 @@ extern void
 unregister_ftrace_function_probe_func(char *glob, struct ftrace_probe_ops *ops);
 extern void unregister_ftrace_function_probe_all(char *glob);
 
-extern int ftrace_text_reserved(void *start, void *end);
+extern int ftrace_text_reserved(const void *start, const void *end);
 
 extern int ftrace_nr_registered_ops(void);
 
@@ -534,7 +534,7 @@ static inline int unregister_ftrace_command(char *cmd_name)
 {
 	return -EINVAL;
 }
-static inline int ftrace_text_reserved(void *start, void *end)
+static inline int ftrace_text_reserved(const void *start, const void *end)
 {
 	return 0;
 }
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 3ffe4c5..4ecdcf8 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1469,7 +1469,7 @@ unsigned long ftrace_location(unsigned long ip)
  * the function tracer. It checks the ftrace internal tables to
  * determine if the address belongs or not.
  */
-int ftrace_text_reserved(void *start, void *end)
+int ftrace_text_reserved(const void *start, const void *end)
 {
 	unsigned long ret;
 
-- 
1.8.1

