Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab1CATHD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:07:03 -0500
Received: from host1.dyn.jankratochvil.net ([89.250.240.48]:39790 "EHLO
	host1.dyn.jankratochvil.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752291Ab1CATHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:07:01 -0500
Date: Tue, 1 Mar 2011 20:06:38 +0100
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        Denys Vlasenko <vda.linux@googlemail.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [RFC] Proposal for ptrace improvements
Message-ID: <20110301190638.GA12196@host1.dyn.jankratochvil.net>
References: <20110301152457.GE26074@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110301152457.GE26074@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Mar 2011 16:24:57 +0100, Tejun Heo wrote:
> P4. PTRACE_SEIZE
[...]
> Completion notification is delivered in the usual way via wait(2).  If
> the task was in jctl stop, it would report the stop signal with the
> matching siginfo.  If the task hits an existing ptrace trap condition,
> the matching SIGTRAP will be reported; otherwise, SIGTRAP will be
> reported with siginfo indicating PTRACE_SEIZE trap.

This is a change from the Roland's proposed PTRACE_ATTACH_NOSTOP.
Currently it is already a problem that apps did not / do not expect the first
waitpid after PTRACE_ATTACH may not be SIGSTOP.  And in the racy case of
a pending signal during PTRACE_ATTACH which gets delivered by first waidpid
the tracer either crashes or loses the signal etc.  (It was a problem for
older GDB, it is fixed in recent GDBs, there exist other ptrace using tools.)

And after all it gets complicated to call PTRACE_ATTACH and then postpone the
reception of SIGSTOP while other signals are being delivered first.


> WAY FORWARD (yeah, I'm feeling some marketing vibe)
> -----------
[...]
> What someone would want if one could start from the scratch is interesting
> but ultimately irrelevant.

The ugdb project provides unified debugging facility for both local and remote
debugging.  With the ptrace extensions a network protocol server needs to be
developed/used anyway and it will be just a thin userland layer mapping
read/write calls to the ptrace calls on the server side in an ineffective way.

OTOH one can look at the similar case of TUX/khttpd (also) has never been
merged into the kernel.


Regards,
Jan
