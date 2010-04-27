Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab0D0No1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 09:44:27 -0400
Received: from www.tglx.de ([62.245.132.106]:59230 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752930Ab0D0NoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 09:44:25 -0400
Date: Tue, 27 Apr 2010 15:42:11 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Guillaume Knispel <gknispel@proformatique.com>
cc: linux-kernel@vger.kernel.org, Linuxppc-dev@lists.ozlabs.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>, Ingo Molnar <mingo@elte.hu>,
       Lars-Peter Clausen <lars@metafoo.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Buesch <mb@bu3sch.de>, Peter Zijlstra <peterz@infradead.org>,
       Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH 1/2] genirq: reliably replay pending edge-triggered irq
In-Reply-To: <1271941798-9659-2-git-send-email-gknispel@proformatique.com>
Message-ID: <alpine.LFD.2.00.1004271537130.2951@localhost.localdomain>
References: <1271941798-9659-1-git-send-email-gknispel@proformatique.com> <1271941798-9659-2-git-send-email-gknispel@proformatique.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Apr 2010, Guillaume Knispel wrote:

> When the critical section in handle_edge_irq() is executed after
> IRQ_DISABLED has been set in the one in disable_irq(), the interrupt is

  in the one ? -ENOPARSE

> acked and masked at controller level and IRQ_PENDING is set.
> ---
>  arch/arm/Kconfig                                   |    4 ----
>  arch/arm/configs/acs5k_defconfig                   |    1 -
>  arch/arm/configs/acs5k_tiny_defconfig              |    1 -

   Changing the defconfigs should be a separate patch and I'm not
   going to push such a thing through the genirq tree. The stale
   entries do not hurt.

> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index 127b871..9bec343 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -1423,7 +1423,7 @@ int setup_ioapic_entry(int apic_id, int irq,
>  	entry->polarity = polarity;
>  
>  	/* Mask level triggered irqs.
> -	 * Use IRQ_DELAYED_DISABLE for edge triggered irqs.
> +	 * Edge triggered irqs can be resent by software.

  That change is unrelated and should be done in a seperate patch.

Thanks,

	tglx
