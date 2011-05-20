Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933973Ab1ETNgM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:36:12 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45998 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933714Ab1ETNgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:36:10 -0400
Date: Fri, 20 May 2011 15:36:08 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH 1/4] clk: Add a generic clock infrastructure
Message-ID: <20110520133608.GF10403@pengutronix.de>
References: <1305876469.325655.313573683829.0.gpush@pororo>
 <1305876469.326305.518470530485.1.gpush@pororo>
 <20110520115936.GA10931@pengutronix.de>
 <alpine.LFD.2.02.1105201521560.3078@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1105201521560.3078@ionos>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 15:31:02 up  7:11,  8 users,  load average: 0.00, 0.00, 0.00
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:219:66ff:fe5b:d076
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 03:25:24PM +0200, Thomas Gleixner wrote:
> On Fri, 20 May 2011, Sascha Hauer wrote:
> 
> > Hi Jeremy,
> > 
> > Nice to see progress in this area :)
> > 
> > On Fri, May 20, 2011 at 03:27:49PM +0800, Jeremy Kerr wrote:
> > > +
> > > +struct clk *clk_register(struct clk_hw_ops *ops, struct clk_hw *hw,
> > > +		const char *name)
> > > +{
> > > +	struct clk *clk;
> > > +
> > > +	clk = kzalloc(sizeof(*clk), GFP_KERNEL);
> > > +	if (!clk)
> > > +		return NULL;
> > > +
> > > +	clk->name = name;
> > > +	clk->ops = ops;
> > > +	clk->hw = hw;
> > > +	hw->clk = clk;
> > 
> > is it worth to add a CLK_REGISTERED flag here? Up to now clocks do not
> > have to be registered at all and the registering might be forgotten for
> > some clocks. I suppose funny things can happen when we operate on
> > unregistered clocks.
> 
> No, because not registered clocks are not accessible :)

D'oh :)

> 
>  > +
> > > +	/* Query the hardware for parent and initial rate */
> > > +
> > > +	if (clk->ops->get_parent)
> > > +		/* We don't to lock against prepare/enable here, as
> > > +		 * the clock is not yet accessible from anywhere */
> > > +		clk->parent = clk->ops->get_parent(clk->hw);
> > > +
> > > +	if (clk->ops->recalc_rate)
> > > +		clk->rate = clk->ops->recalc_rate(clk->hw);
> > 
> > This implicitely requires that we never register a clock before its
> > parent is registered. This makes perfect sense but I think we should
> > catch it here when the user tries to register a clock with a not yet
> > registered parent.
> 
> We can agree on that, but we can make it more clever than that.

Great.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
