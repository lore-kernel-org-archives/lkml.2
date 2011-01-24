Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507Ab1AXTzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 14:55:12 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63334 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab1AXTzL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 14:55:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=SV8qVCh4hQOkHKliTYyltuugKZX8nE/A+2Q38Xw9UfjxQUnGWIpmLFlOqY+pzYovYU
         yemjpz663k9pCI1Bi+hqJGbYXtehBS1vM/HzBhVealAFgIh+Q7BIRdiMo/JlV+/+NK15
         rQuc910wZUBeuCmExoLVNkKBG3sPjZbC4njPY=
MIME-Version: 1.0
In-Reply-To: <1295789862-25482-4-git-send-email-tj@kernel.org>
References: <1295789862-25482-1-git-send-email-tj@kernel.org>
	<1295789862-25482-4-git-send-email-tj@kernel.org>
Date: Mon, 24 Jan 2011 11:55:10 -0800
X-Google-Sender-Auth: ORUIkCVXEWFFxpbMgEBKf9KE6ZY
Message-ID: <AANLkTik0eOxrqwV-xd-tJKXFRG9=irVXs9uJtpZ57qLU@mail.gmail.com>
Subject: Re: [PATCH 03/16] x86: Make default_send_IPI_mask_sequence/allbutself_logical()
 32bit only
From: Yinghai Lu <yinghai@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, x86@kernel.org, eric.dumazet@gmail.com,
        brgerst@gmail.com, gorcunov@gmail.com, penberg@kernel.org,
        shaohui.zheng@intel.com, rientjes@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 23, 2011 at 5:37 AM, Tejun Heo <tj@kernel.org> wrote:
> Both functions are used only in 32bit.  Put them inside CONFIG_X86_32.
> This is to prepare for logical apicid handling update.
>
> - Cyrill Gorcunov spotted that I forgot to move declarations in ipi.h
>  under CONFIG_X86_32.  Fixed.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reviewed-by: Pekka Enberg <penberg@kernel.org>
> Reviewed-by: Cyrill Gorcunov <gorcunov@gmail.com>
> ---
>  arch/x86/include/asm/ipi.h |    8 ++++----
>  arch/x86/kernel/apic/ipi.c |    4 ++--
>  2 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/include/asm/ipi.h b/arch/x86/include/asm/ipi.h
> index 0b72282..615fa90 100644
> --- a/arch/x86/include/asm/ipi.h
> +++ b/arch/x86/include/asm/ipi.h
> @@ -123,10 +123,6 @@ extern void default_send_IPI_mask_sequence_phys(const struct cpumask *mask,
>                                                 int vector);
>  extern void default_send_IPI_mask_allbutself_phys(const struct cpumask *mask,
>                                                         int vector);
> -extern void default_send_IPI_mask_sequence_logical(const struct cpumask *mask,
> -                                                        int vector);
> -extern void default_send_IPI_mask_allbutself_logical(const struct cpumask *mask,
> -                                                        int vector);
>
>  /* Avoid include hell */
>  #define NMI_VECTOR 0x02
> @@ -150,6 +146,10 @@ static inline void __default_local_send_IPI_all(int vector)
>  }
>
>  #ifdef CONFIG_X86_32
> +extern void default_send_IPI_mask_sequence_logical(const struct cpumask *mask,
> +                                                        int vector);
> +extern void default_send_IPI_mask_allbutself_logical(const struct cpumask *mask,
> +                                                        int vector);
>  extern void default_send_IPI_mask_logical(const struct cpumask *mask,
>                                                 int vector);
>  extern void default_send_IPI_allbutself(int vector);
> diff --git a/arch/x86/kernel/apic/ipi.c b/arch/x86/kernel/apic/ipi.c
> index 08385e0..5037736 100644
> --- a/arch/x86/kernel/apic/ipi.c
> +++ b/arch/x86/kernel/apic/ipi.c
> @@ -56,6 +56,8 @@ void default_send_IPI_mask_allbutself_phys(const struct cpumask *mask,
>        local_irq_restore(flags);
>  }
>
> +#ifdef CONFIG_X86_32
> +
>  void default_send_IPI_mask_sequence_logical(const struct cpumask *mask,
>                                                 int vector)
>  {
> @@ -96,8 +98,6 @@ void default_send_IPI_mask_allbutself_logical(const struct cpumask *mask,
>        local_irq_restore(flags);
>  }
>
> -#ifdef CONFIG_X86_32
> -
>  /*
>  * This is only used on smaller machines.
>  */

Acked-by: Yinghai Lu <yinghai@kernel.org>
