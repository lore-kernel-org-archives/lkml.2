Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760014Ab2COIio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 04:38:44 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:34084 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756317Ab2COIik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 04:38:40 -0400
Message-ID: <1331800699.2389.63.camel@epip-laptop>
Subject: Re: [PATCH] arch/unicore32/kernel/dma.c: eliminated unneeded
 free_irq
From: Guan Xuetao <gxt@mprc.pku.edu.cn>
Reply-To: gxt@mprc.pku.edu.cn
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 15 Mar 2012 16:38:19 +0800
In-Reply-To: <1331798498-13606-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1331798498-13606-1-git-send-email-Julia.Lawall@lip6.fr>
Organization: MPRC, PKU
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-15 at 09:01 +0100, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> The device remains functional if the second request_irq fails, so the first
> one should not be freed.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

Thanks,
Guan Xuetao

> 
> ---
> diff --git a/arch/unicore32/kernel/dma.c b/arch/unicore32/kernel/dma.c
> index ae441bc..6184ff2 100644
> --- a/arch/unicore32/kernel/dma.c
> +++ b/arch/unicore32/kernel/dma.c
> @@ -172,8 +172,9 @@ int __init puv3_init_dma(void)
>  
>  	ret = request_irq(IRQ_DMAERR, dma_err_handler, 0, "DMAERR", NULL);
>  	if (ret) {
> +		/* the device remains function if this fails, so don't free
> +		   the previously allocated irq */
>  		printk(KERN_CRIT "Can't register IRQ for DMAERR\n");
> -		free_irq(IRQ_DMA, "DMA");
>  		return ret;
>  	}
>  


