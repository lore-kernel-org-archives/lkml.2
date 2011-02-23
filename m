Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736Ab1BWVqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 16:46:34 -0500
Received: from kroah.org ([198.145.64.141]:59325 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756065Ab1BWVqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 16:46:16 -0500
Date: Wed, 23 Feb 2011 13:28:06 -0800
From: Greg KH <greg@kroah.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: hjanssen@microsoft.com, kys@microsoft.com, v-abkane@microsoft.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: Re: [PATCH 3/4] staging: hv: Fix the code depending on struct
 blkvsc_driver_context data order
Message-ID: <20110223212806.GE23766@kroah.com>
References: <1298492398-16522-1-git-send-email-haiyangz@microsoft.com>
 <1298492398-16522-2-git-send-email-haiyangz@microsoft.com>
 <1298492398-16522-3-git-send-email-haiyangz@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298492398-16522-3-git-send-email-haiyangz@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 12:19:57PM -0800, Haiyang Zhang wrote:
> The patch fixed the code depending on the exact order of fields in the
> struct blkvsc_driver_context. Now, we use container_of() instead of type
> casting from the first field to the container struct.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> 
> ---
>  drivers/staging/hv/blkvsc_drv.c |    8 +++-----
>  1 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
> index 293ab8e..8f38895 100644
> --- a/drivers/staging/hv/blkvsc_drv.c
> +++ b/drivers/staging/hv/blkvsc_drv.c
> @@ -117,8 +117,6 @@ struct block_device_context {
>  
>  /* Per driver */
>  struct blkvsc_driver_context {
> -	/* !! These must be the first 2 fields !! */
> -	/* FIXME this is a bug! */
>  	struct driver_context drv_ctx;
>  	struct storvsc_driver_object drv_obj;
>  };
> @@ -248,7 +246,7 @@ static int blkvsc_probe(struct device *device)
>  	struct driver_context *driver_ctx =
>  				driver_to_driver_context(device->driver);
>  	struct blkvsc_driver_context *blkvsc_drv_ctx =
> -				(struct blkvsc_driver_context *)driver_ctx;
> +		container_of(driver_ctx, struct blkvsc_driver_context, drv_ctx);

Same container_of() complaint here, make it a macro or inline function.

thanks,

greg k-h
