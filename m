Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab0GEKjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 06:39:14 -0400
Received: from exprod5og113.obsmtp.com ([64.18.0.26]:54221 "EHLO
	exprod5og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944Ab0GEKjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 06:39:12 -0400
Message-ID: <4C31B620.4060301@ge.com>
Date: Mon, 05 Jul 2010 11:38:24 +0100
From: Martyn Welch <martyn.welch@ge.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Kulikov Vasiliy <segooon@gmail.com>
CC: Kernel Janitors <kernel-janitors@vger.kernel.org>,
       devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Julia Lawall <julia@diku.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 21/25] vme_ca91cx42: remove casts from void*
References: <1277806577-31418-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1277806577-31418-1-git-send-email-segooon@gmail.com>
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
>  drivers/staging/vme/bridges/vme_ca91cx42.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/vme/bridges/vme_ca91cx42.c b/drivers/staging/vme/bridges/vme_ca91cx42.c
> index 0c82eb4..ce05ffa 100644
> --- a/drivers/staging/vme/bridges/vme_ca91cx42.c
> +++ b/drivers/staging/vme/bridges/vme_ca91cx42.c
> @@ -961,11 +961,11 @@ int ca91cx42_dma_list_add(struct vme_dma_list *list, struct vme_dma_attr *src,
>  
>  	if (dest->type == VME_DMA_VME) {
>  		entry->descriptor.dctl |= CA91CX42_DCTL_L2V;
> -		vme_attr = (struct vme_dma_vme *)dest->private;
> -		pci_attr = (struct vme_dma_pci *)src->private;
> +		vme_attr = dest->private;
> +		pci_attr = src->private;
>  	} else {
> -		vme_attr = (struct vme_dma_vme *)src->private;
> -		pci_attr = (struct vme_dma_pci *)dest->private;
> +		vme_attr = src->private;
> +		pci_attr = dest->private;
>  	}
>  
>  	/* Check we can do fullfill required attributes */
>   


-- 
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square, Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189

