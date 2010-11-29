Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab0K2UC6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 15:02:58 -0500
Received: from imp01.mtu.ru ([62.5.255.10]:54494 "EHLO imp01.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271Ab0K2UC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 15:02:57 -0500
Message-ID: <4CF406ED.6070705@pavlinux.ru>
Date: Mon, 29 Nov 2010 23:02:53 +0300
From: Pavel Vasilyev <pavel@pavlinux.ru>
Reply-To: pavel@pavlinux.ru
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] asm-generic: Raise default NR_IRQS when using sparse
 IRQs
References: <fUhqx-3EE-15@gated-at.bofh.it>
In-Reply-To: <fUhqx-3EE-15@gated-at.bofh.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Yversion: Spamooborona-3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.11.2010 22:20, Mark Brown wrote:
> Rather than have each platform using sparse IRQs pick a suitably large
> NR_IRQS for use with sparse IRQs make the default high when they are
> enabled.  We pick 64k as there is still a bitmap of IRQs that is
> allocated statically, and as we all know 64k should be enough for
> anyone.
> 
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

May be

  #define NR_IRQS 15*NR_CPUS

