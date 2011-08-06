Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817Ab1HFXNR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 19:13:17 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:43837 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab1HFXNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 19:13:14 -0400
Date: Sat, 6 Aug 2011 18:45:19 +0100
From: Grant Likely <grant.likely@secretlab.ca>
To: Stephen Warren <swarren@nvidia.com>
Cc: Colin Cross <ccross@android.com>, Erik Gilling <konkers@android.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] arm/tegra: Delete irq_to_gpio
Message-ID: <20110806174519.GB31966@ponder.secretlab.ca>
References: <1312582534-10871-1-git-send-email-swarren@nvidia.com>
 <1312582534-10871-2-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312582534-10871-2-git-send-email-swarren@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 04:15:34PM -0600, Stephen Warren wrote:
> irq_to_gpio is deprecated and in the process of being removed. Make that
> happen now for ARM Tegra.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Applied both.  Thanks.

g.

> ---
> I assume this will go into one of arm-soc.git's branches, but it depends
> on the previous patch in this series to compile. Arnd, I see you already
> have Grant's gpio/next tree in your repo as depends/gpio, so I assume
> you'll just pick up and merge the latest version of Grant's tree before
> applying this patch?
> 
> Both patches compiled with a number of Tegra boards enable and tested on
> Harmony. All without Device Tree support.
> 
>  arch/arm/mach-tegra/include/mach/gpio.h |    8 --------
>  1 files changed, 0 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm/mach-tegra/include/mach/gpio.h b/arch/arm/mach-tegra/include/mach/gpio.h
> index 196f114..b357808 100644
> --- a/arch/arm/mach-tegra/include/mach/gpio.h
> +++ b/arch/arm/mach-tegra/include/mach/gpio.h
> @@ -32,7 +32,6 @@
>  #define gpio_cansleep		__gpio_cansleep
>  
>  #define TEGRA_GPIO_TO_IRQ(gpio) (INT_GPIO_BASE + (gpio))
> -#define TEGRA_IRQ_TO_GPIO(irq) ((irq) - INT_GPIO_BASE)
>  
>  static inline int gpio_to_irq(unsigned int gpio)
>  {
> @@ -41,13 +40,6 @@ static inline int gpio_to_irq(unsigned int gpio)
>  	return -EINVAL;
>  }
>  
> -static inline int irq_to_gpio(unsigned int irq)
> -{
> -	if ((irq >= INT_GPIO_BASE) && (irq < INT_GPIO_BASE + INT_GPIO_NR))
> -		return irq - INT_GPIO_BASE;
> -	return -EINVAL;
> -}
> -
>  struct tegra_gpio_table {
>  	int	gpio;	/* GPIO number */
>  	bool	enable;	/* Enable for GPIO at init? */
> -- 
> 1.7.0.4
> 
