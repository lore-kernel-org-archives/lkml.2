Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab0CUD6z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 23:58:55 -0400
Received: from cobra.newdream.net ([66.33.216.30]:34526 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab0CUD6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 23:58:53 -0400
Date: Sat, 20 Mar 2010 20:59:53 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Dan Carpenter <error27@gmail.com>
cc: ceph-devel@lists.sourceforge.net, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [ceph-devel] [patch] ceph: cleanup: remove dead code
In-Reply-To: <20100320130127.GA32626@bicker>
Message-ID: <Pine.LNX.4.64.1003202059420.15445@cobra.newdream.net>
References: <20100320130127.GA32626@bicker>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Mar 2010, Dan Carpenter wrote:

> "xattr" is never NULL here.  We took care of that in the previous
> if statement block.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> index 37d6ce6..65b0e9b 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -185,12 +185,6 @@ static int __set_xattr(struct ceph_inode_info *ci,
>  		ci->i_xattrs.names_size -= xattr->name_len;
>  		ci->i_xattrs.vals_size -= xattr->val_len;
>  	}
> -	if (!xattr) {
> -		pr_err("__set_xattr ENOMEM on %p %llx.%llx xattr %s=%s\n",
> -		       &ci->vfs_inode, ceph_vinop(&ci->vfs_inode), name,
> -		       xattr->val);
> -		return -ENOMEM;
> -	}
>  	ci->i_xattrs.names_size += name_len;
>  	ci->i_xattrs.vals_size += val_len;
>  	if (val)

Applied, thanks!
sage
