Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab0IUMzh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 08:55:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:33380 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823Ab0IUMzg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 08:55:36 -0400
Subject: Re: [PATCH] fsldma: add support to 36-bit physical address
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1285066638-7473-1-git-send-email-leoli@freescale.com>
Date: Tue, 21 Sep 2010 07:55:22 -0500
Cc: dan.j.williams@intel.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <877FD0B5-19A7-4A16-831E-369B80B104EA@kernel.crashing.org>
References: <1285066638-7473-1-git-send-email-leoli@freescale.com>
To: Li Yang <leoli@freescale.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 21, 2010, at 5:57 AM, Li Yang wrote:

> Signed-off-by: Li Yang <leoli@freescale.com>
> ---

We really should have a sentence about how or why this works to address 36-bit addressing.

> drivers/dma/fsldma.c |    3 ++-
> 1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
> index cea08be..9163552 100644
> --- a/drivers/dma/fsldma.c
> +++ b/drivers/dma/fsldma.c
> @@ -1,7 +1,7 @@
> /*
>  * Freescale MPC85xx, MPC83xx DMA Engine support
>  *
> - * Copyright (C) 2007 Freescale Semiconductor, Inc. All rights reserved.
> + * Copyright (C) 2007-2009 Freescale Semiconductor, Inc. All rights reserved.
>  *
>  * Author:
>  *   Zhang Wei <wei.zhang@freescale.com>, Jul 2007
> @@ -1338,6 +1338,7 @@ static int __devinit fsldma_of_probe(struct platform_device *op,
> 	fdev->common.device_control = fsl_dma_device_control;
> 	fdev->common.dev = &op->dev;
> 
> +	dma_set_mask(&op->dev, DMA_BIT_MASK(36));
> 	dev_set_drvdata(&op->dev, fdev);
> 
> 	/*
> -- 
> 1.6.6-rc1.GIT
> 
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev

