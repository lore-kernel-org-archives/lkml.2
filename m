Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab2H3P7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 11:59:19 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:33697 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab2H3P7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 11:59:17 -0400
Date: Thu, 30 Aug 2012 11:59:14 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Murali Karicheri <m-karicheri2@ti.com>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, tony@atomide.com,
        santosh.shilimkar@ti.com, wim@iguana.be,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH - 2/2] arm: disable caches based on config option
In-Reply-To: <1346337826-27232-2-git-send-email-m-karicheri2@ti.com>
Message-ID: <alpine.LFD.2.02.1208301156390.1784@xanadu.home>
References: <1346337826-27232-1-git-send-email-m-karicheri2@ti.com> <1346337826-27232-2-git-send-email-m-karicheri2@ti.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Aug 2012, Murali Karicheri wrote:

> CONFIG_CPU_ICACHE_DISABLE and CONFIG_CPU_DCACHE_DISABLE are available
> to allow disabling of D-Cache and I-Cache. However the compressed version
> of head.S currently doesn't check these variables. This patch will fix
> this issue and is written similar to the uncompressed version of head.S
> 
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>

Acked-by: nicolas Pitre <nico@linaro.org>

You may submit your patch to http://www.arm.linux.org.uk/developer/patches/.


> ---
>  arch/arm/boot/compressed/head.S |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
> index b8c64b8..e1d2124 100644
> --- a/arch/arm/boot/compressed/head.S
> +++ b/arch/arm/boot/compressed/head.S
> @@ -659,6 +659,12 @@ __armv7_mmu_cache_on:
>  #ifdef CONFIG_CPU_ENDIAN_BE8
>  		orr	r0, r0, #1 << 25	@ big-endian page tables
>  #endif
> +#ifdef CONFIG_CPU_DCACHE_DISABLE
> +		bic	r0, r0, #1 << 2
> +#endif
> +#ifdef CONFIG_CPU_ICACHE_DISABLE
> +		bic	r0, r0, #1 << 12
> +#endif
>  		orrne	r0, r0, #1		@ MMU enabled
>  		movne	r1, #0xfffffffd		@ domain 0 = client
>  		mcrne	p15, 0, r3, c2, c0, 0	@ load page table pointer
> -- 
> 1.7.9.5
> 
