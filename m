Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab0EJK1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 06:27:13 -0400
Received: from mga14.intel.com ([143.182.124.37]:11473 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428Ab0EJK1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 06:27:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,361,1270450800"; 
   d="scan'208";a="275225169"
Subject: Re: [RFC][PATCH 3/9] perf: export registerred pmus via sysfs
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
In-Reply-To: <1273486708.5605.3342.camel@twins>
References: <1273483623.15998.57.camel@minggr.sh.intel.com>
	 <1273484401.5605.3333.camel@twins>
	 <1273486313.15998.76.camel@minggr.sh.intel.com>
	 <1273486708.5605.3342.camel@twins>
Content-Type: text/plain
Date: Mon, 10 May 2010 18:26:35 +0800
Message-Id: <1273487195.15998.85.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-10 at 18:18 +0800, Peter Zijlstra wrote:
> On Mon, 2010-05-10 at 18:11 +0800, Lin Ming wrote:
> > On Mon, 2010-05-10 at 17:40 +0800, Peter Zijlstra wrote:
> > > On Mon, 2010-05-10 at 17:27 +0800, Lin Ming wrote:
> > > > Export pmus via sysfs /sys/devices/system/cpu/pmus/0...N
> > > > The file name is the pmu id, ie, /sys/devices/system/cpu/pmus/N
> > > > represents pmu id N.
> > > > So perf tool can use it to initialize perf_event_attr. 
> > > 
> > > Why create a whole new directory, why not:
> > > 
> > >  /sys/devices/system/cpu/cpuN/pmu_id ?
> > 
> > 
> > Do you mean /sys/devices/system/cpu/cpuN/pmu_id contain all ids?
> > 
> > For example, each cpu has 4 pmus and the file pmu_id shows something
> > like,
> > 
> > #cat /sys/devices/system/cpu/cpu0/pmu_id
> > 0 1 2 3
> 
> No, I'm assuming there is only 1 PMU per CPU. Corey is the expert on
> crazy hardware though, but I think the sanest way is to extend the CPU
> topology if there's more structure to it.

But our goal is to support multiple pmus, don't we need to assume there
are more than 1 PMU per CPU?

> 
> It simply doesn't make sense to have multiple PMU IDs on a single
> topology entry, how would you choose?

How about
/sys/devices/system/cpu/cpuN/pmu_0
/sys/devices/system/cpu/cpuN/pmu_1
/sys/devices/system/cpu/cpuN/pmu_2
/sys/devices/system/cpu/cpuN/pmu_3
....?


