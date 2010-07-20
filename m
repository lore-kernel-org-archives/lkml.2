Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262Ab0GTRuW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 13:50:22 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:41709 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab0GTRuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 13:50:21 -0400
Message-ID: <4C45E1C9.6010402@linux.vnet.ibm.com>
Date: Tue, 20 Jul 2010 10:50:01 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
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
Subject: Re: [rfc] Describe events in a structured way via sysfs
References: <20100624093625.GA26931@elte.hu> <1277396053.3870.16.camel@jlt3.sipsolutions.net> <20100624173315.GA30403@elte.hu> <1277792114.5400.5.camel@minggr.sh.intel.com> <20100629085532.GE22344@elte.hu> <1277803248.5400.16.camel@minggr.sh.intel.com> <20100629102656.GA25512@elte.hu> <1278057996.3841.26.camel@minggr.sh.intel.com> <4C40F750.4000607@linux.vnet.ibm.com> <1279604908.23815.21.camel@minggr.sh.intel.com> <20100720151920.GC21909@erda.amd.com>
In-Reply-To: <20100720151920.GC21909@erda.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2010 08:19 AM, Robert Richter wrote:
> On 20.07.10 01:48:28, Lin Ming wrote:
>   The caller reads config and type and pass them into perf_event_attr.
>>
>> 1. Hardware events
>> /sys/devices/system/cpu/cpu0...cpuN/events
>> |-- L1-dcache-load-misses  ===>  event name
>> |   |-- config             ===>  config value for the event
>> |   `-- type               ===>  event type
>
> Wouldn't it be much easier to have a unique sysfs id (could be an
> u64):
>
>> |-- L1-dcache-load-misses  ===>  event name
>> |   `-- id                 ===>  event id
>
> ... and then extend the syscall to enable an event by its sysfs id:
>
>              memset(&attr, 0, sizeof(attr));
>              attr.type        = PERF_TYPE_SYSFS;
>              attr.sysfs_id    = sysfs_id;
>              attr.sample_type = PERF_SAMPLE_CPU | PERF_SAMPLE_RAW;
>              attr.config      = config;
> 	    ...
>
> The kerrnel then knows which event is meant and the don't have to
> provide event specific paramaters such as type/config that requires an
> event specific setup. The advantage would be that we can open an event
> file descriptor of every kind of event in a standardized way.

Your example above still shows the .config member being set.  Was that 
intentional?

Maybe another way to accomplish this would be to reuse the .config field 
for the sysfs_id.

We still need a way to deal with event attributes though, so something 
more than a single sysfs_id would be needed to specify the event completely.

- Corey
