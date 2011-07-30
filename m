Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065Ab1G3PAP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 11:00:15 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35324 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab1G3PAI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 11:00:08 -0400
MIME-Version: 1.0
In-Reply-To: <20110730142221.GA17081@flint.arm.linux.org.uk>
References: <CABE8wwv2XQ_aJ8O2TUAz1LgJorBwDbgyQQv7jeAn06Q2AcqH+Q@mail.gmail.com>
	<CAJe_ZhcNM7m-eWA0nDUrOrHxeAhNS00gewf=txmvOFL_uOPhrw@mail.gmail.com>
	<1311740499.1536.56.camel@vkoul-udesk3>
	<CAJe_ZhfaPfobs5P+q+t-kRSK4fAvm-v_brYgqmco8fwOOBeT8A@mail.gmail.com>
	<1311757347.1536.103.camel@vkoul-udesk3>
	<CAJe_Zhd+Z4-=xDzFrd3ARuKZkUAo6n_miQgdSADY9Uk6uhkqhw@mail.gmail.com>
	<20110727203710.GB5028@flint.arm.linux.org.uk>
	<CAJe_ZhcggEW1wfF8EVy-qgfa194B+-qifongLOvPwVg5O9AcBg@mail.gmail.com>
	<20110728224038.GD829@flint.arm.linux.org.uk>
	<CAJe_ZheU2CNsNYqrEZd-9BWw8WFWmEqsGAutJcOXir-PGdyFdQ@mail.gmail.com>
	<20110730142221.GA17081@flint.arm.linux.org.uk>
Date: Sat, 30 Jul 2011 20:30:07 +0530
Message-ID: <CAJe_ZheN6zSXXc4NkZPY6QwO+tkjT3BaAbcpVydOkx6oEvTOGQ@mail.gmail.com>
Subject: Re: [PATCHv2] DMAEngine: Let dmac drivers to set chan_id
From: Jaswinder Singh <jaswinder.singh@linaro.org>
To: Russell King <rmk@arm.linux.org.uk>
Cc: "Koul, Vinod" <vinod.koul@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, per.friden@stericsson.com,
        wei.zhang@freescale.com, ebony.zhu@freescale.com, iws@ovro.caltech.edu,
        s.hauer@pengutronix.de, maciej.sosnowski@intel.com, saeed@marvell.com,
        shawn.guo@freescale.com, yur@emcraft.com, agust@denx.de,
        iwamatsu.nobuhiro@renesas.com, per.forlin@stericsson.com,
        jonas.aberg@stericsson.com, anemo@mba.ocn.ne.jp
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 July 2011 19:52, Russell King <rmk@arm.linux.org.uk> wrote:
> On Sat, Jul 30, 2011 at 06:39:13PM +0530, Jaswinder Singh wrote:
>> On 29 July 2011 04:10, Russell King <rmk@arm.linux.org.uk> wrote:
>>
>> >> > Board 3 has the MMCI connected through an external FPGA mux, which can route the
>> >> > MMCI requests to DMA request signals #1, #2 or #3.
>> >> Say
>> >>  Board3
>> >>      MMCI_RX  -> #{1,2,3}
>> >>      MMCI_TX  -> #{1,2,3}
>> >> And you can't change the route(mapping) after the dmac driver has
>> >> been loaded.
>> >
>> > No.  You have to change it dynamically at run time according to the
>> > DMA activity, because DMA request signals #1, #2 and #3 are shared
>> > between 6 devices.  To make matters worse, it's not six on any of
>> > RQ#1 RQ#2 RQ#3, but some on a couple, some on another couple, and
>> > some on all three.
>> >
>> > BTW, we do support this with Linus W's code (which he's posted to
>> > this thread.)
>>
>> In case you missed my reply to these runtime switching cases,
>> please have a look at https://lkml.org/lkml/2011/7/29/211
>
> Stop pointing me at archives.  I'm not reading links during an email
> discussion.  It's bad enough the mass of words that you include in
> your replies to work out what you're saying.
>
> And actually now, I'm completely lost over exactly what provides what
> with your idea.
>
> Could you please put together a _complete_ example of how you see my
> board examples #1, #2 and #3 working, covering your _entire_ idea in
> one _single_ _concise_ email with no references elsewhere, covering
> in each case:
>
> - how a peripheral device driver obtains, is allocated, or is provided with
>  this 'capability' mask.
> - how a DMA engine driver is told which 'capability' masks from peripheral
>  drivers it is to match.
> - how that is translated to a DMA device channels.
> - how that translates to DMA request signals attached directly to the DMA
>  device.
> - how that translates to DMA request signals attached to some kind of MUX
>  which in turn is attached to a DMA request signal attached to the DMA
>  device.
>
> Better still, do it in pseudo-C code, or real C code if you think that'll
> help (there's nothing like seeing the actual code.)
>
> You have for reference:
> 1. The AMBA drivers in the kernel tree (MMCI, PL011 UART).
>        drivers/tty/serial/amba-pl011.c
>        drivers/mmc/host/mmci.c
> 2. The DMA engine code for PL080 in the kernel tree.
>        drivers/dma/amba-pl08x.c
> 3. Linus' example code for the Versatile/Realview platforms.
>        (attached to his email.)
>
> This is enough to cover the cases I outlined in boards #1,#2,#3.
>
> To tie this down further, into real hardware, so lets say:
> board #1: is Versatile PB926 with an on-board UART0 - so DMA controller
>        request signal #14 for receive and DMA controller request signal
>        #15 for transmit.
>
> board #2: is Realview EB with an on-board UART1 - so DMA controller
>        request signal #12 (RX) and #13 (TX).
>
> board #3: is Versatile PB926 with the FPGA-implemented MMCI1 - so
>        DMA controller request signals #0 to #2 inclusive may be used,
>        via three separate MUXes (one per request signal) requiring
>        the selected mux to be programmed with value '5'.  This same
>        channel can be used for either DMA-to-device or DMA-from-device,
>        but the MMCI device driver may request two separate 'dma channels'
>        if they are available.
>
>        To ensure all cases are covered, please assume that the AACI
>        is also using DMA continuously for a long time in this case,
>        which may be using any of #0 to #2 via the mux, and so how
>        the AACI's in-use DMA device request signal is avoided.
>
Would love to.
But only after Linaro Connect of 1 week.. and then out of time not officially
assigned to it. So it might be soon or late.
