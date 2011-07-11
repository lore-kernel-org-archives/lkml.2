Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab1GKKqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 06:46:32 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36701 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794Ab1GKKqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 06:46:31 -0400
Date: Mon, 11 Jul 2011 12:46:25 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Grant Likely <grant@secretlab.ca>, patches@opensource.wolfsonmicro.com,
        linux-sh@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/6] clk: Initial feedback for off-SoC slow bus clocks
Message-ID: <20110711104625.GH26347@pengutronix.de>
References: <20110711025344.GA27497@opensource.wolfsonmicro.com>
 <20110711093124.GA3239@n2100.arm.linux.org.uk>
 <20110711100759.GG26347@pengutronix.de>
 <20110711102856.GG3239@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110711102856.GG3239@n2100.arm.linux.org.uk>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:40:41 up 19 days, 16:27, 55 users,  load average: 0.22, 0.91,
 1.14
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 11:28:56AM +0100, Russell King - ARM Linux wrote:
> On Mon, Jul 11, 2011 at 12:07:59PM +0200, Sascha Hauer wrote:
> > On Mon, Jul 11, 2011 at 10:31:24AM +0100, Russell King - ARM Linux wrote:
> > > On Mon, Jul 11, 2011 at 11:53:44AM +0900, Mark Brown wrote:
> > > > The biggest issue I ran into was that as the clocks are all registered
> > > > by name with the API if you've got two instances of the same off-SoC
> > > > device in the system you'll not be able to disambiguate between the
> > > > clocks it provides.
> > > 
> > > Sigh.  That sounds like yet more trash.  Obviously whoever thought
> > > up that doesn't actually understand clks.
> > 
> > Nope. In the patches Jeremy posted clocks have a name, but this name
> > is not meant to be used with clk_get. clk_get is still implemented
> > in clkdev, so the matching between clocks and devices is independent
> > of the clock name.
> > 
> > In earlier versions of Jeremys patches the clock name was only present
> > when debugfs was compiled in and I think it can be changed back to this.
> > 
> > That said the debugfs support (which is not present in Jeremys latest
> > series) would break if two clocks with the same name have the same
> > parent, because the clock core would try to create to debugfs entries
> > with the same name.
> 
> If that's all its for, then can't some other solution for debugfs names
> (lets stop calling them clock names to avoid confusion) be found -
> such as
> 
> 	sprintf(debugfsname, "%s@%p", clk->debugfsprefix, clk);
> 

Sounds good. During my tests on i.MX I found it very convenient to have
speaking debugfs names, so I vote for this suggestion instead the
following ones.

> Or how about using something like this:
> 
> $debugfs/clkdev/device/connection -> ../../clk/<name-of-clk>
> $debugfs/clk/<name-of-clk>
> 
> where <name-of-clk> could just be the address of the struct clk (which
> eliminates the need to pass any names in) or some prefix plus an
> incrementing identifier, or just an incrementing number.
> 
> I did think about introducing such a scheme along with clkdev (and did
> have some code but that's long gone), but without the $debugfs/clk/ bit
> being standardized, it wouldn't have worked.
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
