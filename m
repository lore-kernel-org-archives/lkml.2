Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570Ab0FBUW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 16:22:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758067Ab0FBUWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 16:22:25 -0400
Date: Wed, 2 Jun 2010 22:20:49 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Paul Menage <menage@google.com>
Cc: Ben Blum <bblum@andrew.cmu.edu>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       ebiederm@xmission.com, lizf@cn.fujitsu.com, matthltc@us.ibm.com
Subject: Re: [RFC] [PATCH 2/2] cgroups: make procs file writable
Message-ID: <20100602202048.GB28663@redhat.com>
References: <20100530013002.GA762@ghc01.ghc.andrew.cmu.edu> <20100530013303.GC762@ghc01.ghc.andrew.cmu.edu> <20100531175242.GA14691@redhat.com> <20100531180446.GA16249@redhat.com> <AANLkTimcrX0TjzDMNJdubR92pAO4IPATbVpyvvVt0qIV@mail.gmail.com> <20100602140659.GA5324@redhat.com> <AANLkTin-T6ij3xf0ceGoCamwcoayxyf0GdAKY6yXDMVl@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin-T6ij3xf0ceGoCamwcoayxyf0GdAKY6yXDMVl@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02, Paul Menage wrote:
>
> On Wed, Jun 2, 2010 at 7:06 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > I am not sure. It doesn't hurt when we try to move a thread. But if
> > we want to move the whole thread group, we should proceed even if the
> > group leader has already exited and thus has PF_EXITING bit set.
>
> Hmm, maybe. I could see this being argued both ways. Can the process
> hang around indefinitely with the leader as a zombie and the other
> threads still running?

Yes sure. The main thread can exit via sys_exit(), this doesn't affect
the thread group. Of course, I am not saying this is common practice,
perhaps no "important" app does this.

> It wouldn't be that hard to make it possible to avoid relying on
> PF_EXITING as the check - instead we'd have an exiting_css_set object
> that have the same pointer set as init_css_set, but would be
> distinguishable from it as a task->cgroups pointer by virtue of being
> a different object. Then cgroup_exit() can reassign tasks to point to
> exiting_css_set rather than init_css_set, and the various checks that
> are currently made for (task->flags & PF_EXITING) could check for
> (task->cgroups == exiting_css_set) instead. This would allow task
> movement further into the exit process.

It is too late for me to even try to understand the above ;)

But I still can't understand why we can't just remove it. Both
cgroup_attach_task() and cgroup_attach_proc() should handle the
possible races correctly anyway.

Oleg.

