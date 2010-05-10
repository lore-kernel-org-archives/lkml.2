Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417Ab0EJKQH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 06:16:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:43140 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756358Ab0EJKQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 06:16:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,361,1270450800"; 
   d="scan'208";a="516529205"
Subject: Re: [RFC][PATCH 2/9] perf: core, remove hw_perf_event_init
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1273484541.5605.3336.camel@twins>
References: <1273483595.15998.56.camel@minggr.sh.intel.com>
	 <1273484541.5605.3336.camel@twins>
Content-Type: text/plain
Date: Mon, 10 May 2010 18:15:21 +0800
Message-Id: <1273486521.15998.78.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-10 at 17:42 +0800, Peter Zijlstra wrote:
> On Mon, 2010-05-10 at 17:26 +0800, Lin Ming wrote:
> > A new field "pmu_id" is added to struct perf_event_attr.
> > 
> > 2 new functions: perf_event_register_pmu, perf_event_lookup_pmu
> > perf_event_register_pmu: the pmu registration facility
> > perf_event_lookup_pmu: lookup the pmu via the passed in event->attr.pmu_id.
> > 
> > A new api pmu->init_event to replace hw_perf_event_init
> 
> Another problem, this patch breaks all of perf by removing the weak call
> before there is a replacement.
> 
> Please rework such that there is a smooth transition.

OK, I'll rework

> 
> Also, for compatibilities sake, the cpu pmu will be required to get
> pmu_id==0, this doesn't provide that.
> 

Will provide that.

Thanks,
Lin Ming

