Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759243Ab2FUJw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 05:52:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42121 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759210Ab2FUJw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 05:52:26 -0400
Date: Thu, 21 Jun 2012 11:52:23 +0200
From: Jan Kara <jack@suse.cz>
To: Cong Meng <mc@linux.vnet.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VFS: Go through the LRU list of inode from head
Message-ID: <20120621095223.GA11645@quack.suse.cz>
References: <1340269227-20310-1-git-send-email-mc@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340269227-20310-1-git-send-email-mc@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 21-06-12 17:00:27, Cong Meng wrote:
> Go through the LRU list of inode from head.
> 
> (I'm not sure whether there is any trick here I doesn't get.  If yes, 
> any one could explain it)
  Look at inode_lru_list_add(). It adds at the head of the list. So you
should take from the tail to get the least recently used element...

								Honza

> 
> Signed-off-by: Cong Meng <mc@linux.vnet.ibm.com>
> ---
>  fs/inode.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index 775cbab..aac8449 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -704,7 +704,7 @@ void prune_icache_sb(struct super_block *sb, int nr_to_scan)
>  		if (list_empty(&sb->s_inode_lru))
>  			break;
>  
> -		inode = list_entry(sb->s_inode_lru.prev, struct inode, i_lru);
> +		inode = list_entry(sb->s_inode_lru.next, struct inode, i_lru);
>  
>  		/*
>  		 * we are inverting the sb->s_inode_lru_lock/inode->i_lock here,
> -- 
> 1.7.5.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
