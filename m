Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab1HAR07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 13:26:59 -0400
Received: from relais.videotron.ca ([24.201.245.36]:33290 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab1HAR0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 13:26:54 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 01 Aug 2011 18:26:52 +0100 (BST)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux@arm.linux.org.uk, ralf@linux-mips.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: fix compile failure in orion5x/dns323-setup.c
In-reply-to: <1312216934-29710-1-git-send-email-paul.gortmaker@windriver.com>
Message-id: <alpine.LFD.2.00.1108011825190.18706@xanadu.home>
References: <1312216934-29710-1-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Aug 2011, Paul Gortmaker wrote:

> Upstream commit d5341942d784134f2997b3ff82cd63cf71d1f932 "PCI: Make the
> struct pci_dev * argument of pci_fixup_irqs const." leaked an extra
> "const" into an actual call site (vs a proto/decl) which causes this:
> 
> arch/arm/mach-orion5x/dns323-setup.c: In function 'dns323_pci_map_irq':
> arch/arm/mach-orion5x/dns323-setup.c:80: error: expected expression before 'const'
> arch/arm/mach-orion5x/dns323-setup.c:80: error: too few arguments to function 'orion5x_pci_map_irq'
> make[3]: *** [arch/arm/mach-orion5x/dns323-setup.o] Error 1
> 
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Acked-by: Nicolas Pitre <nico@fluxnic.net>
 
> diff --git a/arch/arm/mach-orion5x/dns323-setup.c b/arch/arm/mach-orion5x/dns323-setup.c
> index a6eddae..c105556 100644
> --- a/arch/arm/mach-orion5x/dns323-setup.c
> +++ b/arch/arm/mach-orion5x/dns323-setup.c
> @@ -77,7 +77,7 @@ static int __init dns323_pci_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
>  	/*
>  	 * Check for devices with hard-wired IRQs.
>  	 */
> -	irq = orion5x_pci_map_irq(const dev, slot, pin);
> +	irq = orion5x_pci_map_irq(dev, slot, pin);
>  	if (irq != -1)
>  		return irq;
>  
> -- 
> 1.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
