Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545Ab1D3Pch (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 11:32:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33830 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305Ab1D3PcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 11:32:13 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=vhdKIqpQuCYA:10 a=_xWQ3K2E5FEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=OTTa5E5N_ktR9C3tUj0A:9 a=zJIr6Ti30d4qrgEs32IA:7 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110430153040.354378898@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sat, 30 Apr 2011 11:30:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/8] [GIT PULL][2.6.40] ftrace: cleanups
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I'm still working on the accounting of ftrace function tracer to be able
to have multiple users that do not conflict with each other in selecting
functions to trace. It's going well and is almost done.

But in doing this, there were several cleanups that had to be made first.
This patch series contains those cleanups and I've already run my tests
on them and wanted to get them out now, instead of sending them with
the major changes. This will let reviews focus on the major changes
and not have to worry about these cleanups. Reviewers can examine these
cleanups now if they want.

One nice thing about this patch set is the stats:
  141 insertions(+), 214 deletions(-)

Please pull the latest tip/perf/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/core


Steven Rostedt (8):
      ftrace: Make FTRACE_WARN_ON() work in if condition
      ftrace: Remove unnecessary disabling of irqs
      ftrace: Remove failures file
      ftrace: Remove FTRACE_FL_FAILED flag
      ftrace: Remove FTRACE_FL_CONVERTED flag
      ftrace: Move record update for normal and modules into a separate function
      ftrace: Consolidate updating of ftrace_trace_function
      ftrace: Consolidate the function match routines for normal and mods

----
 include/linux/ftrace.h |    8 +-
 kernel/trace/ftrace.c  |  347 +++++++++++++++++++-----------------------------
 2 files changed, 141 insertions(+), 214 deletions(-)
