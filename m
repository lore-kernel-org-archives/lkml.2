Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab2AUIJ7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 03:09:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37020 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312Ab2AUIJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 03:09:57 -0500
Date: Sat, 21 Jan 2012 09:09:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] vmstat reports no interrupts
Message-ID: <20120121080939.GA32134@elte.hu>
References: <20120114000101.GL1068@n2100.arm.linux.org.uk>
 <1327005616.4826.4.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1327005616.4826.4.camel@edumazet-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Le samedi 14 janvier 2012 à 00:01 +0000, Russell King - ARM Linux a
> écrit :
> > From: Russell King <rmk+kernel@arm.linux.org.uk>
> > proc: fix /proc/stat intr sum
> > 
> > Commit 3292beb340c7688 (sched/accounting: Change cpustat fields to an array)
> > deleted the code which provides us with the sum of all interrupts in
> > the system, causing vmstat to report zero interrupts occuring in the
> > system.  Fix this by restoring the code.
> > 
> > Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> > Tested-by: Russell King <rmk+kernel@arm.linux.org.uk> [on ARM]
> > ---
> >  fs/proc/stat.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/proc/stat.c b/fs/proc/stat.c
> > index d76ca6a..121f77c 100644
> > --- a/fs/proc/stat.c
> > +++ b/fs/proc/stat.c
> > @@ -77,6 +77,8 @@ static int show_stat(struct seq_file *p, void *v)
> >  		steal += kcpustat_cpu(i).cpustat[CPUTIME_STEAL];
> >  		guest += kcpustat_cpu(i).cpustat[CPUTIME_GUEST];
> >  		guest_nice += kcpustat_cpu(i).cpustat[CPUTIME_GUEST_NICE];
> > +		sum += kstat_cpu_irqs_sum(i);
> > +		sum += arch_irq_stat_cpu(i);
> >  
> >  		for (j = 0; j < NR_SOFTIRQS; j++) {
> >  			unsigned int softirq_stat = kstat_softirqs_cpu(j, i);
> > 
> 
> Any news on this patch being accepted and pushed to Linus ?

It should be in v3.3-rc1.

Thanks,

	Ingo
