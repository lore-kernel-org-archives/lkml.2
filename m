Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab1GZBGR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 21:06:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:35610 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169Ab1GZBGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 21:06:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,265,1309762800"; 
   d="scan'208";a="30031300"
Subject: Re: [PATCH v2 1/6] perf: Add interface to add general events to
 sysfs
From: Lin Ming <ming.m.lin@intel.com>
To: Greg KH <gregkh@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>
In-Reply-To: <20110725152038.GA23356@suse.de>
References: <1310740503-15608-1-git-send-email-ming.m.lin@intel.com>
	 <1310740503-15608-2-git-send-email-ming.m.lin@intel.com>
	 <1310996068.13765.67.camel@twins>
	 <1311581475.3938.1477.camel@minggr.sh.intel.com>
	 <1311582723.2617.50.camel@laptop>  <20110725152038.GA23356@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Jul 2011 09:06:07 +0800
Message-ID: <1311642367.3938.1516.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-25 at 23:20 +0800, Greg KH wrote:
> On Mon, Jul 25, 2011 at 10:32:03AM +0200, Peter Zijlstra wrote:
> > On Mon, 2011-07-25 at 16:11 +0800, Lin Ming wrote:
> > > It's strange that I didn't find a way to check if a directory is present
> > > in sysfs. Any hint?
> > 
> > sysfs is voodoo for me, best I can come up with is, ask the sysfs
> > folks ;-)
> > 
> > Kay, Greg?
> 
> What are you trying to do here specifically?

Now there are perf event source devices in sysfs.

$ tree /sys/bus/event_source/devices/
/sys/bus/event_source/devices/
|-- breakpoint
|-- cpu
|-- software
`-- tracepoint

I want to create a "events" directory to hold the most useful events
under the event_source.

$ tree /sys/bus/event_source/devices/cpu
| -- events

Then add one event each time to the "events" dir.

Add "event1"
$ tree /sys/bus/event_source/devices/cpu
| -- events
     | -- event1

Add "event2"
$ tree /sys/bus/event_source/devices/cpu
| -- events
     | -- event1
     | -- event2

So at the first time to add a event I need to check if the "events"
directory is present. If not, create it.

Like below pseudo code,

int perf_pmu_add_event(struct pmu *pmu, const char *name, ....)
{
	if there is no "events" dir under pmu->dev->kobj
		then create "events" dir

	add event "name" to "events"

	return ....
}

So the problem is, for example, how to check if there is a "events" dir
under /sys/bus/event_source/devices/cpu in kernel.

Thanks,
Lin Ming

> 
> sysfs is not ment to be walked from within the kernel, only from
> userspace.  Perhaps that is your problem here?
> 
> greg k-h


