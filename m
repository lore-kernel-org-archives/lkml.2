Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab2EBKZx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 06:25:53 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:33022 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab2EBKZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 06:25:52 -0400
Date: Wed, 2 May 2012 15:55:41 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@kernel.org, pjt@google.com, suresh.b.siddha@intel.com, efault@gmx.de,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/5] sched, fair: Let minimally loaded cpu balance
 the group
Message-ID: <20120502102541.GA22740@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <20120501181430.007891123@chello.nl>
 <20120501182610.745844312@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120501182610.745844312@chello.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12050210-8878-0000-0000-0000023ECFD7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2012-05-01 20:14:31]:

> @@ -3795,12 +3796,11 @@ static inline void update_sg_lb_stats(st
> 
>  		/* Bias balancing toward cpus of our domain */
>  		if (local_group) {
> -			if (idle_cpu(i) && !first_idle_cpu) {
> -				first_idle_cpu = 1;
> +			load = target_load(i, load_idx);
> +			if (load < balance_load || idle_cpu(i)) {
> +				balance_load = load;

Let's say load_idx != 0 (ex: a busy cpu doing this load balance). In
that case, for a idle cpu, we could return non-zero load and hence this
would fail to select such a idle cpu? IOW :

		balance_load = 0 iff idle_cpu(i) ??

>  				balance_cpu = i;
>  			}
> -
> -			load = target_load(i, load_idx);
>  		} else {
>  			load = source_load(i, load_idx);
>  			if (load > max_cpu_load) {
> 
> 

- vatsa

