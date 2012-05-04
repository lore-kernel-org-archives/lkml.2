Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab2EDFeu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 01:34:50 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3968 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab2EDFes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 01:34:48 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 03 May 2012 22:34:28 -0700
Date: Fri, 4 May 2012 08:34:24 +0300
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Colin Cross <ccross@android.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 1/1] ARM: tegra: Add Tegra Memory Controller(MC) driver
Message-ID: <20120504083424.0f394a6db8e95763e59ae2a0@nvidia.com>
In-Reply-To: <CAOesGMivxdDhkEoZh=LuvtKRPfgXi=8X4chEL-cJazjgeo_ONA@mail.gmail.com>
References: <1336063897-12083-1-git-send-email-hdoyu@nvidia.com>
	<4FA2D0C4.4020608@wwwdotorg.org>
	<CAOesGMivxdDhkEoZh=LuvtKRPfgXi=8X4chEL-cJazjgeo_ONA@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2012 22:13:23 +0200
Olof Johansson <olof@lixom.net> wrote:

> Hi,
> 
> On Thu, May 3, 2012 at 11:39 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> > On 05/03/2012 10:51 AM, Hiroshi DOYU wrote:
> >> Tegra Memory Controller(MC) driver for Tegra20/30.
> >> Added to support MC General interrupts, mainly for IOMMU.
> >
> >> The location of a file may not be suitable because of xxx_driver under arch/arm/mach-*.
> >> ---
> >> diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
> >
> > Russell, Olof, Arnd,
> >
> > Where should this driver be placed? It's a completely Tegra-specific
> > module, and I don't believe there's any drivers/ directory or other
> > subsystem that's appropriate to house it right now. Should we go ahead
> > and create a drivers/arm/ for this? Perhaps drivers/misc/?
> 
> TI just added their memory driver in drivers/memory, and it was merged
> through Greg K-H's driver tree. That would be a good location for this
> one as well.
> 
> > Honestly, to me it seems best to keep purely platform-specific drivers
> > like this in arch/arm/mach-tegra, since that's the most closely
> > Tegra-related directory.
> 
> Since tegra has a custom memory controller it's not as obvious that it
> needs to go in a shared location, indeed. But it's easier to use the
> same practices across platforms, and if there are other vendors that
> end up sharing IP blocks for memory down the road, having them in a
> common location makes sense.

I think that the above TI's patch is:

  Add TI EMIF SDRAM controller driver
    http://lwn.net/Articles/494922/

I'm moving this Tegra MC driver under drivers/memory, "tegra{20,30}-mc.c".
