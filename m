Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab2C3Gkq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 02:40:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61209 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754915Ab2C3Gkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 02:40:39 -0400
Date: Fri, 30 Mar 2012 08:40:37 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Linus Walleij <linus.walleij@linaro.org>
cc: Vinod Koul <vinod.koul@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Jassi Brar <jassisinghbrar@gmail.com>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to __dma_request_channel()
In-Reply-To: <CACRpkdbp3EfF-4z2uuy+gLdXvHqUqj+Zmp-GZxhaHv_RxxRKHQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1203300822470.24548@axis700.grange>
References: <1331101687.24656.319.camel@vkoul-udesk3> <1331188201.4657.51.camel@vkoul-udesk3>
 <Pine.LNX.4.64.1203080902170.29847@axis700.grange> <1331204128.4657.54.camel@vkoul-udesk3>
 <Pine.LNX.4.64.1203081200170.29847@axis700.grange> <1331206459.4657.59.camel@vkoul-udesk3>
 <1331211513.4657.67.camel@vkoul-udesk3> <Pine.LNX.4.64.1203081412550.29847@axis700.grange>
 <1331284918.4657.69.camel@vkoul-udesk3> <Pine.LNX.4.64.1203091022200.7852@axis700.grange>
 <1331285959.4657.76.camel@vkoul-udesk3> <Pine.LNX.4.64.1203091049060.7852@axis700.grange>
 <1331520476.4657.79.camel@vkoul-udesk3> <Pine.LNX.4.64.1203161029490.13465@axis700.grange>
 <CACRpkdYiuERV08=UhBRnj2AjC_RxF+EY+zHAtEp6KYf2W10C_Q@mail.gmail.com>
 <Pine.LNX.4.64.1203161128120.13465@axis700.grange>
 <CACRpkdY7ApBc-gbSdf+=7PLtKSMvzYuBi7RNnVgi=vjcd-KvhQ@mail.gmail.com>
 <Pine.LNX.4.64.1203161522570.13465@axis700.grange>
 <CACRpkdbp3EfF-4z2uuy+gLdXvHqUqj+Zmp-GZxhaHv_RxxRKHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:iQ/oIMl4SsiBFqd5/70Gue5x2q/YflfUsHSp9bIJ7XH
 LeLU2CGzQIPFLDnPs8qZoGXpObjspQk9smMhbzdtZIOvGZ24Bz
 F6X3EmXTE9Hxlbayz4cc+LsQUaNurDt+DC5J43x47NlOYw9Vvt
 FPvPzMiUaKiUAt7SVH2+Vi0uuNrXqH0YiunLVD+I8f9AlRRmLN
 L3scJAyzijLqVP1yfniktu9T5OgVtcTCMIsmkMJCArus9fE01z
 zajiAY5+1u5Nfdkfw0k4iHAN8CNbXua81UN2PvVhCHjHnY+LyK
 HmP93GfjaA0R6Hgv/X1YpvbdYAzxCAGed6eH0fqA24c/0DRDf5
 /Ex8zqDqtqjh/7xJ18QAhB1oU7l3fnUXW4N/oeXOkXjbCfZk3F
 Zz8HUS/Dc3aAQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus

On Fri, 30 Mar 2012, Linus Walleij wrote:

> On Fri, Mar 16, 2012 at 3:28 PM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > On Fri, 16 Mar 2012, Linus Walleij wrote:
> 
> >> Oh I was not thinking of relying on config to sort out channels.
> >>
> >> I was thinking of internalizing the dma_filter_fn and make it an
> >> (optional, maybe?) part of dmaengine.
> >
> > Yessss!!! Let's do that! :-D Now, you're proposing exactly the same, as
> > what I was proposing! :-)
> 
> No.

Well, ok, not _exactly_, but in essence. Maybe I didn't explain my 
proposal well enough, so, the analogy is not that clear. My main 
requirement was: we need a way for DMA slaves to pass information about 
the required DMA channel to the dmaengine framework already with the 
request_channel() call, because just requesting _a_ channel and then 
looking at it and either accepting or rejecting it is not good enough. My 
proposal was more generic - pass an opaque parameter to be matched 
against. You are proposing a very specific channel description, but see 
more below.

> > Now you just have to remove the filter function
> > parameter from dma_request_channel() - it is anyway the same for all and
> > implemented in the dmaengine core - and you get
> >
> > dma_request_channel(mask, slave_desc)
> 
> What is the point of mask on slave channels?
> I was more thinking introduce a new call:
> 
> dma_request_slave_channel(struct device *dev);
> 
> >From this the core looks up a suitable channel for that device.
> 
> However you're right (in some later mail) that we need to distinguish
> between RX/TX channels at this point, so I can agree we need some
> additional parameter, but that should be very abstract, not containing
> any custom stuff or any void * or something like that.
> 
> If the device and direction is really all we need to distinguish a suitable
> channel (which I imagine) the signature may very well be:
> 
> dma_request_slave_channel(struct device *dev, enum dma_transfer_direction dir);
> 
> But I'm not sure. (Keep beating me about it... but at this point
> I think code speaks more than words.)

Ok, I looked through a datasheet of one of SoCs, that we're working with 
and most devices require no more than two channels. But then I hit a weird 
example: the sh7372 SoC has 3 SDHI (SD-card) controller instances. SDHI1 
and SDHI2 each can use 2 DMA channels - Tx and Rx, this is also what is 
currently used. However, SDHI0 has 4 (!) DMA channels listed for it in the 
datasheet: 2 Rx and 2 Tx. I have no idea whether it is a bug in the 
documentation (not very likely, this is later confirmed at a different 
location), or whether those channels are completely identical (what would 
be the point then???), or whether we'll ever support that in software (ATM 
we only use two of them), but - a precedent is there... So, we can either 
pretend, that we don't know about it or decide, that we'll never use it 
and go ahead with just device/direction, or we can make it more 
future-proof immediately. But, well, this is a kernel internal API, so, we 
can change it at any time in the future.

Thanks
Guennadi

> > which is exactly what I was proposing! :-)
> 
> Sorry, not at all AFAICT.
> 
> Yours,
> Linus Walleij
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
