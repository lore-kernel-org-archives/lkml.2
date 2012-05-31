Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab2EaJLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 05:11:42 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11938 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab2EaJLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 05:11:40 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 31 May 2012 02:11:13 -0700
Date: Thu, 31 May 2012 12:10:40 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@ti.com>
Subject: Re: [RFC PATCH] clk: add extension API
Message-ID: <20120531091040.GS8026@tbergstrom-lnx.Nvidia.com>
References: <1338285540-24407-1-git-send-email-pdeschrijver@nvidia.com>
 <4FC5DFCF.1020606@codeaurora.org>
 <20120531075125.GL8026@tbergstrom-lnx.Nvidia.com>
 <4FC73424.80107@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4FC73424.80107@codeaurora.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 11:04:36AM +0200, Stephen Boyd wrote:
> On 5/31/2012 12:51 AM, Peter De Schrijver wrote:
> > On Wed, May 30, 2012 at 10:52:31AM +0200, Stephen Boyd wrote:
> >> On 5/29/2012 2:58 AM, Peter De Schrijver wrote:
> >>> Add an extension API for clocks. This allows clocktypes to provide extensions
> >>> for features which are uncommon and cannot be easily mapped onto normal clock
> >>> framework concecpts. eg: resetting blocks, configuring clock phase etc.
> >> This seems rather generic. Why not add more specific APIs/concepts like
> >> clk_reset(), clk_set_phase(), etc.? If they don't map, maybe we should
> >> make them map.
> >>
> > Some of those might be very SoC specific. Eg OMAP doesn't need software
> > controlled modulereset. I don't think we should add a new function to the
> > clock framework for clock related features which only exist in a single
> > SoC or family. Ideally we could use inheritance to add methods to derived
> > clocktypes, but that's not really possible in C unfortunately.
> 
> Most likely your hardware is not that special and the functionality you
> think exists only on your SoC actually exists on 5 others. MSM needs
> software resets too and we also associate them with each clock (there
> can be many clocks for one device and one reset for each clock). We use
> them mostly for the power domain code (looks like tegra and omap do the
> same thing albeit slightly differently).
> 
> What do you plan to support under this API?

Anything which isn't available on other SoCs. If it is available, then we
could indeed add another method. I guess this will need to be decided on
a case by case basis.

Cheers,

Peter.
