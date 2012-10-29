Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab2J2Nwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 09:52:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16043 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024Ab2J2Nwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 09:52:43 -0400
X-Authority-Analysis: v=2.0 cv=NLdXCjGg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=kv1AdNOf53YA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=86CsJcgIa_4A:10 a=pGLkceISAAAA:8 a=JfrnYn6hAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=t7CeM3EgAAAA:8 a=0TcnM1Ft9zW4iYVrduUA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=3Rfx1nUSh_UA:10 a=Zh68SRI7RUMA:10 a=LI9Vle30uBYA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=2e6ZYRoF4I4A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351518762.8467.67.camel@gandalf.local.home>
Subject: Re: [RFC PATCH 3/9] irq_work: Move irq_work_raise()
 declaration/default definition to arch headers
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Mon, 29 Oct 2012 09:52:42 -0400
In-Reply-To: <1351517296-9173-4-git-send-email-fweisbec@gmail.com>
References: <1351517296-9173-1-git-send-email-fweisbec@gmail.com>
	 <1351517296-9173-4-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-29 at 14:28 +0100, Frederic Weisbecker wrote:
> This optimization doesn't matter much. But this prepares the
> arch headers that we need to add a new API in order to detect
> when the arch can trigger self IPIs to implement the irq work.
> 
> This is necessary later to make printk working in nohz CPUs.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---
>  arch/alpha/include/asm/irq_work.h      |    6 ++++++
>  arch/arm/include/asm/irq_work.h        |    1 +
>  arch/arm64/include/asm/irq_work.h      |    1 +
>  arch/avr32/include/asm/irq_work.h      |    1 +
>  arch/blackfin/include/asm/irq_work.h   |    1 +
>  arch/c6x/include/asm/irq_work.h        |    1 +
>  arch/cris/include/asm/irq_work.h       |    1 +
>  arch/frv/include/asm/irq_work.h        |    1 +
>  arch/h8300/include/asm/irq_work.h      |    1 +
>  arch/hexagon/include/asm/irq_work.h    |    1 +
>  arch/ia64/include/asm/irq_work.h       |    1 +
>  arch/m32r/include/asm/irq_work.h       |    1 +
>  arch/m68k/include/asm/irq_work.h       |    1 +
>  arch/microblaze/include/asm/irq_work.h |    1 +
>  arch/mips/include/asm/irq_work.h       |    1 +
>  arch/mn10300/include/asm/irq_work.h    |    1 +
>  arch/openrisc/include/asm/irq_work.h   |    1 +
>  arch/parisc/include/asm/irq_work.h     |    1 +
>  arch/powerpc/include/asm/irq_work.h    |    6 ++++++
>  arch/s390/include/asm/irq_work.h       |    1 +
>  arch/score/include/asm/irq_work.h      |    1 +
>  arch/sh/include/asm/irq_work.h         |    1 +
>  arch/sparc/include/asm/irq_work.h      |    6 ++++++
>  arch/tile/include/asm/irq_work.h       |    1 +
>  arch/um/include/asm/irq_work.h         |    1 +
>  arch/unicore32/include/asm/irq_work.h  |    1 +
>  arch/x86/include/asm/irq_work.h        |   10 ++++++++++
>  arch/x86/kernel/irq_work.c             |    4 ++--
>  arch/xtensa/include/asm/irq_work.h     |    1 +
>  include/asm-generic/irq_work.h         |    9 +++++++++
>  include/linux/irq_work.h               |    1 +
>  kernel/irq_work.c                      |    7 -------
>  32 files changed, 64 insertions(+), 9 deletions(-)
>  create mode 100644 arch/alpha/include/asm/irq_work.h
>  create mode 100644 arch/arm/include/asm/irq_work.h
>  create mode 100644 arch/arm64/include/asm/irq_work.h
>  create mode 100644 arch/avr32/include/asm/irq_work.h
>  create mode 100644 arch/blackfin/include/asm/irq_work.h
>  create mode 100644 arch/c6x/include/asm/irq_work.h
>  create mode 100644 arch/cris/include/asm/irq_work.h
>  create mode 100644 arch/frv/include/asm/irq_work.h
>  create mode 100644 arch/h8300/include/asm/irq_work.h
>  create mode 100644 arch/hexagon/include/asm/irq_work.h
>  create mode 100644 arch/ia64/include/asm/irq_work.h
>  create mode 100644 arch/m32r/include/asm/irq_work.h
>  create mode 100644 arch/m68k/include/asm/irq_work.h
>  create mode 100644 arch/microblaze/include/asm/irq_work.h
>  create mode 100644 arch/mips/include/asm/irq_work.h
>  create mode 100644 arch/mn10300/include/asm/irq_work.h
>  create mode 100644 arch/openrisc/include/asm/irq_work.h
>  create mode 100644 arch/parisc/include/asm/irq_work.h
>  create mode 100644 arch/powerpc/include/asm/irq_work.h
>  create mode 100644 arch/s390/include/asm/irq_work.h
>  create mode 100644 arch/score/include/asm/irq_work.h
>  create mode 100644 arch/sh/include/asm/irq_work.h
>  create mode 100644 arch/sparc/include/asm/irq_work.h
>  create mode 100644 arch/tile/include/asm/irq_work.h
>  create mode 100644 arch/um/include/asm/irq_work.h
>  create mode 100644 arch/unicore32/include/asm/irq_work.h
>  create mode 100644 arch/x86/include/asm/irq_work.h
>  create mode 100644 arch/xtensa/include/asm/irq_work.h
>  create mode 100644 include/asm-generic/irq_work.h
> 
> diff --git a/arch/alpha/include/asm/irq_work.h b/arch/alpha/include/asm/irq_work.h
> new file mode 100644
> index 0000000..814ff3d
> --- /dev/null
> +++ b/arch/alpha/include/asm/irq_work.h
> @@ -0,0 +1,6 @@
> +#ifndef _ALPHA_IRQ_WORK_H
> +#define _ALPHA_IRQ_WORK_H
> +
> +extern void arch_irq_work_raise(void);
> +
> +#endif
> diff --git a/arch/arm/include/asm/irq_work.h b/arch/arm/include/asm/irq_work.h
> new file mode 100644
> index 0000000..f1bffa2
> --- /dev/null
> +++ b/arch/arm/include/asm/irq_work.h
> @@ -0,0 +1 @@
> +#include <asm-generic/irq_work.h>

