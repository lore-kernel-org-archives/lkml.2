Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab0IWMBB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 08:01:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561Ab0IWMBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 08:01:00 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCHv2 0/3] tracing: function graph output for wakeup tracer
Date: Thu, 23 Sep 2010 14:00:50 +0200
Message-Id: <1285243253-7372-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

adding function graph output to irqsoff tracer.
The graph output is enabled by setting new 'display-graph'
trace option.

The v2 updates are based on comments by Frederic Weisbecker
and Steven Rostedt, also rebased to latest master.


v2:
- librarized common functions from irqs/preemptoff tracers
- using local_save_flags instead disabling irqs to get the flags
  in wakeup_graph_return/wakeup_graph_entry


attached patches:
- 1/3 proper check for irq_depth routines
- 2/3 librarize graph related irqs/preempts off calls
- 3/3 graph support for wakeup tracer


plz let me know what you think

wbr,
jirka
---
 kernel/trace/trace.h                 |    4 +
 kernel/trace/trace_functions_graph.c |   87 ++++++++++++-
 kernel/trace/trace_irqsoff.c         |   56 +-------
 kernel/trace/trace_sched_wakeup.c    |  231 ++++++++++++++++++++++++++++++++--
 4 files changed, 312 insertions(+), 66 deletions(-)
