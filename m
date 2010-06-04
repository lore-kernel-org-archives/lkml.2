Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab0FDBgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 21:36:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:51297 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756995Ab0FDBf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 21:35:59 -0400
X-Authority-Analysis: v=1.1 cv=5G9p81xpkHsraAUxe1ju6fFDddHe91pyvlbJxvA2HJk= c=1 sm=0 a=dh3EajZK9uUA:10 a=uEzv4HemXiYA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VwQbUJbxAAAA:8 a=2uQzs01bJdAmVDk6kf4A:9 a=2oz5gkZA3qBO2GfXqlbhdfKjcL0A:4 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100604013506.159506222@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 03 Jun 2010 21:35:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/2] [GIT PULL] tracing: removal of ftrace_preempt_disable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

This bug has been around for a while, and it only causes
missed preemption checks (nothing to crash the kernel). This can
wait till 2.6.36.

Please pull the latest tip/perf/core-3 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/core-3


Steven Rostedt (2):
      tracing/sched: Make preempt_schedule() notrace
      tracing: Remove ftrace_preempt_disable/enable

----
 kernel/sched.c                    |    6 ++--
 kernel/trace/ftrace.c             |    5 +--
 kernel/trace/ring_buffer.c        |   38 ++++++-----------------------
 kernel/trace/trace.c              |    5 +--
 kernel/trace/trace.h              |   48 -------------------------------------
 kernel/trace/trace_clock.c        |    5 +--
 kernel/trace/trace_events.c       |    5 +--
 kernel/trace/trace_functions.c    |    6 ++--
 kernel/trace/trace_sched_wakeup.c |    5 +--
 kernel/trace/trace_stack.c        |    6 ++--
 10 files changed, 27 insertions(+), 102 deletions(-)
