Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937203Ab0COXiz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 19:38:55 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:43980 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933017Ab0COXix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 19:38:53 -0400
Message-ID: <4B9EC50E.80702@linux.vnet.ibm.com>
Date: Mon, 15 Mar 2010 16:38:54 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC] [PATCH 1/1] perf: add support for arch-dependent symbolic
 event names to "perf stat"
References: <4B8F1B58.5000702@linux.vnet.ibm.com> <4B8FFE55.5070008@linux.vnet.ibm.com> <20100311124608.GG31354@elte.hu> <4B993AAF.9050507@linux.vnet.ibm.com> <20100311191441.GA7593@elte.hu> <4B99568D.30608@linux.vnet.ibm.com>
In-Reply-To: <4B99568D.30608@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/11/2010 12:46 PM, Corey Ashford wrote:
>
>
> On 3/11/2010 11:14 AM, Ingo Molnar wrote:
>>
>> * Corey Ashford<cjashfor@linux.vnet.ibm.com> wrote:
> [snip]
>>> I'm not sure how that would work. The issue I am trying to solve
>>> here is that Power arch chips have a large number of very
>>> hardware-specific events that are not generalizable. Many of these
>>> events not only have names, but other user-configurable bits as well
>>> that select or narrow the scope of which exact events are recorded.
>>> This issue is dealt with nicely in libpfm4, as it has mechanisms for
>>> parsing event names and attributes (aka modifiers or unit masks),
>>> and then produces a usable config field for the perf_events_attr
>>> struct.
>>>
>>> Should I take it from the above that you are completely against the
>>> idea of using an external library for hardware-specific event and
>>> attribute naming?
>>
>> Could you give a few relevant examples of events in question, and the
>> kind of
>> configurability/attributes they have on Power?
>
> Here are a few examples for the Power A2 processor. I've distorted the
> names because PMU architecture isn't publicly released yet.
>
> PM_DE_PMC_9:hrd_mask=0xff:hrd=0x22:pma_mask=0x3fff:pma=0x1b2d:culling_mode=3
>
> PM_EX_0x03:lane=2:vlane=1
> PM_OWE_ENG_MAC_FULL:usu=3

Just a follow-up note to this...

I learned that the much of the high-level architecture of the new chip that IBM 
is working on has been publicly released recently, so I have "undistorted" the 
event names below:

PM_DC_PMC_9:lpid_mask=0xff:lpid=0x22:pid_mask=0x3fff:pid=0x1b2d:marking_mode=3
PM_REGX_0x03:lane=2:vlane=1
PM_XML_ENG_MAC_FULL:sus=3


DC = Decompression/Compression accelerator
PMC_9 = Peformance monitoring event 9
REGX = Regular eXpression accelerator
XML = XML parsing accelerator
pid = process id to match
pid_mask = process id match mask
lpid = logical partition id
lpid_mask = logical partition id mask
sus = source unit select
lane, vlane = signal routing fields
marking_mode = used to determine which accelerator work units to mark for 
performance monitoring

- Corey

