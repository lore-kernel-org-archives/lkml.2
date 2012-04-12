Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762738Ab2DLUj5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 16:39:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4199 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762679Ab2DLUj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 16:39:56 -0400
X-Authority-Analysis: v=2.0 cv=NYRkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=ASPqzAbYsGkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=DYwG_jj1po8db-oJkAsA:9 a=8cGKsuDSvutnUMynp6gA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334263193.23924.353.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH][GIT PULL][v3.4] tracing: Fix build breakage without
 CONFIG_PERF_EVENTS (again)
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Date: Thu, 12 Apr 2012 16:39:53 -0400
In-Reply-To: <1334262300.23924.348.camel@gandalf.stny.rr.com>
References: <1334262300.23924.348.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-12 at 16:25 -0400, Steven Rostedt wrote:
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 95059f0..ff639ca 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -836,11 +836,15 @@ extern const char *__stop___trace_bprintk_fmt[];
>  		     filter)
>  #include "trace_entries.h"
>  

Looking at this patch in more depth, it may be cleaner to do:

#if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_FUNCTION_TRACER)
int perf_ftrace_event_register(struct ftrace_event_call *call,
  			       enum trace_reg type, void *data);
#else
# define perf_ftrace_event_register NULL
#endif

Mark, would you like to make the above update?

Thanks,

-- Steve


> +#ifdef CONFIG_PERF_EVENTS
>  #ifdef CONFIG_FUNCTION_TRACER
>  int perf_ftrace_event_register(struct ftrace_event_call *call,
>  			       enum trace_reg type, void *data);
>  #else
>  #define perf_ftrace_event_register NULL
>  #endif /* CONFIG_FUNCTION_TRACER */
> +#else
> +#define perf_ftrace_event_register NULL
> +#endif /* CONFIG_PERF_EVENTS */
>  
>  #endif /* _LINUX_KERNEL_TRACE_H */
> 


