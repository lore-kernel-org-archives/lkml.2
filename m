Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267Ab2FFUQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 16:16:40 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:52829 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757513Ab2FFUQi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 16:16:38 -0400
MIME-Version: 1.0
In-Reply-To: <1339006060.25761.689.camel@lyra>
References: <20120427190033.GA17588@ldl.usa.hp.com>
	<20120606135009.GB1517@srcf.ucam.org>
	<1338999463.25761.630.camel@lyra>
	<20120606162703.GA6779@srcf.ucam.org>
	<1339003956.25761.667.camel@lyra>
	<20120606174202.GA8750@srcf.ucam.org>
	<1339006060.25761.689.camel@lyra>
Date: Wed, 6 Jun 2012 14:16:36 -0600
Message-ID: <CAL-B5D3Wda7TV_NBJWEbzJm=0eCs=b-wgGLdJUFRTwP_ewXGGg@mail.gmail.com>
Subject: Re: [PATCH] Disable Bus Master on PCI device shutdown
From: Myron Stowe <myron.stowe@gmail.com>
To: Khalid Aziz <khalid.aziz@hp.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, linux-pci@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 6, 2012 at 12:07 PM, Khalid Aziz <khalid.aziz@hp.com> wrote:
> On Wed, 2012-06-06 at 18:42 +0100, Matthew Garrett wrote:
>> On Wed, Jun 06, 2012 at 11:32:36AM -0600, Khalid Aziz wrote:
>>
>> > Do we agree that if device shutdown routine cleanly shuts down all I/O,
>> > clearing PCI Bus Mster bit should be safe?
>>
>> In the absence of hardware that dislikes the bus master bit ever being
>> disabled, yes. Do we know if hardware is ever tested in that situation?
>
> I will wait for device vendors to comment on that. I can't claim I have
> tested more than a few devices that way.
>
>>
>> > If yes, then we only have to deal with broken devices. So the approach
>> > could be to disable Bus Master bit unless the device ID matches a
>> > blacklist which we update as we find broken devices. I really don't
>> > like the idea of maintaining blacklists in the kernel for such things
>> > but is that a more practical approach? If blacklist does not sound
>> > good, maybe we can ask drivers to tell PCI subsystem if they are not
>> > ok with clearing Bus Master bit and then PCI subsystem could skip
>> > those devices.
>>
>> Or we could just put responsibility on the drivers to ensure that the
>> hardware won't continue doing any DMA, either by shutting down the
>> engines or clearing the bit.
>>
>
> I assume device shutdown routine should stop all I/O and shutting down
> DMA engine. Disabling Bus Master bit is just an extra measure of safety.
> I do like the idea of disabling Bus Master bit in device shutdown
> routine. After all, drivers know their hardware best. On the other hand,
> it is change to lots of driver code to implement this which means it
> will end up happening slowly over period of time. I don't mind doing the
> work up front on a good number of drivers I feel comfortable modifying.
> I am ok with pulling out code to clear bus master bit from PCI subsystem
> and replacing it with modified shutdown routines for a few drivers to
> start with.
>
> Does any one see any other issues with modifying driver shutdown
> routines for disabling Bus Master bit? Bjorn, any opinions?

Hay Khalid,

I've been following this discussion but still do not understand what the
perceived correct fix is for the situation you were originally trying to
circumvent - namely, stopping NIC devices from triggering DMA activity
upon receipt of an incoming packet.

>From the discussion it sounds like a driver, upon shutdown, can end
all active I/O
clearing the I/O queue, and also (?) shut down its DMA engine, and may
also go as far as disabling the Bus Master bit.

What was occurring in the original issue - was the driver in question not
shutting down its DMA engine for some, possibly valid, reason?

Thanks,
 Myron
>
> ====================================================================
> Khalid Aziz                                         Unix Systems Lab
> (970)898-9214                                        Hewlett-Packard
> khalid.aziz@hp.com                                  Fort Collins, CO
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
