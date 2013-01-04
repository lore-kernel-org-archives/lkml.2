Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab3ADPhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 10:37:47 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:51121 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968Ab3ADPhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 10:37:45 -0500
MIME-Version: 1.0
In-Reply-To: <1351612730-19029-1-git-send-email-javier.martin@vista-silicon.com>
References: <1351612730-19029-1-git-send-email-javier.martin@vista-silicon.com>
Date: Fri, 4 Jan 2013 16:37:44 +0100
Message-ID: <CACKLOr1NXVM3kUFkSMVf=BK9g4EzwXbj2-gvxKjfThe4kAcTsg@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: imx-dma: Disable use of hw_chain to fix sg_dma transfers.
From: javier Martin <javier.martin@vista-silicon.com>
To: linux-kernel@vger.kernel.org
Cc: djbw@fb.com, vinod.koul@intel.com,
        Javier Martin <javier.martin@vista-silicon.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 October 2012 16:58, Javier Martin <javier.martin@vista-silicon.com> wrote:
> HW chaining is currently broken in imx-dma. It can be easily reproduced doing
> intensive accesses to a external MMC card and checking how the file system
> is corrupted.
>
> Preventing the driver to use HW chaining solves these issues.
>
>
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> ---
>  drivers/dma/imx-dma.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
> index 5084975..03f3b64 100644
> --- a/drivers/dma/imx-dma.c
> +++ b/drivers/dma/imx-dma.c
> @@ -643,9 +643,8 @@ static int imxdma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
>                         break;
>                 }
>
> -               imxdmac->hw_chaining = 1;
> -               if (!imxdma_hw_chain(imxdmac))
> -                       return -EINVAL;
> +               imxdmac->hw_chaining = 0;
> +
>                 imxdmac->ccr_from_device = (mode | IMX_DMA_TYPE_FIFO) |
>                         ((IMX_DMA_MEMSIZE_32 | IMX_DMA_TYPE_LINEAR) << 2) |
>                         CCR_REN;
> --
> 1.7.9.5
>

Hi Vinod,
I see you missed this patch for 3.7. Could you please apply it as a fix for 3.8?

Regards.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
