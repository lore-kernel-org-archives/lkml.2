Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853Ab1DZSYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 14:24:30 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:58241 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757556Ab1DZSY2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 14:24:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XBvGIWF1aCTXReNaRt9z+z8cRMCo8WiRY2ziZizhOfPItfhWbXm2tE9ZvCU5qZaPvN
         P5aRY9Rhrx78fLD9Uc+lI8EPwzbITmtMF+GZPWBpZ655ALtqHH7hQUaxvwCLrjoZslXi
         7nZsAvOGOt8wcAcJOHNW1+mjXd6+actlPXoa0=
MIME-Version: 1.0
In-Reply-To: <20110425183943.2693.A69D9226@jp.fujitsu.com>
References: <20110425183810.268B.A69D9226@jp.fujitsu.com>
	<20110425183943.2693.A69D9226@jp.fujitsu.com>
Date: Tue, 26 Apr 2011 15:24:26 -0300
Message-ID: <BANLkTimx=ZqJJNMZUqExEhzbN2czdPg2ZA@mail.gmail.com>
Subject: Re: [PATCH 3/3] m32r: remove redundant declaration
From: Thiago Farina <tfransosi@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hirokazu Takata <takata@linux-m32r.org>, linux-m32r@ml.linux-m32r.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 6:38 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> They has no meanings.
>
s/has/have ?

> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Hirokazu Takata <takata@linux-m32r.org>
> Cc: linux-m32r@ml.linux-m32r.org
> ---
>  arch/m32r/kernel/smp.c |   13 ++-----------
>  1 files changed, 2 insertions(+), 11 deletions(-)
>
> diff --git a/arch/m32r/kernel/smp.c b/arch/m32r/kernel/smp.c
> index f758100..092d40a 100644
> --- a/arch/m32r/kernel/smp.c
> +++ b/arch/m32r/kernel/smp.c
> @@ -30,6 +30,7 @@
>  #include <asm/io.h>
>  #include <asm/mmu_context.h>
>  #include <asm/m32r.h>
> +#include <asm/tlbflush.h>
>
>  /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
>  /* Data structures and variables                                             */
> @@ -61,27 +62,17 @@ extern spinlock_t ipi_lock[];
>  /* Function Prototypes                                                       */
>  /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
>
> -void smp_send_reschedule(int);
>  void smp_reschedule_interrupt(void);
> -
> -void smp_flush_cache_all(void);
>  void smp_flush_cache_all_interrupt(void);
>
> -void smp_flush_tlb_all(void);
>  static void flush_tlb_all_ipi(void *);
> -
> -void smp_flush_tlb_mm(struct mm_struct *);
> -void smp_flush_tlb_range(struct vm_area_struct *, unsigned long, \
> -       unsigned long);
> -void smp_flush_tlb_page(struct vm_area_struct *, unsigned long);
>  static void flush_tlb_others(cpumask_t, struct mm_struct *,
>        struct vm_area_struct *, unsigned long);
> +
>  void smp_invalidate_interrupt(void);
>
> -void smp_send_stop(void);
>  static void stop_this_cpu(void *);
>
> -void smp_send_timer(void);
>  void smp_ipi_timer_interrupt(struct pt_regs *);
>  void smp_local_timer_interrupt(void);
>
> --
> 1.7.3.1
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
