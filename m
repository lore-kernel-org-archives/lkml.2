Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710Ab0C2Leu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 07:34:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38871 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117Ab0C2Let (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 07:34:49 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCHv4 0/2] tracing: function graph output for preempt/irqs-off tracers
Date: Mon, 29 Mar 2010 13:34:34 +0200
Message-Id: <1269862476-4368-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

I'm sending reworked version of the graph output support for
preemptirqsoff/preemptoff/irqsoff tracers.

v4:
- fixed header to display all the info as for
  current irqsoff tracer
- fixed reset of the max_tr buffer during the
  display-graph switch

v3:
- the function_graph tracer should have the same output
  as current version even with events enabled,
  unless I missed something again ;)
- I gave up the idea of function_graph events,
  since it was unsuitable for outputing other
  events as comments "/* */"
- I'm not including the raw function_graph for now


attached patches:
- 1/2 graph output support for irqsoff tracer
- 2/2 graph output support for preemptirqsoff/preemptoff tracers

plz let me know what you think

wbr,
jirka
---
 kernel/trace/trace.c                 |   41 +++++--
 kernel/trace/trace.h                 |   13 ++
 kernel/trace/trace_functions_graph.c |   15 ++-
 kernel/trace/trace_irqsoff.c         |  210 ++++++++++++++++++++++++++++++++-
 4 files changed, 254 insertions(+), 25 deletions(-)
