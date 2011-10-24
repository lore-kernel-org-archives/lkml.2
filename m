Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623Ab1JXNXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 09:23:24 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46759 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369Ab1JXNXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 09:23:23 -0400
Date: Mon, 24 Oct 2011 15:23:19 +0200
From: Grant Likely <grant.likely@secretlab.ca>
To: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org, mingo@kernel.org
Subject: Re: [PATCH v2 1/2] irq: Add EXPORT_SYMBOL_GPL to function of irq
 generic-chip
Message-ID: <20111024132319.GU8708@ponder.secretlab.ca>
References: <1318817327-4589-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318817327-4589-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 11:08:46AM +0900, Nobuhiro Iwamatsu wrote:
> Some functions of irq generic-chip is undefined, because
> EXPORT_SYMBOL_GPL is not set to these.
> 
> -----
> ERROR: "irq_setup_generic_chip" [drivers/gpio/gpio-pch.ko] undefined!
> ERROR: "irq_alloc_generic_chip" [drivers/gpio/gpio-pch.ko] undefined!
> ERROR: "irq_setup_generic_chip" [drivers/gpio/gpio-ml-ioh.ko] undefined!
> ERROR: "irq_alloc_generic_chip" [drivers/gpio/gpio-ml-ioh.ko] undefined!
> -----
> 
> This is revised that EXPORT_SYMBOL_GPL can be added and referred
> to in functions.
> 
> Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>

After getting verbal ack from Thomas, I've merged this via the gpio tree.

g.

> ---
> 
> V2: Add EXPORT_SYMBOL_GPL to irq_setup_generic_chip, irq_alloc_generic_chip,
> irq_setup_alt_chip and irq_remove_generic_chip only.
> 
>  kernel/irq/generic-chip.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
> index e38544d..6cb7613 100644
> --- a/kernel/irq/generic-chip.c
> +++ b/kernel/irq/generic-chip.c
> @@ -211,6 +211,7 @@ irq_alloc_generic_chip(const char *name, int num_ct, unsigned int irq_base,
>  	}
>  	return gc;
>  }
> +EXPORT_SYMBOL_GPL(irq_alloc_generic_chip);
>  
>  /*
>   * Separate lockdep class for interrupt chip which can nest irq_desc
> @@ -258,6 +259,7 @@ void irq_setup_generic_chip(struct irq_chip_generic *gc, u32 msk,
>  	}
>  	gc->irq_cnt = i - gc->irq_base;
>  }
> +EXPORT_SYMBOL_GPL(irq_setup_generic_chip);
>  
>  /**
>   * irq_setup_alt_chip - Switch to alternative chip
> @@ -281,6 +283,7 @@ int irq_setup_alt_chip(struct irq_data *d, unsigned int type)
>  	}
>  	return -EINVAL;
>  }
> +EXPORT_SYMBOL_GPL(irq_setup_alt_chip);
>  
>  /**
>   * irq_remove_generic_chip - Remove a chip
> @@ -311,6 +314,7 @@ void irq_remove_generic_chip(struct irq_chip_generic *gc, u32 msk,
>  		irq_modify_status(i, clr, set);
>  	}
>  }
> +EXPORT_SYMBOL_GPL(irq_remove_generic_chip);
>  
>  #ifdef CONFIG_PM
>  static int irq_gc_suspend(void)
> -- 
> 1.7.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
