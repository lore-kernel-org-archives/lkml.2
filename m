Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127Ab0DAQdF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:33:05 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60534 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757905Ab0DAQc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:32:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sQ8LvoALeRACBVh1vp5Q6ABiM7WUou18DVFkpg63tNlbBj6d/DCFbhXDPytvYBCSQ8
         JvgP07Sa+3o2yGd6qvjSleXosD867fpL+fxgvxOO+rMZHIQ3G8HyyNruegjZhMhS9LaM
         RE68TRSWv1jUkFXQpNtLt5Tm2G16SmmiEHTc4=
Date: Thu, 1 Apr 2010 19:32:58 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5 3/4] tracing: graph output support for irqsoff tracer
Message-ID: <20100401173251.GC5153@nowhere>
References: <1270136229-15263-1-git-send-email-jolsa@redhat.com> <1270136229-15263-4-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270136229-15263-4-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 05:37:08PM +0200, Jiri Olsa wrote:
> +static int start_irqsoff_tracer(struct trace_array *tr, int graph)
>  {
> -	register_ftrace_function(&trace_ops);
> -	if (tracing_is_enabled())
> +	int ret = 0;
> +
> +	if (!graph)
> +		ret = register_ftrace_function(&trace_ops);
> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> +	else
> +		ret = register_ftrace_graph(&irqsoff_graph_return,
> +					    &irqsoff_graph_entry);
> +#endif



Please rather define static inline stubs for register_ftrace_graph
in linux/ftrace.h if !CONFIG_FUNCTION_GRAPH_TRACER



> +
> +	if (!ret && tracing_is_enabled())
>  		tracer_enabled = 1;
>  	else
>  		tracer_enabled = 0;
> +
> +	return ret;
>  }
>  
> -static void stop_irqsoff_tracer(struct trace_array *tr)
> +static void stop_irqsoff_tracer(struct trace_array *tr, int graph)
>  {
>  	tracer_enabled = 0;
> -	unregister_ftrace_function(&trace_ops);
> +
> +	if (!graph)
> +		unregister_ftrace_function(&trace_ops);
> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> +	else
> +		unregister_ftrace_graph();
> +#endif



Same here.

Thanks.

