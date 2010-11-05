Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab0KERT6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 13:19:58 -0400
Received: from relay1.sgi.com ([192.48.179.29]:58395 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753159Ab0KERTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 13:19:54 -0400
Subject: Re: [PATCH] xfs: linux-2.6: xfs_ioctl: fix information leak to
 userland
From: Alex Elder <aelder@sgi.com>
Reply-To: aelder@sgi.com
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, xfs-masters@oss.sgi.com,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Arkadiusz =?UTF-8?Q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>,
        xfs@oss.sgi.com, linux-kernel@vger.kernel.org
In-Reply-To: <1288448778-5373-1-git-send-email-segooon@gmail.com>
References: <1288448778-5373-1-git-send-email-segooon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Nov 2010 12:19:49 -0500
Message-ID: <1288977589.2295.27.camel@doink>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Nov 2010 17:19:49.0874 (UTC) FILETIME=[A6EC4520:01CB7D0D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-10-30 at 18:26 +0400, Vasiliy Kulikov wrote:
> al_hreq is copied from userland.  If al_hreq.buflen is not properly aligned then
> xfs_attr_list will ignore the last bytes of kbuf.  These bytes are unitialized.
> It leads to leaking of contents of kernel stack memory.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> ---
>  Compile tested.
> 
>  fs/xfs/linux-2.6/xfs_ioctl.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_ioctl.c b/fs/xfs/linux-2.6/xfs_ioctl.c
> index 2ea238f..ad442d9 100644
> --- a/fs/xfs/linux-2.6/xfs_ioctl.c
> +++ b/fs/xfs/linux-2.6/xfs_ioctl.c
> @@ -416,7 +416,7 @@ xfs_attrlist_by_handle(
>  	if (IS_ERR(dentry))
>  		return PTR_ERR(dentry);
>  
> -	kbuf = kmalloc(al_hreq.buflen, GFP_KERNEL);
> +	kbuf = kzalloc(al_hreq.buflen, GFP_KERNEL);
>  	if (!kbuf)
>  		goto out_dput;
>  

Looks good.  I will take this in and will send
it to Linus for 2.6.37.  Thanks.

Reviewed-by: Alex Elder <aelder@sgi.com>

