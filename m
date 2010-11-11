Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab0KKKBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 05:01:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37531 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753583Ab0KKKBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 05:01:18 -0500
Date: Thu, 11 Nov 2010 11:01:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: DDD <dongdong.deng@windriver.com>
Cc: dzickus@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: avoid calling arch_trigger_all_cpu_backtrace() at
 the same time on SMP
Message-ID: <20101111100109.GB24558@elte.hu>
References: <1289442042-2515-1-git-send-email-dongdong.deng@windriver.com>
 <20101111092301.GD18789@elte.hu>
 <4CDBBCA5.50306@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CDBBCA5.50306@windriver.com>
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


* DDD <dongdong.deng@windriver.com> wrote:

> Ingo Molnar wrote:
> >* Dongdong Deng <dongdong.deng@windriver.com> wrote:
> >
> >>+static int backtrace_flag;
> >
> >>+	if (cmpxchg(&backtrace_flag, 0, 1) != 0)
> >
> >Sorry to be a PITA, but i asked for test_and_set() because that's
> >the simplest primitive. cmpxchg() semantics is not nearly as
> >obvious and people regularly get it wrong :-/
> 
> As the 'backtrace_flag' could be accessed by multi-cpus on SMP at
> the same time, I use cmpxchg() for getting a atomic/memory barrier
> operation for 'backtrace_flag' variable.
>
> If we use test_and_set, maybe we need smp_wmb() after test_and_set.
> (If I wrong, please correct me, thanks. :-) )

No, test_and_set_bit() is SMP safe and is an implicit barrier as well - so no 
smp_wmb() or other barriers are needed.

Thanks,

	Ingo
