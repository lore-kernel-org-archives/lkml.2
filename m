Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab1FMAgy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 20:36:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:21288 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754558Ab1FMAgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 20:36:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,356,1304319600"; 
   d="scan'208";a="13574698"
Subject: Re: [PATCH]rcu: avoid unnecessary thread wakeup
From: Shaohua Li <shaohua.li@intel.com>
To: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20110610163842.GB2230@linux.vnet.ibm.com>
References: <1307692251.15392.91.camel@sli10-conroe>
	 <20110610163842.GB2230@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Jun 2011 08:36:50 +0800
Message-ID: <1307925410.15392.94.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-06-11 at 00:38 +0800, Paul E. McKenney wrote:
> On Fri, Jun 10, 2011 at 03:50:51PM +0800, Shaohua Li wrote:
> > invoke_rcu_cpu_kthread could be called in the thread itself. In this case,
> > we don't need call wakeup, which is just wasting CPU.
> > 
> > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> > 
> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index 89419ff..f9bd051 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -1475,7 +1475,8 @@ static void invoke_rcu_cpu_kthread(void)
> >  		local_irq_restore(flags);
> >  		return;
> >  	}
> > -	wake_up_process(__this_cpu_read(rcu_cpu_kthread_task));
> > +	if (current != __this_cpu_read(rcu_cpu_kthread_task))
> > +		wake_up_process(__this_cpu_read(rcu_cpu_kthread_task));
> >  	local_irq_restore(flags);
> >  }
> 
> Excellent point, thank you!
> 
> But how about combining the tests, perhaps something like the
> following?
> 
> Unless you have objections or spot problems with it (or it breaks during
> testing), I will queue the patch below with your SOB, since I derived
> it from your patch.
that's better, thanks.

Thanks,
Shaohua

