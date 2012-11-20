Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab2KTQbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 11:31:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915Ab2KTQbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 11:31:36 -0500
Date: Tue, 20 Nov 2012 17:31:48 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Arapov <anton@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, Mikulas Patocka <mpatocka@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] percpu_rw_semaphore: add the lockdep annotations
Message-ID: <20121120163148.GB17534@redhat.com>
References: <20121118190257.GA9660@redhat.com> <20121118190321.GA9684@redhat.com> <20121119150553.8c890970.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121119150553.8c890970.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19, Andrew Morton wrote:
>
> On Sun, 18 Nov 2012 20:03:21 +0100
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > -extern int percpu_init_rwsem(struct percpu_rw_semaphore *);
> > +extern int __percpu_init_rwsem(struct percpu_rw_semaphore *,
> > +				const char *, struct lock_class_key *);
> >  extern void percpu_free_rwsem(struct percpu_rw_semaphore *);
> >
> > +#define percpu_init_rwsem(brw)	\
>
> Should have been called percpu_rwsem_init(). The naming in this code does
> seem to be rather inconsistent.

Oh, I agree with any naming.

I guess Mikulas chose this name because the regular rw_semaphore has
init_rwsem(), not rwsem_init(), so this looks consistent.

> s/percpu_rw_semaphore/percpu_rwsem/g
> would be a good start, then consistently use percpu_rwsem_foo where
> practical.  But percpu_rwsem_down_read() doesn't sound practical :(

But personally I agree, percpu_rwsem_* looks better, and I will be
happy to send the trivial patch.

But can we do this later? This patch should touch the code in blockdev
and uprobes, and currently there is no single tree which this rename
can be based on.

> Is there much point in doing all these changes as five separate patches

four ;) .fix will be folded, I guess.

> (so far)?  Perhaps it should all blobbed into as little as one patch(es)?

Well, I'd prefer to keep this particular change as a separate patch,
and probably 3/3 too (just because I know nothing about kbuild/etc).

But 1/3 can be folded, I agree. And I won't argue if you ask me to
resend everything as one patch.

> You sent your uprobes changes to Ingo as a git pull, but I doubt if
> Ingo's trees contain the percpu_rwsem_rw_semaphore changes.

No, it doesn't. But, correctness-wise, percpu_rw_semaphore works fine
even without these changes, just it is "too slow" as it used in uprobes.
I hope that that fix and these changes will meet together in 3.8.

Oleg.