Don't add stub files. We don't do that anymore.

The correct way of doing this is to modify:

 arch/*/include/asm/Kbuild

and add:

 generic-y += irq_work.h

-- Steve

> diff --git a/arch/arm64/include/asm/irq_work.h b/arch/arm64/include/asm/irq_work.h
> new file mode 100644
> index 0000000..f1bffa2
> --- /dev/null
> +++ b/arch/arm64/include/asm/irq_work.h
> @@ -0,0 +1 @@
> +#include <asm-generic/irq_work.h>
> diff --git a/arch/avr32/include/asm/irq_work.h b/arch/avr32/include/asm/irq_work.h
> new file mode 100644
> index 0000000..f1bffa2
> --- /dev/null
> +++ b/arch/avr32/include/asm/irq_work.h
> @@ -0,0 +1 @@
> +#include <asm-generic/irq_work.h>
> diff --git a/arch/blackfin/include/asm/irq_work.h b/arch/blackfin/include/asm/irq_work.h
> new file mode 100644
> index 0000000..f1bffa2
> --- /dev/null
> +++ b/arch/blackfin/include/asm/irq_work.h
> @@ -0,0 +1 @@
> +#include <asm-generic/irq_work.h>
> diff --git a/arch/c6x/include/asm/irq_work.h b/arch/c6x/include/asm/irq_work.h
> new file mode 100644
> index 0000000..f1bffa2
> --- /dev/null
> +++ b/arch/c6x/include/asm/irq_work.h
> @@ -0,0 +1 @@
> +#include <asm-generic/irq_work.h>
> diff --git a/arch/cris/include/asm/irq_work.h b/arch/cris/include/asm/irq_work.h
> new file mode 100644
> index 0000000..f1bffa2
> --- /dev/null
> +++ b/arch/cris/include/asm/irq_work.h
> @@ -0,0 +1 @@
> +#include <asm-generic/irq_work.h>
> diff --git a/arch/frv/include/asm/irq_work.h b/arch/frv/include/asm/irq_work.h
> new file mode 100644
> index 0000000..f1bffa2
> --- /dev/null
> +++ b/arch/frv/include/asm/irq_work.h
> @@ -0,0 +1 @@
> +#include <asm-generic/irq_work.h>
> diff --git a/arch/h8300/include/asm/irq_work.h b/arch/h8300/include/asm/irq_work.h
> new file mode 100644
> index 0000000..f1bffa2
> --- /dev/null
> +++ b/arch/h8300/include/asm/irq_work.h
> @@ -0,0 +1 @@
> +#include <asm-generic/irq_work.h>
> diff --git a/arch/hexagon/include/asm/irq_work.h b/arch/hexagon/include/asm/irq_work.h
> new file mode 100644
> index 0000000..f1bffa2
> --- /dev/null
> +++ b/arch/hexagon/include/asm/irq_work.h
> @@ -0,0 +1 @@
> +#include <asm-generic/irq_work.h>
> diff --git a/arch/ia64/include/asm/irq_work.h b/arch/ia64/include/asm/irq_work.h
> new file mode 100644
> index 0000000..f1bffa2
> --- /dev/null
> +++ b/arch/ia64/include/asm/irq_work.h
> @@ -0,0 +1 @@
> +#include <asm-generic/irq_work.h>
> diff --git a/arch/m32r/include/asm/irq_work.h b/arch/m32r/include/asm/irq_work.h
> new file mode 100644
> index 0000000..f1bffa2
> --- /dev/null
> +++ b/arch/m32r/include/asm/irq_work.h
> @@ -0,0 +1 @@
> +#include <asm-generic/irq_work.h>
> diff --git a/arch/m68k/include/asm/irq_work.h b/arch/m68k/include/asm/irq_work.h
> new file mode 100644
> index 0000000..f1bffa2
> --- /dev/null
> +++ b/arch/m68k/include/asm/irq_work.h
> @@ -0,0 +1 @@
> +#include <asm-generic/irq_work.h>
> diff --git a/arch/microblaze/include/asm/irq_work.h b/arch/microblaze/include/asm/irq_work.h
> new file mode 100644
> index 0000000..f1bffa2
> --- /dev/null
> +++ b/arch/microblaze/include/asm/irq_work.h
> @@ -0,0 +1 @@
> +#include <asm-generic/irq_work.h>
> diff --git a/arch/mips/include/asm/irq_work.h b/arch/mips/include/asm/irq_work.h
> new file mode 100644
> index 0000000..f1bffa2
> --- /dev/null
> +++ b/arch/mips/include/asm/irq_work.h
> @@ -0,0 +1 @@
> +#include <asm-generic/irq_work.h>
> diff --git a/arch/mn10300/include/asm/irq_work.h b/arch/mn10300/include/asm/irq_work.h
> new file mode 100644
> index 0000000..f1bffa2
> --- /dev/null
> +++ b/arch/mn10300/include/asm/irq_work.h
> @@ -0,0 +1 @@
> +#include <asm-generic/irq_work.h>
> diff --git a/arch/openrisc/include/asm/irq_work.h b/arch/openrisc/include/asm/irq_work.h
> new file mode 100644
> index 0000000..f1bffa2
> --- /dev/null
> +++ b/arch/openrisc/include/asm/irq_work.h
> @@ -0,0 +1 @@
> +#include <asm-generic/irq_work.h>
> diff --git a/arch/parisc/include/asm/irq_work.h b/arch/parisc/include/asm/irq_work.h
> new file mode 100644
> index 0000000..f1bffa2
> --- /dev/null
> +++ b/arch/parisc/include/asm/irq_work.h
> @@ -0,0 +1 @@
> +#include <asm-generic/irq_work.h>
> diff --git a/arch/powerpc/include/asm/irq_work.h b/arch/powerpc/include/asm/irq_work.h
> new file mode 100644
> index 0000000..8b9927f
> --- /dev/null
> +++ b/arch/powerpc/include/asm/irq_work.h
> @@ -0,0 +1,6 @@
> +#ifndef _ASM_POWERPC_IRQ_WORK_H
> +#define _ASM_POWERPC_IRQ_WORK_H
> +
> +extern void arch_irq_work_raise(void);
> +
> +#endif
> diff --git a/arch/s390/include/asm/irq_work.h b/arch/s390/include/asm/irq_work.h
> new file mode 100644
> index 0000000..f1bffa2
> --- /dev/null
> +++ b/arch/s390/include/asm/irq_work.h
> @@ -0,0 +1 @@
> +#include <asm-generic/irq_work.h>
> diff --git a/arch/score/include/asm/irq_work.h b/arch/score/include/asm/irq_work.h
> new file mode 100644
> index 0000000..f1bffa2
> --- /dev/null
> +++ b/arch/score/include/asm/irq_work.h
> @@ -0,0 +1 @@
> +#include <asm-generic/irq_work.h>
> diff --git a/arch/sh/include/asm/irq_work.h b/arch/sh/include/asm/irq_work.h
> new file mode 100644
> index 0000000..f1bffa2
> --- /dev/null
> +++ b/arch/sh/include/asm/irq_work.h
> @@ -0,0 +1 @@
> +#include <asm-generic/irq_work.h>
> diff --git a/arch/sparc/include/asm/irq_work.h b/arch/sparc/include/asm/irq_work.h
> new file mode 100644
> index 0000000..1d062a6
> --- /dev/null
> +++ b/arch/sparc/include/asm/irq_work.h
> @@ -0,0 +1,6 @@
> +#ifndef ___ASM_SPARC_IRQ_H
> +#define ___ASM_SPARC_IRQ_H
> +
> +extern void arch_irq_work_raise(void);
> +
> +#endif
> diff --git a/arch/tile/include/asm/irq_work.h b/arch/tile/include/asm/irq_work.h
> new file mode 100644
> index 0000000..f1bffa2
> --- /dev/null
> +++ b/arch/tile/include/asm/irq_work.h
> @@ -0,0 +1 @@
> +#include <asm-generic/irq_work.h>
> diff --git a/arch/um/include/asm/irq_work.h b/arch/um/include/asm/irq_work.h
> new file mode 100644
> index 0000000..f1bffa2
> --- /dev/null
> +++ b/arch/um/include/asm/irq_work.h
> @@ -0,0 +1 @@
> +#include <asm-generic/irq_work.h>
> diff --git a/arch/unicore32/include/asm/irq_work.h b/arch/unicore32/include/asm/irq_work.h
> new file mode 100644
> index 0000000..f1bffa2
> --- /dev/null
> +++ b/arch/unicore32/include/asm/irq_work.h
> @@ -0,0 +1 @@
> +#include <asm-generic/irq_work.h>
> diff --git a/arch/x86/include/asm/irq_work.h b/arch/x86/include/asm/irq_work.h
> new file mode 100644
> index 0000000..38eed96
> --- /dev/null
> +++ b/arch/x86/include/asm/irq_work.h
> @@ -0,0 +1,10 @@
> +#ifndef _ASM_X86_IRQ_WORK_H
> +#define _ASM_X86_IRQ_WORK_H
> +
> +#ifndef CONFIG_X86_LOCAL_APIC
> +#include <asm-generic/irq_work.h>
> +# else
> +extern void arch_irq_work_raise(void);
> +#endif
> +
> +#endif
> diff --git a/arch/x86/kernel/irq_work.c b/arch/x86/kernel/irq_work.c
> index ca8f703..95f5d4e 100644
> --- a/arch/x86/kernel/irq_work.c
> +++ b/arch/x86/kernel/irq_work.c
> @@ -18,13 +18,13 @@ void smp_irq_work_interrupt(struct pt_regs *regs)
>  	irq_exit();
>  }
>  
> +#ifdef CONFIG_X86_LOCAL_APIC
>  void arch_irq_work_raise(void)
>  {
> -#ifdef CONFIG_X86_LOCAL_APIC
>  	if (!cpu_has_apic)
>  		return;
>  
>  	apic->send_IPI_self(IRQ_WORK_VECTOR);
>  	apic_wait_icr_idle();
> -#endif
>  }
> +#endif
> diff --git a/arch/xtensa/include/asm/irq_work.h b/arch/xtensa/include/asm/irq_work.h
> new file mode 100644
> index 0000000..f1bffa2
> --- /dev/null
> +++ b/arch/xtensa/include/asm/irq_work.h
> @@ -0,0 +1 @@
> +#include <asm-generic/irq_work.h>
> diff --git a/include/asm-generic/irq_work.h b/include/asm-generic/irq_work.h
> new file mode 100644
> index 0000000..a2d4108
> --- /dev/null
> +++ b/include/asm-generic/irq_work.h
> @@ -0,0 +1,9 @@
> +#ifndef __ASM_GENERIC_ATOMIC_H
> +#define __ASM_GENERIC_ATOMIC_H
> +
> +/*
> + * Lame architectures will get the timer tick callback
> + */
> +static inline void arch_irq_work_raise(void) { }
> +
> +#endif
> diff --git a/include/linux/irq_work.h b/include/linux/irq_work.h
> index 6a9e8f5..b39ea0b 100644
> --- a/include/linux/irq_work.h
> +++ b/include/linux/irq_work.h
> @@ -2,6 +2,7 @@
>  #define _LINUX_IRQ_WORK_H
>  
>  #include <linux/llist.h>
> +#include <asm/irq_work.h>
>  
>  struct irq_work {
>  	unsigned long flags;
> diff --git a/kernel/irq_work.c b/kernel/irq_work.c
> index 679c13e..d00011c 100644
> --- a/kernel/irq_work.c
> +++ b/kernel/irq_work.c
> @@ -56,13 +56,6 @@ static bool irq_work_claim(struct irq_work *work)
>  	return true;
>  }
>  
> -void __weak arch_irq_work_raise(void)
> -{
> -	/*
> -	 * Lame architectures will get the timer tick callback
> -	 */
> -}
> -
>  /*
>   * Queue the entry and raise the IPI if needed.
>   */


