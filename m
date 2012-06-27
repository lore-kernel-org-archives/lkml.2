Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab2F0Icw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 04:32:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35854 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806Ab2F0Icu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 04:32:50 -0400
Date: Wed, 27 Jun 2012 09:32:46 +0100
From: Mel Gorman <mgorman@suse.de>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Eric B Munson <emunson@mgebm.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 09/16] netvm: Allow skb allocation to use PFMEMALLOC
 reserves
Message-ID: <20120627083246.GF8271@suse.de>
References: <1340375443-22455-1-git-send-email-mgorman@suse.de>
 <1340375443-22455-10-git-send-email-mgorman@suse.de>
 <20120626152734.GA6509@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120626152734.GA6509@breakpoint.cc>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 05:27:34PM +0200, Sebastian Andrzej Siewior wrote:
> On Fri, Jun 22, 2012 at 03:30:36PM +0100, Mel Gorman wrote:
> > diff --git a/net/core/sock.c b/net/core/sock.c
> > index 5c9ca2b..159dccc 100644
> > --- a/net/core/sock.c
> > +++ b/net/core/sock.c
> > @@ -271,6 +271,9 @@ __u32 sysctl_rmem_default __read_mostly = SK_RMEM_MAX;
> >  int sysctl_optmem_max __read_mostly = sizeof(unsigned long)*(2*UIO_MAXIOV+512);
> >  EXPORT_SYMBOL(sysctl_optmem_max);
> >  
> > +struct static_key memalloc_socks = STATIC_KEY_INIT_FALSE;
> > +EXPORT_SYMBOL_GPL(memalloc_socks);
> > +
> 
> This is used via sk_memalloc_socks() by SLAB.
> 
> From 3da9ab9972845974da114c5a6624335e6371b2d5 Mon Sep 17 00:00:00 2001
> From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Date: Tue, 26 Jun 2012 17:18:20 +0200
> Subject: [PATCH] export sk_memalloc_socks() only with CONFIG_NET
> 
> |mm/built-in.o: In function `atomic_read':
> |include/asm/atomic.h:25: undefined reference to `memalloc_socks'
> |include/asm/atomic.h:25: undefined reference to `memalloc_socks'
> |include/asm/atomic.h:25: undefined reference to `memalloc_socks'
> |include/asm/atomic.h:25: undefined reference to `memalloc_socks'
> |include/asm/atomic.h:25: undefined reference to `memalloc_socks'
> |mm/built-in.o:include/asm/atomic.h:25: more undefined references to `memalloc_socks' follow
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Well caught. I had not tested build with !CONFIG_NET. I've folded in
this patch and the credits accordingly. Thanks.

-- 
Mel Gorman
SUSE Labs
