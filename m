Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921Ab2BIUEr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 15:04:47 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39367 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757235Ab2BIUEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 15:04:46 -0500
Date: Thu, 9 Feb 2012 12:04:39 -0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>, b-cousson@ti.com,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>
Subject: Re: [PATCH v4 4/4] gpio: pl061: enable interrupts with DT style
 binding
Message-ID: <20120209200435.GB2493@r65073-Latitude-D630>
References: <1328308512-22594-1-git-send-email-robherring2@gmail.com>
 <1328308512-22594-5-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328308512-22594-5-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 04:35:12PM -0600, Rob Herring wrote:
...
> @@ -126,18 +127,16 @@ static void pl061_set_value(struct gpio_chip *gc, unsigned offset, int value)
>  static int pl061_to_irq(struct gpio_chip *gc, unsigned offset)
>  {
>  	struct pl061_gpio *chip = container_of(gc, struct pl061_gpio, gc);
> -
> -	if (chip->irq_base <= 0)
> -		return -EINVAL;
> -
> -	return chip->irq_base + offset;
> +	if (!chip->irq_gc)
> +		return -ENXIO;
> +	return irq_find_mapping(chip->irq_gc->domain, offset);

If I understand the driver correctly, it will add a linear domain for
dt case.  Do you have code somewhere creating the mapping before this
irq_find_mapping gets called here?  The reason I'm asking this is I
have to call irq_create_mapping rather than irq_find_mapping here to
get imx gpio driver working with linear domain, otherwise the
irq_find_mapping call will fail.

Regards,
Shawn

>  }
