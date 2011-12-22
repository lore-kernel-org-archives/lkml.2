Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab1LVARN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 19:17:13 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:63521 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754028Ab1LVARL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 19:17:11 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAL9z8k55LL6d/2dsb2JhbABDrCSBBoFyAQEFJxMcIxAIAxguFCUDIRO/VhODaogSBJR+iRyJLA
Date: Thu, 22 Dec 2011 11:17:07 +1100
From: Dave Chinner <david@fromorbit.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] radix_tree: expand comment on optimization
Message-ID: <20111222001707.GI23662@dastard>
References: <alpine.LSU.2.00.1112182234310.1503@eggly.anvils>
 <20111221050740.GD23662@dastard>
 <alpine.LSU.2.00.1112202218490.4026@eggly.anvils>
 <20111221221527.GE23662@dastard>
 <alpine.LSU.2.00.1112211555430.25868@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1112211555430.25868@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 03:57:16PM -0800, Hugh Dickins wrote:
> Expand comment on optimization in radix_tree_range_tag_if_tagged(),
> along the lines proposed by Dave Chinner.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> ---
> And with -p2, this patch will also apply to the rtth tree.
> 
>  lib/radix-tree.c |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> --- mmotm/lib/radix-tree.c	2011-12-16 20:40:26.152758485 -0800
> +++ linux/lib/radix-tree.c	2011-12-21 14:57:20.073657540 -0800
> @@ -703,7 +703,13 @@ unsigned long radix_tree_range_tag_if_ta
>  			node = node->parent;
>  		}
>  
> -		/* optimization: no need to walk up from this node again */
> +		/*
> +		 * Small optimization: now clear that node pointer.
> +		 * Since all of this slot's ancestors now have the tag set
> +		 * from setting it above, we have no further need to walk
> +		 * back up the tree setting tags, until we update slot to
> +		 * point to another radix_tree_node.
> +		 */
>  		node = NULL;

Looks good. I might remember why it was done now ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
