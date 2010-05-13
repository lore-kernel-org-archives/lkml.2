Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab0EMI3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 04:29:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:61963 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873Ab0EMI3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 04:29:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,221,1272870000"; 
   d="scan'208";a="798050052"
Subject: Re: [RFC][PATCH 3/9] perf: export registerred pmus via sysfs
From: Lin Ming <ming.m.lin@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: greg@kroah.com, Peter Zijlstra <peterz@infradead.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
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
In-Reply-To: <20100511091833.GB18869@elte.hu>
References: <20100510114311.GA6449@elte.hu>
	 <1273492164.5605.3397.camel@twins> <20100510115344.GA11238@elte.hu>
	 <4BE8931C.9070106@linux.vnet.ibm.com> <1273560419.5605.3426.camel@twins>
	 <20100511072127.GB10421@elte.hu>
	 <1273566031.30322.31.camel@minggr.sh.intel.com>
	 <1273567815.5605.3491.camel@twins>
	 <1273568620.30322.42.camel@minggr.sh.intel.com>
	 <1273569154.5605.3499.camel@twins>  <20100511091833.GB18869@elte.hu>
Content-Type: text/plain
Date: Thu, 13 May 2010 16:28:53 +0800
Message-Id: <1273739333.30322.119.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-11 at 17:18 +0800, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > The new PMUs will use a dynamic range that starts at PERF_TYPE_MAX.
> 
> I dont think we should use a dynamic range of event sources - it's a 
> completely useless indirection that has no meaning to humans.
> 
> As far as machine interfaces go a much cleaner approach would be to allow an 
> open fd to a sysfs file to be passed to sys_perf_event_open() - this would 
> identify the event source. This needs a small extension of the ABI but we 
> could thus get rid of the 'type' enumeration altogether and express _all_ 
> event sources via fds to sysfs files.

I still don't understand this sys_fd -> pmu lookup, would you please
explain it more detail?

struct pmu {
	kobject kobj;
	...
};

What I can imagine is,

1. In userspace, sys_fd =
open("/sys/devices/system/cpu/event_source", ..), then sys_fd is passed
to sys_perf_event_open()

2. In kernel, sys_file = <find the sys file structure with sys_fd>

3. kobject = <retrieve the kobject from sys_file>

4. pmu = container_of(kobject, struct pmu, kobj)

If my understanding is correct, then step 3 above seems strange. It's
not the typical usage of sys file.

Thanks,
Lin Ming

