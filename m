Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab2DWMda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 08:33:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64316 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab2DWMd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 08:33:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hiroshi DOYU <hdoyu@nvidia.com>
Subject: Re: [PATCH 1/3] ARM: tegra: Add AHB driver
Date: Mon, 23 Apr 2012 12:33:09 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-tegra@vger.kernel.org, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1335181043-15348-1-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1335181043-15348-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204231233.09423.arnd@arndb.de>
X-Provags-ID: V02:K0:PYLZWRDP33OcUPYP+NdrulIHWgf6sNgQVjUP1QokEkw
 o+rXtk5I5hUVwddYnlDJtqqVbq99wNOV7Ravr/pGm1dS1/7vw+
 hlsXu9AobOe3USvBf5mSELNrQuGcyGdqZ8GJyPL9a6lGSBWMl5
 qlYECw5LTX9DSCDP2phq6SNpT18XuMET51AReMkOLnUZb8v5Qd
 1xXGbRAi7lQgkrLjlSnB1csAPMyo6U33HItnzcq5hbVDCnwKk3
 TmCy4G+0AKRRfFgNP7tBxRgt39gilhxwKQp+4wWeHY3ZET6t7B
 T1ITuDamM9lRTNk01EahBSkWFl+otXWDwG5ZQAMVNHwptI7iuX
 +qQZ4jsT9pDxZeVOffjg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 April 2012, Hiroshi DOYU wrote:
> The AHB Bus conforms to the AMBA Specification (Rev 2.0) Advanced
> High-performance Bus (AHB) architecture.
> 
> Both Tegra20/30 have this.
> 
> Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>

Please explain in the text above why it's a good idea to have this
driver.


> @@ -122,6 +123,7 @@ void __init tegra20_init_early(void)
>  	tegra_init_cache(0x331, 0x441);
>  	tegra_pmc_init();
>  	tegra_powergate_init();
> +	tegra_ahb_gizmo_init();
>  }
>  #endif
>  #ifdef CONFIG_ARCH_TEGRA_3x_SOC
> @@ -132,5 +134,6 @@ void __init tegra30_init_early(void)
>  	tegra_init_cache(0x441, 0x551);
>  	tegra_pmc_init();
>  	tegra_powergate_init();
> +	tegra_ahb_gizmo_init();
>  }
>  #endif

Does it really have to be "early", rather than an initcall? Why?

> +
> +static inline unsigned long gizmo_readl(unsigned long offset)
> +{
> +	return readl(IO_TO_VIRT(TEGRA_AHB_GIZMO_BASE + offset));
> +}
> +
> +static inline void gizmo_writel(unsigned long value, unsigned long offset)
> +{
> +	writel(value, IO_TO_VIRT(TEGRA_AHB_GIZMO_BASE + offset));
> +}

Please change this to no longer use hardcoded addresses. A good
implementation would scan the device tree for the physical address
and then ioremap the registers in the init function, in order to
save a local __iomem pointer.

	Arnd
