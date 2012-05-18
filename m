Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762571Ab2ERIVq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 04:21:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57597 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932281Ab2ERIVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 04:21:37 -0400
Date: Fri, 18 May 2012 10:21:32 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vkoul@infradead.org>
cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 5/9 v3] serial: sh-sci: prepare for conversion to the
 shdma base library
In-Reply-To: <1337056029.16185.5363.camel@vkoul-udesk3>
Message-ID: <Pine.LNX.4.64.1205181018570.23140@axis700.grange>
References: <1336576161-27082-1-git-send-email-g.liakhovetski@gmx.de> 
 <1336576161-27082-6-git-send-email-g.liakhovetski@gmx.de>
 <1337056029.16185.5363.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:7QvlDkixm4M4U6+jYx740cQNumCs+REQinXTE2Ueqiz
 wD1oRUSRQ0aC1324vsfJ3+cargMKFJVIlQm0w8s/6eUAPnk3a+
 aGqadmmV/NglO+g7CK1scuj04Icwh4zRUNGbUJxl/OMtNQsdwr
 g8KYyvb0vByCxDjURmY8RuziCDWZ2Wa+EgQsiN5CjuWjRMsIWB
 6HOCckkc1itksqitgXsOJWXspV2nqNMF225Gc8N3rCxXtyZiZu
 FwvA5Q2kRnWNrVA0iB+EhLVocQQAh7ZG8Vl0AF55sPlUdOSuly
 9OMmtFAwLT8+F1237FgduNfhKW2X/JyWG24q0LYQ4nAXdDMdPX
 pDluXCF/xS1Nqt1PGzBqqrqAefxMj4p0sBJx2Q3hS9t9HhRoA7
 kfXMqKfIZQV5w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2012, Vinod Koul wrote:

> On Wed, 2012-05-09 at 17:09 +0200, Guennadi Liakhovetski wrote:
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > Cc: Alan Cox <alan@linux.intel.com>
> > ---
> >  drivers/tty/serial/sh-sci.c |    8 ++++----
> >  1 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
> > index bf461cf..49e3b2a 100644
> > --- a/drivers/tty/serial/sh-sci.c
> > +++ b/drivers/tty/serial/sh-sci.c
> > @@ -1579,9 +1579,9 @@ static bool filter(struct dma_chan *chan, void *slave)
> >  	struct sh_dmae_slave *param = slave;
> >  
> >  	dev_dbg(chan->device->dev, "%s: slave ID %d\n", __func__,
> > -		param->slave_id);
> > +		param->shdma_slave.slave_id);
> >  
> > -	chan->private = param;
> > +	chan->private = &param->shdma_slave;
> passing stuff using chan->private is a dead road, so don't use it.

As you see, it _is_ already done now and has been that way since some 
time. We do want to change this, but not with this patch series.

> >  	return true;
> >  }
> >  
> > @@ -1620,7 +1620,7 @@ static void sci_request_dma(struct uart_port *port)
> >  	param = &s->param_tx;
> >  
> >  	/* Slave ID, e.g., SHDMA_SLAVE_SCIF0_TX */
> > -	param->slave_id = s->cfg->dma_slave_tx;
> > +	param->shdma_slave.slave_id = s->cfg->dma_slave_tx;
> >  
> >  	s->cookie_tx = -EINVAL;
> >  	chan = dma_request_channel(mask, filter, param);
> > @@ -1648,7 +1648,7 @@ static void sci_request_dma(struct uart_port *port)
> >  	param = &s->param_rx;
> >  
> >  	/* Slave ID, e.g., SHDMA_SLAVE_SCIF0_RX */
> > -	param->slave_id = s->cfg->dma_slave_rx;
> > +	param->shdma_slave.slave_id = s->cfg->dma_slave_rx;
> >  
> >  	chan = dma_request_channel(mask, filter, param);
> >  	dev_dbg(port->dev, "%s: RX: got channel %p\n", __func__, chan);

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
