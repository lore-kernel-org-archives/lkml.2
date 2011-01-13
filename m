Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399Ab1AMWGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 17:06:11 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:40378 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755699Ab1AMWGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 17:06:06 -0500
Date: Thu, 13 Jan 2011 16:05:55 -0600
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Dustin Kirkland <kirkland@canonical.com>,
        ecryptfs-devel@lists.launchpad.net, linux-kernel@vger.kernel.org
Subject: Re: ecryptfs build failure
Message-ID: <20110113220554.GA8313@boyd.l.tihix.com>
References: <20110113211535.GB4044@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110113211535.GB4044@swordfish>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu Jan 13, 2011 at 11:15:35PM +0200, Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:
> Hello,
> 
> Recent kernel failed to build due to ecryptfs/main.
> 2 of 3 errors could be fixed with the following patch. The third is:
> we make an assignment `lower_inode = lower_dentry->d_inode;' in
> ecryptfs_get_inode, yet ecryptfs_get_inode knows nothing about lower_dentry.

Thanks - This was mentioned just a little bit ago on LKML by Eric
Dumazet ([BUG] ECRYPT_FS) and Christoph responded with a patch. FWIW,
it doesn't look like the patch below addresses the lower_dentry issue in
ecryptfs_get_inode().

Tyler

> 
> ---
> 
>  fs/ecryptfs/main.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
> index 9ed4769..5694d65 100644
> --- a/fs/ecryptfs/main.c
> +++ b/fs/ecryptfs/main.c
> @@ -141,7 +141,7 @@ int ecryptfs_init_persistent_file(struct dentry *ecryptfs_dentry)
>  	return rc;
>  }
> 
> -static inode *ecryptfs_get_inode(struct inode *lower_inode,
> +static struct inode *ecryptfs_get_inode(struct inode *lower_inode,
>  		       struct super_block *sb)
>  {
>  	struct inode *inode;
> @@ -202,7 +202,7 @@ int ecryptfs_interpose(struct dentry *lower_dentry, struct dentry *dentry,
>  {
>  	struct inode *lower_inode = lower_dentry->d_inode;
>  	struct inode *inode = ecryptfs_get_inode(lower_inode, sb);
> -	if (IS_ERR(inode)
> +	if (IS_ERR(inode))
>  		return PTR_ERR(inode);
>  	if (flags & ECRYPTFS_INTERPOSE_FLAG_D_ADD)
>  		d_add(dentry, inode);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
