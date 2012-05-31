Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab2EaIcg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 04:32:36 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1110 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758107Ab2EaIcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 04:32:33 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 31 May 2012 01:30:18 -0700
Date: Thu, 31 May 2012 11:31:31 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Felipe Balbi <balbi@ti.com>
CC: Stephen Boyd <sboyd@codeaurora.org>, Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@ti.com>
Subject: Re: [RFC PATCH] clk: add extension API
Message-ID: <20120531083131.GQ8026@tbergstrom-lnx.Nvidia.com>
References: <1338285540-24407-1-git-send-email-pdeschrijver@nvidia.com>
 <4FC5DFCF.1020606@codeaurora.org>
 <20120531075125.GL8026@tbergstrom-lnx.Nvidia.com>
 <20120531081841.GG5377@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120531081841.GG5377@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 10:18:42AM +0200, Felipe Balbi wrote:
> * PGP Signed by an unknown key
> 
> On Thu, May 31, 2012 at 10:51:25AM +0300, Peter De Schrijver wrote:
> > On Wed, May 30, 2012 at 10:52:31AM +0200, Stephen Boyd wrote:
> > > On 5/29/2012 2:58 AM, Peter De Schrijver wrote:
> > > > Add an extension API for clocks. This allows clocktypes to provide extensions
> > > > for features which are uncommon and cannot be easily mapped onto normal clock
> > > > framework concecpts. eg: resetting blocks, configuring clock phase etc.
> > > 
> > > This seems rather generic. Why not add more specific APIs/concepts like
> > > clk_reset(), clk_set_phase(), etc.? If they don't map, maybe we should
> > > make them map.
> > > 
> > 
> > Some of those might be very SoC specific. Eg OMAP doesn't need software
> > controlled modulereset. I don't think we should add a new function to the
> 
> it depends on what you call modulereset. We have soft-reset logic hidden
> under the hood, it's done before device creation, so drivers (most of
> them) assume we're probe with the IP in reset state.
> 
> What I wonder most is if this should be done at the clock level or at
> the device level. In the end you reset the IP block, not the clock,
> right ?

Yes. but, every block has at least 1 clock and thus the mapping is identical
down to the register level. Ie. we could do this outside the clockframework,
but then we would have the keep a list of IDs (1 per module) which the drivers
can use to call some tegra reset function which would in the end use registers
in the same memory area to cause a reset. (the registers controlling
modulereset are interleaved with those controlling the enable/disable of the
main moduleclock and bitpositions are identical)

Cheers,

Peter.
