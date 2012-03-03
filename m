Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751062Ab2CCFGg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 00:06:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31606 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab2CCFGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 00:06:32 -0500
X-Authority-Analysis: v=2.0 cv=Z7xu7QtA c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Dh-nGx2rQAIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=pGLkceISAAAA:8 a=iT3oVe0_OGzvZUNVy1wA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1330751190.25686.321.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 1/1] ftrace: fix function graph tracer
From: Steven Rostedt <rostedt@goodmis.org>
To: Rajesh Bhagat <rajesh.lnx@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Sat, 03 Mar 2012 00:06:30 -0500
In-Reply-To: <CA+jqyFAabkTRWENA5Cu8Q8O5Vc+4hmeiTS2_tduuLt2LH+mHBA@mail.gmail.com>
References: <CA+jqyFAabkTRWENA5Cu8Q8O5Vc+4hmeiTS2_tduuLt2LH+mHBA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-17 at 21:39 +0530, Rajesh Bhagat wrote:
> >From 31f8971a19b45aae8227c6d143a6ecde26fa68b2 Mon Sep 17 00:00:00 2001
> From: Rajesh Bhagat <rajesh.lnx@gmail.com>
> Date: Fri, 17 Feb 2012 13:59:15 +0530
> Subject: [PATCH 1/1] ftrace: fix function graph tracer
> 
> when function tracer is set - function_graph tracer is not working
> Problem occurs when CONFIG_DYNAMIC_FTRACE is not set
> 
> Output before patch
> /debug/tracing # echo function > current_tracer
> /debug/tracing # echo function_graph > current_tracer
> /debug/tracing # cat trace

I can't reproduce this. What arch did you see this on? I'm trying it on
PPC and x86, and it works fine.

Now I'm not saying I wont take this patch, because it is a correctness
issue. But I'm thinking this will go into the 3.4 queue.

-- Steve


> 
> Output after patch
> /debug/tracing # echo function > current_tracer
> /debug/tracing # echo function_graph > current_tracer
> /debug/tracing # cat trace
> 0) ! 253.375 us | } /* irq_enter */
> 0) | generic_handle_irq() {
> 0) | handle_fasteoi_irq() {
> 0) 9.208 us | _raw_spin_lock();
> 0) | handle_irq_event() {
> 0) | handle_irq_event_percpu() {
> 
> Signed-off-by: Rajesh Bhagat <rajesh.lnx@gmail.com>
> ---
>  kernel/trace/ftrace.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 683d559..dc2de98 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -219,7 +219,8 @@ static void update_ftrace_function(void)
>  #else
>     __ftrace_trace_function = func;
>  #endif
> -   ftrace_trace_function = ftrace_test_stop_func;
> +   ftrace_trace_function =
> +       (func == ftrace_stub) ? func : ftrace_test_stop_func;
>  #endif
>  }


