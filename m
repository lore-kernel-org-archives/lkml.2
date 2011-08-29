Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab1H2IBJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 04:01:09 -0400
Received: from linux-sh.org ([111.68.239.195]:38352 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026Ab1H2IBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 04:01:00 -0400
Date: Mon, 29 Aug 2011 17:00:47 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Magnus Damm <damm@opensource.se>
Subject: Re: [PATCH] serial: sh-sci: don't filter on DMA device, use only channel ID
Message-ID: <20110829080047.GJ31809@linux-sh.org>
References: <Pine.LNX.4.64.1106241354060.6014@axis700.grange> <1308916071.1536.4.camel@vkoul-udesk3>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308916071.1536.4.camel@vkoul-udesk3>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 24, 2011 at 05:17:51PM +0530, Koul, Vinod wrote:
> On Fri, 2011-06-24 at 13:56 +0200, Guennadi Liakhovetski wrote:
> > On some sh-mobile systems there are more than one DMA controllers, that
> > can be used for serial ports. Specifying a DMA device in sh-sci platform
> > data unnecessarily restricts the driver to only use one DMA controller.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> >  drivers/tty/serial/sh-sci.c |   25 ++++++++-----------------
> >  include/linux/serial_sci.h  |    2 --
> >  2 files changed, 8 insertions(+), 19 deletions(-)
> > 
> > diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
> > index ebd8629..8711f4e 100644
> > --- a/drivers/tty/serial/sh-sci.c
> > +++ b/drivers/tty/serial/sh-sci.c
> > @@ -1295,12 +1295,8 @@ static bool filter(struct dma_chan *chan, void *slave)
> >  	dev_dbg(chan->device->dev, "%s: slave ID %d\n", __func__,
> >  		param->slave_id);
> >  
> > -	if (param->dma_dev == chan->device->dev) {
> > -		chan->private = param;
> > -		return true;
> > -	} else {
> > -		return false;
> > -	}
> > +	chan->private = param;
> > +	return true;
> You should not assign chan->private. 
> Please move this  to dma_slave_control API

I haven't seen any reply to this comment and this patch seems to still be
outstanding, is there an updated version of this patch that I've missed?
