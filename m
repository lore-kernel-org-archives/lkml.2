Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab1LASaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 13:30:19 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:57175 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756091Ab1LASaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 13:30:17 -0500
Date: Thu, 1 Dec 2011 11:30:16 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: "Turquette, Mike" <mturquette@ti.com>, linux@arm.linux.org.uk,
        linus.walleij@stericsson.com, patches@linaro.org,
        shawn.guo@freescale.com, magnus.damm@gmail.com,
        linux-kernel@vger.kernel.org, amit.kucheria@linaro.org,
        richard.zhao@linaro.org, grant.likely@secretlab.ca, dsaxena@linaro.org,
        eric.miao@linaro.org, sboyd@quicinc.com, skannan@quicinc.com,
        linaro-dev@lists.linaro.org, jeremy.kerr@canonical.com,
        linux-omap@vger.kernel.org, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, arnd.bergmann@linaro.org
Subject: Re: [PATCH v3 3/5] clk: introduce the common clock framework
In-Reply-To: <20111201144205.GA2103@sirena.org.uk>
Message-ID: <alpine.DEB.2.00.1112011124221.6289@utopia.booyaka.com>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org> <1321926047-14211-4-git-send-email-mturquette@linaro.org> <alpine.DEB.2.00.1111291619110.6289@utopia.booyaka.com> <CAJOA=zM4vcyTt_RBEVm6JxmzW-Dna0gpuWda7ytq_mqFSuXw9g@mail.gmail.com>
 <alpine.DEB.2.00.1111302308280.6289@utopia.booyaka.com> <20111201144205.GA2103@sirena.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Thu, 1 Dec 2011, Mark Brown wrote:

> On Wed, Nov 30, 2011 at 11:39:59PM -0700, Paul Walmsley wrote:
> 
> > Clock rate/parent-change notifiers are requirements for DVFS use-cases, 
> > and they must be paired with something like the 
> > clk_{allow,block}_rate_change() functions to work efficiently.  I intend 
> > to comment on this later; it's not a simple problem.  It might be worth 
> > noting that Tero and I implemented a simplified version of this for the 
> > N900.
> 
> I'm thinking that if we're going to have clk_{allow,block}_rate_change()
> we may as well make that the main interface to enable rate changes - if
> a device wants to change the clock rate it allows rate changes using
> that interface rather than by disabling the clocks.  I've got devices
> which can do glitch free updates of active clocks so having to disable
> would be a real restriction, and cpufreq would have issues with actually
> disabling the clock too I expect.

The intention behind the clk_{allow,block}_rate_change() proposal was to 
allow the current user of the clock to change its rate without having to 
call clk_{allow,block}_rate_change(), if that driver was the sole user of 
the clock.

So for example, if you had a driver that did:

c = clk_get(dev, clk_name);
clk_enable(c);
clk_set_rate(c, clk_rate);

and c was currently not enabled by any other driver on the system, and 
nothing else had called clk_block_rate_change(c), then the rate change 
would be allowed to proceed.  (modulo any notifier activity, etc.)  

So clk_{allow,block}_rate_change() was simply intended to allow or 
restrict other users of the same clock, not the current user.


- Paul
