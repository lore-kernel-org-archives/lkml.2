Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149Ab0DOXzE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 19:55:04 -0400
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:54466 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758042Ab0DOXzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 19:55:01 -0400
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-Originating-IP: 217.70.178.44
X-Originating-IP: 173.50.255.69
Date: Thu, 15 Apr 2010 16:52:52 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com
Subject: Re: [PATCH RFC tip/core/rcu 02/16] rcu: make dead code really dead
Message-ID: <20100415235251.GA2491@feather>
References: <20100415181255.GA19588@linux.vnet.ibm.com>
 <1271355219-20714-2-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271355219-20714-2-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 11:13:25AM -0700, Paul E. McKenney wrote:
> From: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> cleanup: make dead code really dead
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  kernel/rcutree.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index e54c123..6042fb8 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -1236,11 +1236,11 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
>  		break; /* grace period idle or initializing, ignore. */
>  
>  	case RCU_SAVE_DYNTICK:
> -
> -		raw_spin_unlock(&rnp->lock);  /* irqs remain disabled */
>  		if (RCU_SIGNAL_INIT != RCU_SAVE_DYNTICK)
>  			break; /* So gcc recognizes the dead code. */

GCC's new __builtin_unreachable would help here, though obviously we
can't count on 4.5 or newer quite yet.  A wrapper in compiler.h would
let us use it when available though.

- Josh Triplett
