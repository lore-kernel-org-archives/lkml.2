Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab1BNRcl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 12:32:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726Ab1BNRci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 12:32:38 -0500
Date: Mon, 14 Feb 2011 18:23:58 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
        Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
	PTRACE_ATTACH
Message-ID: <20110214172358.GB14528@redhat.com>
References: <20110204105343.GA12133@htj.dyndns.org> <20110207174821.GA1237@redhat.com> <20110209141803.GH3770@htj.dyndns.org> <201102132325.55353.vda.linux@googlemail.com> <20110214151340.GP18742@htj.dyndns.org> <20110214161515.GA11605@redhat.com> <20110214163346.GZ18742@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110214163346.GZ18742@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14, Tejun Heo wrote:
>
> On Mon, Feb 14, 2011 at 05:15:15PM +0100, Oleg Nesterov wrote:
> > > > PTRACE_CONT in this situation would do the same.
> > >
> > > This can be fixed by updating strace, right?  strace can look at the
> > > wait(2) exit code and if the tracee stopped for group stop, wait for
> > > the tracee to be continued instead of issuing PTRACE_SYSCALL.
> >
> > Yes, in this particular case strace could be more clever.
> >
> > But. The tracee should react to SIGCONT after that, this means we
> > shouldn't "delay" this stop or force the TASK_TRACED state.
>
> Yeap, which is achievable by treating group stop differently from
> ptrace traps and make it proceed to TASK_TRACED only if ptrace wants
> to issue commands.

Yes, agreed. And this is exactly what we currently do. Except, as you
pointed out, the simple s/STOPPED/TRACED/ change is buggy. But the fix
you suggested should be almost invisible to the userland.

> (reiterating just to make sure there's no
> misunderstanding)

The same from my side ;)

Oleg.

