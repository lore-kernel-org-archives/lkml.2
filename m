Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab2IUNrN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 09:47:13 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:29774 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab2IUNrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 09:47:12 -0400
Date: Fri, 21 Sep 2012 09:36:11 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Oliver Chick <oliver.chick@citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Change xen_vbd's flush_support and discard_secure to
 have type unsigned int, rather than bool
Message-ID: <20120921133611.GD13227@phenom.dumpdata.com>
References: <1348218258-4418-1-git-send-email-oliver.chick@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348218258-4418-1-git-send-email-oliver.chick@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 10:04:18AM +0100, Oliver Chick wrote:
> Changing the type of bdev parameters to be unsigned int :1, rather than bool.
> This is more consistent with the types of other features in the block drivers.

Thanks. Put in my for-jens branch.
> 
> Signed-off-by: Oliver Chick <oliver.chick@citrix.com>
> ---
>  drivers/block/xen-blkback/common.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
> index 9ad3b5e..9a54623 100644
> --- a/drivers/block/xen-blkback/common.h
> +++ b/drivers/block/xen-blkback/common.h
> @@ -158,8 +158,8 @@ struct xen_vbd {
>  	struct block_device	*bdev;
>  	/* Cached size parameter. */
>  	sector_t		size;
> -	bool			flush_support;
> -	bool			discard_secure;
> +	unsigned int		flush_support:1;
> +	unsigned int		discard_secure:1;
>  };
>  
>  struct backend_info;
> -- 
> 1.7.9.5
