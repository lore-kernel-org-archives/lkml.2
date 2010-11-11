Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab0KKMRi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 07:17:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756159Ab0KKMRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 07:17:37 -0500
Date: Thu, 11 Nov 2010 13:17:33 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, oleg@redhat.com
Subject: Re: [PATCH] tracing - add indexes to the array values definitions
Message-ID: <20101111121733.GB1946@jolsa.brq.redhat.com>
References: <1289468965-8166-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289468965-8166-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

oops, I got confused.. please ignore this one :)

wbr,
jirka

On Thu, Nov 11, 2010 at 10:49:25AM +0100, Jiri Olsa wrote:
> Adding indexes to trace_options and err_text arrays definitions.
> It helps the code readability.
> 
> wbr,
> jirka
> 
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  kernel/trace/trace.c               |   42 ++++++++++++++++++------------------
>  kernel/trace/trace_events_filter.c |   25 +++++++++++----------
>  2 files changed, 34 insertions(+), 33 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 82d9b81..cf2b0e5 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -405,27 +405,27 @@ unsigned long nsecs_to_usecs(unsigned long nsecs)
>  
>  /* These must match the bit postions in trace_iterator_flags */
>  static const char *trace_options[] = {
> -	"print-parent",
> -	"sym-offset",
> -	"sym-addr",
> -	"verbose",
> -	"raw",
> -	"hex",
> -	"bin",
> -	"block",
> -	"stacktrace",
> -	"trace_printk",
> -	"ftrace_preempt",
> -	"branch",
> -	"annotate",
> -	"userstacktrace",
> -	"sym-userobj",
> -	"printk-msg-only",
> -	"context-info",
> -	"latency-format",
> -	"sleep-time",
> -	"graph-time",
> -	"record-cmd",
> +	[TRACE_ITER_PRINT_PARENT]   = "print-parent",
> +	[TRACE_ITER_SYM_OFFSET]     = "sym-offset",
> +	[TRACE_ITER_SYM_ADDR]       = "sym-addr",
> +	[TRACE_ITER_VERBOSE]        = "verbose",
> +	[TRACE_ITER_RAW]            = "raw",
> +	[TRACE_ITER_HEX]            = "hex",
> +	[TRACE_ITER_BIN]            = "bin",
> +	[TRACE_ITER_BLOCK]          = "block",
> +	[TRACE_ITER_STACKTRACE]     = "stacktrace",
> +	[TRACE_ITER_PRINTK]         = "trace_printk",
> +	[TRACE_ITER_PREEMPTONLY]    = "ftrace_preempt",
> +	[TRACE_ITER_BRANCH]         = "branch",
> +	[TRACE_ITER_ANNOTATE]       = "annotate",
> +	[TRACE_ITER_USERSTACKTRACE] = "userstacktrace",
> +	[TRACE_ITER_SYM_USEROBJ]    = "sym-userobj",
> +	[TRACE_ITER_PRINTK_MSGONLY] = "printk-msg-only",
> +	[TRACE_ITER_CONTEXT_INFO]   = "context-info",
> +	[TRACE_ITER_LATENCY_FMT]    = "latency-format",
> +	[TRACE_ITER_SLEEP_TIME]     = "sleep-time",
> +	[TRACE_ITER_GRAPH_TIME]     = "graph-time",
> +	[TRACE_ITER_RECORD_CMD]     = "record-cmd",
>  	NULL
>  };
>  
> diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> index 36d4010..efb50eb 100644
> --- a/kernel/trace/trace_events_filter.c
> +++ b/kernel/trace/trace_events_filter.c
> @@ -78,18 +78,19 @@ enum {
>  };
>  
>  static char *err_text[] = {
> -	"No error",
> -	"Invalid operator",
> -	"Unbalanced parens",
> -	"Too many operands",
> -	"Operand too long",
> -	"Field not found",
> -	"Illegal operation for field type",
> -	"Illegal integer value",
> -	"Couldn't find or set field in one of a subsystem's events",
> -	"Too many terms in predicate expression",
> -	"Missing field name and/or value",
> -	"Meaningless filter expression",
> +	[FILT_ERR_NONE]              = "No error",
> +	[FILT_ERR_INVALID_OP]        = "Invalid operator",
> +	[FILT_ERR_UNBALANCED_PAREN]  = "Unbalanced parens",
> +	[FILT_ERR_TOO_MANY_OPERANDS] = "Too many operands",
> +	[FILT_ERR_OPERAND_TOO_LONG]  = "Operand too long",
> +	[FILT_ERR_FIELD_NOT_FOUND]   = "Field not found",
> +	[FILT_ERR_ILLEGAL_FIELD_OP]  = "Illegal operation for field type",
> +	[FILT_ERR_ILLEGAL_INTVAL]    = "Illegal integer value",
> +	[FILT_ERR_BAD_SUBSYS_FILTER] = "Couldn't find or set field in one of"
> +				       " a subsystem's events",
> +	[FILT_ERR_TOO_MANY_PREDS]    = "Too many terms in predicate expression",
> +	[FILT_ERR_MISSING_FIELD]     = "Missing field name and/or value",
> +	[FILT_ERR_INVALID_FILTER]    = "Meaningless filter expression",
>  };
>  
>  struct opstack_op {
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
