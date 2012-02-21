Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab2BUNI3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 08:08:29 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63766 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854Ab2BUNIY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 08:08:24 -0500
MIME-Version: 1.0
In-Reply-To: <20120221124409.GL22562@n2100.arm.linux.org.uk>
References: <1329719263-18971-1-git-send-email-swarren@nvidia.com>
	<20120220073941.GC22562@n2100.arm.linux.org.uk>
	<CACRpkdbMFN3=XTSg1oE310eTHecrs6XaMz+DCNYJzwOg8JEEiQ@mail.gmail.com>
	<20120221110618.GJ22562@n2100.arm.linux.org.uk>
	<CACRpkdYzRu4VPKPgxuttuvSDCpfHjvBGGq1rFEDExv1PsoLG=w@mail.gmail.com>
	<20120221124409.GL22562@n2100.arm.linux.org.uk>
Date: Tue, 21 Feb 2012 14:08:23 +0100
Message-ID: <CACRpkda3ZYptmExYbMuQv1LJqf=hD8g8jcPSP8Lij5-xaYd2GQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] Documentation/gpio.txt: Explain expected pinctrl interaction
From: Linus Walleij <linus.walleij@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Randy Dunlap <rdunlap@xenotime.net>, Olof Johansson <olof@lixom.net>,
        Colin Cross <ccross@android.com>, linux-doc@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 1:44 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:

>> (It'd probably need the SA1100 to be a bit more strict in using
>> gpiolib in place for the direct assignments though, else the
>> abstractions get a bit pointless anyway.)
>
> That's mostly happened through my recent set of 100 or so patches.
> There's a few areas where that's not quite as easy as it should be,
> but on the whole, it's mostly complete.

Excellent!

> The other thing I forgot to mention, and I suspect it's particular to
> SA11x0, is that the GPDR must be set correctly according to the special
> function as well as GAFR.  So, if a special function involves driving
> a pin, the pin must be set as an output in GPDR.  Conversely, if the
> special function involves input only, the pin must be set as an input
> in GPDR.
>
> So, on SA11x0, gpio and pin configuration are intimately linked.

It's quite common I think, many platforms have an intimate
relation between GPIO and muxes/altfunctions. For example
it is common that the hardware engineer doesn't helpfully
enable on-die pull-ups on the I2C bus even though the I2C
block is muxed in, you have to go in and set the pull-up bits
separately from muxing the I2C in...

Basically it's expected from a generic pad I/O cell being
arrayed into a GPIO block to expose these things in the same
set of registers.

I made some presentation last week partly describing how
some hardware engineers I know go about creating GPIO
controllers from simpler I/O pad cells:
http://www.df.lth.se/~triad/papers/pincontrol.pdf

Yours,
Linus Walleij
