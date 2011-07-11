Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab1GKD5x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 23:57:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43481 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756634Ab1GKD5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 23:57:49 -0400
Date: Mon, 11 Jul 2011 12:57:40 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jeremy Kerr <jeremy.kerr@canonical.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sh@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Grant Likely <grant@secretlab.ca>
Subject: Re: [PATCH 0/6] clk: Initial feedback for off-SoC slow bus clocks
Message-ID: <20110711035732.GA5040@opensource.wolfsonmicro.com>
References: <20110711025344.GA27497@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110711025344.GA27497@opensource.wolfsonmicro.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 11:53:44AM +0900, Mark Brown wrote:

Linus, CCing you in as apparently you're taking over the clock API work.
Do you need me to forward all the patches to you?

> I've just been having a go at implementing generic clk API support for
> an off-SoC device on a slow bus, the clocking module in the wm831x/2x
> series of PMICs.  Unfortunately as I don't currently have access to a
> platform that has been converted to use the API I've not actually been
> able to test the code but I'm reasonably optimistic that the code will
> Just Work(tm) as the API seems fairly straightforward.
> 
> The biggest issue I ran into was that as the clocks are all registered
> by name with the API if you've got two instances of the same off-SoC
> device in the system you'll not be able to disambiguate between the
> clocks it provides.  I've added a simple solution for this in the form
> of a patch which takes a struct device as an argument and adds that to
> the name of the registered clock.  This isn't ideal but should give
> stable names which systems can use together with clkdev to match clocks
> up with their users.  I believe that when we have device tree bindings
> for clocks we should be able to use the device to access the bindings
> and avoid this mangling - Grant, is that correct?
> 
> Otherwise everything seems to work pretty well from the driver side for
> these devices, I've added some minor updates which came up naturally
> while writing the driver code and seemed fairly obvious.  One of these
> was a change to provide a user visible Kconfig option for building the
> clock drivers, the idea being to make it easier to do build tests.  I
> did also wonder if it's worth adding a patch to enable the API on x86
> (which doesn't currently have a clock API) for coverage.
> 
> These patches (which include the two I posted yesterday) are against the
> series you posted in May with the exception of the wm831x patch which
> also has an additional dependency on "mfd: Add WM831x clock control
> register definitions" which is due for merge in the next merge window.
> If this stuff is all OK for you it would be good if you could include
> the wm831x driver in your tree for this, especially given that there's
> nothing in -next.
> 
> Mark Brown (6):
>       clk: Prototype and document clk_register()
>       clk: Provide a dummy clk_unregister()
>       clk: Constify struct clk_hw_ops
>       clk: Add Kconfig option to build all generic clk drivers
>       clk: Support multiple instances of the same clock provider
>       clk: Add initial WM831x clock driver
> 
>  MAINTAINERS              |    1 +
>  drivers/clk/Kconfig      |   16 ++-
>  drivers/clk/Makefile     |    1 +
>  drivers/clk/clk-wm831x.c |  389 ++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/clk/clk.c        |   38 ++++-
>  include/linux/clk.h      |   33 ++++
>  6 files changed, 472 insertions(+), 6 deletions(-)
>  create mode 100644 drivers/clk/clk-wm831x.c
