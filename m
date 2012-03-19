Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161141Ab2CSOqA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 10:46:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58778 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161032Ab2CSOp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 10:45:58 -0400
Date: Mon, 19 Mar 2012 15:45:45 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@intel.com>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org,
        "'Jassi Brar'" <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to __dma_request_channel()
In-Reply-To: <1332166938.7180.38.camel@vkoul-udesk3>
Message-ID: <Pine.LNX.4.64.1203191524200.11516@axis700.grange>
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
  <Pine.LNX.4.64.1203191502170.11516@axis700.grange> <1332166938.7180.38.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:qNBl64YBrp5r+aF1YapjvuLH4m0+iCB7lX/YfPbtEAR
 qT9ZfdY2M6IyNimhoVRhA9RY2319HfKwC+pNAb6trk4vK+zPd6
 Ftwr0e4Z8Tk/ybNZ7r3yg1MJvQBShtmU60M+BLwNS4QXgZN+B0
 S9W4NByxHRROgMlfaWfv79PusGkzfaTT9DlFlbVK0kOeclSo17
 SWsw6qMLdLYKOjBTV+p+QFWa3bLwAKOrYLp2rtHa15FjMbiGdu
 bRqpfPkyPlj2x1VjWxrX3aEbKA32KkQNW8y9+Dlj3reyulJdW0
 JwhTQZw2tZD6w4SmhiJ0/MouGLzIIpE7KOC3hBxEL31Hu+ESRW
 jOX3DBGQjT3AHeXnSdRPJCMcxD1u5x2vsP38uIDl/y7VMJdf36
 FCrK8kF+l16Bw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2012, Vinod Koul wrote:

> On Mon, 2012-03-19 at 15:09 +0100, Guennadi Liakhovetski wrote:
> > YES! This is exactly what I am talking about! We need an additional 
> > parameter to dma_request_channel(). Whereas in the discussion, that you 
> > pointed me to, it still had the same 3 parameters, as now. (Maybe this has 
> > already been decided upon before - to add an additional parameter, not 
> > sure anymore, this thread has become too long and too slow... My apologies 
> > in this case) So, this can be a device pointer or some specialised slave 
> > ID. Device pointer is nice, I agree. And the next change, that I'd like to 
> > request is pass this parameter further on to DMA device driver's 
> > .device_alloc_chan_resources() method. 
> Sorry my bad. I confused your request for additional parameter as
> request for adding slave_config etc stuff into request API.
> 
> Yes this API would need to be modified for telling dmaengine about
> client. Now Given that this is more slave stuff, I have leaning to
> adding a slave specific request api, something like
> dmaengine_request_slave_channel() which is used for our purpose while
> keeping the original API intact for async_tx usages.
> 
> Btw why should .device_alloc_chan_resources() need this, I so no reason,
> unless we are working around some other issue.

The reason is the following: with the proposed modifications to the 
existing API we want to achieve:

1. client requests a channel
	dmaengine_request_slave_channel(dev)
2. the core looks through platform-specific mapping tables and finds a 
   suitable channel
3. the core calls device driver's .device_alloc_chan_resources() method 
   for that channel
4. the client uses
	dmaengine_slave_config(chan, config)
   to configure the channel

Now, that last channel configuration can have two aspects: (1) static: 
routing, multiplexing, peripheral address. This needs to be set only once 
per each such channel allocation to a specific client, (2) (potentially) 
dynamic: any burst sizes etc. We can pass both these configuration types 
together to the DMA device driver at step 4. For that the slave would have 
to embed struct dma_slave_config into another hardware-specific type with 
additional routing parameters. Otherwise we could pass static 
configuration, supplied by the platform, from the client to the DMA device 
driver already at step 1. This way we would avoid having to embed struct 
dma_slave_config and pass it around even if the driver doesn't actually 
use it. In some cases step 4 would be then dropped completely. But I can 
live with either solution.

Another reason is, that in the future it can happen, that we get further 
restrictions on channel selection, that will not fit into the standard 
mapping scheme. In this case, having access to slave's identification, the 
DMA device driver will have another chance to check, whether the proposed 
channel is indeed suitable.

BTW, if we only pass a device pointer and return to the client channels 
one-by-one, how will the client know, which channel it just has got back - 
Tx or Rx? Will it have to try to configure it for each role and see, which 
one succeeds?...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
