Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027Ab1GLIEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 04:04:51 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64158 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab1GLIEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 04:04:48 -0400
Date: Tue, 12 Jul 2011 10:05:13 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: fix regression in IXP4xx clocksource
Message-ID: <20110712080513.GA2937@riccoc20.at.omicron.at>
References: <m3liwb15t2.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m3liwb15t2.fsf@intrepid.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 11:02:17PM +0200, Krzysztof Halasa wrote:
> From: Richard Cochran <richardcochran@gmail.com>
> 
> Commit 234b6ceddb4fc2a4bc5b9a7670f070f6e69e0868
> 
>    clocksource: convert ARM 32-bit up counting clocksources
> 
> broke the build for ixp4xx and made big endian operation impossible.
> This commit restores the original behaviour.

I know I nag, but can we *please* have this patch in 3.0?
Big endian IXP really, really does not work without it.

Thanks,

Richard

> 
> Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
> Signed-off-by: Krzysztof Hałasa <khc@pm.waw.pl>
> 
> diff --git a/arch/arm/mach-ixp4xx/common.c b/arch/arm/mach-ixp4xx/common.c
> index 74ed81a..0777257 100644
> --- a/arch/arm/mach-ixp4xx/common.c
> +++ b/arch/arm/mach-ixp4xx/common.c
> @@ -419,14 +419,20 @@ static void notrace ixp4xx_update_sched_clock(void)
>  /*
>   * clocksource
>   */
> +
> +static cycle_t ixp4xx_clocksource_read(struct clocksource *c)
> +{
> +	return *IXP4XX_OSTS;
> +}
> +
>  unsigned long ixp4xx_timer_freq = IXP4XX_TIMER_FREQ;
>  EXPORT_SYMBOL(ixp4xx_timer_freq);
>  static void __init ixp4xx_clocksource_init(void)
>  {
>  	init_sched_clock(&cd, ixp4xx_update_sched_clock, 32, ixp4xx_timer_freq);
>  
> -	clocksource_mmio_init(&IXP4XX_OSTS, "OSTS", ixp4xx_timer_freq, 200, 32,
> -			clocksource_mmio_readl_up);
> +	clocksource_mmio_init(NULL, "OSTS", ixp4xx_timer_freq, 200, 32,
> +			ixp4xx_clocksource_read);
>  }
>  
>  /*
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
