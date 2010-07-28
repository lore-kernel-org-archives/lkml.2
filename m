Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab0G1KCg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 06:02:36 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:4108 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754507Ab0G1KCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 06:02:34 -0400
X-SpamScore: -17
X-BigFish: VPS-17(z1039oz1432N98dN936eM9371Pzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L69IJR-02-1KD-02
X-M-MSG: 
Date: Wed, 28 Jul 2010 12:02:17 +0200
From: Robert Richter <robert.richter@amd.com>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
CC: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Johannes Berg <johannes@sipsolutions.net>,
        Peter Zijlstra <peterz@infradead.org>, Greg KH <greg@kroah.com>,
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
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC][PATCH v1 02/15] perf: export generic hardware events via
 sysfs
Message-ID: <20100728100217.GN26154@erda.amd.com>
References: <1279797142.20942.83.camel@minggr.sh.intel.com>
 <20100723104412.GA26154@erda.amd.com>
 <1280197103.24607.61.camel@minggr.sh.intel.com>
 <20100727082749.GK26154@erda.amd.com>
 <4C4F1CBB.7040003@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4C4F1CBB.7040003@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.07.10 13:51:55, Corey Ashford wrote:
> On 07/27/2010 01:27 AM, Robert Richter wrote:
> > On 26.07.10 22:18:23, Lin Ming wrote:
> >
> >>>> /sys/devices/system/cpu/cpu0/events
> >>>> |-- L1-dcache-load-misses
> >>>> |   |-- config
> >>>> |   `-- type
> >
> > vs.
> >
> >>>   |-- L1-dcache-load-misses  ===>  event name
> >>>   |   `-- id                 ===>  event id
> >
> >>> This is very simple and flexible and solves the original problem too.
> >>
> >> Yeah, this is flexible. I'll think about this closely.
> >
> > The thing is, if you start introducing the config/type i/f, we will
> > stick with it for a long time. I want to avoid this from the
> > beginning.
> >
> > Using an id only would work with your current implementation too, you
> > only need to maintain an id ->  config/type mapping, maybe in some
> > private data section, without exporting it to userspace.
> 
> Now that I understand that the sysfs id essentially points to a kernel 
> data structure, I like this idea a lot.  Before I was thinking that you 
> were trying to place a lot of info into the id itself.
> 
> The only downside I see, and maybe it's a very minor one, is that you'll 
> no longer have the ability to specify an event without specifying a 
> sysfs path... there's no other mechanism.

Right, the id is generated dynamically, it could be an incremented u64
value, a pointer to a kernel structure or something else. Its
implementation could even change from kernel to kernel without
breaking the i/f.

Note also, that you will still be able to setup current events using
the traditional way of filling in the syscall structure. Nothing will
change for this.

But yes, a new event could only support a sysfs id setup. And then,
you need sysfs. But you could also implement a non-sysfs setup in
addition.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

