Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914Ab1JRNvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 09:51:36 -0400
Received: from mxout1.idt.com ([157.165.5.25]:57425 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755060Ab1JRNvf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 09:51:35 -0400
x-mimeole: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCHv4] DMAEngine: Define interleaved transfer request api
Date: Tue, 18 Oct 2011 06:51:05 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E552023221DE@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <CAJe_ZhdBSxvH6Zd8JsoLrerapNbLn0a7Lv6KxwivbFuLaSavyg@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCHv4] DMAEngine: Define interleaved transfer request api
Thread-Index: AcyNWTOa/aBoh3PQS9KcPb/5tg0/IQAPylog
References: <1317191992-3635-1-git-send-email-jaswinder.singh@linaro.org><1317200618.1573.1765.camel@vkoul-udesk3><CAJe_ZhfDk7O_O7LDh7GrpcaPMzQuzs9nBA8BeN0VxG8_Oe93wg@mail.gmail.com><1317295068.1573.1780.camel@vkoul-udesk3><CAGsJ_4y+ageAqg1DQtQJ-g2j6im_e3KdvkcBaDFLz8fUniJpuA@mail.gmail.com><CAJe_ZhfyTBgH7wqB1HWtkjDNusecTOTZrqyYKF=Lwb9xQAXA3w@mail.gmail.com><CAGsJ_4x=F41Fbsw9gB3y=Vzyhf8a9yXB=sd6xbxSNUbTAYdjOA@mail.gmail.com><CAJe_Zhd86uqhzRHaA8ci2GHQgz6TadPR5hTuuUKqCWOFJwn6qg@mail.gmail.com><CAGsJ_4zOUFUkGv_-BB5sqjVZF1gBe-MVJS3Vxmi9Jo4sqYCLAg@mail.gmail.com><CAJe_Zhc8zdZzse+jutYERec5bKBPqWmq9v0xYrou0x1BSKyCLQ@mail.gmail.com><20111003161349.GB28287@flint.arm.linux.org.uk><CAJe_ZhfS=4vSS0OiSuNx3S+fW8R4-=khrHtt8suLeHjTFYBVeA@mail.gmail.com><CABE8wwsQKF9eTTU_N305hR=G5qW4Rzb7Lo-nHbc9RVYwSJVSVA@mail.gmail.com><1317966346.1573.2252.camel@vkoul-udesk3><CAJe_ZhdFA641AzmEmYaz++iRNYQmrHDFmAWOkrwmR_h2ie176g@mail.gmail.com><CABE8wwtcO_su0cF6YocVjAYKhUb=TTwqttfaZkC+RWGLKJimdQ@mail.gmail.com><0CE8B6
	BE3C4AD74AB9
	7D9D29BD24E55202321E20@CORPEXCH1.na.ads.idt.com><CAJe_ZhfWcUY2ctUFt0iUf2FOfjKj1Aa8hQH5LqFG+bZ+93CcNQ@mail.gmail.com><0CE8B6BE3C4AD74AB97D9D29BD24E55202321F65@CORPEXCH1.na.ads.idt.com><CAJe_ZhfTg17YgyQ9TuKdhtXMu+8W_E2t3cBqZybfarxWu9Zasg@mail.gmail.com><0CE8B6BE3C4AD74AB97D9D29BD24E552023220AC@CORPEXCH1.na.ads.idt.com> <CAJe_ZhdBSxvH6Zd8JsoLrerapNbLn0a7Lv6KxwivbFuLaSavyg@mail.gmail.com>
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

