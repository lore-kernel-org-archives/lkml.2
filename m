Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab0KHOli (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 09:41:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2260 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754454Ab0KHOlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 09:41:37 -0500
Date: Mon, 8 Nov 2010 09:41:14 -0500
From: Don Zickus <dzickus@redhat.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86, hw_nmi: Move backtrace_mask declaration under
 ARCH_HAS_NMI_WATCHDOG.
Message-ID: <20101108144113.GA29110@redhat.com>
References: <AANLkTimW+GdKZEZdR5DtAp8=D7muTOvVcvuPoiCR2Y2p@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimW+GdKZEZdR5DtAp8=D7muTOvVcvuPoiCR2Y2p@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 07, 2010 at 01:41:34PM +0600, Rakib Mullick wrote:
> backtrace_mask has been used under the code context of
> ARCH_HAS_NMI_WATCHDOG. So put it into that context.
> We were warned by the following warning:
> 
> arch/x86/kernel/apic/hw_nmi.c:21: warning: ‘backtrace_mask’ defined but not used

Thanks, I'll pull that into my tree.

Cheers,
Don

> 
> 
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> ---
> 
> diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
> index cefd694..62f6e1e 100644
> --- a/arch/x86/kernel/apic/hw_nmi.c
> +++ b/arch/x86/kernel/apic/hw_nmi.c
> @@ -17,15 +17,16 @@
>  #include <linux/nmi.h>
>  #include <linux/module.h>
> 
> -/* For reliability, we're prepared to waste bits here. */
> -static DECLARE_BITMAP(backtrace_mask, NR_CPUS) __read_mostly;
> -
>  u64 hw_nmi_get_sample_period(void)
>  {
>  	return (u64)(cpu_khz) * 1000 * 60;
>  }
> 
>  #ifdef ARCH_HAS_NMI_WATCHDOG
> +
> +/* For reliability, we're prepared to waste bits here. */
> +static DECLARE_BITMAP(backtrace_mask, NR_CPUS) __read_mostly;
> +
>  void arch_trigger_all_cpu_backtrace(void)
>  {
>  	int i;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
