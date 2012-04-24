Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437Ab2DXT7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 15:59:33 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54667 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757170Ab2DXT7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 15:59:32 -0400
Date: Tue, 24 Apr 2012 20:59:02 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Hiroshi DOYU <hdoyu@nvidia.com>
Cc: linux-tegra@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tony Lindgren <tony@atomide.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Jamie Iles <jamie@jamieiles.com>,
        Rob Herring <rob.herring@calxeda.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] ARM: tegra: Add SMMU enabler in AHB
Message-ID: <20120424195901.GC3628@n2100.arm.linux.org.uk>
References: <1335269116-9578-1-git-send-email-hdoyu@nvidia.com> <1335269116-9578-2-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335269116-9578-2-git-send-email-hdoyu@nvidia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 03:05:15PM +0300, Hiroshi DOYU wrote:
> +#define AHB_ARBITRATION_XBAR_CTRL_SMMU_INIT_DONE_DONE	1
> +#define AHB_ARBITRATION_XBAR_CTRL_SMMU_INIT_DONE_SHIFT	17
> +
>  struct __tegra_ahb {
>  	void __iomem	*regs;
>  	struct device	*dev;
> @@ -95,6 +98,21 @@ static inline void gizmo_writel(unsigned long value, unsigned long offset)
>  	writel(value, tegra_ahb->regs + offset);
>  }
>  
> +#ifdef CONFIG_ARCH_TEGRA_3x_SOC
> +
> +void tegra_ahb_enable_smmu(void)
> +{
> +	unsigned long val;
> +
> +	val = gizmo_readl(AHB_ARBITRATION_XBAR_CTRL);
> +	val |= AHB_ARBITRATION_XBAR_CTRL_SMMU_INIT_DONE_DONE <<
> +		AHB_ARBITRATION_XBAR_CTRL_SMMU_INIT_DONE_SHIFT;

In addition to what Felipe said...

Why do you need two constants where you have only one use point?
What's wrong with having just a single definition which gives you
the right bitmask?
