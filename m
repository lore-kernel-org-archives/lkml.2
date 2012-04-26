Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab2DZIPL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 04:15:11 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19073 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab2DZIPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 04:15:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 26 Apr 2012 01:14:37 -0700
Date: Thu, 26 Apr 2012 11:14:09 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "balbi@ti.com" <balbi@ti.com>, Rob Herring <rob.herring@calxeda.com>,
        Colin Cross <ccross@android.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [PATCH v2 1/3] ARM: tegra: Add AHB driver
Message-ID: <20120426081409.GI514@tbergstrom-lnx.Nvidia.com>
References: <1335269116-9578-1-git-send-email-hdoyu@nvidia.com>
 <20120425083747.466f5c98330af8964d980b8c@nvidia.com>
 <20120425074639.GB3423@arwen.pp.htv.fi>
 <201204251215.22889.arnd@arndb.de>
 <4F981F6C.2050807@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4F981F6C.2050807@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 05:59:40PM +0200, Stephen Warren wrote:
> On 04/25/2012 06:15 AM, Arnd Bergmann wrote:
> > On Wednesday 25 April 2012, Felipe Balbi wrote:
> ...
> >>> Can this driver be located under "drivers/misc"? Or is there any better place?
> >>
> >> maybe drivers/platform/arm/ ??
> > 
> > I really wouldn't want to add that directory: It has the risk of letting
> > people add random crap there that may or may not be related to ARM (the
> > company) and/or ARM (the architecture).
> > 
> > I think it could go into drivers/amba/ along with the primecell bus driver.
> > The two drivers are for two different aspects of the AMBA spec and don't
> > actually depend on one another as far as I can tell, but it's at least
> > a fitting name, and it doesn't depend on the ARM architecture, which is
> > important because the driver could be used on other architectures that
> > are connected to an AHB bus.
> 
> Hiroshi, is this driver for something (registers/features) that AMBA
> actually specifies? AHB might be part of AMBA (I'm not familiar enough
> to know), but I don't think this aspect of Tegra's AHB bus is part of
> any core AHB/AMBA specification, rather than being some Tegra-specific
> control over the bus (given that the registers and bits correspond to
> Tegra-specific devices on the bus).
> 

The HW controlled by this 'driver' is roughly: the AHB arbiter, glue logic
between IP blocks and the AHB bus and AHB memory controller slave. All of
these are tegra specific AFAIK. So I don't see much point in a generic
driver.

Cheers,

Peter.
