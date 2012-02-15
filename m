Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab2BOPqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 10:46:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864Ab2BOPqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 10:46:04 -0500
Date: Wed, 15 Feb 2012 16:38:16 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
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
Message-ID: <20120215153816.GA15988@redhat.com>
References: <20120215143606.GA14037@redhat.com> <20120215151008.GL1894@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120215151008.GL1894@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15, Cyrill Gorcunov wrote:
>
> On Wed, Feb 15, 2012 at 03:36:06PM +0100, Oleg Nesterov wrote:
> >
> > > +
> > > +	/*
> > > +	 * One should have enough rights to inspect task details.
> > > +	 */
> > > +	if (!ptrace_may_access(task1, PTRACE_MODE_READ) ||
> > > +	    !ptrace_may_access(task2, PTRACE_MODE_READ)) {
> > > +		ret = -EACCES;
> >
> > Well, probably this is fine... but may be you can add a comment.
> > The task can change its credentials right after ptrace_may_access()
> > succeeds. This _looks_ wrong, perhaps it makes sense to  add the
> > "we do not care" note.
> >
>
> Wait, how it's differ from other ptrace_may_access calls all over
> the kernel? I suppose I'm missing something obvious?

For example? Say, mm_access() is fine because it returns ->mm
which we are going to play with.

But map_files_d_revalidate/proc_map_files_get_link looks wrong,
there are obviously racy and should use mm_access().

Probably something else is wrong too.

Once again, I am not saying that this code really has the security
problems. I simply do not know. But it looks wrong without the
comment. I do not really understand why do we need ptrace_may_access(),
but whatever reason we have how we can trust it? Say, when KCMP_VM
checks ->mm, all we know is that PTRACE_MODE_READ succeed in the
past. This looks confusing, imho.

Oleg.

