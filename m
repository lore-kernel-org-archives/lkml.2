Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761651Ab2EJVqL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 17:46:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56997 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761528Ab2EJVqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 17:46:08 -0400
Date: Thu, 10 May 2012 14:46:04 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Hiroshi DOYU <hdoyu@nvidia.com>
Cc: linux-tegra@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, Aneesh V <aneesh@ti.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/4] ARM: tegra30: Add Tegra Memory Controller(MC) driver
Message-ID: <20120510214604.GA3525@kroah.com>
References: <1336635764-30597-1-git-send-email-hdoyu@nvidia.com>
 <1336635764-30597-3-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336635764-30597-3-git-send-email-hdoyu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 10:42:32AM +0300, Hiroshi DOYU wrote:
> Tegra Memory Controller(MC) driver for Tegra30
> Added to support MC General interrupts, mainly for IOMMU(SMMU).

I'll apply this, but:

> +static inline u32 mc_readl(struct tegra30_mc *mc, u32 offs)
> +{
> +	if (offs < 0x10)
> +		return readl(mc->regs[0] + offs);
> +	BUG_ON(offs < 0x3c);
> +	if (offs < 0x1f0)
> +		return readl(mc->regs[1] + offs - 0x3c);
> +	BUG_ON(offs < 0x200);
> +	if (offs < 0x228)
> +		return readl(mc->regs[2] + offs - 0x200);
> +	BUG_ON(offs < 0x284);
> +	if (offs < 0x400)
> +		return readl(mc->regs[3] + offs - 0x284);
> +	BUG();
> +}

That's a lot of BUG* calls.  Same thing with the 1/4 patch in this
series.

We really should not have a BUG call in any driver, as you just stopped
the whole system.  I can understand this being there for debugging when
you create the code originally, but as these are things no one should
ever be able to hit now, you should remove them, right?

Care to write a follow-on patch removing all of these BUG_ON and BUG
calls in this and the drivers/memory/tegra20-mc.c driver?

thanks,

greg k-h
