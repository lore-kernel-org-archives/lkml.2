Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab2BGUIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 15:08:09 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:48704 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563Ab2BGUIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 15:08:06 -0500
Date: Tue, 7 Feb 2012 07:40:09 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rob Herring <robherring2@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Kevin Hilman <khilman@ti.com>, Josh Triplett <josh@joshtriplett.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 3/3][RFC] cpuidle/tracing: Denote the tracepoints as
 being in rcu_idle_exit() section
Message-ID: <20120207154009.GR5941@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120207145653.829892056@goodmis.org>
 <20120207151049.632303467@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120207151049.632303467@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020720-3352-0000-0000-00000274AE75
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 07, 2012 at 09:56:56AM -0500, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> As the tracepoints in the cpuidle code are called when rcu_idle_exit() is in
> effect, the _rcuidle() version must be used, otherwise the rcu_read_lock()s
> that protect the tracepoint will not be honored.
> 
> Cc: Len Brown <len.brown@intel.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Looks good to me!

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  drivers/cpuidle/cpuidle.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index 59f4261..6588f43 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -94,13 +94,13 @@ int cpuidle_idle_call(void)
> 
>  	target_state = &drv->states[next_state];
> 
> -	trace_power_start(POWER_CSTATE, next_state, dev->cpu);
> -	trace_cpu_idle(next_state, dev->cpu);
> +	trace_power_start_rcuidle(POWER_CSTATE, next_state, dev->cpu);
> +	trace_cpu_idle_rcuidle(next_state, dev->cpu);
> 
>  	entered_state = target_state->enter(dev, drv, next_state);
> 
> -	trace_power_end(dev->cpu);
> -	trace_cpu_idle(PWR_EVENT_EXIT, dev->cpu);
> +	trace_power_end_rcuidle(dev->cpu);
> +	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
> 
>  	if (entered_state >= 0) {
>  		/* Update cpuidle counters */
> -- 
> 1.7.8.3
> 
> 

