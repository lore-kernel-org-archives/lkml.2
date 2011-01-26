Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab1AZLEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 06:04:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49125 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352Ab1AZLEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 06:04:35 -0500
Date: Wed, 26 Jan 2011 12:03:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] power_trace: move power_trace to kernel/power/
Message-ID: <20110126110359.GC27809@elte.hu>
References: <4D3FE72B.2010701@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D3FE72B.2010701@cn.fujitsu.com>
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


* Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> 
> I think kernel/trace/ is the place for the tracing implementation files,
> it is not a good place for tracepoint creation. Any subsystem should
> creates tracepoints at its owner location, see also all other CREATE_TRACE_POINTS.
> For example: net-traces.c is in the net/core/ directory.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/Makefile b/kernel/Makefile
> index 353d3fe..25c3767 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -55,6 +55,7 @@ obj-$(CONFIG_MODULES) += module.o
>  obj-$(CONFIG_KALLSYMS) += kallsyms.o
>  obj-$(CONFIG_PM) += power/
>  obj-$(CONFIG_FREEZER) += power/
> +obj-$(CONFIG_TRACEPOINTS) += power/
>  obj-$(CONFIG_BSD_PROCESS_ACCT) += acct.o
>  obj-$(CONFIG_KEXEC) += kexec.o
>  obj-$(CONFIG_BACKTRACE_SELF_TEST) += backtracetest.o
> @@ -100,7 +101,6 @@ obj-$(CONFIG_FUNCTION_TRACER) += trace/
>  obj-$(CONFIG_TRACING) += trace/
>  obj-$(CONFIG_X86_DS) += trace/
>  obj-$(CONFIG_RING_BUFFER) += trace/
> -obj-$(CONFIG_TRACEPOINTS) += trace/
>  obj-$(CONFIG_SMP) += sched_cpupri.o
>  obj-$(CONFIG_IRQ_WORK) += irq_work.o
>  obj-$(CONFIG_PERF_EVENTS) += perf_event.o
> diff --git a/kernel/power/Makefile b/kernel/power/Makefile
> index c350e18..b5a74f5 100644
> --- a/kernel/power/Makefile
> +++ b/kernel/power/Makefile
> @@ -9,3 +9,4 @@ obj-$(CONFIG_HIBERNATION)	+= hibernate.o snapshot.o swap.o user.o \
>  				   block_io.o
>  
>  obj-$(CONFIG_MAGIC_SYSRQ)	+= poweroff.o
> +obj-$(CONFIG_TRACEPOINTS)	+= power-traces.o

What is 'power-traces'? Please name it power-events.c/power-events.o.

Thanks,

	Ingo
