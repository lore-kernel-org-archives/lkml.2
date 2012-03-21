Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab2CUJIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 05:08:39 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36721 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756769Ab2CUJIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 05:08:37 -0400
Date: Wed, 21 Mar 2012 09:07:31 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Turquette, Mike" <mturquette@ti.com>
Cc: Saravana Kannan <skannan@codeaurora.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Grant Likely <grant.likely@secretlab.ca>,
        Jamie Iles <jamie@jamieiles.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Arnd Bergman <arnd.bergmann@linaro.org>, linux-arm-msm@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Zhao <richard.zhao@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>, Paul Walmsley <paul@pwsan.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Amit Kucheria <amit.kucheria@linaro.org>
Subject: Re: [PATCH 1/2] clk: Fix error handling in fixed clock hardware
	type register fn
Message-ID: <20120321090730.GR15988@n2100.arm.linux.org.uk>
References: <CAJOA=zN2cSSpM92oRnW0RyU_ZzyoQ=jthc-fAkf-P3z37uWt7w@mail.gmail.com> <1332214706-675-1-git-send-email-skannan@codeaurora.org> <20120320071957.GH3852@pengutronix.de> <348585ed29fb3ff171267c03658e6c0d.squirrel@www.codeaurora.org> <CAJOA=zO=wp9oyuBZONk2oCRYdWU1c4qanKJik-8-sFg51p27MQ@mail.gmail.com> <4F693DD8.7070305@codeaurora.org> <CAJOA=zNteC+24oWpqkQJRnL8oqAJe2NcsjHNLbJb1MGN--VEsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJOA=zNteC+24oWpqkQJRnL8oqAJe2NcsjHNLbJb1MGN--VEsw@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 10:45:36PM -0700, Turquette, Mike wrote:
> IIRC, that discussion was with respect to the .parent member of struct
> clk.  It was decided that having .parent = NULL does not imply that a
> clock is a root clock, but instead we rely on the CLK_IS_ROOT flag.  I
> can't think of any other instance where a NULL clk when returned from
> a registration function would be useful.

No.  What I've been saying is that in _drivers_ which use clk_get(),
the error range is defined by IS_ERR(clk).  Every other value of
clk must be assumed by the driver to be valid, no ifs or buts.

What the clk API assumes about struct clk is its own business.  If it
wishes to interpret the NULL clk in a specific way, that's its business
to do so.  But it's still not the drivers business to then go and
interpret NULL as being any different from any other valid clock.

This is part of the clk API contract, which is as I said in the first
paragraph, and I keep on saying.  I'm not sure what's so difficult
about this.
