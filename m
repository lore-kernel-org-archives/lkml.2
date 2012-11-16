Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751102Ab2KPJus (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 04:50:48 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:34246 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab2KPJuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 04:50:46 -0500
Date: Fri, 16 Nov 2012 01:47:33 -0800
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Jonathan Cameron <jic23@kernel.org>,
        anish kumar <anish198519851985@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH RESEND] power: generic-adc-battery: Fix checking return
 value of request_any_context_irq
Message-ID: <20121116094733.GA21792@lizard>
References: <1353056962.4277.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1353056962.4277.2.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 05:09:22PM +0800, Axel Lin wrote:
> On failure, request_any_context_irq() returns a negative value.
> On success, it returns either IRQC_IS_HARDIRQ or IRQC_IS_NESTED.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
> This was sent on https://lkml.org/lkml/2012/10/11/77
> Nobody picks up this patch, so resend it.
> I think this patch is for 3.7.

Nah, the driver is new, plus I doubt that anyone actually registers it in
v3.7, and it's definitely not a regression.


The fix itself is a valid one though, I applied it to battery tree.

Thank you!

> Regards,
> Axel
>  drivers/power/generic-adc-battery.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/power/generic-adc-battery.c b/drivers/power/generic-adc-battery.c
> index 9bdf444..4a00ef7 100644
> --- a/drivers/power/generic-adc-battery.c
> +++ b/drivers/power/generic-adc-battery.c
> @@ -327,7 +327,7 @@ static int __devinit gab_probe(struct platform_device *pdev)
>  		ret = request_any_context_irq(irq, gab_charged,
>  				IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
>  				"battery charged", adc_bat);
> -		if (ret)
> +		if (ret < 0)
>  			goto err_gpio;
>  	}
>  
> -- 
> 1.7.9.5
