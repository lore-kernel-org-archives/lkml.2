Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab2ECOEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 10:04:50 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37656 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120Ab2ECOEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 10:04:46 -0400
Date: Thu, 3 May 2012 15:04:28 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Deepak Saxena <dsaxena@linaro.org>, Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>, shawn.guo@linaro.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        David Brown <davidb@codeaurora.org>, Nicolas Pitre <nico@fluxnic.net>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: Making ARM multiplatform kernels DT-only?
Message-ID: <20120503140428.GB897@n2100.arm.linux.org.uk>
References: <201205031350.35476.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205031350.35476.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 01:50:35PM +0000, Arnd Bergmann wrote:
> Hi everyone,
> 
> I've been discussing multiplatform kernels with a few people recently,
> and we will have a lot of discussion sessions about this at Linaro
> Connect in Hong Kong.
> 
> One question that came up repeatedly is whether we should support all
> possible board files for each platform in a multiplatform kernel,
> or just the ones that are already using DT probing. I would like
> to get a quick poll of opinions on that and I've tried to put those
> people on Cc that would be most impacted by this, i.e. the maintainers
> for platforms that have both DT and non-DT board files at the moment.
> 
> My feeling is that we should just mandate DT booting for multiplatform
> kernels, because it significantly reduces the combinatorial space
> at compile time, avoids a lot of legacy board files that we cannot
> test anyway, reduces the total kernel size and gives an incentive
> for people to move forward to DT with their existing boards.
> 
> The counterargument is that we won't be able to support all the
> boards we currently do when the user switches on multiplatform,
> but I think that is acceptable.
> Note that I would still want to allow users to build platforms
> separately in order to enable the ATAG style board files, even
> for platforms that are not multiplatform capable.

I'm basing my comments off mach-zynq.

How about we take the following steps towards it?

1. create arch/arm/include/mach/ which contains standardized headers
   for DT based implementations.  This must include all headers included
   by asm/ or linux/ includes.  This will also be the only mach/ header
   directory included for code outside of arch/arm/mach-*.  This also
   acts as the 'default' set of mach/* includes for stuff like timex.h
   and the empty hardware.h

2. DT based mach-* directories do not have an include directory; their
   include files must be located in the main include/ heirarchy if shared
   with other parts of the kernel, otherwise they must be in the mach-*
   directory.

3. Allow build multiple mach-* directories (which we already do... see
   the samsung stuff.)

We still have irqs.h being SoC dependent, and we still haven't taken
debug-macros.S far enough along to get rid of that.  Then there's also
the problem of uncompress.h.  The last piece of the puzzle is the common
clock stuff.

So, I think we're still a way off it yet - maybe six months or so.
