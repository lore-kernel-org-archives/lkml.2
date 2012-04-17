Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab2DQUoB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 16:44:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275Ab2DQUoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 16:44:00 -0400
Date: Tue, 17 Apr 2012 22:43:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Smith <dsmith@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: hlist_for_each_entry && pos (Was: task_work_queue)
Message-ID: <20120417204322.GA22946@redhat.com>
References: <20120412024751.GA17561@redhat.com> <20120412024810.GA17984@redhat.com> <20120412040059.GA20462@redhat.com> <20120416223512.GI2448@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120416223512.GI2448@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16, Paul E. McKenney wrote:
>
> On Thu, Apr 12, 2012 at 06:00:59AM +0200, Oleg Nesterov wrote:
> >
> > hlist_for_each_entry_*() do not need "pos", it can be
> >
> > 	#define hlist_for_each_entry(pos, head, member)					\
> > 		for (pos = (void*)(head)->first;					\
> > 		pos && ({ pos = hlist_entry((void*)pos, typeof(*pos), member); 1; });	\
> > 		pos = (void*)(pos)->member.next)
> >
> > The only problem, is there any possibility to change the callers
> > somehow??? I even wrote the script which converts them all, but the
> > patch is huge.
> >
> > Please see the old (2008-04-21) message I sent to lkml below, today
> > the diffstat is even "worse":
> >
> > 	152 files changed, 611 insertions(+), 906 deletions(-)
> >
> > and the patch size is 242k.
> >
> > No? we can't?
>
> Maybe this needs a phased approach:
>
> 1.	Add a new API name without the "pos" argument.

and this is the first (or main?) problem. Which name??

> 2.	Send individual patches to the uses, which allows time to
> 	clean up stragglers.
>
> 3.	Remove the old API name.  If any patches from #2 have been
> 	ignored, push them with the removal patch.
>
> 4.	Rename the new API name to the old one, if desired.

Yes, this is much safer, I agree. But I'm afraid that 2. will be
never finished.

And 4. is not trivial anyway, even if it is trivial to generate
the obviously correct patch. Too many trees I guess.


This reminds me I promised to check the code generation. Will do
anyway. But I do not expect any improvement, just it should not
be worse. The only point is too make the usage more simple (you
seem to agree). But at the same time I agree with "the pain
changing the interface" from Linus.

Oleg.

