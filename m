Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750951Ab1CPENR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 00:13:17 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:59943 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab1CPENI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 00:13:08 -0400
Date: Tue, 15 Mar 2011 21:03:08 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [PATCH V4 1/1] rcu: introduce kfree_rcu()
Message-ID: <20110316040308.GC2273@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4D7F356C.8020903@cn.fujitsu.com>
 <1300194693.10062.15.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1300194693.10062.15.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 02:11:33PM +0100, Eric Dumazet wrote:
> Le mardi 15 mars 2011 à 17:46 +0800, Lai Jiangshan a écrit :
> 
> 
> > --- a/kernel/rcutiny.c
> > +++ b/kernel/rcutiny.c
> > @@ -167,7 +167,7 @@ static void rcu_process_callbacks(struct rcu_ctrlblk *rcp)
> >  		prefetch(next);
> >  		debug_rcu_head_unqueue(list);
> >  		local_bh_disable();
> > -		list->func(list);
> > +		__rcu_reclaim(list);
> >  		local_bh_enable();
> >  		list = next;
> >  		RCU_TRACE(cb_count++);
> 
> Paul, I am just wondering why we disable BH before calling list->func()
> 
> This should be done in callbacks that really need it ?
> 
> At least the disable/enable pair is not necessary before calling kfree()

Good point, we could bury the enable/disable pair in __rcu_reclaim().

Lai, am I forgetting any reason why we disable BH?

							Thanx, Paul
