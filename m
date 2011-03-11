Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab1CKJs7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 04:48:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:46068 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778Ab1CKJs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 04:48:56 -0500
Date: Fri, 11 Mar 2011 09:48:37 GMT
From: tip-bot for David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, dhsharp@google.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, dhsharp@google.com, tglx@linutronix.de
In-Reply-To: <1291421609-14665-6-git-send-email-dhsharp@google.com>
References: <1291421609-14665-6-git-send-email-dhsharp@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Fix event alignment: ftrace:context_switch and ftrace:wakeup
Message-ID: <tip-140e4f2d1cd816aed196705c036763313c0e4bd3@git.kernel.org>
Git-Commit-ID: 140e4f2d1cd816aed196705c036763313c0e4bd3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 11 Mar 2011 09:48:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  140e4f2d1cd816aed196705c036763313c0e4bd3
Gitweb:     http://git.kernel.org/tip/140e4f2d1cd816aed196705c036763313c0e4bd3
Author:     David Sharp <dhsharp@google.com>
AuthorDate: Fri, 3 Dec 2010 16:13:19 -0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 10 Mar 2011 10:34:16 -0500

tracing: Fix event alignment: ftrace:context_switch and ftrace:wakeup

Signed-off-by: David Sharp <dhsharp@google.com>
LKML-Reference: <1291421609-14665-6-git-send-email-dhsharp@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_entries.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_entries.h b/kernel/trace/trace_entries.h
index 6cf2237..1516cb3 100644
--- a/kernel/trace/trace_entries.h
+++ b/kernel/trace/trace_entries.h
@@ -109,12 +109,12 @@ FTRACE_ENTRY(funcgraph_exit, ftrace_graph_ret_entry,
  */
 #define FTRACE_CTX_FIELDS					\
 	__field(	unsigned int,	prev_pid	)	\
+	__field(	unsigned int,	next_pid	)	\
+	__field(	unsigned int,	next_cpu	)       \
 	__field(	unsigned char,	prev_prio	)	\
 	__field(	unsigned char,	prev_state	)	\
-	__field(	unsigned int,	next_pid	)	\
 	__field(	unsigned char,	next_prio	)	\
-	__field(	unsigned char,	next_state	)	\
-	__field(	unsigned int,	next_cpu	)
+	__field(	unsigned char,	next_state	)
 
 FTRACE_ENTRY(context_switch, ctx_switch_entry,
 
