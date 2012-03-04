Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab2CDRmt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 12:42:49 -0500
Received: from londo.lunn.ch ([80.238.139.98]:52855 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754457Ab2CDRms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 12:42:48 -0500
Date: Sun, 4 Mar 2012 18:42:29 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Mike Turquette <mturquette@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, patches@linaro.org,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@ti.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        Paul Walmsley <paul@pwsan.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
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
        Grant Likely <grant.likely@secretlab.ca>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v5 4/4] clk: basic clock hardware types
Message-ID: <20120304174229.GD11546@lunn.ch>
References: <1330763341-3437-1-git-send-email-mturquette@linaro.org>
 <1330763341-3437-5-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330763341-3437-5-git-send-email-mturquette@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 03, 2012 at 12:29:01AM -0800, Mike Turquette wrote:
> Many platforms support simple gateable clocks, fixed-rate clocks,
> adjustable divider clocks and multi-parent multiplexer clocks.
> 
> This patch introduces basic clock types for the above-mentioned hardware
> which share some common characteristics.

Hi Mike

These basic clocks don't allow the use of prepare/unprepare, from the
side of the clock provider. I think i need this.

The Orion Kirkwood SoC has clock gating for most of its on chip
peripherals, which the other older Orion devices don't have. The SATA
and PCIe also allows the PHY to be shut down, again which older Orion
devices don't have. The current code links the clock and the PHY
together, shutting both down are the same time. So i would like to
perform the PHY shutdown in the unprepare() function of the clk
driver.

Is allowing to pass prepare/unprepare functions to basic clocks
something you want to support? If i prepare a patch would you consider
it?

	Thanks
		Andrew
