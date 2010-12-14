Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799Ab0LNMe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 07:34:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:47938 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757562Ab0LNMe0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 07:34:26 -0500
Subject: Re: [RFC PATCH 3/3 v3] perf: Update perf tool to monitor uncore
 events
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, Carl Love <cel@linux.ibm.com>
In-Reply-To: <1292292908.10384.137.camel@minggr.sh.intel.com>
References: <1291267238.2405.315.camel@minggr.sh.intel.com>
	 <4D06C846.4030804@linux.vnet.ibm.com>
	 <1292292908.10384.137.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 14 Dec 2010 13:33:27 +0100
Message-ID: <1292330007.6803.1629.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-14 at 10:15 +0800, Lin Ming wrote:

> > First of all, "uncore" is an x86-specific term and so it's not clear to 
> > me if you meant for all arches to utilize this encoding for all "not 
> > core but on the same die" events (IBM Power arch refers to this as 
> > "nest" logic).

I don't think the x86 uncore matches the "not on core but on the same
die" definition. The x86-uncore thing is more like a memory controller
PMU (and since the memory controller is on die it is of course on die,
but its not just any random on-die thing).

The wire-speed thing has tons of special purpose 'cores' on die, each of
them having a PMU.

Using the sysfs stuff you could actually expose each individually.

> Yes, they are temporary solution. I use it to easily test uncore
> patches. Sorry I should mention that.
> 
> sysfs is the final solution, but I'm not clear how the sysfs structures
> should be.
> 
> As we discussed before,
> 
> 1. Should we list all events under sysfs?
> 
> /sys/devices/system/cpu/cpuN/events/event0
> ...
> /sys/devices/system/cpu/cpuN/events/eventN
> 
> /sys/devices/system/node/nodeN/pmuN/events/event0
> ...
> /sys/devices/system/node/nodeN/pmuN/events/eventN

I'd not put _all_ events there, maybe a key few. Then again, Corey would
like to make all optional on module load or somesuch.

> 2. Or should we use a sysfs file to pass in raw config value?

That's not mutually exclusive with 1), the way I've implemented it is
that the sysfs event files provide the raw config values needed for that
event.

> /sys/devices/system/cpu/cpuN/raw
> /sys/devices/system/node/nodeN/pmuN/raw?
> 
> 3. How will the additional attributes(needed by IBM PowerEN chip, etc)
> be passed in?

>From what I understood they all still fit in the single u64 config
field.

