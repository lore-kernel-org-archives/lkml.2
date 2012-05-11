Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759493Ab2EKPFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 11:05:39 -0400
Received: from relay3.sgi.com ([192.48.152.1]:46765 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752082Ab2EKPFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 11:05:36 -0400
Date: Fri, 11 May 2012 10:05:33 -0500
From: Robin Holt <holt@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robin Holt <holt@sgi.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Commit cb83b62 fails to boot with a divide by zero error.
Message-ID: <20120511150533.GH3751@sgi.com>
References: <20120511133938.GG3751@sgi.com>
 <1336746790.1017.17.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336746790.1017.17.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 04:33:10PM +0200, Peter Zijlstra wrote:
> On Fri, 2012-05-11 at 08:39 -0500, Robin Holt wrote:
> 
> > We found that reverting the commit:
> > cb83b62 (x86/sched/core) sched/numa: Rewrite the CONFIG_NUMA sched domain support
> > 
> > also got things working.
> 
> there's a particularly stupid bug in that code

Even with that applied, I still get the divide by zero.

Robin

> 
> 
> 
> ---
> Subject: sched, numa: Fix the new NUMA topology bits
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Fri May 11 00:56:20 CEST 2012
> 
> There's no need to convert a node number to a node number by
> pretending its a cpu number..
> 
> Reported-by: Yinghai Lu <yinghai@kernel.org>
> Reported-and-Tested-by: Greg Pearson <greg.pearson@hp.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/sched/core.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -6378,8 +6378,7 @@ static void sched_init_numa(void)
>  			sched_domains_numa_masks[i][j] = mask;
>  
>  			for (k = 0; k < nr_node_ids; k++) {
> -				if (node_distance(cpu_to_node(j), k) >
> -						sched_domains_numa_distance[i])
> +				if (node_distance(j, k) > sched_domains_numa_distance[i])
>  					continue;
>  
>  				cpumask_or(mask, mask, cpumask_of_node(k));
