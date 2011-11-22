Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848Ab1KVIOB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 03:14:01 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55636 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548Ab1KVIOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 03:14:00 -0500
Date: Tue, 22 Nov 2011 08:13:17 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: linux-next: manual merge of the arm-lpae tree with the arm tree
Message-ID: <20111122081317.GB22232@flint.arm.linux.org.uk>
References: <20111122120358.aa2cefdcdace9a98acafd4b9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111122120358.aa2cefdcdace9a98acafd4b9@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 12:03:58PM +1100, Stephen Rothwell wrote:
> diff --cc arch/arm/mm/ioremap.c
> index 12c7ad2,d1f78ba..0000000
> --- a/arch/arm/mm/ioremap.c
> +++ b/arch/arm/mm/ioremap.c
> @@@ -194,7 -208,14 +202,8 @@@ void __iomem * __arm_ioremap_pfn_caller
>   	 */
>   	if (pfn >= 0x100000 && (__pfn_to_phys(pfn) & ~SUPERSECTION_MASK))
>   		return NULL;
> + #endif
>   
>  -	/*
>  -	 * Don't allow RAM to be mapped - this causes problems with ARMv6+
>  -	 */
>  -	if (WARN_ON(pfn_valid(pfn)))
>  -		return NULL;
>  -

This certainly is not correct - if Catalin's lpae tree is removing this
then that needs to be fixed.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
