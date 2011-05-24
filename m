Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382Ab1EXSRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 14:17:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:58661 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932237Ab1EXSRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 14:17:21 -0400
X-Authority-Analysis: v=1.1 cv=u/eXSd3k4P+OuNmbl5aZU3ellt6eTxbOnGssQLT4hSY= c=1 sm=0 a=vhdKIqpQuCYA:10 a=6ks2GuyAgIwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=9xLNVW9bSdVc-ENLiUMA:9 a=zHPshRwQ30Uu0eO1C0UA:7 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110524181032.382259739@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 24 May 2011 14:10:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 00/12] [GIT PULL][2.6.40/2.8.0/3.0] tracing: clean ups and fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I noticed I had a queue pending for this release that I was waiting
on ACKS on. I received the acks but forgot to push this to you.

I added a couple more fixes (at the end) and ran this through my tests.
This is the last of the patches I have for the merge window. Anything
else will be strictly bug fixes.

I'm hoping to start on libperf.so after this (for 2.6.41 or 2.8.1? or 3.1?)

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/urgent


Jiri Olsa (1):
      jump_label: Check entries limit in __jump_label_update

Masami Hiramatsu (1):
      tracing/kprobes: Fix kprobe-tracer to support stack trace

Rabin Vincent (1):
      ftrace/recordmcount: Avoid STT_FUNC symbols as base on ARM

Rakib Mullick (1):
      x86/ftrace: Fix compiler warning in ftrace.c

Steven Rostedt (6):
      maccess,probe_kernel: Make write/read src const void *
      scripts/tags.sh: Fix ctags for DEFINE_EVENT()
      scripts/tags.sh: Add magic for trace-events for etags too
      ftrace: Have ftrace_startup() return failure code
      tracing: Have event with function tracer check error return
      ftrace: Set ops->flag to enabled even on static function tracing

Vaibhav Nagarnaik (2):
      tracing: Schedule a delayed work to call wakeup()
      tracing: Use NUMA allocation for per-cpu ring buffer pages

----
 arch/blackfin/mm/maccess.c           |    4 +-
 arch/s390/mm/maccess.c               |    4 +-
 arch/x86/kernel/ftrace.c             |   12 +++---
 include/linux/ftrace_event.h         |    4 ++
 include/linux/ring_buffer.h          |    2 +-
 include/linux/uaccess.h              |    8 ++--
 kernel/jump_label.c                  |   18 +++++++---
 kernel/trace/ftrace.c                |   18 ++++++---
 kernel/trace/ring_buffer.c           |   36 ++++++++++---------
 kernel/trace/ring_buffer_benchmark.c |    2 +-
 kernel/trace/trace.c                 |   64 ++++++++++++++++++++++++---------
 kernel/trace/trace.h                 |    9 +++++
 kernel/trace/trace_events.c          |    7 +++-
 kernel/trace/trace_kprobe.c          |    6 ++-
 mm/maccess.c                         |    8 ++--
 scripts/recordmcount.h               |    8 ++++
 scripts/tags.sh                      |    6 ++-
 17 files changed, 145 insertions(+), 71 deletions(-)
