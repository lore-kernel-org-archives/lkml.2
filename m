Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759850Ab1CDSNR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 13:13:17 -0500
Received: from [46.28.109.124] ([46.28.109.124]:36832 "EHLO
	host1.jankratochvil.net" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751883Ab1CDSNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 13:13:16 -0500
Date: Fri, 4 Mar 2011 19:12:50 +0100
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Tejun Heo <tj@kernel.org>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [RFC] Proposal for ptrace improvements
Message-ID: <20110304181250.GA31141@host1.jankratochvil.net>
References: <20110301152457.GE26074@htj.dyndns.org>
 <20110301190638.GA12196@host1.dyn.jankratochvil.net>
 <AANLkTiknaHNADRa3R4Tefg2TGuFmKPZY-_08_krFiNFF@mail.gmail.com>
 <20110304161441.GA12987@host1.jankratochvil.net>
 <20110304170737.GA26904@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110304170737.GA26904@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Mar 2011 18:07:37 +0100, Oleg Nesterov wrote:
> Suppose that the tracee reports, say, a signal after PTRACE_SEIZE/INTERRUPT.
> And this is possible anyway if the debugger races with kill(). Why this
> is bad?

I was asking if it is possible or if it could be avoided.

When you check gdb-6.8.tar it asserts the first received signal is SIGSTOP or
in a different case it ignores the first signal (whatever it is).  This is
because if the programmer sees during the development the first signal that
comes is SIGSTOP (s)he automatically writes the code with that assumption.

When the tracer has a function to attach a task it should be a self-sufficient
function returning the tracee in some normal task like after other events.
So the attach operation should neither leave pending some excessive signals
nor it should eat some normal vital signals (like PTRACE_EVENT_FORK).

Sure the tracer can always handle it some way, ignore this signal, remember if
it has seen that signal etc.  But if we design a new ptrace interface it
should be simple to use and it should not suggest coding racy/buggy tracers.


Thanks,
Jan
