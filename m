Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758335Ab2CFHqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 02:46:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36297 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757731Ab2CFHqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 02:46:19 -0500
Date: Tue, 6 Mar 2012 08:46:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: akpm@linux-foundation.org
Cc: tglx@linutronix.de, hpa@zytor.com, alex.shi@intel.com, cl@gentwo.org,
        sfr@canb.auug.org.au, tj@kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch 5/8] x86: use this_cpu_xxx to replace percpu_xxx funcs
Message-ID: <20120306074601.GD23669@elte.hu>
References: <20120305230515.A9238A02AE@akpm.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120305230515.A9238A02AE@akpm.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:

> From: Alex Shi <alex.shi@intel.com>
> Subject: x86: use this_cpu_xxx to replace percpu_xxx funcs
> 
> Since percpu_xxx() serial functions are duplicate with this_cpu_xxx(). 
> Removing percpu_xxx() definition and replacing them by this_cpu_xxx() in
> code.
> 
> And further more, as Christoph Lameter's requirement, I try to use
> __this_cpu_xx to replace this_cpu_xxx if it is in preempt safe scenario.
> The preempt safe scenarios include:
> 1, in irq/softirq/nmi handler
> 2, protected by preempt_disable
> 3, protected by spin_lock
> 4, if the code context imply that it is preempt safe, like the code is
> follows or be followed a preempt safe code.
> 
> BTW, In fact, this_cpu_xxx are same as __this_cpu_xxx since all funcs
> implement in a single instruction for x86 machine.  But it maybe other
> platforms' performance.

but this is an x86 only patch.

> -	percpu_write(irq_regs, new_regs);
> +	__this_cpu_write(irq_regs, new_regs);

So what's the point of all this ugly churn?

Will percpu_write() be removed altogether? If so then the 
changelog should say *that*, and explain that on x86 this is a 
simple renaming of the API, not a long explanation about 
scenarios that don't actually matter.

If percpu_write() is not being removed then I don't see how this 
patch is an improvement: it's supposed to result in the same 
instructions being emitted, and __this_cpu_write() et al are 
distinctly longer to write ...

So what's the plan here?

Thanks,

	Ingo
