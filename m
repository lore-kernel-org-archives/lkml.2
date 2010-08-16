Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab0HPX34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 19:29:56 -0400
Received: from khc.piap.pl ([195.187.100.11]:52764 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995Ab0HPX3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 19:29:55 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: ARM: 2.6.3[45] PCI regression (IXP4xx and PXA?)
References: <20100811072532.GA21511@n2100.arm.linux.org.uk>
	<20100813152224H.fujita.tomonori@lab.ntt.co.jp>
	<20100813215413.GA21607@n2100.arm.linux.org.uk>
	<20100814181306U.fujita.tomonori@lab.ntt.co.jp>
Date: Tue, 17 Aug 2010 01:29:49 +0200
In-Reply-To: <20100814181306U.fujita.tomonori@lab.ntt.co.jp> (FUJITA
	Tomonori's message of "Sat, 14 Aug 2010 18:30:37 +0900")
Message-ID: <m3vd7agmqa.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> writes:

> A long solution would be having two dma_mask for a device and a
> bus. We also need something to represent a DMA-capable range instead
> of the dma mask.
>
> --- a/arch/arm/mm/dma-mapping.c
> +++ b/arch/arm/mm/dma-mapping.c
> @@ -77,6 +77,11 @@ static struct page *__dma_alloc_buffer(struct device *dev, size_t size, gfp_t gf
>  	if (mask < 0xffffffffULL)
>  		gfp |= GFP_DMA;
>  
> +#ifdef CONFIG_DMABOUNCE
> +	if (dev->archdata.dmabounce)
> +		gfp |= GFP_DMA;
> +#endif
> +
>  	page = alloc_pages(gfp, order);
>  	if (!page)
>  		return NULL;

This patch fixes the problem on my IXP425.
-- 
Krzysztof Halasa
