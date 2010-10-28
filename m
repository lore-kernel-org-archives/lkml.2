Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932757Ab0J1CZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 22:25:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62132 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932685Ab0J1CZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 22:25:18 -0400
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=-qfxTvYugxgA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=7d_E57ReAAAA:8 a=fJZ9nfZQ3g5frqiCSskA:9 a=fPitSO6wWVVc1NupItPMlBrWsa0A:4 a=PUjeQqilurYA:10 a=D6-X0JM3zdQA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] tracing: fix TRACE_EVENT power tracepoint creation
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20101028021632.GA18117@Krystal>
References: <20101028021632.GA18117@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 27 Oct 2010 22:25:16 -0400
Message-ID: <1288232716.18238.140.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-27 at 22:16 -0400, Mathieu Desnoyers wrote:
> DEFINE_TRACE should also exist when CONFIG_EVENT_TRACING=n. Otherwise, setting
> only TRACEPOINTS=y is broken.

NAK, DEFINE_TRACE is deprecated from use outside the tracing
infrastructure.

> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> ---
>  kernel/Makefile             |    1 +
>  kernel/trace/Makefile       |    2 +-
>  kernel/trace/power-traces.c |    6 ++++++
>  3 files changed, 8 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6-lttng/kernel/Makefile
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/Makefile
> +++ linux-2.6-lttng/kernel/Makefile
> @@ -93,6 +93,7 @@ obj-$(CONFIG_TASKSTATS) += taskstats.o t
>  obj-$(USE_IMMEDIATE) += immediate.o
>  obj-$(CONFIG_MARKERS) += marker.o
>  obj-$(CONFIG_TRACEPOINTS) += tracepoint.o
> +obj-$(CONFIG_TRACEPOINTS) += trace/
>  obj-$(CONFIG_LATENCYTOP) += latencytop.o
>  obj-$(CONFIG_BINFMT_ELF) += elfcore.o
>  obj-$(CONFIG_COMPAT_BINFMT_ELF) += elfcore.o
> Index: linux-2.6-lttng/kernel/trace/Makefile
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/trace/Makefile
> +++ linux-2.6-lttng/kernel/trace/Makefile
> @@ -52,7 +52,7 @@ obj-$(CONFIG_EVENT_TRACING) += trace_eve
>  endif
>  obj-$(CONFIG_EVENT_TRACING) += trace_events_filter.o
>  obj-$(CONFIG_KPROBE_EVENT) += trace_kprobe.o
> -obj-$(CONFIG_EVENT_TRACING) += power-traces.o
> +obj-$(CONFIG_TRACEPOINTS) += power-traces.o
>  ifeq ($(CONFIG_TRACING),y)
>  obj-$(CONFIG_KGDB_KDB) += trace_kdb.o
>  endif
> Index: linux-2.6-lttng/kernel/trace/power-traces.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/trace/power-traces.c
> +++ linux-2.6-lttng/kernel/trace/power-traces.c
> @@ -10,8 +10,14 @@
>  #include <linux/sched.h>
>  #include <linux/module.h>
>  
> +#ifdef CONFIG_EVENT_TRACING
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/power.h>
> +#else
> +DEFINE_TRACE(power_start);
> +DEFINE_TRACE(power_end);
> +DEFINE_TRACE(power_frequency);
> +#endif

The trace/events/power.h file should handle the DEFINE_TRACE() when
CONFIG_EVENT_TRACING is not set. Thus, this is the wrong fix.

-- Steve

>  
>  EXPORT_TRACEPOINT_SYMBOL_GPL(power_frequency);
>  


