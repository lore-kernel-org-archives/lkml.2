Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345Ab0DLXdn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 19:33:43 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:39790 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314Ab0DLXdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 19:33:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mUowCYdfNMiq/fmR3akNb0C6w8ai/dCxLcdPc3gEN077LHAMSr2SmjvWQf2C2GvHG/
         WxInEHn/rWUFhpUEp7YmDK98fS95AjsbbN1lPsMJfiDDd0mLQP0K4/PnIkcMvtdC3g5W
         y0fpP1N6s5mmcu8jEVL/6aq30m1235M4nNqWk=
Date: Tue, 13 Apr 2010 01:33:37 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv6 3/4] tracing: graph output support for irqsoff tracer
Message-ID: <20100412233332.GH8285@nowhere>
References: <1270227683-14631-1-git-send-email-jolsa@redhat.com> <1270227683-14631-4-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270227683-14631-4-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 02, 2010 at 07:01:22PM +0200, Jiri Olsa wrote:
> +#define GRAPH_TRACER_FLAGS (TRACE_GRAPH_PRINT_CPU | \
> +			    TRACE_GRAPH_PRINT_PROC)
> +
> +static enum print_line_t irqsoff_print_line(struct trace_iterator *iter)
> +{
> +	u32 flags = GRAPH_TRACER_FLAGS;
> +
> +	if (trace_flags & TRACE_ITER_LATENCY_FMT)
> +		flags |= TRACE_GRAPH_PRINT_DURATION;
> +	else
> +		flags |= TRACE_GRAPH_PRINT_ABS_TIME;



Why not having ABS_TIME in any case?

And more important, you probably want to add TRACE_ITER_LATENCY_FMT
as well to get the contexts (need-resched, hardirq/softirq, preempt-depth,
lock-depth)



> +	/*
> +	 * In graph mode call the graph tracer output function,
> +	 * otherwise go with the TRACE_FN event handler
> +	 */
> +	if (is_graph())
> +		return print_graph_function_flags(iter, flags);
> +
> +	return TRACE_TYPE_UNHANDLED;
> +}
> +
> +static void irqsoff_print_header(struct seq_file *s)
> +{
> +	if (is_graph()) {
> +		struct trace_iterator *iter = s->private;
> +		u32 flags = GRAPH_TRACER_FLAGS;
> +
> +		if (trace_flags & TRACE_ITER_LATENCY_FMT) {
> +			/* print nothing if the buffers are empty */
> +			if (trace_empty(iter))
> +				return;
> +
> +			print_trace_header(s, iter);
> +			flags |= TRACE_GRAPH_PRINT_DURATION;
> +		} else
> +			flags |= TRACE_GRAPH_PRINT_ABS_TIME;
> +
> +		print_graph_headers_flags(s, flags);



Same here.


Other than these few comments, the whole set looks good!

Thanks!

