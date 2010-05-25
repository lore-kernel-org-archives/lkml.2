Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757804Ab0EYDLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 23:11:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40466 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756157Ab0EYDLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 23:11:21 -0400
X-Authority-Analysis: v=1.1 cv=Pm0qIGCwx3bIEOZlSg1a56K3RSwKBTW9sPEb+DFvEKk= c=1 sm=0 a=PrpqVr8aNvUA:10 a=ood2b7iyd8MA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=AlxDmrjx4ldQ0oOngqoA:9 a=tm3rkmGAzBnx6RIJVQHy_5KwVrAA:4 a=PUjeQqilurYA:10 a=1JvJEtVdGvUA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 1/2] perf: Add persistent events
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lin Ming <ming.m.lin@intel.com>, linux-kernel@vger.kernel.org,
       Borislav Petkov <bp@alien8.de>
In-Reply-To: <1274555088-6292-2-git-send-email-bp@amd64.org>
References: <1274555088-6292-1-git-send-email-bp@amd64.org>
	 <1274555088-6292-2-git-send-email-bp@amd64.org>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 24 May 2010 23:11:18 -0400
Message-ID: <1274757078.22648.202.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-05-22 at 21:04 +0200, Borislav Petkov wrote:
> From: Borislav Petkov <bp@alien8.de>
> 
> Register and enable events marked as persistent right after perf events
> has initialized.
> 
> Not-yet-signed-off-by: Borislav Petkov <bp@alien8.de>
> ---
>  include/linux/ftrace_event.h |   10 +++++++
>  include/linux/perf_event.h   |    1 +
>  kernel/perf_event.c          |   59 +++++++++++++++++++++++++++++++++++++----
>  kernel/trace/trace.h         |    1 -
>  4 files changed, 64 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index c0f4b36..b40d637 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -13,6 +13,8 @@ struct dentry;
>  
>  DECLARE_PER_CPU(struct trace_seq, ftrace_event_seq);
>  
> +extern struct list_head ftrace_events;
> +
>  struct trace_print_flags {
>  	unsigned long		mask;
>  	const char		*name;
> @@ -134,6 +136,7 @@ struct ftrace_event_call {
>  	int			perf_refcount;
>  	int			(*perf_event_enable)(struct ftrace_event_call *);
>  	void			(*perf_event_disable)(struct ftrace_event_call *);
> +	unsigned int		type;
>  };

If you look at lastest tip/perf/core, can you add this to the
ftrace_event_class instead. Or if it must be per event, can we find a
way to include it into the flags field. Changes to flags must have the
event_mutex held.

-- Steve

>  
>  #define PERF_MAX_TRACE_SIZE	2048
> @@ -155,6 +158,13 @@ enum {
>  	FILTER_PTR_STRING,
>  };



