Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761693Ab2EKGuf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 02:50:35 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15226 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761120Ab2EKGud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 02:50:33 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 10 May 2012 23:49:28 -0700
Date: Fri, 11 May 2012 09:50:12 +0300
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@wwwdotorg.org>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "Grant Likely" <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Colin Cross <ccross@android.com>, "Olof Johansson" <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        "Santosh Shilimkar" <santosh.shilimkar@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, Aneesh V <aneesh@ti.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/4] ARM: tegra20: Add Tegra Memory Controller(MC)
 driver
Message-ID: <20120511095012.57f737d1b0d2536e0d367a9b@nvidia.com>
In-Reply-To: <4FABF9AB.6020902@wwwdotorg.org>
References: <1336635764-30597-1-git-send-email-hdoyu@nvidia.com>
	<4FABF9AB.6020902@wwwdotorg.org>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, Stephen,

On Thu, 10 May 2012 19:23:55 +0200
Stephen Warren <swarren@wwwdotorg.org> wrote:

> On 05/10/2012 01:42 AM, Hiroshi DOYU wrote:
> > Tegra Memory Controller(MC) driver for Tegra20
> > Added to support MC General interrupts, mainly for IOMMU(GART).
> 
> Greg, you appear to have been commiting all of drivers/memory. I assume
> you'll take patches 1 and 3 in this series, and I will take 2 and 4
> through the Tegra tree? I can take them all through the Tegra tree if
> you want. Taking the .dts patches through your tree might cause
> conflicts in 3.6, since I anticipate some DT-wide cleanup in 3.6.
> 
> Hiroshi, one question below (same for patch 3)
> 
> > diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
> 
> > @@ -20,6 +20,8 @@ config ARCH_TEGRA_2x_SOC
> >  	select PL310_ERRATA_727915 if CACHE_L2X0
> >  	select PL310_ERRATA_769419 if CACHE_L2X0
> >  	select CPU_FREQ_TABLE if CPU_FREQ
> > +	select MEMORY
> > +	select TEGRA20_MC
> 
> Does ARCH_TEGRA_2x_SOC /have/ to select these?
> 
> I'd be inclined to drop the change to mach-tegra/Kconfig. As rationale,
> the code works fine without the driver right now. You'd need to make
> config TEGRA*_MC user-visible/selectable though.
> 
> You could replace this change with a patch to tegra_defconfig which
> enables MEMORY and TEGRA*_MC, or perhaps make config TEGRA20_MC default y.

I'm sending the fixup patches, following this mail, since Greg has
already put the original patches in queue. I think that the following
fixup patches could be squashed into the original ones. The fixup
patches are:

  [PATCH 1/3] ARM: tegra20: Make MC optional in Kconfig
  [PATCH 2/3] ARM: tegra30: Make MC optional in Kconfig
  [PATCH 3/3] ARM: tegra: Make TEGRA{20,30}_MC selectable in defconfig

Let me know if it's better to resend the complete patches again.
