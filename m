Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab2IKIst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 04:48:49 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:47075 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab2IKIsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 04:48:47 -0400
Date: Tue, 11 Sep 2012 11:47:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Samuel Iglesias =?iso-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Jens Taprogge <jens.taprogge@taprogge.org>,
        linux-kernel@vger.kernel.org, industrypack-devel@lists.sourceforge.net
Subject: Re: [PATCH 05/20] Staging: ipack: Choose the optimum bus speed by
 default.
Message-ID: <20120911084755.GO19396@mwanda>
References: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
 <1347267118-9580-5-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1347267118-9580-5-git-send-email-siglesias@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 10:51:43AM +0200, Samuel Iglesias Gonsálvez wrote:
> From: Jens Taprogge <jens.taprogge@taprogge.org>
> 
> Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
> Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
> ---
>  drivers/staging/ipack/ipack.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/staging/ipack/ipack.c b/drivers/staging/ipack/ipack.c
> index 521ff55..6e0b441 100644
> --- a/drivers/staging/ipack/ipack.c
> +++ b/drivers/staging/ipack/ipack.c
> @@ -386,6 +386,11 @@ struct ipack_device *ipack_device_register(struct ipack_bus_device *bus,
>  		return NULL;
>  	}
>  
> +	/* if the device supports 32 MHz operation, use it. */
> +	ret = bus->ops->set_clockrate(dev, dev->speed_32mhz ? 32 : 8);
> +	if (ret < 0)
> +		dev_err(&dev->dev, "failed to switch to 32 MHz operation.\n");

It's strange that we don't test the ->speed_8mhz flag.  Do we even
need that flag?  It might be better to write it like this:

	if (dev->speed_32mhz) {
		ret = bus->ops->set_clockrate(dev, 32);
		 if (ret < 0) {
		 	dev_err(&dev->dev,
			        "failed to switch to 32 MHz operation.\n");
		}
	}

The error message is not accurate in the original code because it
says 32 even if you tried to set it to 8.

regards,
dan carpenter


