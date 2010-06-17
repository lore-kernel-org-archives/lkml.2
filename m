Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab0FQALw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 20:11:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755407Ab0FQALv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 20:11:51 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Kees Cook <kees.cook@canonical.com>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] ptrace: allow restriction of ptrace scope
In-Reply-To: Kees Cook's message of  Wednesday, 16 June 2010 16:39:37 -0700 <20100616233937.GQ24749@outflux.net>
References: <20100616221833.GM24749@outflux.net>
	<20100616231006.34A28403D2@magilla.sf.frob.com>
	<20100616233937.GQ24749@outflux.net>
X-Zippy-Says: Here we are in America...  when do we collect unemployment?
Message-Id: <20100617001114.A90F5403D2@magilla.sf.frob.com>
Date: Wed, 16 Jun 2010 17:11:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Though, honestly, just trying to get rid of PTRACE seems like the better
> place to spend time.

Crushing irony of telling *me* this duly noted.  ;-)
I am not really sure what deeply different set of security constraints
you envision on any other kind of new debugger interface that would be
any different for the concerns you've expressed, though.

> > I don't think "task->pid > 0" is a sort of check that is used elsewhere in
> > the kernel for this.  Perhaps "task == &init_task" would be better.
> 
> Is this correct for pid_ns?  I thought pid 1 (regardless of NS) would have
> a NULL parent?

Don't ask me.  I just mentioned pid_ns to get those who really know about
it to feel obliged to review your code.

> > I suspect you really want to test same_thread_group(walker, current).
> > You don't actually mean to rule out a debugger that forks children with
> > one thread and calls ptrace with another, do you?
> 
> Won't they ultimately have the same parent, though?

Sure, those debugger threads will have the same parent, such as the shell
that spawned the debugger.  But your "security" check is that the caller of
ptrace is a direct ancestor of the tracee.  The ancestry of that ptrace
caller is immaterial.


Thanks,
Roland
