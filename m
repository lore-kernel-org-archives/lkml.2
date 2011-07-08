Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549Ab1GHEww (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 00:52:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:48107 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055Ab1GHEwu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 00:52:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,498,1304319600"; 
   d="scan'208";a="25263229"
From: "Liu, ShuoX" <shuox.liu@intel.com>
To: "Tang, Feng" <feng.tang@intel.com>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 8 Jul 2011 12:52:28 +0800
Subject: RE: [PATCH] dw_spi: Add spi number into spi irq desc
Thread-Topic: [PATCH] dw_spi: Add spi number into spi irq desc
Thread-Index: Acw9KFceEbXOFzvWRrCX/tinZ7YQrAAAFlTQ
Message-ID: <6E3BC7F7C9A4BF4286DD4C043110F30B59E0400124@shsmsx502.ccr.corp.intel.com>
References: <6E3BC7F7C9A4BF4286DD4C043110F30B59E04000E2@shsmsx502.ccr.corp.intel.com>
 <20110708124432.23eb6848@feng-i7>
In-Reply-To: <20110708124432.23eb6848@feng-i7>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for your quick response.
That is not a must. I just followed struct i2c_adapter. What about your idea?

Best Regards,
Shuo liu


-----Original Message-----
From: Tang, Feng 
Sent: Friday, July 08, 2011 12:45 PM
To: Liu, ShuoX
Cc: grant.likely@secretlab.ca; spi-devel-general@lists.sourceforge.net; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dw_spi: Add spi number into spi irq desc

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


