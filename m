Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760041Ab1CDRQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 12:16:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42412 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759954Ab1CDRQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 12:16:42 -0500
Date: Fri, 4 Mar 2011 18:07:37 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Tejun Heo <tj@kernel.org>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [RFC] Proposal for ptrace improvements
Message-ID: <20110304170737.GA26904@redhat.com>
References: <20110301152457.GE26074@htj.dyndns.org> <20110301190638.GA12196@host1.dyn.jankratochvil.net> <AANLkTiknaHNADRa3R4Tefg2TGuFmKPZY-_08_krFiNFF@mail.gmail.com> <20110304161441.GA12987@host1.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110304161441.GA12987@host1.jankratochvil.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04, Jan Kratochvil wrote:
>
> On Tue, 01 Mar 2011 23:14:14 +0100, Denys Vlasenko wrote:
> > On Tue, Mar 1, 2011 at 8:06 PM, Jan Kratochvil <jan.kratochvil@redhat.com> wrote:
> > > Currently it is already a problem that apps did not / do not expect the first
> > > waitpid after PTRACE_ATTACH may not be SIGSTOP.
> >
> > That's exactly why we want to add a better alternative, which doesn't
> > insert that blasted SIGSTOP.
>
> But it insteads blasted SIGTRAP (or some other signal) instead.

I don't really understand your concerns... If you modify gdb to use
PTRACE_SEIZE you can forget about the current problems with the first
signal.

Currently gdb has to take care, but mostly because it should "dismiss"
the real signal sent by attach.

> It would be best if such PTRACE_SEIZE (similar to PTRACE_INTERRUPT) would
> guarantee the first waitpid afterwards returns the artificial signal from
> PTRACE_SEIZE.

Again, I don't think this really matters.

Suppose that the tracee reports, say, a signal after PTRACE_SEIZE/INTERRUPT.
And this is possible anyway if the debugger races with kill(). Why this
is bad?

Oleg.

