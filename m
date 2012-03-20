Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759030Ab2CTWkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 18:40:47 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40396 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758901Ab2CTWkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 18:40:45 -0400
Date: Tue, 20 Mar 2012 23:40:21 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Andrew Lunn <andrew@lunn.ch>, Grant Likely <grant.likely@secretlab.ca>,
        Jamie Iles <jamie@jamieiles.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Mike Turquette <mturquette@linaro.org>,
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
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH 2/2] clk: Move init fields from clk to clk_hw
Message-ID: <20120320224021.GF29317@pengutronix.de>
References: <CAJOA=zN2cSSpM92oRnW0RyU_ZzyoQ=jthc-fAkf-P3z37uWt7w@mail.gmail.com>
 <1332214706-675-1-git-send-email-skannan@codeaurora.org>
 <1332214706-675-2-git-send-email-skannan@codeaurora.org>
 <20120320072018.GC32469@S2101-09.ap.freescale.net>
 <cbd6490459b9fd68875fec4a7c7de073.squirrel@www.codeaurora.org>
 <20120320094031.GI3852@pengutronix.de>
 <e22898bc8b69e85f1e6390d7d858f85c.squirrel@www.codeaurora.org>
 <20120320181441.GO3852@pengutronix.de>
 <4F68E53B.7040800@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F68E53B.7040800@codeaurora.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 21:18:06 up 129 days,  4:05, 34 users,  load average: 0.00, 0.03,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 01:14:51PM -0700, Saravana Kannan wrote:
> On 03/20/2012 11:14 AM, Sascha Hauer wrote:
> >On Tue, Mar 20, 2012 at 03:17:10AM -0700, Saravana Kannan wrote:
> >>
> >>On Tue, March 20, 2012 2:40 am, Sascha Hauer wrote:
> >>>On Tue, Mar 20, 2012 at 12:54:55AM -0700, Saravana Kannan wrote:
> >>>>
> >>>I am using these functions and don't need a static array, I just call
> >>>the functions with the desired parameters.
> >>
> >>Sure, then let's leave it in. Curious, where do you get the desired
> >>parameters from? Is it static date in code or is it from DT? You somehow
> >>probe it?
> >
> >It's not from DT. See this thread:
> >
> >http://www.spinics.net/lists/arm-kernel/msg165839.html
> 
> Ah, I see. That's a lot of functions calls. I think it would be much
> more efficient if you just have an array and loop over it. With my
> patch, you can just call a single register function for all these
> clocks.

I was curious and gave it a try. I registered a fixed clock and 100
gates as child clocks. I tried both DEFINE_CLK_GATE and
clk_register_gate. It turned out there was no difference in speed.

> 
> >
> >The difference is that a struct clk_initializer is only used to
> >initialize a clock and not actively used by the clock framework. But as
> >you already mentioned using a copy inside the clock framework has the
> >same effect.
> 
> My opinion on this is to follow a wait and watch approach on the
> "flags" field. I really can't think of a safe way anyone can misuse
> it. If people start doing that, we can just do the copy and let them
> deal with their broken code. Until that happens, I don't want to
> waste time/space by copying it. The rest of the fields aren't
> actively used by the common clock code after init.

Actually you will save space by copying it because you can put the
initializers in __initdata and throw the initializers of unused SoCs
compiled into the kernel away during runtime.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
