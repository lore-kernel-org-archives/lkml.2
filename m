Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848Ab2HUPNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:13:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59453 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227Ab2HUPMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:12:52 -0400
Date: Tue, 21 Aug 2012 08:12:38 -0700
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-4dc936769e8a6382a4cc12375e8a4daa2b829fda@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de
In-Reply-To: <20120612225426.961092717@goodmis.org>
References: <20120612225426.961092717@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ftrace: Make ftrace_location()
  a nop on !DYNAMIC_FTRACE
Git-Commit-ID: 4dc936769e8a6382a4cc12375e8a4daa2b829fda
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:12:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4dc936769e8a6382a4cc12375e8a4daa2b829fda
Gitweb:     http://git.kernel.org/tip/4dc936769e8a6382a4cc12375e8a4daa2b829fda
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Wed, 6 Jun 2012 13:45:31 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 31 Jul 2012 10:29:57 -0400

ftrace: Make ftrace_location() a nop on !DYNAMIC_FTRACE

When CONFIG_DYNAMIC_FTRACE is not set, ftrace_location() is not defined.
If a user (like kprobes) references this function, it will break
the compile when CONFIG_DYNAMIC_FTRACE is not set.

Add ftrace_location() as a nop (return 0) when DYNAMIC_FTRACE
is not defined.

Link: http://lkml.kernel.org/r/20120612225426.961092717@goodmis.org

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 3e71112..a52f2f4 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -520,7 +520,7 @@ extern int skip_trace(unsigned long ip);
 
 extern void ftrace_disable_daemon(void);
 extern void ftrace_enable_daemon(void);
-#else
+#else /* CONFIG_DYNAMIC_FTRACE */
 static inline int skip_trace(unsigned long ip) { return 0; }
 static inline int ftrace_force_update(void) { return 0; }
 static inline void ftrace_disable_daemon(void) { }
@@ -538,6 +538,10 @@ static inline int ftrace_text_reserved(void *start, void *end)
 {
 	return 0;
 }
+static inline unsigned long ftrace_location(unsigned long ip)
+{
+	return 0;
+}
 
 /*
  * Again users of functions that have ftrace_ops may not
