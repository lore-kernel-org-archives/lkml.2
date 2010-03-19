Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab0CSSXn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 14:23:43 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:41320 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab0CSSXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 14:23:41 -0400
Message-ID: <4BA3C0CF.6070005@oracle.com>
Date: Fri, 19 Mar 2010 11:22:07 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: 2.6.33 GP fault only when built with tracing
References: <4BA2B69D.3000309@oracle.com> <1268956555.758.18.camel@gandalf.stny.rr.com> <20100319005901.GB23020@Krystal>
In-Reply-To: <20100319005901.GB23020@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4BA3C119.0111:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/10 17:59, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
>> On Thu, 2010-03-18 at 16:26 -0700, Randy Dunlap wrote:
>>> I can build/boot 2.6.33 with CONFIG_TRACE/TRACING disabled successfully,
>>> but when I enable lots of tracing config options and then boot with
>>> ftrace=nop on the kernel command line, I see a GP fault when the parport &
>>> parport_pc modules are loading/initializing.
>>
>> Do you see it without adding the "ftrace=nop"? The only thing that
>> should do is expand the ring buffer on boot up.
>>
>>>
>>> It happens in drivers/parport/share.c::parport_register_device(), when that
>>> function calls try_module_get().
>>>
>>> If I comment out the trace_module_get() calls in include/linux/module.h,
>>> the kernel boots with no problems.
>>
>>
>> Interesting. Well, trace_module_get() is a TRACE_EVENT tracepoint. But
>> should be disabled here. It may be something to do with DEFINE_TRACE. 
>>
>> (added Mathieu to Cc since he wrote that code)
> 
> can you try replacing the "local_read(__module_ref_addr(module, cpu))" argument
> with "0" ?

Yes, that boots with no problems.

> Arguments with side-effects are not skipped by the jump over disabled
> instrumentation. This is why we should do that part within the probe declaration
> in the TRACE_EVENT macros.
> 
> But if we find out that the problem really is this argument, then it should be
> fixed, because something would be wrong with it (just moving it to TRACE_EVENT
> is not a proper solution).
> 
> Thanks,
> 
> Mathieu


-- 
~Randy
