Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab1BCOjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 09:39:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:46761 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab1BCOi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 09:38:59 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=-iGt_iAYLz4A:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=UINBkuoCVyVxbB2UuDkA:9 a=J_xQT8zjzwTWQfJHQfT5lY7HpcAA:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110203143518.707423251@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 03 Feb 2011 09:35:18 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 0/3 v2] [GIT PULL][v2.6.38] tracing: alignment fixes (take 3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

The first two patches are the same as before, except that I modified
the change logs to include David's Acks and to make the updates
recommended by Mathieu and Thomas Gleixner.

This also includes a third patch to fix the syscall_metadata.
I ran all three through the same tests on both x86_64 and x86_32
with both gcc version 4.5.1 and 4.4.5.

Please pull the latest tip/perf/urgent-2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/urgent-2


Mathieu Desnoyers (1):
      tracepoints: Fix section alignment using pointer array

Steven Rostedt (2):
      tracing: Replace trace_event struct array with pointer array
      tracing: Replace syscall_meta_data struct array with pointer array

----
 include/asm-generic/vmlinux.lds.h |   24 ++++++++++++------------
 include/linux/module.h            |    4 ++--
 include/linux/syscalls.h          |   28 +++++++++++++++-------------
 include/linux/tracepoint.h        |   35 ++++++++++++++++++++---------------
 include/trace/ftrace.h            |   24 +++++++++++++-----------
 kernel/module.c                   |   16 ++++++++--------
 kernel/trace/trace_events.c       |   12 ++++++------
 kernel/trace/trace_export.c       |    6 +++---
 kernel/trace/trace_syscalls.c     |   19 ++++++++++---------
 kernel/tracepoint.c               |   31 ++++++++++++++++---------------
 10 files changed, 105 insertions(+), 94 deletions(-)
