Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031Ab0JEKGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 06:06:52 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53254 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445Ab0JEKGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 06:06:51 -0400
Date: Tue, 5 Oct 2010 12:06:49 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/4] dmaengine: Add Freescale i.MX1/21/27 DMA driver
Message-ID: <20101005100649.GL28242@pengutronix.de>
References: <1285854995-6569-1-git-send-email-s.hauer@pengutronix.de> <1285854995-6569-5-git-send-email-s.hauer@pengutronix.de> <AANLkTikaAuBe=ef3vnt_xV0At4ZQbNsD4rFqtLF4R+0+@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikaAuBe=ef3vnt_xV0At4ZQbNsD4rFqtLF4R+0+@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:05:17 up 94 days,  1:16, 27 users,  load average: 0.19, 0.27,
	0.28
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Javier,

On Tue, Oct 05, 2010 at 09:45:10AM +0200, javier Martin wrote:
> Hi Sascha,
> 
> 
> +
> > +struct imxdma_channel {
> > +       struct imxdma_engine            *imxdma;
> > +       unsigned int                    channel;
> > +       unsigned int                    imxdma_channel;
> > +
> > +       enum dma_data_direction         direction;
> > +       enum dma_slave_buswidth         word_size;
> > +       dma_addr_t                      bd_phys;
> > +       unsigned long                   flags;
> > +       dma_addr_t                      per_address;
> > +       u32                             watermark_level;
> > +       struct dma_chan                 chan;
> > +       spinlock_t                      lock;
> > +       struct dma_async_tx_descriptor  desc;
> > +       dma_cookie_t                    last_completed;
> > +       enum dma_status                 status;
> > +       int                             dma_request;
> > +       struct scatterlist              *sg_list;
> > +};
> > +
> > +#define MAX_DMA_CHANNELS 8
> >
> 
>  i.MX27 has 16 DMA channels. Maybe an #ifdef would solve the issue.

This is by intention. I want to reserve 8 channels for the old driver
and the remaining 8 for the dmaengine driver. This way we can have both
in the tree and use both drivers parallel. This can be changed to the
real value once the old driver is gone.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
