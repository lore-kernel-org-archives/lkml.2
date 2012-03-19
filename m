Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030941Ab2CSOJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 10:09:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55370 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab2CSOJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 10:09:40 -0400
Date: Mon, 19 Mar 2012 15:09:37 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@intel.com>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org,
        "'Jassi Brar'" <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to __dma_request_channel()
In-Reply-To: <1332165604.7180.24.camel@vkoul-udesk3>
Message-ID: <Pine.LNX.4.64.1203191502170.11516@axis700.grange>
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
  <Pine.LNX.4.64.1203191436030.11516@axis700.grange> <1332165604.7180.24.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:SLWXG4KtVv2+trSQ2GDZMlqrNcXYLqg1zsha76yiwrF
 kQJonvAGIRWRF2Irj47CIkojrMHIJzgRqGrWsAWMdI6nb+lcKj
 z6h4vJgfQVcSmaQ7IBbJMwLci3xipXgPOI0LNDnbi/F6mTbaWn
 FSTdzkWWQDZnjHjSVidAvoORUY7DvMK/9HJa09AxoRtxqiwSCM
 dlrXypxmAYd24ogCHUeaYU2c/oqCI4j5YhEINT3jb6+okBiT9M
 TY4HqzwL4Iw1v39abR2CiXLhjCJnjdM5jAnyvJ/CCK0nKFPul1
 nkO8L76A+JCVtTYgzy1zGROFMIgHviU8vQXzpXBMQIocwOesx0
 hmrlzu/pahEjLTx7UNmKlp9RyJfqATB3dFHsYshSox4NFyxbPV
 lQefvFwEbKpJA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2012, Vinod Koul wrote:

> On Mon, 2012-03-19 at 14:38 +0100, Guennadi Liakhovetski wrote:
> > On Mon, 19 Mar 2012, Vinod Koul wrote:
> > 
> > > On Mon, 2012-03-19 at 12:47 +0100, Guennadi Liakhovetski wrote:
> > > > As I wrote in a reply to Linus W - you need to pass information about the 
> > > > requesting client to the dmaengine core to let it match it against mapping 
> > > > tables. 
> > > NO. 
> > > The client only needs to say that he needs a channel for DMA_SLAVE
> > 
> > How?
> Did you miss our earlier discussion on 

No, I did not.

> https://lkml.org/lkml/2012/3/8/26
> 
> Perhaps, I can enlighten you will below excerpt where we proposed to
> add:
> 
> int dmaengine_add_channel_map(struct dmaengine_map *map, unsigned int num_entries)
> {
> 	/* store this map into dmaengine and use for channle allocation */
> }
> 
> So dmaengine knows client A can use DMAC P, channel 2 and 3.

I understand this.

> So first request will receive ch 2 for A and second one will yield 3.
> 
> > 
> > 	dma_request_channel(mask, filter_fn, filter_arg)
> > 
> > Where shall the client pass to dmaengine its identity info?
> Only change I see for above to tell which client is requesting, so we
> may have to add device pointer of client while requesting.

YES! This is exactly what I am talking about! We need an additional 
parameter to dma_request_channel(). Whereas in the discussion, that you 
pointed me to, it still had the same 3 parameters, as now. (Maybe this has 
already been decided upon before - to add an additional parameter, not 
sure anymore, this thread has become too long and too slow... My apologies 
in this case) So, this can be a device pointer or some specialised slave 
ID. Device pointer is nice, I agree. And the next change, that I'd like to 
request is pass this parameter further on to DMA device driver's 
.device_alloc_chan_resources() method.

Thanks
Guennadi

> > 
> > > DMAengine will know for this client, the platform channel map (already
> > > given to it by platform) says that we can give it DMAC X, channel 4
> > > only.
> > 
> > Some clients need multiple channels - Tx, Rx,...
> > 
> > Thanks
> > Guennadi
> > 
> > > So see if it free, if so allocate it and give to client (while
> > > doing usual stuff)
> > > > You have to pass this information with the dma_request_channel() 
> > > > function. So, either you need to add a parameter or you have to reuse one 
> > > > of existing ones, e.g., deprecate the filter and use its argument for this 
> > > > purpose. If you do this and as long as you pass that parameter further on 
> > > > to the dmaengine device (controller) driver after whatever matching you 
> > > > like to do in the core - I'm fine with that, that fits well with my 
> > > > initial proposal.
> > > I don't care about filter, it can go away if it is not required.
> > > 
> > > Passing slave_config is *enhancement* so for (hopefully) last time
> > >  a) it has *nothing* to do with getting a channel, no role to play in
> > > generic scheme of things
> > >  b) it allows client to call one api for get+configure thats all! 
> > > 
> > > -- 
> > > ~Vinod
> > > 
> > 
> > ---
> > Guennadi Liakhovetski, Ph.D.
> > Freelance Open-Source Software Developer
> > http://www.open-technology.de/
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> -- 
> ~Vinod
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
