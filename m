Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab1AJNVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 08:21:25 -0500
Received: from mail.atmel.fr ([81.80.104.162]:51489 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708Ab1AJNVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 08:21:24 -0500
Message-ID: <4D2B07D0.5050602@atmel.com>
Date: Mon, 10 Jan 2011 14:21:20 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: dan.j.williams@intel.com
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: at_hdmac: use dma_address to program DMA hardware
References: <1292435416-16927-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1292435416-16927-1-git-send-email-nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 15/12/2010 18:50, Nicolas Ferre :
> In atc_prep_slave_sg() function we use dma_address field of scatterlist with
> sg_dma_address() macro instead of sg_phys(). DMA address is already computed
> by dma_map_sg() or another mapping function in calling driver.

Ping?

> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  drivers/dma/at_hdmac.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
> index ea0ee81..ee7dacd 100644
> --- a/drivers/dma/at_hdmac.c
> +++ b/drivers/dma/at_hdmac.c
> @@ -670,7 +670,7 @@ atc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
>  			if (!desc)
>  				goto err_desc_get;
>  
> -			mem = sg_phys(sg);
> +			mem = sg_dma_address(sg);
>  			len = sg_dma_len(sg);
>  			mem_width = 2;
>  			if (unlikely(mem & 3 || len & 3))
> @@ -712,7 +712,7 @@ atc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
>  			if (!desc)
>  				goto err_desc_get;
>  
> -			mem = sg_phys(sg);
> +			mem = sg_dma_address(sg);
>  			len = sg_dma_len(sg);
>  			mem_width = 2;
>  			if (unlikely(mem & 3 || len & 3))


-- 
Nicolas Ferre
