Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab1BTVVH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 16:21:07 -0500
Received: from host1.dyn.jankratochvil.net ([89.250.240.48]:47012 "EHLO
	host1.dyn.jankratochvil.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754928Ab1BTVVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 16:21:06 -0500
Date: Sun, 20 Feb 2011 22:20:53 +0100
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Tejun Heo <tj@kernel.org>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
 PTRACE_ATTACH
Message-ID: <20110220212053.GA23412@host1.dyn.jankratochvil.net>
References: <20110219201603.GB8662@redhat.com>
 <20110219200637.GA8662@redhat.com>
 <20110220094050.GA7714@host1.dyn.jankratochvil.net>
 <20110220171658.GA27355@redhat.com>
 <20110220185204.GA14737@host1.dyn.jankratochvil.net>
 <20110220203819.GB32682@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110220203819.GB32682@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Feb 2011 21:38:19 +0100, Oleg Nesterov wrote:
> On 02/20, Jan Kratochvil wrote:
> > If I do (on kernel-debug-2.6.35.11-83.fc14.x86_64)
> > 	ptrace (PTRACE_ATTACH);
> > 	sleep (1);
> > 	ptrace (PTRACE_DETACH, 0);
> >
> > even without the wait() it really has no effect.
> 
> Well. what does this "has no effect" mean? ;) I am totally confused.
> We were talking about the case when the tracee was stopped before
> attach, right?

No, the case it is not `(T) stopped'.  I was surprised by this ptrace behavior
but it is offtopic and not useful so let's drop it.


> So. So far I assume you are not against this change ;)

No, although you should provide the patch in advance, it would be nice to also
post it first to <gdb@sourceware.org> for comments.

Now if new GDB should allow inferior functions calls on previously
`(T) stopped' process doing PTRACE_CONT(SIGCONT) for executing the call should
be harmless but how to make it `(T) stopped' afterwards?  PTRACE_CONT(SIGSTOP)
right after the inferior call will make the old kernels run the inferior - we
do not want that.  GDB can only wait till the end of debugging session and do
PTRACE_DETACH(SIGSTOP).  But we are back at the point if GDB crashes in
between the inferior will accidentally resume.

(This is the ``(T) stopped' preservation after _exit()' thread along claimed
to be unrelated.)


Thanks,
Jan
