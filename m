Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab2BPTLf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 14:11:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755048Ab2BPTLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 14:11:33 -0500
Date: Thu, 16 Feb 2012 20:03:21 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Valdis.Kletnieks@vt.edu,
        Michal Marek <mmarek@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: + syscalls-x86-add-__nr_kcmp-syscall-v8.patch added to -mm tree
Message-ID: <20120216190321.GA2216@redhat.com>
References: <20120215195733.GA8021@albatros> <20120215200533.GQ1894@moon> <20120215202538.GK4533@moon> <20120215210934.GL4533@moon> <20120215215807.GM4533@moon> <20120216144954.GA11953@redhat.com> <20120216151340.GI1905@moon> <20120216164901.GD3849@moon> <20120216174047.GA31176@redhat.com> <20120216175809.GJ1905@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120216175809.GJ1905@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16, Cyrill Gorcunov wrote:
>
> On Thu, Feb 16, 2012 at 06:40:47PM +0100, Oleg Nesterov wrote:
> > On 02/16, Cyrill Gorcunov wrote:
> > >
> > > -static void access_unlock(struct task_struct *task)
> > > +static void kcmp_unlock(struct mutex *m1, struct mutex *m2)
> > >  {
> > > -	mutex_unlock(&task->signal->cred_guard_mutex);
> > > +	if (m2 > m1)
> > > +		swap(m1, m2);
> >
> > Well, the order doesn't matter in case of _unlock, you can remove
> > this part. Not that it really hurts though, I won't argue.
>
> It drops some instructions so I think it worth removing

Yes.

> (still
> unlocking not in reverse order is something which always make
> me nervious ;)

Yes ;)

so let me repeat, I am not arguing. But IMHO every piece of code
should be understandable. Personally I do not mind at all, just
I _personally_ think this code _can_ confuse the reader, "damn why
we can't simply unlock in any order???".

If you add the "not really needed" comment above this swap - I agree.
If you simply remove this swap - I agree as well.

But. I won't argue if you prefer to keep this patch as is. You are the
author. If it looks better to _you_ - OK, this is correct (afaics).

Oleg.

