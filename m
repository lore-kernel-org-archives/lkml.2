Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab2DZIjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 04:39:36 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55065 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab2DZIjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 04:39:33 -0400
Date: Thu, 26 Apr 2012 10:39:24 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Walmsley <paul@pwsan.com>,
        Shawn Guo <shawn.guo@freescale.com>, Jamie Iles <jamie@jamieiles.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] clk: Use a separate struct for holding init data.
Message-ID: <20120426083924.GE17184@pengutronix.de>
References: <1335419936-10881-1-git-send-email-skannan@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335419936-10881-1-git-send-email-skannan@codeaurora.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:30:59 up 165 days, 16:18, 43 users,  load average: 0.00, 0.03,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 10:58:56PM -0700, Saravana Kannan wrote:
> Create a struct clk_init_data to hold all data that needs to be passed from
> the platfrom specific driver to the common clock framework during clock
> registration. Add a pointer to this struct inside clk_hw.
> 
> This has several advantages:
> * Completely hides struct clk from many clock platform drivers and static
>   clock initialization code that don't care for static initialization of
>   the struct clks.
> * For platforms that want to do complete static initialization, it removed
>   the need to directly mess with the struct clk's fields while still
>   allowing to statically allocate struct clk. This keeps the code more
>   future proof even if they include clk-private.h.
> * Simplifies the generic clk_register() function and allows adding optional
>   fields in the future without modifying the function signature.
> * Simplifies the static initialization of clocks on all platforms by
>   removing the need for forward delcarations or convoluted macros.

Can we please stop messing with the function prototypes? So you prefer
passing a struct to clk_register which is fine and yes, it may have
advantages. But do we really need to change the prototype? Why can't we
just add a new function?

I am generally open to do these changes, but we have come to the point
where people actually want to *use* the clock framework instead of
rebasing their stuff onto the latest patches.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
