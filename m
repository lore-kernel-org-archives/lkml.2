Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932606Ab2FVL2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 07:28:12 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:54673 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761530Ab2FVL2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 07:28:11 -0400
Date: Fri, 22 Jun 2012 13:27:51 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Eric B Munson <emunson@mgebm.net>
Subject: Re: [PATCH 10/17] netvm: Allow skb allocation to use PFMEMALLOC
 reserves
Message-ID: <20120622112750.GA6596@breakpoint.cc>
References: <1340192652-31658-1-git-send-email-mgorman@suse.de>
 <1340192652-31658-11-git-send-email-mgorman@suse.de>
 <20120621163029.GB6045@breakpoint.cc>
 <20120622105451.GC8271@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120622105451.GC8271@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 11:54:51AM +0100, Mel Gorman wrote:
> > This is mostly used by nic to refil their RX skb pool. You add the
> > __GFP_MEMALLOC to the allocation to rise the change of a successfull refill
> > for the swap case.
> > A few drivers use build_skb() to create the skb. __netdev_alloc_skb()
> > shouldn't be affected since the allocation happens with GFP_ATOMIC. Looking at
> > TG3 it uses build_skb() and get_pages() / kmalloc(). Shouldn't this be some
> > considered?
> > 
> 
> While TG3 is not exactly as you describe after rebasing build_skb should
> make a similar check to __alloc_skb. As it is always used for RX allocation
> from the skbuff_head_cache cache the following should be suitable. Thanks.

As Eric pointed out you end up in netdev_alloc_frag() which is using
alloc_page(). This is also used by __netdev_alloc_skb().

Sebastian
