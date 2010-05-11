Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab0EKPvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 11:51:36 -0400
Received: from kroah.org ([198.145.64.141]:55775 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755719Ab0EKPvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 11:51:08 -0400
Date: Tue, 11 May 2010 08:17:47 -0700
From: Greg KH <greg@kroah.com>
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
       Paul Mundt <lethal@linux-sh.org>, lkml <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <carll@us.ibm.com>, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [RFC][PATCH 3/9] perf: export registerred pmus via sysfs
Message-ID: <20100511151747.GA16561@kroah.com>
References: <20100510115344.GA11238@elte.hu>
 <4BE8931C.9070106@linux.vnet.ibm.com>
 <1273560419.5605.3426.camel@twins>
 <20100511072127.GB10421@elte.hu>
 <1273566031.30322.31.camel@minggr.sh.intel.com>
 <1273567815.5605.3491.camel@twins>
 <1273568620.30322.42.camel@minggr.sh.intel.com>
 <1273569154.5605.3499.camel@twins>
 <1273570845.30322.59.camel@minggr.sh.intel.com>
 <1273571322.5605.3523.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273571322.5605.3523.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 11:48:42AM +0200, Peter Zijlstra wrote:
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

The problem with this is /sys/devices/system/ are the horrid sysdev
structures, which don't play nice (or at all) with the rest of the
driver/device model.

If we fix them up to finally work properly like real devices then we
could do this:

> and have links like:
> 
>  /sys/devices/system/cpu/cpuN/cpu_*_events ->
>     /sys/devices/system/cpu/cpu_*_events/
> 
> as well as
> 
>  /sys/class/event_sources/cpu_*_events ->
>     /sys/devices/system/cpu/cpu_*_events/

Like you want to have done.

{sigh}

I guess I'll finally have to start working on this.  I had some
conversations at the last Collab Summit with someone on how to properly
fix this all up, I'll go dig for that note and start in on it.

thanks,

greg k-h
