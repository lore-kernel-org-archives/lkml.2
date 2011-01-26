Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750877Ab1AZGrc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 01:47:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44931 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383Ab1AZGrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 01:47:32 -0500
Date: Wed, 26 Jan 2011 07:47:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Miller <davem@davemloft.net>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 0/3] [GIT PULL][v2.6.38] tracing: fix unaligned event
 arrays
Message-ID: <20110126064723.GA15752@elte.hu>
References: <20110126040459.289776311@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110126040459.289776311@goodmis.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> It was discovered that the alignment of the trace event sections
> break sparc64. The trace events are created by linker magic, so
> gcc does not realize that the structures being allocated will end
> up in an array. Without adding any alignment, x86_64 would create
> the trace event arrays with holes that would break reading the
> events in serial. The fix for that was to force a align(4) to
> keep gcc and the linker from spacing the event structures at various
> alignments. But recent changes have caused this change to break
> sparc due to bad alignment in the structures, caused by the 4 byte
> alignment.
> 
> After some discussions, Mathieu came up with the following patch set
> to correctly fix the alignment issues with the trace event structures.
> 
> Please pull the latest tip/perf/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/urgent
> 
> 
> Mathieu Desnoyers (3):
>       Introduce __u64_aligned and U64_ALIGN() for structure alignment in custom sections
>       tracing: Fix sparc64 alignment crash with __u64_aligned/U64_ALIGN()
>       tracepoints: Use __u64_aligned/U64_ALIGN()
> 
> ----
>  include/asm-generic/vmlinux.lds.h |   27 +++++++++++-------
>  include/linux/align-section.h     |   54 +++++++++++++++++++++++++++++++++++++
>  include/linux/compiler.h          |    8 +++--
>  include/linux/ftrace_event.h      |    2 +-
>  include/linux/syscalls.h          |   12 ++++----
>  include/linux/tracepoint.h        |   12 +++-----
>  include/trace/ftrace.h            |    8 +++---
>  include/trace/syscall.h           |    2 +-
>  kernel/trace/trace.h              |    2 +-
>  kernel/trace/trace_export.c       |    2 +-
>  10 files changed, 94 insertions(+), 35 deletions(-)

Pulled, thanks a lot Steve!

	Ingo
