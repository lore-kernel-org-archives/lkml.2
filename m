Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759920Ab2CMVsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 17:48:08 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60320 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759881Ab2CMVsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 17:48:04 -0400
Message-ID: <4F5FC090.90005@gmail.com>
Date: Tue, 13 Mar 2012 16:48:00 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        linaro-dev@lists.linaro.org, Saravana Kannan <skannan@codeaurora.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Arnd Bergman <arnd.bergmann@linaro.org>, patches@linaro.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Walmsley <paul@pwsan.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/3] clk: introduce the common clock framework
References: <1331366064-1273-1-git-send-email-mturquette@linaro.org> <1331366064-1273-3-git-send-email-mturquette@linaro.org>
In-Reply-To: <1331366064-1273-3-git-send-email-mturquette@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike,

On 03/10/2012 01:54 AM, Mike Turquette wrote:
> The common clock framework defines a common struct clk useful across
> most platforms as well as an implementation of the clk api that drivers
> can use safely for managing clocks.
> 
> The net result is consolidation of many different struct clk definitions
> and platform-specific clock framework implementations.
> 
> This patch introduces the common struct clk, struct clk_ops and an
> implementation of the well-known clock api in include/clk/clk.h.
> Platforms may define their own hardware-specific clock structure and
> their own clock operation callbacks, so long as it wraps an instance of
> struct clk_hw.
> 
> See Documentation/clk.txt for more details.
> 
> This patch is based on the work of Jeremy Kerr, which in turn was based
> on the work of Ben Herrenschmidt.
> 
> Signed-off-by: Mike Turquette <mturquette@linaro.org>
> Signed-off-by: Mike Turquette <mturquette@ti.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Jeremy Kerr <jeremy.kerr@canonical.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Arnd Bergman <arnd.bergmann@linaro.org>
> Cc: Paul Walmsley <paul@pwsan.com>
> Cc: Shawn Guo <shawn.guo@freescale.com>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Richard Zhao <richard.zhao@linaro.org>
> Cc: Saravana Kannan <skannan@codeaurora.org>
> Cc: Magnus Damm <magnus.damm@gmail.com>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Linus Walleij <linus.walleij@stericsson.com>
> Cc: Stephen Boyd <sboyd@codeaurora.org>
> Cc: Amit Kucheria <amit.kucheria@linaro.org>
> Cc: Deepak Saxena <dsaxena@linaro.org>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Andrew Lunn <andrew@lunn.ch>

snip

> +
> +	/*
> +	 * walk the list of orphan clocks and reparent any that are children of
> +	 * this clock
> +	 */
> +	hlist_for_each_entry(orphan, tmp, &clk_orphan_list, child_node)

In __clk_init, this needs to be hlist_for_each_entry_safe as entries can
be removed.

Rob
