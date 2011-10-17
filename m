Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab1JQJ43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 05:56:29 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:50275 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab1JQJ41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 05:56:27 -0400
Message-ID: <4E9BFBB3.805@atmel.com>
Date: Mon, 17 Oct 2011 11:56:03 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        jaswinder.singh@linaro.org, 21cnbao@gmail.com, rmk@arm.linux.org.uk,
        Vinod Koul <vinod.koul@linux.intel.com>, Chris Ball <cjb@laptop.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 06/10] mmc-host: move to dma_transfer_direction
References: <1318570705-17595-1-git-send-email-vinod.koul@intel.com> <1318570705-17595-7-git-send-email-vinod.koul@intel.com>
In-Reply-To: <1318570705-17595-7-git-send-email-vinod.koul@intel.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2011 07:38 AM, Vinod Koul :
> From: Vinod Koul <vinod.koul@linux.intel.com>
> 
> Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Chris Ball <cjb@laptop.org>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  drivers/mmc/host/atmel-mci.c    |    9 ++++++---

[..]

> --- a/drivers/mmc/host/atmel-mci.c
> +++ b/drivers/mmc/host/atmel-mci.c
> @@ -681,16 +681,19 @@ atmci_prepare_data_dma(struct atmel_mci *host, struct mmc_data *data)
>  	if (atmci_is_mci2())
>  		mci_writel(host, DMA, MCI_DMA_CHKSIZE(3) | MCI_DMAEN);
>  
> -	if (data->flags & MMC_DATA_READ)
> +	if (data->flags & MMC_DATA_READ) {
>  		direction = DMA_FROM_DEVICE;
> -	else
> +		slave_dirn = DEV_TO_MEM;

It seems that the slave_dirn declaration is missing...

> +	} else {
>  		direction = DMA_TO_DEVICE;
> +		slave_dirn = MEM_TO_DEV;
> +	}
>  
>  	sglen = dma_map_sg(chan->device->dev, data->sg,
>  			   data->sg_len, direction);
>  
>  	desc = chan->device->device_prep_slave_sg(chan,
> -			data->sg, sglen, direction,
> +			data->sg, sglen, slave_dirn,
>  			DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
>  	if (!desc)
>  		goto unmap_exit;

When fixed:

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Best regards,
-- 
Nicolas Ferre
