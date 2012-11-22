Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758485Ab2KVWbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:31:48 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49161 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089Ab2KVWbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 17:31:42 -0500
Date: Thu, 22 Nov 2012 12:26:33 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: Re: [PATCH 1/1] ARM: cache-l2x0: Fix compile time warnings when
	!CONFIG_OF
Message-ID: <20121122122633.GG5764@n2100.arm.linux.org.uk>
References: <1353586067-9989-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1353586067-9989-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I assume you're working with an old kernel... this has already been
fixed.

On Thu, Nov 22, 2012 at 12:07:47PM +0000, Lee Jones wrote:
> Introduced by:
> 07bd005ed2457876f653fda12981708d737543df
> ARM: 7547/1: cache-l2x0: add support for Aurora L2 cache ctrl
> 
> arch/arm/mm/cache-l2x0.c:37:12: warning: ‘l2_wt_override’ defined but not used
> arch/arm/mm/cache-l2x0.c:292:22: warning: ‘calc_range_end’ defined but not used
> arch/arm/mm/cache-l2x0.c:315:13: warning: ‘aurora_pa_range’ defined but not used
> arch/arm/mm/cache-l2x0.c:328:13: warning: ‘aurora_inv_range’ defined but not used
> arch/arm/mm/cache-l2x0.c:347:13: warning: ‘aurora_clean_range’ defined but not used
> arch/arm/mm/cache-l2x0.c:365:13: warning: ‘aurora_flush_range’ defined but not used
> 
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  arch/arm/mm/cache-l2x0.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
> index bfb5986..25a9226 100644
> --- a/arch/arm/mm/cache-l2x0.c
> +++ b/arch/arm/mm/cache-l2x0.c
> @@ -34,7 +34,6 @@ static DEFINE_RAW_SPINLOCK(l2x0_lock);
>  static u32 l2x0_way_mask;	/* Bitmask of active ways */
>  static u32 l2x0_size;
>  static unsigned long sync_reg_offset = L2X0_CACHE_SYNC;
> -static int l2_wt_override;
>  
>  /* Aurora don't have the cache ID register available, so we have to
>   * pass it though the device tree */
> @@ -284,6 +283,10 @@ static void l2x0_flush_range(unsigned long start, unsigned long end)
>  	raw_spin_unlock_irqrestore(&l2x0_lock, flags);
>  }
>  
> +#ifdef CONFIG_OF
> +
> +static int l2_wt_override;
> +
>  /*
>   * Note that the end addresses passed to Linux primitives are
>   * noninclusive, while the hardware cache range operations use
> @@ -375,6 +378,7 @@ static void aurora_flush_range(unsigned long start, unsigned long end)
>  		}
>  	}
>  }
> +#endif
>  
>  static void l2x0_disable(void)
>  {
> -- 
> 1.7.9.5
> 
