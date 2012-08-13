Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab2HMO7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 10:59:50 -0400
Received: from londo.lunn.ch ([80.238.139.98]:56617 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661Ab2HMO7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 10:59:49 -0400
Date: Mon, 13 Aug 2012 16:59:24 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Michael Walle <michael@walle.cc>, Nicolas Pitre <nico@linaro.org>
Subject: Re: [PATCH 03/10] ARM: mv78xx0: fix win_cfg_base prototype
Message-ID: <20120813145924.GI12756@lunn.ch>
Mail-Followup-To: Arnd Bergmann <arnd@arndb.de>,
	linux-arm-kernel@lists.infradead.org, arm@kernel.org,
	linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
	Michael Walle <michael@walle.cc>, Nicolas Pitre <nico@linaro.org>
References: <1344461278-28245-1-git-send-email-arnd@arndb.de>
 <1344461278-28245-4-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344461278-28245-4-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 11:27:51PM +0200, Arnd Bergmann wrote:
> Patch b6d1c33a31 "ARM: Orion: Consolidate the address map setup" tried
> to merge the address map for the four orion platforms, but apparently
> got it wrong for mv78xx0. Admittedly I don't understand what this
> code actually does, but it's clear that the current version is
> wrong.
> 
> Without this patch, building mv78xx0_defconfig results in:
> 
> arch/arm/mach-mv78xx0/addr-map.c:59:2: warning: initialization from incompatible pointer type [enabled by default]
> arch/arm/mach-mv78xx0/addr-map.c:59:2: warning: (near initialization for 'addr_map_cfg.win_cfg_base') [enabled by default]
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Michael Walle <michael@walle.cc>
> Cc: Nicolas Pitre <nico@linaro.org>
> ---
>  arch/arm/mach-mv78xx0/addr-map.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-mv78xx0/addr-map.c b/arch/arm/mach-mv78xx0/addr-map.c
> index 62b53d7..a9bc841 100644
> --- a/arch/arm/mach-mv78xx0/addr-map.c
> +++ b/arch/arm/mach-mv78xx0/addr-map.c
> @@ -37,7 +37,7 @@
>  #define WIN0_OFF(n)		(BRIDGE_VIRT_BASE + 0x0000 + ((n) << 4))
>  #define WIN8_OFF(n)		(BRIDGE_VIRT_BASE + 0x0900 + (((n) - 8) << 4))
>  
> -static void __init __iomem *win_cfg_base(int win)
> +static void __init __iomem *win_cfg_base(const struct orion_addr_map_cfg *cfg, int win)
>  {
>  	/*
>  	 * Find the control register base address for this window.
> -- 
> 1.7.10
> 

Acked-by: Andrew Lunn <andrew@lunn.ch>

	  Andrew
