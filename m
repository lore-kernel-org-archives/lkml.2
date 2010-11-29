Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750921Ab0K2IfF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 03:35:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36009 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835Ab0K2IfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 03:35:04 -0500
Date: Mon, 29 Nov 2010 09:34:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thiago Farina <tfransosi@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] apic/io_apic.c: Move variable 'desc' into the #ifdef.
Message-ID: <20101129083450.GC12374@elte.hu>
References: <4cc988bf535efac7a6aafe1ca0f0ac44f3968d94.1290992687.git.tfransosi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4cc988bf535efac7a6aafe1ca0f0ac44f3968d94.1290992687.git.tfransosi@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thiago Farina <tfransosi@gmail.com> wrote:

> This variable is only used in the presence of the CONFIG_GENERIC_PENDING_IRQ.
> So when compiling without this config, we get the following warning:
> 
> arch/x86/kernel/apic/io_apic.c: In function ‘ack_apic_level’:
> arch/x86/kernel/apic/io_apic.c:2433: warning: unused variable ‘desc’
> 
> Signed-off-by: Thiago Farina <tfransosi@gmail.com>
> ---
>  arch/x86/kernel/apic/io_apic.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index 7cc0a72..56261be 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -2430,9 +2430,12 @@ static void ack_apic_level(struct irq_data *data)
>  {
>  	struct irq_cfg *cfg = data->chip_data;
>  	int i, do_unmask_irq = 0, irq = data->irq;
> -	struct irq_desc *desc = irq_to_desc(irq);
>  	unsigned long v;
>  
> +#ifdef CONFIG_GENERIC_PENDING_IRQ
> +	struct irq_desc *desc = irq_to_desc(irq);
> +#endif
> +
>  	irq_complete_move(cfg);
>  #ifdef CONFIG_GENERIC_PENDING_IRQ
>  	/* If we are moving the irq we need to mask it */

This is very ugly, and it was ugly before your patch as well.

Please move the bits that are under CONFIG_GENERIC_PENDING_IRQ into a helper inline 
function.

Thanks,

	Ingo
