Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298Ab0HZGDE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 02:03:04 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:34409 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab0HZGDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 02:03:02 -0400
X-AuditID: b753bd60-a6acdba000005dcc-98-4c7603910aa8
Message-ID: <4C76038A.40400@hitachi.com>
Date: Thu, 26 Aug 2010 15:02:50 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCHv11 2.6.36-rc2-tip 10/15] 10: tracing: config option to
 enable both kprobe-tracer and uprobe-tracer.
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6> <20100825134315.5447.96501.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100825134315.5447.96501.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/08/25 22:43), Srikar Dronamraju wrote:
> Selecting CONFIG_PROBE_EVENTS enables both kprobe-based and
> uprobes-based dynamic events. However kprobe-tracer or uprobe-tracer
> can still be individually selected or disabled.
> 
> Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Suggested-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  kernel/trace/Kconfig |   51 +++++++++++++++++++++++++++++---------------------
>  1 files changed, 30 insertions(+), 21 deletions(-)
> 
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index 55ba474..205c12b 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -76,7 +76,7 @@ config RING_BUFFER_ALLOW_SWAP
>  # All tracer options should select GENERIC_TRACER. For those options that are
>  # enabled by all tracers (context switch and event tracer) they select TRACING.
>  # This allows those options to appear when no other tracer is selected. But the
> -# options do not appear when something else selects it. We need the two options
> +# options do not appear when something else selects it. We need the two option

Why are lots of end-of-line 's' character missing? :)


>  # GENERIC_TRACER and TRACING to avoid circular dependencies to accomplish the
>  # hiding of the automatic options.
>  
> @@ -162,7 +162,7 @@ config IRQSOFF_TRACER
>  	  This option measures the time spent in irqs-off critical
>  	  sections, with microsecond accuracy.
>  
> -	  The default measurement method is a maximum search, which is
> +	  The default measurement method is a maximum search, which i
>  	  disabled by default and can be runtime (re-)started
>  	  via:
>  
> @@ -184,7 +184,7 @@ config PREEMPT_TRACER
>  	  This option measures the time spent in preemption-off critical
>  	  sections, with microsecond accuracy.
>  
> -	  The default measurement method is a maximum search, which is
> +	  The default measurement method is a maximum search, which i
>  	  disabled by default and can be runtime (re-)started
>  	  via:
>  
> @@ -228,7 +228,7 @@ choice
>  	prompt "Branch Profiling"
>  	default BRANCH_PROFILE_NONE
>  	help
> -	 The branch profiling is a software profiler. It will add hooks
> +	 The branch profiling is a software profiler. It will add hook
>  	 into the C conditionals to test which path a branch takes.
>  
>  	 The likely/unlikely profiler only looks at the conditions that
> @@ -252,12 +252,12 @@ config PROFILE_ANNOTATED_BRANCHES
>  	bool "Trace likely/unlikely profiler"
>  	select TRACE_BRANCH_PROFILING
>  	help
> -	  This tracer profiles all the the likely and unlikely macros
> +	  This tracer profiles all the the likely and unlikely macro
>  	  in the kernel. It will display the results in:
>  
>  	  /sys/kernel/debug/tracing/profile_annotated_branch
>  
> -	  Note: this will add a significant overhead; only turn this
> +	  Note: this will add a significant overhead; only turn thi
>  	  on if you need to profile the system's use of these macros.
>  
>  config PROFILE_ALL_BRANCHES
> @@ -333,7 +333,7 @@ config BLK_DEV_IO_TRACE
>  	select GENERIC_TRACER
>  	select STACKTRACE
>  	help
> -	  Say Y here if you want to be able to trace the block layer actions
> +	  Say Y here if you want to be able to trace the block layer action
>  	  on a given queue. Tracing allows you to see any traffic happening
>  	  on a block device queue. For more information (and the userspace
>  	  support tools needed), fetch the blktrace tools from:
> @@ -351,9 +351,8 @@ config BLK_DEV_IO_TRACE
>  config KPROBE_EVENT
>  	depends on KPROBES
>  	depends on HAVE_REGS_AND_STACK_ACCESS_API
> +	depends on PROBE_EVENTS
>  	bool "Enable kprobes-based dynamic events"
> -	select TRACING
> -	select PROBE_EVENTS
>  	default y
>  	help
>  	  This allows the user to add tracing events (similar to tracepoints)
> @@ -370,10 +369,9 @@ config UPROBE_EVENT
>  	bool "Enable uprobes-based dynamic events"
>  	depends on ARCH_SUPPORTS_UPROBES
>  	depends on MMU
> +	depends on PROBE_EVENTS
>  	select UPROBES
> -	select PROBE_EVENTS
> -	select TRACING
> -	default n
> +	default y
>  	help
>  	  This allows the user to add tracing events on top of userspace dynamic
>  	  events (similar to tracepoints) on the fly via the traceevents interface.
> @@ -383,7 +381,18 @@ config UPROBE_EVENT
>  	  tools on user space applications.
>  
>  config PROBE_EVENTS
> -	def_bool n
> +	bool "Enable kprobes and uprobe based dynamic events"
> +	select TRACING
> +	default n

