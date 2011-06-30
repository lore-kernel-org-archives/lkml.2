Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758549Ab1F3H10 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 03:27:26 -0400
Received: from www.linutronix.de ([62.245.132.108]:48368 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674Ab1F3H1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 03:27:23 -0400
Date: Thu, 30 Jun 2011 09:27:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asm-generic: Raise default NR_IRQS when using sparse
 IRQs
In-Reply-To: <1309382426-30614-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Message-ID: <alpine.LFD.2.02.1106300926350.2917@ionos>
References: <1309382426-30614-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jun 2011, Mark Brown wrote:

> Rather than have each platform using sparse IRQs pick a suitably large
> NR_IRQS for use with sparse IRQs make the default high when they are
> enabled.  We pick 64k as there is still a bitmap of IRQs that is
> allocated statically, and as we all know 64k should be enough for
> anyone.

The sparse bitmap is overallocated to NR_IRQS + 8k anyway, so that's
rather pointless.
 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  include/asm-generic/irq.h |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/include/asm-generic/irq.h b/include/asm-generic/irq.h
> index b90ec0b..0d95650 100644
> --- a/include/asm-generic/irq.h
> +++ b/include/asm-generic/irq.h
> @@ -4,11 +4,15 @@
>  /*
>   * NR_IRQS is the upper bound of how many interrupts can be handled
>   * in the platform. It is used to size the static irq_map array,
> - * so don't make it too big.
> + * so don't make it too big unless we're using sparse IRQs.
>   */
>  #ifndef NR_IRQS
> +#ifdef CONFIG_SPARSE_IRQ
> +#define NR_IRQS 0xffff
> +#else
>  #define NR_IRQS 64
>  #endif
> +#endif
>  
>  static inline int irq_canonicalize(int irq)
>  {
> -- 
> 1.7.5.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arch" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
