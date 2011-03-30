Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab1C3B5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 21:57:48 -0400
Received: from gate.crashing.org ([63.228.1.57]:55334 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755334Ab1C3B5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 21:57:47 -0400
Subject: Re: linux-next: build failure after merge of the Linus' tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-next@vger.kernel.org,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20110330110045.48fb0ccf.sfr@canb.auug.org.au>
References: <20110330110045.48fb0ccf.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Mar 2011 12:57:01 +1100
Message-ID: <1301450221.2402.717.camel@pasglop>
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
> arch/powerpc/platforms/cell/interrupt.c: In function 'iic_host_map':
> arch/powerpc/platforms/cell/interrupt.c:247: error: 'handle_iic_irq' undeclared (first use in this function)

There's a fix in powerpc "merge" for which I'm about to send Linus a
pull request :-)

Cheers,
Ben.

> Caused by commit f9ba4475f95b ("powerpc: cell: Use the core flow handler").
> 
> I applied the following patch:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 30 Mar 2011 10:48:28 +1100
> Subject: [PATCH] powerpc/cell: fixup for removal of handle_iic_irq
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  arch/powerpc/platforms/cell/interrupt.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/cell/interrupt.c b/arch/powerpc/platforms/cell/interrupt.c
> index a19bec0..44cfd1b 100644
> --- a/arch/powerpc/platforms/cell/interrupt.c
> +++ b/arch/powerpc/platforms/cell/interrupt.c
> @@ -244,7 +244,7 @@ static int iic_host_map(struct irq_host *h, unsigned int virq,
>  		break;
>  	case IIC_IRQ_TYPE_IOEXC:
>  		irq_set_chip_and_handler(virq, &iic_ioexc_chip,
> -					 handle_iic_irq);
> +					 handle_edge_eoi_irq);
>  		break;
>  	default:
>  		irq_set_chip_and_handler(virq, &iic_chip, handle_edge_eoi_irq);
> -- 
> 1.7.4.1
> 


