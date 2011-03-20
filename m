Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653Ab1CTPeW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 11:34:22 -0400
Received: from sh.osrg.net ([192.16.179.4]:54254 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364Ab1CTPeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 11:34:20 -0400
Date: Mon, 21 Mar 2011 00:34:12 +0900 (JST)
Message-Id: <20110321.003412.212697075.ryusuke@osrg.net>
To: nikai@nikai.net
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nilfs2: merge list_del()/list_add_tail() to
 list_move_tail()
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <20110319164530.6cc75cb2@absol.kitzblitz>
References: <20110319164530.6cc75cb2@absol.kitzblitz>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 21 Mar 2011 00:34:14 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Mar 2011 16:45:30 +0100, Nicolas Kaiser wrote:
> Merge list_del() + list_add_tail() to list_move_tail().
> 
> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
> ---
>  fs/nilfs2/inode.c   |    3 +--
>  fs/nilfs2/segment.c |    6 ++----
>  2 files changed, 3 insertions(+), 6 deletions(-)

Thanks, applied both patches.

Ryusuke Konishi

> diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
> index d5625be..84f1b76 100644
> --- a/fs/nilfs2/inode.c
> +++ b/fs/nilfs2/inode.c
> @@ -873,8 +873,7 @@ int nilfs_set_file_dirty(struct inode *inode, unsigned nr_dirty)
>  			return -EINVAL; /* NILFS_I_DIRTY may remain for
>  					   freeing inode */
>  		}
> -		list_del(&ii->i_dirty);
> -		list_add_tail(&ii->i_dirty, &nilfs->ns_dirty_files);
> +		list_move_tail(&ii->i_dirty, &nilfs->ns_dirty_files);
>  		set_bit(NILFS_I_QUEUED, &ii->i_state);
>  	}
>  	spin_unlock(&nilfs->ns_inode_lock);
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index afe4f21..5deeadd 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -1991,8 +1991,7 @@ static int nilfs_segctor_collect_dirty_files(struct nilfs_sc_info *sci,
>  
>  		clear_bit(NILFS_I_QUEUED, &ii->i_state);
>  		set_bit(NILFS_I_BUSY, &ii->i_state);
> -		list_del(&ii->i_dirty);
> -		list_add_tail(&ii->i_dirty, &sci->sc_dirty_files);
> +		list_move_tail(&ii->i_dirty, &sci->sc_dirty_files);
>  	}
>  	spin_unlock(&nilfs->ns_inode_lock);
>  
> @@ -2014,8 +2013,7 @@ static void nilfs_segctor_drop_written_files(struct nilfs_sc_info *sci,
>  		clear_bit(NILFS_I_BUSY, &ii->i_state);
>  		brelse(ii->i_bh);
>  		ii->i_bh = NULL;
> -		list_del(&ii->i_dirty);
> -		list_add_tail(&ii->i_dirty, &ti->ti_garbage);
> +		list_move_tail(&ii->i_dirty, &ti->ti_garbage);
>  	}
>  	spin_unlock(&nilfs->ns_inode_lock);
>  }
> -- 
> 1.7.3.4
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