On Tue, Oct 18, 2011 at 1:45 AM, Jassi Brar <jaswinder.singh@linaro.org> wrote:
> 
> On 18 October 2011 02:37, Bounine, Alexandre
> <Alexandre.Bounine@idt.com> wrote:
> > On Mon, Oct 17, 2011 at 3:30 PM, Jassi Brar
> <jaswinder.singh@linaro.org>
> > wrote:
> > ... skip ...
> >> > This is a source of the problem for RIO - DMA controller driver
> >> creates
> >> > virtual channels statically. RapidIO may use 8- or 16-bit destID.
> >> > In this case we need to create 256 or 64K virtual channels if we
> >> > want to cover all possible targets on single RIO port. Adding an
> >> extra
> >> > controller/net multiplies that number. Considering that not every
> >> > device will need a data transfer from a given node static
> allocation
> >> > will
> >> > create even more wasted resources.
> >> >
> >> Please excuse my rudimentary knowledge of RapidIO but I am tempted
> >> to ask why not register channels only for those targets that are
> >> actually
> >> detected and enumerated?
> >>
> > Two reasons:
> > - possibility of hot device insertion/removal
> ... but the linux RIO stack doesn't seem to support hotplug.
> Enumeration/discovery is done only once during boot.
> Am I overlooking something ?
> 
You are right about the current status of enumeration/discovery.
Hotplug support is in updates pipeline and will be added in planned
order for RIO patches. There are some other patches that should
go ahead of it (e.g. DMA ;) ).
Device insertion/removal notification is already in place but is
not handled yet.

We do not want to have a RapidIO DMA implementation that may become
obsolete in six month. In addition there are some user's implementations
of RapidIO hotplug which we should try not to break if they will add DMA.  

> > - there is no advance knowledge of which target device may require
> DMA
> >  service. A device driver for the particular target device is
> expected
> >  to request DMA service if required.
> >
> IMHO 1 channel per real device is an acceptable 'overhead'.
> Already many SoCs register dozens of channels but only a couple
> of them are actually used.
>
Is 64K of virtual channels per RIO port is acceptable?
Freescale's QorIQ 4080 SoC has two RIO controllers.
Designs with tsi712 may have even more: up to 4 is a reasonable estimate.
 
> >> > There is nothing that absence of full 66-bit addressing blocks
> now.
> >> > So far we are not aware about implementations that use 66-bit
> >> address.
> >> >
> >> Thanks for the important info.
> >> If I were you, I would postpone enabling support for 66-bit
> addressing
> >> esp when it soo affects the dmaengine API.
> >> Otherwise, you don't just code unused feature, but also put
> > constraints
> >> on development/up-gradation of the API in future, possibly, nearer
> > than
> >> real need of the feature.
> >>
> >> If we postpone 66-bit addressing to when it arrives, we can
> >> 1) Attach destID to the virtual channel's identity
> >> 2) Use device_prep_dma_memcpy so as to be able to change
> >>     target address for every transfer. Or use prep_slave, depending
> >>     upon nature of address at target endpoint.
> >> 3) Use slave_config to set wr_type if it remains same for enough
> >>     consecutive transfers to the same target (only you could strike
> >>     the balance between idealism and pragmatism).
> >>
> > With item #1 above being a separate topic, I may have a problem with
> #2
> > as well: dma_addr_t is sized for the local platform and not
> guaranteed
> > to be a 64-bit value (which may be required by a target).
> > Agree with #3 (if #1 and #2 work).
> >
> Perhaps simply change dma_addr_t to u64 in dmaengine.h alone ?
> 
Adding an extra parameter to prep_slave_sg() looks much better to me.
That tweak for prep_dma_memcopy() may be more unsafe than the
extra param in prep_slave_sg().
Plus dma_memcopy does not fit logically for RIO as good as dma_slave.
For RIO we have only one buffer in local memory (as slave).
We just need to pass more info to the transfer prep routine.
 
> >> > This does not prevent someone from designing RIO compliant
> endpoint
> >> > device which gives interpretation to these two bits in addition to
> >> full 64-bit
> >> > addressing of their platform.
> >> >
> >> It sounds as if the 2bits are 'Vendor-Specific' ?
> >>
> > They are not 'Vendor-Specific' in the RIO spec (just address),
> > but HW vendors may give them such meaning. I just wanted to say
> > that HW designers may follow the same logic as we do here and
> > decide to give those bits a special meaning because "no one uses
> > them".
> >
> We should discount that. Irrespective of linux RIO stack, a vendor
> would be at fault if it assigns different meaning to the upper 2bits
> while the specs deem them just MSB of 66-bit addresses.
> 
Not a big deal. We may limit RIO address to 64-bits if this is needed
for the DMA API adopted for RIO. Let's define the right API first ;). 

> > So far this is a theoretical possibility and we are not
> > aware about any designs of this type. We may put a big warning
> > note about 64-bit limitation in RapidIO documentation section.
> >
> Yes, please.

