Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932743Ab3AJDQ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 22:16:56 -0500
Received: from mout.gmx.net ([212.227.17.21]:56198 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932659Ab3AJDQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 22:16:55 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18ww4kXiCIwB2FwrkdbwdvIM+YUFcSeLWzBc1Mz/x
	8il/6LzoOpTqsO
Message-ID: <1357787806.26078.4.camel@marge.simpson.net>
Subject: Re: [PATCH v3 04/22] sched: don't need go to smaller sched domain
From: Mike Galbraith <efault@gmx.de>
To: Morten Rasmussen <Morten.Rasmussen@arm.com>
Cc: Alex Shi <alex.shi@intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>, "pjt@google.com" <pjt@google.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 10 Jan 2013 04:16:46 +0100
In-Reply-To: <20130109173807.GB2046@e103034-lin>
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
	 <1357375071-11793-5-git-send-email-alex.shi@intel.com>
	 <20130109173807.GB2046@e103034-lin>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-09 at 17:38 +0000, Morten Rasmussen wrote: 
> On Sat, Jan 05, 2013 at 08:37:33AM +0000, Alex Shi wrote:
> > If parent sched domain has no task allowed cpu find. neither find in
> > it's child. So, go out to save useless checking.
> > 
> > Signed-off-by: Alex Shi <alex.shi@intel.com>
> > ---
> >  kernel/sched/fair.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> > 
> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > index 3c7b09a..ecfbf8e 100644
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -3378,10 +3378,8 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
> >  			load_idx = sd->wake_idx;
> >  
> >  		group = find_idlest_group(sd, p, cpu, load_idx);
> 
> The previous patch changed the behavior of find_idlest_group() to
> returning the local group if it is suitable. This effectively means that
> you remove the recursive search for a suitable idle sched group. You
> could as well merge find_idlest_group() and find_idlest_cpu() to avoid
> iterating through the cpus of the same sched group twice.

find_idlest_* could stop when seeing 0 too, can't get much more idle.

-Mike

