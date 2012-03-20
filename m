Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab2CTXrq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 19:47:46 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:46120 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab2CTXro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 19:47:44 -0400
Date: Tue, 20 Mar 2012 17:47:42 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
cc: Shawn Guo <shawn.guo@linaro.org>, Saravana Kannan <skannan@codeaurora.org>,
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
In-Reply-To: <20120320181050.GN3852@pengutronix.de>
Message-ID: <alpine.DEB.2.00.1203201740470.22974@utopia.booyaka.com>
References: <CAJOA=zN2cSSpM92oRnW0RyU_ZzyoQ=jthc-fAkf-P3z37uWt7w@mail.gmail.com> <1332214706-675-1-git-send-email-skannan@codeaurora.org> <1332214706-675-2-git-send-email-skannan@codeaurora.org> <20120320072018.GC32469@S2101-09.ap.freescale.net>
 <cbd6490459b9fd68875fec4a7c7de073.squirrel@www.codeaurora.org> <20120320094031.GI3852@pengutronix.de> <20120320141811.GF32469@S2101-09.ap.freescale.net> <20120320181050.GN3852@pengutronix.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sascha

On Tue, 20 Mar 2012, Sascha Hauer wrote:

> [ C99 structure initializer elided ]
> 
> This will make a 4000 line file out of a 500 line file. Now when for
> some reason struct clk_divider changes we end with big patches. If the
> clk core gets a new fancy CLK_ flag which we want to have then again
> we end up with big patches. Then there's also the possibility that
> someone finds out that .lock and .hw.flags are common to all dividers
> and comes up with a #define DEFINE_CLK_DIVIDER again to share common
> fields.

At least we can understand easily what is being changed.  Readability, 
particularly by others not familiar with the clock data, is more important 
to me.

So like Saravana, I too prefer C99 structure initializers.  At least there 
should be a choice.

Quick quiz: in this line below:

imx_clk_divider("foo_clk", "bar_clk", CCM_BASE + 0x20, 0x5, 0x3);

which field is the bitfield shift and which is the bitfield width? :-)


- Paul

