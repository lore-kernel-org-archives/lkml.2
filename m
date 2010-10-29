Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761503Ab0J2QcB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 12:32:01 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56621 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab0J2Qb7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 12:31:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=MYTJFXVBj9P4d/r2J/nfgzGVUF7WkSfBYSSF2/uHDPDSDEbM/HZxaMXs61CnQ/ybeB
         /I0AYtBaJpcqWlShjNGTAiusqAWkZAxCrPzjp2mLDjt+YwA6/TopKO6IQW4CVjSbtdg8
         SLZufG4K9Nho2+wfSnY4/U2j111O/dCgXKxnQ=
MIME-Version: 1.0
In-Reply-To: <4CCAD4E8.8040801@snapgear.com>
References: <4CCAD4E8.8040801@snapgear.com>
Date: Fri, 29 Oct 2010 18:31:57 +0200
X-Google-Sender-Auth: zjEguILDuf2UeWMiV8lUeC3i-pI
Message-ID: <AANLkTin4v0=R0Q2etqi+WkLSJTV7T5J01rd+AbymutqG@mail.gmail.com>
Subject: Re: [PATCH][resend] m68k,m68knommu: Do not include linux/hardirq.h in asm/irqflags.h
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: linux-m68k@vger.kernel.org, dhowells@redhat.com, gerg@uclinux.org,
        phdm@macqel.be, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 16:06, Greg Ungerer <gerg@snapgear.com> wrote:
> Philippe DeMuyter noticed this build failure with Linus' current git
> tree. I think it is m68k clean too. If all are ok with it I'll
> pass it directly to Linus.

Sorry, I saw his patch before, but had no spare cycles left for testing.

Unfortunately that breaks CONFIG_MMU=y:

arch/m68k/include/asm/irqflags.h: In function ‘arch_local_irq_enable’:
arch/m68k/include/asm/irqflags.h:43: error: implicit declaration of
function ‘hardirq_count’

But if you protect the #include <linux/hardirq.h> by #ifdef
CONFIG_MMU, I'm happy with
it.

> m68k,m68knommu: Do not include linux/hardirq.h in asm/irqflags.h
>
> Recent changes to header files made kernel compilation for m68k/m68knommu
> fail with :
>  CC      arch/m68knommu/kernel/asm-offsets.s
> In file included from /archives/linux/git/arch/m68k/include/asm/system.h:2,
>                 from include/linux/wait.h:25,
>                 from include/linux/mmzone.h:9,
>                 from include/linux/gfp.h:4,
>                 from include/linux/irq.h:20,
>                 from include/asm-generic/hardirq.h:12,
>                 from
> /archives/linux/git/arch/m68k/include/asm/hardirq_no.h:17,
>                 from /archives/linux/git/arch/m68k/include/asm/hardirq.h:2,
>                 from include/linux/hardirq.h:10,
>                 from /archives/linux/git/arch/m68k/include/asm/irqflags.h:5,
>                 from include/linux/irqflags.h:15,
>                 from include/linux/spinlock.h:53,
>                 from include/linux/seqlock.h:29,
>                 from include/linux/time.h:8,
>                 from include/linux/timex.h:56,
>                 from include/linux/sched.h:56,
>                 from arch/m68knommu/kernel/asm-offsets.c:12:
> /archives/linux/git/arch/m68k/include/asm/system_no.h: In function
> â€˜__xchgâ€™:
> /archives/linux/git/arch/m68k/include/asm/system_no.h:79: error: implicit
> declaration of function â€˜local_irq_saveâ€™
> /archives/linux/git/arch/m68k/include/asm/system_no.h:101: error: implicit
> declaration of function â€˜local_irq_restoreâ€™
>
> Fix that
>
> Signed-off-by: Philippe De Muyter <phdm@macqel.be>
>
> ---
> diff --git a/arch/m68k/include/asm/irqflags.h
> b/arch/m68k/include/asm/irqflags.h
> index 4a5b284..38b414d 100644
> --- a/arch/m68k/include/asm/irqflags.h
> +++ b/arch/m68k/include/asm/irqflags.h
> @@ -2,7 +2,6 @@
>  #define _M68K_IRQFLAGS_H
>  #include <linux/types.h>
> -#include <linux/hardirq.h>
>  #include <linux/preempt.h>
>  #include <asm/thread_info.h>
>  #include <asm/entry.h>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
