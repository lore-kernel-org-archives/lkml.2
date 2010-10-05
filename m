Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484Ab0JEJOL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 05:14:11 -0400
Received: from www.tglx.de ([62.245.132.106]:41623 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755300Ab0JEJOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 05:14:10 -0400
Date: Tue, 5 Oct 2010 11:13:53 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>, x86@kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 04/22] x86/io_apic: add get_nr_irqs_gsi()
In-Reply-To: <1286216015-9710-5-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.LFD.2.00.1010051112560.2556@localhost6.localdomain6>
References: <1286216015-9710-1-git-send-email-konrad.wilk@oracle.com> <1286216015-9710-5-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Oct 2010, Konrad Rzeszutek Wilk wrote:

> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> Impact: new interface to get max GSI
> 
> Add get_nr_irqs_gsi() to return nr_irqs_gsi.  Xen will use this to
> determine how many irqs it needs to reserve for hardware irqs.

Acked.by: Thomas Gleixner <tglx@linutronix.de>

> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Reviewed-by: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: x86@kernel.org
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> ---
>  arch/x86/include/asm/io_apic.h |    1 +
>  arch/x86/kernel/apic/io_apic.c |    5 +++++
>  2 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
> index 9cb2edb..f27c681 100644
> --- a/arch/x86/include/asm/io_apic.h
> +++ b/arch/x86/include/asm/io_apic.h
> @@ -169,6 +169,7 @@ extern void mask_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
>  extern int restore_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
>  
>  extern void probe_nr_irqs_gsi(void);
> +extern int get_nr_irqs_gsi(void);
>  
>  extern int setup_ioapic_entry(int apic, int irq,
>  			      struct IO_APIC_route_entry *entry,
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index f1efeba..4c9b2b9 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -3862,6 +3862,11 @@ void __init probe_nr_irqs_gsi(void)
>  	printk(KERN_DEBUG "nr_irqs_gsi: %d\n", nr_irqs_gsi);
>  }
>  
> +int get_nr_irqs_gsi(void)
> +{
> +	return nr_irqs_gsi;
> +}
> +
>  #ifdef CONFIG_SPARSE_IRQ
>  int __init arch_probe_nr_irqs(void)
>  {
> -- 
> 1.7.0.4
> 
