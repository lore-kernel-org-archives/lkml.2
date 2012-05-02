Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758301Ab2EBCBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 22:01:42 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:60268 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757384Ab2EBCBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 22:01:40 -0400
Date: Tue, 1 May 2012 18:56:50 -0700
From: Mike Turquette <mturquette@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Saravana Kannan <skannan@codeaurora.org>, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Grant Likely <grant.likely@secretlab.ca>, h@pengutronix.de,
        Jamie Iles <jamie@jamieiles.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Arnd Bergman <arnd.bergmann@linaro.org>, linux-arm-msm@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Zhao <richard.zhao@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>, Paul Walmsley <paul@pwsan.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Amit Kucheria <amit.kucheria@linaro.org>
Subject: Re: [PATCH] clk: Use a separate struct for holding init data.
Message-ID: <20120502015650.GE17311@gmail.com>
References: <4d67387a86d99cbb4e2acf68d3588b1c.squirrel@www.codeaurora.org>
 <20120426095135.GG17184@pengutronix.de>
 <4F9EE84C.90106@codeaurora.org>
 <CAJOA=zNCagT6GaeHi_jq7-LU9P-SfJZ8PA9bo-oeswjC0tHyYA@mail.gmail.com>
 <4F9F1659.1010804@codeaurora.org>
 <20120501081103.GC2194@S2101-09.ap.freescale.net>
 <20120501091334.GG15541@lunn.ch>
 <20120501170001.GB4089@opensource.wolfsonmicro.com>
 <4FA0258D.8020807@codeaurora.org>
 <20120501181922.GD4089@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120501181922.GD4089@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20120501-19:19, Mark Brown wrote:
> On Tue, May 01, 2012 at 11:03:57AM -0700, Saravana Kannan wrote:
> 
> > Sorry for the annoyance I seem to have caused. I too have been
> > trying to get this in for a while before the other platforms started
> > using the new framework. Not everyone was free at the same time and
> > it's taken longer that I would have wished for.
> 
> > I did my best to limit the changes that would be needed without
> > making my patch useless. Appreciate your understanding.
> 
> To be honest it doesn't look like your patch is a particular issue here
> - there's wider process problems, for example we've managed to go
> through most of the release cycle and so far the only changes showing up
> in -next are:

I think that "wider process problems" is probably a euphemism, and I'll
take responsibility for that.  This has been a learning process for me
and I underestimated the percentage of my time that would be consumed by
common clk maintenance.  I'm trying to rectify that problem now.

> 
> Viresh Kumar (6):
>       SPEAr: clk: Add VCO-PLL Synthesizer clock
>       SPEAr: clk: Add Auxiliary Synthesizer clock
>       SPEAr: clk: Add Fractional Synthesizer clock
>       SPEAr: clk: Add General Purpose Timer Synthesizer clock
>       SPEAr: Switch to common clock framework
>       SPEAr13xx: Add common clock framework support
> 
> Mark Brown (1):
>       ARM: 7376/1: clkdev: Implement managed clk_get()
> 
> Sascha Hauer (1):
>       clk: add a fixed factor clock
> 
> viresh kumar (1):
>       ARM: 7392/1: CLKDEV: Optimize clk_find()
> 
> and obviously there's quite a bit more work which has been going on.

I could use some suggestions on the best way to resolve the merge issues
we have currently.  It appears that we have three bases that platforms
need to port over the common clk framework:

Russell's clkdev
Arnd's arm-soc
My clk-next branch

I was happy to push my changes to Linus directly (as discussed in
previous mails) but I'm starting to think that maybe having Arnd absorb
the clk-next branch as part of arm-soc would be the fastest way to
assist platforms that are porting over.

Do the platform folks agree?  Is this suggestion sane?

Thanks,
Mike
