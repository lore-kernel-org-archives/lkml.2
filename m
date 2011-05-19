Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934487Ab1ESTbr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 15:31:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64049 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933808Ab1ESTbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 15:31:44 -0400
Date: Thu, 19 May 2011 13:31:42 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ben Dooks <ben@simtec.co.uk>,
        spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH 2/2] spi: spi_s3c24xx: Use spi_bitbang_stop instead of
 spi_unregister_master in s3c24xx_spi_remove
Message-ID: <20110519193142.GR5109@ponder.secretlab.ca>
References: <1305416008.24670.1.camel@phoenix>
 <1305416116.24670.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305416116.24670.3.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 15, 2011 at 07:35:16AM +0800, Axel Lin wrote:
> Calling spi_bitbang_stop() will also destroy bitbang->workqueue,
> which is created by calling spi_bitbang_start() in s3c24xx_spi_probe().
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied, thanks.
g.

> ---
>  drivers/spi/spi_s3c24xx.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/spi/spi_s3c24xx.c b/drivers/spi/spi_s3c24xx.c
> index 151a95e..1a5fcab 100644
> --- a/drivers/spi/spi_s3c24xx.c
> +++ b/drivers/spi/spi_s3c24xx.c
> @@ -668,7 +668,7 @@ static int __exit s3c24xx_spi_remove(struct platform_device *dev)
>  
>  	platform_set_drvdata(dev, NULL);
>  
> -	spi_unregister_master(hw->master);
> +	spi_bitbang_stop(&hw->bitbang);
>  
>  	clk_disable(hw->clk);
>  	clk_put(hw->clk);
> -- 
> 1.7.1
> 
> 
> 
