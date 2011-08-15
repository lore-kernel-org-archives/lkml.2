Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362Ab1HOTpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 15:45:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242Ab1HOTpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 15:45:43 -0400
Date: Mon, 15 Aug 2011 21:42:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Matt Fleming <matt.fleming@linux.intel.com>,
        linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v2 0/3] make vfork killable
Message-ID: <20110815194209.GA19239@redhat.com>
References: <20110727163159.GA23785@redhat.com> <20110729192358.GB31717@mtj.dyndns.org> <20110812175550.GA7484@redhat.com> <20110813161814.GE4254@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110813161814.GE4254@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 08/13, Tejun Heo wrote:
>
> Hello, Oleg.
>
> On Fri, Aug 12, 2011 at 07:55:50PM +0200, Oleg Nesterov wrote:
> > > an alternative approach
> > > could be handling vfork waiting as a type of job control stop.
> >
> > Well, I didn't see the code, but to be honest this doesn't look
> > like a good idea to me. Firstly, personally I do not think this
> > has something to do with the job control stop.
> >
> > And, to me sys_restart_syscall() looks like the very natural
> > approach, and simple.
>
> I've been playing with this and it does a bit further than
> implementation simplicity.  Currently, we have three different modes
> of stopping a task.
>
> * Regular job control and ptrace.
> * vfork wait.
> * cgroup freeze.

I still can't understand what exactly you have in mind.

And to me vfork() is closer to nanoslep() than to cgroup_freezer.
(As for cgroup_freezer, I agree it would be nice to reimplent it
 in any case).

> The downside is that that wouldn't work with cgroup freeze at
> all - there's no syscall to restart.

Sure. Still I don't understand why restart is not suitable for vfork
and why it would be better to unify freezer/vfork.

OK. Let's discuss this later, I hope you will cc me ;)


But what do you think about this series? It is simple, it doesn't
play with restarts. In some sense it even simplifies the code because
it removes one user of ->vfork_done. I don't think these patches can
complicate the further changes you are going to do.

No?

Oleg.

