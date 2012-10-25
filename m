Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965644Ab2JYNmD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 09:42:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43787 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965376Ab2JYNl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 09:41:59 -0400
From: Michal Hocko <mhocko@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Joe Perches <joe@perches.com>
Subject: [PATCH] linux/kernel.h: remove duplicate trace_printk declaration
Date: Thu, 25 Oct 2012 15:41:51 +0200
Message-Id: <1351172511-18125-1-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

!CONFIG_TRACING both declares and defines (empty) trace_printk.
The first one is not redundant so it can be removed.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 include/linux/kernel.h |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 594b419..c56e425 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -535,9 +535,6 @@ __ftrace_vprintk(unsigned long ip, const char *fmt, va_list ap);
 
 extern void ftrace_dump(enum ftrace_dump_mode oops_dump_mode);
 #else
-static inline __printf(1, 2)
-int trace_printk(const char *fmt, ...);
-
 static inline void tracing_start(void) { }
 static inline void tracing_stop(void) { }
 static inline void ftrace_off_permanent(void) { }
@@ -547,8 +544,8 @@ static inline void tracing_on(void) { }
 static inline void tracing_off(void) { }
 static inline int tracing_is_on(void) { return 0; }
 
-static inline int
-trace_printk(const char *fmt, ...)
+static inline __printf(1, 2)
+int trace_printk(const char *fmt, ...)
 {
 	return 0;
 }
-- 
1.7.10.4

