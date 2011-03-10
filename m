Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab1CJQC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 11:02:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:57628 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab1CJP7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 10:59:12 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=J1Z4frUYFuoA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1XWaLZrsAAAA:8 a=meVymXHHAAAA:8 a=Ri8dEQlOvTb3_SfG2pMA:9 a=Ty9kcH92wbIvoKtv5QddnuFDJqMA:4 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110310155909.977480208@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 10 Mar 2011 10:58:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Sharp <dhsharp@google.com>
Subject: [PATCH 04/15] tracing: Fix event alignment: ftrace:context_switch and ftrace:wakeup
References: <20110310155800.478792851@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-Fix-event-alignment-ftrace-context_switch-an.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Sharp <dhsharp@google.com>

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
 
-- 
1.7.2.3


