Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab0CZNgw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 09:36:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709Ab0CZNgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 09:36:51 -0400
Date: Fri, 26 Mar 2010 14:34:39 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Grzegorz Nosek <root@localdomain.pl>, Roland McGrath <roland@redhat.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Testing lxc 0.6.5 in Fedora 13
Message-ID: <20100326133439.GA15790@redhat.com>
References: <20100321195044.GA23757@megiteam.pl> <20100323212834.GH20796@count0.beaverton.ibm.com> <20100325213356.GB20541@megiteam.pl> <20100326111131.GA8604@redhat.com> <20100326113201.GB17113@megiteam.pl> <20100326120028.GA11311@redhat.com> <20100326124619.GC3345@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100326124619.GC3345@count0.beaverton.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26, Matt Helsley wrote:
>
> On Fri, Mar 26, 2010 at 01:00:28PM +0100, Oleg Nesterov wrote:
> > 
> > > +               ptrace_pid_vnr = nr;
> > > +               if (unlikely(p->parent != p->real_parent)) {
> > > +                       rcu_read_lock();
> > > +                       ptrace_pid_vnr = task_pid_nr_ns(p, p->parent->nsproxy->pid_ns);
> > 
> > Yes, this is what I meant.
> > 
> > But we should not do this in do_fork().
> 
> I'm puzzled. If not here, where should we do this? Or are you saying
> ptrace should take a reference to the pid,

Ah, no, sorry.

I meant tracehook_report_clone_complete should do this under "if (trace)".
And we need a helper to get the right pid, it could be used
by do_notify_parent() too, and (probably) we need more changes like this.

> > But once again. This change fixes the value in "tracee->ptrace_message == newpid",
> > but a quick grep shows that strace-4.5.19 doesn't use PTRACE_GETEVENTMSG at all.
>
> You are correct. However strace and gdb aren't necessarily the only users
> of ptrace so wouldn't it still be good to fix this?

Yes, agreed.

Oh. The only problem is utrace patches in -mm. I mean the possible textual
conflicts...

Oleg.

