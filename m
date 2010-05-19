Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598Ab0ERRoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 13:44:05 -0400
Received: from mga14.intel.com ([143.182.124.37]:7653 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757327Ab0ERRoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 13:44:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,256,1272870000"; 
   d="scan'208";a="278571361"
Subject: [RFC][PATCH v2 0/11] perf: remove __weak function
 hw_perf_event_init
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <carll@us.ibm.com>, "greg@kroah.com" <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 May 2010 01:43:58 +0000
Message-Id: <1274233438.3036.78.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
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

Here is v2 of the patch series.
v2 only touches the x86 code, let me first gather comments if this is the
right direction to go...
And then touch other arches.

[PATCH 01/11] perf: un-const struct pmu *
[PATCH 02/11] perf: core, add pmu register and lookup functions
[PATCH 03/11] perf: x86, implement pmu->init_event
[PATCH 04/11] perf: core, use new api to lookup pmu and init event
[PATCH 05/11] perf: x86, remove hw_perf_event_init
[PATCH 06/11] perf: core, export pmus via sysfs
[PATCH 07/11] perf: x86, implements pmu::register_events
[PATCH 08/11] sysfs: introduce new interface sysfs_get_kobject
[PATCH 09/11] perf: multiplex perf_event_attr::type field
[PATCH 10/11] perf: core, lookup pmu via sysfs
[PATCH 11/11] perf top: demo of how to use the sysfs interface

Thanks for any comments.

Lin Ming

