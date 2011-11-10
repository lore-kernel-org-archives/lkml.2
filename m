Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934719Ab1KJOBG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 09:01:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933828Ab1KJOBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 09:01:04 -0500
Date: Thu, 10 Nov 2011 15:00:37 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: Do not stall in synchronous compaction for THP
 allocations
Message-ID: <20111110140037.GV5075@redhat.com>
References: <20111110100616.GD3083@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111110100616.GD3083@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 10:06:16AM +0000, Mel Gorman wrote:
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 963c5de..cddc2d0 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2213,7 +2213,13 @@ rebalance:
>  					sync_migration);
>  	if (page)
>  		goto got_pg;
> -	sync_migration = true;
> +
> +	/*
> +	 * Do not use sync migration for transparent hugepage allocations as
> +	 * it could stall writing back pages which is far worse than simply
> +	 * failing to promote a page.
> +	 */
> +	sync_migration = !(gfp_mask & __GFP_NO_KSWAPD);
>  
>  	/* Try direct reclaim and then allocating */
>  	page = __alloc_pages_direct_reclaim(gfp_mask, order,

Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
