Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095Ab2JPR6K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 13:58:10 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:48470 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab2JPR6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 13:58:08 -0400
Date: Tue, 16 Oct 2012 09:32:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: peterz@infradead.org, acme@ghostprotocols.net, mingo@kernel.org,
        tglx@linutronix.de, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH 2/2] perf, cpu hotplug: Use cached value of
 smp_processor_id()
Message-ID: <20121016163211.GB2385@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20121016075809.3572.47848.stgit@srivatsabhat.in.ibm.com>
 <20121016075817.3572.76733.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121016075817.3572.76733.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101617-5406-0000-0000-0000012BB623
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 01:28:17PM +0530, Srivatsa S. Bhat wrote:
> The perf_cpu_notifier() macro invokes smp_processor_id() multiple
> times. Optimize it by using a local variable.
> 
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
> 
>  include/linux/perf_event.h |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 0647805..6bfb2faa 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -803,15 +803,16 @@ static inline void perf_event_task_tick(void)				{ }
>  do {									\
>  	static struct notifier_block fn##_nb __cpuinitdata =		\
>  		{ .notifier_call = fn, .priority = CPU_PRI_PERF };	\
> +	unsigned long cpu = smp_processor_id();				\
>  	unsigned long flags;						\
>  	fn(&fn##_nb, (unsigned long)CPU_UP_PREPARE,			\
> -		(void *)(unsigned long)smp_processor_id());		\
> +		(void *)(unsigned long)cpu);				\
>  	local_irq_save(flags);						\
>  	fn(&fn##_nb, (unsigned long)CPU_STARTING,			\
> -		(void *)(unsigned long)smp_processor_id());		\
> +		(void *)(unsigned long)cpu);				\
>  	local_irq_restore(flags);					\
>  	fn(&fn##_nb, (unsigned long)CPU_ONLINE,				\
> -		(void *)(unsigned long)smp_processor_id());		\
> +		(void *)(unsigned long)cpu);				\
>  	register_cpu_notifier(&fn##_nb);				\
>  } while (0)
> 
> 

