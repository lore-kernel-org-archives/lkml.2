Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab2BWMj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 07:39:26 -0500
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:40530 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752277Ab2BWMjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 07:39:24 -0500
Message-ID: <4F463374.3080502@ti.com>
Date: Thu, 23 Feb 2012 18:09:16 +0530
From: Shubhrajyoti <shubhrajyoti@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Tarun Kanti DebBarma <tarun.kanti@ti.com>
CC: linux-omap@vger.kernel.org, grant.likely@secretlab.ca, khilman@ti.com,
        tony@atomide.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 5/6] gpio/omap: fix trigger type to unsigned
References: <1329999031-6914-1-git-send-email-tarun.kanti@ti.com> <1329999031-6914-6-git-send-email-tarun.kanti@ti.com>
In-Reply-To: <1329999031-6914-6-git-send-email-tarun.kanti@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 February 2012 05:40 PM, Tarun Kanti DebBarma wrote:
> The GPIO trigger parameter is of type unsigned.
> enum {
>         IRQ_TYPE_NONE           = 0x00000000,
>         IRQ_TYPE_EDGE_RISING    = 0x00000001,
>         IRQ_TYPE_EDGE_FALLING   = 0x00000002,
>         IRQ_TYPE_EDGE_BOTH      = (IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING),
>         IRQ_TYPE_LEVEL_HIGH     = 0x00000004,
>         IRQ_TYPE_LEVEL_LOW      = 0x00000008,
>         IRQ_TYPE_LEVEL_MASK     = (IRQ_TYPE_LEVEL_LOW | IRQ_TYPE_LEVEL_HIGH),
>         IRQ_TYPE_SENSE_MASK     = 0x0000000f,
>
>         IRQ_TYPE_PROBE          = 0x00000010,
> ...
> };
> Even though gpio_irq_type(struct irq_data *d, unsigned type) has the right type
> of parameter, the subsequent called functions set_gpio_triggering() and
> set_gpio_trigger() wrongly makes it signed integer. Fix this.
>
> Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>
> ---
>  drivers/gpio/gpio-omap.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
> index 3dd4b3a..67535c8 100644
> --- a/drivers/gpio/gpio-omap.c
> +++ b/drivers/gpio/gpio-omap.c
> @@ -232,7 +232,7 @@ static void _set_gpio_debounce(struct gpio_bank *bank, unsigned gpio,
>  }
>  
>  static inline void set_gpio_trigger(struct gpio_bank *bank, int gpio,
> -						int trigger)
> +						unsigned trigger)
>  {
>  	void __iomem *base = bank->base;
>  	u32 gpio_bit = 1 << gpio;
> @@ -314,7 +314,8 @@ static void _toggle_gpio_edge_triggering(struct gpio_bank *bank, int gpio)
>  static void _toggle_gpio_edge_triggering(struct gpio_bank *bank, int gpio) {}
>  #endif
>  
> -static int _set_gpio_triggering(struct gpio_bank *bank, int gpio, int trigger)
> +static int _set_gpio_triggering(struct gpio_bank *bank, int gpio,
> +							unsigned trigger)
you meant unsigned int ? could it be made u32.
>  {
>  	void __iomem *reg = bank->base;
>  	void __iomem *base = bank->base;

