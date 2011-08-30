Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab1H3Kfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 06:35:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39380 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362Ab1H3Kfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 06:35:47 -0400
Date: Tue, 30 Aug 2011 12:35:45 +0200
From: Jan Kara <jack@suse.cz>
To: Li Haifeng <omycle@gmail.com>
Cc: jack@suse.cz, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] fix the outdated comment in ext2_nfs_get_inode()
Message-ID: <20110830103545.GA16202@quack.suse.cz>
References: <CAFNq8R62+5dLbDV3b_rtFgMwTZ2abW+h+tg013L=pij60tTRdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFNq8R62+5dLbDV3b_rtFgMwTZ2abW+h+tg013L=pij60tTRdw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 30-08-11 17:53:58, Li Haifeng wrote:
> The function iget  referred by the comment is replaced by ext2_iget .
> And the ext2_read_inode() is not exist, the ext2_iget is "neater". So
> the comment is fixed here.
> 
> Signed-off-by: Li Haifeng <omycle@gmail.com>
> ---
>  fs/ext2/super.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 1dd62ed..994ced3 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -327,10 +327,8 @@ static struct inode *ext2_nfs_get_inode(struct
> super_block *sb,
>     if (ino > le32_to_cpu(EXT2_SB(sb)->s_es->s_inodes_count))
>         return ERR_PTR(-ESTALE);
> 
> -   /* iget isn't really right if the inode is currently unallocated!!
> -    * ext2_read_inode currently does appropriate checks, but
> -    * it might be "neater" to call ext2_get_inode first and check
> -    * if the inode is valid.....
> +   /*
> +    * ext2_iget isn't really right if the inode is currently unallocated!!
  OK, but we should keep there a note that ext2_iget() does appropriate
checks to handle stale inodes.

									Honza
>      */
>     inode = ext2_iget(sb, ino);
>     if (IS_ERR(inode))
> -- 
> 1.7.4.1
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
