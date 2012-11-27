Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933071Ab2K0DFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 22:05:34 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:48443 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614Ab2K0DFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 22:05:33 -0500
Message-ID: <50B42DF8.8010407@inktank.com>
Date: Mon, 26 Nov 2012 21:05:28 -0600
From: Alex Elder <elder@inktank.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Sage Weil <sage@inktank.com>, ceph-devel <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [TRIVIAL PATCH] bdi_register: Add __printf verification, fix
 arg mismatch
References: <1353613769.10902.8.camel@joe-AO722>
In-Reply-To: <1353613769.10902.8.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2012 01:49 PM, Joe Perches wrote:
> __printf is useful to verify format and arguments.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Looks good.  I can take this into the ceph tree.  Thanks.

Reviewed-by: Alex Elder <elder@inktank.com>

> ---
>  fs/ceph/super.c             |    2 +-
>  include/linux/backing-dev.h |    1 +
>  2 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 2eb43f2..e7dbb5c 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -849,7 +849,7 @@ static int ceph_register_bdi(struct super_block *sb,
>  		fsc->backing_dev_info.ra_pages =
>  			default_backing_dev_info.ra_pages;
>  
> -	err = bdi_register(&fsc->backing_dev_info, NULL, "ceph-%d",
> +	err = bdi_register(&fsc->backing_dev_info, NULL, "ceph-%ld",
>  			   atomic_long_inc_return(&bdi_seq));
>  	if (!err)
>  		sb->s_bdi = &fsc->backing_dev_info;
> diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
> index 2a9a9ab..12731a1 100644
> --- a/include/linux/backing-dev.h
> +++ b/include/linux/backing-dev.h
> @@ -114,6 +114,7 @@ struct backing_dev_info {
>  int bdi_init(struct backing_dev_info *bdi);
>  void bdi_destroy(struct backing_dev_info *bdi);
>  
> +__printf(3, 4)
>  int bdi_register(struct backing_dev_info *bdi, struct device *parent,
>  		const char *fmt, ...);
>  int bdi_register_dev(struct backing_dev_info *bdi, dev_t dev);
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

