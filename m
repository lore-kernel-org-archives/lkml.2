Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab2EGTTB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 15:19:01 -0400
Received: from www.linutronix.de ([62.245.132.108]:41678 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab2EGTTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 15:19:00 -0400
Date: Mon, 7 May 2012 21:18:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>
cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: langwell: Prevent possible NULL pointer dereference
 in the demux handler.
In-Reply-To: <1336321508-20981-1-git-send-email-krzysztof.wilczynski@linux.com>
Message-ID: <alpine.LFD.2.02.1205072117330.6271@ionos>
References: <1336321508-20981-1-git-send-email-krzysztof.wilczynski@linux.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 May 2012, Krzysztof Wilczynski wrote:

> This is to address a possible NULL pointer dereference on a platform that might
> use this driver but its underlying IRQ chip does not provide an irq_eoi callback.
> 
> A commit 0766d20 added an conditional to the code, but then it was later
> super-seeded by commit 20e2aa9 which introduced number of helper functions
> for accessing various members of the irq_desc struct, but removed said
> conditional from the code.
> 
> This change will re-introduce conditional guarding against possible NULL
> pointer dereference caused by missing EIO handler.
> 
> Signed-off-by: Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>
> ---
>  drivers/gpio/gpio-langwell.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-langwell.c b/drivers/gpio/gpio-langwell.c
> index 00692e8..5749738 100644
> --- a/drivers/gpio/gpio-langwell.c
> +++ b/drivers/gpio/gpio-langwell.c
> @@ -260,7 +260,8 @@ static void lnw_irq_handler(unsigned irq, struct irq_desc *desc)
>  		}
>  	}
>  
> -	chip->irq_eoi(data);
> +	if (data)
> +		chip->irq_eoi(data);

And how does data, which is always set as long as the interrupt exist
prove that the chip has an eoi function?

Thanks,

	tglx
