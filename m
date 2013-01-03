Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab3ACH2d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 02:28:33 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:51466 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab3ACH23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 02:28:29 -0500
Message-ID: <50E5330B.2060007@ti.com>
Date: Thu, 3 Jan 2013 12:58:11 +0530
From: R Sricharan <r.sricharan@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: <ahemaily@gmail.com>
CC: <tony@atomide.com>, <linux-omap@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/1] arm :omap :DMA: fix a bug on reserving the omap SDMA
 channels
References: <1356813800-4705-1-git-send-email-ahemaily@gmail.com>
In-Reply-To: <1356813800-4705-1-git-send-email-ahemaily@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sunday 30 December 2012 02:13 AM, ahemaily@gmail.com wrote:
> From: ahemaily <ahemaily@gmail.com>
>
> The variable  dma_lch_count  used for comparison  (omap_dma_reserve_channels <= dma_lch_count)
> before it initialized to the value from omap_dma_dev_attr : d->lch_count.
>
> I change the place of dma_lch_count initialization to be before the comparison.
>
> Signed-off-by: Abdelrahman Hemaily <ahemaily@gmail.com>
> ---
>   arch/arm/plat-omap/dma.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/plat-omap/dma.c b/arch/arm/plat-omap/dma.c
> index c76ed8b..cb3e321 100644
> --- a/arch/arm/plat-omap/dma.c
> +++ b/arch/arm/plat-omap/dma.c
> @@ -2014,12 +2014,12 @@ static int __devinit omap_system_dma_probe(struct platform_device *pdev)
>
>   	d			= p->dma_attr;
>   	errata			= p->errata;
> -
> +	dma_lch_count           = d->lch_count;
> +
>   	if ((d->dev_caps & RESERVE_CHANNEL) && omap_dma_reserve_channels
>   			&& (omap_dma_reserve_channels <= dma_lch_count))
>   		d->lch_count	= omap_dma_reserve_channels;
>
> -	dma_lch_count		= d->lch_count;
    By removing this line, you are effectively not assigning
    d->lch_count after reserving. So the patch should only change
    dma_lch_count in the above "if statement" to d->lch_count

Regards,
  Sricharan


