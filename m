Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685Ab1IWTGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 15:06:46 -0400
Received: from cobra.newdream.net ([66.33.216.30]:33989 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab1IWTGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 15:06:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:in-reply-to:message-id:references:mime-version:
	content-type; q=dns; s=newdream.net; b=i4ITSBXI3738ReGSTKvP/r/bU
	tUXkvCr/uJIkzS8jMa2FyPMJCdFXuzvdlr+s86gmY4rJ+11CmxkkJIx3upNQYFKX
	QzPfx7h/jcZuuV0Nz35Khwnss+NsL1F1oYhd7eIynzSAA0PPjfsmgOZSEko8Yh7r
	M/Xbm/Ff8mFPoWRK+8=
Date: Fri, 23 Sep 2011 12:06:43 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: H Hartley Sweeten <hartleys@visionengravers.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>, ceph-devel@vger.kernel.org
Subject: Re: [PATCH] ceph/super.c: quiet sparse noise
In-Reply-To: <201109231153.30334.hartleys@visionengravers.com>
Message-ID: <Pine.LNX.4.64.1109231206390.26399@cobra.newdream.net>
References: <201109231153.30334.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied, thanks!

sage

On Fri, 23 Sep 2011, H Hartley Sweeten wrote:

> Quiet the sparse noise:
> 
> warning: symbol 'create_fs_client' was not declared. Should it be static?
> warning: symbol 'destroy_fs_client' was not declared. Should it be static?
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Sage Weil <sage@newdream.net>
> ceph-devel@vger.kernel.org
> 
> ---
> 
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index e0a6a06..bbc1b78 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -426,7 +426,7 @@ static int extra_mon_dispatch(struct ceph_client *client, struct ceph_msg *msg)
>  /*
>   * create a new fs client
>   */
> -struct ceph_fs_client *create_fs_client(struct ceph_mount_options *fsopt,
> +static struct ceph_fs_client *create_fs_client(struct ceph_mount_options *fsopt,
>  					struct ceph_options *opt)
>  {
>  	struct ceph_fs_client *fsc;
> @@ -502,7 +502,7 @@ fail:
>  	return ERR_PTR(err);
>  }
>  
> -void destroy_fs_client(struct ceph_fs_client *fsc)
> +static void destroy_fs_client(struct ceph_fs_client *fsc)
>  {
>  	dout("destroy_fs_client %p\n", fsc);
>  
> --
> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
