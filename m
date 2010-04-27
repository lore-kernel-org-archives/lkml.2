Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab0D0Bfr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 21:35:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:51764 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab0D0Bfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 21:35:46 -0400
X-Authority-Analysis: v=1.1 cv=5TxanRntTX9OAC4XagPzOb4UH5Mu5Wq2gEwJT3nijOM= c=1 sm=0 a=VK7oVquvUSoA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=20KFwNOVAAAA:8 a=ig9YrC-s4r3WSblVanUA:9 a=9xIm-k0ufyxwHJOabLbHWYOPPicA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCHv6 4/4] tracing: graph output support for
 preemptirqsoff/preemptoff tracers
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Jiri Olsa <jolsa@redhat.com>
Cc: mingo@elte.hu, fweisbec@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <1270227683-14631-5-git-send-email-jolsa@redhat.com>
References: <1270227683-14631-1-git-send-email-jolsa@redhat.com>
	 <1270227683-14631-5-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 26 Apr 2010 21:35:43 -0400
Message-ID: <1272332143.9739.39.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-02 at 19:01 +0200, Jiri Olsa wrote:
> hi,
> 
> adding support for graph output for preemptirqsoff/preemptoff tracers.
> 

So far I like the series. But I'm confused why this patch is separate
from patch 3. Is there some reason for it?

If not, I'll just merge this into patch 3

-- Steve

> wbr,
> jirka
> 
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  kernel/trace/trace_irqsoff.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
> index cc20d7c..6fd486e 100644
> --- a/kernel/trace/trace_irqsoff.c
> +++ b/kernel/trace/trace_irqsoff.c
> @@ -672,9 +672,15 @@ static struct tracer preemptoff_tracer __read_mostly =
>  	.start		= irqsoff_tracer_start,
>  	.stop		= irqsoff_tracer_stop,
>  	.print_max	= 1,
> +	.print_header   = irqsoff_print_header,
> +	.print_line     = irqsoff_print_line,
> +	.flags		= &tracer_flags,
> +	.set_flag	= irqsoff_set_flag,
>  #ifdef CONFIG_FTRACE_SELFTEST
>  	.selftest    = trace_selftest_startup_preemptoff,
>  #endif
> +	.open		= irqsoff_trace_open,
> +	.close		= irqsoff_trace_close,
>  };
>  # define register_preemptoff(trace) register_tracer(&trace)
>  #else
> @@ -700,9 +706,15 @@ static struct tracer preemptirqsoff_tracer __read_mostly =
>  	.start		= irqsoff_tracer_start,
>  	.stop		= irqsoff_tracer_stop,
>  	.print_max	= 1,
> +	.print_header   = irqsoff_print_header,
> +	.print_line     = irqsoff_print_line,
> +	.flags		= &tracer_flags,
> +	.set_flag	= irqsoff_set_flag,
>  #ifdef CONFIG_FTRACE_SELFTEST
>  	.selftest    = trace_selftest_startup_preemptirqsoff,
>  #endif
> +	.open		= irqsoff_trace_open,
> +	.close		= irqsoff_trace_close,
>  };
>  
>  # define register_preemptirqsoff(trace) register_tracer(&trace)


