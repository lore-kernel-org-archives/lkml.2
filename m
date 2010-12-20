Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837Ab0LTQjy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 11:39:54 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:38749 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932292Ab0LTQjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 11:39:53 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+BDFcjLaWBYHsfZwqHkkoigq6cFKUZhnmtl6TbL6
	sOxGcLKRZRkuTl
Subject: Re: [tip:sched/core] sched: Add 'autogroup' scheduling feature:
 automated per session task groups
From: Mike Galbraith <efault@gmx.de>
To: Bharata B Rao <bharata.rao@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, mathieu.desnoyers@efficios.com,
        torvalds@linux-foundation.org, pjt@google.com, markus@trippelsdorf.de,
        tglx@linutronix.de, oleg@redhat.com, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
In-Reply-To: <AANLkTi=3-FpuzXZ8xoEWCPhKrwydDOj0m4n-eEh-2BdT@mail.gmail.com>
References: <1290281700.28711.9.camel@maggy.simson.net>
	 <tip-5091faa449ee0b7d73bc296a93bca9540fc51d0a@git.kernel.org>
	 <AANLkTimRfVFmuMJzuirgsc37=RhC6zKX0C0YXhXO44O9@mail.gmail.com>
	 <1292851159.5021.2.camel@laptop>
	 <AANLkTi=3-FpuzXZ8xoEWCPhKrwydDOj0m4n-eEh-2BdT@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Dec 2010 17:39:53 +0100
Message-ID: <1292863193.19476.9.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-20 at 21:16 +0530, Bharata B Rao wrote:
> On Mon, Dec 20, 2010 at 6:49 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > On Mon, 2010-12-20 at 18:38 +0530, Bharata B Rao wrote:
> >> The autogroup patchset removes the display of cgroup name from
> >> sched_debug output.
> >
> > Hrmph.. that wasn't supposed to happen, care to send a patch to fix that
> > up?
> 
> There are two aspects here:
> 
> - Printing cgroup name for per-CPU cfs_rqs shouldn't be affected by
>   autogroup and the old code should work here.
> - Printing cgroup name for tasks depends on task_group(), which has
> been changed by autogroup patch. I haven't really looked deep into
> autogroup patch, but from whatever I can gather, Mike had a reason
> to remove this bit from sched_debug. The task groups created for
> autogroups don't have cgroups associated with them and hence no
> dentries and hence no pathnames.

Mike didn't remove it, but _was_ supposed to get around to it.

> I guess we could do fix this as shown in the attached patch.


+#ifdef CONFIG_CGROUP_SCHED
+	{
+		char path[64];
+

...

+#if defined(CONFIG_CGROUP_SCHED) && defined(CONFIG_FAIR_GROUP_SCHED)
+	char path[128];

 
One reason it was removed was path[64/128].

	-Mike

