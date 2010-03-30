Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891Ab0CaAdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:33:47 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:34052 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756259Ab0C3XLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:11:53 -0400
Message-ID: <4BB28537.2060003@linux.vnet.ibm.com>
Date: Tue, 30 Mar 2010 16:11:51 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: eranian@gmail.com
CC: stephane eranian <eranian@googlemail.com>, Lin Ming <ming.m.lin@intel.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Dan Terpstra <terpstra@eecs.utk.edu>, Philip Mucci <mucci@eecs.utk.edu>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [RFC] perf_events: support for uncore a.k.a. nest units
References: <4B560ACD.4040206@linux.vnet.ibm.com> <d3f22a1003290213x7d7904an59d50eb6a8616133@mail.gmail.com> <1269934931.8575.6.camel@minggr.sh.intel.com> <4BB22BB0.8030208@linux.vnet.ibm.com> <u2h7c86c4471003301428v9189ccbesec68ee149dfe9f@mail.gmail.com>
In-Reply-To: <u2h7c86c4471003301428v9189ccbesec68ee149dfe9f@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/30/2010 2:28 PM, stephane eranian wrote:
> On Tue, Mar 30, 2010 at 6:49 PM, Corey Ashford
> <cjashfor@linux.vnet.ibm.com>  wrote:
>> 4) How do we choose a CPU to do the housekeeping work for a particular nest
>> PMU.  Peter thought that user space should still specify the it via
>> open_perf_event() cpu parameter, but there's also an argument to be made for
>> the kernel choosing the best CPU to handle the job, or at least make it
>> optional for the user to choose the CPU.
>>
> One of the housekeeping task is to handle uncore PMU interrupts, for instance.
> That is not a trivial task given that events are managed independently and
> that you could be monitoring per-thread or system-wide. It may be that
> some uncore PMU can only interrupt one core. Intel Nehalem can interrupt
> many at once.

That's a good point, and I think it's unreasonable to expect that the user knows 
exactly how the interrupts are connected from the uncore/nest PMU to which CPU(s).

Perhaps one way around this would be to return an error if the chosen CPU wasn't 
fully capable of performing the housekeeping functions for the requested PMU. 
But this certainly isn't ideal, because relying on this mechanism would require 
that the user (or user tool) figure out which CPU is fully capable by 
trial-and-error.

- Corey

