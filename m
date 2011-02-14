Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289Ab1BNSOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 13:14:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131Ab1BNSOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 13:14:19 -0500
Date: Mon, 14 Feb 2011 19:06:09 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Tejun Heo <tj@kernel.org>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
	PTRACE_ATTACH
Message-ID: <20110214180609.GE15847@redhat.com>
References: <20110204105343.GA12133@htj.dyndns.org> <20110207174821.GA1237@redhat.com> <20110209141803.GH3770@htj.dyndns.org> <201102132325.55353.vda.linux@googlemail.com> <20110214153149.GB8761@redhat.com> <AANLkTikYf1CE41x6FjE6FiZ40v8taRSy8aZ3-5tjAvok@mail.gmail.com> <20110214173910.GA15847@redhat.com> <AANLkTiku4OQKgwCHF-c5dc4AZzmuCKmzk0EuTaqxK_Wr@mail.gmail.com> <20110214180034.GD15847@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110214180034.GD15847@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14, Oleg Nesterov wrote:
>
> On 02/14, Denys Vlasenko wrote:
> >
> > On Mon, Feb 14, 2011 at 6:39 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> > > On 02/14, Denys Vlasenko wrote:
> > >>
> > >> On Mon, Feb 14, 2011 at 4:31 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> > >> > On 02/13, Denys Vlasenko wrote:
> > >> >>
> > >> >> $ strace -tt sleep 30
> > >> >> 23:02:15.619262 execve("/bin/sleep", ["sleep", "30"], [/* 30 vars */]) = 0
> > >> >> ...
> > >> >> 23:02:15.622112 nanosleep({30, 0}, NULL) = ? ERESTART_RESTARTBLOCK (To be restarted)
> > >> >> 23:02:23.781165 --- SIGSTOP (Stopped (signal)) @ 0 (0) ---
> > >> >> 23:02:23.781251 --- SIGSTOP (Stopped (signal)) @ 0 (0) ---
> > >> >>     (I forgot again why we see it twice. Another quirk I guess...)
> > >> >
> > >> >      (this is correct, the tracee reports the signal=SIGSTOP, then
> > >> >       it reports it actually stopps with exit_code=SIGSTOP)
> > >>
> > >> Ah, I see. Is there any way debugger can distinguish between these two
> > >> different stops?
> > >
> > > IIRC, the (only?) way to distinguish is to check last_siginfo != NULL
> > > via ptrace(PTRACE_GETSIGINFO).
> >
> > What do you think strace needs to do when it sees second SIGSTOP
> > (meaning "in theory", not "on current kernel which may be buggy")?
> >
> > ptrace(PTRACE_SYSCALL, $PID, 0x1, 0)?
>
> proably this, or even ptrace(PTRACE_SYSCALL, $PID, 0x1, SIGSTOP).
> I think.
>
> (assuming that ptrace_resume() respects TASK_STOPPED)

Oh, but I forgot to mention... there is another problem, _any_
ptrace request when the tracee is stopped turns it into TASK_TRACED.

Oleg.

