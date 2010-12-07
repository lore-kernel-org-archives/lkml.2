Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab0LGBqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 20:46:36 -0500
Received: from sh.osrg.net ([192.16.179.4]:38207 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753404Ab0LGBqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 20:46:35 -0500
Date: Tue, 7 Dec 2010 10:45:46 +0900
To: fernando.lugo@ti.com
Cc: linux@arm.linux.org.uk, fujita.tomonori@lab.ntt.co.jp,
        linux-arm-kernel@lists.infradead.org, Hiroshi.DOYU@nokia.com,
        linux-kernel@vger.kernel.org, omar.ramirez@ti.com, bshah@ti.com,
        vpasam@ti.com
Subject: Re: [PATCH] ARM: Add Kconfig entry for SG chain support
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1291686036-32562-1-git-send-email-fernando.lugo@ti.com>
References: <1291686036-32562-1-git-send-email-fernando.lugo@ti.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20101207104451X.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 07 Dec 2010 10:45:48 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  6 Dec 2010 19:40:36 -0600
Fernando Guzman Lugo <fernando.lugo@ti.com> wrote:

> Add a entry to make possible SG chaining under ARM
> architecture.
> 
> Tidspbridge driver needs SG chaining, however SG chain has not
> been tested under all platforms. Adding this option OMAP
> platform can enable it and if other platforms have issues they
> would not enable it.
> 
> This patch is base on this discussion:
> 
> http://marc.info/?l=linux-arm-kernel&m=129166415415541&w=2
> 
> Signed-off-by: Fernando Guzman Lugo <fernando.lugo@ti.com>
> ---
>  arch/arm/Kconfig                   |    6 ++++++
>  arch/arm/include/asm/scatterlist.h |    4 ++++
>  2 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index dd944bd..f5cfd42 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1017,6 +1017,12 @@ config CPU_HAS_PMU
>  	default y
>  	bool
>  
> +config ARM_SG_CHAIN
> +	bool "Enable SG chain support"
> +	default n
> +	help
> +	  Enable support for SG chaining for ARM
> +

I thought that you simply add something like the following to
arch/arm/include/asm/scatterlist.h?

#ifdef CONFIG_ARCH_OMAP
#define ARCH_HAS_SG_CHAIN
#endif

Because you can't enable sg chaining on some arm architectures. Some
arm SCSI drivers can't handle sg chaining but they are not available
on omap, right? Why do you make this configurable on all arm archs
like the above?


>  if !MMU
>  source "arch/arm/Kconfig-nommu"
>  endif
> diff --git a/arch/arm/include/asm/scatterlist.h b/arch/arm/include/asm/scatterlist.h
> index 2f87870..eab7c4f 100644
> --- a/arch/arm/include/asm/scatterlist.h
> +++ b/arch/arm/include/asm/scatterlist.h
> @@ -5,4 +5,8 @@
>  #include <asm/types.h>
>  #include <asm-generic/scatterlist.h>
>  
> +#ifdef CONFIG_ARM_SG_CHAIN
> +#define ARCH_HAS_SG_CHAIN
> +#endif
> +
>  #endif /* _ASMARM_SCATTERLIST_H */
