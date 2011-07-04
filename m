Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757795Ab1GDPsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 11:48:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756749Ab1GDPsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 11:48:39 -0400
Date: Mon, 4 Jul 2011 17:44:05 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-hardening@lists.openwall.com, Randy Dunlap <rdunlap@xenotime.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [RFC] ipc: introduce shm_rmid_forced sysctl
Message-ID: <20110704154405.GA9544@redhat.com>
References: <20110622152514.GA9521@albatros> <20110704150859.GB6893@redhat.com> <20110704153644.GB21350@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110704153644.GB21350@albatros>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04, Vasiliy Kulikov wrote:
>
> On Mon, Jul 04, 2011 at 17:08 +0200, Oleg Nesterov wrote:
> > On 06/22, Vasiliy Kulikov wrote:
> > >
> > > +void exit_shm(struct task_struct *task)
> > > +{
> > > +	struct nsproxy *nsp = task->nsproxy;
> > > +	struct ipc_namespace *ns;
> > > +
> > > +	if (!nsp)
> > > +		return;
> > > +	ns = nsp->ipc_ns;
> > > +	if (!ns || !ns->shm_rmid_forced)
> >
> > This looks confusing, imho. How it is possible that ->nsproxy or
> > ->ipc_ns is NULL?
>
> I spotted the same checking logic in other places.  I don't know whether
> it is redundant, I guess it can happen when the namespace is dying.
> Probably it cannot happed inside of task do_exit(), only for extern
> observers.

No, afaics it can't happen in do_exit() until we call exit_notify().
Otherwise, for example, any dying child will OOPS in do_notify_parent().
Or please look at exit_sem()->sem_lock_check(tsk->nsproxy->ipc_ns).

Oleg.

