Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607Ab0EKIvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 04:51:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:39605 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756589Ab0EKIvR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 04:51:17 -0400
Subject: Re: [RFC][PATCH 3/9] perf: export registerred pmus via sysfs
From: Peter Zijlstra <peterz@infradead.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>, lkml <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <carll@us.ibm.com>
In-Reply-To: <1273566031.30322.31.camel@minggr.sh.intel.com>
References: <1273484401.5605.3333.camel@twins>
	 <1273486313.15998.76.camel@minggr.sh.intel.com>
	 <1273486708.5605.3342.camel@twins>
	 <1273487195.15998.85.camel@minggr.sh.intel.com>
	 <1273490824.5605.3379.camel@twins> <20100510114311.GA6449@elte.hu>
	 <1273492164.5605.3397.camel@twins> <20100510115344.GA11238@elte.hu>
	 <4BE8931C.9070106@linux.vnet.ibm.com> <1273560419.5605.3426.camel@twins>
	 <20100511072127.GB10421@elte.hu>
	 <1273566031.30322.31.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 11 May 2010 10:50:15 +0200
Message-ID: <1273567815.5605.3491.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-11 at 16:20 +0800, Lin Ming wrote:

> How will this sysfs interface be used for userspace tool?
> 
>  /sys/devices/system/node/nodeN/node_events
>                                node_events/event_source_id
> 
>                                node_events/local_misses/event_id
>                                           /local_hits/event_id
>                                           /remote_misses/event_id
>                                           /remote_hits/event_id
> 
> For example, to monitor node event local_misses on node 0, does it work
> as below?
> 
> 1. perf top -e local_misses -n 0 (-n 0 means node 0)
> 
> 2. read /sys/devices/system/node/node0/node_events/event_source_id to
> get the pmu_id
> 
> 3. read /sys/devices/system/node/node0/node_events/local_misses/event_id
> to get the event_id
> 
> 4. event_attr::pmu_id=pmu_id, event::config=event_id
> 
> 5. other setting...
> 
> 6. call syscall perf_event_open(....)

No, you'll use event_source_id as perf_event_attr::type, use event_id as
perf_event_attr::config and then use a cpu-wide counter on a cpu
contained in node0.


