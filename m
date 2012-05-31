Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab2EaJGG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 05:06:06 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4139 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab2EaJGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 05:06:04 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 31 May 2012 02:05:52 -0700
Date: Thu, 31 May 2012 12:05:18 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Felipe Balbi <balbi@ti.com>
CC: Stephen Boyd <sboyd@codeaurora.org>, Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@ti.com>
Subject: Re: [RFC PATCH] clk: add extension API
Message-ID: <20120531090518.GR8026@tbergstrom-lnx.Nvidia.com>
References: <1338285540-24407-1-git-send-email-pdeschrijver@nvidia.com>
 <4FC5DFCF.1020606@codeaurora.org>
 <20120531075125.GL8026@tbergstrom-lnx.Nvidia.com>
 <20120531081841.GG5377@arwen.pp.htv.fi>
 <20120531083131.GQ8026@tbergstrom-lnx.Nvidia.com>
 <20120531085432.GK5377@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120531085432.GK5377@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> What if a module needs two clocks and you drive the reset on both of the
> clocks ? What would happen ?
> 

Only 'leave clocks' have this reset method and a module can only have 1 of
them.

> > but then we would have the keep a list of IDs (1 per module) which the drivers
> > can use to call some tegra reset function which would in the end use registers
> > in the same memory area to cause a reset. (the registers controlling
> > modulereset are interleaved with those controlling the enable/disable of the
> > main moduleclock and bitpositions are identical)
> 
> Well, under a generic device-level API, you could just call an internal
> clk_reset() function because you know which clocks feed into which
> devices anyway. It could look something like:
> 
> on Tegra:
> 
> device_reset(dev)
> 	-> dev_pm_domain->reset()
> 		-> tegra_periph_reset()
> 

These methods are also needed internally by the powergating code.

> on OMAP:
> 
> device_reset(dev)
> 	-> dev_pm_domain->reset()
> 		-> omap_hwmod_reset()
> 
> 
> btw:
> 
> tegra_periph_reset(....)
> {
> 	tegra_periph_reset_assert(...);
> 	udelay(2);
> 	tegra_periph_reset_deassert(...);
> }

which uses the clockframework currently.

Cheers,

Peter.
