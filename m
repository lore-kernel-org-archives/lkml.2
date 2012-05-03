Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132Ab2ECUN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 16:13:26 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45015 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876Ab2ECUNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 16:13:24 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:37a9]
In-Reply-To: <4FA2D0C4.4020608@wwwdotorg.org>
References: <1336063897-12083-1-git-send-email-hdoyu@nvidia.com>
	<4FA2D0C4.4020608@wwwdotorg.org>
Date: Thu, 3 May 2012 13:13:23 -0700
Message-ID: <CAOesGMivxdDhkEoZh=LuvtKRPfgXi=8X4chEL-cJazjgeo_ONA@mail.gmail.com>
Subject: Re: [PATCH 1/1] ARM: tegra: Add Tegra Memory Controller(MC) driver
From: Olof Johansson <olof@lixom.net>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Hiroshi DOYU <hdoyu@nvidia.com>, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Colin Cross <ccross@android.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, May 3, 2012 at 11:39 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 05/03/2012 10:51 AM, Hiroshi DOYU wrote:
>> Tegra Memory Controller(MC) driver for Tegra20/30.
>> Added to support MC General interrupts, mainly for IOMMU.
>
>> The location of a file may not be suitable because of xxx_driver under arch/arm/mach-*.
>> ---
>> diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
>
> Russell, Olof, Arnd,
>
> Where should this driver be placed? It's a completely Tegra-specific
> module, and I don't believe there's any drivers/ directory or other
> subsystem that's appropriate to house it right now. Should we go ahead
> and create a drivers/arm/ for this? Perhaps drivers/misc/?

TI just added their memory driver in drivers/memory, and it was merged
through Greg K-H's driver tree. That would be a good location for this
one as well.

> Honestly, to me it seems best to keep purely platform-specific drivers
> like this in arch/arm/mach-tegra, since that's the most closely
> Tegra-related directory.

Since tegra has a custom memory controller it's not as obvious that it
needs to go in a shared location, indeed. But it's easier to use the
same practices across platforms, and if there are other vendors that
end up sharing IP blocks for memory down the road, having them in a
common location makes sense.


-Olof
