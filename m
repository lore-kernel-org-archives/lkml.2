Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab2CMNgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 09:36:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15531 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422Ab2CMNgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 09:36:53 -0400
X-Authority-Analysis: v=2.0 cv=d9t3OGfE c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Dh-nGx2rQAIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=pGLkceISAAAA:8 a=n0L0DoIFRTeAVdATwYcA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1331645811.25686.661.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 1/1] ftrace: fix function graph tracer
From: Steven Rostedt <rostedt@goodmis.org>
To: Rajesh Bhagat <rajesh.lnx@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 13 Mar 2012 09:36:51 -0400
In-Reply-To: <CA+jqyFAabkTRWENA5Cu8Q8O5Vc+4hmeiTS2_tduuLt2LH+mHBA@mail.gmail.com>
References: <CA+jqyFAabkTRWENA5Cu8Q8O5Vc+4hmeiTS2_tduuLt2LH+mHBA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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

BTW, this patch has major whitespace issues. It does not apply.

-- Steve


