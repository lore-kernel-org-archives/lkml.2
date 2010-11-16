Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab0KPFcl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 00:32:41 -0500
Received: from tango.tkos.co.il ([62.219.50.35]:42886 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283Ab0KPFck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 00:32:40 -0500
Date: Tue, 16 Nov 2010 07:32:14 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Gregory Bean <gbean@codeaurora.org>
Cc: dwalker@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] msm: gpio: Add v2 gpio support to MSM SoCs.
Message-ID: <20101116053214.GB15652@jasper.tkos.co.il>
References: <1289852419-7122-1-git-send-email-gbean@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289852419-7122-1-git-send-email-gbean@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gregory,

On Mon, Nov 15, 2010 at 12:20:18PM -0800, Gregory Bean wrote:
> Beginning with the MSM8x60, the hardware block responsible for gpio
> support changes.  Provide gpiolib support for the new v2 architecture.
> 
> Cc: Baruch Siach <baruch@tkos.co.il>
> Signed-off-by: Gregory Bean <gbean@codeaurora.org>
> ---

[snip]

> +struct msm_gpio_dev {
> +	struct gpio_chip gpio_chip;
> +};

This wrapper struct seems redundant. You only use it in msm_gpio_probe, where 
you can just use 'struct gpio_chip' directly.

> +static DEFINE_SPINLOCK(tlmm_lock);
> +
> +static inline struct msm_gpio_dev *to_msm_gpio_dev(struct gpio_chip *chip)
> +{
> +	return container_of(chip, struct msm_gpio_dev, gpio_chip);
> +}

Not used.

> +static inline void set_gpio_bits(unsigned n, void __iomem *reg)
> +{
> +	writel(readl(reg) | n, reg);
> +}

Move the locking in, or better, eliminate it, since it's only used in 
msm_gpio_direction_output.

[snip]

> +static struct platform_device msm_device_gpio = {
> +	.name = "msmgpio",
> +	.id   = 0,

Redundant.

> +};

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
