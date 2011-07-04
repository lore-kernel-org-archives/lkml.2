Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782Ab1GDJOB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 05:14:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47662 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753583Ab1GDJN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 05:13:59 -0400
Date: Mon, 4 Jul 2011 11:13:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jan Beulich <JBeulich@novell.com>
Subject: Re: [RFC GIT PULL] x86 entry / perf stacktrace changes
Message-ID: <20110704091345.GB22943@elte.hu>
References: <1309624184-9790-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309624184-9790-1-git-send-email-fweisbec@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo,
> 
> Please pull the perf/stacktrace branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	perf/stacktrace
> 
> Or may be not yet. It's still in RFC because I would like
> to ensure I did not break cfi annotations. I hope Jan beulich
> or others can have a look.
> 
> Sorry to mess up irq entry and perf stacktrace changes in the same
> topic. But the changes happen to be very interconnected.
> 
> Several cleanups, fixes and optimizations for the x86-64
> stacktraces and irq entry.
> 
> Last patch seems to add a bit of overhead in the irq entry
> (one more "push") but given the changes made in previous
> patches, the end result is a more optimized and more clear irq
> entry.
> 
> Thanks,
> 	Frederic
> ---
> 
> Frederic Weisbecker (6):
>       x86: Save stack pointer in perf live regs savings
>       x86: Fetch stack from regs when possible in dump_trace()
>       x86,64: Simplify save_regs()
>       x86,64: Separate arg1 from rbp handling in SAVE_REGS_IRQ
>       x86: Remove useless unwinder backlink from irq regs saving
>       x86: Don't use frame pointer to save old stack on irq entry
> 
> 
>  arch/x86/include/asm/perf_event.h |    5 +++
>  arch/x86/kernel/dumpstack_64.c    |   37 +++-----------------
>  arch/x86/kernel/entry_64.S        |   69 ++++++++++++++++--------------------
>  3 files changed, 41 insertions(+), 70 deletions(-)

Pulled, thanks a lot Frederic! The irq backtrace fixes look pretty 
important - if there's any CFI annotation detail to be fixed we can 
do it in a delta.

Thanks,

	Ingo
