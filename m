Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab2FCVE2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 17:04:28 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:61711 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719Ab2FCVE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 17:04:27 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 108.17.144.84
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+r2jamYMeJ9xQAgfxvcQblymmRQRwNzjU=
Date: Sun, 3 Jun 2012 17:04:24 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Michael Walle <michael@walle.cc>
Cc: linux-arm-kernel@lists.infradead.org,
        "open list:SPI SUBSYSTEM" <spi-devel-general@lists.sourceforge.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] spi-orion: remove uneeded spi_info
Message-ID: <20120603210424.GM14756@titan.lakedaemon.net>
References: <1338754215-16022-1-git-send-email-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338754215-16022-1-git-send-email-michael@walle.cc>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 03, 2012 at 10:10:14PM +0200, Michael Walle wrote:
> This was formerly used to store the tclk value. Remove it.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>  drivers/spi/spi-orion.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/spi/spi-orion.c b/drivers/spi/spi-orion.c
> index dfd04e9..2760450 100644
> --- a/drivers/spi/spi-orion.c
> +++ b/drivers/spi/spi-orion.c
> @@ -45,7 +45,6 @@ struct orion_spi {
>  	void __iomem		*base;
>  	unsigned int		max_speed;
>  	unsigned int		min_speed;
> -	struct orion_spi_info	*spi_info;
>  	struct clk              *clk;
>  };
>  
> @@ -450,12 +449,9 @@ static int __init orion_spi_probe(struct platform_device *pdev)
>  	struct spi_master *master;
>  	struct orion_spi *spi;
>  	struct resource *r;
> -	struct orion_spi_info *spi_info;
>  	unsigned long tclk_hz;
>  	int status = 0;
>  
> -	spi_info = pdev->dev.platform_data;
> -
>  	master = spi_alloc_master(&pdev->dev, sizeof *spi);
>  	if (master == NULL) {
>  		dev_dbg(&pdev->dev, "master allocation failed\n");
> @@ -476,7 +472,6 @@ static int __init orion_spi_probe(struct platform_device *pdev)
>  
>  	spi = spi_master_get_devdata(master);
>  	spi->master = master;
> -	spi->spi_info = spi_info;
>  
>  	spi->clk = clk_get(&pdev->dev, NULL);

It's not relevant to this patch, but later in the patch series, you
initialize this device via devicetree.  Did you add the clock node?  Is
there a dependency for this series that I missed?

thx,

Jason.

>  	if (IS_ERR(spi->clk)) {
> -- 
> 1.7.2.5
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
