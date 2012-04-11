Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178Ab2DKMSy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 08:18:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9697 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab2DKMSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 08:18:53 -0400
X-Authority-Analysis: v=2.0 cv=Z8Fu7QtA c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=GQe9zCMQTfAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=gu6fZOg2AAAA:8 a=D19gQVrFAAAA:8 a=wggVRkVUAAAA:8 a=DYwG_jj1po8db-oJkAsA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334146730.23924.238.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] trace: Fix build breakage without CONFIG_PERF_EVENTS
From: Steven Rostedt <rostedt@goodmis.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Date: Wed, 11 Apr 2012 08:18:50 -0400
In-Reply-To: <1334132429-6091-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1334132429-6091-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Please change your subject when you submit a new patch. I've ignored
your last one because I thought I already applied it.

Your first patch:

  http://marc.info/?l=linux-kernel&m=133042701226637

Which was applied:

  https://lkml.org/lkml/2012/3/14/304


Your second patch:

  https://lkml.org/lkml/2012/3/26/164

As with this one, has the same subject. I only noticed it as I was about
to tell you that it was already applied.

Thanks,

-- Steve


On Wed, 2012-04-11 at 09:20 +0100, Mark Brown wrote:
> Today's -next fails to link for me:
> 
> kernel/built-in.o:(.data+0x178e50): undefined reference to `perf_ftrace_event_register'
> 
> It looks like multiple fixes have been merged for the issue fixed by
> commit fa73dc9 (tracing: Fix build breakage without CONFIG_PERF_EVENTS)
> though I can't identify the other changes that have gone in at the
> minute, it's possible that the changes which caused the breakage fixed
> by the previous commit got dropped but the fix made it in.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  kernel/trace/trace.h |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 95059f0..ff639ca 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -836,11 +836,15 @@ extern const char *__stop___trace_bprintk_fmt[];
>  		     filter)
>  #include "trace_entries.h"
>  
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


