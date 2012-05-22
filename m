Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011Ab2EVJGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 05:06:17 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:41100 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755965Ab2EVJGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 05:06:14 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19TT/oFs51TF+oQqOvpXzLkXyuRG23ByAjbTmAI6C
	Wmxx7dv4zBsZ1i
Message-ID: <1337677564.5446.11.camel@marge.simpson.net>
Subject: Re: [PATCH 1/2] sched: readd FAIR_SLEEPERS feature
From: Mike Galbraith <efault@gmx.de>
To: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Tue, 22 May 2012 11:06:04 +0200
In-Reply-To: <4FBB3C3B.3090202@linux.vnet.ibm.com>
References: <1337615137-55111-1-git-send-email-schwidefsky@de.ibm.com>
	 <1337615137-55111-2-git-send-email-schwidefsky@de.ibm.com>
	 <4FBB3C3B.3090202@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-22 at 09:11 +0200, Christian Ehrhardt wrote: 
> 
> On 05/21/2012 05:45 PM, Martin Schwidefsky wrote:
> [...]
> > --- a/kernel/sched/features.h
> > +++ b/kernel/sched/features.h
> > @@ -1,3 +1,12 @@
> > +#ifdef CONFIG_SCHED_FAIR_SLEEPERS
> > +/*
> > + * Disregards a certain amount of sleep time (sched_latency_ns) and
> > + * considers the task to be running during that period. This gives it
> > + * a service deficit on wakeup, allowing it to run sooner.
> > + */
> > +SCHED_FEAT(FAIR_SLEEPERS, false)
> > +#endif
> > +
> >   /*
> >    * Only give sleepers 50% of their service deficit. This allows
> >    * them to run sooner, but does not allow tons of sleepers to
> 
> This would be right for s390, but a change to every other architecture.
> As far as I know s390 had custom patches in any distribution supported 
> on s390 to set the default to false (like in your patch), but the 
> upstream default for every other architecture was true.
> 
> I think the patch could look like this to make all happy:
> ...
> +#ifndef CONFIG_S390
> + SCHED_FEAT(FAIR_SLEEPERS, true)
> +#else
> +SCHED_FEAT(FAIR_SLEEPERS, false)
> ...

Um, yeah, default off is a non-starter.. until someone comes up with a
less annoying preemption model that is.

-Mike

