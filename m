Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab0ENCPS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 22:15:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:15721 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469Ab0ENCPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 22:15:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,226,1272870000"; 
   d="scan'208";a="517801926"
Date: Fri, 14 May 2010 10:15:08 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] radix-tree: fix radix_tree_prev_hole underflow case
Message-ID: <20100514021508.GA7810@localhost>
References: <1273802724-3414-1-git-send-email-cesarb@cesarb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273802724-3414-1-git-send-email-cesarb@cesarb.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 10:05:24AM +0800, Cesar Eduardo Barros wrote:
> radix_tree_prev_hole() used LONG_MAX to detect underflow; however,
> ULONG_MAX is clearly what was intended, both here and by its only user
> (count_history_pages at mm/readahead.c).
 
Good catch, thanks! I actually have a more smart
radix_tree_prev_hole() that uses ULONG_MAX.

Andrew, fortunately this bug has little impact on readahead.

Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>

> Cc: Wu Fengguang <fengguang.wu@intel.com>
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
> ---
>  lib/radix-tree.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/radix-tree.c b/lib/radix-tree.c
> index b69031f..be40980 100644
> --- a/lib/radix-tree.c
> +++ b/lib/radix-tree.c
> @@ -656,7 +656,7 @@ EXPORT_SYMBOL(radix_tree_next_hole);
>   *
>   *	Returns: the index of the hole if found, otherwise returns an index
>   *	outside of the set specified (in which case 'index - return >= max_scan'
> - *	will be true). In rare cases of wrap-around, LONG_MAX will be returned.
> + *	will be true). In rare cases of wrap-around, ULONG_MAX will be returned.
>   *
>   *	radix_tree_next_hole may be called under rcu_read_lock. However, like
>   *	radix_tree_gang_lookup, this will not atomically search a snapshot of
> @@ -674,7 +674,7 @@ unsigned long radix_tree_prev_hole(struct radix_tree_root *root,
>  		if (!radix_tree_lookup(root, index))
>  			break;
>  		index--;
> -		if (index == LONG_MAX)
> +		if (index == ULONG_MAX)
>  			break;
>  	}
>  
> -- 
> 1.6.6.1
