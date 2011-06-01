Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933343Ab1FAKOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 06:14:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:48571 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933260Ab1FAKOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 06:14:45 -0400
Date: Wed, 1 Jun 2011 12:14:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Linux/PPC Development <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] powerpc/fsl: Use irq_data_get_irq_handler_data() in
 chain handler
In-Reply-To: <alpine.DEB.2.00.1106011042080.30334@ayla.of.borg>
Message-ID: <alpine.LFD.2.02.1106011213120.3078@ionos>
References: <alpine.DEB.2.00.1106011042080.30334@ayla.of.borg>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jun 2011, Geert Uytterhoeven wrote:

> If you already have a pointer to a struct irq_data , it's more efficient
> to use irq_data_get_irq_handler_data().
> irq_get_handler_data() has to look up the struct irq_desc pointer again,
> which was already passed to the chain handler.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
> Completely untested, not even compile-tested.
> If this is correct, there are probably more of these?
> 
>  arch/powerpc/sysdev/fsl_msi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/powerpc/sysdev/fsl_msi.c b/arch/powerpc/sysdev/fsl_msi.c
> index 92e7833..9b92c82 100644
> --- a/arch/powerpc/sysdev/fsl_msi.c
> +++ b/arch/powerpc/sysdev/fsl_msi.c
> @@ -193,7 +193,7 @@ static void fsl_msi_cascade(unsigned int irq, struct irq_desc *desc)
>  	u32 have_shift = 0;
>  	struct fsl_msi_cascade_data *cascade_data;
>  
> -	cascade_data = irq_get_handler_data(irq);
> +	cascade_data = irq_data_get_irq_handler_data(idata);

  cascade_data = irq_desc_get_handler_data(desc);

Might compile and work :)

