Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab2EZLaz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 07:30:55 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36413 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab2EZLax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 07:30:53 -0400
Date: Sat, 26 May 2012 13:30:46 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: kernel@pengutronix.de, shawn.guo@freescale.com,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/15] dma: imx-sdma: Use
 clk_prepare_enable/clk_disable_unprepare
Message-ID: <20120526113046.GX30400@pengutronix.de>
References: <1337987696-31728-1-git-send-email-festevam@gmail.com>
 <1337987696-31728-4-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337987696-31728-4-git-send-email-festevam@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 13:30:14 up 195 days, 19:17, 39 users,  load average: 6.22, 5.26,
 3.35
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 08:14:45PM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Prepare the clock before enabling it.
> 
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: <linux-kernel@vger.kernel.org>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  drivers/dma/imx-sdma.c |   28 ++++++++++++++--------------
>  1 files changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
> index fb4f499..b6174e6 100644
> --- a/drivers/dma/imx-sdma.c
> +++ b/drivers/dma/imx-sdma.c
> @@ -868,8 +868,8 @@ static int sdma_alloc_chan_resources(struct dma_chan *chan)
>  	sdmac->peripheral_type = data->peripheral_type;
>  	sdmac->event_id0 = data->dma_request;
>  
> -	clk_enable(sdmac->sdma->clk_ipg);
> -	clk_enable(sdmac->sdma->clk_ahb);
> +	clk_prepare_enable(sdmac->sdma->clk_ipg);
> +	clk_prepare_enable(sdmac->sdma->clk_ahb);

No, the clock already is prepared, see the probe function.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
