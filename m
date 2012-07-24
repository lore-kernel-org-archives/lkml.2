Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab2GXKho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 06:37:44 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:44308 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751751Ab2GXKhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 06:37:43 -0400
Date: Tue, 24 Jul 2012 11:37:17 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Cyril Chemparathy <cyril@ti.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nico@linaro.org" <nico@linaro.org>, Will Deacon <Will.Deacon@arm.com>,
        Vitaly Andrianov <vitalya@ti.com>
Subject: Re: [RFC 03/23] ARM: LPAE: use phys_addr_t on virt <--> phys
 conversion
Message-ID: <20120724103717.GF20132@arm.com>
References: <1343092165-9470-1-git-send-email-cyril@ti.com>
 <1343092165-9470-4-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343092165-9470-4-git-send-email-cyril@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 02:09:05AM +0100, Cyril Chemparathy wrote:
> This patch fixes up the types used when converting back and forth between
> physical and virtual addresses.
> 
> Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
> Signed-off-by: Cyril Chemparathy <cyril@ti.com>
> ---
>  arch/arm/include/asm/memory.h |   17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
> index fcb5757..7629dfe 100644
> --- a/arch/arm/include/asm/memory.h
> +++ b/arch/arm/include/asm/memory.h
> @@ -169,22 +169,27 @@ extern unsigned long __pv_phys_offset;
>  	: "=r" (to)					\
>  	: "r" (from), "I" (type))
>  
> -static inline unsigned long __virt_to_phys(unsigned long x)
> +static inline phys_addr_t __virt_to_phys(unsigned long x)
>  {
>  	unsigned long t;
>  	__pv_stub(x, t, "add", __PV_BITS_31_24);
>  	return t;
>  }
>  
> -static inline unsigned long __phys_to_virt(unsigned long x)
> +static inline unsigned long __phys_to_virt(phys_addr_t x)
>  {
>  	unsigned long t;
>  	__pv_stub(x, t, "sub", __PV_BITS_31_24);
>  	return t;
>  }

BTW, I would prefer if the phys-to-virt patching was fixed as well. It
shouldn't be difficult.

-- 
Catalin
