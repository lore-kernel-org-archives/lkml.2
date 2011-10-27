Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750955Ab1J0EWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 00:22:44 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:13155 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab1J0EWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 00:22:41 -0400
Message-ID: <4EA8DBDE.9070405@snapgear.com>
Date: Thu, 27 Oct 2011 14:19:42 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        <linux-m68k@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] m68k: Fall back to __gpio_to_irq() for non-arch GPIOs
References: <1319615515-3286-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1319615515-3286-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 26/10/11 17:51, Mark Brown wrote:
> gpiolib provides __gpio_to_irq() to map gpiolib gpios to interrupts - hook
> that up on m68k.
>
> Signed-off-by: Mark Brown<broonie@opensource.wolfsonmicro.com>

I'll take this through the m68knommu git tree, since it is only used
by the ColdFire CPU parts.

Thanks
Greg



>   arch/m68k/include/asm/gpio.h |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/arch/m68k/include/asm/gpio.h b/arch/m68k/include/asm/gpio.h
> index b204683..00d0071 100644
> --- a/arch/m68k/include/asm/gpio.h
> +++ b/arch/m68k/include/asm/gpio.h
> @@ -225,7 +225,8 @@ static inline void gpio_set_value(unsigned gpio, int value)
>
>   static inline int gpio_to_irq(unsigned gpio)
>   {
> -	return (gpio<  MCFGPIO_IRQ_MAX) ? gpio + MCFGPIO_IRQ_VECBASE : -EINVAL;
> +	return (gpio<  MCFGPIO_IRQ_MAX) ? gpio + MCFGPIO_IRQ_VECBASE
> +		: __gpio_to_irq(gpio);
>   }
>
>   static inline int irq_to_gpio(unsigned irq)


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
