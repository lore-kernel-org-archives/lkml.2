Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab0G0I2G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 04:28:06 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:59138
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753707Ab0G0I2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 04:28:03 -0400
X-SpamScore: -9
X-BigFish: VPS-9(z1039oz1432N98dN936eMzz1202hzzz32i2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L67JID-02-58M-02
X-M-MSG: 
Date: Tue, 27 Jul 2010 10:27:49 +0200
From: Robert Richter <robert.richter@amd.com>
To: Lin Ming <ming.m.lin@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
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
Message-ID: <20100727082749.GK26154@erda.amd.com>
References: <1279797142.20942.83.camel@minggr.sh.intel.com>
 <20100723104412.GA26154@erda.amd.com>
 <1280197103.24607.61.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1280197103.24607.61.camel@minggr.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.07.10 22:18:23, Lin Ming wrote:

> > > /sys/devices/system/cpu/cpu0/events
> > > |-- L1-dcache-load-misses
> > > |   |-- config
> > > |   `-- type

vs.

> >  |-- L1-dcache-load-misses  ===> event name
> >  |   `-- id                 ===> event id

> > This is very simple and flexible and solves the original problem too.
> 
> Yeah, this is flexible. I'll think about this closely.

The thing is, if you start introducing the config/type i/f, we will
stick with it for a long time. I want to avoid this from the
beginning.

Using an id only would work with your current implementation too, you
only need to maintain an id -> config/type mapping, maybe in some
private data section, without exporting it to userspace.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

