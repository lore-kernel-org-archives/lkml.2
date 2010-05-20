Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab0ETBde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 21:33:34 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:45012 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab0ETBdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 21:33:33 -0400
Message-ID: <4BF4915B.10104@linux.vnet.ibm.com>
Date: Wed, 19 May 2010 18:33:15 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Lin Ming <ming.m.lin@intel.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
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
       Carl Love <carll@us.ibm.com>, "greg@kroah.com" <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH v2 11/11] perf top: demo of how to use the sysfs
 interface
References: <1274233792.3036.90.camel@localhost> <4BF42B6F.6000009@linux.vnet.ibm.com> <1274318249.3603.135.camel@minggr.sh.intel.com>
In-Reply-To: <1274318249.3603.135.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/19/2010 6:17 PM, Lin Ming wrote:
> On Thu, 2010-05-20 at 02:18 +0800, Corey Ashford wrote:
>>
>> On 5/18/2010 6:49 PM, Lin Ming wrote:
>>> Just a temporary patch to show how to use the pmu sysfs interface...
>>>
>>> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
>>> ---
>>>  tools/perf/builtin-top.c |   13 +++++++++++++
>>>  1 files changed, 13 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
>>> index adc179d..eaa9405 100644
>>> --- a/tools/perf/builtin-top.c
>>> +++ b/tools/perf/builtin-top.c
>>> @@ -1206,6 +1206,7 @@ static void start_counter(int i, int counter)
>>>  	struct perf_event_attr *attr;
>>>  	int cpu;
>>>  	int thread_index;
>>> +	int sys_fd;
>>>
>>>  	cpu = profile_cpu;
>>>  	if (target_tid == -1 && profile_cpu == -1)
>>> @@ -1226,9 +1227,21 @@ static void start_counter(int i, int counter)
>>>
>>>  	for (thread_index = 0; thread_index < thread_num; thread_index++) {
>>>  try_again:
>>> +		/*
>>> +		 * This is just an ugly demo of how to use the sysfs interface.
>>> +		 * You can also parse the <event-name> and open sys file as,
>>> +		 * sys_fd = open("/sys/devices/system/cpu/events/<event-name>/event_source/id", O_RDONLY);
>>> +		 */
>>
>> In this above case, does this sys_fd also specify the event I am going to open, in addition to its event source?  I'd assume not since event_source is a symlink to /sys/devices/system/cpu/event_source (right?)
> 
> Right, this sys_fd only specifies the event source.
> 
>> How do I specify the exact event id via the sysfs interface?
> 
> /sys/devices/system/cpu/events/<event-name>/id
> 
> But in this patch series, the event id sysfs interface is not used yet.

So, I would open that id and then read the id code and place it in attr->config or maybe place
the fd into attr (somewhere) ?

We also need to take into account event "attributes" - other data that is needed to configure a specific event.  For example, think about a memory controller which has a PMU can count events in a particular memory range; we need to be able to supply the memory range somehow, and I don't think that can be accomplished by passing in the fd of a sysfs file that we've opened.

- Corey

