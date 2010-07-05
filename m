Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354Ab0GEKjh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 06:39:37 -0400
Received: from exprod5og110.obsmtp.com ([64.18.0.20]:60287 "EHLO
	exprod5og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756204Ab0GEKjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 06:39:36 -0400
Message-ID: <4C31B637.6070604@ge.com>
Date: Mon, 05 Jul 2010 11:38:47 +0100
From: Martyn Welch <martyn.welch@ge.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Kulikov Vasiliy <segooon@gmail.com>
CC: Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Julia Lawall <julia@diku.dk>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 22/25] vme_tsi148: remove casts from void*
References: <1277806581-31452-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1277806581-31452-1-git-send-email-segooon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kulikov Vasiliy wrote:
> Remove unnesessary casts from void*.
>
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
>   

Seems ok, cheers,

Signed-off-by: Martyn Welch <martyn.welch@ge.com>


> ---
>  drivers/staging/vme/bridges/vme_tsi148.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/staging/vme/bridges/vme_tsi148.c b/drivers/staging/vme/bridges/vme_tsi148.c
> index abe88a3..4685a31 100644
> --- a/drivers/staging/vme/bridges/vme_tsi148.c
> +++ b/drivers/staging/vme/bridges/vme_tsi148.c
> @@ -1649,7 +1649,7 @@ int tsi148_dma_list_add(struct vme_dma_list *list, struct vme_dma_attr *src,
>  	/* Fill out source part */
>  	switch (src->type) {
>  	case VME_DMA_PATTERN:
> -		pattern_attr = (struct vme_dma_pattern *)src->private;
> +		pattern_attr = src->private;
>  
>  		entry->descriptor.dsal = pattern_attr->pattern;
>  		entry->descriptor.dsat = TSI148_LCSR_DSAT_TYP_PAT;
> @@ -1663,7 +1663,7 @@ int tsi148_dma_list_add(struct vme_dma_list *list, struct vme_dma_attr *src,
>  
>  		break;
>  	case VME_DMA_PCI:
> -		pci_attr = (struct vme_dma_pci *)src->private;
> +		pci_attr = src->private;
>  
>  		reg_split((unsigned long long)pci_attr->address, &address_high,
>  			&address_low);
> @@ -1672,7 +1672,7 @@ int tsi148_dma_list_add(struct vme_dma_list *list, struct vme_dma_attr *src,
>  		entry->descriptor.dsat = TSI148_LCSR_DSAT_TYP_PCI;
>  		break;
>  	case VME_DMA_VME:
> -		vme_attr = (struct vme_dma_vme *)src->private;
> +		vme_attr = src->private;
>  
>  		reg_split((unsigned long long)vme_attr->address, &address_high,
>  			&address_low);
> @@ -1701,7 +1701,7 @@ int tsi148_dma_list_add(struct vme_dma_list *list, struct vme_dma_attr *src,
>  	/* Fill out destination part */
>  	switch (dest->type) {
>  	case VME_DMA_PCI:
> -		pci_attr = (struct vme_dma_pci *)dest->private;
> +		pci_attr = dest->private;
>  
>  		reg_split((unsigned long long)pci_attr->address, &address_high,
>  			&address_low);
> @@ -1710,7 +1710,7 @@ int tsi148_dma_list_add(struct vme_dma_list *list, struct vme_dma_attr *src,
>  		entry->descriptor.ddat = TSI148_LCSR_DDAT_TYP_PCI;
>  		break;
>  	case VME_DMA_VME:
> -		vme_attr = (struct vme_dma_vme *)dest->private;
> +		vme_attr = dest->private;
>  
>  		reg_split((unsigned long long)vme_attr->address, &address_high,
>  			&address_low);
>   


-- 
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square, Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189

