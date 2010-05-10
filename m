Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab0EJLMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 07:12:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:27665 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753297Ab0EJLM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 07:12:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,361,1270450800"; 
   d="scan'208";a="620330233"
Subject: Re: [RFC][PATCH 3/9] perf: export registerred pmus via sysfs
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mundt <lethal@linux-sh.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1273489474.5605.3355.camel@twins>
References: <1273483623.15998.57.camel@minggr.sh.intel.com>
	 <1273484401.5605.3333.camel@twins>
	 <1273486313.15998.76.camel@minggr.sh.intel.com>
	 <1273486708.5605.3342.camel@twins>
	 <1273487195.15998.85.camel@minggr.sh.intel.com>
	 <20100510103546.GB14278@linux-sh.org>
	 <1273489084.15998.99.camel@minggr.sh.intel.com>
	 <1273489474.5605.3355.camel@twins>
Content-Type: text/plain
Date: Mon, 10 May 2010 19:11:53 +0800
Message-Id: <1273489913.15998.103.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-10 at 19:04 +0800, Peter Zijlstra wrote:
> On Mon, 2010-05-10 at 18:58 +0800, Lin Ming wrote:
> > Take Nehalem core and uncore pmu as an example,
> > 
> > core pmu sits under /sys/devices/system/cpu/cpuN/pmu_id with ID 0,
> > 
> > But uncore pmu is shared by cpus within package, where should it sit
> > under? 
> 
> I already gave you the answer to that:
> 
>  /sys/devices/system/cpu/cpuN/nodeN/
> 
> the uncore pmu is the memory controller (aka node) pmu.

Ah, much clear now.

perf_event_register_pmu needs another paramter, like

perf_event_register_pmu(struct pmu *pmu, int pmu_type);

Thanks.

