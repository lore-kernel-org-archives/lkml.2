Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377Ab1B1GME (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 01:12:04 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:33304 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751147Ab1B1GMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 01:12:02 -0500
Date: Sat, 26 Feb 2011 04:59:01 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
 PTRACE_ATTACH
Message-ID: <20110226035900.GD1656@ucw.cz>
References: <20110204130455.GA3671@redhat.com>
 <20110209141803.GH3770@htj.dyndns.org>
 <20110209212526.GA9999@redhat.com>
 <201102140001.47218.vda.linux@googlemail.com>
 <20110214090356.GA21979@host1.dyn.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110214090356.GA21979@host1.dyn.jankratochvil.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2011-02-14 10:03:56, Jan Kratochvil wrote:
> On Mon, 14 Feb 2011 00:01:47 +0100, Denys Vlasenko wrote:
> > * sleep runs in nanosleep
> > * SIGSTOP arrives, strace sees it
> > * strace logs it and allows it via ptrace(PTRACE_SYSCALL, ..., SIGSTOP)
> > * sleep process enters group-stop
> 
> The last point breaks the documented behavior of ptrace:
> 	If data is nonzero and not SIGSTOP, it is interpreted as a signal to
> 	be delivered to the child; otherwise, no signal is delivered.
> 
> I do not see it would affect gdb.  strace will change its behavior when
> SIGSTOP is sent to its tracee although the new behavior may be OK.
> 
> It is more a subject of apps compatibility testing with such a kernel change.

apps compatibility testing?

No, we don't change kernel APIs like that -- those are called
regressions.

Just make ptrace(PTRACE_SYSCALL_2, ...) with fixed semantics.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
