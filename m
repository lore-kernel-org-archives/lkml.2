Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030420Ab2EQUNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 16:13:21 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:34656 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030403Ab2EQUNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 16:13:15 -0400
Date: Thu, 17 May 2012 16:13:04 -0400 (EDT)
Message-Id: <20120517.161304.1765970628771192598.davem@davemloft.net>
To: mgorman@suse.de
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, neilb@suse.de, a.p.zijlstra@chello.nl,
        michaelc@cs.wisc.edu, emunson@mgebm.net
Subject: Re: [PATCH 12/17] netvm: Propagate page->pfmemalloc from
 skb_alloc_page to skb
From: David Miller <davem@davemloft.net>
In-Reply-To: <1337266231-8031-13-git-send-email-mgorman@suse.de>
References: <1337266231-8031-1-git-send-email-mgorman@suse.de>
	<1337266231-8031-13-git-send-email-mgorman@suse.de>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 17 May 2012 13:13:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mel Gorman <mgorman@suse.de>
Date: Thu, 17 May 2012 15:50:26 +0100

> The skb->pfmemalloc flag gets set to true iff during the slab
> allocation of data in __alloc_skb that the the PFMEMALLOC reserves
> were used. If page splitting is used, it is possible that pages will
> be allocated from the PFMEMALLOC reserve without propagating this
> information to the skb. This patch propagates page->pfmemalloc from
> pages allocated for fragments to the skb.
> 
> It works by reintroducing and expanding the skb_alloc_page() API
> to take an skb. If the page was allocated from pfmemalloc reserves,
> it is automatically copied. If the driver allocates the page before
> the skb, it should call skb_propagate_pfmemalloc() after the skb is
> allocated to ensure the flag is copied properly.
> 
> Failure to do so is not critical. The resulting driver may perform
> slower if it is used for swap-over-NBD or swap-over-NFS but it should
> not result in failure.
> 
> [davem@davemloft.net: API rename and consistency]
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: David S. Miller <davem@davemloft.net>
