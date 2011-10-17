Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805Ab1JQSAv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 14:00:51 -0400
Received: from mxout1.idt.com ([157.165.5.25]:37843 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679Ab1JQSAu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 14:00:50 -0400
x-mimeole: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCHv4] DMAEngine: Define interleaved transfer request api
Date: Mon, 17 Oct 2011 11:00:06 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E55202321F65@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <CAJe_ZhfWcUY2ctUFt0iUf2FOfjKj1Aa8hQH5LqFG+bZ+93CcNQ@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCHv4] DMAEngine: Define interleaved transfer request api
Thread-Index: AcyM3+OlUvVtNJUlR0WUrp+F0lLz/AAA2wBw
References: <1317191992-3635-1-git-send-email-jaswinder.singh@linaro.org><1317200618.1573.1765.camel@vkoul-udesk3><CAJe_ZhfDk7O_O7LDh7GrpcaPMzQuzs9nBA8BeN0VxG8_Oe93wg@mail.gmail.com><1317295068.1573.1780.camel@vkoul-udesk3><CAGsJ_4y+ageAqg1DQtQJ-g2j6im_e3KdvkcBaDFLz8fUniJpuA@mail.gmail.com><CAJe_ZhfyTBgH7wqB1HWtkjDNusecTOTZrqyYKF=Lwb9xQAXA3w@mail.gmail.com><CAGsJ_4x=F41Fbsw9gB3y=Vzyhf8a9yXB=sd6xbxSNUbTAYdjOA@mail.gmail.com><CAJe_Zhd86uqhzRHaA8ci2GHQgz6TadPR5hTuuUKqCWOFJwn6qg@mail.gmail.com><CAGsJ_4zOUFUkGv_-BB5sqjVZF1gBe-MVJS3Vxmi9Jo4sqYCLAg@mail.gmail.com><CAJe_Zhc8zdZzse+jutYERec5bKBPqWmq9v0xYrou0x1BSKyCLQ@mail.gmail.com><20111003161349.GB28287@flint.arm.linux.org.uk><CAJe_ZhfS=4vSS0OiSuNx3S+fW8R4-=khrHtt8suLeHjTFYBVeA@mail.gmail.com><CABE8wwsQKF9eTTU_N305hR=G5qW4Rzb7Lo-nHbc9RVYwSJVSVA@mail.gmail.com><1317966346.1573.2252.camel@vkoul-udesk3><CAJe_ZhdFA641AzmEmYaz++iRNYQmrHDFmAWOkrwmR_h2ie176g@mail.gmail.com><CABE8wwtcO_su0cF6YocVjAYKhUb=TTwqttfaZkC+RWGLKJimdQ@mail.gmail.com><0CE8B6
	BE3C4AD74AB9
	7D9D29BD24E55202321C11@CORPEXCH1.na.ads.idt.com><CAJe_ZheocjVhD4PTXQo3R7rqgiyt4BCo8Fx_sJ7AmDCjB=zMxQ@mail.gmail.com><0CE8B6BE3C4AD74AB97D9D29BD24E55202321E20@CORPEXCH1.na.ads.idt.com> <CAJe_ZhfWcUY2ctUFt0iUf2FOfjKj1Aa8hQH5LqFG+bZ+93CcNQ@mail.gmail.com>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Jassi Brar <jaswinder.singh@linaro.org>
CC: "Williams, Dan J" <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Russell King <rmk@arm.linux.org.uk>,
        Barry Song <21cnbao@gmail.com>, <linux-kernel@vger.kernel.org>,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
        Dave Jiang <dave.jiang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 11:17 AM, Jassi Brar
