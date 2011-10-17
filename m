Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab1JQVIH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 17:08:07 -0400
Received: from mxout1.idt.com ([157.165.5.25]:46002 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754099Ab1JQVIE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 17:08:04 -0400
x-mimeole: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCHv4] DMAEngine: Define interleaved transfer request api
Date: Mon, 17 Oct 2011 14:07:31 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E552023220AC@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <CAJe_ZhfTg17YgyQ9TuKdhtXMu+8W_E2t3cBqZybfarxWu9Zasg@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCHv4] DMAEngine: Define interleaved transfer request api
Thread-Index: AcyNAyo/g/cXrS03SUy80vnnzI7YGwABC+5g
References: <1317191992-3635-1-git-send-email-jaswinder.singh@linaro.org><1317200618.1573.1765.camel@vkoul-udesk3><CAJe_ZhfDk7O_O7LDh7GrpcaPMzQuzs9nBA8BeN0VxG8_Oe93wg@mail.gmail.com><1317295068.1573.1780.camel@vkoul-udesk3><CAGsJ_4y+ageAqg1DQtQJ-g2j6im_e3KdvkcBaDFLz8fUniJpuA@mail.gmail.com><CAJe_ZhfyTBgH7wqB1HWtkjDNusecTOTZrqyYKF=Lwb9xQAXA3w@mail.gmail.com><CAGsJ_4x=F41Fbsw9gB3y=Vzyhf8a9yXB=sd6xbxSNUbTAYdjOA@mail.gmail.com><CAJe_Zhd86uqhzRHaA8ci2GHQgz6TadPR5hTuuUKqCWOFJwn6qg@mail.gmail.com><CAGsJ_4zOUFUkGv_-BB5sqjVZF1gBe-MVJS3Vxmi9Jo4sqYCLAg@mail.gmail.com><CAJe_Zhc8zdZzse+jutYERec5bKBPqWmq9v0xYrou0x1BSKyCLQ@mail.gmail.com><20111003161349.GB28287@flint.arm.linux.org.uk><CAJe_ZhfS=4vSS0OiSuNx3S+fW8R4-=khrHtt8suLeHjTFYBVeA@mail.gmail.com><CABE8wwsQKF9eTTU_N305hR=G5qW4Rzb7Lo-nHbc9RVYwSJVSVA@mail.gmail.com><1317966346.1573.2252.camel@vkoul-udesk3><CAJe_ZhdFA641AzmEmYaz++iRNYQmrHDFmAWOkrwmR_h2ie176g@mail.gmail.com><CABE8wwtcO_su0cF6YocVjAYKhUb=TTwqttfaZkC+RWGLKJimdQ@mail.gmail.com><CAJe_Z
	heocjVhD4PTX
	Qo3R7rqgiyt4BCo8Fx_sJ7AmDCjB=zMxQ@mail.gmail.com><0CE8B6BE3C4AD74AB97D9D29BD24E55202321E20@CORPEXCH1.na.ads.idt.com><CAJe_ZhfWcUY2ctUFt0iUf2FOfjKj1Aa8hQH5LqFG+bZ+93CcNQ@mail.gmail.com><0CE8B6BE3C4AD74AB97D9D29BD24E55202321F65@CORPEXCH1.na.ads.idt.com> <CAJe_ZhfTg17YgyQ9TuKdhtXMu+8W_E2t3cBqZybfarxWu9Zasg@mail.gmail.com>
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

On Mon, Oct 17, 2011 at 3:30 PM, Jassi Brar <jaswinder.singh@linaro.org>
wrote:
... skip ...
> > This is a source of the problem for RIO - DMA controller driver
> creates
> > virtual channels statically. RapidIO may use 8- or 16-bit destID.
> > In this case we need to create 256 or 64K virtual channels if we
> > want to cover all possible targets on single RIO port. Adding an
> extra
> > controller/net multiplies that number. Considering that not every
> > device will need a data transfer from a given node static allocation
> > will
> > create even more wasted resources.
> >
> Please excuse my rudimentary knowledge of RapidIO but I am tempted
> to ask why not register channels only for those targets that are
> actually
> detected and enumerated?
> 
Two reasons:
- possibility of hot device insertion/removal
- there is no advance knowledge of which target device may require DMA
  service. A device driver for the particular target device is expected
  to request DMA service if required.

> >>
> >> 1) The role of the 'extra' 2bits ?
> >>
> > Just upper bits of the RIO address.
> >
> I assume you mean any transfer could be targeted at any of 2^66 bits
> on the remote device.
Yes, this is correct. 

> 
> > There is nothing that absence of full 66-bit addressing blocks now.
> > So far we are not aware about implementations that use 66-bit
> address.
> >
> Thanks for the important info.
> If I were you, I would postpone enabling support for 66-bit addressing
> esp when it soo affects the dmaengine API.
> Otherwise, you don't just code unused feature, but also put
constraints
> on development/up-gradation of the API in future, possibly, nearer
than
> real need of the feature.
> 
> If we postpone 66-bit addressing to when it arrives, we can
> 1) Attach destID to the virtual channel's identity
> 2) Use device_prep_dma_memcpy so as to be able to change
>     target address for every transfer. Or use prep_slave, depending
>     upon nature of address at target endpoint.
> 3) Use slave_config to set wr_type if it remains same for enough
>     consecutive transfers to the same target (only you could strike
>     the balance between idealism and pragmatism).
> 
With item #1 above being a separate topic, I may have a problem with #2
as well: dma_addr_t is sized for the local platform and not guaranteed
to be a 64-bit value (which may be required by a target).
Agree with #3 (if #1 and #2 work).  

> > This does not prevent someone from designing RIO compliant endpoint
> > device which gives interpretation to these two bits in addition to
> full 64-bit
> > addressing of their platform.
> >
> It sounds as if the 2bits are 'Vendor-Specific' ?
> 
They are not 'Vendor-Specific' in the RIO spec (just address),
but HW vendors may give them such meaning. I just wanted to say
that HW designers may follow the same logic as we do here and
decide to give those bits a special meaning because "no one uses
them". They are expecting from RapidIO fabric to pass 66-bit
address and have right to do this. Tsi721 is capable to generate
66-bit address for RIO requests.

So far this is a theoretical possibility and we are not
aware about any designs of this type. We may put a big warning
note about 64-bit limitation in RapidIO documentation section.

I have 64-bit only support in Tsi721 DMA driver because my priority
is defining right upper layer interface to DMA Engine.
I published tsi721 DMA driver mostly as supporting example to
demonstrate what we are doing at RapidIO layer.
After the upper layer is defined it should not be a problem to
switch to 66-bit or just keep 64.

> >> We should try our best to avoid opening the can of worms by adding
> >> (void *) hook to each transfer, because any client driver could
want
> > to
> >> pass its own private data to dmac and there would be no way for a
> dmac
> >> driver to know what to cast the void pointer to.
> >
> > Do we really expect that clients will jump to use an extra parameter
> > without a valid reason and without knowing their hardware specifics?
> >
> The long term plan for dmaengine is to be able to have client drivers
> shared across dmac drivers. And that requires clients making no
> assumptions about the underlying dmac and the dmac driver expecting
> nothing from client via outside of common APIs.
In this case adding new values to dma_transaction_type (like
DMA_RAPIDIO)
may have a sense when using unified prep_slave_sg() with extra
parameter.
This will hide RapidIO dmac drivers from DMA_SLAVE clients (and vice
versa)
while keeping common APIs from growing in their numbers.

Alex.
 
