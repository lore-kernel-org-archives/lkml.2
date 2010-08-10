Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625Ab0HJMee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 08:34:34 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55724 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757552Ab0HJMe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 08:34:29 -0400
Date: Tue, 10 Aug 2010 14:34:26 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
        linux kernel <linux-kernel@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/8] ARM i.MX dma: implement wrapper for dma functions
Message-ID: <20100810123426.GH27749@pengutronix.de>
References: <1281344743-2029-1-git-send-email-s.hauer@pengutronix.de> <1281344743-2029-2-git-send-email-s.hauer@pengutronix.de> <AANLkTimtQrmrW-pNWX=0J9GMsGrS-5-LZKkxdHDSuSxW@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimtQrmrW-pNWX=0J9GMsGrS-5-LZKkxdHDSuSxW@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:23:52 up 38 days,  3:34, 29 users,  load average: 0.03, 0.12,
	0.33
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Tue, Aug 10, 2010 at 12:45:17AM +0200, Linus Walleij wrote:
> 2010/8/9 Sascha Hauer <s.hauer@pengutronix.de>:
> 
> > Currently there is only one i.MX DMA implementation in the tree,
> > the one for i.MX1/21/27. The SDMA support for i.MX25/31/35/51 can
> > be implemented similarly. This wrapper for the DMA is implemented
> > so that drivers do not have to care about the implementation
> > present and don't have to #ifdef DMA support
> >
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > (...)
> > +struct imx_dma_operations {
> > +       int (*config_channel)(int channel, struct imx_dma_config *cfg);
> > +       int (*setup_single)(int channel, dma_addr_t mem, int dma_length,
> > +               unsigned int dmamode);
> > +       int (*setup_sg)(int channel, struct scatterlist *sg,
> > +                       unsigned int sgcount, unsigned int dma_length,
> > +                       unsigned int dmamode);
> > +       void (*enable)(int channel);
> > +       void (*disable)(int channel);
> > +       int (*request)(enum imx_dma_prio);
> > +       void (*free)(int channel);
> > +       int num_channels;
> > +};
> 
> This is just getting *so* close to the drivers/dma dmaengine API.

I was afraid somewone would say this ;)

> 
> We decided to use the damengine for all our DMA drivers and we
> haven't regretted one bit.
> 
> There has been some noise about too many drivers stacking up
> below arch/arm instead of going to the apropriate subsystem, can't
> you atleast contemplate using the dmaengine and help us improve
> that subsystem?

The last time I looked into dmaengine I failed to see how this API
could help me. Looking at it again it seems that this is the way
to go. I will definitely have a closer look. I can't promise though that
this will be before the next merge window. The SDMA engine on the other
hand is of great value for the i.MX community, so if anyone is willing
to help here, please step forward.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
