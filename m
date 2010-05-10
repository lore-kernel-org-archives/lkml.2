Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679Ab0EJJZu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 05:25:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:12369 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689Ab0EJJZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 05:25:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,361,1270450800"; 
   d="scan'208";a="620309919"
Subject: [RFC][PATCH 0/9] perf: remove __weak function hw_perf_event_init
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 10 May 2010 17:25:15 +0800
Message-Id: <1273483515.15998.54.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

On Wed, Mar 31, 2010 at 1:15 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> Right, I've got some definite ideas on how to go here, just need some
> time to implement them.
>
> The first thing that needs to be done is get rid of all the __weak
> functions (with exception of perf_callchain*, since that really is arch
> specific).
>
> For hw_perf_event_init() we need to create a pmu registration facility
> and lookup a pmu_id, either passed as an actual id found in sysfs or an
> open file handle from sysfs (the cpu pmu would be pmu_id 0 for backwards
> compat).

Here are 9 small patches to remove __weak function hw_perf_event_init

[PATCH 1/9] perf: un-const struct pmu *
A new field "id" will be added to struct pmu, and the "id" is assigned
at registration time, so the struct is not const any more.

[PATCH 2/9] perf: core, remove weak function hw_perf_event_init
A new field "pmu_id" is added to struct perf_event_attr.
2 new functions: perf_event_register_pmu, perf_event_lookup_pmu
perf_event_register_pmu: the pmu registration facility
perf_event_lookup_pmu: lookup the pmu via the passed in
event->attr.pmu_id.
A new api pmu->init_event to replace hw_perf_event_init

[PATCH 3/9] perf: export registered pmus via sysfs
Export pmus via sysfs /sys/devices/system/cpu/pmus/0...N
The file name is the pmu id, so perf tool can use it to initialize
perf_event_attr.

[PATCH 4/9] perf: x86, convert to new API pmu->init_event
[PATCH 5/9] perf: arm, convert to new API pmu->init_event
[PATCH 6/9] perf: powerpc, convert to new API pmu->init_event
[PATCH 7/9] perf: sh, convert to new API pmu->init_event
[PATCH 8/9] perf: sparc, convert to new API pmu->init_event
[PATCH 9/9] perf top: set perf_event_attr->pmu_id

Thanks for any comments.

Lin Ming

