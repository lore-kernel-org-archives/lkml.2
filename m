Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab2EJFhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 01:37:43 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42637 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab2EJFhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 01:37:41 -0400
Message-ID: <4FAB541A.8060003@gmail.com>
Date: Thu, 10 May 2012 13:37:30 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Milton Miller <miltonm@bga.com>, Grant Likely <grant.likely@secretlab.ca>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Anton Blanchard <anton@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc: use local var instead of local_paca->irq_happened
 directly in __check_irq_replay
References: <4FA1E527.1090807@gmail.com> <1336011306.2653.3.camel@pasglop>	 <1336018961.2653.11.camel@pasglop> <4FA226A8.1080903@gmail.com>	 <4FA22CC5.3010107@gmail.com> <1336032561.18712.1.camel@pasglop>	 <4FA31653.5090103@gmail.com> <1336090207.18712.9.camel@pasglop> <1336448796.2540.187.camel@pasglop>
In-Reply-To: <1336448796.2540.187.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012年05月08日 11:46, Benjamin Herrenschmidt wrote:
> Hi Wang !
> 
> Does this patch fixes it for you ?
> 

Sorry, this patch doesn't work. And my system crashed again with the patch.
======================================================
# kernel BUG at /usr/src/kernels/linux/arch/powerpc/kernel/irq.c:188!
cpu 0x0: Vector: 700 (Program Check) at [c00000026ffebbb0]
    pc: c00000000000ea9c: .__check_irq_replay+0x7c/0x90
    lr: c000000000010578: .arch_local_irq_restore+0x38/0x90
    sp: c00000026ffebe30
   msr: 8000000000029032
  current = 0xc000000000e27be0
  paca    = 0xc000000003580000	 softe: 0	 irq_happened: 0x01
    pid   = 0, comm = swapper/0
kernel BUG at /usr/src/kernels/linux/arch/powerpc/kernel/irq.c:188!
enter ? for help
[link register   ] c000000000010578 .arch_local_irq_restore+0x38/0x90
[c00000026ffebe30] c000000000f42100 softirq_vec+0x0/0x80 (unreliable)
[c00000026ffebea0] c000000000085854 .__do_softirq+0xa4/0x2a0
[c00000026ffebf90] c0000000000229b8 .call_do_softirq+0x14/0x24
[c000000000edf870] c0000000000106c8 .do_softirq+0xf8/0x130
[c000000000edf910] c000000000085544 .irq_exit+0xc4/0xf0
[c000000000edf990] c0000000000100a4 .do_IRQ+0xe4/0x310
[c000000000edfa50] c0000000000038c0 hardware_interrupt_common+0x140/0x180
--- Exception: 501 (Hardware Interrupt) at c0000000000105b4 .arch_local_irq_restore+0x74/0x90
[c000000000edfd40] c000000000058480 .pSeries_idle+0x10/0x40 (unreliable)
[c000000000edfdb0] c000000000017d70 .cpu_idle+0x190/0x290
[c000000000edfe70] c00000000000b308 .rest_init+0x88/0xa0
[c000000000edfef0] c0000000008c0d1c .start_kernel+0x554/0x574
[c000000000edff90] c000000000009658 .start_here_common+0x20/0x48
0:mon> e
cpu 0x0: Vector: 700 (Program Check) at [c00000026ffebbb0]
    pc: c00000000000ea9c: .__check_irq_replay+0x7c/0x90
    lr: c000000000010578: .arch_local_irq_restore+0x38/0x90
    sp: c00000026ffebe30
   msr: 8000000000029032
  current = 0xc000000000e27be0
  paca    = 0xc000000003580000	 softe: 0	 irq_happened: 0x01
    pid   = 0, comm = swapper/0
