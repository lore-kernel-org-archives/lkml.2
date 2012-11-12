Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab2KLKpB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 05:45:01 -0500
Received: from anubis.se.axis.com ([195.60.68.12]:49788 "EHLO
	anubis.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab2KLKo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 05:44:59 -0500
Date: Mon, 12 Nov 2012 11:44:56 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Mikael Starvik <starvik@axis.com>, linux-cris-kernel@axis.com
Subject: Re: [PATCH 01/11] cris: move usec/nsec conversion to
 do_slow_gettimeoffset
Message-ID: <20121112104456.GM2834@axis.com>
References: <1352408516-21988-1-git-send-email-swarren@wwwdotorg.org>
 <1352408516-21988-3-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352408516-21988-3-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2012 at 02:01:46PM -0700, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> Move usec to nsec conversion from arch_gettimeoffset() to
> do_slow_gettimeoffset(); in a future patch, do_slow_gettimeoffset()
> will be used directly as the implementation of arch_gettimeoffset(),
> so needs to perform all required calculations.
> 
> Cc: Mikael Starvik <starvik@axis.com>
> Cc: Jesper Nilsson <jesper.nilsson@axis.com>

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

> Cc: linux-cris-kernel@axis.com
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
>  arch/cris/arch-v10/kernel/time.c |    4 ++--
>  arch/cris/kernel/time.c          |    2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/cris/arch-v10/kernel/time.c b/arch/cris/arch-v10/kernel/time.c
> index bcffcb6..162892f 100644
> --- a/arch/cris/arch-v10/kernel/time.c
> +++ b/arch/cris/arch-v10/kernel/time.c
> @@ -65,8 +65,8 @@ unsigned long do_slow_gettimeoffset(void)
>  	 */
>  	count = *R_TIMER0_DATA;
>  
> -	/* Convert timer value to usec */
> -	return (TIMER0_DIV - count) * ((NSEC_PER_SEC/1000)/HZ)/TIMER0_DIV;
> +	/* Convert timer value to nsec */
> +	return (TIMER0_DIV - count) * (NSEC_PER_SEC/HZ)/TIMER0_DIV;
>  }
>  
>  /* Excerpt from the Etrax100 HSDD about the built-in watchdog:
> diff --git a/arch/cris/kernel/time.c b/arch/cris/kernel/time.c
> index 277ffc4..b063c92 100644
> --- a/arch/cris/kernel/time.c
> +++ b/arch/cris/kernel/time.c
> @@ -46,7 +46,7 @@ static unsigned long (*do_gettimeoffset)(void) = do_slow_gettimeoffset;
>  
>  u32 arch_gettimeoffset(void)
>  {
> -       return do_gettimeoffset() * 1000;
> +	return do_gettimeoffset();
>  }
>  #endif
>  
> -- 
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
