Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab2BQRWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 12:22:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4046 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab2BQRWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 12:22:22 -0500
X-Authority-Analysis: v=2.0 cv=HeuWv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=Dh-nGx2rQAIA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=n0L0DoIFRTeAVdATwYcA:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 1/1] ftrace: fix function graph tracer
From: Steven Rostedt <rostedt@goodmis.org>
To: Rajesh Bhagat <rajesh.lnx@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <CA+jqyFAabkTRWENA5Cu8Q8O5Vc+4hmeiTS2_tduuLt2LH+mHBA@mail.gmail.com>
References: <CA+jqyFAabkTRWENA5Cu8Q8O5Vc+4hmeiTS2_tduuLt2LH+mHBA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Feb 2012 12:22:16 -0500
Message-ID: <1329499337.10311.10.camel@acer.local.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-17 at 21:39 +0530, Rajesh Bhagat wrote:

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

Nice catch! This should also go into stable. When I get back from the
conference I'll start getting it upstream.

Thanks,

-- Steve


