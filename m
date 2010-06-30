Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab0F3T7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 15:59:35 -0400
Received: from shutemov.name ([188.40.19.243]:36241 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754494Ab0F3T7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 15:59:34 -0400
Date: Wed, 30 Jun 2010 22:59:33 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Christoph Egger <siccegge@cs.fau.de>
Cc: David Brown <davidb@codeaurora.org>,
       Daniel Walker <dwalker@codeaurora.org>,
       Bryan Huntsman <bryanh@codeaurora.org>,
       Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de,
       Brian Swetland <swetland@google.com>
Subject: Re: [PATCH 04/33] Removing dead MSM7X00A_IDLE
Message-ID: <20100630195933.GD3969@shutemov.name>
References: <cover.1277911345.git.siccegge@cs.fau.de>
 <c7e75d44aebaaabfdff9cf5fbda54512d0062728.1277911346.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7e75d44aebaaabfdff9cf5fbda54512d0062728.1277911346.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 05:55:03PM +0200, Christoph Egger wrote:
> MSM7X00A_IDLE doesn't exist in Kconfig, therefore removing all
> references for it from the source code.

It was removed in commit 1637de0c9. I'm not sure if it's correct.

Brian Swetland added to CC list.

> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
> ---
>  arch/arm/mach-msm/idle.S |   13 -------------
>  1 files changed, 0 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/arm/mach-msm/idle.S b/arch/arm/mach-msm/idle.S
> index 6a94f05..d8e8027 100644
> --- a/arch/arm/mach-msm/idle.S
> +++ b/arch/arm/mach-msm/idle.S
> @@ -20,17 +20,4 @@
>  #include <asm/assembler.h>
>  
>  ENTRY(arch_idle)
> -#ifdef CONFIG_MSM7X00A_IDLE
> -	mrc     p15, 0, r1, c1, c0, 0    /* read current CR    */
> -	bic     r0, r1, #(1 << 2)        /* clear dcache bit   */
> -	bic     r0, r0, #(1 << 12)       /* clear icache bit   */
> -	mcr     p15, 0, r0, c1, c0, 0    /* disable d/i cache  */
> -
> -	mov     r0, #0                   /* prepare wfi value  */
> -	mcr     p15, 0, r0, c7, c10, 0   /* flush the cache    */
> -	mcr     p15, 0, r0, c7, c10, 4   /* memory barrier     */
> -	mcr     p15, 0, r0, c7, c0, 4    /* wait for interrupt */
> -
> -	mcr     p15, 0, r1, c1, c0, 0    /* restore d/i cache  */
> -#endif
>  	mov     pc, lr
> -- 
> 1.7.0.4
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

-- 
 Kirill A. Shutemov
