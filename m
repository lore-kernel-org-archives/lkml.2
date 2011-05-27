Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab1E0UMH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 16:12:07 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54545 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab1E0UME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 16:12:04 -0400
Date: Fri, 27 May 2011 14:12:01 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, alsa-devel@alsa-project.org,
        Dmitry Artamonow <mad_soft@inbox.ru>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        Harald Welte <laforge@gnufiish.org>
Subject: Re: [PATCH] gpio: add GPIOF_ values regardless on kconfig settings
Message-ID: <20110527201201.GA6645@ponder.secretlab.ca>
References: <20110523134815.fb87933a.randy.dunlap@oracle.com>
 <20110523224659.GB19533@opensource.wolfsonmicro.com>
 <20110523155343.2e68c265.randy.dunlap@oracle.com>
 <20110524000837.GA30515@opensource.wolfsonmicro.com>
 <4DDB082F.3010107@oracle.com>
 <20110524014959.GA27710@opensource.wolfsonmicro.com>
 <4DDB3AFF.9030006@oracle.com>
 <20110524075248.GB19734@sirena.org.uk>
 <20110527074552.GA907@ponder.secretlab.ca>
 <4DDFE391.2030507@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DDFE391.2030507@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 10:46:57AM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Make GPIOF_ defined values available even when GPIOLIB nor GENERIC_GPIO
> is enabled by moving them to <linux/gpio.h>.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Applied, thanks.

g.

> ---
>  include/asm-generic/gpio.h |   10 ----------
>  include/linux/gpio.h       |   11 +++++++++++
>  2 files changed, 11 insertions(+), 10 deletions(-)
> 
> --- linux-next-20110523.orig/include/asm-generic/gpio.h
> +++ linux-next-20110523/include/asm-generic/gpio.h
> @@ -170,16 +170,6 @@ extern int __gpio_cansleep(unsigned gpio
>  
>  extern int __gpio_to_irq(unsigned gpio);
>  
> -#define GPIOF_DIR_OUT	(0 << 0)
> -#define GPIOF_DIR_IN	(1 << 0)
> -
> -#define GPIOF_INIT_LOW	(0 << 1)
> -#define GPIOF_INIT_HIGH	(1 << 1)
> -
> -#define GPIOF_IN		(GPIOF_DIR_IN)
> -#define GPIOF_OUT_INIT_LOW	(GPIOF_DIR_OUT | GPIOF_INIT_LOW)
> -#define GPIOF_OUT_INIT_HIGH	(GPIOF_DIR_OUT | GPIOF_INIT_HIGH)
> -
>  /**
>   * struct gpio - a structure describing a GPIO with configuration
>   * @gpio:	the GPIO number
> --- linux-next-20110523.orig/include/linux/gpio.h
> +++ linux-next-20110523/include/linux/gpio.h
> @@ -3,6 +3,17 @@
>  
>  /* see Documentation/gpio.txt */
>  
> +/* make these flag values available regardless of GPIO kconfig options */
> +#define GPIOF_DIR_OUT	(0 << 0)
> +#define GPIOF_DIR_IN	(1 << 0)
> +
> +#define GPIOF_INIT_LOW	(0 << 1)
> +#define GPIOF_INIT_HIGH	(1 << 1)
> +
> +#define GPIOF_IN		(GPIOF_DIR_IN)
> +#define GPIOF_OUT_INIT_LOW	(GPIOF_DIR_OUT | GPIOF_INIT_LOW)
> +#define GPIOF_OUT_INIT_HIGH	(GPIOF_DIR_OUT | GPIOF_INIT_HIGH)
> +
>  #ifdef CONFIG_GENERIC_GPIO
>  #include <asm/gpio.h>
>  
