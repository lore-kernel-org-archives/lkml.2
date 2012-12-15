Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654Ab2LOAi1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 19:38:27 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:56146 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab2LOAi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 19:38:26 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/2] spi: devicetree: add support for loopback mode
To: Felipe Balbi <balbi@ti.com>, spi-devel-general@lists.sourceforge.net,
        rob@landley.net, rob.herring@calxeda.com
Cc: devicetree-discuss@lists.ozlabs.org,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>
In-Reply-To: <1355301960-21523-2-git-send-email-balbi@ti.com>
References: <1355301960-21523-1-git-send-email-balbi@ti.com> <1355301960-21523-2-git-send-email-balbi@ti.com>
Date: Sat, 15 Dec 2012 00:32:24 +0000
Message-Id: <20121215003224.CBFD93E0BEC@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Dec 2012 10:46:00 +0200, Felipe Balbi <balbi@ti.com> wrote:
> there are a few spi master drivers which make
> use of that flag but there is no way to pass it
> through devicetree.
> 
> This patch just creates a way to pass SPI_LOOP
> via devicetree.

I don't understand how this would be useful since loopback mode is
really just a test feature. Is there any reason to do loopback for
something other than test?

I think it would be better to add a sysfs or debugfs property to
manipulate the SPI_LOOP flag from userspace. What do you think?

g.

> 
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---
>  Documentation/devicetree/bindings/spi/spi-bus.txt | 2 ++
>  drivers/spi/spi.c                                 | 2 ++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/spi/spi-bus.txt b/Documentation/devicetree/bindings/spi/spi-bus.txt
> index 296015e..1949586 100644
> --- a/Documentation/devicetree/bindings/spi/spi-bus.txt
> +++ b/Documentation/devicetree/bindings/spi/spi-bus.txt
> @@ -55,6 +55,8 @@ contain the following properties.
>      		chip select active high
>  - spi-3wire       - (optional) Empty property indicating device requires
>      		    3-wire mode.
> +- spi-loopback    - (optional) Empty property indicating device requires
> +    		    loopback mode.
>  
>  If a gpio chipselect is used for the SPI slave the gpio number will be passed
>  via the cs_gpio
> diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
> index 3f1b9ee..6bcdc03 100644
> --- a/drivers/spi/spi.c
> +++ b/drivers/spi/spi.c
> @@ -868,6 +868,8 @@ static void of_register_spi_devices(struct spi_master *master)
>  			spi->mode |= SPI_CS_HIGH;
>  		if (of_find_property(nc, "spi-3wire", NULL))
>  			spi->mode |= SPI_3WIRE;
> +		if (of_find_property(nc, "spi-loopback", NULL))
> +			spi->mode |= SPI_LOOP;
>  
>  		/* Device speed */
>  		prop = of_get_property(nc, "spi-max-frequency", &len);
> -- 
> 1.8.1.rc1.5.g7e0651a
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
