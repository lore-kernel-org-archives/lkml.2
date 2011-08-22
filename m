Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab1HVUOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 16:14:23 -0400
Received: from cobra.newdream.net ([66.33.216.30]:47067 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588Ab1HVUOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 16:14:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:in-reply-to:message-id:references:mime-version:
	content-type; q=dns; s=newdream.net; b=qj6mSHQUwMdod/LiLM05AJ4x7
	kRP6qFbzkRT7qPauc15IHhn9vdeEjIiQycDOBt+bkGW0egq5gxpwPaKU2t8oR9fM
	Fd4nv6hNb/gKHNjuzinF/zKhd9cIugbPMNq5UPrFTf6LBzwAl+aLOrsqSyrST4ak
	snVoDPNnP8USnopy2o=
Date: Mon, 22 Aug 2011 13:19:17 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Noah Watkins <noahwatkins@gmail.com>
cc: ceph-devel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ceph: fix memory leak
In-Reply-To: <CAB2gnbWqq4qDh0qmK8tC1-q5KY2H0rf_fNX_kVcFUEM6ZhYo5w@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1108221317320.17780@cobra.newdream.net>
References: <CAB2gnbWqq4qDh0qmK8tC1-q5KY2H0rf_fNX_kVcFUEM6ZhYo5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, applied both of these!

sage

On Mon, 22 Aug 2011, Noah Watkins wrote:

> kfree does not clean up indirect allocations in
> ceph_fs_client and ceph_options (e.g. snapdir_name).
> 
> Signed-off-by: Noah Watkins <noahwatkins@gmail.com>
> ---
>  fs/ceph/super.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 733674d..788f5ad 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -824,8 +824,8 @@ static struct dentry *ceph_mount(struct
> file_system_type *fs_type,
>  	fsc = create_fs_client(fsopt, opt);
>  	if (IS_ERR(fsc)) {
>  		res = ERR_CAST(fsc);
> -		kfree(fsopt);
> -		kfree(opt);
> +		destroy_mount_options(fsopt);
> +		ceph_destroy_options(opt);
>  		goto out_final;
>  	}
> 
> -- 
> 1.7.6
> --
> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
