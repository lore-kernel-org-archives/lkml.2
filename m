Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188Ab0JTGfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 02:35:50 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34747 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757787Ab0JTGft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 02:35:49 -0400
Date: Wed, 20 Oct 2010 08:35:42 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Vasiliy Kulikov <segooon@gmail.com>, kernel-janitors@vger.kernel.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dma: imx-dma: fix signedness bug
Message-ID: <20101020063542.GD28242@pengutronix.de>
References: <1287327110-9158-1-git-send-email-segooon@gmail.com> <AANLkTik15Z2_wyDRDOHOnpKKPgb+PHWs477esndgWmex@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTik15Z2_wyDRDOHOnpKKPgb+PHWs477esndgWmex@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:33:18 up 108 days, 21:44, 21 users,  load average: 0.21, 1.06,
	0.90
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 03:26:05PM -0700, Dan Williams wrote:
> On Sun, Oct 17, 2010 at 7:51 AM, Vasiliy Kulikov <segooon@gmail.com> wrote:
> > mxdmac->channel was unsigned, so check (imxdmac->channel < 0) for
> > failed imx_dma_request_by_prio() made no sence.  Explicitly check
> > signed values.
> >
> > Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> > ---
> >  drivers/dma/imx-dma.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
> > index 346be62..75d870f 100644
> > --- a/drivers/dma/imx-dma.c
> > +++ b/drivers/dma/imx-dma.c
> > @@ -335,7 +335,7 @@ static int __init imxdma_probe(struct platform_device *pdev)
> >
> >                imxdmac->imxdma_channel = imx_dma_request_by_prio("dmaengine",
> >                                DMA_PRIO_MEDIUM);
> > -               if (imxdmac->channel < 0)
> > +               if ((int)imxdmac->channel < 0)
> >                        goto err_init;
> 
> Should this be:
> 
>                if ((int)imxdmac->channel < 0) {
>                        ret = -ENODEV;
>                        goto err_init;
>                }
> 
> ...because I get the following in my compilation tests.

Yes, ret is clearly used uninitialized. I wonder why my gcc-4.3.2 compiler
does not warn me about this :(

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
