Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab2BQNup (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 08:50:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40150 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab2BQNun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 08:50:43 -0500
Date: Fri, 17 Feb 2012 05:50:04 -0800
From: tip-bot for Geunsik Lim <geunsik.lim@samsung.com>
Message-ID: <tip-1e42e83fde5537266c1d1e7fd8c010b3028d50fc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, geunsik.lim@samsung.com, rdunlap@xenotime.net,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        geunsik.lim@samsung.com, rostedt@goodmis.org, tglx@linutronix.de,
        rdunlap@xenotime.net
In-Reply-To: <1328695537-15081-1-git-send-email-geunsik.lim@gmail.com>
References: <1328695537-15081-1-git-send-email-geunsik.lim@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ftrace: sched_switch plugin is deprecated
Git-Commit-ID: 1e42e83fde5537266c1d1e7fd8c010b3028d50fc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 17 Feb 2012 05:50:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1e42e83fde5537266c1d1e7fd8c010b3028d50fc
Gitweb:     http://git.kernel.org/tip/1e42e83fde5537266c1d1e7fd8c010b3028d50fc
Author:     Geunsik Lim <geunsik.lim@samsung.com>
AuthorDate: Wed, 8 Feb 2012 19:05:36 +0900
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 13 Feb 2012 09:14:47 -0500

ftrace: sched_switch plugin is deprecated

Actually, sched_switch function tracer is merged into wakeup/wakeup_rt
Update 'mini-HOWTO' for ftrace(Kernel function tracer).
If we want to trace "sched:sched_switch" to trace sched_switch func,
We may utilize event option.(e.g: trace-cmd list -e | grep sched)
This patch is based on Linux-3.3.rc2-SMP-PREEMPT

Link: http://lkml.kernel.org/r/1328695537-15081-1-git-send-email-geunsik.lim@gmail.com

Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a3f1bc5..10d5503 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2764,12 +2764,12 @@ static const char readme_msg[] =
 	"tracing mini-HOWTO:\n\n"
 	"# mount -t debugfs nodev /sys/kernel/debug\n\n"
 	"# cat /sys/kernel/debug/tracing/available_tracers\n"
-	"wakeup preemptirqsoff preemptoff irqsoff function sched_switch nop\n\n"
+	"wakeup wakeup_rt preemptirqsoff preemptoff irqsoff function nop\n\n"
 	"# cat /sys/kernel/debug/tracing/current_tracer\n"
 	"nop\n"
-	"# echo sched_switch > /sys/kernel/debug/tracing/current_tracer\n"
+	"# echo wakeup > /sys/kernel/debug/tracing/current_tracer\n"
 	"# cat /sys/kernel/debug/tracing/current_tracer\n"
-	"sched_switch\n"
+	"wakeup\n"
 	"# cat /sys/kernel/debug/tracing/trace_options\n"
 	"noprint-parent nosym-offset nosym-addr noverbose\n"
 	"# echo print-parent > /sys/kernel/debug/tracing/trace_options\n"
