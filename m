Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab2CTSOq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 14:14:46 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33660 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab2CTSOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 14:14:44 -0400
Date: Tue, 20 Mar 2012 19:14:41 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Shawn Guo <shawn.guo@linaro.org>, Mike Turquette <mturquette@linaro.org>,
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
Subject: Re: [PATCH 2/2] clk: Move init fields from clk to clk_hw
Message-ID: <20120320181441.GO3852@pengutronix.de>
References: <CAJOA=zN2cSSpM92oRnW0RyU_ZzyoQ=jthc-fAkf-P3z37uWt7w@mail.gmail.com>
 <1332214706-675-1-git-send-email-skannan@codeaurora.org>
 <1332214706-675-2-git-send-email-skannan@codeaurora.org>
 <20120320072018.GC32469@S2101-09.ap.freescale.net>
 <cbd6490459b9fd68875fec4a7c7de073.squirrel@www.codeaurora.org>
 <20120320094031.GI3852@pengutronix.de>
 <e22898bc8b69e85f1e6390d7d858f85c.squirrel@www.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e22898bc8b69e85f1e6390d7d858f85c.squirrel@www.codeaurora.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 19:11:30 up 129 days,  1:58, 27 users,  load average: 1.13, 1.02,
 0.68
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 03:17:10AM -0700, Saravana Kannan wrote:
> 
> On Tue, March 20, 2012 2:40 am, Sascha Hauer wrote:
> > On Tue, Mar 20, 2012 at 12:54:55AM -0700, Saravana Kannan wrote:
> >>
> > I am using these functions and don't need a static array, I just call
> > the functions with the desired parameters.
> 
> Sure, then let's leave it in. Curious, where do you get the desired
> parameters from? Is it static date in code or is it from DT? You somehow
> probe it?

It's not from DT. See this thread:

http://www.spinics.net/lists/arm-kernel/msg165839.html

> 
> > Overall the clock framework was written in a way that we have to expose
> > as little information about the internally used structs as necessary. It
> > seems your patches are pulling in the opposite direction now.
> 
> I'm not exposing anything that you don't already pass from the platform
> driver. Also, you realize that this is very similar to what you suggested
> with clk_initializer right? If there is a strong push, we can make a copy
> of these inside the struct clk, but for these few init fields I don't see
> a point (see earlier email).

The difference is that a struct clk_initializer is only used to
initialize a clock and not actively used by the clock framework. But as
you already mentioned using a copy inside the clock framework has the
same effect.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
