Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab2CHG2F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 01:28:05 -0500
Received: from londo.lunn.ch ([80.238.139.98]:56723 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162Ab2CHG2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 01:28:01 -0500
Date: Thu, 8 Mar 2012 07:27:39 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: "Turquette, Mike" <mturquette@ti.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Paul Walmsley <paul@pwsan.com>, linaro-dev@lists.linaro.org,
        Linus Walleij <linus.walleij@stericsson.com>, patches@linaro.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Deepak Saxena <dsaxena@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 3/4] clk: introduce the common clock framework
Message-ID: <20120308062739.GE18513@lunn.ch>
Mail-Followup-To: "Turquette, Mike" <mturquette@ti.com>,
	Sascha Hauer <s.hauer@pengutronix.de>, Andrew Lunn <andrew@lunn.ch>,
	Paul Walmsley <paul@pwsan.com>, linaro-dev@lists.linaro.org,
	Linus Walleij <linus.walleij@stericsson.com>, patches@linaro.org,
	Stephen Boyd <sboyd@codeaurora.org>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
	Rob Herring <rob.herring@calxeda.com>,
	Richard Zhao <richard.zhao@linaro.org>,
	Grant Likely <grant.likely@secretlab.ca>,
	Deepak Saxena <dsaxena@linaro.org>,
	Saravana Kannan <skannan@codeaurora.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Shawn Guo <shawn.guo@freescale.com>,
	Amit Kucheria <amit.kucheria@linaro.org>,
	Russell King <linux@arm.linux.org.uk>,
	Jeremy Kerr <jeremy.kerr@canonical.com>,
	Arnd Bergman <arnd.bergmann@linaro.org>,
	linux-arm-kernel@lists.infradead.org
References: <1330763341-3437-1-git-send-email-mturquette@linaro.org>
 <1330763341-3437-4-git-send-email-mturquette@linaro.org>
 <20120303133158.GA26882@pengutronix.de>
 <CAJOA=zNFNEHxBDhRDdvm7DYR83R0LJjsp_AT3BoG+nL+iN5_tw@mail.gmail.com>
 <20120304115201.GB26882@pengutronix.de>
 <CAJOA=zP8d8wm==7=svOzh03Ft-1_LV71q0mA6Pncrh5vQSWGEA@mail.gmail.com>
 <20120305073836.GU3852@pengutronix.de>
 <CAJOA=zMs75ZQ24g5PXpSLV3AJzWEo12g86G8+4+ryQR_cTYpzA@mail.gmail.com>
 <20120306190039.GJ3852@pengutronix.de>
 <CAJOA=zOG_6eSWPEfFL6VKWeTpGKD9y11xeHoOwdS3b59tAZ45A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJOA=zOG_6eSWPEfFL6VKWeTpGKD9y11xeHoOwdS3b59tAZ45A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Assuming that some day OMAP code can be refactored to allow for lazy
> (or at least initcall-based) registration of clocks then perhaps your
> suggestion can take root.  Which leads me to this question: are there
> any other platforms out there that require the level of expose to
> struct clk present in this patchset?  OMAP does, for now, but if that
> changes then I need to know if others require this as well.

Hi Mike

For kirkwood, i use static clk's for all but my root clock. I cannot
statically know the rate of the root clock, so i have to determine it
at boot time using heuristics, PCI ID, etc.

I used statics thinking it would be less code. No idea if it actually
is, and there is nothing stopping me moving to creating the clocks
after creating the root clock.

One comment i have about the current static clks. I completely missing
you need to call __clk_init() on them and so ended up with lots of
division by zero errors, since they did not have a parent, and so the
code seemed not be to able to determine the rate.

So 

1) Please add __clk_init() to the documentation in the section about
   static clocks.

2) Should maybe the name change? It seems strange having to call a
   __X() function. If this is a function which is supposed to be used,
   drop the __. Maybe clk_static_register()?

3) Maybe, if the parent is missing, clk_get_rate() should return an
   error?

Andrew
