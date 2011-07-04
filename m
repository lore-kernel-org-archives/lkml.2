Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276Ab1GDKPS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 06:15:18 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:42579 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757186Ab1GDKPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 06:15:16 -0400
Message-ID: <4E119250.8090009@metafoo.de>
Date: Mon, 04 Jul 2011 12:13:36 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110505 Icedove/3.0.11
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Anton Vorontsov <cbouatmailru@gmail.com>
Subject: Re: [PATCH] power: gpio-charger: Fix checking return value of request_any_context_irq
References: <1309773855.2267.1.camel@phoenix>
In-Reply-To: <1309773855.2267.1.camel@phoenix>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2011 12:04 PM, Axel Lin wrote:
> request_any_context_irq() returns a negative value on failure.
> On success, it returns either IRQC_IS_HARDIRQ or IRQC_IS_NESTED.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

Thanks

> ---
>  drivers/power/gpio-charger.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/power/gpio-charger.c b/drivers/power/gpio-charger.c
> index 718f2c5..a64b885 100644
> --- a/drivers/power/gpio-charger.c
> +++ b/drivers/power/gpio-charger.c
> @@ -127,7 +127,7 @@ static int __devinit gpio_charger_probe(struct platform_device *pdev)
>  		ret = request_any_context_irq(irq, gpio_charger_irq,
>  				IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
>  				dev_name(&pdev->dev), charger);
> -		if (ret)
> +		if (ret < 0)
>  			dev_warn(&pdev->dev, "Failed to request irq: %d\n", ret);
>  		else
>  			gpio_charger->irq = irq;

