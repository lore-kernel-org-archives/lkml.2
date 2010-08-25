Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab0HYTA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 15:00:27 -0400
Received: from cobra.newdream.net ([66.33.216.30]:46228 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab0HYTAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 15:00:24 -0400
Date: Wed, 25 Aug 2010 12:01:07 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Dan Carpenter <error27@gmail.com>
cc: Yehuda Sadeh <yehuda@hq.newdream.net>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] ceph: ceph_get_inode() returns an ERR_PTR
In-Reply-To: <20100825071135.GO29330@bicker>
Message-ID: <Pine.LNX.4.64.1008251201020.19762@cobra.newdream.net>
References: <20100825071135.GO29330@bicker>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, queueing this up!

sage


On Wed, 25 Aug 2010, Dan Carpenter wrote:

> ceph_get_inode() returns an ERR_PTR and it doesn't return a NULL.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 5d893d3..1e623ec 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -1229,11 +1229,11 @@ retry_lookup:
>  			in = dn->d_inode;
>  		} else {
>  			in = ceph_get_inode(parent->d_sb, vino);
> -			if (in == NULL) {
> +			if (IS_ERR(in)) {
>  				dout("new_inode badness\n");
>  				d_delete(dn);
>  				dput(dn);
> -				err = -ENOMEM;
> +				err = PTR_ERR(in);
>  				goto out;
>  			}
>  			dn = splice_dentry(dn, in, NULL);
> --
> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
