Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab1ESCM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 22:12:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:42133 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755774Ab1ESCMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 22:12:55 -0400
X-Authority-Analysis: v=1.1 cv=ou1QuR4lBR9YeJgEH9ccYmbAdaWqVVq3lOvCKJtMpGM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=JvHnLcn6QEkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=uGhq8XEZL_EnftAQQogA:9 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110519021151.600991800@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 18 May 2011 22:11:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 00/13] [GIT PULL] ftrace: Allow function tracer to be used by multiple clients
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/perf/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/core


Steven Rostedt (13):
      ftrace: Replace FTRACE_FL_NOTRACE flag with a hash of ignored functions
      ftrace: Use hash instead for FTRACE_FL_FILTER
      ftrace: Create a global_ops to hold the filter and notrace hashes
      ftrace: Separate hash allocation and assignment
      ftrace: Use counters to enable functions to trace
      ftrace: Add enabled_functions file
      ftrace: Add ops parameter to ftrace_startup/shutdown functions
      ftrace: Have global_ops store the functions that are to be traced
      ftrace: Free hash with call_rcu_sched()
      ftrace: Implement separate user function filtering
      ftrace: Allow dynamically allocated function tracers
      ftrace: Modify ftrace_set_filter/notrace to take ops
      ftrace: Add self-tests for multiple function trace users

----
 include/linux/ftrace.h                |   33 +-
 include/linux/kernel.h                |    1 +
 kernel/extable.c                      |    8 +
 kernel/trace/ftrace.c                 |  992 ++++++++++++++++++++++++++++-----
 kernel/trace/trace.h                  |    2 +
 kernel/trace/trace_functions.c        |    2 +
 kernel/trace/trace_irqsoff.c          |    1 +
 kernel/trace/trace_sched_wakeup.c     |    1 +
 kernel/trace/trace_selftest.c         |  214 +++++++-
 kernel/trace/trace_selftest_dynamic.c |    6 +
 kernel/trace/trace_stack.c            |    1 +
 11 files changed, 1116 insertions(+), 145 deletions(-)
