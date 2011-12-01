Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab1LAOmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 09:42:21 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35029 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab1LAOmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 09:42:20 -0500
Date: Thu, 1 Dec 2011 14:42:05 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: "Turquette, Mike" <mturquette@ti.com>, linux@arm.linux.org.uk,
        linus.walleij@stericsson.com, patches@linaro.org,
        shawn.guo@freescale.com, magnus.damm@gmail.com,
        linux-kernel@vger.kernel.org, amit.kucheria@linaro.org,
        richard.zhao@linaro.org, grant.likely@secretlab.ca, dsaxena@linaro.org,
        eric.miao@linaro.org, sboyd@quicinc.com, skannan@quicinc.com,
        linaro-dev@lists.linaro.org, jeremy.kerr@canonical.com,
        linux-omap@vger.kernel.org, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, arnd.bergmann@linaro.org
Subject: Re: [PATCH v3 3/5] clk: introduce the common clock framework
Message-ID: <20111201144205.GA2103@sirena.org.uk>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org>
 <1321926047-14211-4-git-send-email-mturquette@linaro.org>
 <alpine.DEB.2.00.1111291619110.6289@utopia.booyaka.com>
 <CAJOA=zM4vcyTt_RBEVm6JxmzW-Dna0gpuWda7ytq_mqFSuXw9g@mail.gmail.com>
 <alpine.DEB.2.00.1111302308280.6289@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1111302308280.6289@utopia.booyaka.com>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 11:39:59PM -0700, Paul Walmsley wrote:

> Clock rate/parent-change notifiers are requirements for DVFS use-cases, 
> and they must be paired with something like the 
> clk_{allow,block}_rate_change() functions to work efficiently.  I intend 
> to comment on this later; it's not a simple problem.  It might be worth 
> noting that Tero and I implemented a simplified version of this for the 
> N900.

I'm thinking that if we're going to have clk_{allow,block}_rate_change()
we may as well make that the main interface to enable rate changes - if
a device wants to change the clock rate it allows rate changes using
that interface rather than by disabling the clocks.  I've got devices
which can do glitch free updates of active clocks so having to disable
would be a real restriction, and cpufreq would have issues with actually
disabling the clock too I expect.
