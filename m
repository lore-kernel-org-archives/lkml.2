Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964844Ab1GOFFQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 01:05:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48766 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932307Ab1GOFFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 01:05:14 -0400
Date: Fri, 15 Jul 2011 14:05:05 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>, Grant Likely <grant@secretlab.ca>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sh@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 6/6] clk: Add initial WM831x clock driver
Message-ID: <20110715050503.GL32716@opensource.wolfsonmicro.com>
References: <20110711025344.GA27497@opensource.wolfsonmicro.com>
 <1310352837-4277-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1310352837-4277-6-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20110715025339.GO2927@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110715025339.GO2927@ponder.secretlab.ca>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 08:53:39PM -0600, Grant Likely wrote:
> On Mon, Jul 11, 2011 at 11:53:57AM +0900, Mark Brown wrote:

> > @@ -10,6 +10,7 @@ config GENERIC_CLK_BUILD_TEST
> >  	depends on EXPERIMENTAL && GENERIC_CLK
> >  	select GENERIC_CLK_FIXED
> >  	select GENERIC_CLK_GATE
> > +	select GENERIC_CLK_WM831X if MFD_WM831X=y

> Hmmm, this could get unwieldy in a hurry.

It's not really any hassle, we've got a one of these in ASoC.  The list
gets long but if you keep it sorted it's not an issue for merges and
otherwise it's just long not complicated.  The ability to get build
coverage is *really* useful.

> > +static int wm831x_xtal_enable(struct clk_hw *hw)
> > +{
> > +	struct wm831x_clk *clkdata = container_of(hw, struct wm831x_clk,
> > +						  xtal_hw);

> This container of is used 10 times.  A static inline would be
> reasonable.

Not quite - it's used in three different variants (one for each of the
clocks).

> > +	if (clkdata->xtal_ena)
> > +		return 0;
> > +	else
> > +		return -EPERM;
> > +}

> Nit: return clkdata->xtal_ena ? 0 : -EPERM;

> Just makes for more concise code.

I have an extremely strong dislike of the ternery operator, I find it
does nothing for legibility.

> > +	if (!clk_register(wm831x->dev, &wm831x_clkout_ops, &clkdata->clkout_hw,
> > +			  "clkout")) {
> > +		ret = -EINVAL;
> > +		goto err_fll;
> > +	}

> How common will this pattern be?  Is there need for a
> clk_register_many() variant?

I dunno, I think a lot of the SoCs may be doing one clk per device.  But
equally well it's not like it'd be hard if someone starts working on the
API again.
