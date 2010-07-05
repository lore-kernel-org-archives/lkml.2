Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab0GEHQB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 03:16:01 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41060 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab0GEHQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 03:16:00 -0400
Date: Mon, 5 Jul 2010 09:15:53 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Christoph Egger <siccegge@cs.fau.de>
Cc: Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 15/33] Removing dead PROCESSOR_NS9750
Message-ID: <20100705071553.GD18865@pengutronix.de>
References: <cover.1277911345.git.siccegge@cs.fau.de> <73d2b3929175d36d8bfdedf2d49150d2ed911b2a.1277911346.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <73d2b3929175d36d8bfdedf2d49150d2ed911b2a.1277911346.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 05:58:48PM +0200, Christoph Egger wrote:
> PROCESSOR_NS9750 doesn't exist in Kconfig, therefore removing all
> references for it from the source code.
> 
> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
> ---
>  arch/arm/mach-ns9xxx/gpio.c |    8 --------
>  1 files changed, 0 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm/mach-ns9xxx/gpio.c b/arch/arm/mach-ns9xxx/gpio.c
> index 5503ca0..58f4f50 100644
> --- a/arch/arm/mach-ns9xxx/gpio.c
> +++ b/arch/arm/mach-ns9xxx/gpio.c
> @@ -25,9 +25,6 @@
>  
>  #if defined(CONFIG_PROCESSOR_NS9360)
>  #define GPIO_MAX 72
> -#elif defined(CONFIG_PROCESSOR_NS9750)
> -#define GPIO_MAX 49
> -#endif
>  
>  /* protects BBU_GCONFx and BBU_GCTRLx */
>  static spinlock_t gpio_lock = __SPIN_LOCK_UNLOCKED(gpio_lock);
> @@ -42,11 +39,6 @@ static inline int ns9xxx_valid_gpio(unsigned gpio)
>  		return gpio <= 72;
>  	else
>  #endif
> -#if defined(CONFIG_PROCESSOR_NS9750)
> -	if (processor_is_ns9750())
> -		return gpio <= 49;
> -	else
> -#endif
>  	{
>  		BUG();
>  		return 0;
The code is correct as is, but AFAIK the ns9750 isn't supported anymore
even in the Digi provided BSPs and as it seems there aren't any efforts
to maintain ns9xxx in mainline.

So, Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
