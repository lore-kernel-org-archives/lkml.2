Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab0HWNEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 09:04:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299Ab0HWNEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 09:04:44 -0400
Date: Mon, 23 Aug 2010 09:04:38 -0400
From: Josef Bacik <josef@redhat.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Chris Mason <chris.mason@oracle.com>, Josef Bacik <josef@redhat.com>,
        linux-btrfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] btrfs: free fully occupied bitmap in cluster
Message-ID: <20100823130438.GC2404@localhost.localdomain>
References: <4C71CD4B.10606@cn.fujitsu.com> <4C71CD84.1000809@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C71CD84.1000809@cn.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 09:23:16AM +0800, Li Zefan wrote:
> If there's no more free space in a bitmap, we should free it,
> otherwise seems it won't get freed until we free the block group.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  fs/btrfs/free-space-cache.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index 017fd55..631e14f 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -1035,6 +1035,8 @@ static u64 btrfs_alloc_from_bitmap(struct btrfs_block_group_cache *block_group,
>  
>  	ret = search_start;
>  	bitmap_clear_bits(block_group, entry, ret, bytes);
> +	if (entry->bytes == 0)
> +		free_bitmap(block_group, entry);
>  out:
>  	spin_unlock(&cluster->lock);
>  	spin_unlock(&block_group->tree_lock);
> -- 
> 1.7.0.1
> 

Oops, good catch

Reviewed-by: Josef Bacik <josef@redhat.com>

Thanks,

Josef
