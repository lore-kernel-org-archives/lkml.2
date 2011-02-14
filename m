Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab1BNQJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 11:09:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755522Ab1BNQJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 11:09:57 -0500
Date: Mon, 14 Feb 2011 17:01:48 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Tejun Heo <tj@kernel.org>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
	PTRACE_ATTACH
Message-ID: <20110214160148.GD8761@redhat.com>
References: <20110204130455.GA3671@redhat.com> <20110209141803.GH3770@htj.dyndns.org> <20110209212526.GA9999@redhat.com> <201102140001.47218.vda.linux@googlemail.com> <20110214090356.GA21979@host1.dyn.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110214090356.GA21979@host1.dyn.jankratochvil.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14, Jan Kratochvil wrote:
>
> On Mon, 14 Feb 2011 00:01:47 +0100, Denys Vlasenko wrote:
> > * sleep runs in nanosleep
> > * SIGSTOP arrives, strace sees it
> > * strace logs it and allows it via ptrace(PTRACE_SYSCALL, ..., SIGSTOP)
> > * sleep process enters group-stop
>
> The last point breaks the documented behavior of ptrace:

Well, afaics no. This is what we currently do.

> 	If data is nonzero and not SIGSTOP, it is interpreted as a signal to
> 	be delivered to the child; otherwise, no signal is delivered.

Fantastic. I never knew the man states this (although the documentation
above means PTRACE_CONT).

But this is not true. And iirc this was never true. Netither PTRACE_CONT,
nor any other request threat SIGSTOP specially.

(also, please note that the signal is not necessarily delivered, only
 if we are going to resume the tracee after it reported the signal or
 syscall entry/exit)

> > * nothing happens until some other signal arrives
> > * say, SIGCONT arrives
>
> What if other signal arrives?

only SIGCONT can resume the stopped task (ignorign SIGKILL).

> The tracer probably should not be notified as
> the tracee is in a group-stop.

It is.

Oleg.

