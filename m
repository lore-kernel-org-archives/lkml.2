Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618Ab0JFDiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 23:38:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41826 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758593Ab0JFDfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 23:35:46 -0400
X-Authority-Analysis: v=1.1 cv=vbQZhf6WRU4XF+4tPWNJEMYU0N1CowIjcRZ/qR/IBDs= c=1 sm=0 a=owMOAjIgFCMA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=1jYkifEB4wS8NeMA5tMA:9 a=uD-2GSI_q-Ni91V0PXYA:7 a=sjNOLo_eeRwjEt8_6Pxm_X8xCgcA:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101006033445.465428951@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 05 Oct 2010 23:34:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/9] [GIT PULL] tracing: updates for 2.6.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/perf/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/core


Jason Baron (1):
      jump label/x86: Move arch_init_ideal_nop5 later

Jiri Olsa (3):
      tracing: Add proper check for irq_depth routines
      tracing: Make graph related irqs/preemptsoff functions global
      tracing: Graph support for wakeup tracer

Steven Rostedt (4):
      tracing/x86: No need to disable interrupts when calling arch_init_ideal_nop5
      tracing: Use one prologue for the wakeup tracer function tracers
      tracing: Use one prologue for the preempt irqs off tracer function tracers
      tracing: Remove parent recording in latency tracer graph options

matt mooney (1):
      tracing/trivial: Remove cast from void*

----
 arch/x86/kernel/alternative.c        |    5 +
 arch/x86/kernel/setup.c              |    6 -
 kernel/trace/ftrace.c                |    8 +-
 kernel/trace/trace.c                 |    2 +-
 kernel/trace/trace.h                 |    4 +
 kernel/trace/trace_functions_graph.c |   86 +++++++++++-
 kernel/trace/trace_irqsoff.c         |  152 +++++++-------------
 kernel/trace/trace_sched_wakeup.c    |  257 ++++++++++++++++++++++++++++++---
 8 files changed, 380 insertions(+), 140 deletions(-)
