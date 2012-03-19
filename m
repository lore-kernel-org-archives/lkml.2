Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936Ab2CSLXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 07:23:11 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53990 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab2CSLXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 07:23:08 -0400
Date: Mon, 19 Mar 2012 12:22:52 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: "Turquette, Mike" <mturquette@ti.com>, Andrew Lunn <andrew@lunn.ch>,
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
Message-ID: <20120319112252.GW3852@pengutronix.de>
References: <CAJOA=zP8d8wm==7=svOzh03Ft-1_LV71q0mA6Pncrh5vQSWGEA@mail.gmail.com>
 <20120305073836.GU3852@pengutronix.de>
 <CAJOA=zMs75ZQ24g5PXpSLV3AJzWEo12g86G8+4+ryQR_cTYpzA@mail.gmail.com>
 <20120306190039.GJ3852@pengutronix.de>
 <CAJOA=zOG_6eSWPEfFL6VKWeTpGKD9y11xeHoOwdS3b59tAZ45A@mail.gmail.com>
 <20120308062739.GE18513@lunn.ch>
 <20120308232549.GU3852@pengutronix.de>
 <20120309075720.GC16608@lunn.ch>
 <CAJOA=zPztBfTY_WDwZ5iFEa94eCtHyrzN422RTACMQXs625gRA@mail.gmail.com>
 <20120319070115.GC31410@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120319070115.GC31410@S2101-09.ap.freescale.net>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:06:11 up 127 days, 18:53, 98 users,  load average: 0.05, 0.12,
 0.56
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 03:01:17PM +0800, Shawn Guo wrote:
> On Fri, Mar 09, 2012 at 10:25:00AM -0800, Turquette, Mike wrote:
> ...
> > However if you have the ability to use the clk_foo_register functions
> > please do use them in place of static initialization.  The static init
> > stuff is only for folks backed into a corner and forced to use it...
> > for now.  I'm looking at ways to allow for kmalloc'ing in early boot,
> > as well as reducing the number of clocks that my platform registers
> > during early boot drastically.
> > 
> While I agree using registration functions rather than static
> initialization will help make "struct clk" an opaque cookie, I also
> see some benefit with using static initialization over registration
> functions.  That is we will be able to initialize parents statically
> rather than calling expensive __clk_lookup() to find them when using
> registration functions.
> 
> I'm not sure if this will be a concern with the platforms that have
> hundreds of clocks.  Keep it in mind, when we say one clock, there
> are generally 3 clks behind it, clk_gate, clk_divider and clk_mux.

On an i.MX51 with a fully dynamically allocated clock tree it takes
about 10ms to initialize the tree which I think is acceptable. The
clock tree is not complete, but I would think that about 70% of the
clocks are there.
Normally less performant platforms will have less clocks, so I assume
the times will be comparable.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
