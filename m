Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761448Ab2BOOwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 09:52:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757989Ab2BOOwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 09:52:05 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        paulus@samba.org, acme@ghostprotocols.net, a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, aarapov@redhat.com
Subject: [PATCHv9 0/7] ftrace, perf: Adding support to use function trace
Date: Wed, 15 Feb 2012 15:51:47 +0100
Message-Id: <1329317514-8131-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
here's another version of perf support for function trace
with filter. 

attached patches:
 - 1/7 ftrace: Add enable/disable ftrace_ops control interface
 - 2/7 ftrace, perf: Add open/close tracepoint perf registration actions
 - 3/7 ftrace, perf: Add add/del tracepoint perf registration actions
 - 4/7 ftrace: Add FTRACE_ENTRY_REG macro to allow event registration
 - 5/7 ftrace, perf: Add support to use function tracepoint in perf
 - 6/7 ftrace: Allow to specify filter field type for ftrace events
 - 7/7 ftrace, perf: Add filter support for function trace event

v9 changes:
  fixed patches 5/7 and 7/7 to work with disabled options:
    CONFIG_FUNCTION_TRACER, CONFIG_DYNAMIC_FTRACE

thanks,
jirka
---
 include/linux/ftrace.h             |   77 +++++++++++++-
 include/linux/ftrace_event.h       |    9 ++-
 include/linux/perf_event.h         |    3 +
 kernel/trace/ftrace.c              |  132 ++++++++++++++++++++---
 kernel/trace/trace.h               |   38 +++++--
 kernel/trace/trace_entries.h       |   54 +++++++---
 kernel/trace/trace_event_perf.c    |  208 ++++++++++++++++++++++++++++-------
 kernel/trace/trace_events.c        |   12 ++-
 kernel/trace/trace_events_filter.c |  168 ++++++++++++++++++++++++++++-
 kernel/trace/trace_export.c        |   64 ++++++++----
 kernel/trace/trace_kprobe.c        |    8 ++-
 kernel/trace/trace_syscalls.c      |   18 +++-
 12 files changed, 671 insertions(+), 120 deletions(-)
