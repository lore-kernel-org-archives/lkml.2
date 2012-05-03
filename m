Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749Ab2EDMWt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 08:22:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54660 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757666Ab2EDMWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 08:22:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: Making ARM multiplatform kernels DT-only?
Date: Thu, 3 May 2012 16:27:44 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Deepak Saxena <dsaxena@linaro.org>, Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>, shawn.guo@linaro.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        David Brown <davidb@codeaurora.org>, Nicolas Pitre <nico@fluxnic.net>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
References: <201205031350.35476.arnd@arndb.de> <20120503141853.GC897@n2100.arm.linux.org.uk>
In-Reply-To: <20120503141853.GC897@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205031627.44889.arnd@arndb.de>
X-Provags-ID: V02:K0:jaCpIOStRxD+IHrt/ofnAaMY78/Hqy+bwey1hM0NRAJ
 iOIRIhvmzB+IkLvIdx/HG1k/78X5YDXVN7K47NOaXTCWIxi8DK
 +PW6BTC8VV7clvOlaEZ8gBV0aJgTHDnxPF1alKoQjYIpJg7dEF
 0vjFvf+NcuzX8I0GbfJq6NZQ5fEDHCtmsFneLPx6PSxdIvxkp3
 0hiSpFB6706dm6DuXKoSEFsgxGyz6pVnm7Xc3JzpCIvnbjiJda
 5YyLRzTPfxFC5KD1nJANTZ9R4bkQx8YslSPT3Uc1knrKqr7C1a
 /rGo5BEWecVdIMhKOUefAgX7/OfgoHELVGJ5lxXzE06MEWiaLF
 9l5HXUj8f5Ohg4fbOKTY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 May 2012, Russell King - ARM Linux wrote:
> On Thu, May 03, 2012 at 01:50:35PM +0000, Arnd Bergmann wrote:
> > My feeling is that we should just mandate DT booting for multiplatform
> > kernels, because it significantly reduces the combinatorial space
> > at compile time, avoids a lot of legacy board files that we cannot
> > test anyway, reduces the total kernel size and gives an incentive
> > for people to move forward to DT with their existing boards.
> 
> On this point, I strongly object, especially as I'm one who uses the
> existing non-DT multiplatform support extensively.  It's really not
> a problem for what you're trying to achieve.

Just to clarify the terminology, when I said "multiplatform", I did
not mean enabling more than one board file inside a given mach-*
directory but instead enabling multiple mach-* directories that
are currently mutually exclusive, i.e. the future stuff you replied
to in the other mail, not what everyone is doing today, and this
would not stop anything from working that works today.

> I think what you're proposing is a totally artificial restriction.
> There's no problem with a kernel supporting DT and non-DT together.
> We've proven that many many times.  I prove it every night that my
> build and boot system runs - the OMAP LDP boots a multiplatform kernel
> just fine without DT.

Of course it's an artificial restriction, if it was a technical necessity,
I would not have needed to ask ;-) IMHO however it's a helpful restriction.
My current count of board files is 393 and if you consider that we won't
build v6+ and v4/v5 together and that some of them will probably not
be multiplatform capable for a long time, we probably end up with about
half of them in a given kernel, which is still a lot and I would not
expect distributors to make a good decision about which ones of these
are important to enable and which ones are not. If we restrict the
Kconfig space to just the ones that are DT-enabled, we can be reasonably
sure that these have been recently tested on actual hardware by someone
who cares about them, and we get only a fraction of the user visible
options, roughly one per soc generation.

One counterargument that just occurred to me is build coverage, and it
would be nice to have "make allyesconfig" actually build everything
together as far as possible. We could get a bit closer to that if
we allow those platforms that have no DT support to just provide a
Kconfig option for multiplatform kernels that enables everything, e.g.
when you build an ARMv4/ARMv5 kernel, you can enable all sa1100
based boards together using one option, but when you build an sa1100
kernel, you keep picking them individually.

	Arnd

