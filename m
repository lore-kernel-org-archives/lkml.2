Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634Ab0FXOmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 10:42:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57244 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755464Ab0FXOme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 10:42:34 -0400
Date: Fri, 25 Jun 2010 00:42:28 +1000
From: Nick Piggin <npiggin@suse.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 01/52] kernel: add bl_list
Message-ID: <20100624144228.GC10441@laptop>
References: <20100624030212.676457061@suse.de>
 <20100624030725.718438579@suse.de>
 <1277359462.3471.1156.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1277359462.3471.1156.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 08:04:22AM +0200, Eric Dumazet wrote:
> Le jeudi 24 juin 2010 à 13:02 +1000, npiggin@suse.de a écrit :
> > +static inline void hlist_bl_set_first(struct hlist_bl_head *h, struct hlist_bl_node *n)
> > +{
> > +	h->first = (struct hlist_bl_node *)((unsigned long)n | ((unsigned long)h->first & 1UL));
> 
> Hmm, shouldnt hlist_bl_set_first() be used only with bit lock held ?
> 
> 	h->first = (struct hlist_bl_node *)((unsigned long)n | 1UL);
> > +}

I had it that way but changed it for some reason. Thinking about it
again though, you're right I'm sure (it could have been some other
bug in my code making me think I needed it).

Thanks.

> > +static inline void hlist_bl_set_first_rcu(struct hlist_bl_head *h, struct hlist_bl_node *n)
> > +{
> > +	rcu_assign_pointer(h->first, (struct hlist_bl_node *)((unsigned long)n | ((unsigned long)h->first & 1UL)));
> 
> Same question here.
> 
> > +}
> > +
> > +static inline struct hlist_bl_node *hlist_bl_first_rcu(struct hlist_bl_head *h)
> > +{
> > +	return (struct hlist_bl_node *)((unsigned long)rcu_dereference(h->first) & ~1UL);
> > +}
> 
> 
> Looks really nice Nick, maybe we should push this so that other
> subsystem can start using it.

Sure, if you have an interest in using it, it will be trivial to send
upstream. Should we merge it before any users appear? I don't know...

