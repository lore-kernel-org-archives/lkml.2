Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933603Ab2GDHGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 03:06:50 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42696 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab2GDHGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 03:06:48 -0400
Date: Wed, 4 Jul 2012 09:06:38 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: vinod.koul@intel.com, kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        dan.j.williams@intel.com, javier.martin@vista-silicon.com,
        Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH] dma: imx-dma: Fix kernel crash due to missing clock
 conversion
Message-ID: <20120704070638.GI2698@pengutronix.de>
References: <1341340409-9347-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341340409-9347-1-git-send-email-fabio.estevam@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:04:59 up 10 days, 22:16, 39 users,  load average: 0.43, 0.77,
 0.73
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2012 at 03:33:29PM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <festevam@gmail.com>
> 
> With the new i.MX clock infrastructure we need to request the dma clocks
> seperately: ahb and ipg clocks.
> 
> This fixes the following kernel crash and make audio to be functional again:
> 
> 
> Reported-by: Javier Martin <javier.martin@vista-silicon.com>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

One minor comment inside, should you have to resend this, please
consider addressing it. Otherwise:

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

> ---
>  drivers/dma/imx-dma.c |   36 +++++++++++++++++++++++++-----------
>  1 files changed, 25 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
> index fcfeb3c..5084975 100644
> --- a/drivers/dma/imx-dma.c
> +++ b/drivers/dma/imx-dma.c
> @@ -172,7 +172,8 @@ struct imxdma_engine {
>  	struct device_dma_parameters	dma_parms;
>  	struct dma_device		dma_device;
>  	void __iomem			*base;
> -	struct clk			*dma_clk;
> +	struct clk			*dma_ahb;
> +	struct clk			*dma_ipg;

I would prefer the names 'clk_*' so that it's a bit more obvious what
these are.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
