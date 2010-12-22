Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab0LVQHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 11:07:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4156 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753870Ab0LVQHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 11:07:35 -0500
Date: Wed, 22 Dec 2010 17:00:16 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 10/16] ptrace: clean transitions between TASK_STOPPED
	and TRACED
Message-ID: <20101222160016.GA11722@redhat.com>
References: <1291654624-6230-1-git-send-email-tj@kernel.org> <1291654624-6230-11-git-send-email-tj@kernel.org> <20101220150037.GE11583@redhat.com> <20101221173155.GE13285@htj.dyndns.org> <20101222113948.GA30266@redhat.com> <20101222151429.GC8061@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101222151429.GC8061@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22, Tejun Heo wrote:
>
> On Wed, Dec 22, 2010 at 12:39:48PM +0100, Oleg Nesterov wrote:
> >
> > sys_ptrace() only works for the single thread who did PTRACE_ATTACH,
> > but do_wait() should work for its sub-threads.
> >
> > 	1. the tracer knows that the tracee is stopped
> >
> > 	2. the tracer does ptrace(ATTACH)
> >
> > 	3. the tracer's sub-thread does do_wait()
> >
> > Note! Personally I think we can ignore this "problem", I do not
> > think it can break anything except some specialized test-case.
>
> But if ptrace(ATTACH) doesn't return until the transition is complete
> when the task is already stopped, the tracer's sub-thread's do_wait()
> will behave exactly the same.  The only difference would be that
> ptrace(ATTACH) may now block and/or is failed by a signal delivery.
>
> How would #3 behave differently if STOPPED -> TRACED transition is
> guaranteed to be complete by the end of #2?

Ahhh, sorry. I meant, two threads can do 2. and 3. at the same time.

But let me repeat, it is not that I think we should worry. I mentioned
this only because I think it is better to discuss everything we can,
even the really minor things.

Oleg.

