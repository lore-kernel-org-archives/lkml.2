Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169Ab2EDNAv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 09:00:51 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8308 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756794Ab2EDNAt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 09:00:49 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 04 May 2012 06:00:41 -0700
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>
CC: "olof@lixom.net" <olof@lixom.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "ccross@android.com" <ccross@android.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Date: Fri, 4 May 2012 15:00:35 +0200
Subject: Re: [PATCH 1/1] ARM: tegra: Add Tegra Memory Controller(MC) driver
Thread-Topic: [PATCH 1/1] ARM: tegra: Add Tegra Memory Controller(MC) driver
Thread-Index: Ac0p9eZxIZt6T5vxTCy1CcyHkSNUKQ==
Message-ID: <20120504.160035.1828735037330038337.hdoyu@nvidia.com>
References: <1336063897-12083-1-git-send-email-hdoyu@nvidia.com><4FA2D0C4.4020608@wwwdotorg.org>
In-Reply-To: <4FA2D0C4.4020608@wwwdotorg.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH 1/1] ARM: tegra: Add Tegra Memory Controller(MC) driver
Date: Thu, 3 May 2012 20:39:00 +0200
Message-ID: <4FA2D0C4.4020608@wwwdotorg.org>

> On 05/03/2012 10:51 AM, Hiroshi DOYU wrote:
> > Tegra Memory Controller(MC) driver for Tegra20/30.
> > Added to support MC General interrupts, mainly for IOMMU.
> 
> > The location of a file may not be suitable because of xxx_driver under arch/arm/mach-*.
> > ---
> > diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
> 
> Russell, Olof, Arnd,
> 
> Where should this driver be placed? It's a completely Tegra-specific
> module, and I don't believe there's any drivers/ directory or other
> subsystem that's appropriate to house it right now. Should we go ahead
> and create a drivers/arm/ for this? Perhaps drivers/misc/?
> 
> Honestly, to me it seems best to keep purely platform-specific drivers
> like this in arch/arm/mach-tegra, since that's the most closely
> Tegra-related directory.
> 
> Hiroshi,
> 
> This driver attempts to cover both Tegra20 and Tegra30. However, there's
> almost no common code. I think it'd be best as separate tegra20-mc.c and
> tegra30-mc.c.
> 
> This patch should include DT binding documentation.
> 
> That all said, I'd hold off on reposting this until we work out how the
> MC/GART/SMMU parent-child relationship stuff is worked out; see my
> immediately previous email.

Ok.

What about the following AHB patches? AHB patches are independent of
MC/GART/SMMU DT issue basically. If you think that they are ready to
merge, I'll post the update version, I fixed some of your latest
comments.

 [PATCH 1/3] ARM: tegra: Add Tegra AHB driver
 [PATCH 2/3] ARM: tegra: Add SMMU enabler in AHB
 [PATCH 3/3] ARM: dt: tegra: Add device tree support for AHB


I'll hold off on the following until we get some direction for
MC/GART/SMMU. They are related to how dt info is passed via MC.

 [PATCH 1/3] ARM: tegra: Add Tegra Memory Controller(MC) driver
 [PATCH 2/3] ARM: dt: tegra: Add device tree support for Memory Controller(MC)
 [PATCH 3/3] iommu/tegra: smmu: Refrain from accessing to AHB
