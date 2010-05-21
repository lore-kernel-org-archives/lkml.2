Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934086Ab0EURLH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 13:11:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:41403 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758306Ab0EURLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 13:11:01 -0400
Date: Fri, 21 May 2010 17:09:55 GMT
From: tip-bot for Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
       mingo@redhat.com, mathieu.desnoyers@efficios.com, lizf@cn.fujitsu.com,
       peterz@infradead.org, fweisbec@gmail.com, rostedt@goodmis.org,
       hch@lst.de, akpm@linux-foundation.org, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       acme@redhat.com, mathieu.desnoyers@efficios.com, lizf@cn.fujitsu.com,
       peterz@infradead.org, fweisbec@gmail.com, akpm@linux-foundation.org,
       hch@lst.de, rostedt@goodmis.org, tglx@linutronix.de,
       mhiramat@redhat.com, laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <20100430165959.GA25605@Krystal>
References: <20100430165959.GA25605@Krystal>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracepoints: Add check trace callback type
Message-ID: <tip-53da59aa6dd881fd0bbdd058a8a299d90ce9dd1d@git.kernel.org>
Git-Commit-ID: 53da59aa6dd881fd0bbdd058a8a299d90ce9dd1d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 21 May 2010 17:09:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  53da59aa6dd881fd0bbdd058a8a299d90ce9dd1d
Gitweb:     http://git.kernel.org/tip/53da59aa6dd881fd0bbdd058a8a299d90ce9dd1d
Author:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
AuthorDate: Fri, 30 Apr 2010 12:59:59 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 14 May 2010 09:34:26 -0400

tracepoints: Add check trace callback type

This check is meant to be used by tracepoint users which do a direct cast of
callbacks to (void *) for direct registration, thus bypassing the
register_trace_##name and unregister_trace_##name checks.

This permits to ensure that the callback type matches the function type at the
call site, but without generating any code.

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
LKML-Reference: <20100430165959.GA25605@Krystal>
CC: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Li Zefan <lizf@cn.fujitsu.com>
CC: Christoph Hellwig <hch@lst.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/tracepoint.h |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 1d85f9a..8d5e4f6 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -137,9 +137,11 @@ static inline void tracepoint_update_probe_range(struct tracepoint *begin,
 	static inline int unregister_trace_##name(void (*probe)(proto))	\
 	{								\
 		return tracepoint_probe_unregister(#name, (void *)probe);\
+	}								\
+	static inline void check_trace_callback_type_##name(void (*cb)(proto)) \
+	{								\
 	}
 
-
 #define DEFINE_TRACE_FN(name, reg, unreg)				\
 	static const char __tpstrtab_##name[]				\
 	__attribute__((section("__tracepoints_strings"))) = #name;	\
@@ -168,6 +170,9 @@ static inline void tracepoint_update_probe_range(struct tracepoint *begin,
 	static inline int unregister_trace_##name(void (*probe)(proto))	\
 	{								\
 		return -ENOSYS;						\
+	}								\
+	static inline void check_trace_callback_type_##name(void (*cb)(proto)) \
+	{								\
 	}
 
 #define DEFINE_TRACE_FN(name, reg, unreg)
