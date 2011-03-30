Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab1C3B5t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 21:57:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:55335 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755348Ab1C3B5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 21:57:47 -0400
Subject: Re: linux-next: build failure after merge of the Linus' tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-next@vger.kernel.org,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20110330110027.b83a1d20.sfr@canb.auug.org.au>
References: <20110330110027.b83a1d20.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Mar 2011 12:56:43 +1100
Message-ID: <1301450203.2402.716.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-30 at 11:00 +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the Linus' tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> kernel/irq/chip.c: In function 'handle_edge_eoi_irq':
> kernel/irq/chip.c:517: warning: label 'out_unlock' defined but not used
> kernel/irq/chip.c:503: error: label 'out_eoi' used but not defined

There's a fix in tip/irq/urgent ...

Cheers,
Ben.

> Caused by commit 0521c8fbb3da ("genirq: Provide edge_eoi flow handler")
> which was clearly not even built with CONFIG_IRQ_EDGE_EOI_HANDLER defined.
> 
> I applied this fixup patch:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 30 Mar 2011 10:55:12 +1100
> Subject: [PATCH] genirq: fix CONFIG_IRQ_EDGE_EOI_HANDLER build
> 
> Fixes these errors:
> 
> kernel/irq/chip.c: In function 'handle_edge_eoi_irq':
> kernel/irq/chip.c:517: warning: label 'out_unlock' defined but not used
> kernel/irq/chip.c:503: error: label 'out_eoi' used but not defined
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  kernel/irq/chip.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> index 616ec1c..1dafc86 100644
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -514,7 +514,7 @@ void handle_edge_eoi_irq(unsigned int irq, struct irq_desc *desc)
>  	} while ((desc->istate & IRQS_PENDING) &&
>  		 !irqd_irq_disabled(&desc->irq_data));
>  
> -out_unlock:
> +out_eoi:
>  	chip->irq_eoi(&desc->irq_data);
>  	raw_spin_unlock(&desc->lock);
>  }
> -- 
> 1.7.4.1
> 
> 


