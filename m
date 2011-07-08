Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab1GHTHu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 15:07:50 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35401 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab1GHTHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 15:07:49 -0400
Date: Fri, 8 Jul 2011 13:07:46 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: "Liu, ShuoX" <shuox.liu@intel.com>
Cc: "Tang, Feng" <feng.tang@intel.com>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dw_spi: Add spi number into spi irq desc
Message-ID: <20110708190746.GE9070@ponder.secretlab.ca>
References: <6E3BC7F7C9A4BF4286DD4C043110F30B59E04001D4@shsmsx502.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E3BC7F7C9A4BF4286DD4C043110F30B59E04001D4@shsmsx502.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 08, 2011 at 02:24:31PM +0800, Liu, ShuoX wrote:
> From b260c4e51487364552886b0327fe98d66e850168 Mon Sep 17 00:00:00 2001
> From: ShuoX Liu <shuox.liu@intel.com>
> Date: Thu, 7 Jul 2011 16:09:41 +0800
> Subject: [PATCH] dw_spi: Add spi number into spi irq desc
> 
> Signed-off-by: ShuoX Liu <shuox.liu@intel.com>

Patch does not apply against current spi/next (linux-next).

g.

> ---
>  drivers/spi/dw_spi.c |    4 +++-
>  drivers/spi/dw_spi.h |    1 +
>  2 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/spi/dw_spi.c b/drivers/spi/dw_spi.c
> index 919fa9d..68a3026 100644
> --- a/drivers/spi/dw_spi.c
> +++ b/drivers/spi/dw_spi.c
> @@ -818,9 +818,11 @@ int __devinit dw_spi_add_host(struct dw_spi *dws)
>  	dws->prev_chip = NULL;
>  	dws->dma_inited = 0;
>  	dws->dma_addr = (dma_addr_t)(dws->paddr + 0x60);
> +	snprintf(dws->name, sizeof(dws->name), "dw_spi%d",
> +			dws->bus_num);
>  
>  	ret = request_irq(dws->irq, dw_spi_irq, IRQF_SHARED,
> -			"dw_spi", dws);
> +			dws->name, dws);
>  	if (ret < 0) {
>  		dev_err(&master->dev, "can not get IRQ\n");
>  		goto err_free_master;
> diff --git a/drivers/spi/dw_spi.h b/drivers/spi/dw_spi.h
> index 7a5e78d..8b7b07b 100644
> --- a/drivers/spi/dw_spi.h
> +++ b/drivers/spi/dw_spi.h
> @@ -96,6 +96,7 @@ struct dw_spi {
>  	struct spi_device	*cur_dev;
>  	struct device		*parent_dev;
>  	enum dw_ssi_type	type;
> +	char			name[16];
>  
>  	void __iomem		*regs;
>  	unsigned long		paddr;
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
