Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab1DZLiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 07:38:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33027 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754633Ab1DZLiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 07:38:07 -0400
Date: Tue, 26 Apr 2011 21:37:58 +1000
From: NeilBrown <neilb@suse.de>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 02/13] mm: sl[au]b: Add knowledge of PFMEMALLOC reserve
 pages
Message-ID: <20110426213758.450f6f49@notabene.brown>
In-Reply-To: <1303803414-5937-3-git-send-email-mgorman@suse.de>
References: <1303803414-5937-1-git-send-email-mgorman@suse.de>
	<1303803414-5937-3-git-send-email-mgorman@suse.de>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Apr 2011 08:36:43 +0100 Mel Gorman <mgorman@suse.de> wrote:

> +		/*
> +		 * If there are full empty slabs and we were not forced to
> +		 * allocate a slab, mark this one !pfmemalloc
> +		 */
> +		l3 = cachep->nodelists[numa_mem_id()];
> +		if (!list_empty(&l3->slabs_free) && force_refill) {
> +			struct slab *slabp = virt_to_slab(objp);
> +			slabp->pfmemalloc = false;
> +			clear_obj_pfmemalloc(&objp);
> +			check_ac_pfmemalloc(cachep, ac);
> +			return objp;
> +		}

The comment doesn't match the code.  I think you need to remove the words
"full" and "not" assuming the code is correct which it probably is...

But the code seems to be much more complex than Peter's original, and I don't
see the gain.

Peter's code had only one 'reserved' flag for each kmem_cache.  You seem to
have one for every slab.  I don't see the point.
It is true that yours is in some sense more fair - but I'm not sure the
complexity is worth it.

Was there some particular reason you made the change?

NeilBrown
