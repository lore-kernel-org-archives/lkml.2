Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758458Ab1DMVPR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 17:15:17 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39979 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434Ab1DMVPP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 17:15:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=VyiQC+UmqjqKJP9Ly05vLun4sDlY+CiQRzVIOZBVtEoZabUMqaR1fCaHc4w6gUQcIk
         TGDRzL36giAMjOLwjVuF+CFDlPRK1qDZSAuCslsOgxLAAxHwmcKHH33t2Xr+g9NSAxZb
         XOQ+LkzcflzEvzH40VE71K33dD99bPM5qNmxE=
MIME-Version: 1.0
In-Reply-To: <20110405152728.744338123@chello.nl>
References: <20110405152338.692966333@chello.nl>
	<20110405152728.744338123@chello.nl>
Date: Wed, 13 Apr 2011 14:15:14 -0700
X-Google-Sender-Auth: dG3yoTMeR2k7YemNVPYrDuS6Qws
Message-ID: <BANLkTi=+x6+tyHY2uOvE99BXxdreb3Gu=Q@mail.gmail.com>
Subject: Re: [PATCH 01/21] sched: Provide scheduler_ipi() callback in response
 to smp_send_reschedule()
From: Tony Luck <tony.luck@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ralf Baechle <ralf@linux-mips.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 5, 2011 at 8:23 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> --- linux-2.6.orig/arch/ia64/kernel/irq_ia64.c
> +++ linux-2.6/arch/ia64/kernel/irq_ia64.c
> @@ -31,6 +31,7 @@
>  #include <linux/irq.h>
>  #include <linux/ratelimit.h>
>  #include <linux/acpi.h>
> +#include <linux/sched.h>
>
>  #include <asm/delay.h>
>  #include <asm/intrinsics.h>
> @@ -496,6 +497,7 @@ ia64_handle_irq (ia64_vector vector, str
>                        smp_local_flush_tlb();
>                        kstat_incr_irqs_this_cpu(irq, desc);
>                } else if (unlikely(IS_RESCHEDULE(vector))) {
> +                       scheduler_ipi();
>                        kstat_incr_irqs_this_cpu(irq, desc);
>                } else {
>                        ia64_setreg(_IA64_REG_CR_TPR, vector);

This bit breaks ia64 CONFIG_SMP=n builds in next-20110413 with:

arch/ia64/kernel/irq_ia64.c: In function ‘ia64_handle_irq’:
arch/ia64/kernel/irq_ia64.c:500: error: implicit declaration of
function ‘scheduler_ipi’

-Tony
