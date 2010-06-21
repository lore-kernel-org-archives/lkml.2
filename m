Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561Ab0FUO2n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 10:28:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:39341 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab0FUO2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 10:28:42 -0400
X-Authority-Analysis: v=1.1 cv=w1shWbTWTAfAQ6jIUag4hBIbd8wqGnfzh/ne7nEp+Po= c=1 sm=0 a=MjmHPCbp0jsA:10 a=ood2b7iyd8MA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=pGLkceISAAAA:8 a=ayqztE60YIDjpZbvhywA:9 a=Z92mY6PWu2-bq0yVONT-QAZiT_AA:4 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] tracing: Fix undelared ENOSYS in
 include/linux/tracepoint.h
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>
In-Reply-To: <1277118549-622-1-git-send-email-wuzhangjin@gmail.com>
References: <1277118549-622-1-git-send-email-wuzhangjin@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 21 Jun 2010 10:28:40 -0400
Message-ID: <1277130520.9181.12.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-21 at 19:09 +0800, Wu Zhangjin wrote:
> From: Wu Zhangjin <wuzhangjin@gmail.com>
> 
> The header file include/linux/tracepoint.h may be included without
> include/linux/errno.h and then the compiler will fail on building for
> undelcared ENOSYS. This patch fixes this problem via including <linux/errno.h>
> to include/linux/tracepoint.h.
> 

Hi Wu,

I have not hit this. Did you hit this with mips? Does it need to get
into 2.6.35 or can it wait till 2.6.36?

-- Steve

> Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
> ---
>  include/linux/tracepoint.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> index 9a59d1f..103d1b6 100644
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -14,6 +14,7 @@
>   * See the file COPYING for more details.
>   */
>  
> +#include <linux/errno.h>
>  #include <linux/types.h>
>  #include <linux/rcupdate.h>
>  


