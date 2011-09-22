Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab1IVWKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 18:10:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61611 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158Ab1IVWK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 18:10:27 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=vhdKIqpQuCYA:10 a=nUrvXaxooO4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=VwQbUJbxAAAA:8 a=NEAV23lmAAAA:8 a=XlA4D2BAbLdS7X0Q1DEA:9 a=U62fhAwekXMA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Message-Id: <20110922220935.537134016@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 22 Sep 2011 18:09:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 00/21] [GIT PULL][v3.2] tracing: queued up stuff waiting for k.org to come back on line
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I've had lots of these patches for a while now and was holding off
till kernel.org became back on line. But that is taking much longer
than I expected, and the patches are starting to build up even though
I've been working more on -rt lately. I may start working on mainline
again soon so need to get rid of the queue I currently have.

Sorry for the big patch set, but it is really more a bunch of smaller
patch sets that have accumulated.

I bit the bullet and created a github account. You can pull from that
for now.

Thanks!

-- Steve

Please pull the latest tip/perf/core tree, which can be found at:

  git://github.com/rostedt/linux.git
tip/perf/core

Head SHA1: 963616e48ea9cf58a1c3217457612cfa2be70b2c


Jiri Olsa (10):
      tracing/filter: Use static allocation for filter predicates
      tracing/filter: Separate predicate init and filter addition
      tracing/filter: Remove field_name from filter_pred struct
      tracing/filter: Simplify tracepoint event lookup
      tracing/filter: Unify predicate tree walking, change check_pred_tree function to use it
      tracing/filter: Change count_leafs function to use walk_pred_tree
      tracing/filter: Change fold_pred_tree function to use walk_pred_tree
      tracing/filter: Change fold_pred function to use walk_pred_tree
      tracing/filter: Change filter_match_preds function to use walk_pred_tree
      tracing/filter: Add startup tests for events filter

Kevin Winchester (1):
      x86: jump_label: arch_jump_label_text_poke_early: add missing __init

Mathieu Desnoyers (1):
      Tracepoint: Dissociate from module mutex

Steven Rostedt (7):
      tracing: Clean up tb_fmt to not give faulty compile warning
      tracing: Add preempt disable for filter self test
      tracing: Add a counter clock for those that do not trust clocks
      tracing: Fix preemptirqsoff tracer to not stop at preempt off
      tracing: Account for preempt off in preempt_schedule()
      tracing: Do not allocate buffer for trace_marker
      tracing: Add optional percpu buffers for trace_printk()

Vaibhav Nagarnaik (2):
      trace: Add a new readonly entry to report total buffer size
      trace: Add ring buffer stats to measure rate of events

----
 Documentation/kernel-parameters.txt     |   11 +
 arch/x86/kernel/jump_label.c            |    2 +-
 include/linux/module.h                  |   12 -
 include/linux/ring_buffer.h             |    2 +
 include/linux/trace_clock.h             |    1 +
 include/linux/tracepoint.h              |   25 +-
 kernel/module.c                         |   47 --
 kernel/sched.c                          |    9 +
 kernel/trace/Makefile                   |    2 +
 kernel/trace/ring_buffer.c              |   70 +++-
 kernel/trace/trace.c                    |  183 ++++++-
 kernel/trace/trace.h                    |   15 +-
 kernel/trace/trace_clock.c              |   12 +
 kernel/trace/trace_events_filter.c      |  795 ++++++++++++++++++-------------
 kernel/trace/trace_events_filter_test.h |   50 ++
 kernel/trace/trace_irqsoff.c            |    4 +-
 kernel/trace/trace_printk.c             |   19 +-
 kernel/tracepoint.c                     |  169 ++++++-
 18 files changed, 953 insertions(+), 475 deletions(-)
