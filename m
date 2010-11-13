Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab0KMT1M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 14:27:12 -0500
Received: from tango.tkos.co.il ([62.219.50.35]:60487 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755061Ab0KMT1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 14:27:09 -0500
Date: Sat, 13 Nov 2010 21:25:55 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Gregory Bean <gbean@codeaurora.org>
Cc: dwalker@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] msm: gpio: Add v2 gpio support to MSM SoCs.
Message-ID: <20101113192555.GA23794@tarshish>
References: <1289585342-21341-1-git-send-email-gbean@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289585342-21341-1-git-send-email-gbean@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gregory,

On Fri, Nov 12, 2010 at 10:09:01AM -0800, Gregory Bean wrote:
> Beginning with the MSM8x60, the hardware block responsible for gpio
> support changes.  Provide gpiolib support for the new v2 architecture.
> 
> Signed-off-by: Gregory Bean <gbean@codeaurora.org>
> ---

[snip]

> +static inline void clr_gpio_bits(unsigned n, void __iomem *reg)
> +{
> +	writel(readl(reg) & ~n, reg);

IMO you should move the locking here. And since the only user of this function 
is msm_gpio_direction_input, I'd eliminate it altogether.

> +}

[snip]

> +static int msm_gpio_direction_input(struct gpio_chip *chip, unsigned 
> offset)
> +{
> +	unsigned long irq_flags;
> +
> +	spin_lock_irqsave(&tlmm_lock, irq_flags);
> +	clr_gpio_bits(BIT(GPIO_OE_BIT), GPIO_CONFIG(offset));
> +	spin_unlock_irqrestore(&tlmm_lock, irq_flags);
> +	return 0;
> +}

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
