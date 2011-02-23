Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722Ab1BWVqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 16:46:19 -0500
Received: from kroah.org ([198.145.64.141]:59331 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753663Ab1BWVqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 16:46:18 -0500
Date: Wed, 23 Feb 2011 13:28:56 -0800
From: Greg KH <greg@kroah.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: hjanssen@microsoft.com, kys@microsoft.com, v-abkane@microsoft.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: Re: [PATCH 4/4] staging: hv: Fix the code depending on struct
 storvsc_driver_context data order
Message-ID: <20110223212856.GF23766@kroah.com>
References: <1298492398-16522-1-git-send-email-haiyangz@microsoft.com>
 <1298492398-16522-2-git-send-email-haiyangz@microsoft.com>
 <1298492398-16522-3-git-send-email-haiyangz@microsoft.com>
 <1298492398-16522-4-git-send-email-haiyangz@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298492398-16522-4-git-send-email-haiyangz@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 12:19:58PM -0800, Haiyang Zhang wrote:
> The patch fixed the code depending on the exact order of fields in the
> struct storvsc_driver_context. Now, we use container_of() instead of type
> casting from the first field to the container struct.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> 
> ---
>  drivers/staging/hv/storvsc_drv.c |   14 ++++++--------
>  1 files changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
> index 33acee5..a364627 100644
> --- a/drivers/staging/hv/storvsc_drv.c
> +++ b/drivers/staging/hv/storvsc_drv.c
> @@ -64,8 +64,6 @@ struct storvsc_cmd_request {
>  };
>  
>  struct storvsc_driver_context {
> -	/* !! These must be the first 2 fields !! */
> -	/* FIXME this is a bug... */
>  	struct driver_context drv_ctx;
>  	struct storvsc_driver_object drv_obj;
>  };
> @@ -223,8 +221,8 @@ static int storvsc_probe(struct device *device)
>  	int ret;
>  	struct driver_context *driver_ctx =
>  				driver_to_driver_context(device->driver);
> -	struct storvsc_driver_context *storvsc_drv_ctx =
> -				(struct storvsc_driver_context *)driver_ctx;
> +	struct storvsc_driver_context *storvsc_drv_ctx = container_of(
> +		driver_ctx, struct storvsc_driver_context, drv_ctx);

Same container_of() macro/inline function issue.

thanks,

greg k-h