<jaswinder.singh@linaro.org> wrote:
> 
> On 17 October 2011 19:37, Bounine, Alexandre
> <Alexandre.Bounine@idt.com> wrote:
> > On Sat, Oct 15, 2011 at 7:26 AM, Jassi Brar
> <jaswinder.singh@linaro.org>
> > wrote:
> >>
> >> On 15 October 2011 00:45, Bounine, Alexandre
> >> <Alexandre.Bounine@idt.com> wrote:
> >>
> >> >> But doesn't the info, pointed to by this (void *), remain same
> for
> >> >> every
> >> >> transfer to a particular target/remote device ?
> >> > No. An address within the target may (and most likely will) be
> > changed for
> >> > every transfer. Target destination ID will be the same for given
> > virtual channel.
> >> >
> >> Thanks for the info.
> >>
> >> > Virtual channel may bring the same challenge and I may need a
> > channel locking
> >> > if more than one requester try to read/write data to the same
> target
> > RIO device.
> >> >
> >> One can't avoid taking care of locking, but using virtual channels
> >> keeps the dma_chan usage consistent.
> >>
> > Using virtual channels adds layers of complexity
> Perhaps you didn't get me ... I suggest the dma controller driver
> (not client drivers) create virtual channels corresponding to each
> device it can talk to. A bunch of virtual channels could be served
> by a single appropriate physical channel.
> It is actually quite common, see amba-pl08x.c or pl330.c for example.
> 
This is a source of the problem for RIO - DMA controller driver creates
virtual channels statically. RapidIO may use 8- or 16-bit destID.
In this case we need to create 256 or 64K virtual channels if we
want to cover all possible targets on single RIO port. Adding an extra
controller/net multiplies that number. Considering that not every
device will need a data transfer from a given node static allocation
will
create even more wasted resources. 

> > which may be avoided with simple API changes:
> > - virtual channel allocation: statically vs. dynamically
> Yes, it would be cool but it's not possible right now.
> 
This is a reason for calling it "added complexity" we will need
to find some mechanism to do it dynamically at DMA or RIO layer.

> > - linking virtual channel to the physical one
> >
> Perhaps you mean what I suggested ?
> 
I mean linking dynamically allocated virtual channel to the physical
one.
Sorry for confusing statement. Ideally, in the virtual channel scenario
rio_request_dma() should dynamically allocate target-mapped virtual DMA
channel and link it to the appropriate physical DMA channel.  

> >
> >> RapidIO supports 34(32+2), 50(48+2) and 66(64+2) bit addressing
> >> which makes me wonder if the (upper or lower) 2 bits could be
> attached
> >> to
> >> the identity of the target device ?
> >> (tsi721 driver actually discards the upper 2 bits while claiming to
> >> support
> >> 66bit addressing so I couldn't make anything out of it and specs
> don't
> >> seem to say much about it)
> >>
> >> If there is no user of 66bit addressing and isn't coming in very
> near
> >> future,
> >> we might as well drop that case for now(tsi721 already does)
because
> >> that 'completeness' of support modifies the semantics of dmaengine
> > apis
> >> today for no real use.
> > This is marked to be fixed in tsi721 driver. Also, this is a local
> > deficiency
> > and changing it that does not affect other components of the RIO
> > subsystem.
> > Contrary to that, defining an upper layer affects all future
> development
> > and
> > may result in greater pain if it needs to be adjusted later.
> >
> I just wanted to know
> 
> 1) The role of the 'extra' 2bits ?
> 
Just upper bits of the RIO address.

> 2) Are there real use-cases that are blocked on this support right now
> ?
>     If there are indeed, do you think the transfer would be _randomly_
>    distributed over the 66-bit address space ? Because otherwise,
maybe
>    the upper 2 bits could be used to "activate" one of the 4
"segments"
>    using slave config call.
> 
There is nothing that absence of full 66-bit addressing blocks now.
So far we are not aware about implementations that use 66-bit address.
This does not prevent someone from designing RIO compliant endpoint
device
which gives interpretation to these two bits in addition to full 64-bit
addressing of their platform.

At this moment we may say that it is reasonable to lower an importance
of 66-bit
addressing but we should keep it in mind when considering all pros and
cons
of possible API changes. I discussed this with some members of RTA and
did not
hear any strong argument in favor of full 66-bit addressing support in
SW
at this moment.

> We should try our best to avoid opening the can of worms by adding
> (void *) hook to each transfer, because any client driver could want
to
> pass its own private data to dmac and there would be no way for a dmac
> driver to know what to cast the void pointer to.

Do we really expect that clients will jump to use an extra parameter
without a valid reason and without knowing their hardware specifics?

Alex.

