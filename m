Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506Ab1DVSB7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 14:01:59 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:41209 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756423Ab1DVSB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 14:01:57 -0400
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX19dXq9qzq1dosm9MDBmqGWbSv2xSqTLSYZIfsDfNW
	g5ubKOfK6qkW/z
Date: Thu, 21 Apr 2011 21:22:58 +0200
From: torbenh <torbenh@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Saravana Kannan <skannan@codeaurora.org>,
        Paul McKenney <paul.mckenney@linaro.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>, kernel@pengutronix.de,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ben Dooks <ben-linux@fluff.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Paul Mundt <lethal@linux-sh.org>,
        linux-sh <linux-sh@vger.kernel.org>
Subject: Re: [PATCH RFC] clk: add support for automatic parent handling
Message-ID: <20110421192258.GD13755@siel.b>
Mail-Followup-To: Thomas Gleixner <tglx@linutronix.de>,
	Saravana Kannan <skannan@codeaurora.org>,
	Paul McKenney <paul.mckenney@linaro.org>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Stephen Boyd <sboyd@codeaurora.org>,
	Jeremy Kerr <jeremy.kerr@canonical.com>, kernel@pengutronix.de,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Ben Dooks <ben-linux@fluff.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>, Paul Mundt <lethal@linux-sh.org>,
	linux-sh <linux-sh@vger.kernel.org>
References: <alpine.LFD.2.00.1104192339180.2744@localhost6.localdomain6>
 <1303308457-7501-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <alpine.LFD.2.02.1104201704350.3323@ionos>
 <20110420185922.GD31131@pengutronix.de>
 <alpine.LFD.2.02.1104202113250.3323@ionos>
 <4DAFD5AA.9020404@codeaurora.org>
 <alpine.LFD.2.02.1104211147300.3323@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1104211147300.3323@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 12:33:49PM +0200, Thomas Gleixner wrote:
> On Wed, 20 Apr 2011, Saravana Kannan wrote:
> > On 04/20/2011 12:52 PM, Thomas Gleixner wrote:
> > > 2) The "framework" API is just a set of low level primitive helper
> > >     functions
> > > 
> > >     It lacks:
> > > 
> > >     - proper refcounting. clk_get() / clk_put() should do that at the
> > >       framework level.
> > 
> > This has nothing to do with the patches Jeremy made. clk_get()/_put() is in
> > clkdev. Also, I'm not sure if clk_get()/put() needs refcounting. That's like
> > asking kalloc/kfree to have refcounting.
> 
> Ok. I missed the clkdev part.

well... just look at this:

-> git grep __clk_get
arch/arm/mach-bcmring/include/mach/clkdev.h:#define __clk_get(clk) ({ 1; })
arch/arm/mach-davinci/include/mach/clkdev.h:static inline int __clk_get(struct clk *clk)
arch/arm/mach-ep93xx/include/mach/clkdev.h:#define __clk_get(clk) ({ 1; })
arch/arm/mach-integrator/include/mach/clkdev.h:static inline int __clk_get(struct clk *clk)
arch/arm/mach-lpc32xx/include/mach/clkdev.h:#define __clk_get(clk) ({ 1; })
arch/arm/mach-mmp/include/mach/clkdev.h:#define __clk_get(clk) ({ 1; })
arch/arm/mach-msm/include/mach/clkdev.h:static inline int __clk_get(struct clk *clk) { return 1; }
arch/arm/mach-mxs/include/mach/clkdev.h:#define __clk_get(clk) ({ 1; })
arch/arm/mach-nomadik/include/mach/clkdev.h:#define __clk_get(clk) ({ 1; })
arch/arm/mach-nuc93x/include/mach/clkdev.h:#define __clk_get(clk) ({ 1; })
arch/arm/mach-pnx4008/include/mach/clkdev.h:#define __clk_get(clk) ({ 1; })
arch/arm/mach-pxa/include/mach/clkdev.h:#define __clk_get(clk) ({ 1; })
arch/arm/mach-realview/include/mach/clkdev.h:#define __clk_get(clk) ({ 1; })
arch/arm/mach-shmobile/clock.c:int __clk_get(struct clk *clk)
arch/arm/mach-shmobile/clock.c:EXPORT_SYMBOL(__clk_get);
arch/arm/mach-shmobile/include/mach/clkdev.h:int __clk_get(struct clk *clk);
arch/arm/mach-tegra/include/mach/clkdev.h:static inline int __clk_get(struct clk *clk)
arch/arm/mach-u300/clock.c:int __clk_get(struct clk *clk)
arch/arm/mach-u300/clock.c:EXPORT_SYMBOL(__clk_get);
arch/arm/mach-u300/include/mach/clkdev.h:int __clk_get(struct clk *clk);
arch/arm/mach-ux500/include/mach/clkdev.h:#define __clk_get(clk) ({ 1; })
arch/arm/mach-versatile/include/mach/clkdev.h:#define __clk_get(clk) ({ 1; })
arch/arm/mach-vexpress/include/mach/clkdev.h:#define __clk_get(clk) ({ 1; })
arch/arm/mach-w90x900/include/mach/clkdev.h:#define __clk_get(clk) ({ 1; })
arch/arm/plat-mxc/include/mach/clkdev.h:#define __clk_get(clk) ({ 1; })
arch/arm/plat-omap/include/plat/clkdev.h:static inline int __clk_get(struct clk *clk)
arch/arm/plat-spear/include/plat/clkdev.h:#define __clk_get(clk) ({ 1; })
arch/arm/plat-stmp3xxx/include/mach/clkdev.h:#define __clk_get(clk) ({ 1; })
arch/arm/plat-tcc/include/mach/clkdev.h:#define __clk_get(clk) ({ 1; })
arch/sh/include/asm/clkdev.h:#define __clk_get(clk) ({ 1; })
drivers/clk/clkdev.c:   if (clk && !__clk_get(clk))




-- 
torben Hohn
