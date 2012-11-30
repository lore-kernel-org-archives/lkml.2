Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254Ab2K3OBQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 09:01:16 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42473 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144Ab2K3OBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 09:01:15 -0500
Date: Fri, 30 Nov 2012 14:01:10 +0000
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, viresh.kumar@linaro.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 1/1] mfd: Simplify IRQ domain registration code in STMPE
Message-ID: <20121130140110.GC23648@gmail.com>
References: <1353683969-9332-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1353683969-9332-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Nov 2012, Lee Jones wrote:

> Historically, a driver would have to decide whether it required
> a Linear or Legacy IRQ domain when registering one. This can end
> up as quite a lot of code. A new Simple call now exists which
> simplifies this process. Let's make use of it here.
> 
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/stmpe.c |   14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
> index b03cc64..0e6d8b8 100644
> --- a/drivers/mfd/stmpe.c
> +++ b/drivers/mfd/stmpe.c
> @@ -889,18 +889,14 @@ static struct irq_domain_ops stmpe_irq_ops = {
>  static int __devinit stmpe_irq_init(struct stmpe *stmpe,
>  				struct device_node *np)
>  {
> -	int base = stmpe->irq_base;
> +	int base = 0;
>  	int num_irqs = stmpe->variant->num_irqs;
>  
> -	if (base) {
> -		stmpe->domain = irq_domain_add_legacy(
> -			np, num_irqs, base, 0, &stmpe_irq_ops, stmpe);
> -	}
> -	else {
> -		stmpe->domain = irq_domain_add_linear(
> -			np, num_irqs, &stmpe_irq_ops, stmpe);
> -	}
> +	if (!np)
> +		base = stmpe->irq_base;
>  
> +	stmpe->domain = irq_domain_add_simple(np, num_irqs, base,
> +					      &stmpe_irq_ops, stmpe);
>  	if (!stmpe->domain) {
>  		dev_err(stmpe->dev, "Failed to create irqdomain\n");
>  		return -ENOSYS;
> -- 
> 1.7.9.5

Poke.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
