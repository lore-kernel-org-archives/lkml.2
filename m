Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037Ab2BGWyh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 17:54:37 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:44405 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755661Ab2BGWyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 17:54:36 -0500
Date: Tue, 7 Feb 2012 14:51:36 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rob Herring <robherring2@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Kevin Hilman <khilman@ti.com>, Josh Triplett <josh@joshtriplett.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 2/3][RFC] x86/tracing: Denote the power and cpuidle
 tracepoints as _rcuidle()
Message-ID: <20120207225136.GA3233@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120207145653.829892056@goodmis.org>
 <20120207151049.413659845@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120207151049.413659845@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020722-5930-0000-0000-000004E14DB5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 07, 2012 at 09:56:55AM -0500, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> The power and cpuidle tracepoints are called within a rcu_idle_exit()
> section, and must be denoted with the _rcuidle() version of the tracepoint.
> 
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

(Sorry, fat-fingered this one the first time around.)

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  arch/x86/kernel/process.c |   24 ++++++++++++------------
>  1 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index 15763af..44eefde 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -377,8 +377,8 @@ static inline int hlt_use_halt(void)
>  void default_idle(void)
>  {
>  	if (hlt_use_halt()) {
> -		trace_power_start(POWER_CSTATE, 1, smp_processor_id());
> -		trace_cpu_idle(1, smp_processor_id());
> +		trace_power_start_rcuidle(POWER_CSTATE, 1, smp_processor_id());
> +		trace_cpu_idle_rcuidle(1, smp_processor_id());
>  		current_thread_info()->status &= ~TS_POLLING;
>  		/*
>  		 * TS_POLLING-cleared state must be visible before we
> @@ -391,8 +391,8 @@ void default_idle(void)
>  		else
>  			local_irq_enable();
>  		current_thread_info()->status |= TS_POLLING;
> -		trace_power_end(smp_processor_id());
> -		trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
> +		trace_power_end_rcuidle(smp_processor_id());
> +		trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
>  	} else {
>  		local_irq_enable();
>  		/* loop is done by the caller */
> @@ -450,8 +450,8 @@ EXPORT_SYMBOL_GPL(cpu_idle_wait);
>  static void mwait_idle(void)
>  {
>  	if (!need_resched()) {
> -		trace_power_start(POWER_CSTATE, 1, smp_processor_id());
> -		trace_cpu_idle(1, smp_processor_id());
> +		trace_power_start_rcuidle(POWER_CSTATE, 1, smp_processor_id());
> +		trace_cpu_idle_rcuidle(1, smp_processor_id());
>  		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
>  			clflush((void *)&current_thread_info()->flags);
> 
> @@ -461,8 +461,8 @@ static void mwait_idle(void)
>  			__sti_mwait(0, 0);
>  		else
>  			local_irq_enable();
> -		trace_power_end(smp_processor_id());
> -		trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
> +		trace_power_end_rcuidle(smp_processor_id());
> +		trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
>  	} else
>  		local_irq_enable();
>  }
> @@ -474,13 +474,13 @@ static void mwait_idle(void)
>   */
>  static void poll_idle(void)
>  {
> -	trace_power_start(POWER_CSTATE, 0, smp_processor_id());
> -	trace_cpu_idle(0, smp_processor_id());
> +	trace_power_start_rcuidle(POWER_CSTATE, 0, smp_processor_id());
> +	trace_cpu_idle_rcuidle(0, smp_processor_id());
>  	local_irq_enable();
>  	while (!need_resched())
>  		cpu_relax();
> -	trace_power_end(smp_processor_id());
> -	trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
> +	trace_power_end_rcuidle(smp_processor_id());
> +	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
>  }
> 
>  /*
> -- 
> 1.7.8.3
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

