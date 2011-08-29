Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab1H2L4t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 07:56:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:55614 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753529Ab1H2L4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 07:56:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,296,1312182000"; 
   d="scan'208";a="46052607"
Subject: Re: [PATCH] serial: sh-sci: don't filter on DMA device, use only
 channel ID
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Magnus Damm <damm@opensource.se>
In-Reply-To: <CANqRtoRn-Csu+Rns6dn6=cJmRqbZfLKXA9brs8Ug9rFvGRn78w@mail.gmail.com>
References: <Pine.LNX.4.64.1106241354060.6014@axis700.grange>
	 <1308916071.1536.4.camel@vkoul-udesk3>
	 <20110829080047.GJ31809@linux-sh.org>
	 <CANqRtoRn-Csu+Rns6dn6=cJmRqbZfLKXA9brs8Ug9rFvGRn78w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Aug 2011 17:25:31 +0530
Message-ID: <1314618931.1606.114.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-29 at 17:16 +0900, Magnus Damm wrote:
> On Mon, Aug 29, 2011 at 5:00 PM, Paul Mundt <lethal@linux-sh.org> wrote:
> > On Fri, Jun 24, 2011 at 05:17:51PM +0530, Koul, Vinod wrote:
> >> On Fri, 2011-06-24 at 13:56 +0200, Guennadi Liakhovetski wrote:
> >> > On some sh-mobile systems there are more than one DMA controllers, that
> >> > can be used for serial ports. Specifying a DMA device in sh-sci platform
> >> > data unnecessarily restricts the driver to only use one DMA controller.
> >> >
> >> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> >> > ---
> >> >  drivers/tty/serial/sh-sci.c |   25 ++++++++-----------------
> >> >  include/linux/serial_sci.h  |    2 --
> >> >  2 files changed, 8 insertions(+), 19 deletions(-)
> >> >
> >> > diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
> >> > index ebd8629..8711f4e 100644
> >> > --- a/drivers/tty/serial/sh-sci.c
> >> > +++ b/drivers/tty/serial/sh-sci.c
> >> > @@ -1295,12 +1295,8 @@ static bool filter(struct dma_chan *chan, void *slave)
> >> >     dev_dbg(chan->device->dev, "%s: slave ID %d\n", __func__,
> >> >             param->slave_id);
> >> >
> >> > -   if (param->dma_dev == chan->device->dev) {
> >> > -           chan->private = param;
> >> > -           return true;
> >> > -   } else {
> >> > -           return false;
> >> > -   }
> >> > +   chan->private = param;
> >> > +   return true;
> >> You should not assign chan->private.
> >> Please move this  to dma_slave_control API
> >
> > I haven't seen any reply to this comment and this patch seems to still be
> > outstanding, is there an updated version of this patch that I've missed?
I don't recall seeing any updated version fixing this 

--
~Vinod
> This patch is simply making the SCIF driver behave as other drivers
> that support DMA Engine like for instance:
> MMCIF - drivers/mmc/host/sh_mmcif.c
> SDHI - drivers/mmc/host/tmio_mmc_dma.c
> USBHS - drivers/usb/renesas_usbhs/fifo.c
> 
> The SIU driver is still acting like the SCIF driver though:
> SIU - sound/soc/sh/siu_pcm.c
> 
> If possible I would prefer if the drivers for the SCIF and the SIU
> first could be cleaned up to behave like MMCIF/SDHI/USBHS and then we
> can move to make use of the dma_slave_control API after that.
> 
> Any thoughs?
> 
> Thanks,
> 
> / magnus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



