Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab0KXPpK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 10:45:10 -0500
Received: from www.tglx.de ([62.245.132.106]:50112 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845Ab0KXPpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 10:45:08 -0500
Date: Wed, 24 Nov 2010 16:45:03 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asm-generic: Raise default NR_IRQS when using sparse
 IRQs
In-Reply-To: <1290613156-861-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Message-ID: <alpine.LFD.2.00.1011241642540.2900@localhost6.localdomain6>
References: <1290613156-861-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Nov 2010, Mark Brown wrote:

> Rather than have each platform using sparse IRQs pick a suitably large
> NR_IRQS for use with sparse IRQs make the default exceptionally high
> when they are enabled.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  include/asm-generic/irq.h |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/include/asm-generic/irq.h b/include/asm-generic/irq.h
> index b90ec0b..a76bea2 100644
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
> +#define NR_IRQS 0x7fffffff

Resulting in a 256 MB bitmap. I guess you did not try to boot that on
some random ARM board :)

Thanks,

	tglx
