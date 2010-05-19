Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab0ESCfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 22:35:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:13916 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753102Ab0ESCfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 22:35:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,259,1272870000"; 
   d="scan'208";a="519186627"
Subject: Re: [RFC][PATCH v2 06/11] perf: core, export pmus via sysfs
From: Lin Ming <ming.m.lin@intel.com>
To: Greg KH <greg@kroah.com>
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
In-Reply-To: <20100518200524.GA20223@kroah.com>
References: <1274233602.3036.84.camel@localhost>
	 <20100518200524.GA20223@kroah.com>
Content-Type: text/plain
Date: Wed, 19 May 2010 10:34:55 +0800
Message-Id: <1274236496.3603.22.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-19 at 04:05 +0800, Greg KH wrote:
> On Wed, May 19, 2010 at 01:46:42AM +0000, Lin Ming wrote:
> > Now only exports cpu hardware events.
> > 
> > For each PMU, there are 2 sysfs dirs: event_source and events.
> > 
> > For example,
> > /sys/devices/system/cpu/event_source/
> > /sys/devices/system/cpu/events/
> > 
> > $ tree /sys/devices/system/cpu/event_source/
> > /sys/devices/system/cpu/event_source/
> > `-- id
> > 
> > $ tree /sys/devices/system/cpu/events/
> > /sys/devices/system/cpu/events/
> > |-- L1-dcache-load-misses
> > |   |-- event_source -> ../../event_source
> 
> What is this symlink for?  Is it needed as they all seem to point to the
> same thing.

The symlink is used to find the "event_source" of the "event".

/sys/devices/system/cpu/event_source/

/sys/devices/system/cpu/events/
|-- L1-dcache-load-misses
|   |-- event_source -> ../../event_source

For above example, "event_source" is the cpu pmu and the "event" is
L1-dcache-load-misses.

Yes, they point to the same thing, because all the events
under /sys/devices/system/cpu/events/* is monitored by the same event
source, ie, the cpu pmu(/sys/devices/system/cpu/event_source/).

> 
> Also, as you are trying to add new sysfs interfaces, please document
> them in Documentation/ABI.

Will add the document.

> 
> And, do you have to use "raw" kobjects here?  Any chance you can use a
> struct device instead?

Let me think about this.

> 
> I'm still not really understanding what exactly you are trying to show
> in the sysfs tree here anyway, perhaps the documentation update will
> clear that up for me.

To support multiple pmus(or call them event source), I want to show all
the pmus and events in the sysfs tree.

For cpu pmu,
/sys/devices/system/cpu/event_source/*
/sys/devices/system/cpu/events/*

For node pmu,
/sys/devices/system/node/event_source/*
/sys/devices/system/node/events/*

For mce,
/sys/kernel/events/mce/*

and so on...the exact placement is not yet final.

Thanks,
Lin Ming

> 
> thanks,
> 
> greg k-h

