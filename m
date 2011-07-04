Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab1GDJR4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 05:17:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33559 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755570Ab1GDJRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 05:17:55 -0400
Date: Mon, 4 Jul 2011 11:17:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@novell.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 5/6] x86: Remove useless unwinder backlink from irq regs
 saving
Message-ID: <20110704091742.GC22943@elte.hu>
References: <1309624184-9790-1-git-send-email-fweisbec@gmail.com>
 <1309624184-9790-6-git-send-email-fweisbec@gmail.com>
 <4E1187E4020000780004BF2C@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E1187E4020000780004BF2C@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <JBeulich@novell.com> wrote:

> >>> On 02.07.11 at 18:29, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > The unwinder backlink in interrupt entry is very useless.
> > It's actually not part of the stack frame chain and thus is
> > never used.
> 
> I very much doubt this - see dump_trace()'s comment in its IRQ-stack
> related code portion (and the corresponding use of irq_stack_end[-1]).

> > +++ b/arch/x86/kernel/entry_64.S
> > @@ -327,7 +327,6 @@ ENDPROC(native_usergs_sysret64)
> >  	jne 2f
> >  	mov PER_CPU_VAR(irq_stack_ptr),%rsp
> >  	EMPTY_FRAME 0
> > -	pushq_cfi %rbp			/* backlink for unwinder */
> >  	/*
> >  	 * We entered an interrupt context - irqs are off:
> >  	 */

Frederic, please add it back with a much better comment in the .S 
showing where it's used and how. Perhaps even try to trigger the 
usage of this backlink and document the effect in the changelog.

Thanks,

	Ingo
