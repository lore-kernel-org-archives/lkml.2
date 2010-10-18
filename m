Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757747Ab0JRUcu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 16:32:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46732 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756704Ab0JRUct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 16:32:49 -0400
X-Authority-Analysis: v=1.1 cv=exbvkCqEOBXDkHq+8n3wanotOBQtbe7qbIajSD+JluU= c=1 sm=0 a=8EwnKXnB_KgA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=skD6RWCdlbx_JQn9IYEA:9 a=AYkFWKOwUMF1ryUyjYAA:7 a=QXVz9Mf-a5ek5JdVJggrrceGNfsA:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101018202939.828061748@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 18 Oct 2010 16:29:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/7] [GIT PULL] tracing: various updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I pushed these before, but they had a couple of jump label patches that
caused you a build error. Since these patches have nothing to do with
jump label, I rebased them without the jump label patches on top
of latest tip/perf/core.

The couple of jump label that were taken out of this patch series
now live in the jump label branch of my tree (and were actually in
the last jump label push which also needs a rewrite).

Please pull the latest tip/perf/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/core


Jiri Olsa (3):
      tracing: Add proper check for irq_depth routines
      tracing: Make graph related irqs/preemptsoff functions global
      tracing: Graph support for wakeup tracer

Steven Rostedt (3):
      tracing: Use one prologue for the wakeup tracer function tracers
      tracing: Use one prologue for the preempt irqs off tracer function tracers
      tracing: Remove parent recording in latency tracer graph options

matt mooney (1):
      tracing/trivial: Remove cast from void*

----
 kernel/trace/ftrace.c                |    4 +-
 kernel/trace/trace.c                 |    2 +-
 kernel/trace/trace.h                 |    4 +
 kernel/trace/trace_functions_graph.c |   86 +++++++++++-
 kernel/trace/trace_irqsoff.c         |  152 +++++++-------------
 kernel/trace/trace_sched_wakeup.c    |  257 ++++++++++++++++++++++++++++++---
 6 files changed, 374 insertions(+), 131 deletions(-)
