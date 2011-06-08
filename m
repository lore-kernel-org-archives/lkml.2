Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab1FHRc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 13:32:56 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33290 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab1FHRcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 13:32:55 -0400
Date: Wed, 8 Jun 2011 11:32:53 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: David Jander <david@protonic.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 5/6] GPIO: pca953x.c: Fix warning of enabled
 interrupts in handler
Message-ID: <20110608173253.GM8499@ponder.secretlab.ca>
References: <1307537314-4345-1-git-send-email-david@protonic.nl>
 <1307537314-4345-6-git-send-email-david@protonic.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307537314-4345-6-git-send-email-david@protonic.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 02:48:33PM +0200, David Jander wrote:
> When using nested threaded irqs, use handle_nested_irq(). This function
> does not call the chip handler, so no handler is set.
> 
> Signed-off-by: David Jander <david@protonic.nl>

Merged, thanks.

g.

> ---
>  drivers/gpio/pca953x.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
> index 97e0d32..dfed81f 100644
> --- a/drivers/gpio/pca953x.c
> +++ b/drivers/gpio/pca953x.c
> @@ -436,7 +436,7 @@ static irqreturn_t pca953x_irq_handler(int irq, void *devid)
>  
>  	do {
>  		level = __ffs(pending);
> -		generic_handle_irq(level + chip->irq_base);
> +		handle_nested_irq(level + chip->irq_base);
>  
>  		pending &= ~(1 << level);
>  	} while (pending);
> @@ -484,8 +484,8 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
>  
>  			irq_clear_status_flags(irq, IRQ_NOREQUEST);
>  			irq_set_chip_data(irq, chip);
> -			irq_set_chip_and_handler(irq, &pca953x_irq_chip,
> -						 handle_simple_irq);
> +			irq_set_chip(irq, &pca953x_irq_chip);
> +			irq_set_nested_thread(irq, true);
>  #ifdef CONFIG_ARM
>  			set_irq_flags(irq, IRQF_VALID);
>  #else
> -- 
> 1.7.4.1
> 
