Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539Ab2BOPKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 10:10:16 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45063 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab2BOPKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 10:10:12 -0500
Date: Wed, 15 Feb 2012 19:10:08 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Valdis.Kletnieks@vt.edu,
        Michal Marek <mmarek@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: + syscalls-x86-add-__nr_kcmp-syscall-v8.patch added to -mm tree
Message-ID: <20120215151008.GL1894@moon>
References: <20120215143606.GA14037@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120215143606.GA14037@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 03:36:06PM +0100, Oleg Nesterov wrote:
> 
> task->files can be NULL, we can race with exit_files().

So I need to call get_files_struct. Thanks Oleg!

> 
> > +	fdt = files_fdtable(task->files);
> > +	if (idx < fdt->max_fds)
> > +		file = fdt->fd[idx];
> 
> You can probably rely on rcu instead of ->file_lock, but this is minor.
> 

I think so. I'll be updating the patch anyway (on top of current
one) so I'll address this comment too. Thanks!

> > +
> > +	/*
> > +	 * One should have enough rights to inspect task details.
> > +	 */
> > +	if (!ptrace_may_access(task1, PTRACE_MODE_READ) ||
> > +	    !ptrace_may_access(task2, PTRACE_MODE_READ)) {
> > +		ret = -EACCES;
> 
> Well, probably this is fine... but may be you can add a comment.
> The task can change its credentials right after ptrace_may_access()
> succeeds. This _looks_ wrong, perhaps it makes sense to  add the
> "we do not care" note.
> 

Wait, how it's differ from other ptrace_may_access calls all over
the kernel? I suppose I'm missing something obvious?

	Cyrill
