Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598Ab0DADSZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 23:18:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61807 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab0DADSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 23:18:20 -0400
X-Authority-Analysis: v=1.1 cv=3DUlJUu7qWFNpNttJVwyA1nQS84iC7EN/BDLX6qJweI= c=1 sm=0 a=vPnlRXC0CbEA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VwQbUJbxAAAA:8 a=xLu7a0G5PGjQgG6sOSIA:9 a=j3-Q1QEYcA1dO4EzX6I4X3_X4aEA:4 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100401031735.683626160@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 31 Mar 2010 23:17:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/7] [GIT PULL] tracing: updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core


Li Zefan (3):
      tracing: Convert some signal events to DEFINE_TRACE
      tracing: Update comments
      tracing: Remove side effect from module tracepoints that caused a GPF

Steven Rostedt (4):
      tracing: Fix compile error in module tracepoints when MODULE_UNLOAD not set
      ring-buffer: Add place holder recording of dropped events
      tracing: Show the lost events in the trace_pipe output
      ring-buffer: Add lost event count to end of sub buffer

----
 drivers/oprofile/cpu_buffer.c        |    4 +-
 include/linux/ftrace_event.h         |    1 +
 include/linux/module.h               |    6 +-
 include/linux/ring_buffer.h          |    6 +-
 include/trace/events/module.h        |   18 ++++--
 include/trace/events/signal.h        |   52 +++++++----------
 include/trace/ftrace.h               |   33 ++++++-----
 kernel/module.c                      |    8 +-
 kernel/trace/ring_buffer.c           |  101 ++++++++++++++++++++++++++++++++--
 kernel/trace/ring_buffer_benchmark.c |    2 +-
 kernel/trace/trace.c                 |   30 +++++++---
 kernel/trace/trace_functions_graph.c |    5 +-
 kernel/trace/trace_selftest.c        |    2 +-
 13 files changed, 187 insertions(+), 81 deletions(-)
