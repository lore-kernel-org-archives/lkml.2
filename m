Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab1ECTmu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 15:42:50 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35921 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745Ab1ECTmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 15:42:47 -0400
Date: Tue, 3 May 2011 13:42:43 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, linus.walleij@linaro.org,
        Anton Vorontsov <cbouatmailru@gmail.com>
Subject: Re: [PATCH] basic_mmio_gpio: convert to non-__raw* accessors
Message-ID: <20110503194243.GH9401@ponder.secretlab.ca>
References: <1302538286-3547-1-git-send-email-jamie@jamieiles.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302538286-3547-1-git-send-email-jamie@jamieiles.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 05:11:26PM +0100, Jamie Iles wrote:
> The __raw_* accessors don't include memory barriers and can cause
> problems when writes get stuck in write buffers.
> 
> Suggested-by: Linus Walleij <linus.walleij@linaro.org>
> Cc: Anton Vorontsov <cbouatmailru@gmail.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>

Merged, thanks.

g.

> ---
> 
> Note: This patch is based on top of my other series to extend
> basic_mmio_gpio.
> 
>  drivers/gpio/basic_mmio_gpio.c |   16 ++++++++--------
>  1 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/gpio/basic_mmio_gpio.c b/drivers/gpio/basic_mmio_gpio.c
> index f4afd96..b2ec45f 100644
> --- a/drivers/gpio/basic_mmio_gpio.c
> +++ b/drivers/gpio/basic_mmio_gpio.c
> @@ -101,43 +101,43 @@ static struct bgpio_chip *to_bgpio_chip(struct gpio_chip *gc)
>  
>  static void bgpio_write8(void __iomem *reg, unsigned long data)
>  {
> -	__raw_writeb(data, reg);
> +	writeb(data, reg);
>  }
>  
>  static unsigned long bgpio_read8(void __iomem *reg)
>  {
> -	return __raw_readb(reg);
> +	return readb(reg);
>  }
>  
>  static void bgpio_write16(void __iomem *reg, unsigned long data)
>  {
> -	__raw_writew(data, reg);
> +	writew(data, reg);
>  }
>  
>  static unsigned long bgpio_read16(void __iomem *reg)
>  {
> -	return __raw_readw(reg);
> +	return readw(reg);
>  }
>  
>  static void bgpio_write32(void __iomem *reg, unsigned long data)
>  {
> -	__raw_writel(data, reg);
> +	writel(data, reg);
>  }
>  
>  static unsigned long bgpio_read32(void __iomem *reg)
>  {
> -	return __raw_readl(reg);
> +	return readl(reg);
>  }
>  
>  #if BITS_PER_LONG >= 64
>  static void bgpio_write64(void __iomem *reg, unsigned long data)
>  {
> -	__raw_writeq(data, reg);
> +	writeq(data, reg);
>  }
>  
>  static unsigned long bgpio_read64(void __iomem *reg)
>  {
> -	return __raw_readq(reg);
> +	return readq(reg);
>  }
>  #endif /* BITS_PER_LONG >= 64 */
>  
> -- 
> 1.7.4.2
> 
