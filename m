Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab0DBRBj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 13:01:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18783 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754753Ab0DBRBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 13:01:34 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCHv6 0/4] tracing: function graph output for preempt/irqs-off tracers
Date: Fri,  2 Apr 2010 19:01:19 +0200
Message-Id: <1270227683-14631-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

updates based on comments by Frederic Weisbecker,
also rebase to latest master.

I'm sending reworked version of the graph output support for
preemptirqsoff/preemptoff/irqsoff tracers.

v6:
- using stubs instead of ifdef in trace_irqsoff for graph
  tracer's calls

v5:
- function graph events are back in game
- changed function graph tracer interface to be able to
  pass custom tracer flags
- changed calls to trace_function to trace graph records
  when the display-graph otion is enabled.  As function tracer
  and graph tracer have different spacing during the record
  output, this way it looks better, and the info stays.

  This could be also done via TRACE_PRINT, then it'd be displayed
  as comment.. I chose the first way, though it could be easily
  changed.

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
- 1/4 adding ftrace events for graph tracer
- 2/4 graph tracer - adding support for passing flags to ouput functions
- 3/4 graph output support for irqsoff tracer
- 4/4 graph output support for preemptirqsoff/preemptoff tracers


plz let me know what you think

wbr,
jirka
---
