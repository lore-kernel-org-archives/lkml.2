Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab2GERhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 13:37:18 -0400
Received: from void.printf.net ([89.145.121.20]:42207 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032Ab2GERhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 13:37:16 -0400
From: Chris Ball <cjb@laptop.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org
Subject: Re: [PATCH 4/9 v3] mmc: sh_mobile_sdhi: prepare for conversion to the shdma base library
References: <1336576161-27082-1-git-send-email-g.liakhovetski@gmx.de>
	<1336576161-27082-5-git-send-email-g.liakhovetski@gmx.de>
Date: Thu, 05 Jul 2012 13:37:08 -0400
In-Reply-To: <1336576161-27082-5-git-send-email-g.liakhovetski@gmx.de>
	(Guennadi Liakhovetski's message of "Wed, 9 May 2012 17:09:16 +0200")
Message-ID: <8762a2xg6z.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, May 09 2012, Guennadi Liakhovetski wrote:
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Chris Ball <cjb@laptop.org>
> ---
>  drivers/mmc/host/sh_mobile_sdhi.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/mmc/host/sh_mobile_sdhi.c b/drivers/mmc/host/sh_mobile_sdhi.c
> index 934b68e..b8d7004 100644
> --- a/drivers/mmc/host/sh_mobile_sdhi.c
> +++ b/drivers/mmc/host/sh_mobile_sdhi.c
> @@ -145,10 +145,10 @@ static int __devinit sh_mobile_sdhi_probe(struct platform_device *pdev)
>  		mmc_data->cd_gpio = p->cd_gpio;
>  
>  		if (p->dma_slave_tx > 0 && p->dma_slave_rx > 0) {
> -			priv->param_tx.slave_id = p->dma_slave_tx;
> -			priv->param_rx.slave_id = p->dma_slave_rx;
> -			priv->dma_priv.chan_priv_tx = &priv->param_tx;
> -			priv->dma_priv.chan_priv_rx = &priv->param_rx;
> +			priv->param_tx.shdma_slave.slave_id = p->dma_slave_tx;
> +			priv->param_rx.shdma_slave.slave_id = p->dma_slave_rx;
> +			priv->dma_priv.chan_priv_tx = &priv->param_tx.shdma_slave;
> +			priv->dma_priv.chan_priv_rx = &priv->param_rx.shdma_slave;
>  			priv->dma_priv.alignment_shift = 1; /* 2-byte alignment */
>  			mmc_data->dma = &priv->dma_priv;
>  		}

Acked-by: Chris Ball <cjb@laptop.org>

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
