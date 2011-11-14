Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab1KNRkE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 12:40:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab1KNRkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 12:40:01 -0500
Date: Mon, 14 Nov 2011 18:39:47 +0100 (CET)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost6.localdomain6
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH 2/2] Compile error with allmodconfig and
 CONFIG_PREEMPT_RT_FULL=y
In-Reply-To: <20111114165148.GB2372@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.00.1111141837100.6707@localhost6.localdomain6>
References: <1321235083-21756-1-git-send-email-jkacur@redhat.com> <1321235083-21756-2-git-send-email-jkacur@redhat.com> <20111114165148.GB2372@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Nov 2011, Paul E. McKenney wrote:

> On Mon, Nov 14, 2011 at 02:44:43AM +0100, John Kacur wrote:
> > ERROR: "in_serving_softirq" [net/sched/cls_cgroup.ko] undefined!
> > 
> > The above can be fixed by exporting in_serving_softirq
> > 
> > Signed-off-by: John Kacur <jkacur@redhat.com>
> > 
> > The above patch was originally for 3.0.9-rt25
> > But I also needed to cherry-pick it for 3.2-rc1-rt1
> > ---
> >  kernel/softirq.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/softirq.c b/kernel/softirq.c
> > index 3db1d6f..5452432 100644
> > --- a/kernel/softirq.c
> > +++ b/kernel/softirq.c
> > @@ -447,6 +447,7 @@ int in_serving_softirq(void)
> >  	preempt_enable();
> >  	return res;
> >  }
> > +EXPORT_SYMBOL(in_serving_softirq);
> 
> Why not EXPORT_SYMBOL_GPL?

I have no problem with that, note however that the upstream file has

EXPORT_SYMBOL(irq_stat);
EXPORT_SYMBOL(local_bh_disable);
EXPORT_SYMBOL(_local_bh_enable);
EXPORT_SYMBOL(local_bh_enable);
EXPORT_SYMBOL(local_bh_enable_ip);
EXPORT_SYMBOL(__tasklet_schedule);
EXPORT_SYMBOL(__tasklet_hi_schedule);
EXPORT_SYMBOL(__tasklet_hi_schedule_first);
EXPORT_SYMBOL(tasklet_init);
EXPORT_SYMBOL(tasklet_kill);
EXPORT_SYMBOL(__send_remote_softirq);
EXPORT_SYMBOL(send_remote_softirq);

Any reason we can't change all of those to EXPORT_SYMBOL_GPL?

> 
> With that change,
> 
> Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Not yet ready for mainline, because mainline does not yet have
> in_serving_softirq().  Therefore not queued for -rcu.
> 
> 							Thanx, Paul
> 
> >  /*
> >   * Called with bh and local interrupts disabled. For full RT cpu must
