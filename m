Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933144Ab3AIVqc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:46:32 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:36151 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932967Ab3AIVqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 16:46:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, eric.y.miao@gmail.com,
        linux@arm.linux.org.uk, haojian.zhuang@gmail.com, chao.bi@intel.com,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 05/11] spi/pxa2xx: make clock rate configurable from platform data
Date: Wed, 09 Jan 2013 22:52:12 +0100
Message-ID: <4864369.rBqnVsbbLM@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc2+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130109105107.GT13897@intel.com>
References: <1357555480-24022-1-git-send-email-mika.westerberg@linux.intel.com> <50EC90C3.2090604@intel.com> <20130109105107.GT13897@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 09, 2013 12:51:07 PM Mika Westerberg wrote:
> On Tue, Jan 08, 2013 at 10:33:55PM +0100, Rafael J. Wysocki wrote:
> > On 1/8/2013 2:10 PM, Mark Brown wrote:
> > >On Tue, Jan 08, 2013 at 02:41:53PM +0200, Mika Westerberg wrote:
> > >>On Tue, Jan 08, 2013 at 11:02:28AM +0000, Mark Brown wrote:
> > >>>No, the way to do this is to fix x86 to enable the clock API there.  The
> > >>>x86 maintainers couldn't be bothered when I submitted a patch and
> > >>>getting anyone to take a patch to make it available by default appears
> > >>>to be unreasonably hard but perhaps if someone from Intel tries the x86
> > >>>maintainers might take a patch...
> > >>Do you mean enabling CONFIG_COMMON_CLK on x86?
> > >Yes.
> > 
> > Why so?  x86 doesn't have a notion of direct clock control, at least
> > not on the ACPI systems.
> > 
> > >>>We shouldn't be adding special case code to every driver that might need
> > >>>a clock that gets used on an Intel system.
> > >>I agree and it is cleaner to have the same API for all arches. However, I'm
> > >>not sure how do we create the fixed clocks then? There is nothing in ACPI
> > >>namespace (or in the ACPI 5.0 spec) that allows you to describe clocks and
> > >>their relationships.
> > >I'm sure it's not beyond the bounds of possibility that we could solve
> > >this problem...
> > 
> > No, it isn't.  Any suggestions?
> 
> I have one suggestion.
> 
> Since even on x86 we are now starting to see peripherals that exists
> normally on traditional SoCs, like the SPI controller, and the drivers
> expect to have clock for these.
> 
> What if we make drivers/clk/clk-x86.c that initializes necessary clocks
> like the LPSS 100MHz fixed clock and registers this to all the LPSS
> devices? Something along the lines of:
> 
>         clk = clk_register_fixed_rate(NULL, "lpss_iclk", NULL, CLK_IS_ROOT,
> 				      100000000);
> 
> 	...
> 
> 	clk_register_clkdev(clk, NULL, "INT33C0:00");
> 
> These are clocks that you really can't control (enable/disable) but they
> allow one to get the clock rate using the standard clk API.
> 
> One problem (among other things) with this is that now we have these clocks
> created and registered on every single x86 system.

Well, we can make them depend on some .config options.

> Other problem is that this setup needs manual maintenance as we can't get
> the configuration from ACPI.

So we just happen to know what the rate is supposed to be?  What's the source
of that information?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
