Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab0K2A6d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 19:58:33 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41870 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab0K2A6c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 19:58:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SeZZLzFzE93fOaetaslQ46BojgJ4CaDxgmaKTnHZ+Sm4Hm1GaFLKjNNbFUNP5kEbrs
         RYMpGY3lbHM5+a3HcQCVaxa9wip7tLBiTKYYm5CPVfMRyM82Y9KML2W+z886MmZlunhP
         9IAcUjYCIcNqGbjcNTWF7fA4Q+7bCrbEfKHmA=
MIME-Version: 1.0
In-Reply-To: <9354bfd606c4f42b8433bfb1be173198e94f1d87.1290991196.git.tfransosi@gmail.com>
References: <9354bfd606c4f42b8433bfb1be173198e94f1d87.1290991196.git.tfransosi@gmail.com>
	<9354bfd606c4f42b8433bfb1be173198e94f1d87.1290991196.git.tfransosi@gmail.com>
Date: Sun, 28 Nov 2010 22:58:31 -0200
Message-ID: <AANLkTike+reihX6k4FoXc0kva6Mwq5rs6QBu-84MYR0g@mail.gmail.com>
Subject: Re: [PATCH] apic/io_apic.c: Remove unused variable 'desc'.
From: Thiago Farina <tfransosi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 28, 2010 at 10:42 PM, Thiago Farina <tfransosi@gmail.com> wrote:
> This fix the following warning:
>
> arch/x86/kernel/apic/io_apic.c: In function ‘ack_apic_level’:
> arch/x86/kernel/apic/io_apic.c:2433: warning: unused variable ‘desc’
>
> Signed-off-by: Thiago Farina <tfransosi@gmail.com>
> ---
>  arch/x86/kernel/apic/io_apic.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index 7cc0a72..31c493d 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -2430,7 +2430,6 @@ static void ack_apic_level(struct irq_data *data)
>  {
>        struct irq_cfg *cfg = data->chip_data;
>        int i, do_unmask_irq = 0, irq = data->irq;
> -       struct irq_desc *desc = irq_to_desc(irq);
>        unsigned long v;
>
>        irq_complete_move(cfg);
> --
> 1.7.3.2.343.g7d43d
>
>

Please, disregard this. This variable is used in the #ifdef
CONFIG_GENERIC_PENDING_IRQ. Sorry for the noise.
