Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab1K0SEo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 13:04:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab1K0SEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 13:04:43 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        paulus@samba.org, acme@ghostprotocols.net
Cc: linux-kernel@vger.kernel.org
Subject: [RFC] ftrace, perf: Adding support to use function trace
Date: Sun, 27 Nov 2011 19:04:25 +0100
Message-Id: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
here's another version of perf support for function trace
with filter. The changeset is working and hopefully is not
introducing more bugs.. ;) still testing.

Patch 1 through 3 could be probably taken separately as they
fix independent issues. The rest is specific to the perf
function tracing.

I needed a way to temporarily enable/disable ftrace_ops based
on the event in/out scheduling, patch 4/9 is introducing that.
Not sure this is the best way though..

Also adding open/close, add/del registration actions for
tracepoint (patches 5,6) to have suitable place to control
the function trace.

Patch 7 enables the function event perf registration,
and patches 8 and 9 add filter support.

attached patches:
- 1/9 trace: Fix uninitialized variable compiler warning
- 2/9 ftrace: Fix possible NULL dereferencing in __ftrace_hash_rec_update
- 3/9 ftrace: Fix shutdown to disable calls properly
- 4/9 ftrace: Add enable/disable ftrace_ops control interface
- 5/9 ftrace, perf: Add open/close tracepoint perf registration actions
- 6/9 ftrace, perf: Add add/del tracepoint perf registration actions
- 7/9 ftrace, perf: Add support to use function tracepoint in perf
- 8/9 ftrace, perf: Add FILTER_TRACE_FN event field type
- 9/9 ftrace, perf: Add filter support for function trace event

thanks for comments,
jirka
---
 include/linux/ftrace.h             |   12 ++
 include/linux/ftrace_event.h       |    9 ++-
 include/linux/perf_event.h         |    3 +
 kernel/trace/ftrace.c              |   45 ++++++---
 kernel/trace/trace.c               |    3 +-
 kernel/trace/trace.h               |    9 ++-
 kernel/trace/trace_event_perf.c    |  208 ++++++++++++++++++++++++++++-------
 kernel/trace/trace_events.c        |   12 ++-
 kernel/trace/trace_events_filter.c |  114 ++++++++++++++++++--
 kernel/trace/trace_export.c        |   53 ++++++++-
 kernel/trace/trace_kprobe.c        |    8 ++-
 kernel/trace/trace_syscalls.c      |   18 +++-
 12 files changed, 413 insertions(+), 81 deletions(-)
