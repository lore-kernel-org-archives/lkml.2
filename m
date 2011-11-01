Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab1KAXhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 19:37:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44756 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755986Ab1KAXhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 19:37:12 -0400
Date: Wed, 2 Nov 2011 00:37:08 +0100
From: Jan Kara <jack@suse.cz>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@openvz.org,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fs: fix dentry leak in simple_fill_super()
Message-ID: <20111101233708.GK18701@quack.suse.cz>
References: <20111101121233.15505.87415.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111101121233.15505.87415.stgit@zurg>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 01-11-11 16:12:33, Konstantin Khlebnikov wrote:
> put dentry if inode allocation failed, d_genocide() cannot release it
  Al is currently ill and Christoph Hellwig is taking care of fixes for
now. Added him to CC...

								Honza

> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> ---
>  fs/libfs.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/libfs.c b/fs/libfs.c
> index c18e9a1..a2c0029 100644
> --- a/fs/libfs.c
> +++ b/fs/libfs.c
> @@ -510,8 +510,10 @@ int simple_fill_super(struct super_block *s, unsigned long magic,
>  		if (!dentry)
>  			goto out;
>  		inode = new_inode(s);
> -		if (!inode)
> +		if (!inode) {
> +			dput(dentry);
>  			goto out;
> +		}
>  		inode->i_mode = S_IFREG | files->mode;
>  		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
>  		inode->i_fop = files->ops;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
