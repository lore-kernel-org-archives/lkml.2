Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab2GITTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 15:19:25 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:37205 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751432Ab2GITTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 15:19:24 -0400
Date: Mon, 9 Jul 2012 21:18:56 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Eric B Munson <emunson@mgebm.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 11/16] netvm: Propagate page->pfmemalloc from
 skb_alloc_page to skb
Message-ID: <20120709191856.GD3515@breakpoint.cc>
References: <1340375443-22455-1-git-send-email-mgorman@suse.de>
 <1340375443-22455-12-git-send-email-mgorman@suse.de>
 <20120626201328.GI6509@breakpoint.cc>
 <20120627084348.GG8271@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627084348.GG8271@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 09:43:48AM +0100, Mel Gorman wrote:
> > You did not touch all drivers which use alloc_page(s)() like e1000(e). Was
> > this on purpose?
> 
> Yes. The ones I changed were the semi-obvious ones and carried over from
> when the patches were completely out of tree.  As the changelog notes
> it is not critical that these annotation happens and can be fixed on a
> per-driver basis if there are complains about network swapping being slow.
okay, I was just curious why some drivers were updated and others not.

> I can update e1000 if you like but it's not critical
> to do so and in fact getting a bug reporting saying that network swap
> was slow on e1000 would be useful to me in its own way :)
No, leave as it, I was just curious.
One thing: Do you think it makes sense to you introduce
	#define GFP_NET_RX     (GFP_ATOMIC | __GFP_MEMALLOC)

and use it within the receive path instead of GFP_ATOMIC?

Sebastian
