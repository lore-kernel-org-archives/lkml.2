Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758439Ab0GHRu5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 13:50:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:36015 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756682Ab0GHRuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 13:50:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,559,1272870000"; 
   d="scan'208";a="584198559"
Subject: Re: [PATCH] sched: Call update_group_power only for local_group
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Venkatesh Pallipadi <venki@google.com>,
       LKML <linux-kernel@vger.kernel.org>, Gautham R Shenoy <ego@in.ibm.com>,
       Joel Schopp <jschopp@austin.ibm.com>,
       Michael Neuling <mikey@neuling.org>
In-Reply-To: <1278611346.1900.165.camel@laptop>
References: <1278088816.1917.279.camel@laptop>
	 <1278089799-11949-1-git-send-email-venki@google.com>
	 <1278598336.1900.150.camel@laptop>
	 <1278611133.2834.10.camel@sbs-t61.sc.intel.com>
	 <1278611346.1900.165.camel@laptop>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 08 Jul 2010 10:50:16 -0700
Message-Id: <1278611416.2834.12.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-08 at 10:49 -0700, Peter Zijlstra wrote:
> On Thu, 2010-07-08 at 10:45 -0700, Suresh Siddha wrote:
> >  
> > @@ -2456,6 +2454,9 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
> >  	init_sd_power_savings_stats(sd, sds, idle);
> >  	load_idx = get_sd_load_idx(sd, idle);
> >  
> > +	if (this_cpu == smp_processor_id())
> > +		update_group_power(sd, this_cpu);
> > +
> >  	do {
> >  		int local_group;
> 
> Which will break for nohz_idle_balance..

Then the logic is broken somewhere because update_group_power() reads
APERF/MPERF MSR's which doesn't make sense when this_cpu !=
smp_processor_id(). What am I missing?

thanks,
suresh

