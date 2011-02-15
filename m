Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622Ab1BOXBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 18:01:52 -0500
Received: from www.tglx.de ([62.245.132.106]:38261 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027Ab1BOXBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 18:01:49 -0500
Date: Wed, 16 Feb 2011 00:01:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Kenneth Albanowski (Palm GBU)" <Kenneth.Albanowski@palm.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Jakub Jelinek <jakub@redhat.com>,
        Andreas Schwab <schwab@linux-m68k.org>
Subject: RE: Question about clearing of tsk->robust_list in clone
In-Reply-To: <23C1F4DA0B73684F85AD25A73E4BB50315252C50@ushqwmb09>
Message-ID: <alpine.LFD.2.00.1102152354070.26192@localhost6.localdomain6>
References: <23C1F4DA0B73684F85AD25A73E4BB50315252BD7@ushqwmb09> <alpine.LFD.2.00.1102151233330.26192@localhost6.localdomain6> <23C1F4DA0B73684F85AD25A73E4BB50315252C50@ushqwmb09>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Feb 2011, Kenneth Albanowski (Palm GBU) wrote:

> On Tue, 15 Feb 2011, Thomas Gleixner wrote:
> 
> > The sanity checks in exit_robust_list will catch that mutex_1
> > owner is not matching, but that makes it not more correct.
> 
> Yes, that's my remaining question: whether the intention was that the
> owner filter would often be preventing erroneous unlocks, or whether
> there should never be an inappropriate list in normal usage. The owner
> check does seem sufficient to prevent mayhem if the list pointer is
> copied to the child.

It's task state, so we cannot keep state around which belongs to some
other task. 

Of course we have nevertheless sanity checks in place as we have no
idea what kind of crap user space hands us as "robust_list" pointer.

Ideally we never need to walk that list at all in the normal exit
case when user space behaves nicely.
 
> On Tue, 15 Feb 2011, Peter Zijlstra wrote:
> 
> > Realistically libpthread should register an on_fork() callback to 
> > ensure the state is properly propagated.
> 
> Agreed, that seems reasonable, with only the minor impact of an
> additional set_robust_list call. That resolves this as a libc issue,
> not a kernel issue.

As I said, I don't understand that argument of the additional call at
all. We do it on every process start and on every pthread_create
already, just fork() was forgotten somehow.

Thanks,

	tglx
