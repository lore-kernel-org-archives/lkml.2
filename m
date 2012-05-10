Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289Ab2EJLD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 07:03:29 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39006 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757877Ab2EJLD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 07:03:28 -0400
Date: Thu, 10 May 2012 12:02:42 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ben Dooks <ben-linux@fluff.org>
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
Message-ID: <20120510110242.GE3190@n2100.arm.linux.org.uk>
References: <201205031350.35476.arnd@arndb.de> <20120503141853.GC897@n2100.arm.linux.org.uk> <20120510105515.GC30103@trinity.fluff.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120510105515.GC30103@trinity.fluff.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 11:55:15AM +0100, Ben Dooks wrote:
> On Thu, May 03, 2012 at 03:18:53PM +0100, Russell King - ARM Linux wrote:
> > I think what you're proposing is a totally artificial restriction.
> > There's no problem with a kernel supporting DT and non-DT together.
> > We've proven that many many times.  I prove it _every_ night that my
> > build and boot system runs - the OMAP LDP boots a multiplatform kernel
> > just fine without DT.
> 
> We could have had the same for Samsung's entire range if a bit of work
> had been applied to do things like PAGE_OFFSET and replaceable IRQ
> controllers.

We never did dynamic PAGE_OFFSET because we _had_ taken the decision with
the inclusion of XIP support that we weren't going to have self-modifying
code in the kernel - and loading the offset for every page table walk
would have been very expensive.

The self-modifying code viewpoint seems to have changed as a result of
Nicolas moving jobs, from an employer who wanted XIP to one who wants a
single kernel image, which in itself isn't surprising.
