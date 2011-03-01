Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab1CAPlo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 10:41:44 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:16002 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756436Ab1CAPln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 10:41:43 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAOOhbE2rRN+K/2dsb2JhbACEKKIkdKANiwWRL4Eng0R2BIUShw2DQA
X-IronPort-AV: E=Sophos;i="4.62,247,1297036800"; 
   d="scan'208";a="664944271"
Message-ID: <4D6D13C6.5020807@cisco.com>
Date: Tue, 01 Mar 2011 08:41:58 -0700
From: David Ahern <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, mingo@elte.hu, fweisbec@gmail.com,
        paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH 3/6] perf record: add time-of-day option
References: <1298865151-23656-1-git-send-email-daahern@cisco.com>	 <1298865151-23656-4-git-send-email-daahern@cisco.com>	 <1298989751.5226.863.camel@laptop>  <4D6D0438.2090901@cisco.com> <1298993714.5226.871.camel@laptop>
In-Reply-To: <1298993714.5226.871.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/01/2011 08:35 AM, Peter Zijlstra wrote:
> On Tue, 2011-03-01 at 07:35 -0700, David Ahern wrote:
>>
>> On 03/01/2011 07:29 AM, Peter Zijlstra wrote:
>>
>>>> +/* add a sample to the event stream based on user request */
>>>> +static int perf_event_generate_sample(struct perf_event *event)
>>>> +{
>>>> +       struct perf_sample_data data;
>>>> +       struct pt_regs regs;
>>>> +
>>>> +       perf_fetch_caller_regs(&regs);
>>>> +       event->pmu->read(event);
>>>> +       perf_sample_data_init(&data, 0);
>>>> +       data.period = event->hw.last_period;
>>>> +       perf_event_output(event, 0, &data, &regs);
>>>> +
>>>> +       return 0;
>>>> +}
>>>
>>> I'm not quite sure why you need this.. 
>>>
>>
>> periodic samples are generated after the specified period. I want the
>> first sample immediately and the remainder based on the set period.
>>
>> So generically, how do you get the first sample into the event stream
>> and let the others happen based on the timer? I need not only the
>> counter value but also the perf_clock timestamp that comes from the
>> SAMPLE_TIME attribute.
> 
> Again, why?
> 

realtime-clock counter is created with a period N. How do you correlate
perf_clock to time-of-day until now + N? You need a sample from the
beginning of the event stream, not N nanoseconds into it.

David
