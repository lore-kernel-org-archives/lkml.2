Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964961Ab2CUJQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 05:16:30 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46999 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932066Ab2CUJQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 05:16:29 -0400
Date: Wed, 21 Mar 2012 10:16:25 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Paul Walmsley <paul@pwsan.com>
Cc: Shawn Guo <shawn.guo@linaro.org>, Saravana Kannan <skannan@codeaurora.org>,
        Mike Turquette <mturquette@linaro.org>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>, Jamie Iles <jamie@jamieiles.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/2] clk: Move init fields from clk to clk_hw
Message-ID: <20120321091625.GR3852@pengutronix.de>
References: <CAJOA=zN2cSSpM92oRnW0RyU_ZzyoQ=jthc-fAkf-P3z37uWt7w@mail.gmail.com>
 <1332214706-675-1-git-send-email-skannan@codeaurora.org>
 <1332214706-675-2-git-send-email-skannan@codeaurora.org>
 <20120320072018.GC32469@S2101-09.ap.freescale.net>
 <cbd6490459b9fd68875fec4a7c7de073.squirrel@www.codeaurora.org>
 <20120320094031.GI3852@pengutronix.de>
 <20120320141811.GF32469@S2101-09.ap.freescale.net>
 <20120320181050.GN3852@pengutronix.de>
 <alpine.DEB.2.00.1203201740470.22974@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1203201740470.22974@utopia.booyaka.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:15:28 up 129 days, 17:02, 63 users,  load average: 0.00, 0.22,
 0.34
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 05:47:42PM -0600, Paul Walmsley wrote:
> Hello Sascha
> 
> On Tue, 20 Mar 2012, Sascha Hauer wrote:
> 
> > [ C99 structure initializer elided ]
> > 
> > This will make a 4000 line file out of a 500 line file. Now when for
> > some reason struct clk_divider changes we end with big patches. If the
> > clk core gets a new fancy CLK_ flag which we want to have then again
> > we end up with big patches. Then there's also the possibility that
> > someone finds out that .lock and .hw.flags are common to all dividers
> > and comes up with a #define DEFINE_CLK_DIVIDER again to share common
> > fields.
> 
> At least we can understand easily what is being changed.  Readability, 
> particularly by others not familiar with the clock data, is more important 
> to me.
> 
> So like Saravana, I too prefer C99 structure initializers.  At least there 
> should be a choice.
> 
> Quick quiz: in this line below:
> 
> imx_clk_divider("foo_clk", "bar_clk", CCM_BASE + 0x20, 0x5, 0x3);
> 
> which field is the bitfield shift and which is the bitfield width? :-)

I can't even remember the argument order in memset, but I never voted
for a struct memset_init ;)

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
