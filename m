Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab2DSGRG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 02:17:06 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:46623 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753035Ab2DSGRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 02:17:05 -0400
Date: Thu, 19 Apr 2012 09:16:09 +0300
From: Mika Westerberg <mika.westerberg@iki.fi>
To: Hannu Heikkinen <hannuxx@iki.fi>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca
Subject: Re: [PATCH] spi/ep93xx: clean probe/remove routines
Message-ID: <20120419061609.GC18520@mwesterb-mobl.lan>
References: <1334752571-24627-1-git-send-email-hannuxx@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334752571-24627-1-git-send-email-hannuxx@iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 03:36:11PM +0300, Hannu Heikkinen wrote:
> Use devm_* functions for managing devres resources.
> 
> Also use local espi_irq and remove irq variable from
> struct ep93xx_spi.
> 
> Cc: mika.westerberg@iki.fi
> Cc: grant.likely@secretlab.ca
> Signed-off-by: Hannu Heikkinen <hannuxx@iki.fi>
> ---
>  drivers/spi/spi-ep93xx.c |   36 ++++++++++--------------------------
>  1 file changed, 10 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
> index 6db2887..2c5fb81 100644
> --- a/drivers/spi/spi-ep93xx.c
> +++ b/drivers/spi/spi-ep93xx.c
> @@ -114,7 +114,6 @@ struct ep93xx_spi {
>  	struct clk			*clk;
>  	void __iomem			*regs_base;
>  	unsigned long			sspdr_phys;
> -	int				irq;
>  	unsigned long			min_rate;
>  	unsigned long			max_rate;
>  	bool				running;
> @@ -1035,6 +1034,7 @@ static int __devinit ep93xx_spi_probe(struct platform_device *pdev)
>  	struct ep93xx_spi_info *info;
>  	struct ep93xx_spi *espi;
>  	struct resource *res;
> +	int espi_irq;

Since you are going to make a new version of the patch anyway, can you rename
'espi_irq' to just plain 'irq'?

After that you can add my

Acked-by: Mika Westerberg <mika.westerberg@iki.fi>
