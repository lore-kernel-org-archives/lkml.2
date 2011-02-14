Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab1BNJE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 04:04:29 -0500
Received: from host1.dyn.jankratochvil.net ([89.250.240.48]:37078 "EHLO
	host1.dyn.jankratochvil.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752276Ab1BNJE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 04:04:27 -0500
Date: Mon, 14 Feb 2011 10:03:56 +0100
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
 PTRACE_ATTACH
Message-ID: <20110214090356.GA21979@host1.dyn.jankratochvil.net>
References: <20110204130455.GA3671@redhat.com>
 <20110209141803.GH3770@htj.dyndns.org>
 <20110209212526.GA9999@redhat.com>
 <201102140001.47218.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102140001.47218.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Feb 2011 00:01:47 +0100, Denys Vlasenko wrote:
> * sleep runs in nanosleep
> * SIGSTOP arrives, strace sees it
> * strace logs it and allows it via ptrace(PTRACE_SYSCALL, ..., SIGSTOP)
> * sleep process enters group-stop

The last point breaks the documented behavior of ptrace:
	If data is nonzero and not SIGSTOP, it is interpreted as a signal to
	be delivered to the child; otherwise, no signal is delivered.

I do not see it would affect gdb.  strace will change its behavior when
SIGSTOP is sent to its tracee although the new behavior may be OK.

It is more a subject of apps compatibility testing with such a kernel change.


> * nothing happens until some other signal arrives
> * say, SIGCONT arrives

What if other signal arrives?  The tracer probably should not be notified as
the tracee is in a group-stop.


> * strace logs it and allows it via ptrace(PTRACE_SYSCALL, ..., SIGCONT)


Thanks,
Jan
