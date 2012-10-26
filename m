Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462Ab2JZLjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 07:39:44 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39957 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932349Ab2JZLjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 07:39:41 -0400
Message-ID: <508A7665.4030109@ti.com>
Date: Fri, 26 Oct 2012 17:09:17 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Cyril Chemparathy <cyril@ti.com>
CC: <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <khilman@ti.com>, "Porter, Matt" <mporter@ti.com>
Subject: Re: [PATCH] davinci: check for presence of channel controller on
 slot alloc
References: <1347473642-9948-1-git-send-email-cyril@ti.com>
In-Reply-To: <1347473642-9948-1-git-send-email-cyril@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Matt, who is doing the DMA engine conversion for EDMA

On 9/12/2012 11:44 PM, Cyril Chemparathy wrote:
> This patch adds a check for the presence of the channel controller when
> trying to allocate a slot.  Without this fix, the kernel panics with a NULL
> pointer dereference when the dma-engine drivers are probed.
> 
> Signed-off-by: Cyril Chemparathy <cyril@ti.com>
> ---
>  arch/arm/mach-davinci/dma.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm/mach-davinci/dma.c b/arch/arm/mach-davinci/dma.c
> index a685e97..2fee31e 100644
> --- a/arch/arm/mach-davinci/dma.c
> +++ b/arch/arm/mach-davinci/dma.c
> @@ -743,6 +743,9 @@ EXPORT_SYMBOL(edma_free_channel);
>   */
>  int edma_alloc_slot(unsigned ctlr, int slot)
>  {
> +	if (!edma_cc[ctlr])
> +		return -ENODEV;

I am ok with this patch, although I wonder if a better error is -ENXIO
or even -EINVAL (since its most likely the result of a wrong argument).

This patch will conflict with the EDMA movement series that Matt is
doing and he should probably include it in his series to avoid
conflicts. From the description it appears to be not required for v3.7
anyway.

Thanks,
Sekhar
