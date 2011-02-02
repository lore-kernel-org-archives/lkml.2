Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab1BBSJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 13:09:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:37883 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709Ab1BBSJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 13:09:40 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=AJNahVAuRqUA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=4b2RG7byHm8dx53wxTQA:9 a=H-IYbJz2KCFcKHArljPfYU8UHQkA:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110202180613.978219945@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 02 Feb 2011 13:06:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 0/2] [GIT PULL][v2.6.38]: tracing: alignment fixes (take 2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

OK, this time I ran this under x86_64 and x86_32 with gcc-4.5.1
and gcc-4.4.5. It even found a bug, that I had to fix and retest.

Mathieu,

Can you review your patch, as it had some conflicts (Ingo removed
the other broken patch set which you based this on). Just make sure
that I didn't screw anything up.

David,

Can you test this on sparc?

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/urgent


Mathieu Desnoyers (1):
      Tracepoints: Fix section alignment using pointer array

Steven Rostedt (1):
      tracing: Replace trace_event struct array with pointer array

----
 include/asm-generic/vmlinux.lds.h |   15 ++++++++-------
 include/linux/module.h            |    4 ++--
 include/linux/syscalls.h          |   10 ++++++----
 include/linux/tracepoint.h        |   35 ++++++++++++++++++++---------------
 include/trace/ftrace.h            |   24 +++++++++++++-----------
 kernel/module.c                   |   16 ++++++++--------
 kernel/trace/trace_events.c       |   12 ++++++------
 kernel/trace/trace_export.c       |    6 +++---
 kernel/tracepoint.c               |   31 ++++++++++++++++---------------
 9 files changed, 82 insertions(+), 71 deletions(-)
