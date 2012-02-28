Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527Ab2B1NWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 08:22:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755158Ab2B1NWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 08:22:06 -0500
Date: Tue, 28 Feb 2012 14:21:59 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trace: Fix build breakage without CONFIG_PERF_EVENTS
Message-ID: <20120228132159.GA1694@m.brq.redhat.com>
References: <1330426967-17067-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330426967-17067-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 11:02:46AM +0000, Mark Brown wrote:
> Today's -next fails to build for me:
> 
>   CC      kernel/trace/trace_export.o
> In file included from kernel/trace/trace_export.c:197: kernel/trace/trace_entries.h:58: error: 'perf_ftrace_event_register' undeclared here (not in a function)
> make[2]: *** [kernel/trace/trace_export.o] Error 1
> make[1]: *** [kernel/trace] Error 2
> make: *** [kernel] Error 2
> 
> because as of ced390 (ftrace, perf: Add support to use function
> tracepoint in perf) perf_trace_event_register() is declared in trace.h
> only if CONFIG_PERF_EVENTS is enabled but I don't have that set.
hi,
what architecture are you on? I wonder how you managed to
switch off PERF_EVENTS ;) I tried only x86..

could you please send you config,

thanks,
jirka

> 
> Ensure that we always have a definition of perf_trace_event_register()
> by making the definition unconditional.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  kernel/trace/trace.h |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 54faec7..3dd357c 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -835,13 +835,11 @@ extern const char *__stop___trace_bprintk_fmt[];
>  		     filter)
>  #include "trace_entries.h"
>  
> -#ifdef CONFIG_PERF_EVENTS
>  #ifdef CONFIG_FUNCTION_TRACER
>  int perf_ftrace_event_register(struct ftrace_event_call *call,
>  			       enum trace_reg type, void *data);
>  #else
>  #define perf_ftrace_event_register NULL
>  #endif /* CONFIG_FUNCTION_TRACER */
> -#endif /* CONFIG_PERF_EVENTS */
>  
>  #endif /* _LINUX_KERNEL_TRACE_H */
> -- 
> 1.7.9.1
> 
