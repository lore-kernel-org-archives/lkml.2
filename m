Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160Ab1FPOh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 10:37:26 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52274 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068Ab1FPOhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 10:37:22 -0400
Date: Thu, 16 Jun 2011 08:37:18 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, alsa-devel@alsa-project.org,
        Dmitry Artamonow <mad_soft@inbox.ru>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        Harald Welte <laforge@gnufiish.org>
Subject: Re: [PATCH 1/2] gpio: add GPIOF_ values regardless on kconfig
 settings
Message-ID: <20110616143718.GB2806@ponder.secretlab.ca>
References: <20110527074552.GA907@ponder.secretlab.ca>
 <4DDFE391.2030507@oracle.com>
 <20110527201201.GA6645@ponder.secretlab.ca>
 <BANLkTin-KSVcG2cQfRM3Ys0_g_uJVruDMw@mail.gmail.com>
 <20110603171837.GA9918@opensource.wolfsonmicro.com>
 <BANLkTi=oko_C8_46Y8p5O1Qvw1KEn-1PjA@mail.gmail.com>
 <4DEC4D67.6010506@oracle.com>
 <20110614091211.465553de.randy.dunlap@oracle.com>
 <20110614161357.GB1839@ponder.secretlab.ca>
 <20110614170511.5cb8c8b2.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110614170511.5cb8c8b2.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 05:05:11PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Make GPIOF_ defined values available even when GPIOLIB nor GENERIC_GPIO
> is enabled by moving them to <linux/gpio.h>.
> 
> Fixes these build errors in linux-next:
> sound/soc/codecs/ak4641.c:524: error: 'GPIOF_OUT_INIT_LOW' undeclared (first use in this function)
> sound/soc/codecs/wm8915.c:2921: error: 'GPIOF_OUT_INIT_LOW' undeclared (first use in this function)
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Applied, thanks.

g.

> ---
>  include/asm-generic/gpio.h |   10 ----------
>  include/linux/gpio.h       |   11 +++++++++++
>  2 files changed, 11 insertions(+), 10 deletions(-)
> 
> --- linux-next-20110614.orig/include/asm-generic/gpio.h
> +++ linux-next-20110614/include/asm-generic/gpio.h
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
> --- linux-next-20110614.orig/include/linux/gpio.h
> +++ linux-next-20110614/include/linux/gpio.h
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
