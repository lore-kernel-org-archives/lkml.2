Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab1FEP0x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 11:26:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41268 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757Ab1FEP0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 11:26:52 -0400
Date: Sun, 5 Jun 2011 17:26:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arne Jansen <lists@die-jansens.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
Message-ID: <20110605152641.GA31124@elte.hu>
References: <4DEB58D8.4000805@die-jansens.de>
 <20110605110132.GB23463@elte.hu>
 <20110605111933.GA24592@elte.hu>
 <20110605113627.GA25724@elte.hu>
 <4DEB6F3A.3000109@die-jansens.de>
 <20110605133958.GA27812@elte.hu>
 <4DEB8A93.30601@die-jansens.de>
 <20110605141003.GB29338@elte.hu>
 <4DEB933C.1070900@die-jansens.de>
 <20110605151323.GA30590@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110605151323.GA30590@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Arne Jansen <lists@die-jansens.de> wrote:
> 
> > sched.c:934: in function __task_rq_lock
> >         lockdep_assert_held(&p->pi_lock);
> 
> Oh. Could you remove that line with the patch below - does it result 
> in a working system?
> 
> Now, this patch alone just removes a debugging check - but i'm not 
> sure the debugging check is correct - we take the pi_lock in a raw 
> way - which means it's not lockdep covered.
> 
> So how can lockdep_assert_held() be called on it?

Ok, i'm wrong there - it's lockdep covered.

I also reviewed all the __task_rq_lock() call sites and each of them 
has the pi_lock acquired. So unless both Peter and me are blind, the 
other option would be some sort of memory corruption corrupting the 
runqueue.

But ... that looks so unlikely here, it's clearly heavy printk() and 
console_sem twiddling that triggers the bug, not any other scheduler 
activity.

Thanks,

	Ingo
