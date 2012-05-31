Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400Ab2EaMBH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 08:01:07 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44017 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620Ab2EaMBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 08:01:06 -0400
Date: Thu, 31 May 2012 13:00:58 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Felipe Balbi <balbi@ti.com>, Russell King <linux@arm.linux.org.uk>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@ti.com>
Subject: Re: [RFC PATCH] clk: add extension API
Message-ID: <20120531120057.GA15786@sirena.org.uk>
References: <1338285540-24407-1-git-send-email-pdeschrijver@nvidia.com>
 <4FC5DFCF.1020606@codeaurora.org>
 <20120531075125.GL8026@tbergstrom-lnx.Nvidia.com>
 <20120531081841.GG5377@arwen.pp.htv.fi>
 <20120531083131.GQ8026@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120531083131.GQ8026@tbergstrom-lnx.Nvidia.com>
X-Cookie: Here there be tygers.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 11:31:31AM +0300, Peter De Schrijver wrote:

> > What I wonder most is if this should be done at the clock level or at
> > the device level. In the end you reset the IP block, not the clock,
> > right ?

> Yes. but, every block has at least 1 clock and thus the mapping is identical
> down to the register level. Ie. we could do this outside the clockframework,
> but then we would have the keep a list of IDs (1 per module) which the drivers
> can use to call some tegra reset function which would in the end use registers
> in the same memory area to cause a reset. (the registers controlling
> modulereset are interleaved with those controlling the enable/disable of the
> main moduleclock and bitpositions are identical)

One option which doesn't really need anything from the clock API is for
the module resets to restore these registers so the clock API never
notices anything changed.
