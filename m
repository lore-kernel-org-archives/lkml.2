Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125Ab1GaBiy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 21:38:54 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:54202 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752711Ab1GaBir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 21:38:47 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlUDAI2uNE55LCkBgWdsb2JhbABBp2MVAQEWJiWBQAEBBAEnExwjBQsIAw4KLhQlAyETh2y/AQ6GNASjcQ
Date: Sun, 31 Jul 2011 11:38:43 +1000
From: Dave Chinner <david@fromorbit.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        containers@lists.linux-foundation.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        James Bottomley <JBottomley@parallels.com>
Subject: Re: [PATCH 3/4] dcache set size
Message-ID: <20110731013843.GN5404@dastard>
References: <1311947059-17209-1-git-send-email-glommer@parallels.com>
 <1311947059-17209-4-git-send-email-glommer@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311947059-17209-4-git-send-email-glommer@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 05:44:18PM +0400, Glauber Costa wrote:
> Simple patch that provides a function allowing its caller to set
> the maximum number of dentries that can exist at the same time
> at a given super block. Will be used in a later patch.

Pretty simple - probably better to put it in the patch that uses it,
I think.

> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: Dave Chinner <david@fromorbit.com>
> ---
>  fs/dcache.c            |   12 ++++++++++++
>  include/linux/dcache.h |    1 +
>  2 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/dcache.c b/fs/dcache.c
> index 3bdb106..4369aa2 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -1202,6 +1202,18 @@ static int dcache_mem_check(struct super_block *sb)
>  	return -ENOMEM;
>  }
>  
> +int vfs_set_dcache_size(struct super_block *sb, int size)
> +{
> +	unsigned long dr = percpu_counter_sum_positive(&sb->s_nr_dentry); 
> +
> +	if (size != sb->s_nr_dentry_max)
> +		prune_dcache_sb(sb, dr - size);

And why shrink if the new size > the current sb->s_nr_dentry_max?

And what happens when size > dr?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
