Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab0L2Sh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 13:37:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717Ab0L2Shx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 13:37:53 -0500
Date: Wed, 29 Dec 2010 19:30:16 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Dario Faggioli <raistlin@linux.it>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>, torbenh <torbenh@gmx.de>,
        john.stultz@linaro.org, roland@redhat.com, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH resend] Reading POSIX CPU timer from outside the
	process.
Message-ID: <20101229183016.GA455@redhat.com>
References: <1293121303.3390.185.camel@Palantir> <1293533742.2899.1028.camel@Palantir> <20101228163829.GA26533@redhat.com> <1293572304.2899.1214.camel@Palantir> <20101229132130.GA16349@redhat.com> <1293631815.2899.1238.camel@Palantir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293631815.2899.1238.camel@Palantir>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29, Dario Faggioli wrote:
>
> On Wed, 2010-12-29 at 14:21 +0100, Oleg Nesterov wrote:
>
> > You do not need clock_getcpuclockid() at all. In fact I do not really
> > understand what this helper should actually do, probably it is only
> > needed to validate the pid. You can simply use MAKE_THREAD_CPUCLOCK()
> > to sample a single thread via clock_gettime().
> >
> Fine, but, is that macro available for an application developer? Because
> I can find it in kernel and glibc sources, but not in my /usr/include/*,
> which is the motivation behind this attempt... But it might be my
> fault! :-P

Yes, I do not see MAKE_*_CPUCLOCK() in /usr/include.

> > IOW. Unless I missed something, with this patch, the only problem
> > is that getcpuclockid() always assumes MAKE_PROCESS_CPUCLOCK(),
> > I do not think this is the kernel problem.
> >
> Agreed, sorry for wasting (hopefully not too much) people's time. :-(

No, I think you have a point. I'd suggest you to re-send the
patch which removes this limitation from kernel side.

My only objection was, we shouldn't add the hacks to overcome
the limitations in glibc. Say, posix_cpu_clock_get() should only
check CPUCLOCK_PERTHREAD(), it should not treat !group_leader
specially just because getcpuclockid() can construct the proper
clock id. This should be solved in userland.

Oleg.

