Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621Ab0GNVMs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 17:12:48 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:55016 "EHLO
	mrelay1-d.mgt.gandi.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752668Ab0GNVMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 17:12:47 -0400
X-Originating-IP: 217.70.178.38
X-Originating-IP: 74.107.143.84
Date: Wed, 14 Jul 2010 14:12:31 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com
Subject: Re: [PATCH RFC tip/core/rcu 27/30] rcu: apply ->rda changes to
 rcutree_trace.c
Message-ID: <20100714211230.GA4624@feather>
References: <20100714200945.GA10535@linux.vnet.ibm.com>
 <1279138204-12849-27-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279138204-12849-27-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 01:10:01PM -0700, Paul E. McKenney wrote:
> The print_rcu_pendings() function used the ->rda[] array, so this
> commit makes it instead use per_cpu_ptr().
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  kernel/rcutree_trace.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
> index 36c95b4..458e032 100644
> --- a/kernel/rcutree_trace.c
> +++ b/kernel/rcutree_trace.c
> @@ -262,7 +262,7 @@ static void print_rcu_pendings(struct seq_file *m, struct rcu_state *rsp)
>  	struct rcu_data *rdp;
>  
>  	for_each_possible_cpu(cpu) {
> -		rdp = rsp->rda[cpu];
> +		rdp = per_cpu_ptr(rsp->rda, cpu);
>  		if (rdp->beenonline)
>  			print_one_rcu_pending(m, rdp);
>  	}

For the final version of this patchset, this should get squashed into
the previous patch, right?  Otherwise, the state after the previous
patch but before this one won't compile.

- Josh Triplett
