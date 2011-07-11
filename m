Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab1GKNXJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 09:23:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757288Ab1GKNXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 09:23:07 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org
Subject: [RFC 0/4] trace,perf: Enabling ftrace:function tracepoint for perf
Date: Mon, 11 Jul 2011 15:22:52 +0200
Message-Id: <1310390576-8289-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

attached patches add perf support for function trace.

- Patch 1 adds support to register ftrace:function tracepoint.

- Patch 2 adds a way to used filtering for ip and parent_ip fields.

- Patches 3 and 4 are adding new ioctl to specify the filter on the
  "struct ftrace" level.

  I know this is probably not a good idea, but I dont see a good way
  to combine ftrace_ops filtering with tracepoint filtering other than
  keep them separated.

  My other guess is instead of ioctl use some keyword to specify functions
  followed by standard filter.. something like:

    "FUNCTION_TRACE(sys_open sys_close sys_read) (ip == sys_open)"

  Please take this more as a question about interface than forcing
  new ioctl.. ;)


attached patches:
 - 1/4 perf, ftrace: Add perf support to use function tracepoint
 - 2/4 perf, ftrace: Add filter support
 - 3/4 perf, ftrace: Add new perf ioctl for function trace filter
 - 4/4 perf, ftrace: Add ftrace option for perf stat command


thanks for comments,
jirka
---
 include/linux/ftrace.h             |    7 +-
 include/linux/ftrace_event.h       |    9 +-
 include/linux/perf_event.h         |    2 +
 kernel/events/core.c               |   14 +++
 kernel/trace/ftrace.c              |   34 +++++-
 kernel/trace/trace.h               |    5 +
 kernel/trace/trace_event_perf.c    |  225 +++++++++++++++++++++++++++++-------
 kernel/trace/trace_events.c        |   10 +-
 kernel/trace/trace_events_filter.c |   32 ++++-
 kernel/trace/trace_export.c        |   21 ++++
 kernel/trace/trace_kprobe.c        |    6 +-
 kernel/trace/trace_syscalls.c      |   14 ++-
 tools/perf/builtin-stat.c          |    2 +
 tools/perf/util/evlist.c           |   26 ++++-
 tools/perf/util/evlist.h           |    2 +
 tools/perf/util/evsel.h            |    1 +
 tools/perf/util/parse-events.c     |   37 ++++++-
 tools/perf/util/parse-events.h     |    1 +
 18 files changed, 376 insertions(+), 72 deletions(-)
