Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab0CXNBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 09:01:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:43089 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004Ab0CXNBo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 09:01:44 -0400
Subject: Re: [PATCH][RESEND] tracing: Fix lockdep warning in global_clock()
From: Peter Zijlstra <peterz@infradead.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4BA97FA1.7030606@cn.fujitsu.com>
References: <4BA97FA1.7030606@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 24 Mar 2010 14:01:31 +0100
Message-ID: <1269435691.5109.236.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
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
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

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

