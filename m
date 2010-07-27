Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab0G0RwV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 13:52:21 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:59451 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947Ab0G0RwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 13:52:19 -0400
Message-ID: <4C4F1CBB.7040003@linux.vnet.ibm.com>
Date: Tue, 27 Jul 2010 10:51:55 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
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
Subject: Re: [RFC][PATCH v1 02/15] perf: export generic hardware events via
 sysfs
References: <1279797142.20942.83.camel@minggr.sh.intel.com> <20100723104412.GA26154@erda.amd.com> <1280197103.24607.61.camel@minggr.sh.intel.com> <20100727082749.GK26154@erda.amd.com>
In-Reply-To: <20100727082749.GK26154@erda.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2010 01:27 AM, Robert Richter wrote:
> On 26.07.10 22:18:23, Lin Ming wrote:
>
>>>> /sys/devices/system/cpu/cpu0/events
>>>> |-- L1-dcache-load-misses
>>>> |   |-- config
>>>> |   `-- type
>
> vs.
>
>>>   |-- L1-dcache-load-misses  ===>  event name
>>>   |   `-- id                 ===>  event id
>
>>> This is very simple and flexible and solves the original problem too.
>>
>> Yeah, this is flexible. I'll think about this closely.
>
> The thing is, if you start introducing the config/type i/f, we will
> stick with it for a long time. I want to avoid this from the
> beginning.
>
> Using an id only would work with your current implementation too, you
> only need to maintain an id ->  config/type mapping, maybe in some
> private data section, without exporting it to userspace.

Now that I understand that the sysfs id essentially points to a kernel 
data structure, I like this idea a lot.  Before I was thinking that you 
were trying to place a lot of info into the id itself.

The only downside I see, and maybe it's a very minor one, is that you'll 
no longer have the ability to specify an event without specifying a 
sysfs path... there's no other mechanism.

- Corey

