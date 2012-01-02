Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682Ab2ABIWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 03:22:19 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50725 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab2ABIWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 03:22:18 -0500
Date: Mon, 2 Jan 2012 01:22:14 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Michal Simek <monstr@monstr.eu>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ryan Mallon <rmallon@gmail.com>
Subject: Re: [PATCH 4/4] microblaze: Remove NO_IRQ from architecture
Message-ID: <20120102082214.GF18381@ponder.secretlab.ca>
References: <1324477932-19262-1-git-send-email-monstr@monstr.eu>
 <1324477932-19262-2-git-send-email-monstr@monstr.eu>
 <1324477932-19262-3-git-send-email-monstr@monstr.eu>
 <1324477932-19262-4-git-send-email-monstr@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324477932-19262-4-git-send-email-monstr@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 03:32:12PM +0100, Michal Simek wrote:
> NO_IRQ shouldn't be used by any driver. All Microblaze
> drivers are fixed that's why NO_IRQ can be removed.
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>
> CC: Grant Likely <grant.likely@secretlab.ca>
> CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> CC: Ryan Mallon <rmallon@gmail.com>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

> ---
>  arch/microblaze/include/asm/irq.h |    2 --
>  arch/microblaze/pci/pci-common.c  |    4 ++--
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/microblaze/include/asm/irq.h b/arch/microblaze/include/asm/irq.h
> index b116a82..a175132 100644
> --- a/arch/microblaze/include/asm/irq.h
> +++ b/arch/microblaze/include/asm/irq.h
> @@ -27,8 +27,6 @@ typedef unsigned long irq_hw_number_t;
>  
>  extern unsigned int nr_irq;
>  
> -#define NO_IRQ 0
> -
>  struct pt_regs;
>  extern void do_IRQ(struct pt_regs *regs);
>  
> diff --git a/arch/microblaze/pci/pci-common.c b/arch/microblaze/pci/pci-common.c
> index db841c7..0d71b2e 100644
> --- a/arch/microblaze/pci/pci-common.c
> +++ b/arch/microblaze/pci/pci-common.c
> @@ -242,7 +242,7 @@ int pci_read_irq_line(struct pci_dev *pci_dev)
>  			 line, pin);
>  
>  		virq = irq_create_mapping(NULL, line);
> -		if (virq != NO_IRQ)
> +		if (virq)
>  			irq_set_irq_type(virq, IRQ_TYPE_LEVEL_LOW);
>  	} else {
>  		pr_debug(" Got one, spec %d cells (0x%08x 0x%08x...) on %s\n",
> @@ -253,7 +253,7 @@ int pci_read_irq_line(struct pci_dev *pci_dev)
>  		virq = irq_create_of_mapping(oirq.controller, oirq.specifier,
>  					     oirq.size);
>  	}
> -	if (virq == NO_IRQ) {
> +	if (!virq) {
>  		pr_debug(" Failed to map !\n");
>  		return -1;
>  	}
> -- 
> 1.7.5.4
> 
