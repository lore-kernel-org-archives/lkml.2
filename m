Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab1LUS4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 13:56:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418Ab1LUS4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 13:56:43 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        paulus@samba.org, acme@ghostprotocols.net, a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, aarapov@redhat.com
Subject: [PATCHv4 0/8] ftrace, perf: Adding support to use function trace
Date: Wed, 21 Dec 2011 19:56:24 +0100
Message-Id: <1324493791-5688-1-git-send-email-jolsa@redhat.com>
In-Reply-To: <1324468136-3997-1-git-send-email-jolsa@redhat.com>
References: <1324468136-3997-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
here's another version of perf support for function trace
with filter. 

attached patches:
  1/7 ftrace: Change filter/notrace set functions to return exit code
  2/7 ftrace: Add enable/disable ftrace_ops control interface
  3/7 ftrace, perf: Add open/close tracepoint perf registration actions
  4/7 ftrace, perf: Add add/del tracepoint perf registration actions
  5/7 ftrace, perf: Add support to use function tracepoint in perf
  6/7 ftrace, perf: Distinguish ftrace function event field type
  7/7 ftrace, perf: Add filter support for function trace event

v4 changes:
  2/7 - FL_GLOBAL_CONTROL changed to FL_GLOBAL_CONTROL_MASK
      - changed WARN_ON_ONCE() to include the !preempt_count()
      - changed this_cpu_ptr to per_cpu_ptr

  ommited Fix possible NULL dereferencing in __ftrace_hash_rec_update
  (2/8 in v3)

v3 changes:
  3/8 - renamed __add/remove_ftrace_ops
      - fixed preemtp_enable/recursion_clear order in ftrace_ops_control_func 
      - renamed/commented API functions -  enable/disable_ftrace_function
  
  ommited graph tracer workarounf patch 10/10  

v2 changes:
 01/10 - keeping the old fix instead of adding hash_has_contents func
         I'll send separating patchset for this
 02/10 - using different way to avoid the issue (3/9 in v1)
 03/10 - using the way proposed by Steven for controling ftrace_ops
         (4/9 in v1)
 06/10 - added check ensuring the ftrace:function event could be used by
         root only (7/9 in v1)
 08/10 - added more description (8/9 in v1)
 09/10 - changed '&&' operator to '||' which seems more suitable
         in this case (9/9 in v1)

thanks,
jirka
---
 include/linux/ftrace.h             |   46 ++++++++-
 include/linux/ftrace_event.h       |    9 +-
 include/linux/perf_event.h         |    3 +
 kernel/trace/ftrace.c              |  135 +++++++++++++++++++++--
 kernel/trace/trace.h               |   11 ++-
 kernel/trace/trace_event_perf.c    |  212 +++++++++++++++++++++++++++++-------
 kernel/trace/trace_events.c        |   12 ++-
 kernel/trace/trace_events_filter.c |  116 ++++++++++++++++++-
 kernel/trace/trace_export.c        |   53 ++++++++-
 kernel/trace/trace_kprobe.c        |    8 +-
 kernel/trace/trace_syscalls.c      |   18 +++-
 11 files changed, 542 insertions(+), 81 deletions(-)
