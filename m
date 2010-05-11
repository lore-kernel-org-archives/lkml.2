Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452Ab0EKJxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 05:53:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:9240 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757807Ab0EKJxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 05:53:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,206,1272870000"; 
   d="scan'208";a="516889028"
Subject: Re: [RFC][PATCH 3/9] perf: export registerred pmus via sysfs
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
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
       Carl Love <carll@us.ibm.com>, "greg@kroah.com" <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>
In-Reply-To: <1273571322.5605.3523.camel@twins>
References: <1273484401.5605.3333.camel@twins>
	 <1273486313.15998.76.camel@minggr.sh.intel.com>
	 <1273486708.5605.3342.camel@twins>
	 <1273487195.15998.85.camel@minggr.sh.intel.com>
	 <1273490824.5605.3379.camel@twins> <20100510114311.GA6449@elte.hu>
	 <1273492164.5605.3397.camel@twins> <20100510115344.GA11238@elte.hu>
	 <4BE8931C.9070106@linux.vnet.ibm.com> <1273560419.5605.3426.camel@twins>
	 <20100511072127.GB10421@elte.hu>
	 <1273566031.30322.31.camel@minggr.sh.intel.com>
	 <1273567815.5605.3491.camel@twins>
	 <1273568620.30322.42.camel@minggr.sh.intel.com>
	 <1273569154.5605.3499.camel@twins>
	 <1273570845.30322.59.camel@minggr.sh.intel.com>
	 <1273571322.5605.3523.camel@twins>
Content-Type: text/plain
Date: Tue, 11 May 2010 17:53:02 +0800
Message-Id: <1273571582.30322.60.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-11 at 17:48 +0800, Peter Zijlstra wrote:
> On Tue, 2010-05-11 at 17:40 +0800, Lin Ming wrote:
> > /sys/devices/system/cpu/cpu0/cpu_hw_events/*
> > /sys/devices/system/cpu/cpu0/cpu_hw_cache_events/*
> > /sys/devices/system/cpu/cpu0/cpu_raw_events/*
> > ....
> > ....
> > /sys/devices/system/cpu/cpuN/cpu_hw_events/*
> > /sys/devices/system/cpu/cpuN/cpu_hw_cache_events/*
> > /sys/devices/system/cpu/cpuN/cpu_raw_events/*
> > 
> > Is /sys/class/event_sources/* looks like,
> > 
> > /sys/class/event_sources/cpu_hw_events0
> > -> /sys/devices/system/cpu/cpu0/cpu_hw_events
> > ...
> > /sys/class/event_sources/cpu_hw_eventsN
> > -> /sys/devices/system/cpu/cpuN/cpu_hw_events
> > 
> > /sys/class/event_sources/cpu_hw_cache_events0
> > -> /sys/devices/system/cpu/cpu0/cpu_hw_events
> > ...
> > /sys/class/event_sources/cpu_hw_cache_eventsN
> > -> /sys/devices/system/cpu/cpuN/cpu_hw_events
> 
> Hmm, good question.
> 
> No all the cpus would have the same event sources. I'm not sure if we
> can make sysfs understand that though (added GregKH and Kay to CC).
> 
> Possibly we'd have to place them at the cpu level, like:
> 
>  /sys/devices/system/cpu/cpu_*_events/
> 
> and have links like:
> 
>  /sys/devices/system/cpu/cpuN/cpu_*_events ->
>     /sys/devices/system/cpu/cpu_*_events/
> 
> as well as
> 
>  /sys/class/event_sources/cpu_*_events ->
>     /sys/devices/system/cpu/cpu_*_events/

Ah, I like this idea.

Thanks.

