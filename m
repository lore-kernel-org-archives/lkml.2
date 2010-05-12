Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab0ELFwB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 01:52:01 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:55970 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab0ELFv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 01:51:59 -0400
Date: Wed, 12 May 2010 14:51:12 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <carll@us.ibm.com>, "greg@kroah.com" <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [RFC][PATCH 3/9] perf: export registerred pmus via sysfs
Message-ID: <20100512055112.GA4691@linux-sh.org>
References: <20100510115344.GA11238@elte.hu> <4BE8931C.9070106@linux.vnet.ibm.com> <1273560419.5605.3426.camel@twins> <20100511072127.GB10421@elte.hu> <1273566031.30322.31.camel@minggr.sh.intel.com> <1273567815.5605.3491.camel@twins> <1273568620.30322.42.camel@minggr.sh.intel.com> <1273569154.5605.3499.camel@twins> <1273570845.30322.59.camel@minggr.sh.intel.com> <1273571322.5605.3523.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273571322.5605.3523.camel@twins>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 11:48:42AM +0200, Peter Zijlstra wrote:
> On Tue, 2010-05-11 at 17:40 +0800, Lin Ming wrote:
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
This is something I've been thinking about, too. On SH we have a
large set of perf counter events that are entirely dependent on the
configuration of the CPU they're on, with no requirement that these
configurations are identical on all CPUs in an SMP configuration.

As an example, it's possible to halve the L1 dcache and use that part of
it as a small and fast memory which has completely different events
associated with it from the regular L1 dcache events. These events would
be invalid on a CPU that was running with all cache ways enabled but
might also be valid on other CPUs that bolt these events to an extra SRAM
outside of the cache topology completely.

In any event, the events are at least consistent across all CPUs, it's
only which ones are valid on a given CPU at a given time that can change.