kernel BUG at /usr/src/kernels/linux/arch/powerpc/kernel/irq.c:188!
0:mon> r
R00 = 0000000000000001   R16 = 0000000003680000
R01 = c00000026ffebe30   R17 = 000000000021ed0f
R02 = c000000000edd228   R18 = 000000000021efbb
R03 = 0000000000000500   R19 = 000000000021ee84
R04 = 0000000000000000   R20 = c000000000f42100
R05 = 00000000000007ea   R21 = 0000000000000000
R06 = 00000000273f6d30   R22 = c000000000955b80
R07 = 00363d0e68097e11   R23 = c000000000955b80
R08 = 00000000008c0000   R24 = 000000000000000a
R09 = c000000003580000   R25 = 0000000000000000
R10 = 0000000000000001   R26 = c000000000edc100
R11 = 0000000000000000   R27 = c00000026ffe8000
R12 = 0000000000000002   R28 = 0000000000000000
R13 = c000000003580000   R29 = c000000000f42100
R14 = 0000000002e1fa78   R30 = c000000000e60890
R15 = 0000000001173000   R31 = 0000000000000040
pc  = c00000000000ea9c .__check_irq_replay+0x7c/0x90
cfar= c00000000000ea3c .__check_irq_replay+0x1c/0x90
lr  = c000000000010578 .arch_local_irq_restore+0x38/0x90
msr = 8000000000029032   cr  = 28000048
ctr = c000000000063f70   xer = 0000000000000001   trap =  700
0:mon> t
[link register   ] c000000000010578 .arch_local_irq_restore+0x38/0x90
[c00000026ffebe30] c000000000f42100 softirq_vec+0x0/0x80 (unreliable)
[c00000026ffebea0] c000000000085854 .__do_softirq+0xa4/0x2a0
[c00000026ffebf90] c0000000000229b8 .call_do_softirq+0x14/0x24
[c000000000edf870] c0000000000106c8 .do_softirq+0xf8/0x130
[c000000000edf910] c000000000085544 .irq_exit+0xc4/0xf0
[c000000000edf990] c0000000000100a4 .do_IRQ+0xe4/0x310
[c000000000edfa50] c0000000000038c0 hardware_interrupt_common+0x140/0x180
--- Exception: 501 (Hardware Interrupt) at c0000000000105b4 .arch_local_irq_restore+0x74/0x90
[c000000000edfd40] c000000000058480 .pSeries_idle+0x10/0x40 (unreliable)
[c000000000edfdb0] c000000000017d70 .cpu_idle+0x190/0x290
[c000000000edfe70] c00000000000b308 .rest_init+0x88/0xa0
[c000000000edfef0] c0000000008c0d1c .start_kernel+0x554/0x574
[c000000000edff90] c000000000009658 .start_here_common+0x20/0x48
0:mon> di 



> From 249f8649bf95a4c3e6637284754a165c1d83c394 Mon Sep 17 00:00:00 2001
> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Date: Tue, 8 May 2012 13:31:59 +1000
> Subject: [PATCH 2/3] powerpc/irq: Fix bug with new lazy IRQ handling code
> 
> We had a case where we could turn on hard interrupts while
> leaving the PACA_IRQ_HARD_DIS bit set in the PACA. This can
> in turn cause a BUG_ON() to hit in __check_irq_replay() due
> to interrupt state getting out of sync.
> 
> The assembly code was also way too convoluted. Instead, we
> now leave it to the C code to do the right thing which ends
> up being smaller and more readable.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
>  arch/powerpc/kernel/entry_64.S |   18 ------------------
>  arch/powerpc/kernel/irq.c      |    8 +++++++-
>  2 files changed, 7 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
> index fd46046..29f1357 100644
> --- a/arch/powerpc/kernel/entry_64.S
> +++ b/arch/powerpc/kernel/entry_64.S
> @@ -763,16 +763,6 @@ do_work:
>  	SOFT_DISABLE_INTS(r3,r4)
>  1:	bl	.preempt_schedule_irq
>  
> -	/* Hard-disable interrupts again (and update PACA) */
> -#ifdef CONFIG_PPC_BOOK3E
> -	wrteei	0
> -#else
> -	ld	r10,PACAKMSR(r13) /* Get kernel MSR without EE */
> -	mtmsrd	r10,1
> -#endif /* CONFIG_PPC_BOOK3E */
> -	li	r0,PACA_IRQ_HARD_DIS
> -	stb	r0,PACAIRQHAPPENED(r13)
> -
>  	/* Re-test flags and eventually loop */
>  	clrrdi	r9,r1,THREAD_SHIFT
>  	ld	r4,TI_FLAGS(r9)
> @@ -783,14 +773,6 @@ do_work:
>  user_work:
>  #endif /* CONFIG_PREEMPT */
>  
> -	/* Enable interrupts */
> -#ifdef CONFIG_PPC_BOOK3E
> -	wrteei	1
> -#else
> -	ori	r10,r10,MSR_EE
> -	mtmsrd	r10,1
> -#endif /* CONFIG_PPC_BOOK3E */
> -
>  	andi.	r0,r4,_TIF_NEED_RESCHED
>  	beq	1f
>  	bl	.restore_interrupts
> diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
> index 5ec1b23..3717fb5 100644
> --- a/arch/powerpc/kernel/irq.c
> +++ b/arch/powerpc/kernel/irq.c
> @@ -260,11 +260,17 @@ EXPORT_SYMBOL(arch_local_irq_restore);
>   * if they are currently disabled. This is typically called before
>   * schedule() or do_signal() when returning to userspace. We do it
>   * in C to avoid the burden of dealing with lockdep etc...
> + *
> + * NOTE: This is called with interrupts hard disabled but not marked
> + * as such in paca->irq_happened, so we need to resync this.
>   */
>  void restore_interrupts(void)
>  {
> -	if (irqs_disabled())
> +	if (irqs_disabled()) {
> +		local_paca->irq_happened |= PACA_IRQ_HARD_DIS;
>  		local_irq_enable();
> +	} else
> +		__hard_irq_enable();
>  }
>  
>  #endif /* CONFIG_PPC64 */

