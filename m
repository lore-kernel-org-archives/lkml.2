Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781Ab2CILAd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 06:00:33 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51242 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab2CILAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 06:00:32 -0500
Date: Fri, 9 Mar 2012 12:00:28 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Javier Martin <javier.martin@vista-silicon.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dan.j.williams@intel.com, vinod.koul@intel.com, linux@arm.linux.org.uk,
        kernel@pengutronix.de
Subject: Re: [PATCH v2 01/13] dmaengine: imx-dma: merge old dma-v1.c with
 imx-dma.c
Message-ID: <20120309110028.GB3852@pengutronix.de>
References: <1331130825-14947-1-git-send-email-javier.martin@vista-silicon.com>
 <1331130825-14947-2-git-send-email-javier.martin@vista-silicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331130825-14947-2-git-send-email-javier.martin@vista-silicon.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:58:54 up 117 days, 18:45, 60 users,  load average: 0.09, 0.25,
 0.15
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 03:33:33PM +0100, Javier Martin wrote:
> It is mainly a simple merge changing the prefix of some
> functions to fit the imx-dma namings.
> 
> As there are no users of the old dma-v1.c api we can safely
> remove this file.
> 
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> ---
> @@ -633,11 +1127,8 @@ static int __exit imxdma_remove(struct platform_device *pdev)
>  
>          dma_async_device_unregister(&imxdma->dma_device);
>  
> -	for (i = 0; i < MAX_DMA_CHANNELS; i++) {
> -		struct imxdma_channel *imxdmac = &imxdma->channel[i];
> -
> -		 imx_dma_free(imxdmac->imxdma_channel);
> -	}
> +	for (i = 0; i < MAX_DMA_CHANNELS; i++)
> +		free_irq(MX2x_INT_DMACH0 + i, NULL);

This lacks a test for i.MX1/21/27. The above is correct for i.MX21/27,
but on i.MX1 you have to free MX1_DMA_INT/MX1_DMA_ERR.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
