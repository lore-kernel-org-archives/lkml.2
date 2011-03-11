Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410Ab1CKJw2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 04:52:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:38635 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754272Ab1CKJwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 04:52:25 -0500
Date: Fri, 11 Mar 2011 09:52:07 GMT
From: tip-bot for Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fweisbec@gmail.com, yuanhan.liu@linux.intel.com, rostedt@goodmis.org,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yuanhan.liu@linux.intel.com, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <1289196312-25323-1-git-send-email-yuanhan.liu@linux.intel.com>
References: <1289196312-25323-1-git-send-email-yuanhan.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Export trace_set_clr_event()
Message-ID: <tip-56355b83e2a24ce7e1870c8479205e2cdd332225@git.kernel.org>
Git-Commit-ID: 56355b83e2a24ce7e1870c8479205e2cdd332225
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 11 Mar 2011 09:52:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  56355b83e2a24ce7e1870c8479205e2cdd332225
Gitweb:     http://git.kernel.org/tip/56355b83e2a24ce7e1870c8479205e2cdd332225
Author:     Yuanhan Liu <yuanhan.liu@linux.intel.com>
AuthorDate: Mon, 8 Nov 2010 14:05:12 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 10 Mar 2011 10:34:51 -0500

tracing: Export trace_set_clr_event()

Trace events belonging to a module only exists when the module is
loaded. Well, we can use trace_set_clr_event funtion to enable some
trace event at the module init routine, so that we will not miss
something while loading then module.

So, Export the trace_set_clr_event function so that module can use it.

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
LKML-Reference: <1289196312-25323-1-git-send-email-yuanhan.liu@linux.intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index e1d579b..e88f74f 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -325,6 +325,7 @@ int trace_set_clr_event(const char *system, const char *event, int set)
 {
 	return __ftrace_set_clr_event(NULL, system, event, set);
 }
+EXPORT_SYMBOL_GPL(trace_set_clr_event);
 
 /* 128 should be much more than enough */
 #define EVENT_BUF_SIZE		127
