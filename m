Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab1IEPB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 11:01:59 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52615 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab1IEPB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 11:01:56 -0400
Date: Mon, 5 Sep 2011 17:01:41 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@linux.intel.com>
cc: Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Magnus Damm <damm@opensource.se>
Subject: Re: [PATCH] serial: sh-sci: don't filter on DMA device, use only
 channel ID
In-Reply-To: <1315233788.26251.163.camel@vkoul-udesk3>
Message-ID: <Pine.LNX.4.64.1109051700030.1112@axis700.grange>
References: <Pine.LNX.4.64.1106241354060.6014@axis700.grange> 
 <1308916071.1536.4.camel@vkoul-udesk3>  <20110829080047.GJ31809@linux-sh.org>
  <CANqRtoRn-Csu+Rns6dn6=cJmRqbZfLKXA9brs8Ug9rFvGRn78w@mail.gmail.com> 
 <1314618931.1606.114.camel@vkoul-udesk3>  <Pine.LNX.4.64.1108300931220.19151@axis700.grange>
  <1314698522.1606.164.camel@vkoul-udesk3>  <Pine.LNX.4.64.1108301317280.19151@axis700.grange>
  <1314703426.1606.167.camel@vkoul-udesk3>  <Pine.LNX.4.64.1108301332190.19151@axis700.grange>
  <Pine.LNX.4.64.1109051002400.1112@axis700.grange>  <1315228408.26251.75.camel@vkoul-udesk3>
  <Pine.LNX.4.64.1109051532220.1112@axis700.grange> <1315233788.26251.163.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:nvC+Q1Sa2PweybGbYI6bEzZR6O7+f4mlm/fwXIKjrXe
 QVHy5XKPexLd/yBWHBPsFimlvsSE8f6k96QphTWRrn/RWi0znw
 nEZU5ng+ok9WWbPDfaxTrOeM0f9vlNkkNwbe2rC9JRbvFdj6w8
 luPdYESQzsuafdAEAS4cKkpyHn9ZW1XEAM1FX7kPXF+o2GKDgI
 yA4UvtDM96sZO7XGO1kyy6giczCwKqHFgbSqnTHfdoCtbfO+W1
 Ht2KkZ6j/l4YH7KazvLvFqzPs6cutMw2dkcXPIbysTQxV6aze1
 60tQwXAMGW87cwvNJE4bVjHgLUmrkjZJI7mlWCgjrqL8VbLlmT
 qtUj6TR3uVGKqV1F01z5VPEW9/gYiJ+dHCIQsk97yYT/hL5g/2
 KOO2lNOXyA45g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Sep 2011, Vinod Koul wrote:

> On Mon, 2011-09-05 at 15:48 +0200, Guennadi Liakhovetski wrote:
> > 
> > Let me try again. DMA channels on these DMA controllers are not dedicated. 
> > On one such SoC there can be several such DMA controllers of different 
> > kinds. One kind is "generic" - it can do memcpy(), besides channels can be 
> > freely configured for one of onboard peripherals: serial, mmc, etc. Some 
> > of them can also serve external DMA-capable devices. Another kind of DMA 
> > controllers, served by the same driver, can only be used with USB 
> > controllers. Now, if the MMC driver requests a DMA channel, let's say, the 
> > dmaengine core first finds the USB DMA controller. The MMC driver cannot 
> > know this. It assigns its MMC DMA configuration to the.private pointer and 
> > returns true. Next the DMA driver is entered, it checks the private 
> > pointer, sees an MMC channel request, looks at the DMA controller and 
> > sees, that it doesn't support MMC. So, .device_alloc_chan_resources() 
> > fails. When the same is attempted with a suitable DMA controller, the 
> > shdma driver recognises, that the controller can service MMC and uses the 
> > data, provided the MMC driver, to configure the DMA channel for MMC.
> Hmmm, Can't you know in filter function if the respective channel can do
> the dma for you or not? Maybe export a dma function or use platform data
> for this (wont you soc have these caps fixed), i prefer latter.
> That maybe a better approach. 

How? On a system you can have 3 suitable DMA controllers and 2 unsuitable. 
Do you want to pass a list of 3 suitable DMA controllers to each 
peripheral driver?...

> Once you have been allocated it should normally work, additional
> filtering confuses :(

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
