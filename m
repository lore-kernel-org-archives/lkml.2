Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab1ECJ3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 05:29:55 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48595 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750898Ab1ECJ3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 05:29:54 -0400
Subject: Re: [PATCHv2 4/4] ARM: tegra: irq: Add tegra_eoi
From: Will Deacon <will.deacon@arm.com>
To: Colin Cross <ccross@android.com>
Cc: lakml <linux-arm-kernel@lists.infradead.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <1304288854-11011-1-git-send-email-ccross@android.com>
References: <1304284213-11950-5-git-send-email-ccross@android.com>
	 <1304288854-11011-1-git-send-email-ccross@android.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 May 2011 10:29:33 +0100
Message-ID: <1304414973.27863.2.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Colin,

On Sun, 2011-05-01 at 23:27 +0100, Colin Cross wrote:
> Implement irq_eoi to allow the GIC irq chip flow controller to
> be changed to fasteoi.
> 
> Signed-off-by: Colin Cross <ccross@android.com>
> ---
> v2: Add tegra_eoi without removing tegra_ack, patch can now be
>     merged safely before Will Deacon's gic fasteoi patch
> 
>  arch/arm/mach-tegra/irq.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-tegra/irq.c b/arch/arm/mach-tegra/irq.c
> index da17491..4956c3c 100644
> --- a/arch/arm/mach-tegra/irq.c
> +++ b/arch/arm/mach-tegra/irq.c
> @@ -95,6 +95,14 @@ static void tegra_ack(struct irq_data *d)
>         tegra_irq_write_mask(d->irq, ICTLR_CPU_IEP_FIR_CLR);
>  }
> 
> +static void tegra_eoi(struct irq_data *d)
> +{
> +       if (d->irq < FIRST_LEGACY_IRQ)
> +               return;
> +
> +       tegra_irq_write_mask(d->irq, ICTLR_CPU_IEP_FIR_CLR);
> +}
> +
>  static int tegra_retrigger(struct irq_data *d)
>  {
>         if (d->irq < FIRST_LEGACY_IRQ)
> @@ -116,6 +124,7 @@ void __init tegra_init_irq(void)
>         }
> 
>         gic_arch_extn.irq_ack = tegra_ack;
> +       gic_arch_extn.irq_eoi = tegra_eoi;
>         gic_arch_extn.irq_mask = tegra_mask;
>         gic_arch_extn.irq_unmask = tegra_unmask;
>         gic_arch_extn.irq_retrigger = tegra_retrigger;
> --
> 1.7.4.1

Just the job!

Acked-by: Will Deacon <will.deacon@arm.com>

Thanks,

Will