Hmm, without this series, KPROBE_EVENT is set "y" by default.
(PROBE_EVENTS is introduced by 8/15)
I'd like to set this "y" by default, because it doesn't
affect other parts.

Thank you,

> +	help
> +	  This allows a user to add dynamic tracing events in
> +	  kernel using kprobe-tracer and in userspace using
> +	  uprobe-tracer. However users can still selectively
> +	  disable one of these events.
> +
> +	  For more information on kprobe-tracer and uprobe-tracer
> +	  please refer help under KPROBE_EVENT and UPROBE_EVENT
> +	  respectively.
>  
>  config DYNAMIC_FTRACE
>  	bool "enable/disable ftrace tracepoints dynamically"
> @@ -393,14 +402,14 @@ config DYNAMIC_FTRACE
>  	help
>            This option will modify all the calls to ftrace dynamically
>  	  (will patch them out of the binary image and replace them
> -	  with a No-Op instruction) as they are called. A table is
> +	  with a No-Op instruction) as they are called. A table i
>  	  created to dynamically enable them again.
>  
>  	  This way a CONFIG_FUNCTION_TRACER kernel is slightly larger, but
>  	  otherwise has native performance as long as no tracing is active.
>  
>  	  The changes to the code are done by a kernel thread that
> -	  wakes up once a second and checks to see if any ftrace calls
> +	  wakes up once a second and checks to see if any ftrace call
>  	  were made. If so, it runs stop_machine (stops all CPUS)
>  	  and modifies the code to jump over the call to ftrace.
>  
> @@ -432,7 +441,7 @@ config FTRACE_STARTUP_TEST
>  	select FTRACE_SELFTEST
>  	help
>  	  This option performs a series of startup tests on ftrace. On bootup
> -	  a series of tests are made to verify that the tracer is
> +	  a series of tests are made to verify that the tracer i
>  	  functioning properly. It will do tests on all the configured
>  	  tracers of ftrace.
>  
> @@ -441,12 +450,12 @@ config EVENT_TRACE_TEST_SYSCALLS
>  	depends on FTRACE_STARTUP_TEST
>  	help
>  	 This option will also enable testing every syscall event.
> -	 It only enables the event and disables it and runs various loads
> +	 It only enables the event and disables it and runs various load
>  	 with the event enabled. This adds a bit more time for kernel boot
>  	 up since it runs this on every system call defined.
>  
>  	 TBD - enable a way to actually call the syscalls as we test their
> -	       events
> +	       event
>  
>  config MMIOTRACE
>  	bool "Memory mapped IO tracing"
> @@ -465,7 +474,7 @@ config MMIOTRACE_TEST
>  	tristate "Test module for mmiotrace"
>  	depends on MMIOTRACE && m
>  	help
> -	  This is a dumb module for testing mmiotrace. It is very dangerous
> +	  This is a dumb module for testing mmiotrace. It is very dangerou
>  	  as it will write garbage to IO memory starting at a given address.
>  	  However, it should be safe to use on e.g. unused portion of VRAM.
>  
> @@ -477,9 +486,9 @@ config RING_BUFFER_BENCHMARK
>  	help
>  	  This option creates a test to stress the ring buffer and benchmark it.
>  	  It creates its own ring buffer such that it will not interfere with
> -	  any other users of the ring buffer (such as ftrace). It then creates
> +	  any other users of the ring buffer (such as ftrace). It then create
>  	  a producer and consumer that will run for 10 seconds and sleep for
> -	  10 seconds. Each interval it will print out the number of events
> +	  10 seconds. Each interval it will print out the number of event
>  	  it recorded and give a rough estimate of how long each iteration took.
>  
>  	  It does not disable interrupts or raise its priority, so it may be

