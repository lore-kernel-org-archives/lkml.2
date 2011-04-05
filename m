Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab1DEXTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 19:19:39 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50174 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab1DEXTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 19:19:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=WkWWR9nJYyn85xoK/tF4UDVZWaT9rgTHn9K6C3jmIQN4R9ZpsJM5V4LrolGshQzm1E
         VGtfYIzKPkBYd5b3V3WBvm2Or6y2a3q7kowM0cWnOCo9JkJNLxV4wWsflFvaj/apJAUd
         UuaIGJehhAddGRex4aXvnO1JZqwKSAyzG+Bp0=
MIME-Version: 1.0
In-Reply-To: <AANLkTikfBhCH5wrpYzKbws0F_UVaskhtN_SUGQ+hU8Ab@mail.gmail.com>
References: <alpine.LFD.2.00.1103310145390.28032@xanadu.home>
	<201104011554.07924.arnd@arndb.de>
	<1301671655.28467.52.camel@e102144-lin.cambridge.arm.com>
	<201104011755.57412.arnd@arndb.de>
	<AANLkTikfBhCH5wrpYzKbws0F_UVaskhtN_SUGQ+hU8Ab@mail.gmail.com>
Date: Wed, 6 Apr 2011 01:19:34 +0200
X-Google-Sender-Auth: dpGt8XvmKoiFBidWY_JRsHaxpSs
Message-ID: <BANLkTinDgAwu7jg+rciMUU19fj+TKPRwmg@mail.gmail.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>,
        Ingo Molnar <mingo@elte.hu>, david@lang.hm,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        lkml <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        David Brown <davidb@codeaurora.org>, linux-omap@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/1 Linus Torvalds <torvalds@linux-foundation.org>:

> If you have discoverable hardware, use it.
>
> But by "discoverable hardware" I mean something like PCI config
> cycles. IOW, real hardware features.

The ARM AMBA architecture actually has such a thing, or a
little of it, found in drivers/amba/bus.c.

Basically it requires you to get the physical address and size of
each peripheral, then at offset -0x10 from the end address (usually
at even 4K pages), if you find the magic number 0xB105F00D
(ARM has a sense of humour, obviously) you can find something
alike the PCI IDs at offset -0x20, manufacturer ID, version number
and revision of the hardware.

It isn't very hard to imagine that mechanism providing IRQ
numbers or DMA channel allocation and other such data
so it becomes more plug'n'play-ish. If the hardware had a
list of device physical whereabouts in a specific location too,
the system would be quite self-describing.

Not as sexy as the separate PCI configuration space
though, it's just hardcoded in along with the device I/O pages.

Apparently ARM pushed this in their few initial cells
and manufacturers are free to reuse this system for their
silicon. ST Microelectronics for example actually use it to
a larger extent. But since it was not mandatory and there
was no clear way on how to register magic numbers with
this system (like the PCI-SIG), it simply failed. Silicon
foundries didn't care or even know about it, neglecting to put
this 0xB105F00D in place.

IMO the world would have been much better off if
ARM mandated that all vendors *must* use this scheme
for their hardware blocks if they are to license the AMBA
bus incarnations, but they don't.

Maybe the ARM guys on the list has some background on
this?

Yours,
Linus Walleij
