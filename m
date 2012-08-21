Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab2HUJ0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 05:26:17 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45972 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195Ab2HUJ0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 05:26:12 -0400
Date: Tue, 21 Aug 2012 11:26:06 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 00/19] [GIT PULL][v3.6] ftrace: Allow kprobes to work
 with ftace
Message-ID: <20120821092606.GA12202@gmail.com>
References: <20120721021943.274162381@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120721021943.274162381@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> This patch series extends ftrace function tracing utility to be
> more dynamic for its users. It allows for data passing to the callback
> functions, as well as reading regs as if a breakpoint were to trigger
> at function entry.
> 
> The main goal of this patch series was to allow kprobes to use ftrace
> as an optimized probe point when a probe is placed on an ftrace nop.
> With lots of help from Masami Hiramatsu, and going through lots of
> iterations, we finally came up with a good solution.
> 
> I've tested it vigorously (although, like always, there may be some
> subtle bug), but I feel it is ready for inclussion for the 3.6 merge
> window.
> 
> Please pull the latest tip/perf/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/perf/core
> 
> Head SHA1: aa5e57294ac5614ac395a9733d3e050eace4764e
> 
> 
> Masami Hiramatsu (5):
>       ftrace: add ftrace_set_filter_ip() for address based filter
>       kprobes: cleanup to separate probe-able check
>       kprobes: Move locks into appropriate functions
>       kprobes: introduce ftrace based optimization
>       kprobes/x86: ftrace based optimization for x86
> 
> Steven Rostedt (13):
>       ftrace: Pass ftrace_ops as third parameter to function trace callback
>       ftrace: Consolidate arch dependent functions with 'list' function
>       ftrace: Return pt_regs to function trace callback
>       ftrace/x86_32: Push ftrace_ops in as 3rd parameter to function tracer
>       ftrace/x86: Add separate function to save regs
>       ftrace/x86: Add save_regs for i386 function calls
>       ftrace/x86: Remove function_trace_stop check from graph caller
>       ftrace: Add default recursion protection for function tracing
>       ftrace: Only compile ftrace selftest if selftests are enabled
>       ftrace: Add selftest to test function trace recursion protection
>       ftrace: Add selftest to test function save-regs support
>       kprobes: Inverse taking of module_mutex with kprobe_mutex
>       ftrace: Make ftrace_location() a nop on !DYNAMIC_FTRACE
> 
> Uros Bizjak (1):
>       ftrace/x86_32: Simplify parameter setup for ftrace_regs_caller
> 
> ----
>  arch/x86/include/asm/ftrace.h     |   49 +++---
>  arch/x86/include/asm/kprobes.h    |    1 +
>  arch/x86/kernel/entry_32.S        |   75 ++++++++-
>  arch/x86/kernel/entry_64.S        |   96 +++++++++--
>  arch/x86/kernel/ftrace.c          |   73 ++++++++-
>  arch/x86/kernel/kprobes.c         |   48 ++++++
>  include/linux/ftrace.h            |  158 ++++++++++++++++--
>  include/linux/kprobes.h           |   27 ++++
>  kernel/kprobes.c                  |  250 ++++++++++++++++++++--------
>  kernel/trace/Makefile             |    2 +
>  kernel/trace/ftrace.c             |  322 ++++++++++++++++++++++++++++---------
>  kernel/trace/trace.h              |    2 +-
>  kernel/trace/trace_event_perf.c   |    3 +-
>  kernel/trace/trace_events.c       |    4 +-
>  kernel/trace/trace_functions.c    |   14 +-
>  kernel/trace/trace_irqsoff.c      |    5 +-
>  kernel/trace/trace_sched_wakeup.c |    5 +-
>  kernel/trace/trace_selftest.c     |  277 ++++++++++++++++++++++++++++++-
>  kernel/trace/trace_stack.c        |    4 +-
>  19 files changed, 1199 insertions(+), 216 deletions(-)

Pulled, thanks a lot Steve!

	Ingo
