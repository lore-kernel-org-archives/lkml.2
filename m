Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab1I0Fwb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 01:52:31 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49428 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab1I0Fw3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 01:52:29 -0400
MIME-Version: 1.0
In-Reply-To: <20110927134534.af4c3bdad6918111a2e03034@canb.auug.org.au>
References: <20110927134534.af4c3bdad6918111a2e03034@canb.auug.org.au>
Date: Tue, 27 Sep 2011 07:52:28 +0200
Message-ID: <CAKnu2MoTz5cv9m+x84NeEbO-6YaK0QwwSaHpFwfBWiBG+GrdLw@mail.gmail.com>
Subject: Re: linux-next: manual merge of the mfd tree with the arm tree
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/27 Stephen Rothwell <sfr@canb.auug.org.au>:

> Today's linux-next merge of the mfd tree got a conflict in
> arch/arm/mach-u300/include/mach/irqs.h between commit cc890cd78acd ("ARM:
> 7083/1: rewrite U300 GPIO to use gpiolib") from the  tree and commit
> e085f9a2e27d ("mfd: Delete ab3550 driver") from the mfd tree.
> I fixed it up (I think - see below) anc can carry the fix as necessary.
> (...)
>
> diff --cc arch/arm/mach-u300/include/mach/irqs.h
> index d270fea,a6867b1..0000000
> --- a/arch/arm/mach-u300/include/mach/irqs.h
> +++ b/arch/arm/mach-u300/include/mach/irqs.h
> @@@ -106,25 -106,9 +106,19 @@@
>  #define IRQ_U300_NFIF                 45
>  #define IRQ_U300_NFIF2                        46
>  #define IRQ_U300_SYSCON_PLL_LOCK      47
>  -#define U300_NR_IRQS                  48
>  +#define U300_VIC_IRQS_END             48
>  #endif
>
>  -#define NR_IRQS U300_NR_IRQS
>  +/* Maximum 8*7 GPIO lines */
>  +#ifdef CONFIG_GPIO_U300
>  +#define IRQ_U300_GPIO_BASE            (U300_VIC_IRQS_END)
>  +#define IRQ_U300_GPIO_END             (IRQ_U300_GPIO_BASE + 56)
>  +#else
>  +#define IRQ_U300_GPIO_END             (U300_VIC_IRQS_END)
>  +#endif
>  +
> - /* Optional AB3550 mixsig chip */
> - #ifdef CONFIG_AB3550_CORE
> - #define IRQ_AB3550_BASE                       (IRQ_U300_GPIO_END)
> - #define IRQ_AB3550_END                        (IRQ_AB3550_BASE + 38)
> - #else
>  +#define IRQ_AB3550_END                        (IRQ_U300_GPIO_END)
> - #endif
>  +
>  +#define NR_IRQS                               (IRQ_AB3550_END)

Nothing mentioning the AB3559 should be left after the merge, so the
IRQ_AB3550_END should be gone.

delete IRQ_AB3550_END and
#define NR_IRQS IRQ_U300_GPIO_END

I will watch this closely in the merge window.

Thanks,
Linus Walleij
