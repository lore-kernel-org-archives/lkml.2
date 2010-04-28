Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757044Ab0D1UWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 16:22:32 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:57420 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757024Ab0D1UWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 16:22:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEANow2EtGGNqG/2dsb2JhbACceHK+WoUOBA
Date: Wed, 28 Apr 2010 16:22:25 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 01/10][RFC] tracing: Create class struct for events
Message-ID: <20100428202225.GB8591@Krystal>
References: <20100426195024.256424113@goodmis.org> <20100426200241.373124697@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20100426200241.373124697@goodmis.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 16:21:07 up 21 days,  6:14,  4 users,  load average: 0.21, 0.21,
	0.18
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> This patch creates a ftrace_event_class struct that event structs point to.
> This class struct will be made to hold information to modify the
> events. Currently the class struct only holds the events system name.
> 
> This patch slightly increases the size of the text as well as decreases
> the data size. The overall change is still a slight increase, but
> this change lays the ground work of other changes to make the footprint
> of tracepoints smaller.
> 
> With 82 standard tracepoints, and 616 system call tracepoints:
> 
>    text	   data	    bss	    dec	    hex	filename
> 5788186	1337252	9351592	16477030	 fb6b66	vmlinux.orig
> 5792282	1333796	9351592	16477670	 fb6de6	vmlinux.class
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/ftrace_event.h       |    6 +++++-
>  include/linux/syscalls.h           |    6 ++++--
>  include/trace/ftrace.h             |   36 +++++++++++++++---------------------
>  kernel/trace/trace_events.c        |   20 ++++++++++----------
>  kernel/trace/trace_events_filter.c |    6 +++---
>  kernel/trace/trace_export.c        |    6 +++++-
>  kernel/trace/trace_kprobe.c        |   12 ++++++------
>  kernel/trace/trace_syscalls.c      |    4 ++++
>  8 files changed, 52 insertions(+), 44 deletions(-)
> 
[...]
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index 75dd778..0921a8f 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -62,7 +62,10 @@
>  		struct trace_entry	ent;				\
>  		tstruct							\
>  		char			__data[0];			\
> -	};
> +	};								\
> +									\
> +	static struct ftrace_event_class event_class_##name;
> +
>  #undef DEFINE_EVENT
>  #define DEFINE_EVENT(template, name, proto, args)	\
>  	static struct ftrace_event_call			\
> @@ -430,22 +433,6 @@ perf_trace_disable_##name(struct ftrace_event_call *unused)		\
>   *
>   * Override the macros in <trace/trace_events.h> to include the following:
>   *
> - * static void ftrace_event_<call>(proto)
> - * {
> - *	event_trace_printk(_RET_IP_, "<call>: " <fmt>);
> - * }
> - *
> - * static int ftrace_reg_event_<call>(struct ftrace_event_call *unused)
> - * {
> - *	return register_trace_<call>(ftrace_event_<call>);
> - * }
> - *
> - * static void ftrace_unreg_event_<call>(struct ftrace_event_call *unused)
> - * {
> - *	unregister_trace_<call>(ftrace_event_<call>);
> - * }
> - *
> - *
>   * For those macros defined with TRACE_EVENT:
>   *
>   * static struct ftrace_event_call event_<call>;

So.. just wondering, why are you removing these comments ? What's
replacing them ?

Maybe you meant to remove this in a following patch ?

Thanks,

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
