Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372Ab1EHVo4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 17:44:56 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40651 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab1EHVoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 17:44:55 -0400
Date: Sun, 8 May 2011 22:44:37 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 03/19] ARM: LPAE: Use unsigned long for
	__phys_to_virt and __virt_to_phys
Message-ID: <20110508214437.GP27807@n2100.arm.linux.org.uk>
References: <1304859098-10760-1-git-send-email-catalin.marinas@arm.com> <1304859098-10760-4-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304859098-10760-4-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 08, 2011 at 01:51:22PM +0100, Catalin Marinas wrote:
> The !CONFIG_ARM_PATCH_PHYS_VIRT case uses macros for __phys_to_virt and
> __virt_to_phys but does not use any type casting. This causes issues

It might be a good idea to include the compiler warning message in the
commit log, so that the 'issues' being addressed are readily known.

> with LPAE where the phys_addr_t is 64-bit. Note that these macros are
> only valid for lowmem physical addresses where the range is within
> 32-bit.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  arch/arm/include/asm/memory.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
> index 431077c..10e4b4c 100644
> --- a/arch/arm/include/asm/memory.h
> +++ b/arch/arm/include/asm/memory.h
> @@ -194,8 +194,8 @@ static inline unsigned long __phys_to_virt(unsigned long x)
>  	return t;
>  }
>  #else
> -#define __virt_to_phys(x)	((x) - PAGE_OFFSET + PHYS_OFFSET)
> -#define __phys_to_virt(x)	((x) - PHYS_OFFSET + PAGE_OFFSET)
> +#define __virt_to_phys(x)	((unsigned long)(x) - PAGE_OFFSET + PHYS_OFFSET)
> +#define __phys_to_virt(x)	((unsigned long)(x) - PHYS_OFFSET + PAGE_OFFSET)
>  #endif
>  #endif
>  
> 
