Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab2BGAU3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 19:20:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491Ab2BGAU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 19:20:28 -0500
Date: Tue, 7 Feb 2012 01:20:15 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        paulus@samba.org, acme@ghostprotocols.net, a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, aarapov@redhat.com
Subject: Re: [PATCH 7/7] ftrace, perf: Add filter support for function trace
 event
Message-ID: <20120207002015.GA2831@m.redhat.com>
References: <1326912275-26405-1-git-send-email-jolsa@redhat.com>
 <1327776209-4883-1-git-send-email-jolsa@redhat.com>
 <1327776209-4883-8-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327776209-4883-8-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 28, 2012 at 07:43:29PM +0100, Jiri Olsa wrote:
> Adding support to filter function trace event via perf
> interface. It is now possible to use filter interface
> in the perf tool like:
> 
>   perf record -e ftrace:function --filter="(ip == mm_*)" ls
> 
> The filter syntax is restricted to the the 'ip' field only,
> and following operators are accepted '==' '!=' '||', ending
> up with the filter strings like:
> 
>   ip == f1[, ]f2 ... || ip != f3[, ]f4 ...
> 
> with comma ',' or space ' ' as a function separator. If the
> space ' ' is used as a separator, the right side of the
> assignment needs to be enclosed in double quotes '"'.
> 
> The '==' operator adds trace filter with same effect as would
> be added via set_ftrace_filter file.
> 
> The '!=' operator adds trace filter with same effect as would
> be added via set_ftrace_notrace file.
> 
> The right side of the '!=', '==' operators is list of functions
> or regexp. to be added to filter separated by space.
> 
> The '||' operator is used for connecting multiple filter definitions
> together. It is possible to have more than one '==' and '!='
> operators within one filter string.
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>

SNIP

>  static void perf_ftrace_function_enable(struct perf_event *event)
> diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> index eb04a2a..c8a64ec 100644
> --- a/kernel/trace/trace_events_filter.c
> +++ b/kernel/trace/trace_events_filter.c
> @@ -54,6 +54,13 @@ struct filter_op {
>  	int precedence;
>  };
>  
> +static struct filter_op filter_ftrace_ops[] = {
> +	{ OP_OR,	"||",		1 },
> +	{ OP_NE,	"!=",		2 },
> +	{ OP_EQ,	"==",		2 },
> +	{ OP_NONE,	"OP_NONE",	0 },
> +};

ugh.. just found I cannot define filter_ftrace_ops like this,
will send fix with new version.

thanks,
jirka
