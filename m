Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab0ILMaE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 08:30:04 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:44492 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823Ab0ILMaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 08:30:03 -0400
Date: Sun, 12 Sep 2010 14:29:55 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Jaswinder Singh Rajput <jaswinder@infradead.org>
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: Remove useless condition
Message-ID: <20100912122955.GA28839@cmpxchg.org>
References: <1284289340.2650.2.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284289340.2650.2.camel@ht.satnam>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 12, 2010 at 04:32:20PM +0530, Jaswinder Singh Rajput wrote:
> 
> if (ret) is useless as it will be never NULL as in previous statement
> we are setting ret = prev for !ret

If there is no match and no extent below the given file offset, `prev'
will be NULL as well, no?

So the check is not useless, it prevents throwing out a cached success
in case of a lookup failure.

> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> Cc: Chris Mason <chris.mason@oracle.com>
> ---
>  fs/btrfs/ordered-data.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
> index e56c72b..7b04008 100644
> --- a/fs/btrfs/ordered-data.c
> +++ b/fs/btrfs/ordered-data.c
> @@ -154,8 +154,7 @@ static inline struct rb_node *tree_search(struct btrfs_ordered_inode_tree *tree,
>  	ret = __tree_search(root, file_offset, &prev);
>  	if (!ret)
>  		ret = prev;
> -	if (ret)
> -		tree->last = ret;
> +	tree->last = ret;
>  	return ret;
>  }
>  
> -- 
> 1.7.2.2
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
