Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab0ECSQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 14:16:36 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:53191 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755888Ab0ECSQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 14:16:34 -0400
Date: Mon, 3 May 2010 11:16:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: mmotm 2010-04-28 - RCU whinges
Message-ID: <20100503181629.GJ2597@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <201004290021.o3T0L04Y028017@imap1.linux-foundation.org>
 <5702.1272822394@localhost>
 <1272865137.2173.179.camel@edumazet-laptop>
 <5933.1272897014@localhost>
 <1272898726.2226.47.camel@edumazet-laptop>
 <5112.1272900590@localhost>
 <20100503154357.GF2597@linux.vnet.ibm.com>
 <1272903293.2226.50.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1272903293.2226.50.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 03, 2010 at 06:14:53PM +0200, Eric Dumazet wrote:
> Le lundi 03 mai 2010 à 08:43 -0700, Paul E. McKenney a écrit :
> 
> > Highly recommended.  ;-)
> > 
> > And thanks to you for your testing efforts and to Eric for the fixes!!!
> > 
> 
> For this last one, I think you should push following patch Paul

I would be happy to if I could find the commit creating
hlist_for_each_entry_continue_rcu()...

I do see a ca. 2008 patch from Stephen Hemminger:

	http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg264661.html

According to http://patchwork.ozlabs.org/patch/47997/, this is
going up the networking tree as of March 18, 2010.

So I would be happy to push the patch below, but to do so, I will need
to adopt the portion of Stephen's patch that created this primitive.

Please let me know how you would like to proceed!

							Thanx, Paul

> Followup of commit 3120438ad6
> (rcu: Disable lockdep checking in RCU list-traversal primitives)
> 
> Or we might introduce a hlist_for_each_entry_continue_rcu_bh() macro...
> 
> 
> 
> diff --git a/include/linux/rculist.h b/include/linux/rculist.h
> index 004908b..b0c7e24 100644
> --- a/include/linux/rculist.h
> +++ b/include/linux/rculist.h
> @@ -435,10 +435,10 @@ static inline void hlist_add_after_rcu(struct hlist_node *prev,
>   * @member:	the name of the hlist_node within the struct.
>   */
>  #define hlist_for_each_entry_continue_rcu(tpos, pos, member)		\
> -	for (pos = rcu_dereference((pos)->next);			\
> +	for (pos = rcu_dereference_raw((pos)->next);			\
>  	     pos && ({ prefetch(pos->next); 1; }) &&			\
>  	     ({ tpos = hlist_entry(pos, typeof(*tpos), member); 1; });  \
> -	     pos = rcu_dereference(pos->next))
> +	     pos = rcu_dereference_raw(pos->next))
> 
> 
>  #endif	/* __KERNEL__ */
> 
> 
