Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab0IXHZ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 03:25:29 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42845 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab0IXHZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 03:25:28 -0400
Date: Fri, 24 Sep 2010 09:25:23 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.ml.walleij@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/3] dmaengine: add wrapper functions for dmaengine
Message-ID: <20100924072523.GM23406@pengutronix.de>
References: <1281956870-12463-1-git-send-email-s.hauer@pengutronix.de> <1281956870-12463-3-git-send-email-s.hauer@pengutronix.de> <AANLkTin8v_29HESnmhE5==3OLmb29bmoOY1iona4C+eD@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTin8v_29HESnmhE5==3OLmb29bmoOY1iona4C+eD@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:22:30 up 82 days, 22:33, 23 users,  load average: 0.46, 0.71,
	1.00
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On Thu, Sep 23, 2010 at 12:53:58PM -0700, Dan Williams wrote:
> > diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> > index 0df7864..635c60b 100644
> > --- a/include/linux/dmaengine.h
> > +++ b/include/linux/dmaengine.h
> > @@ -491,6 +491,47 @@ struct dma_device {
> >        void (*device_issue_pending)(struct dma_chan *chan);
> >  };
> >
> > +static inline int dmaengine_device_control(struct dma_chan *chan,
> > +                                          enum dma_ctrl_cmd cmd,
> > +                                          unsigned long arg)
> > +{
> > +       return chan->device->device_control(chan, cmd, arg);
> > +}
> > +
> > +static inline int dmaengine_slave_config(struct dma_chan *chan,
> > +                                         struct dma_slave_config *config)
> > +{
> > +       return dmaengine_device_control(chan, DMA_SLAVE_CONFIG,
> > +                       (unsigned long)config);
> > +}
> > +
> > +static inline int dmaengine_terminate_all(struct dma_chan *chan)
> > +{
> > +       return dmaengine_device_control(chan, DMA_TERMINATE_ALL, 0);
> > +}
> > +
> > +static inline struct dma_async_tx_descriptor *dmaengine_prep_slave_sg(
> > +               struct dma_chan *chan, struct scatterlist *sgl,
> > +               unsigned int sg_len, enum dma_data_direction direction,
> > +               unsigned long flags)
> > +{
> > +       return chan->device->device_prep_slave_sg(chan, sgl, sg_len, direction,
> > +                       flags);
> > +}
> > +
> > +static inline struct dma_async_tx_descriptor *dmaengine_prep_cyclic(
> > +               struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
> > +               size_t period_len, enum dma_data_direction direction)
> > +{
> > +       return chan->device->device_prep_dma_cyclic(chan, buf_addr, buf_len,
> > +                       period_len, direction);
> > +}
> > +
> 
> No strong disagreements on the above, the type safety of
> dmaengine_slave_config() is nice.

So you have only small disagreements? ;) I can drop the dmaengine_prep_*
functions and only keep the device_control functions if like it better.

> 
> > +static inline int dmaengine_tx_submit(struct dma_async_tx_descriptor *desc)
> > +{
> > +       return desc->tx_submit(desc);
> > +}
> 
> This one can drop the tx.

You mean the function should be named dmaengine_submit?

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
