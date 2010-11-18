Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab0KRBeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 20:34:15 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39853 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab0KRBcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 20:32:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=RKDHmJkxoaT3RQvqjbXtNlvALQzhxEkjboVl9J4VrZzW4NILz5eAU2MgnsXcA12asa
         kIj9s2v0fGHYFZSJmplCaQqiz656tdxGV+EPrtzfWnb8K31cknNbeGnG4ctkYDpfh0O3
         Ctyh4LtWQ3CZGhxSiDfzzmTnpCZGiCtp1ge5c=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Jason Baron <jbaron@redhat.com>
Subject: [PATCH 3/5] tracing: Allow raw syscall trace events for non privileged users
Date: Thu, 18 Nov 2010 02:32:41 +0100
Message-Id: <1290043963-1480-4-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1290043963-1480-1-git-send-regression-fweisbec@gmail.com>
References: <1290043963-1480-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows non privileged users to use the raw syscall trace events
for task bound tracing in perf.

It is safe because raw syscall trace events don't leak system wide
informations.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jason Baron <jbaron@redhat.com>
---
 include/trace/events/syscalls.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/syscalls.h b/include/trace/events/syscalls.h
index fb726ac..5a4c04a 100644
--- a/include/trace/events/syscalls.h
+++ b/include/trace/events/syscalls.h
@@ -40,6 +40,8 @@ TRACE_EVENT_FN(sys_enter,
 	syscall_regfunc, syscall_unregfunc
 );
 
+TRACE_EVENT_FLAGS(sys_enter, TRACE_EVENT_FL_CAP_ANY)
+
 TRACE_EVENT_FN(sys_exit,
 
 	TP_PROTO(struct pt_regs *regs, long ret),
@@ -62,6 +64,8 @@ TRACE_EVENT_FN(sys_exit,
 	syscall_regfunc, syscall_unregfunc
 );
 
+TRACE_EVENT_FLAGS(sys_exit, TRACE_EVENT_FL_CAP_ANY)
+
 #endif /* CONFIG_HAVE_SYSCALL_TRACEPOINTS */
 
 #endif /* _TRACE_EVENTS_SYSCALLS_H */
-- 
1.6.2.3

