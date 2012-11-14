Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab2KNGwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:52:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43386 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992Ab2KNGv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 01:51:58 -0500
Date: Tue, 13 Nov 2012 22:51:40 -0800
From: tip-bot for Michal Hocko <mhocko@suse.cz>
Message-ID: <tip-60efc15ae96c7aace8060411b0d5add20e1ab21e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, mhocko@suse.cz
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, mhocko@suse.cz
In-Reply-To: <1351172511-18125-1-git-send-email-mhocko@suse.cz>
References: <1351172511-18125-1-git-send-email-mhocko@suse.cz>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] linux/kernel.h:
  Remove duplicate trace_printk declaration
Git-Commit-ID: 60efc15ae96c7aace8060411b0d5add20e1ab21e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 22:51:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  60efc15ae96c7aace8060411b0d5add20e1ab21e
Gitweb:     http://git.kernel.org/tip/60efc15ae96c7aace8060411b0d5add20e1ab21e
Author:     Michal Hocko <mhocko@suse.cz>
AuthorDate: Thu, 25 Oct 2012 15:41:51 +0200
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 31 Oct 2012 16:46:37 -0400

linux/kernel.h: Remove duplicate trace_printk declaration

!CONFIG_TRACING both declares and defines (empty) trace_printk.
The first one is not redundant so it can be removed.

Link: http://lkml.kernel.org/r/1351172511-18125-1-git-send-email-mhocko@suse.cz

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/kernel.h |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index a123b13..7785d5d 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -527,9 +527,6 @@ __ftrace_vprintk(unsigned long ip, const char *fmt, va_list ap);
 
 extern void ftrace_dump(enum ftrace_dump_mode oops_dump_mode);
 #else
-static inline __printf(1, 2)
-int trace_printk(const char *fmt, ...);
-
 static inline void tracing_start(void) { }
 static inline void tracing_stop(void) { }
 static inline void ftrace_off_permanent(void) { }
@@ -539,8 +536,8 @@ static inline void tracing_on(void) { }
 static inline void tracing_off(void) { }
 static inline int tracing_is_on(void) { return 0; }
 
-static inline int
-trace_printk(const char *fmt, ...)
+static inline __printf(1, 2)
+int trace_printk(const char *fmt, ...)
 {
 	return 0;
 }
