Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab1BSUYs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 15:24:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083Ab1BSUYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 15:24:47 -0500
Date: Sat, 19 Feb 2011 21:16:03 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Tejun Heo <tj@kernel.org>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
	PTRACE_ATTACH
Message-ID: <20110219201603.GB8662@redhat.com>
References: <20110204105343.GA12133@htj.dyndns.org> <AANLkTi=Djwcf9YoUrGtTEOp8W_YhsefzrNhMxVhtw_Lp@mail.gmail.com> <20110216215157.GA6054@host1.dyn.jankratochvil.net> <201102170437.51382.vda.linux@googlemail.com> <20110217191952.GA13611@redhat.com> <20110218211140.GA2066@host1.dyn.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110218211140.GA2066@host1.dyn.jankratochvil.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18, Jan Kratochvil wrote:
>
> On Thu, 17 Feb 2011 20:19:52 +0100, Oleg Nesterov wrote:
> > > > That is after PTRACE_DETACH(0) the process should remain `T (stopped)'
> > > > iff the process was `T (stopped)' before PTRACE_ATTACH.
> > > >  - PTRACE_DETACH(0)       should preserve `T (stopped)'.
> > >
> > > I assume you are thinking about PTRACE_ATTACH + wait():SIGSTOP
> > > + PTRACE_DETACH(0) sequence.
> >
> > plus it should be stopped before attach, I assume. Otherwise this
> > not true with the current code.
>
> I did not talk about the current code.  I was making a proposal of new
> behavior (which should not break existing software).

Confused.

> If PTRACE_ATTACH was done on process with `T (stopped)'

this matters "it should be stopped before attach"

> then after
> PTRACE_DETACH(0) again the process should be `T (stopped)'.

Regardless of what the debugger did in between? This can't be right.
I'd say, it doesn't make sense to take the state of the tracee before
PTRACE_ATTACH into account. What does matter, is its state before
PTRACE_DETACH.

If the debugger did not resume the tracee before PTRACE_DETACH, then
of course I agree, PTRACE_DETACH(0) should preserve T (stopped).

But again, lets discuss this separately.

Oleg.

