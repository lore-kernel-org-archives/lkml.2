Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab1HLRGb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 13:06:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62731 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab1HLRGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 13:06:30 -0400
X-Authority-Analysis: v=1.1 cv=sbbt6Wn8j+VvNVI1Ftt/uHhinWyuFt+R57MN9Ty2Tys= c=1 sm=0 a=t46GFYAlYqgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=hD80L64hAAAA:8 a=Y3s_nfE6k1A7eICYLfEA:9 a=PUjeQqilurYA:10 a=v3rLFGiuRE8A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] ftrace: tracing_on to start/stop tracing
From: Steven Rostedt <rostedt@goodmis.org>
To: Geunsik Lim <leemgs1@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1313127022-23830-1-git-send-email-leemgs1@gmail.com>
References: <1313127022-23830-1-git-send-email-leemgs1@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 12 Aug 2011 13:06:28 -0400
Message-ID: <1313168788.18583.342.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-12 at 14:30 +0900, Geunsik Lim wrote:
> From: Geunsik Lim <geunsik.lim@samsung.com>
> 
> tracing_enabled option is deprecated.
> To start/stop tracing, write to /sys/kernel/debug/tracing/tracing_on
> without tracing_enabled. This patch is based on Linux 3.1.0-rc1
> 

Ug, I thought I fixed this. OK, thanks. Maybe we can add this to 3.1, as
it is a very low risk patch and fixes something that can confuse people.

-- Steve

> Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>
> ---
>  kernel/trace/trace.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index e5df02c..91abdbf 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -2710,9 +2710,9 @@ static const char readme_msg[] =
>  	"# cat /sys/kernel/debug/tracing/trace_options\n"
>  	"noprint-parent nosym-offset nosym-addr noverbose\n"
>  	"# echo print-parent > /sys/kernel/debug/tracing/trace_options\n"
> -	"# echo 1 > /sys/kernel/debug/tracing/tracing_enabled\n"
> +	"# echo 1 > /sys/kernel/debug/tracing/tracing_on\n"
>  	"# cat /sys/kernel/debug/tracing/trace > /tmp/trace.txt\n"
> -	"# echo 0 > /sys/kernel/debug/tracing/tracing_enabled\n"
> +	"# echo 0 > /sys/kernel/debug/tracing/tracing_on\n"
>  ;
>  
>  static ssize_t


