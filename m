Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab1DTQNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 12:13:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37248 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559Ab1DTQNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 12:13:33 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=vhdKIqpQuCYA:10 a=BMVA_mf54fQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=h1msV1-NIpBbKvTb0w0A:9 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110420155838.640017971@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Apr 2011 11:58:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>
Subject: [PATCH 0/6] [GIT PULL][v2.6.40] tracing: updates and jump label rebase
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

[ Resend, as due to a cut and paste error, Ingo's and Andrew's email
  was chopped off the Cc list ]

This includes minor updates to ftrace as well as the patchset
for jump labels. I took out the debug printk patch that had caused
earlier conflicts. We can add that one later.

Please pull the latest tip/perf/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/core


Jan Glauber (1):
      jump label: Add s390 support

Jason Baron (2):
      jump label: Introduce static_branch() interface
      jump label: Add _ASM_ALIGN for x86 and x86_64

Jiri Olsa (1):
      tracing: Avoid soft lockup in trace_pipe

Steven Rostedt (2):
      tracing: Convert trace_printk() formats for module to const char *
      tracing: Print trace_bprintk() formats for modules too

----
 arch/mips/include/asm/jump_label.h  |   22 +-
 arch/s390/Kconfig                   |    1 +
 arch/s390/include/asm/jump_label.h  |   37 +++
 arch/s390/kernel/Makefile           |    2 +-
 arch/s390/kernel/jump_label.c       |   59 ++++
 arch/sparc/include/asm/jump_label.h |   25 +-
 arch/x86/include/asm/alternative.h  |    3 +-
 arch/x86/include/asm/jump_label.h   |   27 +-
 arch/x86/kernel/alternative.c       |    2 +-
 arch/x86/kernel/module.c            |    1 +
 include/asm-generic/vmlinux.lds.h   |   14 +-
 include/linux/dynamic_debug.h       |    2 -
 include/linux/jump_label.h          |   89 ++++---
 include/linux/jump_label_ref.h      |   44 ---
 include/linux/perf_event.h          |   26 +-
 include/linux/tracepoint.h          |   22 +-
 kernel/jump_label.c                 |  539 ++++++++++++++---------------------
 kernel/perf_event.c                 |    4 +-
 kernel/trace/trace.c                |   15 +-
 kernel/trace/trace_output.c         |    3 +
 kernel/trace/trace_printk.c         |  120 +++++++-
 kernel/tracepoint.c                 |   23 +-
 22 files changed, 578 insertions(+), 502 deletions(-)
