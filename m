Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab2IFOR2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 10:17:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:45026 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab2IFOR1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 10:17:27 -0400
Message-ID: <1346941023.18408.15.camel@twins>
Subject: Re: [PATCH tip/core/rcu 14/23] rcu: Remove now-unused rcu_state
 fields
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Date: Thu, 06 Sep 2012 16:17:03 +0200
In-Reply-To: <1346350718-30937-14-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120830181811.GA29154@linux.vnet.ibm.com>
	 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1346350718-30937-14-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-30 at 11:18 -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> Moving the RCU grace-period processing to a kthread and adjusting the
> tracing resulted in two of the rcu_state structure's fields being unused.
> This commit therefore removes them.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  kernel/rcutree.h |    7 -------
>  1 files changed, 0 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/rcutree.h b/kernel/rcutree.h
> index 2d4cc18..8f0293c 100644
> --- a/kernel/rcutree.h
> +++ b/kernel/rcutree.h
> @@ -378,13 +378,6 @@ struct rcu_state {
>  
>  	u8	fqs_state ____cacheline_internodealigned_in_smp;
>  						/* Force QS state. */
> -	u8	fqs_active;			/* force_quiescent_state() */
> -						/*  is running. */
> -	u8	fqs_need_gp;			/* A CPU was prevented from */
> -						/*  starting a new grace */
> -						/*  period because */
> -						/*  force_quiescent_state() */
> -						/*  was running. */
>  	u8	boost;				/* Subject to priority boost. */
>  	unsigned long gpnum;			/* Current gp number. */
>  	unsigned long completed;		/* # of last completed gp. */

Typically one would fold this change into the patch that caused said
redundancy and not mention it. Save a patch to (post/review/merge) and
makes the patches a more solid whole.

