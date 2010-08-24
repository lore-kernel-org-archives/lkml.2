Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab0HXIO3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 04:14:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58812 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683Ab0HXIO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 04:14:27 -0400
Date: Tue, 24 Aug 2010 10:14:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Venkatesh Pallipadi <venki@google.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 0/4] Finer granularity and task/cgroup irq time accounting
Message-ID: <20100824081407.GB27089@elte.hu>
References: <1279583835-22854-1-git-send-email-venki@google.com>
 <20100720095546.2f899e04@mschwide.boeblingen.de.ibm.com>
 <AANLkTiktBNr3pVOHwxX3piwagtkGxHpp5TepBFS3UGhb@mail.gmail.com>
 <20100722131239.208d9501@mschwide.boeblingen.de.ibm.com>
 <AANLkTim==2J3Fo8Axz0yLvpfWf1bq_e0c0EYWi6y3xRe@mail.gmail.com>
 <1282636286.2605.2307.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282636286.2605.2307.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2010-07-22 at 19:12 -0700, Venkatesh Pallipadi wrote:
> > >
> > > Well, the task and cgroup information is there but what does it really
> > > tell me? As long as the irq & softirq time can be caused by any other
> > > process I don't see the value of this incorrect data point.
> > >
> > 
> > Data point will be correct. How it gets used is a different qn. This
> > interface will be useful for Alert/Paranoid/Annoyed user/admin who
> > sees that the job exec_time is high but it is not doing any useful
> > work. 
> 
> I'm very sympathetic with Martin's POV. irq/softirq times per task 
> don't really make sense. In the case you provide above the solution 
> would be to subtract these times from the task execution time, not 
> break it out. In that case he would see his task not do much, and end 
> up with the same action list.

Right, andthis connects to something Frederic sent a few RFC patches for 
some time ago: finegrained irq/softirq perf stat support. If we do 
something in this area we need a facility that enables both types of 
statistics gathering.

Frederic's model is based on exclusion - so you could do a perf stat run 
that excluded softirq and hardirq execution from a workload's runtime. 
It's nifty, as it allows the reduction of measurement noise. (IRQ and 
softirq execution can be regarded as random noise added (or not added) 
to execution times)

Thanks,

	Ingo
