Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716Ab2CSQcb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:32:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59685 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756619Ab2CSQc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:32:28 -0400
Date: Mon, 19 Mar 2012 17:32:20 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@linux.intel.com>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org,
        "'Jassi Brar'" <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to __dma_request_channel()
In-Reply-To: <1332174036.12110.15.camel@vkoul-udesk3>
Message-ID: <Pine.LNX.4.64.1203191722390.11516@axis700.grange>
References: <1331101687.24656.319.camel@vkoul-udesk3> 
 <Pine.LNX.4.64.1203070917380.19595@axis700.grange> 
 <20120307093026.GM17370@n2100.arm.linux.org.uk>  <Pine.LNX.4.64.1203071041030.19595@axis700.grange>
  <20120307103112.GP17370@n2100.arm.linux.org.uk> 
 <Pine.LNX.4.64.1203071149190.19595@axis700.grange> 
 <20120307124620.GT17370@n2100.arm.linux.org.uk>  <Pine.LNX.4.64.1203071416060.19595@axis700.grange>
  <20120307142634.GA18787@n2100.arm.linux.org.uk> 
 <Pine.LNX.4.64.1203071602330.19595@axis700.grange> 
 <20120307162755.GB18787@n2100.arm.linux.org.uk>  <Pine.LNX.4.64.1203071906040.19595@axis700.grange>
  <1331188201.4657.51.camel@vkoul-udesk3>  <Pine.LNX.4.64.1203080902170.29847@axis700.grange>
  <1331204128.4657.54.camel@vkoul-udesk3>  <Pine.LNX.4.64.1203081200170.29847@axis700.grange>
  <1331206459.4657.59.camel@vkoul-udesk3>  <1331211513.4657.67.camel@vkoul-udesk3>
  <Pine.LNX.4.64.1203081412550.29847@axis700.grange>  <1331284918.4657.69.camel@vkoul-udesk3>
  <Pine.LNX.4.64.1203091022200.7852@axis700.grange>  <1331285959.4657.76.camel@vkoul-udesk3>
  <Pine.LNX.4.64.1203091049060.7852@axis700.grange>  <1331520476.4657.79.camel@vkoul-udesk3>
  <Pine.LNX.4.64.1203161029490.13465@axis700.grange>  <1332157021.7180.5.camel@vkoul-udesk3>
  <Pine.LNX.4.64.1203191244240.11516@axis700.grange>  <1332164062.7180.19.camel@vkoul-udesk3>
  <Pine.LNX.4.64.1203191436030.11516@axis700.grange>  <1332165604.7180.24.camel@vkoul-udesk3>
  <Pine.LNX.4.64.1203191502170.11516@axis700.grange>  <1332166938.7180.38.camel@vkoul-udesk3>
  <Pine.LNX.4.64.1203191524200.11516@axis700.grange> <1332174036.12110.15.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:L57dCU39YTCUFeCrRTjjEOSCytW9TiNnFsHXG9dYrFR
 1zCk94upGFfUuNimGEkokSa7O501q6X5XCXpG+yPWsh+sVXXo/
 /gSEk4YF5el4lHxc0UPF2qdGzjmfkCS6rDlm9vq3d3lhf3gmFw
 bGO3qc3pqHCo/JjIO1+e9vVkDnWxFeh1UINYZ+a5BxzwKbtp7A
 vJLKErTsCN7KZMcqx4SG29+ymM+A0+Wdnj99sMmAMEEBkN5YUy
 9HjsUQOjVo9pnG2AogjOban68DmPEBKPWd8Ac2N1f09u+oRdOs
 PrUg1qYj9ZWFDBjtZ2cBp4nnkzk+Y4kDPXNBQS/ulzbHLeoB1n
 QkV3mwiSo6NC1ZYymnpsa0oPiJUhcFZKAxZJEmi5boaFWebJ7/
 4ZUfK9Q68sFdw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2012, Vinod Koul wrote:

> On Mon, 2012-03-19 at 15:45 +0100, Guennadi Liakhovetski wrote:
> > > Btw why should .device_alloc_chan_resources() need this, I so no reason,
> > > unless we are working around some other issue.
> > 
> > The reason is the following: with the proposed modifications to the 
> > existing API we want to achieve:
> > 
> > 1. client requests a channel
> > 	dmaengine_request_slave_channel(dev)
> > 2. the core looks through platform-specific mapping tables and finds a 
> >    suitable channel
> > 3. the core calls device driver's .device_alloc_chan_resources() method 
> >    for that channel
> > 4. the client uses
> > 	dmaengine_slave_config(chan, config)
> >    to configure the channel
> > 
> > Now, that last channel configuration can have two aspects: (1) static: 
> > routing, multiplexing, peripheral address. This needs to be set only once 
> > per each such channel allocation to a specific client,
> correct
> 
> >  (2) (potentially) 
> > dynamic: any burst sizes etc.
> I dont think burst-size would be dynamic, are they on sh- ?

Not atm, I just thought some other platforms / clients wanted to configure 
it dynamically. I may be wrong, though.

> >  We can pass both these configuration types 
> > together to the DMA device driver at step 4. For that the slave would have 
> > to embed struct dma_slave_config into another hardware-specific type with 
> > additional routing parameters.
> I think most of generic parameters are already there. As long as you
> dont have abnormal controller current dma_slave_config should suffice.
> Again, if you have specific need pls let us know, this structure can &
> should be expanded if dmacs needs something for slave configuration.

Sure. In the datasheet we have: to configure a channel for client 1 write 
value X to register A and value Y to register B. That's it. One of them is 
really just a magic slave ID. Another one has several fields with values 
like bus width and transfer size. They could be passed "properly," but 
since those fields also vary between DMAC versions, it is easier to just 
fix the whole register value per client and pass it from the platform 
data. In any case, at least the slave ID is really just a constant, that 
cannot be calculated and has to be passed from platform data.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
