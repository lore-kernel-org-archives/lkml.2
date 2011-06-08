Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751202Ab1FHQkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 12:40:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152Ab1FHQj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 12:39:58 -0400
Date: Wed, 8 Jun 2011 18:36:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, tony.luck@intel.com, fenghua.yu@intel.com,
        monstr@monstr.eu, ralf@linux-mips.org, benh@kernel.crashing.org,
        paulus@samba.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        linux390@de.ibm.com, lethal@linux-sh.org, davem@davemloft.net,
        jdike@addtoit.com, richard@nod.at, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        linux-ia64@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au,
        linux-mips@linux-mips.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        sparclinux@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH -v2] Audit: push audit success and retcode into arch
	ptrace.h
Message-ID: <20110608163653.GA9592@redhat.com>
References: <20110603220451.23134.47368.stgit@paris.rdu.redhat.com> <20110607171952.GA25729@redhat.com> <1307472796.2052.12.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307472796.2052.12.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07, Eric Paris wrote:
>
> On Tue, 2011-06-07 at 19:19 +0200, Oleg Nesterov wrote:
> >
> > With or without this patch, can't we call audit_syscall_exit() twice
> > if there is something else in _TIF_WORK_SYSCALL_EXIT mask apart from
> > SYSCALL_AUDIT ? First time it is called from asm, then from
> > syscall_trace_leave(), no?
> >
> > For example. The task has TIF_SYSCALL_AUDIT and nothing else, it does
> > system_call->auditsys->system_call_fastpath. What if it gets, say,
> > TIF_SYSCALL_TRACE before ret_from_sys_call?
>
> No harm is done calling twice.  The first call will do the real work and
> cleanup.  It will set a flag in the audit data that the work has been
> done (in_syscall == 0) thus the second call will then not do any real
> work and won't have anything to clean up.

Hmm... and I assume context->previous != NULL is not possible on x86_64.
OK, thanks.

And I guess, all CONFIG_AUDITSYSCALL code in entry.S is only needed to
microoptimize the case when TIF_SYSCALL_AUDIT is the only reason for the
slow path. I wonder if it really makes the measureble difference...

Oleg.

