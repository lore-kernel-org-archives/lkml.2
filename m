Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab2IBCvK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 22:51:10 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:60860 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828Ab2IBCvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 22:51:08 -0400
X-Originating-IP: 217.70.178.134
X-Originating-IP: 50.43.46.74
Date: Sat, 1 Sep 2012 19:51:00 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        Dimitri Sivanich <sivanich@sgi.com>
Subject: Re: [PATCH tip/core/rcu 08/23] rcu: Segregate rcu_state fields to
 improve cache locality
Message-ID: <20120902025100.GA6786@leaf>
References: <20120830181811.GA29154@linux.vnet.ibm.com>
 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346350718-30937-8-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346350718-30937-8-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 11:18:23AM -0700, Paul E. McKenney wrote:
> From: Dimitri Sivanich <sivanich@sgi.com>
> 
> The fields in the rcu_state structure that are protected by the
> root rcu_node structure's ->lock can share a cache line with the
> fields protected by ->onofflock.  This can result in excessive
> memory contention on large systems, so this commit applies
> ____cacheline_internodealigned_in_smp to the ->onofflock field in
> order to segregate them.
> 
> Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Tested-by: Dimitri Sivanich <sivanich@sgi.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  kernel/rcutree.h |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/rcutree.h b/kernel/rcutree.h
> index effb273..5d92b80 100644
> --- a/kernel/rcutree.h
> +++ b/kernel/rcutree.h
> @@ -394,7 +394,8 @@ struct rcu_state {
>  
>  	/* End of fields guarded by root rcu_node's lock. */
>  
> -	raw_spinlock_t onofflock;		/* exclude on/offline and */
> +	raw_spinlock_t onofflock ____cacheline_internodealigned_in_smp;
> +						/* exclude on/offline and */
>  						/*  starting new GP. */
>  	struct rcu_head *orphan_nxtlist;	/* Orphaned callbacks that */
>  						/*  need a grace period. */
> -- 
> 1.7.8
> 
