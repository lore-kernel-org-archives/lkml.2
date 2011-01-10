Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751263Ab1AJFAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 00:00:54 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:38912 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891Ab1AJFAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 00:00:52 -0500
Date: Sun, 9 Jan 2011 18:15:59 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] rcu: call __rcu_read_unlock() in exit_rcu()
Message-ID: <20110110021559.GG2383@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4D22DB19.3000300@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D22DB19.3000300@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 04:32:25PM +0800, Lai Jiangshan wrote:
> 
> rcu_read_unlock() is a wrapper of many things:
> 	the core __rcu_read_unlock(), debugs...etc.
> 
> It is better that we only calls the core __rcu_read_unlock() here.

Hello, Lai!

Last time I checked, a task exiting in an RCU read-side critical section
got an error before it got to this point.  That said, the "__" does a
good job of indicating that this is not a normal end of an RCU read-side
critical section.

I have queued this at least for the moment, and also created a TINY_RCU
counterpart.

							Thanx, Paul

> signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index a363871..94035a0 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -802,7 +802,7 @@ void exit_rcu(void)
>  	if (t->rcu_read_lock_nesting == 0)
>  		return;
>  	t->rcu_read_lock_nesting = 1;
> -	rcu_read_unlock();
> +	__rcu_read_unlock();
>  }
> 
>  #else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
