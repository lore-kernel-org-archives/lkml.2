Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab0LTEZR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 23:25:17 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:58629 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab0LTEZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 23:25:14 -0500
Date: Mon, 20 Dec 2010 13:23:44 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sundar Iyer <sundar.iyer@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: linux-next: manual merge of the mfd tree with the ux500-core tree
Message-ID: <20101220042344.GB10050@linux-sh.org>
References: <20101220152148.6fedee0d.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101220152148.6fedee0d.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 03:21:48PM +1100, Stephen Rothwell wrote:
> The genirq core is being converted to pass struct irq_data to irq_chip
> operations rather than an IRQ number. Update the tc35892 driver to the
> new APIs.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Acked-by: Rabin Vincent <rabin.vincent@stericsson.com>
> Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>

Sorry to hijack the thread..

> diff --git a/drivers/mfd/tc3589x.c b/drivers/mfd/tc3589x.c
> index 32291fe..dde2d858 100644
> --- a/drivers/mfd/tc3589x.c
> +++ b/drivers/mfd/tc3589x.c
> @@ -170,15 +170,15 @@ again:
>  	return IRQ_HANDLED;
>  }
>  
> -static void tc3589x_irq_dummy(unsigned int irq)
> +static void tc3589x_irq_dummy(struct irq_data *data)
>  {
>  	/* No mask/unmask at this level */
>  }
>  
>  static struct irq_chip tc3589x_irq_chip = {
> -	.name	= "tc3589x",
> -	.mask	= tc3589x_irq_dummy,
> -	.unmask	= tc3589x_irq_dummy,
> +	.name		= "tc3589x",
> +	.irq_mask	= tc3589x_irq_dummy,
> +	.irq_unmask	= tc3589x_irq_dummy,
>  };
>  
>  static int tc3589x_irq_init(struct tc3589x *tc3589x)

Is there some reason you don't just kill this off and use dummy_irq_chip?
