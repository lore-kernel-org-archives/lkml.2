Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab1BOQH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 11:07:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754964Ab1BOQHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 11:07:25 -0500
Date: Tue, 15 Feb 2011 16:58:48 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
        Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
	PTRACE_ATTACH
Message-ID: <20110215155848.GA8699@redhat.com>
References: <20110209141803.GH3770@htj.dyndns.org> <201102132325.55353.vda.linux@googlemail.com> <20110214151340.GP18742@htj.dyndns.org> <AANLkTi=Djwcf9YoUrGtTEOp8W_YhsefzrNhMxVhtw_Lp@mail.gmail.com> <20110214175144.GC15847@redhat.com> <AANLkTi=VVWVkrqqQyOtsP72S5-nWny=Ukmf_r-m1qMwV@mail.gmail.com> <20110214190141.GA19221@redhat.com> <AANLkTi=_af8+XKD+d-677JpQZA=AN2EsydscSYxk7z55@mail.gmail.com> <20110214200130.GA21559@redhat.com> <20110215152448.GL3160@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110215152448.GL3160@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tejun,

On 02/15, Tejun Heo wrote:
>
> Hello, Oleg, Denys.
>
> On Mon, Feb 14, 2011 at 09:01:30PM +0100, Oleg Nesterov wrote:
> > > Or we can avoid entering TASK_TRACED on ptrace(PTRACE_GETSIGINFO) et al.
> > > Can we remain in TASK_STOPPED?
> >
> > Oh, unlikely, I think.
>
> Actually I was thinking along this line.  We can allow
> PTRACE_GETSIGINFO to proceed without forcing the tracee into TRACED
> state, the rationale being the operation is required to tell between
> group stop and ptrace trap.  Am I missing something?

I do not think this is really wrong (except this means another user
visible change and I never know if it is fine).

But I think it doesn't really help. Yes, this is probably enough for
strace (I don't know for sure) , but a more "sophisticated" debugger
may want to do something else with the stopped tracee.


And. Denys suggested this assuming PTRACE_CONT-doesnt-resume-until-SIGCONT,
and in this case this is not really needed. The debugger can safely do
PTRACE_GETSIGINFO even if this changes the state to TASK_TRACED.
Once it does PTRACE_CONT the tracee becomes "visible" to SIGCONT. Or,
if SIGCONT comes in between, the tracee runs.

Oleg.

