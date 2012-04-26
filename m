Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab2DZFuq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 01:50:46 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13367 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab2DZFuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 01:50:44 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 25 Apr 2012 22:50:27 -0700
Date: Thu, 26 Apr 2012 08:49:44 +0300
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Arnd Bergmann <arnd@arndb.de>, "balbi@ti.com" <balbi@ti.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH v2 1/3] ARM: tegra: Add AHB driver
Message-ID: <20120426084944.21e7aa1c3944c906742967a2@nvidia.com>
In-Reply-To: <4F981F6C.2050807@wwwdotorg.org>
References: <1335269116-9578-1-git-send-email-hdoyu@nvidia.com>
	<20120425083747.466f5c98330af8964d980b8c@nvidia.com>
	<20120425074639.GB3423@arwen.pp.htv.fi>
	<201204251215.22889.arnd@arndb.de>
	<4F981F6C.2050807@wwwdotorg.org>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2012 17:59:40 +0200
Stephen Warren <swarren@wwwdotorg.org> wrote:

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

Agree.

Taking a look at AHB spec, this tegra-ahb part is a bit beyond that
spec from S/W POV. If there's other similiar AHB drivers from othere
SoC, we may be able to generalize them, but at the moment, it's hard
to imagine how much/little part is common for similar AHB drivers,
like registers/bit definitions. Most of the part may depends on
SoC/Tegra.

> I'm not really convinced that low-level platform-specific drivers like
> this shouldn't be in the arch/arm/mach-* directories.

So I think that keeping this kind of drivers under
"arch/arm/mach-*" or "drivers/amba" as 'tegra'-ahb.c name. If similier
drivers comes, then, what about thinking the generalization again?
Either way would be ok for me.
