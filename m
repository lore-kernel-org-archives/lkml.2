Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759537Ab0GQAUj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 20:20:39 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:35687 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229Ab0GQAUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 20:20:38 -0400
Message-ID: <4C40F750.4000607@linux.vnet.ibm.com>
Date: Fri, 16 Jul 2010 17:20:32 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Lin Ming <ming.m.lin@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Johannes Berg <johannes@sipsolutions.net>,
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
References: <1277187920.4467.3.camel@minggr.sh.intel.com> <1277189971.3637.5.camel@jlt3.sipsolutions.net> <1277191359.5025.4.camel@minggr.sh.intel.com> <1277192007.3637.8.camel@jlt3.sipsolutions.net> <20100624093625.GA26931@elte.hu> <1277396053.3870.16.camel@jlt3.sipsolutions.net> <20100624173315.GA30403@elte.hu> <1277792114.5400.5.camel@minggr.sh.intel.com> <20100629085532.GE22344@elte.hu> <1277803248.5400.16.camel@minggr.sh.intel.com> <20100629102656.GA25512@elte.hu> <1278057996.3841.26.camel@minggr.sh.intel.com>
In-Reply-To: <1278057996.3841.26.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2010 01:06 AM, Lin Ming wrote:
> On Tue, 2010-06-29 at 18:26 +0800, Ingo Molnar wrote:
>> * Lin Ming<ming.m.lin@intel.com>  wrote:
>>
>>>> Also, we can (optionally) consider 'generic', subsystem level events to
>>>> also show up under:
>>>>
>>>>     /sys/bus/pci/drivers/i915/events/
>>>>
>>>> This would give a model to non-device-specific events to be listed one
>>>> level higher in the sysfs hierarchy.
>>>>
>>>> This too would be done in the driver, not by generic code. It's generally
>>>> the driver which knows how the events should be categorized.
>>>
>>> This is a bit difficult. I'd like not to touch TRACE_EVENT(). [...]
>>
>> We can certainly start with the simpler variant - it's also the more common
>> case.
>>
>>> [...] How does the driver know if an event is 'generic' if TRACE_EVENT is
>>> not touched?
>>
>> Well, it's per driver code which creates the 'events' directory anyway, so
>> that code decides where to link things. It can link it to the per driver kobj
>> - or to the per subsys kobj.
>>
>>>> I'd imagine something similar for wireless drivers as well - most
>>>> currently defined events would show up on a per device basis there.
>>>>
>>>> Can you see practical problems with this scheme?
>>>
>>> Not now. I may find some problems when write more detail code.
>>
>> Ok. Feel free to post RFC patches (even if they are not fully complete yet),
>> so that we can see how things are progressing.
>>
>> I suspect the best approach would be to try to figure out the right sysfs
>> placement for one or two existing driver tracepoints, so that we can see it
>> all in practice. (Obviously any changes to drivers will have to go via the
>> relevant driver maintainer tree(s).)
>
> Well, take i915 tracepoints as an example, the sys structures as below
>
> /sys/class/drm/card0/events/
> |-- i915_gem_object_bind
> |   |-- enable
> |   |-- filter
> |   |-- format
> |   `-- id
...

Hi Lin,

Sorry for my late reply on this thread.  I had missed these posts 
earlier because I had an email filter that was set to look for messages 
with "perf" in the subject, and so I missed this entire thread.

With your example here, let's say I want to open this event with the 
perf_events ABI... how would I go about doing that?  Have you figured 
out whether the caller would read the id and pass that into the 
interface, or perhaps pass in the fd of the id file (or perhaps the fd 
of the specific event directory).

Also, I see the filter and format fields here.  Would the caller write 
to these fields to set them up?  What's the format of the data that's 
written to them?  Would it be totally device dependent?  It seems like 
there should be a way for a user space tool to discover what can be 
programmed into the filter and format fields.

- Corey
