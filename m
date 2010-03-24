Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab0CXDDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 23:03:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:51619 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419Ab0CXDDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 23:03:49 -0400
X-Authority-Analysis: v=1.0 c=1 a=nbUHkydfttcA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=omOdbC7AAAAA:8 a=KofTMTqHOdg-s3cLyo4A:9 a=V_V50z-2Y0T9ldF3NR54deq3lEcA:4 a=PUjeQqilurYA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH][RESEND] tracing: Fix lockdep warning in global_clock()
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4BA97FA1.7030606@cn.fujitsu.com>
References: <4BA97FA1.7030606@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 23 Mar 2010 23:03:46 -0400
Message-ID: <1269399826.2957.1933.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-24 at 10:57 +0800, Li Zefan wrote:
> # echo 1 > events/enable
>  # echo global > trace_clock
> 
> ------------[ cut here ]------------
> WARNING: at kernel/lockdep.c:3162 check_flags+0xb2/0x190()
> ...
> ---[ end trace 3f86734a89416623 ]---
> possible reason: unannotated irqs-on.
> ...
> 

Peter,

I see no problem with this patch, but I do want your Acked-by for it.

Thanks,

-- Steve

> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/trace/trace_clock.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
> index 6fbfb8f..9d589d8 100644
> --- a/kernel/trace/trace_clock.c
> +++ b/kernel/trace/trace_clock.c
> @@ -84,7 +84,7 @@ u64 notrace trace_clock_global(void)
>  	int this_cpu;
>  	u64 now;
>  
> -	raw_local_irq_save(flags);
> +	local_irq_save(flags);
>  
>  	this_cpu = raw_smp_processor_id();
>  	now = cpu_clock(this_cpu);
> @@ -110,7 +110,7 @@ u64 notrace trace_clock_global(void)
>  	arch_spin_unlock(&trace_clock_struct.lock);
>  
>   out:
> -	raw_local_irq_restore(flags);
> +	local_irq_restore(flags);
>  
>  	return now;
>  }


