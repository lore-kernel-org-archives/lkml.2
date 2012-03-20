Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669Ab2CTHTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 03:19:46 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63762 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392Ab2CTHTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 03:19:44 -0400
Date: Tue, 20 Mar 2012 15:20:20 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Walmsley <paul@pwsan.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jamie Iles <jamie@jamieiles.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/2] clk: Move init fields from clk to clk_hw
Message-ID: <20120320072018.GC32469@S2101-09.ap.freescale.net>
References: <CAJOA=zN2cSSpM92oRnW0RyU_ZzyoQ=jthc-fAkf-P3z37uWt7w@mail.gmail.com>
 <1332214706-675-1-git-send-email-skannan@codeaurora.org>
 <1332214706-675-2-git-send-email-skannan@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332214706-675-2-git-send-email-skannan@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 08:38:26PM -0700, Saravana Kannan wrote:
> This has a couple of advantages:
> * Completely hides struct clk from many clock platform drivers and static
>   clock initialization code.
> * Simplifies the generic clk_register() function and allows adding optional
>   fields in the future without modifying the function signature.
> * Allows for simpler static initialization of clocks on all platforms by
>   removing the need for forward delcarations.
> * Halves the number of symbols added for each static clock initialization.
> 
> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>

I agree this is a reasonable move.  But while you simplify the interface
of clk_register(), why not making a further step to simplify the
following interfaces simple too?

struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
                const char *parent_name, unsigned long flags,
                unsigned long fixed_rate);
struct clk *clk_register_gate(struct device *dev, const char *name,
                const char *parent_name, unsigned long flags,
                void __iomem *reg, u8 bit_idx,
                u8 clk_gate_flags, spinlock_t *lock);
struct clk *clk_register_divider(struct device *dev, const char *name,
                const char *parent_name, unsigned long flags,
                void __iomem *reg, u8 shift, u8 width,
                u8 clk_divider_flags, spinlock_t *lock);
struct clk *clk_register_mux(struct device *dev, const char *name,
                char **parent_names, u8 num_parents, unsigned long flags,
                void __iomem *reg, u8 shift, u8 width,
                u8 clk_mux_flags, spinlock_t *lock);

Otherwise,

Acked-by: Shawn Guo <shawn.guo@linaro.org>

-- 
Regards,
Shawn
