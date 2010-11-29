Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab0K2K1z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 05:27:55 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47680 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101Ab0K2K1y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 05:27:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=w+BU04h3Kn1waF6+DS0NNeqReYHwgP/Q6WjgeJFOi8kNBFQikt9GLNb3RUO4tkhKEN
         X4yM3m8O6jYfxOfkRlubYZbROoxZMR6J9Xh42d3xW1C3+2PBkFf7KfD6P8jqwj9U4jf7
         /+HrQnRD2theHeYCow768NyqH2t3MCtXtRKT8=
MIME-Version: 1.0
In-Reply-To: <4cc988bf535efac7a6aafe1ca0f0ac44f3968d94.1290992687.git.tfransosi@gmail.com>
References: <4cc988bf535efac7a6aafe1ca0f0ac44f3968d94.1290992687.git.tfransosi@gmail.com>
Date: Mon, 29 Nov 2010 16:27:53 +0600
Message-ID: <AANLkTimg5MLkE=38ujG8QHoGfcP-sXSci61Cii_t4kSA@mail.gmail.com>
Subject: Re: [PATCH] apic/io_apic.c: Move variable 'desc' into the #ifdef.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Thiago Farina <tfransosi@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 7:06 AM, Thiago Farina <tfransosi@gmail.com> wrote:
> This variable is only used in the presence of the CONFIG_GENERIC_PENDING_IRQ.
> So when compiling without this config, we get the following warning:
>
> arch/x86/kernel/apic/io_apic.c: In function ‘ack_apic_level’:
> arch/x86/kernel/apic/io_apic.c:2433: warning: unused variable ‘desc’
>

Its been already fixed by
http://marc.info/?l=linux-mm-commits&m=128821373401265&w=2. Currently
its on -mm tree.

thanks,
rakib

> Signed-off-by: Thiago Farina <tfransosi@gmail.com>
> ---
>  arch/x86/kernel/apic/io_apic.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index 7cc0a72..56261be 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -2430,9 +2430,12 @@ static void ack_apic_level(struct irq_data *data)
>  {
>        struct irq_cfg *cfg = data->chip_data;
>        int i, do_unmask_irq = 0, irq = data->irq;
> -       struct irq_desc *desc = irq_to_desc(irq);
>        unsigned long v;
>
> +#ifdef CONFIG_GENERIC_PENDING_IRQ
> +       struct irq_desc *desc = irq_to_desc(irq);
> +#endif
> +
>        irq_complete_move(cfg);
>  #ifdef CONFIG_GENERIC_PENDING_IRQ
>        /* If we are moving the irq we need to mask it */
> --
> 1.7.3.2.343.g7d43d
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
