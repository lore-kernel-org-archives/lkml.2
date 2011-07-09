Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab1GIOdM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 10:33:12 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48536 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab1GIOdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 10:33:11 -0400
Message-ID: <4E1866A2.9040407@gmail.com>
Date: Sat, 09 Jul 2011 09:33:06 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: nico@fluxnic.net
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] ARM: move ARCH_HAS_DMA_SET_COHERENT_MASK into memory.h
References: <1309366019-24379-1-git-send-email-robherring2@gmail.com> <1309366019-24379-3-git-send-email-robherring2@gmail.com>
In-Reply-To: <1309366019-24379-3-git-send-email-robherring2@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas,

On 06/29/2011 11:46 AM, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> On ixp4xx and pxa, ARCH_HAS_DMA_SET_COHERENT_MASK resides in hardware.h
> which does not get directly included by dma-mapping.h. Move it into
> mach/memory.h which is explicitly included.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> ---
>  arch/arm/mach-ixp4xx/include/mach/hardware.h |    2 --
>  arch/arm/mach-ixp4xx/include/mach/memory.h   |    1 +
>  arch/arm/mach-pxa/include/mach/hardware.h    |    1 -
>  arch/arm/mach-pxa/include/mach/memory.h      |    1 +
>  4 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/mach-ixp4xx/include/mach/hardware.h b/arch/arm/mach-ixp4xx/include/mach/hardware.h
> index 8138371..f91ca6d 100644
> --- a/arch/arm/mach-ixp4xx/include/mach/hardware.h
> +++ b/arch/arm/mach-ixp4xx/include/mach/hardware.h
> @@ -26,8 +26,6 @@
>  #define PCIBIOS_MAX_MEM		0x4BFFFFFF
>  #endif
>  
> -#define ARCH_HAS_DMA_SET_COHERENT_MASK
> -
>  #define pcibios_assign_all_busses()	1
>  
>  /* Register locations and bits */
> diff --git a/arch/arm/mach-ixp4xx/include/mach/memory.h b/arch/arm/mach-ixp4xx/include/mach/memory.h
> index 34e7940..d671f5c 100644
> --- a/arch/arm/mach-ixp4xx/include/mach/memory.h
> +++ b/arch/arm/mach-ixp4xx/include/mach/memory.h
> @@ -16,6 +16,7 @@
>  
>  #ifdef CONFIG_PCI
>  #define ARM_DMA_ZONE_SIZE	SZ_64M
> +#define ARCH_HAS_DMA_SET_COHERENT_MASK
>  #endif
>  
>  #endif
> diff --git a/arch/arm/mach-pxa/include/mach/hardware.h b/arch/arm/mach-pxa/include/mach/hardware.h
> index 6957ba5..313051c 100644
> --- a/arch/arm/mach-pxa/include/mach/hardware.h
> +++ b/arch/arm/mach-pxa/include/mach/hardware.h
> @@ -340,7 +340,6 @@ extern unsigned long get_clock_tick_rate(void);
>  #define PCIBIOS_MIN_IO		0
>  #define PCIBIOS_MIN_MEM		0
>  #define pcibios_assign_all_busses()	1
> -#define ARCH_HAS_DMA_SET_COHERENT_MASK
>  #endif
>  
>  #endif  /* _ASM_ARCH_HARDWARE_H */
> diff --git a/arch/arm/mach-pxa/include/mach/memory.h b/arch/arm/mach-pxa/include/mach/memory.h
> index 07734f3..e697578 100644
> --- a/arch/arm/mach-pxa/include/mach/memory.h
> +++ b/arch/arm/mach-pxa/include/mach/memory.h
> @@ -19,6 +19,7 @@
>  
>  #if defined(CONFIG_MACH_ARMCORE) && defined(CONFIG_PCI)
>  #define ARM_DMA_ZONE_SIZE	SZ_64M
> +#define ARCH_HAS_DMA_SET_COHERENT_MASK
>  #endif
>  
>  #endif

I noticed this is going to have conflicts with your ARM_DMA_ZONE_SIZE
series. Can you add this into your series? This still presents another
issue to solve for single kernel binary, but hopefully the dma mapping
work will help.

Rob
