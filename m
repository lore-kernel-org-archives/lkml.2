Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760084Ab2COIJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 04:09:50 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:58229 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195Ab2COIJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 04:09:44 -0400
Message-ID: <4F61A3C6.8000607@bfs.de>
Date: Thu, 15 Mar 2012 09:09:42 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: Guan Xuetao <gxt@mprc.pku.edu.cn>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/unicore32/kernel/dma.c: eliminated unneeded free_irq
References: <1331798498-13606-1-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1331798498-13606-1-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 15.03.2012 09:01, schrieb Julia Lawall:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> The device remains functional if the second request_irq fails, so the first
> one should not be freed.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
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

obviously we had the same idea ... i did not see that her it came in the moment i send my reply
sorry for the noise,
re,
 wh

