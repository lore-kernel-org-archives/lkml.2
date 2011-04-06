Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985Ab1DFImC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 04:42:02 -0400
Received: from service87.mimecast.com ([94.185.240.25]:37565 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754808Ab1DFImA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 04:42:00 -0400
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <Will.Deacon@arm.com>,
        Ingo Molnar <mingo@elte.hu>, david@lang.hm,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Tony Lindgren <tony@atomide.com>,
        lkml <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        David Brown <davidb@codeaurora.org>, linux-omap@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <BANLkTinDgAwu7jg+rciMUU19fj+TKPRwmg@mail.gmail.com>
References: <alpine.LFD.2.00.1103310145390.28032@xanadu.home>
	 <201104011554.07924.arnd@arndb.de>
	 <1301671655.28467.52.camel@e102144-lin.cambridge.arm.com>
	 <201104011755.57412.arnd@arndb.de>
	 <AANLkTikfBhCH5wrpYzKbws0F_UVaskhtN_SUGQ+hU8Ab@mail.gmail.com>
	 <BANLkTinDgAwu7jg+rciMUU19fj+TKPRwmg@mail.gmail.com>
Organization: ARM Limited
Date: Wed, 06 Apr 2011 09:41:44 +0100
Message-ID: <1302079304.8718.7.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 06 Apr 2011 08:41:48.0176 (UTC) FILETIME=[77938900:01CBF436]
X-MC-Unique: 111040609415400401
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-06 at 00:19 +0100, Linus Walleij wrote:
> 2011/4/1 Linus Torvalds <torvalds@linux-foundation.org>:
> 
> > If you have discoverable hardware, use it.
> >
> > But by "discoverable hardware" I mean something like PCI config
> > cycles. IOW, real hardware features.
> 
> The ARM AMBA architecture actually has such a thing, or a
> little of it, found in drivers/amba/bus.c.
> 
> Basically it requires you to get the physical address and size of
> each peripheral, then at offset -0x10 from the end address (usually
> at even 4K pages), if you find the magic number 0xB105F00D
> (ARM has a sense of humour, obviously) you can find something
> alike the PCI IDs at offset -0x20, manufacturer ID, version number
> and revision of the hardware.

I don't think this was ever part of the AMBA specification. It was just
some convention used within ARM for the PrimeCell peripherals. Other
AMBA licensees did something else so it's not a reliable mechanism (I
think ARM gave up on this as well in recent peripherals).

> IMO the world would have been much better off if
> ARM mandated that all vendors *must* use this scheme
> for their hardware blocks if they are to license the AMBA
> bus incarnations, but they don't.

As you said, it had limitations like not providing IRQ or DMA
information, so not entirely useful.

FDT may have its problems but so far is a more generic approach for
specifying such information.

-- 
Catalin


