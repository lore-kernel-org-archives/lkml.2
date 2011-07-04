Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab1GDH3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 03:29:13 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:50745 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab1GDH3M convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:6:1>);
	Mon, 4 Jul 2011 03:29:12 -0400
X-Greylist: delayed 495 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Jul 2011 03:29:12 EDT
Message-Id: <4E1187E4020000780004BF2C@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 04 Jul 2011 08:29:08 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Frederic Weisbecker" <fweisbec@gmail.com>
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Arnaldo Carvalho de Melo" <acme@redhat.com>,
        "LKML" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 5/6] x86: Remove useless unwinder backlink from irq
	 regs saving
References: <1309624184-9790-1-git-send-email-fweisbec@gmail.com>
 <1309624184-9790-6-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1309624184-9790-6-git-send-email-fweisbec@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 02.07.11 at 18:29, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> The unwinder backlink in interrupt entry is very useless.
> It's actually not part of the stack frame chain and thus is
> never used.

I very much doubt this - see dump_trace()'s comment in its IRQ-stack
related code portion (and the corresponding use of irq_stack_end[-1]).

Jan

> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Jan Beulich <JBeulich@novell.com>
> ---
>  arch/x86/kernel/entry_64.S |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index 20dc8e6..6131432 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -327,7 +327,6 @@ ENDPROC(native_usergs_sysret64)
>  	jne 2f
>  	mov PER_CPU_VAR(irq_stack_ptr),%rsp
>  	EMPTY_FRAME 0
> -	pushq_cfi %rbp			/* backlink for unwinder */
>  	/*
>  	 * We entered an interrupt context - irqs are off:
>  	 */




