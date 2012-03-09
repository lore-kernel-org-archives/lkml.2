Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab2CIJfJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 04:35:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:43531 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014Ab2CIJfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 04:35:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="119354176"
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to
 __dma_request_channel()
From: Vinod Koul <vinod.koul@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org,
        "'Jassi Brar'" <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <Pine.LNX.4.64.1203091022200.7852@axis700.grange>
References: <1331101687.24656.319.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1203070917380.19595@axis700.grange>
	 <20120307093026.GM17370@n2100.arm.linux.org.uk>
	 <Pine.LNX.4.64.1203071041030.19595@axis700.grange>
	 <20120307103112.GP17370@n2100.arm.linux.org.uk>
	 <Pine.LNX.4.64.1203071149190.19595@axis700.grange>
	 <20120307124620.GT17370@n2100.arm.linux.org.uk>
	 <Pine.LNX.4.64.1203071416060.19595@axis700.grange>
	 <20120307142634.GA18787@n2100.arm.linux.org.uk>
	 <Pine.LNX.4.64.1203071602330.19595@axis700.grange>
	 <20120307162755.GB18787@n2100.arm.linux.org.uk>
	 <Pine.LNX.4.64.1203071906040.19595@axis700.grange>
	 <1331188201.4657.51.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1203080902170.29847@axis700.grange>
	 <1331204128.4657.54.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1203081200170.29847@axis700.grange>
	 <1331206459.4657.59.camel@vkoul-udesk3>
	 <1331211513.4657.67.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1203081412550.29847@axis700.grange>
	 <1331284918.4657.69.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1203091022200.7852@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Mar 2012 15:09:19 +0530
Message-ID: <1331285959.4657.76.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-09 at 10:24 +0100, Guennadi Liakhovetski wrote:
> On Fri, 9 Mar 2012, Vinod Koul wrote:
> 
> > On Thu, 2012-03-08 at 14:18 +0100, Guennadi Liakhovetski wrote:
> > > > Assuming I didn't miss...
> > > > 
> > > > The case B can be handled without sweat by platforms channel mapping
> > > > information.
> > > > 
> > > > Case A where we don't find that devices exist in map, thus being treated
> > > > as generic DMA channels and can be handled easily in sequence. So when
> > > > someone in Q request a channel it would get first channel in Ps
> > > > 
> > > > This way we handle both of them in a transparent manner to both clients
> > > > and controllers. 
> > > > 
> > > > Perhaps we can also add capability to know that if channel is to be
> > > > searched in map or not - would be anyway required for non slave cases.
> > > 
> > > Right, but I don't understand then what this gives us. You propose some 
> > > channel maps, that will not be used for your "case A." Which means, for 
> > > "case A" nothing changes. So, the reason for this whole thread hasn't been 
> > > addressed: how to pass channel configuration to the DMA controller driver.
> > For "Case A" there should be no filtering or any issues even now. You
> > have controller requesting a channel and as long as they get a channel
> > for respective pool, it should work.
> > 
> > Or is there anything else which is required in this case?
> 
> Yes, there is. You keep complaining about my use of .priv pointer, which I 
> use in the filter to pass channel configuration to the DMA controller 
> driver. That is the original reason for this whole discussion. If you're 
> fine with that, I'll just carry that .priv use over in the "simple" DMA 
> engine driver and stay happy forever:-)
Channel configuration != filtering & channel allocation

The discussion is focused on getting request_channel fixed so that we
take care of oddities in respective platforms for channel maps which
exist.
What the heck does it have to on how you configure you channel??

Once you have channel allocated correctly which can work for you, you
need to configure you channel. Since this is slave case you to tell what
your client FIFO depth, burst size, width etc parameters. There is
dma_slave_config for that purpose ONLY. Is there anything else required
for _configuring_ if yes, we can add those. But then again that doesn't
have anything to do with how you get a channel.


-- 
~Vinod

