Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab0DUOig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 10:38:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:41548 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755393Ab0DUOif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 10:38:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,250,1270450800"; 
   d="scan'208";a="791473369"
Subject: Re: [RFC] perf_events: support for uncore a.k.a. nest units
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1271859755.1776.108.camel@laptop>
References: <OFA47E1D5E.A81B0A43-ON07257706.00721254-07257706.0074D40F@us-phx1.az05.bull.com>
	 <1271424250.4807.2277.camel@twins>
	 <1271764547.13968.69.camel@minggr.sh.intel.com>
	 <1271764993.1676.431.camel@laptop>
	 <1271837295.3794.3.camel@minggr.sh.intel.com>
	 <m2q7c86c4471004210132id258e98y47134ab3bd486efe@mail.gmail.com>
	 <1271839190.3794.5.camel@minggr.sh.intel.com>
	 <i2j7c86c4471004210144kd8223bfbve5d6bee2820d0ccf@mail.gmail.com>
	 <1271842974.3794.16.camel@minggr.sh.intel.com>
	 <1271843869.1776.65.camel@laptop>  <1271887942.3054.33.camel@localhost>
	 <1271859755.1776.108.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Apr 2010 22:38:22 +0000
Message-Id: <1271889502.7414.14.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-21 at 22:22 +0800, Peter Zijlstra wrote:
> On Wed, 2010-04-21 at 22:12 +0000, Lin Ming wrote:
> > +       ret = pmu->commit_txn(pmu);
> > +       if (!ret) {
> > +               pmu->stop_txn(pmu);
> > +               return 0;
> > +       }
> >  
> >  group_error:
> > +       pmu->stop_txn(pmu); 
> 
> If you let commit_txn() also clear the state you can save some logic and
> a method.

I add this ->stop_txn(pmu) because the rollback code also need to clear
the state.

> 
> But yes, this looks good. If you don't remove the weak interface just
> yet, you can do a patch per architecture that uses this (at least
> powerpc and sparc do), and remove the weak thing at the end once all
> users are gone.
> 

OK, I'll do that for powerpc and sparc.

And need to check if there are transaction methods in group_sched_in for
other arch, as below.

group_sched_in(...)
{
	if (pmu->start_txn)
		pmu->start_txn(pmu);

	if (pmu->commit_txn)
		pmu->commit_txn(pmu)
}

Thanks,
Lin Ming

