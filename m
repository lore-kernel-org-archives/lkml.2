Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab2IJQ0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 12:26:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56128 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272Ab2IJQ0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 12:26:37 -0400
Date: Mon, 10 Sep 2012 18:26:33 +0200
From: Jan Kara <jack@suse.cz>
To: Wang Sheng-Hui <shhuiw@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH] vfs: correct comment for
 fs/fs-writeback.c/move_expired_inodes
Message-ID: <20120910162633.GA29178@quack.suse.cz>
References: <504B68EC.50807@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504B68EC.50807@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 08-09-12 23:49:00, Wang Sheng-Hui wrote:
> The function scans @delaying_queue and stops at the first inode
> whose dirtied_when is after *work->older_than_this. So the expired
> ones being moved are those before *work->older_than_this. Correct
> the comment here.
  Fengguang Wu would be a more appropriate for this. Added to CC. BTW the
patch is fine so feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> ---
>  fs/fs-writeback.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index be3efc4..fd255c0 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -248,7 +248,7 @@ static bool inode_dirtied_after(struct inode *inode, unsigned long t)
>  }
>  
>  /*
> - * Move expired (dirtied after work->older_than_this) dirty inodes from
> + * Move expired (dirtied before work->older_than_this) dirty inodes from
>   * @delaying_queue to @dispatch_queue.
>   */
>  static int move_expired_inodes(struct list_head *delaying_queue,
> -- 
> 1.7.1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
