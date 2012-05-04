Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286Ab2EDMhj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 08:37:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51881 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576Ab2EDMhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 08:37:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>
Subject: Re: Making ARM multiplatform kernels DT-only?
Date: Fri, 4 May 2012 12:34:48 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, linaro-dev@lists.linaro.org,
        Jason Cooper <jason@lakedaemon.net>, Nicolas Pitre <nico@fluxnic.net>,
        Tony Lindgren <tony@atomide.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>, Olof Johansson <olof@lixom.net>,
        David Brown <davidb@codeaurora.org>, shawn.guo@linaro.org,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
References: <201205031350.35476.arnd@arndb.de> <20120503141853.GC897@n2100.arm.linux.org.uk> <87fwbg8fm8.fsf@lebrac.rtp-net.org>
In-Reply-To: <87fwbg8fm8.fsf@lebrac.rtp-net.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205041234.48892.arnd@arndb.de>
X-Provags-ID: V02:K0:Mk7MqJrKKk9MdWuqAet4ocr9cLRFDm9uzTy3vhdzbml
 DoXopsPEboAXj8L7iMN1d3/kCMEgYg6IAHJ+ZbtprqWlf+JEqV
 i6WnG6m3ZzX7mG0bCCBeX/mJIG7EYYMzHKU1jNPCqMaLe4ppt+
 nyGH9U6wtsiXq6cPaCGLkIrSJrccrZHXS2F2e3msqcbJ/WVRQm
 CC5CPbSbJkQqlzGzlF8Hd/7qU8OoQVW/qUwq+0YtZwvuT0cb2U
 OxXkDt3K+kCM+AoBQzyIzP9pmsgUlyym4Fvh1+IoAneP+NEsKR
 Q9uagc88xBaXM3KKcFeMwVbiZOZqBUt3DNpk/uZt5kVfbnYcCA
 +y4Mqkl1DmeBeY8BVLN4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 May 2012, Arnaud Patard wrote:
> > On Thu, May 03, 2012 at 01:50:35PM +0000, Arnd Bergmann wrote:
> >> My feeling is that we should just mandate DT booting for multiplatform
> >> kernels, because it significantly reduces the combinatorial space
> >> at compile time, avoids a lot of legacy board files that we cannot
> >> test anyway, reduces the total kernel size and gives an incentive
> >> for people to move forward to DT with their existing boards.
> >
> > On this point, I strongly object, especially as I'm one who uses the
> > existing non-DT multiplatform support extensively.  It's really not
> > a problem for what you're trying to achieve.
> >
> 
> Please, don't do this. afaik, the idea was to reduce the numbers of
> kernel to deal with. Unfortunately, this kind of restriction would
> increase it. Consider orion platforms. This would mean having to deal
> with 4 kernels (1 for DT, 1 for orion5x, 1 for kirkwood, 1 for mv78xx0).

Ok, point taken. 

My hope for Orion is that we can actually proceed quicker there than
on other platforms because the hardware is relatively simple, especially
its clock and pinctrl aspects, so we would be able to boot almost anything
with just supplying the right .dts file before we get to the point
where we can boot the first multiplatform kernel on orion.

> Dropping HW support because one wants to encourage people to convert
> their board file into DT seems weird. Doing this, imho, should even be
> called a regression. The DT conversion won't happen in an eye blink so
> non-DT kernels are still something we should take care of.

It's not dropping support for anything and not a regression in that
sense. We will have other restrictions with multiplatform kernels
for some time, with a lot of drivers breaking at first, and this question
is basically about which tradeoffs and priorities we make with the
new multiplatform enablement. 

> > I think what you're proposing is a totally artificial restriction.
> > There's no problem with a kernel supporting DT and non-DT together.
> > We've proven that many many times.  I prove it every night that my
> > build and boot system runs - the OMAP LDP boots a multiplatform kernel
> > just fine without DT.
> 
> I think it's true for imx too. iirc, one can build a single image for
> armv4/armv5 and one other for armv6/armv7 without having to use DT.

Yes, it's true for most platforms, and with my proposal, you would
still be able to build an i.mx kernel that runs on all boards it
runs on today, dt or not, nothing changed. The only question is
when you want to build a combined kernel for orion+imx+omap+...
whether that should allow the same options or just a subset.

	Arnd
