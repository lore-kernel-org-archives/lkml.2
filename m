Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab0ELC07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 22:26:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47842 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab0ELC06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 22:26:58 -0400
X-Authority-Analysis: v=1.1 cv=PaD2Wv+9xJqXNP3J8apim3QBTBpXOuB+BaCFQon6buA= c=1 sm=0 a=sJlmgwa1rWMA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=omOdbC7AAAAA:8 a=bZpWqcX92lUi1ZgIi6wA:9 a=XjwhhoBSeVr32RX6yt0A:7 a=9EFc2LHp4FO13Ye6YLZr1C4C83IA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] tracing: Fix function declarations if
 !CONFIG_STACKTRACE
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4BE77C14.5010806@cn.fujitsu.com>
References: <4BE77C14.5010806@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 11 May 2010 22:26:55 -0400
Message-ID: <1273631215.27703.17.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-10 at 11:23 +0800, Li Zefan wrote:
> ftrace_trace_stack() and frace_trace_userstacke() take a
> struct ring_buffer argument, not struct trace_array. Commit
> e77405ad("tracing: pass around ring buffer instead of tracer")
> made this change.
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Thanks Li,

I'll add this when I'm finished working on the TRACE_EVENT() updates.

-- Steve

> ---
>  kernel/trace/trace.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index d1ce0be..58f6896 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -405,12 +405,12 @@ void ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags,
>  void __trace_stack(struct trace_array *tr, unsigned long flags, int skip,
>  		   int pc);
>  #else
> -static inline void ftrace_trace_stack(struct trace_array *tr,
> +static inline void ftrace_trace_stack(struct ring_buffer *buffer,
>  				      unsigned long flags, int skip, int pc)
>  {
>  }
>  
> -static inline void ftrace_trace_userstack(struct trace_array *tr,
> +static inline void ftrace_trace_userstack(struct ring_buffer *buffer,
>  					  unsigned long flags, int pc)
>  {
>  }


