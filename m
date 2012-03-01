Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030349Ab2CAKTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 05:19:19 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55036 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966042Ab2CAKTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 05:19:18 -0500
Date: Thu, 1 Mar 2012 11:19:05 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Javier Martin <javier.martin@vista-silicon.com>
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        vinod.koul@intel.com, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] dmaengine: Add support for multiple descriptors
 for imx-dma.
Message-ID: <20120301101904.GA3852@pengutronix.de>
References: <1330445298-3522-1-git-send-email-javier.martin@vista-silicon.com>
 <1330445298-3522-3-git-send-email-javier.martin@vista-silicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330445298-3522-3-git-send-email-javier.martin@vista-silicon.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:14:32 up 109 days, 18:01, 34 users,  load average: 0.00, 0.01,
 0.15
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 05:08:18PM +0100, Javier Martin wrote:
> dmaengine specifies the possibility that several descriptors
> can be queued for transfer. It also indicates that tasklets
> must be used for DMA callbacks.
> 
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>

Have you tested this patch with audio?


> +static int imxdma_xfer_desc(struct imxdma_desc *d)
> +{
> +	struct imxdma_channel *imxdmac = to_imxdma_chan(d->desc.chan);
> +	int ret;
> +
> +	/* Configure and enable */
> +	switch (d->type) {
> +	case IMXDMA_DESC_MEMCPY:
> +		ret = imx_dma_config_channel(imxdmac->imxdma_channel,
> +					  d->config_port, d->config_mem, 0, 0);
> +		if (ret < 0)
> +			return ret;
> +		ret = imx_dma_setup_single(imxdmac->imxdma_channel, d->src,
> +					   d->len, d->dest, d->dmamode);
> +		if (ret < 0)
> +			return ret;
> +		break;
> +	case IMXDMA_DESC_CYCLIC:
> +		ret = imx_dma_setup_progression_handler(imxdmac->imxdma_channel,
> +							imxdma_progression);
> +		if (ret < 0)
> +			return ret;

You fall through here. Is this intended? If yes, a comment would be good
here.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
