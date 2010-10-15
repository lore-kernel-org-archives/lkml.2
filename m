Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab0JOMSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 08:18:55 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:56289 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754292Ab0JOMSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 08:18:54 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18wM2tQe28wu3IC3pdu3QEi8CQJ2DZTx8mzv+rGyN
	FWMyVfu+1/NTOY
Subject: Re: [PATCH 4/4] sched: force balancing on newidle balance if local
 group has capacity
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Nikhil Rao <ncrao@google.com>, Ingo Molnar <mingo@elte.hu>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1287144395.29097.1462.camel@twins>
References: <1286996978-7007-1-git-send-email-ncrao@google.com>
	 <1286996978-7007-5-git-send-email-ncrao@google.com>
	 <1287144395.29097.1462.camel@twins>
Content-Type: text/plain
Date: Fri, 15 Oct 2010 14:18:49 +0200
Message-Id: <1287145129.9200.32.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-15 at 14:06 +0200, Peter Zijlstra wrote:
> On Wed, 2010-10-13 at 12:09 -0700, Nikhil Rao wrote:
> > +bool check_utilization(struct sd_lb_stats *sds)
> > +{
> > +       if (!sds->this_has_capacity || sds->busiest_has_capacity)
> > +               return false;
> > +
> > +       return true;
> > +}
> > +
> >  /******* find_busiest_group() helpers end here *********************/
> >  
> >  /**
> > @@ -2824,6 +2845,10 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
> >         if (!sds.busiest || sds.busiest_nr_running == 0)
> >                 goto out_balanced;
> >  
> > +       /*  SD_BALANCE_NEWIDLE trumps SMP nice when underutilized */
> > +       if (idle == CPU_NEWLY_IDLE && check_utilization(&sds))
> > +               goto force_balance; 
> 
> 
> Is that really worth an extra function?

(I did that)

No, just it made it look prettier to me.  I figured the compiler will
nuke it at zero cost.

	-Mike

