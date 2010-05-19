Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594Ab0ESFBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 01:01:38 -0400
Received: from kroah.org ([198.145.64.141]:49220 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341Ab0ESFBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 01:01:37 -0400
Date: Tue, 18 May 2010 22:00:42 -0700
From: Greg KH <greg@kroah.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <carll@us.ibm.com>, Kay Sievers <kay.sievers@vrfy.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH v2 06/11] perf: core, export pmus via sysfs
Message-ID: <20100519050042.GA16022@kroah.com>
References: <1274233602.3036.84.camel@localhost>
 <20100518200524.GA20223@kroah.com>
 <1274236496.3603.22.camel@minggr.sh.intel.com>
 <20100519024823.GA25229@kroah.com>
 <1274240429.3603.76.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274240429.3603.76.camel@minggr.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 11:40:29AM +0800, Lin Ming wrote:
> On Wed, 2010-05-19 at 10:48 +0800, Greg KH wrote:
> > On Wed, May 19, 2010 at 10:34:55AM +0800, Lin Ming wrote:
> > > /sys/devices/system/cpu/events/
> > > |-- L1-dcache-load-misses
> > > |   |-- event_source -> ../../event_source
> > > 
> > > For above example, "event_source" is the cpu pmu and the "event" is
> > > L1-dcache-load-misses.
> > > 
> > > Yes, they point to the same thing, because all the events
> > > under /sys/devices/system/cpu/events/* is monitored by the same event
> > > source, ie, the cpu pmu(/sys/devices/system/cpu/event_source/).
> > 
> > Then, why have a symlink if they are all going to be the same?
> 
> So how about move the symlink to parent directory, like
> 
> /sys/devices/system/cpu/event_source/
> 
> /sys/devices/system/cpu/events/
> |-- event_source -> ../event_source

Again, why would that make any sense?  You would be creating a symlink
to something that is always the same symlink.  Why would that even be
needed?

> > > > I'm still not really understanding what exactly you are trying to show
> > > > in the sysfs tree here anyway, perhaps the documentation update will
> > > > clear that up for me.
> > > 
> > > To support multiple pmus
> > 
> > What is a "pmu"?
> 
> Performance Monitoring Unit

What is a "unit"?

> > > (or call them event source),
> > 
> > What is an "event source"?
> 
> The source who generates the event.

The traditional way to define a word, or phrase, is to not use the word
or phrase in the definition, otherwise that definition makes no sense.

> The event includes hardware events, cache-misses, bus-cycles,
> interrupts, error conditions, hotplug......
> and software events, context-switches, page-faults, sched events......

So, stuff that happens to a CPU that are usually handled in the
performance counters portion of the CPU, right?

Why put this in sysfs?  Why do you think that mapping this information
there makes sense?

> > > I want to show all
> > > the pmus and events in the sysfs tree.
> > 
> > Why do these things need to be in sysfs?  What benifit is it going to
> > have?
> 
> Kernel to provide the information of the event source and
> hardware/software events via sysfs and user-space can get
> this info from sysfs.

But that's not what you were doing with your "open a sysfs file from
within the kernel and use the kobject there" logic, right?  You were
doing everything within the kernel itself, so sysfs, and kobjects and
the like, aren't really needed at all, right?

How are you exporting this information to userspace today?

> > > For mce,
> > > /sys/kernel/events/mce/*
> > 
> > What?  No, don't create /sys/kernel/events/.  Is that in this patchset?
> 
> No, not in this patchset.

Good :)

> > Ick, that's such a "general" name that it is going to get confusing very
> > quickly.  Heck, I still don't know what this "event" thing is yet :)
> > 
> > > and so on...the exact placement is not yet final.
> > 
> > Again, why do you need/want anything in sysfs in the first place?
> > What problem is it going to solve?  Who is going to benifit?  Why do
> > they care?  What is this whole thing about?

You forgot to answer these questions...

thanks,

greg k-h
