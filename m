Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934123Ab0EURMw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 13:12:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:41498 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933527Ab0EURMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 13:12:50 -0400
Date: Fri, 21 May 2010 17:12:33 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, lizf@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <4BE77C14.5010806@cn.fujitsu.com>
References: <4BE77C14.5010806@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Fix function declarations if !CONFIG_STACKTRACE
Message-ID: <tip-e1f7992e015ae1373d66c8068d0a45e4111a0aed@git.kernel.org>
Git-Commit-ID: e1f7992e015ae1373d66c8068d0a45e4111a0aed
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 21 May 2010 17:12:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e1f7992e015ae1373d66c8068d0a45e4111a0aed
Gitweb:     http://git.kernel.org/tip/e1f7992e015ae1373d66c8068d0a45e4111a0aed
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Mon, 10 May 2010 11:23:00 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 14 May 2010 14:33:24 -0400

tracing: Fix function declarations if !CONFIG_STACKTRACE

ftrace_trace_stack() and frace_trace_userstacke() take a
struct ring_buffer argument, not struct trace_array. Commit
e77405ad("tracing: pass around ring buffer instead of tracer")
made this change.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4BE77C14.5010806@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 6356259..40cd171 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -419,12 +419,12 @@ void ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags,
 void __trace_stack(struct trace_array *tr, unsigned long flags, int skip,
 		   int pc);
 #else
-static inline void ftrace_trace_stack(struct trace_array *tr,
+static inline void ftrace_trace_stack(struct ring_buffer *buffer,
 				      unsigned long flags, int skip, int pc)
 {
 }
 
-static inline void ftrace_trace_userstack(struct trace_array *tr,
+static inline void ftrace_trace_userstack(struct ring_buffer *buffer,
 					  unsigned long flags, int pc)
 {
 }
