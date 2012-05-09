Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760856Ab2EITdm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 15:33:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49777 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab2EITdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 15:33:41 -0400
Date: Wed, 9 May 2012 12:33:37 -0700
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [ 046/167] [PATCH] spi: Fix device unregistration when
 unregistering the bus master
Message-ID: <20120509193335.GD15527@herton-ThinkPad-T420>
References: <20120509055029.588587017@decadent.org.uk>
 <20120509055036.064659639@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120509055036.064659639@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 06:51:15AM +0100, Ben Hutchings wrote:
> 3.2-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> commit 178db7d30f94707efca1a189753c105ef69942ed upstream.

After applying this change, this introduces a bug on spi-fsl-spi.c, we
need to apply in addition to this change commit
5039a86973cd35bdb2f64d28ee12f13fe2bb5a4c

> 
> Device are added as children of the bus master's parent device, but
> spi_unregister_master() looks for devices to unregister in the bus
> master's children. This results in the child devices not being
> unregistered.
> 
> Fix this by registering devices as direct children of the bus master.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/spi/spi.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
> index 77eae99..b2ccdea 100644
> --- a/drivers/spi/spi.c
> +++ b/drivers/spi/spi.c
> @@ -319,7 +319,7 @@ struct spi_device *spi_alloc_device(struct spi_master *master)
>  	}
>  
>  	spi->master = master;
> -	spi->dev.parent = dev;
> +	spi->dev.parent = &master->dev;
>  	spi->dev.bus = &spi_bus_type;
>  	spi->dev.release = spidev_release;
>  	device_initialize(&spi->dev);
> -- 
> 1.7.10
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
