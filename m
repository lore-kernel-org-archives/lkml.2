Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230Ab0LUFuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 00:50:15 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:36470 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751651Ab0LUFuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 00:50:13 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19Y18U1maxYW+WNb7/IHOU/hO1Cl7tfYEuprH4hPF
	OCiNgofExRIYk+
Subject: Re: [tip:sched/core] sched: Add 'autogroup' scheduling feature:
 automated per session task groups
From: Mike Galbraith <efault@gmx.de>
To: Bharata B Rao <bharata.rao@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, mathieu.desnoyers@efficios.com,
        torvalds@linux-foundation.org, pjt@google.com, markus@trippelsdorf.de,
        tglx@linutronix.de, oleg@redhat.com, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
In-Reply-To: <AANLkTikdarpzXgLA5Ve-9bjaDbNpnjOShioE3yf2ytp0@mail.gmail.com>
References: <1290281700.28711.9.camel@maggy.simson.net>
	 <tip-5091faa449ee0b7d73bc296a93bca9540fc51d0a@git.kernel.org>
	 <AANLkTimRfVFmuMJzuirgsc37=RhC6zKX0C0YXhXO44O9@mail.gmail.com>
	 <1292851159.5021.2.camel@laptop>
	 <AANLkTi=3-FpuzXZ8xoEWCPhKrwydDOj0m4n-eEh-2BdT@mail.gmail.com>
	 <1292863193.19476.9.camel@marge.simson.net>
	 <AANLkTikdarpzXgLA5Ve-9bjaDbNpnjOShioE3yf2ytp0@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Dec 2010 06:50:11 +0100
Message-ID: <1292910611.6614.18.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-21 at 10:34 +0530, Bharata B Rao wrote:
> On Mon, Dec 20, 2010 at 10:09 PM, Mike Galbraith <efault@gmx.de> wrote:
> > On Mon, 2010-12-20 at 21:16 +0530, Bharata B Rao wrote:
> >> On Mon, Dec 20, 2010 at 6:49 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >> > On Mon, 2010-12-20 at 18:38 +0530, Bharata B Rao wrote:
> >> >> The autogroup patchset removes the display of cgroup name from
> >> >> sched_debug output.
> >> >
> >> > Hrmph.. that wasn't supposed to happen, care to send a patch to fix that
> >> > up?
> >>
> >> There are two aspects here:
> >>
> >> - Printing cgroup name for per-CPU cfs_rqs shouldn't be affected by
> >>   autogroup and the old code should work here.
> >> - Printing cgroup name for tasks depends on task_group(), which has
> >> been changed by autogroup patch. I haven't really looked deep into
> >> autogroup patch, but from whatever I can gather, Mike had a reason
> >> to remove this bit from sched_debug. The task groups created for
> >> autogroups don't have cgroups associated with them and hence no
> >> dentries and hence no pathnames.
> >
> > Mike didn't remove it, but _was_ supposed to get around to it.
> >
> >> I guess we could do fix this as shown in the attached patch.
> >
> >
> > +#ifdef CONFIG_CGROUP_SCHED
> > +       {
> > +               char path[64];
> > +
> >
> > ...
> >
> > +#if defined(CONFIG_CGROUP_SCHED) && defined(CONFIG_FAIR_GROUP_SCHED)
> > +       char path[128];
> >
> >
> > One reason it was removed was path[64/128].
> 
> Other callers of cgroup_path use PATH_MAX=4096 here. I believe the
> original reason for these short path sizes was to be light on stack
> and as well as to avoid allocation. Can we have some reasonable length
> (256 or 512 ?) and live with truncation (if that ever happens) ?

I don't see why not, unlikely situation in non-critical path.

> Also, while displaying group name with tasks, does it make sense to
> display autogroup-<id> (the one shown in /proc/<pid>/autogroup) ?

I did to me obviously :)  I'm fine with it not showing up, though if it
survives and evolves, maybe it'll want visibility.  ATM, you know what's
in what group via ps -o foo,session.

	-Mike


