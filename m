Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287Ab0JQVeJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 17:34:09 -0400
Received: from cobra.newdream.net ([66.33.216.30]:34307 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab0JQVeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 17:34:07 -0400
Date: Sun, 17 Oct 2010 14:36:56 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Julia Lawall <julia@diku.dk>
cc: Joe Perches <joe@perches.com>, kernel-janitors@vger.kernel.org,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] fs/ceph/xattr.c: Use kmemdup
In-Reply-To: <Pine.LNX.4.64.1010172154400.394@ask.diku.dk>
Message-ID: <Pine.LNX.4.64.1010171436260.1842@cobra.newdream.net>
References: <1287341311-11161-1-git-send-email-julia@diku.dk> 
 <1287341311-11161-3-git-send-email-julia@diku.dk> <1287341657.20968.61.camel@Joe-Laptop>
 <Pine.LNX.4.64.1010172154400.394@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, applied!

sage


On Sun, 17 Oct 2010, Julia Lawall wrote:

> Convert a sequence of kmalloc and memcpy to use kmemdup.
> 
> The semantic patch that performs this transformation is:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression a,flag,len;
> expression arg,e1,e2;
> statement S;
> @@
> 
>   a =
> -  \(kmalloc\|kzalloc\)(len,flag)
> +  kmemdup(arg,len,flag)
>   <... when != a
>   if (a == NULL || ...) S
>   ...>
> - memcpy(a,arg,len+1);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  fs/ceph/xattr.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff -u -p a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -716,10 +716,9 @@ int ceph_setxattr(struct dentry *dentry,
>  
>  	/* preallocate memory for xattr name, value, index node */
>  	err = -ENOMEM;
> -	newname = kmalloc(name_len + 1, GFP_NOFS);
> +	newname = kmemdup(name, name_len + 1, GFP_NOFS);
>  	if (!newname)
>  		goto out;
> -	memcpy(newname, name, name_len + 1);
>  
>  	if (val_len) {
>  		newval = kmalloc(val_len + 1, GFP_NOFS);
> --
> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
