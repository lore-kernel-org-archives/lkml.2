Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932731Ab1BXHM6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 02:12:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43375 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932689Ab1BXHM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 02:12:56 -0500
Date: Thu, 24 Feb 2011 08:12:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 0/5] genirq: Forced threaded interrupt handlers
Message-ID: <20110224071237.GA7197@elte.hu>
References: <20110223231601.613115832@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110223231601.613115832@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> Some time ago when the threaded interrupt handlers infrastructure was
> about to be merged, Andrew asked me where that command line switch was
> which magically runs all interrupt handlers and the softirqs in
> threads.
> 
> While we were doing that brute force in preempt-rt for quite a while
> it took some time to come up with a reasonable non intrusive
> implementation for mainline. We also had to find a solution which fits
> Linus' recently issued "palatable Trojan horse" requirement (see:
> https://lwn.net/Articles/370998/).
> 
> The gift of this patch series is the ability to add "threadirqs" to
> the kernel command line and magically (almost) all interrupt handlers
> - except those which are explicitely marked IRQF_NO_THREAD - are
> confined into threads along with all soft interrupts.
> 
> That allows to enhance the debugability of the kernel as a bug in an
> interrupt handler is not necessarily taking the whole machine
> down. It's just the particular irq thread which goes into nirwana. Bad
> luck if that's the one which is crucial to retrieve the bug report,
> but in most cases - yes, I analysed quite a lot of bugzilla reports -
> it will be helpful for reporters not to be forced to transcribe the
> bug from the screen.

Just a quick bike shed painting suggestion: could we please name it anything but 
'forced' threaded irqs? Something like 'irqthread debugging' or 'full irqthreads'?

Thanks,

	Ingo
