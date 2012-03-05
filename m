Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab2CEKSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 05:18:41 -0500
Received: from londo.lunn.ch ([80.238.139.98]:53903 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756418Ab2CEKSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 05:18:38 -0500
Date: Mon, 5 Mar 2012 11:17:08 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Andrew Lunn <andrew@lunn.ch>, "Turquette, Mike" <mturquette@ti.com>,
        Russell King <linux@arm.linux.org.uk>, patches@linaro.org,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        Paul Walmsley <paul@pwsan.com>, Shawn Guo <shawn.guo@freescale.com>,
        Jamie Iles <jamie@jamieiles.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH v5 4/4] clk: basic clock hardware types
Message-ID: <20120305101708.GF24858@lunn.ch>
References: <1330763341-3437-1-git-send-email-mturquette@linaro.org>
 <1330763341-3437-5-git-send-email-mturquette@linaro.org>
 <20120304174229.GD11546@lunn.ch>
 <CAJOA=zNWN6L+-YEkNKoQnjnrrswNpCBmtnhKBm04HekWP46i5w@mail.gmail.com>
 <20120305084823.GD24858@lunn.ch>
 <20120305092948.GV3852@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120305092948.GV3852@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I think i can wrap your simple gate clock, to make my "complex" gate
> > clock. What would help is if you would EXPORT_SYMBOL_GPL
> > clk_gate_enable() and clk_gate_disable(), since they do exactly what i
> > want. I can then build my own clk_ops structure, with my own
> > unprepare() function. I would probably use DEFINE_CLK_GATE as is, and
> > then at run time, before calling __clk_init() overwrite the .ops with
> > my own version.
> 
> Maybe I don't get your point, but clk_unprepare should be used when
> you have to sleep to disable your clock. When clk_gate_disable() is
> exactly why do you want to use clk_unprepare instead of clk_disable?

I'm trying to avoid having to implement a new clock provider. The
whole point of the generic clk code is to consolidate code. It seems
silly to create a new clk provider which is 95% identical to Mike's
gated provider, if i can avoid it.

If i stuff it into clk_disable(), it means i cannot use the basic gate
clock Mike provides in the generic clock framework. Which is a shame,
since it does exactly what i want in terms of gating the clock.

If i can use unprepare(), which basic gate does not use, i can use
Mikes code, and just extend it. It is there, it is unused, so why not
use it?

    Andrew
