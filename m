Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111Ab2ECSjG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 14:39:06 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34415 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001Ab2ECSjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 14:39:04 -0400
Message-ID: <4FA2D0C4.4020608@wwwdotorg.org>
Date: Thu, 03 May 2012 12:39:00 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Hiroshi DOYU <hdoyu@nvidia.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
CC: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Colin Cross <ccross@android.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 1/1] ARM: tegra: Add Tegra Memory Controller(MC) driver
References: <1336063897-12083-1-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1336063897-12083-1-git-send-email-hdoyu@nvidia.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2012 10:51 AM, Hiroshi DOYU wrote:
> Tegra Memory Controller(MC) driver for Tegra20/30.
> Added to support MC General interrupts, mainly for IOMMU.

> The location of a file may not be suitable because of xxx_driver under arch/arm/mach-*.
> ---
> diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile

Russell, Olof, Arnd,

Where should this driver be placed? It's a completely Tegra-specific
module, and I don't believe there's any drivers/ directory or other
subsystem that's appropriate to house it right now. Should we go ahead
and create a drivers/arm/ for this? Perhaps drivers/misc/?

Honestly, to me it seems best to keep purely platform-specific drivers
like this in arch/arm/mach-tegra, since that's the most closely
Tegra-related directory.

Hiroshi,

This driver attempts to cover both Tegra20 and Tegra30. However, there's
almost no common code. I think it'd be best as separate tegra20-mc.c and
tegra30-mc.c.

This patch should include DT binding documentation.

That all said, I'd hold off on reposting this until we work out how the
MC/GART/SMMU parent-child relationship stuff is worked out; see my
immediately previous email.
