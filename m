Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab2CIMUW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 07:20:22 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:58597 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337Ab2CIMUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 07:20:21 -0500
Date: Fri, 9 Mar 2012 13:20:08 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@intel.com>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org,
        "'Jassi Brar'" <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to __dma_request_channel()
In-Reply-To: <1331285959.4657.76.camel@vkoul-udesk3>
Message-ID: <Pine.LNX.4.64.1203091049060.7852@axis700.grange>
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
  <Pine.LNX.4.64.1203091022200.7852@axis700.grange> <1331285959.4657.76.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:5qnG7YMallcffQnXrOY/nXFXxPqyikcBLcqVCdIU0wf
 WNqMDovCQcwPTUWIiuC9CHMVp2tU2g2GOnc2p1RZ4GHSMakQTA
 jTfzePC6bWzS/p5iVHtCy8IW5W8E9MV4iFY/f5u/8rRsNmPsni
 1KN7nL8SHnFMfkSsaaBemA21krBOT8Jm7s31qHKMRsK2eMRZOO
 d5mccZX89u3gz6lfZpYqAzOGc5HSlBCVIuaL1BbfAyg3GO6BsD
 KDdwl4CxuVUmoDRm61J8oz1KRu4h+VLs48b+naohyzmKYkIuSS
 fRl9JOFk+ZLtZ0wjEiFeSl+7HDwHB0CAVuJu6OdhH1jEJugZ8C
 vobqi8j8bjxaHdDCymZMtUoLVbKN9hvhztoYhaZujell5krz+l
 v0eBNw75fnu0A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2012, Vinod Koul wrote:

> On Fri, 2012-03-09 at 10:24 +0100, Guennadi Liakhovetski wrote:
> > On Fri, 9 Mar 2012, Vinod Koul wrote:
> > 
> > > On Thu, 2012-03-08 at 14:18 +0100, Guennadi Liakhovetski wrote:
> > > > > Assuming I didn't miss...
> > > > > 
> > > > > The case B can be handled without sweat by platforms channel mapping
> > > > > information.
> > > > > 
> > > > > Case A where we don't find that devices exist in map, thus being treated
> > > > > as generic DMA channels and can be handled easily in sequence. So when
> > > > > someone in Q request a channel it would get first channel in Ps
> > > > > 
> > > > > This way we handle both of them in a transparent manner to both clients
> > > > > and controllers. 
> > > > > 
> > > > > Perhaps we can also add capability to know that if channel is to be
> > > > > searched in map or not - would be anyway required for non slave cases.
> > > > 
> > > > Right, but I don't understand then what this gives us. You propose some 
> > > > channel maps, that will not be used for your "case A." Which means, for 
> > > > "case A" nothing changes. So, the reason for this whole thread hasn't been 
> > > > addressed: how to pass channel configuration to the DMA controller driver.
> > > For "Case A" there should be no filtering or any issues even now. You
> > > have controller requesting a channel and as long as they get a channel
> > > for respective pool, it should work.
> > > 
> > > Or is there anything else which is required in this case?
> > 
> > Yes, there is. You keep complaining about my use of .priv pointer, which I 
> > use in the filter to pass channel configuration to the DMA controller 
> > driver. That is the original reason for this whole discussion. If you're 
> > fine with that, I'll just carry that .priv use over in the "simple" DMA 
> > engine driver and stay happy forever:-)
> Channel configuration != filtering & channel allocation
> 
> The discussion is focused on getting request_channel fixed so that we
> take care of oddities in respective platforms for channel maps which
> exist.
> What the heck does it have to on how you configure you channel??
> 
> Once you have channel allocated correctly which can work for you,

It can be made to work as long as there's only one DMAC group with 
configurable channels and all other DMACs are dedicated to specific 
peripherals, yes. I don't know whether there are already now or are 
approaching any platforms with multiple reconfigurable groups.

> you
> need to configure you channel. Since this is slave case you to tell what
> your client FIFO depth, burst size, width etc parameters. There is
> dma_slave_config for that purpose ONLY. Is there anything else required
> for _configuring_ if yes, we can add those. But then again that doesn't
> have anything to do with how you get a channel.

As Russell mentioned, struct dma_slave_config isn't suitable for channel 
configuration. Currently we use struct sh_dmae_slave_config to configure 
channels. As you can see, apart from the client's address, it also 
contains two fields with register values, that have to be used with this 
client. We could use dmaengine_slave_config() and embed struct 
dma_slave_config in our private type, but out of 7 fields of that struct 
effectively only one would be used, which makes this approach both clumsy 
and inefficient.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
