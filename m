Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933080Ab2CZRNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 13:13:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7626 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932667Ab2CZRNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 13:13:19 -0400
X-Authority-Analysis: v=2.0 cv=P4S4d18u c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=wBLf1-ka6lYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=pGLkceISAAAA:8 a=h2bMMLQGu82jfTVKS-cA:9 a=BI4mPJJOTQOGITsJzRYA:7 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1332781998.23924.112.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 1/1] ftrace: fix dynamic ftrace filter reset issue
From: Steven Rostedt <rostedt@goodmis.org>
To: Rajesh Bhagat <rajesh.lnx@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 26 Mar 2012 13:13:18 -0400
In-Reply-To: <CA+jqyFDRBkeAA8OPuBmAoj_ZF_HgR-U6Eu1QQ8oe_PKeN1pVFQ@mail.gmail.com>
References: <CA+jqyFDRBkeAA8OPuBmAoj_ZF_HgR-U6Eu1QQ8oe_PKeN1pVFQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-21 at 11:22 +0530, Rajesh Bhagat wrote:

> Signed-off-by: Rajesh Bhagat <rajesh.lnx@gmail.com>
> ---
>  kernel/trace/trace.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index a3f1bc5..f4fb190 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -3058,8 +3058,10 @@ static int tracing_set_tracer(const char *buf)
>         ret = -EINVAL;
>         goto out;
>     }
> -   if (t == current_trace)
> +   if (t == current_trace) {
> +       tracing_reset_online_cpus(tr);
>         goto out;
> +   }

BTW, this patch has major whitespace problems. You need to fix your mail
client. For a trivial patch like this, I can fix up, but anything else
will become a major issue. And we do not accept attachments.

-- Steve


