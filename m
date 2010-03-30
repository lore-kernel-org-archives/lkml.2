Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab0C3Puk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 11:50:40 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:46749 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703Ab0C3Puj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 11:50:39 -0400
Date: Tue, 30 Mar 2010 08:50:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: more careful check for the last non-dyntick-idle
 CPU
Message-ID: <20100330155023.GA2513@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4BB1D524.9050508@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB1D524.9050508@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 06:40:36PM +0800, Lai Jiangshan wrote:
> Warning: I just did build test.
> 
> Subject: [PATCH] rcu: more careful check for the last non-dyntick-idle CPU
> 
> If a CPU is not in nohz_cpu_mask, it does not means this
> CPU is a non-dyntick-idle CPU, because this CPU may be offline or not exist.

Good catch, queued, thank you!

							Thanx, Paul

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index 4befb64..6086a7d 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -1026,7 +1026,7 @@ int rcu_needs_cpu(int cpu)
> 
>  	/* Don't bother unless we are the last non-dyntick-idle CPU. */
>  	for_each_cpu_not(thatcpu, nohz_cpu_mask)
> -		if (thatcpu != cpu) {
> +		if (cpu_online(thatcpu) && thatcpu != cpu) {
>  			per_cpu(rcu_dyntick_drain, cpu) = 0;
>  			per_cpu(rcu_dyntick_holdoff, cpu) = jiffies - 1;
>  			return rcu_needs_cpu_quick_check(cpu);
