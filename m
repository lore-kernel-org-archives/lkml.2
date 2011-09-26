Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab1IZThl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 15:37:41 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49459 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907Ab1IZThk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 15:37:40 -0400
Date: Mon, 26 Sep 2011 20:37:33 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Jamie Iles <jamie@jamieiles.com>, Mike Turquette <mturquette@ti.com>,
        linux-kernel@vger.kernel.org, paul@pwsan.com,
        linaro-dev@lists.linaro.org, linus.walleij@stericsson.com,
        patches@linaro.org, eric.miao@linaro.org,
        broonie@opensource.wolfsonmicro.com, magnus.damm@gmail.com,
        arnd.bergmann@linaro.org, skannan@quicinc.com, linux@arm.linux.org.uk,
        jeremy.kerr@canonical.com, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, sboyd@quiinc.com
Subject: Re: [PATCH v2 4/7] clk: Add simple gated clock
Message-ID: <20110926193733.GC9194@gallagher>
References: <1316730422-20027-1-git-send-email-mturquette@ti.com>
 <1316730422-20027-5-git-send-email-mturquette@ti.com>
 <4E80C564.3050004@gmail.com>
 <20110926184024.GB9194@gallagher>
 <4E80CE28.9030103@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E80CE28.9030103@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 02:10:32PM -0500, Rob Herring wrote:
> On 09/26/2011 01:40 PM, Jamie Iles wrote:
> > On Mon, Sep 26, 2011 at 01:33:08PM -0500, Rob Herring wrote:
> >>> +static void clk_gate_set_bit(struct clk_hw *clk)
> >>> +{
> >>> +	struct clk_gate *gate = to_clk_gate(clk);
> >>> +	u32 reg;
> >>> +
> >>> +	reg = __raw_readl(gate->reg);
> >>> +	reg |= BIT(gate->bit_idx);
> >>> +	__raw_writel(reg, gate->reg);
> >>
> >> Don't these read-mod-writes need a spinlock around it?
> >>
> >> It's possible to have an enable bits and dividers in the same register.
> >> If you did a set_rate and while doing an enable/disable, there would be
> >> a problem. Also, it may be 2 different clocks in the same register, so
> >> the spinlock needs to be shared and not per clock.
> > 
> > Well the prepare lock will be held here and I believe that would be 
> > sufficient.
> 
> No, the enable spinlock is protecting enable/disable. But set_rate is
> protected by the prepare mutex. So you clearly don't need locking if you
> have a register of only 1 bit enables. If you have a register accessed
> by both enable/disable and prepare/unprepare/set_rate, then you need
> some protection.

OK fair point, but I would guess that if you had a clock like this then 
you probably wouldn't use this simple gated clock would you?  (speaking 
from my world where we have quite simple clocks ;-))

Jamie
