Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927Ab1FFIVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 04:21:33 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43624 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310Ab1FFIVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 04:21:32 -0400
Date: Mon, 6 Jun 2011 02:21:31 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Florian Fainelli <ffainelli@freebox.fr>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Maxime Bizon <mbizon@freebox.fr>
Subject: Re: [PATCH] x86/devicetree: add missing
 early_init_dt_setup_initrd_arch stub
Message-ID: <20110606082131.GH10410@ponder.secretlab.ca>
References: <201106061015.50039.ffainelli@freebox.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106061015.50039.ffainelli@freebox.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 10:15:49AM +0200, Florian Fainelli wrote:
> From: Florian Fainelli <ffainelli@freebox.fr>
> 
> This patch fixes the following build failure:
> 
> drivers/built-in.o: In function `early_init_dt_check_for_initrd':
> /home/florian/dev/kernel/x86/linux-2.6-x86/drivers/of/fdt.c:571:
> undefined reference to `early_init_dt_setup_initrd_arch'
> make: *** [.tmp_vmlinux1] Error 1
> 
> which happens as soon as we enable initrd support on a x86 devicetree
> platform such as Intel CE4100.
> 
> Tested on a custom Intel CE4100 board.
> 
> CC:stable@kernel.org
> Signed-off-by: Florian Fainelli <ffainelli@freebox.fr>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

> ---
> Grant,
> 
> MIPS, PowerPC, Microblaze and now x86 all have the same way of implementing
> this, would it rather make sense to get this merged to generic devicetree functions
> and let this be overriden if needed?

Probably, but I'm not going to tackle that problem just yet.  Although
if you want to investigate and propose a patch, then go for it.  :-)

g.


> 
> Stable: this is a candidate for 2.6.39.2
> 
> diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
> index 690bc84..9aeb78a 100644
> --- a/arch/x86/kernel/devicetree.c
> +++ b/arch/x86/kernel/devicetree.c
> @@ -13,6 +13,7 @@
>  #include <linux/slab.h>
>  #include <linux/pci.h>
>  #include <linux/of_pci.h>
> +#include <linux/initrd.h>
>  
>  #include <asm/hpet.h>
>  #include <asm/irq_controller.h>
> @@ -98,6 +99,16 @@ void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
>  	return __alloc_bootmem(size, align, __pa(MAX_DMA_ADDRESS));
>  }
>  
> +#ifdef CONFIG_BLK_DEV_INITRD
> +void __init early_init_dt_setup_initrd_arch(unsigned long start,
> +					    unsigned long end)
> +{
> +	initrd_start = (unsigned long)__va(start);
> +	initrd_end = (unsigned long)__va(end);
> +	initrd_below_start_ok = 1;
> +}
> +#endif
> +
>  void __init add_dtb(u64 data)
>  {
>  	initial_dtb = data + offsetof(struct setup_data, data);
> -- 
> 1.7.4.1
> 
