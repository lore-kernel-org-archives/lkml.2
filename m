Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585Ab0EURo2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 13:44:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756223Ab0EURo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 13:44:26 -0400
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/10] perf, trace: Remove IRQ-disable from perf/tracepoint interaction
References: <20100521090201.326791353@chello.nl>
	<20100521090710.419716197@chello.nl>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Fri, 21 May 2010 13:43:49 -0400
In-Reply-To: <20100521090710.419716197@chello.nl> (Peter Zijlstra's message of "Fri, 21 May 2010 11:02:02 +0200")
Message-ID: <y0maartf8ve.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Peter Zijlstra <a.p.zijlstra@chello.nl> writes:

> [...]
> @@ -799,13 +799,10 @@ perf_trace_templ_##call(struct ftrace_ev
>  static notrace void perf_trace_##call(proto)				\
>  {									\
>  	struct ftrace_event_call *event_call = &event_##call;		\
> -	struct pt_regs *__regs = &get_cpu_var(perf_trace_regs);		\
> -									\
> -	perf_fetch_caller_regs(__regs, 1);				\
> -									\
> -	perf_trace_templ_##template(event_call, __regs, args);		\
> +	struct pt_regs __regs;						\
>  									\
> -	put_cpu_var(perf_trace_regs);					\
> +	perf_fetch_caller_regs(&__regs, 1);				\
> +	perf_trace_templ_##template(event_call, &__regs, args);		\
>  }
>  [...]

To what extent are you worried about something the size of struct
pt_regs being auto/stack allocated?


- FChE
