Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab1HJVYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 17:24:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61560 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755022Ab1HJVYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 17:24:44 -0400
X-Authority-Analysis: v=1.1 cv=sbbt6Wn8j+VvNVI1Ftt/uHhinWyuFt+R57MN9Ty2Tys= c=1 sm=0 a=8ngbtJSub7gA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=OK6KGJRP79UmbsUhLNcA:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCHv2 10/10] tracing/filter: Add startup tests for events
 filter
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20110804112251.GA3797@jolsa.brq.redhat.com>
References: <1312452506-5100-1-git-send-email-jolsa@redhat.com>
	 <1312452506-5100-11-git-send-email-jolsa@redhat.com>
	 <20110804112251.GA3797@jolsa.brq.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 10 Aug 2011 17:24:42 -0400
Message-ID: <1313011482.18583.279.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-04 at 13:22 +0200, Jiri Olsa wrote:
> oops,
> I sent wrong version with small leak, proper one attached..
> 
> thanks,
> jirka
> 
> 
> ---
> Adding automated tests running as late_initcall. Tests are
> compiled in with CONFIG_FTRACE_STARTUP_TEST option.
> 
> Adding test event "ftrace_test_filter" used to simulate
> filter processing during event occurance.
> 
> String filters are compiled and tested against several
> test events with different values.
> 
> Also testing that evaluation of explicit predicates is ommited
> due to the lazy filter evaluation.
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  include/trace/events/test.h        |   45 ++++++++
>  kernel/trace/trace.h               |    3 +
>  kernel/trace/trace_events_filter.c |  209 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 257 insertions(+), 0 deletions(-)
>  create mode 100644 include/trace/events/test.h
> 
> diff --git a/include/trace/events/test.h b/include/trace/events/test.h
> new file mode 100644
> index 0000000..81c5484
> --- /dev/null
> +++ b/include/trace/events/test.h

Hmm, I'd like to keep this out of the include/trace/events directory.
Could you put this directly into the kernel/trace/ directory, using the
Makefile tricks in samples/trace_events/Makefile and the
TRACE_INCLUDE_PATH as seen in samples/trace_events/trace-events-sample.h

-- Steve


> @@ -0,0 +1,45 @@
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM test
> +
> +#if !defined(_TRACE_TEST_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_TEST_H
> +
> +#include <linux/tracepoint.h>
> +
> +TRACE_EVENT(ftrace_test_filter,
> +
> +	TP_PROTO(int a, int b, int c, int d, int e, int f, int g, int h),
> +
> +	TP_ARGS(a, b, c, d, e, f, g, h),
> +
> +	TP_STRUCT__entry(
> +		__field(int, a)
> +		__field(int, b)
> +		__field(int, c)
> +		__field(int, d)
> +		__field(int, e)
> +		__field(int, f)
> +		__field(int, g)
> +		__field(int, h)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->a = a;
> +		__entry->b = b;
> +		__entry->c = c;
> +		__entry->d = d;
> +		__entry->e = e;
> +		__entry->f = f;
> +		__entry->g = g;
> +		__entry->h = h;
> +	),
> +
> +	TP_printk("a %d, b %d, c %d, d %d, e %d, f %d, g %d, h %d",
> +		  __entry->a, __entry->b, __entry->c, __entry->d,
> +		  __entry->e, __entry->f, __entry->g, __entry->h)
> +);
> +


