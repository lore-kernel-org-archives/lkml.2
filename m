Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604Ab1FGSGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 14:06:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40116 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495Ab1FGSGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 14:06:53 -0400
Date: Tue, 7 Jun 2011 20:06:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: lists@die-jansens.de, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        stable@kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/urgent] lockdep: Fix lock_is_held() on recursion
Message-ID: <20110607180638.GB22523@elte.hu>
References: <1307398759.2497.966.camel@laptop>
 <tip-f2513cde93f0957d5dc6c09bc24b0cccd27d8e1d@git.kernel.org>
 <1307450343.2322.250.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307450343.2322.250.camel@twins>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Tue, 2011-06-07 at 12:02 +0000, tip-bot for Peter Zijlstra wrote:
> > Commit-ID:  f2513cde93f0957d5dc6c09bc24b0cccd27d8e1d
> > Gitweb:     http://git.kernel.org/tip/f2513cde93f0957d5dc6c09bc24b0cccd27d8e1d
> > Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> > AuthorDate: Mon, 6 Jun 2011 12:32:43 +0200
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Tue, 7 Jun 2011 12:25:50 +0200
> > 
> > lockdep: Fix lock_is_held() on recursion
> > 
> > The main lock_is_held() user is lockdep_assert_held(), avoid false
> > assertions in lockdep_off() sections by unconditionally reporting the
> > lock is taken.
> > 
> > [ the reason this is important is a lockdep_assert_held() in ttwu()
> >   which triggers a warning under lockdep_off() as in printk() which
> >   can trigger another wakeup and lock up due to spinlock
> >   recursion, as reported and heroically debugged by Arne Jansen ]
> > 
> > Reported-and-tested-by: Arne Jansen <lists@die-jansens.de>
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: <stable@kernel.org>
> 
> Not _that_ critical for stable since the offending lockdep_assert_held()
> doesn't exist in .39, still definitely won't hurt.

Correct, the bug was hard enough to find, i didnt want someone else 
to trigger a similar one. There's numerous lockdep_assert_held() 
instances all around the tree.

Thanks,

	Ingo
