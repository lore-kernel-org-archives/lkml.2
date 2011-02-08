Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079Ab1BHB7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 20:59:35 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45988 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab1BHB7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 20:59:32 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=Wt_XNqjzNjQA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=yRJg_FlhHyYAnaiKSHAA:9 a=UTLoBz7lxfj-uvKXwPT_L40UZhYA:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110208015617.902200587@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 07 Feb 2011 20:56:17 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 00/14] [GIT PULL][v2.6.39] tracing/filter: More robust filtering
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I finally finished and tested all these patches. Minor fixes were
made since the last email. I also added a couple of patches to
allow a switch between filters instead of having a small period that
the filter would either filter out all or none as it changes the
filtering.

Please pull the latest tip/perf/filter tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/filter


Steven Rostedt (14):
      tracing/filter: Have no filter return a match
      tracing/filter: Move OR and AND logic out of fn() method
      tracing/filter: Dynamically allocate preds
      tracing/filter: Call synchronize_sched() just once for system filters
      tracing/filter: Allocate the preds in an array
      tracing/filter: Free pred array on disabling of filter
      tracing/filter: Use a tree instead of stack for filter_match_preds()
      tracing/filter: Optimize short ciruit check
      tracing/filter: Check the created pred tree
      tracing/filter: Optimize filter by folding the tree
      tracing/filter: Move MAX_FILTER_PRED to local tracing directory
      tracing/filter: Increase the max preds to 2^14
      tracing/filter: Swap entire filter of events
      tracing/filter: Remove synchronize_sched() from __alloc_preds()

----
 include/linux/ftrace_event.h       |    1 -
 kernel/trace/trace.h               |   38 ++-
 kernel/trace/trace_events_filter.c |  885 +++++++++++++++++++++++++++++-------
 3 files changed, 754 insertions(+), 170 deletions(-)
