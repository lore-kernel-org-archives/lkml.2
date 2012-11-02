Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759109Ab2KBQof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 12:44:35 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:42497 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758701Ab2KBQoc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 12:44:32 -0400
MIME-Version: 1.0
In-Reply-To: <20121102110038.GA19493@arwen.pp.htv.fi>
References: <20121101124025.GA12489@arwen.pp.htv.fi>
	<A16B0ABF-AB9D-4F48-88BD-96F123FFEF2F@antoniou-consulting.com>
	<20121101131609.GC12489@arwen.pp.htv.fi>
	<E911D0B7-0397-4ED0-828E-71F9531E84E0@antoniou-consulting.com>
	<20121101135148.382aec00@pyramind.ukuu.org.uk>
	<9F25E89E-9194-4725-8A8C-053DCBADA1DB@antoniou-consulting.com>
	<20121101220518.GE14982@arwen.pp.htv.fi>
	<CA+Bv8XbAvEXe=zDaA8W2+ROD2duYMRcJu4-bms31OH=V_ScKow@mail.gmail.com>
	<20121102085718.GF17063@arwen.pp.htv.fi>
	<CA+Bv8Xb4eAQ2po-nwCT6ZXNdaU7cwshVaGC795e3GYZ+B7L-jQ@mail.gmail.com>
	<20121102110038.GA19493@arwen.pp.htv.fi>
Date: Fri, 2 Nov 2012 09:44:31 -0700
X-Google-Sender-Auth: lwa623Fdjx4dU91ZoiDfj2-F674
Message-ID: <CA+Bv8Xb_W-VfNM1WfT5YyKMnOUYBp6qg7_CEFvPq3690dbWY3w@mail.gmail.com>
Subject: Re: [PATCH 0/3] capebus moving omap_devices to mach-omap2
From: Russ Dill <Russ.Dill@ti.com>
To: balbi@ti.com
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "Cousson, Benoit" <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        linux-kernel@vger.kernel.org, Koen Kooi <koen@dominion.thruhere.net>,
        Matt Porter <mporter@ti.com>, linux-omap@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>, Paul Walmsley <paul@pwsan.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 2, 2012 at 4:00 AM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Fri, Nov 02, 2012 at 02:42:51AM -0700, Russ Dill wrote:
>> >> browse through various detect functions, yes, some of them key off an
>> >> ID, but a lot of them just check various registers to see if certain
>> >> bits are zero, or certain bits are one. A lot of I²C devices I've
>> >> dealt with have no good way of probing them, especially GPIO chips
>> >> (you'll notice none of the I²C GPIO expanders have detect functions)
>> >
>> > it doesn't mean it can't be done.
>>
>> Really? Please, do tell how you would write a detect function for a
>> PCA9534. It has 4 registers, an input port registers, an output port
>> register, a polarity inversion register, and a configuration register.
>
> read them and match to their reset values, perhaps ?

So its ok for it to not work on warm reset? Also, I'm pretty sure [
random, 0xff, 0x00, 0xff ] describes quite a few chips.

>> And don't forget, since we are probing, every detect routine for every
>> I²C driver will have to run with every I²C address on every bus,
>> possibly with both address formats.
>
> not *every* I2C address. What you say is wrong, a ->detect() method will
> only run for those addresses which the device can actually assume.

OK, that's still a potentially large number of addresses.

>> >> On top of all this the detect routine does not tell you if the alert
>> >> pin is connected to some IRQ, or in the case of a GPIO expander, what
>> >> those GPIOs are connected to, etc, etc.
>> >
>> > so what ? All you want to do with detect is figure out if the far end is
>> > who you think it is, not what it's doing.
>>
>> If we already knew who was there, we wouldn't need a detect routine.
>
> of course not :-) But the whole discussion has been about not knowing
> which capes (and thus which devices) are attached to the bone.

Eh? Finding out which bone is connected is pretty easy, they all have
an EEPROM with identifying information. That isn't the problem that
capebus is solving, capebus is solving the problem of enumerating that
hardware.
