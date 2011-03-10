Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705Ab1CJP7M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 10:59:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:57628 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab1CJP7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 10:59:10 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=-OOBIrKiCbIA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=VC6-7KfeeH6L4JwG_c4A:9 a=NAk796hwdnYLlJnqKvAA:7 a=ppEIdJjX0bzSEbCuedobSoNk-c0A:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110310155800.478792851@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 10 Mar 2011 10:58:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 00/15] [GIT PULL] tracing: updates for 2.6.39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/perf/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/core


David Sharp (8):
      tracing: Add an 'overwrite' trace_option.
      ring-buffer: Remove unused #include <linux/trace_irq.h>
      tracing: Fix event alignment: ftrace:context_switch and ftrace:wakeup
      tracing: Fix event alignment: module:module_request
      tracing: Fix event alignment: kvm:kvm_hv_hypercall
      tracing: Fix event alignment: mce:mce_record
      tracing: Fix event alignment: skb:kfree_skb
      tracing: Adjust conditional expression latency formatting.

Jiri Olsa (1):
      tracing: Explain about unstable clock on resume with ring buffer warning

Steven Rostedt (5):
      tracing: Remove lock_depth from event entry
      ftrace: Add .ref.text as one of the safe areas to trace
      ftrace/graph: Trace function entry before updating index
      tracing: Align 4 byte ints together in struct tracer
      tracing: Fix irqoff selftest expanding max buffer

Yuanhan Liu (1):
      tracing: Export trace_set_clr_event()

----
 Documentation/trace/ftrace.txt |    5 +++++
 arch/x86/kernel/ftrace.c       |   15 ++++++++-------
 arch/x86/kvm/trace.h           |    8 ++++----
 include/linux/ftrace_event.h   |    1 -
 include/linux/ring_buffer.h    |    2 ++
 include/trace/events/mce.h     |    8 ++++----
 include/trace/events/module.h  |    5 ++---
 include/trace/events/skb.h     |    4 ++--
 kernel/trace/ring_buffer.c     |   24 +++++++++++++++++++++---
 kernel/trace/trace.c           |   34 +++++++++++++++++++++++-----------
 kernel/trace/trace.h           |    3 ++-
 kernel/trace/trace_entries.h   |    6 +++---
 kernel/trace/trace_events.c    |    2 +-
 kernel/trace/trace_output.c    |   36 ++++++++++++++++++++----------------
 scripts/recordmcount.c         |    3 ++-
 scripts/recordmcount.pl        |    1 +
 16 files changed, 100 insertions(+), 57 deletions(-)
