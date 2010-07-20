Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374Ab0GTPTf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 11:19:35 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:8201 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185Ab0GTPTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 11:19:34 -0400
X-SpamScore: -16
X-BigFish: VPS-16(zz1432N98dN936eMzz1202hzzz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L5V3W9-01-64R-02
X-M-MSG: 
Date: Tue, 20 Jul 2010 17:19:20 +0200
From: Robert Richter <robert.richter@amd.com>
To: Lin Ming <ming.m.lin@intel.com>
CC: Corey Ashford <cjashfor@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
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
Subject: Re: [rfc] Describe events in a structured way via sysfs
Message-ID: <20100720151920.GC21909@erda.amd.com>
References: <20100624093625.GA26931@elte.hu>
 <1277396053.3870.16.camel@jlt3.sipsolutions.net>
 <20100624173315.GA30403@elte.hu>
 <1277792114.5400.5.camel@minggr.sh.intel.com>
 <20100629085532.GE22344@elte.hu>
 <1277803248.5400.16.camel@minggr.sh.intel.com>
 <20100629102656.GA25512@elte.hu>
 <1278057996.3841.26.camel@minggr.sh.intel.com>
 <4C40F750.4000607@linux.vnet.ibm.com>
 <1279604908.23815.21.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1279604908.23815.21.camel@minggr.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.07.10 01:48:28, Lin Ming wrote:
 The caller reads config and type and pass them into perf_event_attr.
> 
> 1. Hardware events
> /sys/devices/system/cpu/cpu0...cpuN/events
> |-- L1-dcache-load-misses  ===> event name
> |   |-- config             ===> config value for the event
> |   `-- type               ===> event type

Wouldn't it be much easier to have a unique sysfs id (could be an
u64):

> |-- L1-dcache-load-misses  ===> event name
> |   `-- id                 ===> event id

... and then extend the syscall to enable an event by its sysfs id:

            memset(&attr, 0, sizeof(attr));
            attr.type        = PERF_TYPE_SYSFS;
            attr.sysfs_id    = sysfs_id;
            attr.sample_type = PERF_SAMPLE_CPU | PERF_SAMPLE_RAW;
            attr.config      = config;
	    ...

The kerrnel then knows which event is meant and the don't have to
provide event specific paramaters such as type/config that requires an
event specific setup. The advantage would be that we can open an event
file descriptor of every kind of event in a standardized way.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

