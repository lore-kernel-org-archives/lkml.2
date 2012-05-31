Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757654Ab2EaBZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 21:25:09 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48026 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754614Ab2EaBZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 21:25:07 -0400
Date: Thu, 31 May 2012 02:24:50 +0100
From: Will Deacon <will.deacon@arm.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH] ARM: cmpxchg: define __HAVE_ARCH_CMPXCHG for armv6
 and later
Message-ID: <20120531012450.GA8506@mudshark.cambridge.arm.com>
References: <1338364287-11614-1-git-send-email-yong.zhang0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338364287-11614-1-git-send-email-yong.zhang0@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, May 30, 2012 at 08:51:26AM +0100, Yong Zhang wrote:
> diff --git a/arch/arm/include/asm/cmpxchg.h b/arch/arm/include/asm/cmpxchg.h
> index 7eb18c1..a91b44e 100644
> --- a/arch/arm/include/asm/cmpxchg.h
> +++ b/arch/arm/include/asm/cmpxchg.h
> @@ -127,6 +127,8 @@ static inline unsigned long __xchg(unsigned long x, volatile void *ptr, int size
>  
>  #else	/* min ARCH >= ARMv6 */
>  
> +#define __HAVE_ARCH_CMPXCHG 1
> +
>  extern void __bad_cmpxchg(volatile void *ptr, int size);

As long as this only requires 4-byte cmpxchg support then I think this is
fine. It looks like that's currently the case, so:

Acked-by: Will Deacon <will.deacon@arm.com>

Will
