Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab1BTTYz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 14:24:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754235Ab1BTTYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 14:24:54 -0500
Date: Sun, 20 Feb 2011 20:16:35 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, torvalds@linux-foundation.org,
        Tejun Heo <tj@kernel.org>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
	PTRACE_ATTACH
Message-ID: <20110220191635.GA32682@redhat.com>
References: <20110220094050.GA7714@host1.dyn.jankratochvil.net> <201102201806.30273.vda.linux@googlemail.com> <20110220191026.GA16288@host1.dyn.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110220191026.GA16288@host1.dyn.jankratochvil.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20, Jan Kratochvil wrote:
>
> On Sun, 20 Feb 2011 18:06:30 +0100, Denys Vlasenko wrote:
>
> > Not exactly. Even after we fix kernel so that it properly preserves
> > group-stop across ptrace-stops, gdb will still see TWO
> > waitpid:SIGSTOP events, not one.
> >
> > First one says "the tracee has received SIGSTOP", and after PTRACE_CONT(SIGSTOP),
> > second one says "the tracee has stopped because of SIGSTOP".
> > Currently, neither strace nor gdb understands that second one
> > is different from first.
>
> I thought the kernel change being discussed should be the second SIGSTOP will
> receive the process's original parent,

No, no, the debugger should see this notification whatever we do.

> so that CTRL-Z on a debugged process
> from shell works the normal way, as without a debugger.

Yes, this is yet another problem (din't I say we have a lot of them? ;),
CTRL-Z should work and thus we have notify original parent as well.
And even this is not enough, we should change do_wait(WSTOPPED).
But this is another story, gdb shouldn't be affected by these changes.

Oleg.

