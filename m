Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab2HEU2l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 16:28:41 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44264 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab2HEU2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 16:28:37 -0400
MIME-Version: 1.0
In-Reply-To: <20120703193403.GA26355@n2100.arm.linux.org.uk>
References: <2b797c83-6a3c-4051-841a-a4cfa9d1cae1@email.android.com>
	<20120701104401.GA4352@mail.gnudd.com>
	<20120703130042.GA10007@mail.gnudd.com>
	<201207031319.40884.arnd@arndb.de>
	<20120703193403.GA26355@n2100.arm.linux.org.uk>
Date: Sun, 5 Aug 2012 22:28:36 +0200
Message-ID: <CACRpkdZLGhgpUJy_3QGYvGRqyxMkkPPSdyP==h5YurWqKnctBw@mail.gmail.com>
Subject: Re: [PATCH V2 5/6] x86: add CONFIG_ARM_AMBA, selected by STA2X11
From: Linus Walleij <linus.walleij@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Alim Akhtar <alim.akhtar@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Alessandro Rubini <rubini@gnudd.com>,
        hpa@zytor.com, linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        alan@linux.intel.com, x86@kernel.org, gregkh@linuxfoundation.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 3, 2012 at 9:34 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Jul 03, 2012 at 01:19:40PM +0000, Arnd Bergmann wrote:
>> On Tuesday 03 July 2012, Alessandro Rubini wrote:
>> >    drivers/dma/amba-pl08x.c: needs <asm/hardware/pl080.h>
>> >      proposed fix: move pl080.h to include/linux
>>
>> Note that there is already an include/linux/amba/pl08x.h.
>> I would just move the few parts of pl080.h that are actually
>> needed with global visibility there, and move the rest
>> to drivers/dma/.
>
> NAK.  It's the entire register definitions for the PL08x, which we really
> should not be exporting to common code.

The major reason why that file is there is that there is *another*
PL080 driver in arch/arm/mach-s3c64xx/dma.c which I repeatedly
asked the Samsung people to replace with the
drivers/dma/amba-pl08x.c driver. :-(

When I worked on the PL08x driver in drivers/dma I reused
this header to avoid code duplication.

Now that thing is stranding in the way. Alim, Kukjin, what's happening?

I feel tempted to update Alim's patch myself and push it on you
soon...

> Please wait until _after_ my DMA engine stuff (which is now in linux-next)
> makes its way upstream before touching any of this stuff, otherwise there's
> going to be conflicts.

That stuff is in now, looking real good. Good work on this!

> As part of my patch series, this gets rid of a number of uses of it in
> arch/arm, but there's still the .cctl_memcpy initializer which does. I've
> not yet checked whether all implementations use the same value (they
> probably do), and if so then it should be eliminated from platform code
> and moved into the driver.

Sounds like a plan. If we just get rid of the duplicate implementation
we're going somewhere.

Yours,
Linus Walleij
