Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717Ab0FBVAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 17:00:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757538Ab0FBVAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 17:00:40 -0400
Date: Wed, 2 Jun 2010 22:58:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Paul Menage <menage@google.com>
Cc: Ben Blum <bblum@andrew.cmu.edu>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       ebiederm@xmission.com, lizf@cn.fujitsu.com, matthltc@us.ibm.com
Subject: Re: [RFC] [PATCH 2/2] cgroups: make procs file writable
Message-ID: <20100602205855.GA30039@redhat.com>
References: <20100530013002.GA762@ghc01.ghc.andrew.cmu.edu> <20100530013303.GC762@ghc01.ghc.andrew.cmu.edu> <20100531175242.GA14691@redhat.com> <20100531180446.GA16249@redhat.com> <AANLkTimcrX0TjzDMNJdubR92pAO4IPATbVpyvvVt0qIV@mail.gmail.com> <20100602140659.GA5324@redhat.com> <AANLkTin-T6ij3xf0ceGoCamwcoayxyf0GdAKY6yXDMVl@mail.gmail.com> <20100602202048.GB28663@redhat.com> <AANLkTimrJFiidM8BlUNvmzfapUAv8369R9PYnTscasEf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimrJFiidM8BlUNvmzfapUAv8369R9PYnTscasEf@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02, Paul Menage wrote:
>
> On Wed, Jun 2, 2010 at 1:20 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > Yes sure. The main thread can exit via sys_exit(), this doesn't affect
> > the thread group. Of course, I am not saying this is common practice,
> > perhaps no "important" app does this.
>
> This check has been in cgroups for quite a while and no-one's
> complained so far...

Sure. because currently attach_task_by_pid() works with the single
thread. But Ben's patch reuses this code to call cgroup_attach_proc().

> > But I still can't understand why we can't just remove it. Both
> > cgroup_attach_task() and cgroup_attach_proc() should handle the
> > possible races correctly anyway.
>
> The "it" that you're proposing to remove is in fact the code that
> handles those races.

In that case I confused, and I thought we already agreed that
the PF_EXITING check in attach_task_by_pid() is not strictly needed
for correctness.

Once again, the task can call do_exit() and set PF_EXITING right
after the check.

> Anyway, I think this issue is orthogonal to the movability of entire
> processes - with Ben's patch, an exited-but-not-reaped group leader is
> immovable either via "tasks" or "cgroup.procs".

Hmm. As I said, I didn't really read this patch. But I thought that
cgroup_attach_proc() tries to handle this.

Anyway I agree, this is minor and I never pretended I understand
this code.


Hmm. The usage of ->thread_group in ->can_attach() methods doesn't
look safe to me... but currently bool threadgroup is always false.

Oleg.

