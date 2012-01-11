Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321Ab2AKJIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 04:08:04 -0500
Received: from merlin.infradead.org ([205.233.59.134]:46608 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756117Ab2AKJH5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 04:07:57 -0500
Message-ID: <1326272868.2442.122.camel@twins>
Subject: Re: [PATCH] sched/s390: fix compile error in sched/core.c
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 11 Jan 2012 10:07:48 +0100
In-Reply-To: <1326268696-30904-1-git-send-email-borntraeger@de.ibm.com>
References: <1326268696-30904-1-git-send-email-borntraeger@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-11 at 08:58 +0100, Christian Borntraeger wrote:
> From: Christian Borntraeger <borntraeger@de.ibm.com>
> 
> commit 029632fbb7b7c9d85063cc9eb470de6c54873df3
>     sched: Make separate sched*.c translation units
> 
> removed the include of asm/mutex.h from sched.c. This breaks the combination of
> 
> CONFIG_MUTEX_SPIN_ON_OWNER=yes
> CONFIG_HAVE_ARCH_MUTEX_CPU_RELAX=yes
> like s390 without mutex debugging:
> 
>   CC      kernel/sched/core.o
> kernel/sched/core.c: In function ‘mutex_spin_on_owner’:
> kernel/sched/core.c:3287: error: implicit declaration of function ‘arch_mutex_cpu_relax’
> make[2]: *** [kernel/sched/core.o] Error 1
> 
> Lets re-add the include to kernel/sched/core.c

Weird, I would have expected -next to pick this up.. Anyway, no
objection although do we really need that extra #ifdef ?

> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  kernel/sched/core.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index cecbb64..f82efdc 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -74,6 +74,9 @@
>  
>  #include <asm/tlb.h>
>  #include <asm/irq_regs.h>
> +#ifdef CONFIG_HAVE_ARCH_MUTEX_CPU_RELAX
> +#include <asm/mutex.h>
> +#endif
>  #ifdef CONFIG_PARAVIRT
>  #include <asm/paravirt.h>
>  #endif

