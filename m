Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab2EDJcr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 05:32:47 -0400
Received: from lebrac.rtp-net.org ([88.191.135.105]:40083 "EHLO
	lebrac.rtp-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab2EDJcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 05:32:46 -0400
X-Greylist: delayed 489 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 May 2012 05:32:46 EDT
From: Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, Kukjin Kim <kgene.kim@samsung.com>,
        linaro-dev@lists.linaro.org, Jason Cooper <jason@lakedaemon.net>,
        Nicolas Pitre <nico@fluxnic.net>, Tony Lindgren <tony@atomide.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>, Olof Johansson <olof@lixom.net>,
        David Brown <davidb@codeaurora.org>, shawn.guo@linaro.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Making ARM multiplatform kernels DT-only?
Organization: RtpNet
References: <201205031350.35476.arnd@arndb.de>
	<20120503141853.GC897@n2100.arm.linux.org.uk>
Date: Fri, 04 May 2012 11:22:55 +0200
In-Reply-To: <20120503141853.GC897@n2100.arm.linux.org.uk> (Russell King's
	message of "Thu, 3 May 2012 15:18:53 +0100")
Message-ID: <87fwbg8fm8.fsf@lebrac.rtp-net.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux <linux@arm.linux.org.uk> writes:

Hi,

> On Thu, May 03, 2012 at 01:50:35PM +0000, Arnd Bergmann wrote:
>> My feeling is that we should just mandate DT booting for multiplatform
>> kernels, because it significantly reduces the combinatorial space
>> at compile time, avoids a lot of legacy board files that we cannot
>> test anyway, reduces the total kernel size and gives an incentive
>> for people to move forward to DT with their existing boards.
>
> On this point, I strongly object, especially as I'm one who uses the
> existing non-DT multiplatform support extensively.  It's really not
> a problem for what you're trying to achieve.
>

Please, don't do this. afaik, the idea was to reduce the numbers of
kernel to deal with. Unfortunately, this kind of restriction would
increase it. Consider orion platforms. This would mean having to deal
with 4 kernels (1 for DT, 1 for orion5x, 1 for kirkwood, 1 for mv78xx0).

Dropping HW support because one wants to encourage people to convert
their board file into DT seems weird. Doing this, imho, should even be
called a regression. The DT conversion won't happen in an eye blink so
non-DT kernels are still something we should take care of.

> I think what you're proposing is a totally artificial restriction.
> There's no problem with a kernel supporting DT and non-DT together.
> We've proven that many many times.  I prove it _every_ night that my
> build and boot system runs - the OMAP LDP boots a multiplatform kernel
> just fine without DT.

I think it's true for imx too. iirc, one can build a single image for
armv4/armv5 and one other for armv6/armv7 without having to use DT.

Regards,
Arnaud
