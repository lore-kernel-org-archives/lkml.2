Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919Ab2FPAC6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 20:02:58 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:53038 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267Ab2FPAC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 20:02:57 -0400
X-Originating-IP: 217.70.178.143
X-Originating-IP: 50.43.46.74
Date: Fri, 15 Jun 2012 17:02:39 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 15/15] rcu: RCU_SAVE_DYNTICK code no longer
 ever dead
Message-ID: <20120616000238.GG7613@leaf>
References: <20120615210550.GA27506@linux.vnet.ibm.com>
 <1339794370-28119-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1339794370-28119-15-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339794370-28119-15-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 02:06:10PM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> Before RCU had unified idle, the RCU_SAVE_DYNTICK leg of the switch
> statement in force_quiescent_state() was dead code for CONFIG_NO_HZ=n
> kernel builds.  With unified idle, the code is never dead.  This commit
> therefore removes the "if" statement designed to make gcc aware of when
> the code was and was not dead.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

One comment below; with that change:

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  kernel/rcutree.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 75ad92a..0b0c9cc 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -1744,8 +1744,6 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
>  		break; /* grace period idle or initializing, ignore. */
>  
>  	case RCU_SAVE_DYNTICK:
> -		if (RCU_SIGNAL_INIT != RCU_SAVE_DYNTICK)
> -			break; /* So gcc recognizes the dead code. */
>  
>  		raw_spin_unlock(&rnp->lock);  /* irqs remain disabled */

Drop the blank line too?
