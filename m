Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab0KKL4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 06:56:44 -0500
Received: from gate.crashing.org ([63.228.1.57]:43792 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755956Ab0KKL4m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 06:56:42 -0500
Subject: Re: [PATCH v2] fsldma: add support to 36-bit physical address
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1289477789-10651-1-git-send-email-leoli@freescale.com>
Date: Thu, 11 Nov 2010 05:56:01 -0600
Cc: <dan.j.williams@intel.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <54AAF9B7-9533-45B8-9C49-A964203AF707@kernel.crashing.org>
References: <1289477789-10651-1-git-send-email-leoli@freescale.com>
To: Li Yang <leoli@freescale.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 11, 2010, at 6:16 AM, Li Yang wrote:

> Expand the dma_mask of fsldma device to 36-bit, indicating that the
> DMA engine can deal with 36-bit physical address and does not need
> the SWIOTLB to create bounce buffer for it when doing dma_map_*().
> 
> Signed-off-by: Li Yang <leoli@freescale.com>
> ---
> Add more detailed commit message
> 
> drivers/dma/fsldma.c |    4 +++-
> 1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
> index cea08be..8c79b37 100644
> --- a/drivers/dma/fsldma.c
> +++ b/drivers/dma/fsldma.c
> @@ -1,7 +1,7 @@
> /*
>  * Freescale MPC85xx, MPC83xx DMA Engine support
>  *
> - * Copyright (C) 2007 Freescale Semiconductor, Inc. All rights reserved.
> + * Copyright (C) 2007-2010 Freescale Semiconductor, Inc. All rights reserved.
>  *
>  * Author:
>  *   Zhang Wei <wei.zhang@freescale.com>, Jul 2007
> @@ -1338,6 +1338,8 @@ static int __devinit fsldma_of_probe(struct platform_device *op,
> 	fdev->common.device_control = fsl_dma_device_control;
> 	fdev->common.dev = &op->dev;
> 
> +	dma_set_mask(&(op->dev), DMA_BIT_MASK(36));
> +

Is there any reason we shouldn't set DMA_BIT_MASK(64) since the DMA block programming model allows the address to be 64-bits?

> 	dev_set_drvdata(&op->dev, fdev);
> 
> 	/*
> -- 
> 1.6.6-rc1.GIT
> 

