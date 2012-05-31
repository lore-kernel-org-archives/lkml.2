Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab2EaJnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 05:43:47 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15348 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab2EaJnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 05:43:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 31 May 2012 02:41:48 -0700
Date: Thu, 31 May 2012 12:43:01 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Felipe Balbi <balbi@ti.com>
CC: Stephen Boyd <sboyd@codeaurora.org>, Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@ti.com>
Subject: Re: [RFC PATCH] clk: add extension API
Message-ID: <20120531094301.GT8026@tbergstrom-lnx.Nvidia.com>
References: <1338285540-24407-1-git-send-email-pdeschrijver@nvidia.com>
 <4FC5DFCF.1020606@codeaurora.org>
 <20120531075125.GL8026@tbergstrom-lnx.Nvidia.com>
 <20120531081841.GG5377@arwen.pp.htv.fi>
 <20120531083131.GQ8026@tbergstrom-lnx.Nvidia.com>
 <20120531085432.GK5377@arwen.pp.htv.fi>
 <20120531090518.GR8026@tbergstrom-lnx.Nvidia.com>
 <20120531092603.GM5377@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120531092603.GM5377@arwen.pp.htv.fi>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > on Tegra:
> > > 
> > > device_reset(dev)
> > > 	-> dev_pm_domain->reset()
> > > 		-> tegra_periph_reset()
> > > 
> > 
> > These methods are also needed internally by the powergating code.
> 
> so ? Just call them when you need...
> 

the powergating code calls assert and deassert indepedently
ie:

tegra_periph_reset_assert()

do stuff

tegra_periph_reset_assert()

> > > on OMAP:
> > > 
> > > device_reset(dev)
> > > 	-> dev_pm_domain->reset()
> > > 		-> omap_hwmod_reset()
> > > 
> > > 
> > > btw:
> > > 
> > > tegra_periph_reset(....)
> > > {
> > > 	tegra_periph_reset_assert(...);
> > > 	udelay(2);
> > > 	tegra_periph_reset_deassert(...);
> > > }
> > 
> > which uses the clockframework currently.
> 
> no problems there. The point is that you already know which clock feed
> into which device, so if you have a device-based API for device
> soft-reset, you can figure out which exact clock to toggle, right ?

you have the struct clk, you could dive into that and grab clk_hw and call
some function directly. But sounds quite horrible to me.

Cheers,

Peter.
