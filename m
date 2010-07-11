Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab0GKT0k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 15:26:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60472 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754638Ab0GKT0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 15:26:38 -0400
Date: Sun, 11 Jul 2010 21:26:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH] x86-64: software IRQ masking and handling
Message-ID: <20100711192615.GB21598@elte.hu>
References: <4C3A06E3.50402@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3A06E3.50402@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> This is something suggested by Rusty Russell a while ago.  It makes IRQ 
> masking a software switch like preemption or softirq enable/disable.  
> Hardware interrupt masking (cli/sti) and delivery are decoupled from actual 
> IRQ handling.  IRQ disabling is done by single instruction moving 1 to a 
> percpu variable.  Enabling is similar but it should check whether there's 
> any pending interrupt to handle.
> 
> This change greatly reduces the number of hardware IRQ masking 
> manipulations.  cli/sti still being somewhat costly operations (I hear 
> nehalem is better tho), this should be able to improve overall performance, 
> especially on paravirts.

Not just Nehalem but on various AMD CPUs it was in the below-10-cycles range 
for years.

Note that we tried this in -rt, but the pain and trouble (and, often, code 
bloat) was not worth the trouble. The PUSHF/POPF/CLI/STI instructions are 
really simple and short in the instruction stream - without disturbing other 
registers.

	Ingo
