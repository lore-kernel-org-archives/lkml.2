Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417Ab1GHEfY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 00:35:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:13504 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204Ab1GHEfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 00:35:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,497,1304319600"; 
   d="scan'208";a="24755304"
Date: Fri, 8 Jul 2011 12:44:32 +0800
From: Feng Tang <feng.tang@intel.com>
To: "Liu, ShuoX" <shuox.liu@intel.com>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dw_spi: Add spi number into spi irq desc
Message-ID: <20110708124432.23eb6848@feng-i7>
In-Reply-To: <6E3BC7F7C9A4BF4286DD4C043110F30B59E04000E2@shsmsx502.ccr.corp.intel.com>
References: <6E3BC7F7C9A4BF4286DD4C043110F30B59E04000E2@shsmsx502.ccr.corp.intel.com>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shuo,

Looks ok to me, and thanks for the fix. One nit is do we have to use a char[48]
for the name?

Thanks,
Feng

On Fri, 8 Jul 2011 11:51:05 +0800
"Liu, ShuoX" <shuox.liu@intel.com> wrote:

> From 2efa9dbb5c4b1d8fa798d1792498ae21fc3a9d04 Mon Sep 17 00:00:00 2001
> From: ShuoX Liu <shuox.liu@intel.com>
> Date: Thu, 7 Jul 2011 16:09:41 +0800
> Subject: [PATCH] dw_spi: Add spi number into spi irq desc
> 
> Signed-off-by: ShuoX Liu <shuox.liu@intel.com>
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
> index 7a5e78d..c7b9165 100644
> --- a/drivers/spi/dw_spi.h
> +++ b/drivers/spi/dw_spi.h
> @@ -96,6 +96,7 @@ struct dw_spi {
>  	struct spi_device	*cur_dev;
>  	struct device		*parent_dev;
>  	enum dw_ssi_type	type;
> +	char			name[48];
>  
>  	void __iomem		*regs;
>  	unsigned long		paddr;


