Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab1GHPdx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 11:33:53 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44491 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab1GHPdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 11:33:52 -0400
Date: Fri, 8 Jul 2011 09:33:49 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: langwell_gpio: ack the correct bit for langwell
 gpio interrupts
Message-ID: <20110708153349.GA9070@ponder.secretlab.ca>
References: <20110708090218.18318.32875.stgit@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110708090218.18318.32875.stgit@bob.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 08, 2011 at 10:02:18AM +0100, Alan Cox wrote:
> From: Mathias Nyman <mathias.nyman@linux.intel.com>
> 
> The wrong bit was masked when acking langwell gpio interrupts.
> 
> Reason for maskig the wrong bit was probably because__ffs() and ffs() functions
> return bit indexes differently (0..31 vs 1..32)
> 
> This fixes langwell based devices from hanging when a gpio interrupt is
> triggered and undoes the breakage which occurred in change set
> 732063b92bb727b27e61580ce278dddefe31c6ad
> 
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> Signed-off-by: Alan Cox <alan@linux.intel.com>

Merged, thanks.

g.

> ---
> 
>  drivers/gpio/langwell_gpio.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/drivers/gpio/langwell_gpio.c b/drivers/gpio/langwell_gpio.c
> index bd6571e..644ba12 100644
> --- a/drivers/gpio/langwell_gpio.c
> +++ b/drivers/gpio/langwell_gpio.c
> @@ -223,7 +223,7 @@ static void lnw_irq_handler(unsigned irq, struct irq_desc *desc)
>  		gedr = gpio_reg(&lnw->chip, base, GEDR);
>  		pending = readl(gedr);
>  		while (pending) {
> -			gpio = __ffs(pending) - 1;
> +			gpio = __ffs(pending);
>  			mask = BIT(gpio);
>  			pending &= ~mask;
>  			/* Clear before handling so we can't lose an edge */
> 
