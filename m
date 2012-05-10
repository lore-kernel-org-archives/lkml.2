Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935Ab2EJRYC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:24:02 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39717 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab2EJRX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:23:59 -0400
Message-ID: <4FABF9AB.6020902@wwwdotorg.org>
Date: Thu, 10 May 2012 11:23:55 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Hiroshi DOYU <hdoyu@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-tegra@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, Aneesh V <aneesh@ti.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/4] ARM: tegra20: Add Tegra Memory Controller(MC) driver
References: <1336635764-30597-1-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1336635764-30597-1-git-send-email-hdoyu@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2012 01:42 AM, Hiroshi DOYU wrote:
> Tegra Memory Controller(MC) driver for Tegra20
> Added to support MC General interrupts, mainly for IOMMU(GART).

Greg, you appear to have been commiting all of drivers/memory. I assume
you'll take patches 1 and 3 in this series, and I will take 2 and 4
through the Tegra tree? I can take them all through the Tegra tree if
you want. Taking the .dts patches through your tree might cause
conflicts in 3.6, since I anticipate some DT-wide cleanup in 3.6.

Hiroshi, one question below (same for patch 3)

> diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig

> @@ -20,6 +20,8 @@ config ARCH_TEGRA_2x_SOC
>  	select PL310_ERRATA_727915 if CACHE_L2X0
>  	select PL310_ERRATA_769419 if CACHE_L2X0
>  	select CPU_FREQ_TABLE if CPU_FREQ
> +	select MEMORY
> +	select TEGRA20_MC

Does ARCH_TEGRA_2x_SOC /have/ to select these?

I'd be inclined to drop the change to mach-tegra/Kconfig. As rationale,
the code works fine without the driver right now. You'd need to make
config TEGRA*_MC user-visible/selectable though.

You could replace this change with a patch to tegra_defconfig which
enables MEMORY and TEGRA*_MC, or perhaps make config TEGRA20_MC default y.

What are people's thoughts here?

Aside from this, the series looks fine to me.
