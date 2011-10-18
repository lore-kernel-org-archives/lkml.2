Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab1JRPQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 11:16:50 -0400
Received: from mxout1.idt.com ([157.165.5.25]:60919 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237Ab1JRPQt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 11:16:49 -0400
x-mimeole: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCHv4] DMAEngine: Define interleaved transfer request api
Date: Tue, 18 Oct 2011 08:15:33 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E55202322257@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <CAJe_Zhd7j+30K4ho59XiBHtGpc4PagK-NcXmxGC1WSBudV5HHg@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCHv4] DMAEngine: Define interleaved transfer request api
Thread-Index: AcyNpflRQiP0C09FT7iqQvm4on+a6wAAPVNw
References: <1317191992-3635-1-git-send-email-jaswinder.singh@linaro.org><1317200618.1573.1765.camel@vkoul-udesk3><CAJe_ZhfDk7O_O7LDh7GrpcaPMzQuzs9nBA8BeN0VxG8_Oe93wg@mail.gmail.com><1317295068.1573.1780.camel@vkoul-udesk3><CAGsJ_4y+ageAqg1DQtQJ-g2j6im_e3KdvkcBaDFLz8fUniJpuA@mail.gmail.com><CAJe_ZhfyTBgH7wqB1HWtkjDNusecTOTZrqyYKF=Lwb9xQAXA3w@mail.gmail.com><CAGsJ_4x=F41Fbsw9gB3y=Vzyhf8a9yXB=sd6xbxSNUbTAYdjOA@mail.gmail.com><CAJe_Zhd86uqhzRHaA8ci2GHQgz6TadPR5hTuuUKqCWOFJwn6qg@mail.gmail.com><CAGsJ_4zOUFUkGv_-BB5sqjVZF1gBe-MVJS3Vxmi9Jo4sqYCLAg@mail.gmail.com><CAJe_Zhc8zdZzse+jutYERec5bKBPqWmq9v0xYrou0x1BSKyCLQ@mail.gmail.com><20111003161349.GB28287@flint.arm.linux.org.uk><CAJe_ZhfS=4vSS0OiSuNx3S+fW8R4-=khrHtt8suLeHjTFYBVeA@mail.gmail.com><CABE8wwsQKF9eTTU_N305hR=G5qW4Rzb7Lo-nHbc9RVYwSJVSVA@mail.gmail.com><1317966346.1573.2252.camel@vkoul-udesk3><CAJe_ZhdFA641AzmEmYaz++iRNYQmrHDFmAWOkrwmR_h2ie176g@mail.gmail.com><CABE8wwtcO_su0cF6YocVjAYKhUb=TTwqttfaZkC+RWGLKJimdQ@mail.gmail.com><CAJe_Z
	hfWcUY2ctUFt
	0iUf2FOfjKj1Aa8hQH5LqFG+bZ+93CcNQ@mail.gmail.com><0CE8B6BE3C4AD74AB97D9D29BD24E55202321F65@CORPEXCH1.na.ads.idt.com><CAJe_ZhfTg17YgyQ9TuKdhtXMu+8W_E2t3cBqZybfarxWu9Zasg@mail.gmail.com><0CE8B6BE3C4AD74AB97D9D29BD24E552023220AC@CORPEXCH1.na.ads.idt.com><CAJe_ZhdBSxvH6Zd8JsoLrerapNbLn0a7Lv6KxwivbFuLaSavyg@mail.gmail.com><0CE8B6BE3C4AD74AB97D9D29BD24E552023221DE@CORPEXCH1.na.ads.idt.com> <CAJe_Zhd7j+30K4ho59XiBHtGpc4PagK-NcXmxGC1WSBudV5HHg@mail.gmail.com>
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

On Tue, Oct 18, 2011 at 10:55 AM, Jassi Brar <jaswinder.singh@linaro.org> wrote:
> 
> On 18 October 2011 19:21, Bounine, Alexandre
> <Alexandre.Bounine@idt.com> wrote:
> 
> >> > - there is no advance knowledge of which target device may require
> >> DMA
> >> >  service. A device driver for the particular target device is
> >> expected
> >> >  to request DMA service if required.
> >> >
> >> IMHO 1 channel per real device is an acceptable 'overhead'.
> >> Already many SoCs register dozens of channels but only a couple
> >> of them are actually used.
> >>
> > Is 64K of virtual channels per RIO port is acceptable?
> >
> I said 1 channel per _real_ device after enumeration, assuming status
> quo
> of no hotplug support. But you plan to implement hotplug soon, so that
> kills
> this option.
> Btw, is the RIO hotplug usage gonna look like USB or PCI?
I would say closer to USB with surprise insertion/removal.
But nothing is final here yet. There are some changes to
enumeration/discovery that we would like to see first.

> 
> >> >> > There is nothing that absence of full 66-bit addressing blocks
> >> now.
> >> >> > So far we are not aware about implementations that use 66-bit
> >> >> address.
> >> >> >
> >> >> Thanks for the important info.
> >> >> If I were you, I would postpone enabling support for 66-bit
> >> addressing
> >> >> esp when it soo affects the dmaengine API.
> >> >> Otherwise, you don't just code unused feature, but also put
> >> > constraints
> >> >> on development/up-gradation of the API in future, possibly,
> nearer
> >> > than
> >> >> real need of the feature.
> >> >>
> >> >> If we postpone 66-bit addressing to when it arrives, we can
> >> >> 1) Attach destID to the virtual channel's identity
> >> >> 2) Use device_prep_dma_memcpy so as to be able to change
> >> >>     target address for every transfer. Or use prep_slave,
> depending
> >> >>     upon nature of address at target endpoint.
> >> >> 3) Use slave_config to set wr_type if it remains same for enough
> >> >>     consecutive transfers to the same target (only you could
> strike
> >> >>     the balance between idealism and pragmatism).
> >> >>
> >> > With item #1 above being a separate topic, I may have a problem
> with
> >> #2
> >> > as well: dma_addr_t is sized for the local platform and not
> >> guaranteed
> >> > to be a 64-bit value (which may be required by a target).
> >> > Agree with #3 (if #1 and #2 work).
> >> >
> >> Perhaps simply change dma_addr_t to u64 in dmaengine.h alone ?
> >>
> > Adding an extra parameter to prep_slave_sg() looks much better to me.
> > That tweak for prep_dma_memcopy() may be more unsafe than the
> > extra param in prep_slave_sg().
> >
> To me the idea of making exception for RapidIO to add a new API looks
> even better. Anyways... whatever maintainers decide.

Both hands up for this! 

> 
> > Plus dma_memcopy does not fit logically for RIO as good as dma_slave.
> > For RIO we have only one buffer in local memory (as slave).
> > We just need to pass more info to the transfer prep routine.
> >
> From a client's POV a slave transfer is just a 'variation' of memcpy
> after the underlying channel has been configured appropriately. More so
> when even some Mem->Mem dmacs support physical channel configuration
> tweaking (PL330 in Samsung's SoCs do at least)
> So in an ideal world, there could be one generic 'prepare' and an
> optional
> 'slave_config' callback.
> OTOH I suspect I am overlooking something serious since nobody ever
> tried doing it. But this is a topic of different discussion.
