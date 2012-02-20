Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369Ab2BTSJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 13:09:17 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4722 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab2BTSJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 13:09:16 -0500
X-Authority-Analysis: v=2.0 cv=MaXuSuDf c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=cmBuszERE20A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=6rqHouBjAAAA:8 a=HZLBGm3rWhYEIv5dZMAA:9 a=PUjeQqilurYA:10 a=TAmEwCHjoHMA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1329761354.25686.32.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] trace: don't print an extra separator of flags
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 20 Feb 2012 13:09:14 -0500
In-Reply-To: <1329650167-480655-1-git-send-email-avagin@openvz.org>
References: <1329650167-480655-1-git-send-email-avagin@openvz.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-02-19 at 14:16 +0300, Andrew Vagin wrote:
> From: Andrey Vagin <avagin@openvz.org>
> 
> It occurs if __print_flags is used more than once

Hi, which tracepoint does this? I like to see what the issue is.

Thanks,

-- Steve

> 
> Signed-off-by: Andrew Vagin <avagin@openvz.org>
> ---
>  kernel/trace/trace_output.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
> index 0d6ff35..3efd718 100644
> --- a/kernel/trace/trace_output.c
> +++ b/kernel/trace/trace_output.c
> @@ -300,7 +300,7 @@ ftrace_print_flags_seq(struct trace_seq *p, const char *delim,
>  	unsigned long mask;
>  	const char *str;
>  	const char *ret = p->buffer + p->len;
> -	int i;
> +	int i, first = 1;
>  
>  	for (i = 0;  flag_array[i].name && flags; i++) {
>  
> @@ -310,8 +310,10 @@ ftrace_print_flags_seq(struct trace_seq *p, const char *delim,
>  
>  		str = flag_array[i].name;
>  		flags &= ~mask;
> -		if (p->len && delim)
> +		if (!first && delim)
>  			trace_seq_puts(p, delim);
> +		else
> +			first = 0;
>  		trace_seq_puts(p, str);
>  	}
>  


