Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab0FACgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 22:36:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:56806 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739Ab0FACgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 22:36:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,337,1272870000"; 
   d="scan'208";a="283400949"
Subject: Re: [rfc] Describe events in a structured way via sysfs
From: Lin Ming <ming.m.lin@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, Greg KH <greg@kroah.com>,
       Lin Ming <ming.m.lin@intel.com>,
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
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <AANLkTinJeYJtCg2aRWhHTcf5E2-dN2-oAfEJ8tAtFjb9@mail.gmail.com>
References: <1274233602.3036.84.camel@localhost>
	 <20100518200524.GA20223@kroah.com>
	 <1274236496.3603.22.camel@minggr.sh.intel.com>
	 <20100519024823.GA25229@kroah.com>	<1274253276.5605.10124.camel@twins>
	 <20100520184213.GB21030@kroah.com>	<20100520201418.GB11470@elte.hu>
	 <20100520231229.GB8335@kroah.com>	<1274429038.1674.1684.camel@laptop>
	 <20100521094053.GA4658@elte.hu>
	 <AANLkTinJeYJtCg2aRWhHTcf5E2-dN2-oAfEJ8tAtFjb9@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 01 Jun 2010 10:34:32 +0800
Message-Id: <1275359672.7586.85.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Thu, 2010-05-20 at 16:12 -0700, Greg KH wrote:
> 
> > > How deep in the device tree are you really going to be
> > > caring about?  It sounds like the large majority of
> > > events are only going to be coming from the "system"
> > > type objects (cpu, nodes, memory, etc.) and very few
> > > would be from things that we consider a 'struct
> > > device' today (like a pci, usb, scsi, or input, etc.)
> >
> > The general noise I hear from the hardware people is
> > that we'll see more and more device-level stuff - bus
> > bridges/controller and actual devices (GPUs, NICs etc.)
> > will be wanting to export performance metrics.
> 
> There's (much) more:
> 
>  - laptops want to provide power level/usage metrics,
> 
>  - we could express a lot of special, lower level
>   (transport specific) disk IO stats via events as well -
>   without having to push those stats to a higher level
>   (where it might not make sense). Currently such kinds
>   of stats/metrics are very device/subsystem specific
>   way, if they are provided at all.
> 
> Also, we already have quite a few per device tracepoints
> upstream. Here are a few examples:
> 
>  - GPU tracepoints (trace_i915_gem_request_submit(), etc.)
>  - WIFI tracepoints (trace_iwlwifi_dev_ioread32(), etc.)
>  - block tracepoints (trace_block_bio_complete())
> 
> So these would be attached to:
> 
>  # GEM events of drm/card0:
>  /sys/devices/pci0000:00/0000:00:02.0/drm/card0/events/i915_gem_request_submit/
> 
>  # Wifi-ioread events of wlan0:
>  /sys/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/net/wlan0/events/iwlwifi_dev_ioread32/
> 
>  # whole sdb disk events:
>  /sys/block/sdb/events/block_bio_complete/
> 
>  # sdb1 partition events:
>  /sys/block/sdb/sdb1/events/block_bio_complete/
> 

The difficulty is how to know where each event should be attached to.

struct ftrace_event_call *call;

for_each_event(call, __start_ftrace_events, __stop_ftrace_events) {
	/* where will this event be attached to?  */
}

Any idea?

Thanks,
Lin Ming


